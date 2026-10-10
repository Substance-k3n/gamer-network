import {
  applyDecorators,
  type CallHandler,
  type ExecutionContext,
  HttpStatus,
  Inject,
  Injectable,
  type NestInterceptor,
  UseInterceptors,
} from '@nestjs/common';
import { ApiHeader } from '@nestjs/swagger';
import { and, eq, isNull, lt, or, sql } from 'drizzle-orm';
import { createHash } from 'node:crypto';
import { catchError, from, mergeMap, type Observable, of } from 'rxjs';
import type { AuthedRequest } from '../auth/auth.decorators.js';
import { AppError } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { idempotencyKeys } from '../db/schema/index.js';

export const KEEP_KEYS_HOURS = 24;
/** A first request that hasn't finished after this is taken as crashed; a retry may run again. */
const STALE_AFTER = sql`interval '1 minute'`;
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * docs/API.md "Idempotency": with `Idempotency-Key: <uuid>`, a retry of
 * the same request returns the first answer instead of creating a
 * duplicate. Only successes are kept; after an error the key is free.
 */
@Injectable()
export class IdempotencyInterceptor implements NestInterceptor {
  constructor(@Inject(DB) private readonly db: Db) {}

  async intercept(ctx: ExecutionContext, next: CallHandler): Promise<Observable<unknown>> {
    const req = ctx.switchToHttp().getRequest<AuthedRequest>();
    const key = req.header('idempotency-key');
    if (key === undefined) return next.handle();
    if (!UUID.test(key)) {
      throw new AppError(
        HttpStatus.BAD_REQUEST,
        'bad_idempotency_key',
        'Idempotency-Key must be a UUID.',
      );
    }

    const userId = req.user.id;
    const requestHash = createHash('sha256')
      .update(`${req.method} ${req.originalUrl}\n${JSON.stringify(req.body ?? null)}`)
      .digest('base64url');
    const row = and(eq(idempotencyKeys.userId, userId), eq(idempotencyKeys.key, key));

    // Take the key, or take it back when it's old or its first request died.
    const [claimed] = await this.db
      .insert(idempotencyKeys)
      .values({ userId, key, requestHash })
      .onConflictDoUpdate({
        target: [idempotencyKeys.userId, idempotencyKeys.key],
        set: { requestHash, response: null, completedAt: null, createdAt: sql`now()` },
        setWhere: or(
          lt(idempotencyKeys.createdAt, sql`now() - make_interval(hours => ${KEEP_KEYS_HOURS})`),
          and(
            isNull(idempotencyKeys.completedAt),
            lt(idempotencyKeys.createdAt, sql`now() - ${STALE_AFTER}`),
          ),
        ),
      })
      .returning({ key: idempotencyKeys.key });

    if (!claimed) {
      const first = await this.db.query.idempotencyKeys.findFirst({ where: row });
      if (first && first.requestHash !== requestHash) {
        throw new AppError(
          HttpStatus.UNPROCESSABLE_ENTITY,
          'idempotency_key_reused',
          'That Idempotency-Key was used for a different request.',
        );
      }
      if (!first?.completedAt) {
        throw new AppError(
          HttpStatus.CONFLICT,
          'idempotency_in_progress',
          'That request is still being handled. Try again in a moment.',
        );
      }
      return of(first.response === null ? undefined : JSON.parse(first.response));
    }

    return next.handle().pipe(
      mergeMap(async (body: unknown) => {
        await this.db
          .update(idempotencyKeys)
          .set({
            response: body === undefined ? null : JSON.stringify(body),
            completedAt: new Date(),
          })
          .where(row);
        return body;
      }),
      catchError((e: unknown) =>
        from(
          this.db
            .delete(idempotencyKeys)
            .where(row)
            .then(() => {
              throw e;
            }),
        ),
      ),
    );
  }
}

/** For POSTs that create something. */
export const Idempotent = () =>
  applyDecorators(
    UseInterceptors(IdempotencyInterceptor),
    ApiHeader({
      name: 'Idempotency-Key',
      required: false,
      description: 'A UUID per create. A retry with the same key returns the first answer.',
      schema: { type: 'string', format: 'uuid' },
    }),
  );
