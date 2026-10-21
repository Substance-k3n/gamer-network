import { Injectable } from '@nestjs/common';
import { and, eq, exists, gt, isNull, ne, not, sql } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { groupMembers, notifications, users } from '../db/schema/index.js';
import { blockedEitherWay } from '../feed/feed-notifier.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { isLive } from '../users/visibility.js';

/** At most one group_event push per group in this window; the rest only reach Alerts. */
export const EVENT_PUSH_EVERY_MS = 3600_000;

type Group = { id: string };

/**
 * docs/FEED_AND_GROUPS_API.md "Notifications" for groups: never about your
 * own action, never across a block, never to anyone no longer live. Pass
 * the caller's transaction.
 */
@Injectable()
export class GroupNotifier {
  constructor(private readonly notifier: NotificationsService) {}

  /** A join request on an approval group: its admins. One unread request per person and group. */
  async joinRequested(tx: Tx, group: Group, userId: string): Promise<void> {
    const admins = await tx
      .select({ id: users.id })
      .from(groupMembers)
      .innerJoin(users, eq(users.id, groupMembers.userId))
      .where(
        and(
          eq(groupMembers.groupId, group.id),
          eq(groupMembers.status, 'member'),
          eq(groupMembers.role, 'admin'),
          ne(users.id, userId),
          isLive(),
          not(blockedEitherWay(tx, userId, users.id)),
          // Asked, cancelled and asked again: the first request is still unread.
          not(
            exists(
              tx
                .select({ one: sql`1` })
                .from(notifications)
                .where(
                  and(
                    eq(notifications.userId, users.id),
                    eq(notifications.type, 'group_join_request'),
                    eq(notifications.groupId, group.id),
                    eq(notifications.actorId, userId),
                    isNull(notifications.readAt),
                  ),
                ),
            ),
          ),
        ),
      );
    await this.notifier.notify(
      tx,
      admins.map((a) => ({
        userId: a.id,
        type: 'group_join_request' as const,
        actorId: userId,
        groupId: group.id,
      })),
    );
  }

  /** An admin let them in: the new member. */
  async approved(tx: Tx, group: Group, adminId: string, userId: string): Promise<void> {
    if (adminId === userId) return;
    const [ok] = await tx
      .select({ id: users.id })
      .from(users)
      .where(and(eq(users.id, userId), isLive(), not(blockedEitherWay(tx, adminId, users.id))));
    if (!ok) return;
    await this.notifier.notify(tx, [
      { userId, type: 'group_join_approved', actorId: adminId, groupId: group.id },
    ]);
  }

  /**
   * A new event: every other member, in one batch. Events don't flood:
   * after one group_event push for the group, others within the hour go
   * to Alerts only.
   */
  async event(
    tx: Tx,
    group: Group,
    event: { id: string; createdBy: string },
    now = new Date(),
  ): Promise<void> {
    const actorId = event.createdBy;
    const members = await tx
      .select({ id: users.id })
      .from(groupMembers)
      .innerJoin(users, eq(users.id, groupMembers.userId))
      .where(
        and(
          eq(groupMembers.groupId, group.id),
          eq(groupMembers.status, 'member'),
          ne(users.id, actorId),
          isLive(),
          not(blockedEitherWay(tx, actorId, users.id)),
        ),
      );
    if (members.length === 0) return;
    const [recent] = await tx
      .select({ id: notifications.id })
      .from(notifications)
      .where(
        and(
          eq(notifications.groupId, group.id),
          eq(notifications.type, 'group_event'),
          gt(notifications.createdAt, new Date(now.getTime() - EVENT_PUSH_EVERY_MS)),
        ),
      )
      .limit(1);
    await this.notifier.notify(
      tx,
      members.map((m) => ({
        userId: m.id,
        type: 'group_event' as const,
        actorId,
        groupId: group.id,
        groupEventId: event.id,
        // Already handled: the push outbox skips it.
        pushedAt: recent ? now : null,
      })),
    );
  }
}
