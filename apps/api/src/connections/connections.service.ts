import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gt, inArray, or, type SQL, sql } from 'drizzle-orm';
import { AppError, notFound } from '../common/app-error.js';
import { uniqueViolation } from '../common/db-errors.js';
import type { User } from '../auth/sessions.service.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { checkIns, connectionRequests, connections, listings, users } from '../db/schema/index.js';
import { ListingsService } from '../listings/listings.service.js';
import { ProfileService } from '../me/profile.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { listingCheckInDueAt } from '../play/play-times.js';
import { isLive, visibleTo } from '../users/visibility.js';
import type {
  AcceptedRequestDto,
  ConnectionDto,
  ConnectionPageDto,
  ConnectionRequestDto,
  SendRequestBody,
} from './connections.dto.js';

export const DAILY_REQUEST_LIMIT = 30;
export const REREQUEST_AFTER_DAYS = 7;
const DAY_MS = 24 * 60 * 60 * 1000;

type RequestRow = typeof connectionRequests.$inferSelect;

/** connections stores each pair once, lower id first (uuid order = hex string order). */
export const orderedPair = (x: string, y: string): [string, string] => (x < y ? [x, y] : [y, x]);

/** The connected pair's row, if any. */
const pairIs = (x: string, y: string) => {
  const [a, b] = orderedPair(x, y);
  return and(eq(connections.userAId, a), eq(connections.userBId, b));
};

const conflict = (code: string, message: string, fields?: Record<string, string>) =>
  new AppError(HttpStatus.CONFLICT, code, message, fields);

