import { Injectable } from '@nestjs/common';
import { lt } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { idempotencyKeys } from '../db/schema/index.js';
import type { Job } from '../jobs/jobs.js';
import { KEEP_KEYS_HOURS } from './idempotency.js';

/** Forgets idempotency keys after 24 hours. */
@Injectable()
export class IdempotencyKeysJob implements Job {
  readonly name = 'idempotency-keys';
  readonly everyMs = 60 * 60 * 1000;

  async run(tx: Tx, now: Date): Promise<void> {
    await tx
      .delete(idempotencyKeys)
      .where(lt(idempotencyKeys.createdAt, new Date(now.getTime() - KEEP_KEYS_HOURS * 3600_000)));
  }
}
