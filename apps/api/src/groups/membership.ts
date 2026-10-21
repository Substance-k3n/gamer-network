import { and, asc, eq, ne, sql } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { groupMembers, groups } from '../db/schema/index.js';

/**
 * Account deletion (docs/FEED_AND_GROUPS_API.md "Safety and moderation"):
 * groups where they were the only member are archived (status deleted);
 * they leave every other group and drop their requests. Where they were
 * the only admin, the longest-standing member takes over, so the group
 * can still approve requests.
 */
export async function departGroups(tx: Tx, userId: string): Promise<void> {
  const mine = await tx.select().from(groupMembers).where(eq(groupMembers.userId, userId));
  for (const m of mine) {
    if (m.status === 'member') {
      await tx.select({ id: groups.id }).from(groups).where(eq(groups.id, m.groupId)).for('update');
      const others = await tx
        .select()
        .from(groupMembers)
        .where(
          and(
            eq(groupMembers.groupId, m.groupId),
            eq(groupMembers.status, 'member'),
            ne(groupMembers.userId, userId),
          ),
        )
        .orderBy(asc(groupMembers.joinedAt), asc(groupMembers.userId));
      if (others.length === 0) {
        await tx
          .update(groups)
          .set({ status: 'deleted', memberCount: 0 })
          .where(and(eq(groups.id, m.groupId), eq(groups.status, 'live')));
        await tx.delete(groupMembers).where(eq(groupMembers.groupId, m.groupId));
        continue;
      }
      if (m.role === 'admin' && !others.some((o) => o.role === 'admin')) {
        await tx
          .update(groupMembers)
          .set({ role: 'admin' })
          .where(
            and(eq(groupMembers.groupId, m.groupId), eq(groupMembers.userId, others[0]!.userId)),
          );
      }
      await tx
        .update(groups)
        .set({ memberCount: sql`greatest(${groups.memberCount} - 1, 0)` })
        .where(eq(groups.id, m.groupId));
    }
    await tx
      .delete(groupMembers)
      .where(and(eq(groupMembers.groupId, m.groupId), eq(groupMembers.userId, userId)));
  }
}
