import { Inject, Injectable, Logger } from '@nestjs/common';
import { and, asc, desc, eq, gt, inArray, isNull, lt, or, type SQL, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { decodeCursor, encodeCursor } from '../common/cursor.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  devices,
  games,
  listings,
  notifications,
  playInvites,
  sessions,
  users,
} from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import { visibleTo } from '../users/visibility.js';
import { notificationText } from './notification-text.js';
import type { NotificationDto } from './notifications.dto.js';
import { PUSHER, type Pusher } from './pusher.js';

export type NewNotification = typeof notifications.$inferInsert;

/** Postgres channel; NOTIFY is delivered only when the writing transaction commits. */
export const PUSH_CHANNEL = 'notifications_created';

@Injectable()
export class NotificationsService {
  private readonly log = new Logger(NotificationsService.name);

  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(PUSHER) private readonly pusher: Pusher,
    private readonly profiles: ProfileService,
  ) {}

  /**
   * The one way to create notifications. Pass the caller's transaction: if
   * it rolls back, nothing is stored and nothing is pushed.
   */
  async notify(db: Db | Tx, rows: NewNotification[]): Promise<void> {
    if (rows.length === 0) return;
    await db.insert(notifications).values(rows);
    await db.execute(sql`select pg_notify(${PUSH_CHANNEL}, '')`);
  }

  /** Notifications with what their text needs: actor, and the game of their listing or invite. */
  private withFacts(where: SQL | undefined) {
    return this.db
      .select({ n: notifications, actor: users, gameName: games.name })
      .from(notifications)
      .leftJoin(users, eq(users.id, notifications.actorId))
      .leftJoin(listings, eq(listings.id, notifications.listingId))
      .leftJoin(playInvites, eq(playInvites.id, notifications.playInviteId))
      .leftJoin(games, eq(games.id, sql`coalesce(${listings.gameId}, ${playInvites.gameId})`))
      .where(where);
  }

  private text(r: Awaited<ReturnType<NotificationsService['withFacts']>>[number]) {
    return notificationText({
      type: r.n.type,
      actorName: r.actor?.displayName ?? null,
      actorUsername: r.actor?.username ?? null,
      gameName: r.gameName,
      listingId: r.n.listingId,
      checkInId: r.n.checkInId,
    });
  }

  /** Alerts, newest first. Hides ones from people you can no longer see. */
  async list(viewer: User, limit = 20, cursor?: string) {
    const after = decodeCursor(cursor);
    const rows = await this.withFacts(
      and(
        eq(notifications.userId, viewer.id),
        or(isNull(notifications.actorId), visibleTo(this.db, viewer.id)),
        after ? lt(notifications.id, after) : undefined,
      ),
    )
      .orderBy(desc(notifications.id))
      .limit(limit + 1);
    const page = rows.slice(0, limit);
    const actors = await this.profiles.cards(page.flatMap((r) => (r.actor ? [r.actor] : [])));
    const card = new Map(actors.map((c) => [c.id, c]));
    const items = page.map((r): NotificationDto => ({
      id: r.n.id,
      type: r.n.type,
      actor: (r.actor && card.get(r.actor.id)) ?? null,
      listingId: r.n.listingId,
      connectionRequestId: r.n.connectionRequestId,
      playInviteId: r.n.playInviteId,
      checkInId: r.n.checkInId,
      ...this.text(r),
      readAt: r.n.readAt,
      createdAt: r.n.createdAt,
    }));
    return { items, nextCursor: rows.length > limit ? encodeCursor(items.at(-1)!.id) : null };
  }

  async unreadCount(viewer: User): Promise<number> {
    const [row] = await this.db
      .select({ n: sql<number>`count(*)::int` })
      .from(notifications)
      .leftJoin(users, eq(users.id, notifications.actorId))
      .where(
        and(
          eq(notifications.userId, viewer.id),
          isNull(notifications.readAt),
          or(isNull(notifications.actorId), visibleTo(this.db, viewer.id)),
        ),
      );
    return row!.n;
  }

  /** Marks the given ids (yours only), or all of them. */
  async markRead(viewer: User, ids: string[] | 'all'): Promise<void> {
    if (ids !== 'all' && ids.length === 0) return;
    await this.db
      .update(notifications)
      .set({ readAt: new Date() })
      .where(
        and(
          eq(notifications.userId, viewer.id),
          isNull(notifications.readAt),
          ids === 'all' ? undefined : inArray(notifications.id, ids),
        ),
      );
  }

  /**
   * Sends pushes for notifications not pushed yet. Claims rows with
   * FOR UPDATE SKIP LOCKED, so instances never send the same one twice.
   * Returns how many were handled; call again while it returns `batch`.
   */
  async dispatch(batch = 100): Promise<number> {
    return this.db.transaction(async (tx) => {
      const claimed = await tx
        .select({ id: notifications.id, userId: notifications.userId })
        .from(notifications)
        .where(isNull(notifications.pushedAt))
        .orderBy(asc(notifications.id))
        .limit(batch)
        .for('update', { skipLocked: true });
      if (claimed.length === 0) return 0;
      const ids = claimed.map((c) => c.id);
      await tx
        .update(notifications)
        .set({ pushedAt: new Date() })
        .where(inArray(notifications.id, ids));

      const now = new Date();
      const [facts, targets] = await Promise.all([
        this.withFacts(inArray(notifications.id, ids)),
        tx
          .select({ userId: devices.userId, token: devices.fcmToken })
          .from(devices)
          .leftJoin(sessions, eq(sessions.id, devices.sessionId))
          .where(
            and(
              inArray(devices.userId, [...new Set(claimed.map((c) => c.userId))]),
              // Devices registered by a session only push while it is signed in.
              or(
                isNull(devices.sessionId),
                and(isNull(sessions.revokedAt), gt(sessions.expiresAt, now)),
              ),
            ),
          ),
      ]);
      const tokensOf = new Map<string, string[]>();
      for (const t of targets) tokensOf.set(t.userId, [...(tokensOf.get(t.userId) ?? []), t.token]);

      const dead: string[] = [];
      for (const r of facts) {
        const tokens = tokensOf.get(r.n.userId) ?? [];
        if (tokens.length === 0) continue;
        const { title, text, route } = this.text(r);
        try {
          const { invalidTokens } = await this.pusher.send(tokens, {
            title,
            body: text,
            data: { type: r.n.type, id: r.n.id, route },
          });
          dead.push(...invalidTokens);
        } catch (e) {
          // Push is best effort: the notification is still in Alerts.
          this.log.warn(`push ${r.n.id} failed: ${(e as Error).message}`);
        }
      }
      if (dead.length) await tx.delete(devices).where(inArray(devices.fcmToken, dead));
      return claimed.length;
    });
  }

  /** Runs dispatch until the outbox is empty. */
  async dispatchAll(): Promise<void> {
    while ((await this.dispatch()) === 100);
  }
}
