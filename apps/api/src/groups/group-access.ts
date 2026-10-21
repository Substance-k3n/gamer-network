import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { AppError, notFound } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { groupMembers, groups } from '../db/schema/index.js';
import { groupVisible } from './group-visibility.js';

export type Group = typeof groups.$inferSelect;
export type Membership = typeof groupMembers.$inferSelect;

export const notMember = () =>
  new AppError(HttpStatus.FORBIDDEN, 'not_member', 'Join the group to do that.');
export const notGroupAdmin = () =>
  new AppError(HttpStatus.FORBIDDEN, 'not_group_admin', 'Only a group admin can do that.');

/** Who may do what in a group. A hidden group is a 404 for everyone. */
@Injectable()
export class GroupAccess {
  constructor(@Inject(DB) private readonly db: Db) {}

  /** The group, or 404 when it's archived, removed or hidden by a ban. */
  async visible(groupId: string): Promise<Group> {
    const [group] = await this.db
      .select()
      .from(groups)
      .where(and(eq(groups.id, groupId), groupVisible(this.db)));
    if (!group) throw notFound('That group');
    return group;
  }

  /** Their row in the group (member or pending), if any. */
  async membership(groupId: string, userId: string): Promise<Membership | undefined> {
    return this.db.query.groupMembers.findFirst({
      where: and(eq(groupMembers.groupId, groupId), eq(groupMembers.userId, userId)),
    });
  }

  /** The group, if `userId` is a member of it (403 not_member). */
  async member(groupId: string, userId: string): Promise<{ group: Group; me: Membership }> {
    const group = await this.visible(groupId);
    const me = await this.membership(groupId, userId);
    if (me?.status !== 'member') throw notMember();
    return { group, me };
  }

  /** The group, if `userId` is one of its admins (403 not_group_admin). */
  async admin(groupId: string, userId: string): Promise<Group> {
    const group = await this.visible(groupId);
    const me = await this.membership(groupId, userId);
    if (me?.status !== 'member' || me.role !== 'admin') throw notGroupAdmin();
    return group;
  }
}