@Injectable()
export class ConnectionsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
    private readonly listingsService: ListingsService,
    private readonly notifier: NotificationsService,
  ) {}

  private async build(rows: RequestRow[], viewerId: string): Promise<ConnectionRequestDto[]> {
    if (rows.length === 0) return [];
    const ids = [...new Set(rows.flatMap((r) => [r.fromUserId, r.toUserId]))];
    const [people, listingById] = await Promise.all([
      this.db.select().from(users).where(inArray(users.id, ids)),
      this.listingsService.byIds(
        rows.flatMap((r) => (r.listingId ? [r.listingId] : [])),
        viewerId,
      ),
    ]);
    const cards = new Map((await this.profiles.cards(people)).map((c) => [c.id, c] as const));
    return rows.map((r) => ({
      id: r.id,
      from: cards.get(r.fromUserId)!,
      to: cards.get(r.toUserId)!,
      listing: (r.listingId && listingById.get(r.listingId)) || null,
      message: r.message,
      status: r.status,
      createdAt: r.createdAt,
    }));
  }

  async send(from: User, body: SendRequestBody): Promise<ConnectionRequestDto> {
    if (body.toUserId === from.id) {
      throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', "That's you.", {
        toUserId: "You can't connect with yourself",
      });
    }
    const to = await this.db.query.users.findFirst({
      where: and(eq(users.id, body.toUserId), visibleTo(this.db, from.id)),
    });
    if (!to) throw notFound('That player');

    const now = new Date();
    const [connected, theirs, lastDeclined, [today]] = await Promise.all([
      this.db.query.connections.findFirst({ where: pairIs(from.id, to.id) }),
      this.db.query.connectionRequests.findFirst({
        where: and(
          eq(connectionRequests.fromUserId, to.id),
          eq(connectionRequests.toUserId, from.id),
          eq(connectionRequests.status, 'pending'),
        ),
      }),
      this.db.query.connectionRequests.findFirst({
        where: and(
          eq(connectionRequests.fromUserId, from.id),
          eq(connectionRequests.toUserId, to.id),
          eq(connectionRequests.status, 'declined'),
          gt(
            connectionRequests.respondedAt,
            new Date(now.getTime() - REREQUEST_AFTER_DAYS * DAY_MS),
          ),
        ),
      }),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(connectionRequests)
        .where(
          and(
            eq(connectionRequests.fromUserId, from.id),
            gt(connectionRequests.createdAt, new Date(now.getTime() - DAY_MS)),
          ),
        ),
    ]);
    if (connected) throw conflict('already_connected', "You're already connected.");
    if (theirs) {
      throw conflict(
        'request_waiting_for_you',
        `${to.displayName} already asked to connect. Accept their request instead.`,
        { requestId: theirs.id },
      );
    }
    if (lastDeclined) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'request_cooldown',
        'You can ask this player again in a few days.',
      );
    }
    if (today!.n >= DAILY_REQUEST_LIMIT) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'daily_limit',
        `You can send ${DAILY_REQUEST_LIMIT} requests a day. Try again tomorrow.`,
      );
    }
    if (body.listingId) {
      const listing = await this.db.query.listings.findFirst({
        where: eq(listings.id, body.listingId),
      });
      if (!listing || listing.ownerId !== to.id) {
        throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Wrong listing.', {
          listingId: "Not one of this player's listings",
        });
      }
      if (listing.status !== 'open' || listing.expiresAt <= now) {
        throw conflict('listing_not_open', 'That listing is full or has ended.');
      }
    }

    const row = await this.db
      .transaction(async (tx) => {
        const [created] = await tx
          .insert(connectionRequests)
          .values({
            fromUserId: from.id,
            toUserId: to.id,
            listingId: body.listingId ?? null,
            message: body.message ?? null,
          })
          .returning();
        await this.notifier.notify(tx, [
          {
            userId: to.id,
            type: 'connection_request',
            actorId: from.id,
            connectionRequestId: created!.id,
            listingId: created!.listingId,
          },
        ]);
        return created!;
      })
      .catch((e: unknown) => {
        if (uniqueViolation(e) === 'connection_requests_one_pending') {
          throw conflict('request_pending', 'You already asked. Waiting for them to answer.');
        }
        throw e;
      });
    return (await this.build([row], from.id))[0]!;
  }

  /** Pending requests to you (from people you may see) or from you. */
  async list(viewer: User, direction: 'incoming' | 'outgoing'): Promise<ConnectionRequestDto[]> {
    const incoming = direction === 'incoming';
    const rows = await this.db
      .select({ request: connectionRequests })
      .from(connectionRequests)
      .innerJoin(
        users,
        eq(users.id, incoming ? connectionRequests.fromUserId : connectionRequests.toUserId),
      )
      .where(
        and(
          eq(connectionRequests.status, 'pending'),
          eq(incoming ? connectionRequests.toUserId : connectionRequests.fromUserId, viewer.id),
          visibleTo(this.db, viewer.id),
        ),
      )
      .orderBy(desc(connectionRequests.id))
      .limit(100);
    return this.build(
      rows.map((r) => r.request),
      viewer.id,
    );
  }

  /** A pending request, locked for this transaction. 404 unless `where` matches. */
  private async pending(tx: Tx, id: string, where: SQL): Promise<RequestRow> {
    const [row] = await tx
      .select()
      .from(connectionRequests)
      .where(and(eq(connectionRequests.id, id), where))
      .for('update');
    if (!row) throw notFound('That request');
    if (row.status !== 'pending') {
      throw conflict('request_not_pending', 'That request was already answered or withdrawn.');
    }
    return row;
  }

  /**
   * docs/DATA_MODEL.md "Accepting a request from a listing": one transaction
   * for the connection, the listing's filled count, both check-ins and the
   * requester's notification.
   */
  async accept(viewer: User, id: string): Promise<AcceptedRequestDto> {
    const now = new Date();
    const { request, connectedAt } = await this.db.transaction(async (tx) => {
      const req = await this.pending(tx, id, eq(connectionRequests.toUserId, viewer.id));
      const [accepted] = await tx
        .update(connectionRequests)
        .set({ status: 'accepted', respondedAt: now })
        .where(eq(connectionRequests.id, req.id))
        .returning();
      const [a, b] = orderedPair(req.fromUserId, req.toUserId);
      await tx
        .insert(connections)
        .values({
          userAId: a,
          userBId: b,
          sourceRequestId: req.id,
          sourceListingId: req.listingId,
          createdAt: now,
        })
        .onConflictDoNothing();
      const [pair] = await tx.select().from(connections).where(pairIs(a, b));

      if (req.listingId) {
        // Take a slot if one is left; a full or ended listing still connects you.
        await tx
          .update(listings)
          .set({
            filled: sql`${listings.filled} + 1`,
            status: sql`case when ${listings.filled} + 1 >= ${listings.partySize} - 1 then 'full'::listing_status else ${listings.status} end`,
          })
          .where(
            and(
              eq(listings.id, req.listingId),
              eq(listings.status, 'open'),
              gt(listings.expiresAt, now),
              sql`${listings.filled} < ${listings.partySize} - 1`,
            ),
          );
        await tx
          .insert(checkIns)
          .values(
            [
              [req.fromUserId, req.toUserId],
              [req.toUserId, req.fromUserId],
            ].map(([userId, otherUserId]) => ({
              userId: userId!,
              otherUserId: otherUserId!,
              listingId: req.listingId,
              dueAt: listingCheckInDueAt(now),
            })),
          )
          .onConflictDoNothing();
      }

      await this.notifier.notify(tx, [
        {
          userId: req.fromUserId,
          type: 'connection_accepted',
          actorId: viewer.id,
          connectionRequestId: req.id,
          listingId: req.listingId,
        },
      ]);
      return { request: accepted!, connectedAt: pair!.createdAt };
    });
    const [dto] = await this.build([request], viewer.id);
    return { request: dto!, connection: { user: dto!.from, connectedAt } };
  }

  /** "Not now". The sender isn't told; they can ask again after 7 days. */
  async decline(viewer: User, id: string): Promise<void> {
    await this.db.transaction(async (tx) => {
      const req = await this.pending(tx, id, eq(connectionRequests.toUserId, viewer.id));
      await tx
        .update(connectionRequests)
        .set({ status: 'declined', respondedAt: new Date() })
        .where(eq(connectionRequests.id, req.id));
    });
  }

  /** Withdraw your own pending request. */
  async cancel(viewer: User, id: string): Promise<void> {
    await this.db.transaction(async (tx) => {
      const req = await this.pending(tx, id, eq(connectionRequests.fromUserId, viewer.id));
      await tx
        .update(connectionRequests)
        .set({ status: 'cancelled', respondedAt: new Date() })
        .where(eq(connectionRequests.id, req.id));
    });
  }

  /** Your connections, newest first. People who are banned or deleted are left out. */
  async mine(viewer: User, limit = 20, cursor?: string): Promise<ConnectionPageDto> {
    const other = sql<string>`case when ${connections.userAId} = ${viewer.id} then ${connections.userBId} else ${connections.userAId} end`;
    const after = cursor ? decodeConnectionCursor(cursor) : undefined;
    const rows = await this.db
      .select({ user: users, connectedAt: connections.createdAt })
      .from(connections)
      .innerJoin(users, eq(users.id, other))
      .where(
        and(
          or(eq(connections.userAId, viewer.id), eq(connections.userBId, viewer.id)),
          isLive(),
          after
            ? sql`(${connections.createdAt}, ${users.id}) < (${after.at}, ${after.id})`
            : undefined,
        ),
      )
      .orderBy(desc(connections.createdAt), desc(users.id))
      .limit(limit + 1);
    const page = rows.slice(0, limit);
    const cards = await this.profiles.cards(page.map((r) => r.user));
    const last = page.at(-1);
    return {
      items: page.map((r, i): ConnectionDto => ({ user: cards[i]!, connectedAt: r.connectedAt })),
      nextCursor:
        rows.length > limit && last
          ? Buffer.from(`${last.connectedAt.toISOString()}|${last.user.id}`).toString('base64url')
          : null,
    };
  }

  async remove(viewer: User, userId: string): Promise<void> {
    const removed = await this.db
      .delete(connections)
      .where(pairIs(viewer.id, userId))
      .returning({ a: connections.userAId });
    if (removed.length === 0) throw notFound('That connection');
  }
}

function decodeConnectionCursor(cursor: string): { at: string; id: string } {
  const [at, id] = Buffer.from(cursor, 'base64url').toString().split('|');
  if (!at || !id || Number.isNaN(Date.parse(at)) || !/^[0-9a-f-]{36}$/.test(id)) {
    throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Bad cursor.', {
      cursor: 'Use nextCursor from the previous page',
    });
  }
  return { at, id };
}
