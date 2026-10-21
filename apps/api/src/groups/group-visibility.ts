import { and, type AnyColumn, eq, exists, isNotNull, ne, not, notExists, sql } from 'drizzle-orm';
import { alias } from 'drizzle-orm/pg-core';
import type { Db, Tx } from '../db/db.js';
import { groupMembers, groups, users } from '../db/schema/index.js';

// docs/FEED_AND_GROUPS_API.md "Safety and moderation". A group is hidden
// (404) when archived or removed, or while its creator is banned and no
// one else is a member: it's worked out when read, so an unban brings it
// back.

const creator = alias(users, 'group_creator');

/** Groups anyone may see. The query must have `groups` in it. */
export const groupVisible = (db: Db | Tx) =>
  and(
    eq(groups.status, 'live'),
    not(
      and(
        exists(
          db
            .select({ one: sql`1` })
            .from(creator)
            .where(and(eq(creator.id, groups.createdBy), isNotNull(creator.bannedAt))),
        ),
        notExists(
          db
            .select({ one: sql`1` })
            .from(groupMembers)
            .where(
              and(
                eq(groupMembers.groupId, groups.id),
                ne(groupMembers.userId, groups.createdBy),
                eq(groupMembers.status, 'member'),
              ),
            ),
        ),
      )!,
    ),
  );

/** `userId` (a value or a column) is a member (not just pending) of the group in `groupId`. */
export const memberOf = (db: Db | Tx, groupId: AnyColumn | string, userId: AnyColumn | string) =>
  exists(
    db
      .select({ one: sql`1` })
      .from(groupMembers)
      .where(
        and(
          eq(groupMembers.groupId, groupId),
          eq(groupMembers.userId, userId),
          eq(groupMembers.status, 'member'),
        ),
      ),
  );

/** The group in `groupId` is visible and `viewerId` is a member: group posts are for them only. */
export const inVisibleGroup = (db: Db | Tx, groupId: AnyColumn, viewerId: string) =>
  exists(
    db
      .select({ one: sql`1` })
      .from(groups)
      .where(and(eq(groups.id, groupId), groupVisible(db), memberOf(db, groups.id, viewerId))),
  );

/** `userId` is an admin of the group: they may remove posts and comments in it. */
export async function isGroupAdmin(db: Db | Tx, groupId: string, userId: string) {
  const row = await db.query.groupMembers.findFirst({
    where: and(
      eq(groupMembers.groupId, groupId),
      eq(groupMembers.userId, userId),
      eq(groupMembers.status, 'member'),
      eq(groupMembers.role, 'admin'),
    ),
  });
  return row !== undefined;
}
