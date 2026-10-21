import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, ilike, inArray, lte, ne, or, type SQL, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import type { PageQuery } from '../common/cursor.js';
import { uniqueViolation } from '../common/db-errors.js';
import { checkRate } from '../common/rate-limit.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { env } from '../env.js';
import { games, groupMembers, groups, posts, users } from '../db/schema/index.js';
import { connectedTo } from '../feed/visibility.js';
import { ProfileService } from '../me/profile.service.js';
import { visibleTo } from '../users/visibility.js';
import { type Group, GroupAccess } from './group-access.js';
import { decodeKey, encodeKey } from './group-cursor.js';
import { GroupEventsService } from './group-events.service.js';
import { GroupNotifier } from './group-notifier.js';
import { groupShapeErrors, shortFrom } from './group-rules.js';
import { groupVisible } from './group-visibility.js';
import type {
  CreateGroupBody,
  GroupMembersQuery,
  GroupsQuery,
  MyGroupsQuery,
  UpdateGroupBody,
} from './groups.body.js';
import type {
  GroupDto,
  GroupMemberPageDto,
  GroupPageDto,
  GroupRole,
  MembershipStatus,
} from './groups.dto.js';

const DAY_MS = 24 * 3600_000;
export const GROUPS_PER_DAY = 3;
export const JOINS_PER_DAY = 30;

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );
const conflict = (code: string, message: string) =>
  new AppError(HttpStatus.CONFLICT, code, message);
const nameTaken = () =>
  conflict('group_name_taken', 'A group with that name already exists. Try another name.');
const lastAdmin = () =>
  conflict('last_admin', 'Make someone else an admin first: a group needs at least one.');

/** `%`, `_` and `\` match literally. */
const likeAny = (q: string) => `%${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

type GroupRow = { group: Group; game: GroupDto['game'] };

/** docs/FEED_AND_GROUPS_API.md "Groups": the groups, their members and roles. */
@Injectable()
export class GroupsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly access: GroupAccess,
    private readonly events: GroupEventsService,
    private readonly notifier: GroupNotifier,
    private readonly profiles: ProfileService,
  ) {}

  /** Groups with their game, and `at`: the time a page is sorted by, as text, for the cursor. */
  private rows(at: SQL<string> = sql<string>`null`) {
    return this.db
      .select({
        group: groups,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
        at,
      })
      .from(groups)
      .leftJoin(games, eq(games.id, groups.gameId));
  }

  /** The kind chips and the search box: name, game or place. */
  private filters(kind?: string, query?: string) {
    return and(
      kind ? eq(groups.kind, kind as Group['kind']) : undefined,
      query
        ? or(
            ilike(groups.name, likeAny(query)),
            ilike(games.name, likeAny(query)),
            ilike(groups.place, likeAny(query)),
          )
        : undefined,
    );
  }

  /** discover: live groups, most members first, then newest. mine: see `mine`. */
  async list(viewer: User, q: GroupsQuery): Promise<GroupPageDto> {
    if (q.tab === 'mine') return this.mine(viewer, q, q.query);
    const limit = q.limit ?? 20;
    const after = decodeKey(q.cursor, ['int', 'uuid']);
    const rows = await this.rows()
      .where(
        and(
          groupVisible(this.db),
          this.filters(q.kind, q.query),
          after
            ? sql`(${groups.memberCount}, ${groups.id}) < (${Number(after[0])}, ${after[1]}::uuid)`
            : undefined,
        ),
      )
      .orderBy(desc(groups.memberCount), desc(groups.id))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    const last = items.at(-1);
    return {
      items: await this.build(items, viewer.id),
      nextCursor:
        rows.length > limit && last ? encodeKey(last.group.memberCount, last.group.id) : null,
    };
  }

  /**
   * Yours, requests included, most recent activity first: when you joined
   * or asked, or the group's latest post or event, whichever is later.
   */
  async mine(viewer: User, q: MyGroupsQuery, query?: string): Promise<GroupPageDto> {
    const limit = q.limit ?? 20;
    const after = decodeKey(q.cursor, ['time', 'uuid']);
    const activity = sql<Date>`greatest(${groupMembers.createdAt}, ${groupMembers.joinedAt},
      (select max(${posts.createdAt}) from ${posts}
        where ${posts.groupId} = ${groups.id} and ${posts.status} = 'live'),
      (select max(e.created_at) from group_events e where e.group_id = ${groups.id}))`;
    const rows = await this.rows(sql<string>`(${activity})::text`)
      .innerJoin(
        groupMembers,
        and(eq(groupMembers.groupId, groups.id), eq(groupMembers.userId, viewer.id)),
      )
      .where(
        and(
          groupVisible(this.db),
          this.filters(q.kind, query),
          after
            ? sql`(${activity}, ${groups.id}) < (${after[0]}::timestamptz, ${after[1]}::uuid)`
            : undefined,
        ),
      )
      .orderBy(desc(activity), desc(groups.id))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    const last = items.at(-1);
    return {
      items: await this.build(items, viewer.id),
      nextCursor: rows.length > limit && last ? encodeKey(last.at, last.group.id) : null,
    };
  }

  /** The groups someone is a member of, latest joined first. 404 when you can't see them. */
  async ofUser(viewer: User, username: string, q: PageQuery): Promise<GroupPageDto> {
    const user = await this.db.query.users.findFirst({
      where: and(eq(users.username, username.trim().toLowerCase()), visibleTo(this.db, viewer.id)),
    });
    if (!user) throw notFound('That player');
    const limit = q.limit ?? 20;
    const after = decodeKey(q.cursor, ['time', 'uuid']);
    const rows = await this.rows(sql<string>`${groupMembers.joinedAt}::text`)
      .innerJoin(
        groupMembers,
        and(
          eq(groupMembers.groupId, groups.id),
          eq(groupMembers.userId, user.id),
          eq(groupMembers.status, 'member'),
        ),
      )
      .where(
        and(
          groupVisible(this.db),
          after
            ? sql`(${groupMembers.joinedAt}, ${groups.id}) < (${after[0]}::timestamptz, ${after[1]}::uuid)`
            : undefined,
        ),
      )
      .orderBy(desc(groupMembers.joinedAt), desc(groups.id))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    const last = items.at(-1);
    return {
      items: await this.build(items, viewer.id),
      nextCursor: rows.length > limit && last ? encodeKey(last.at, last.group.id) : null,
    };
  }

  async get(viewer: User, id: string): Promise<GroupDto> {
    const [row] = await this.rows()
      .where(and(eq(groups.id, id), groupVisible(this.db)))
      .limit(1);
    if (!row) throw notFound('That group');
    return (await this.build([row], viewer.id))[0]!;
  }

  private async checkGame(gameId: string | null | undefined) {
    if (!gameId) return;
    const game = await this.db.query.games.findFirst({ where: eq(games.id, gameId) });
    if (!game) throw invalid({ gameId: 'Unknown game' });
  }

  /** 409 group_name_taken when another live group has the name, ignoring case. */
  private async checkName(name: string, except?: string) {
    const [taken] = await this.db
      .select({ id: groups.id })
      .from(groups)
      .where(
        and(
          sql`lower(${groups.name}) = lower(${name})`,
          eq(groups.status, 'live'),
          except ? ne(groups.id, except) : undefined,
        ),
      )
      .limit(1);
    if (taken) throw nameTaken();
  }

  /** You become its admin. Verified email (the controller), 3 a day. */
  async create(viewer: User, body: CreateGroupBody): Promise<GroupDto> {
    const shape = groupShapeErrors(body);
    if (shape) throw invalid(shape);
    await this.checkGame(body.gameId);
    await checkRate(
      this.db,
      groups,
      { user: groups.createdBy, createdAt: groups.createdAt },
      viewer.id,
      GROUPS_PER_DAY,
      DAY_MS,
      'groups',
      { verb: 'create', per: 'a day' },
    );
    await this.checkName(body.name);
    const now = new Date();
    const id = await this.db
      .transaction(async (tx) => {
        const [group] = await tx
          .insert(groups)
          .values({
            name: body.name,
            short: body.short ?? shortFrom(body.name),
            kind: body.kind,
            gameId: body.gameId ?? null,
            place: body.place,
            about: body.about ?? '',
            rules: body.rules ?? [],
            tone: body.tone ?? 'accent',
            approval: body.approval ?? false,
            createdBy: viewer.id,
            memberCount: 1,
          })
          .returning();
        await tx.insert(groupMembers).values({
          groupId: group!.id,
          userId: viewer.id,
          role: 'admin',
          status: 'member',
          joinedAt: now,
        });
        return group!.id;
      })
      .catch((e: unknown) => {
        if (uniqueViolation(e) === 'groups_name_unique') throw nameTaken();
        throw e;
      });
    return this.get(viewer, id);
  }

  /** Admins: any of the create fields but kind. */
  async update(viewer: User, id: string, body: UpdateGroupBody): Promise<GroupDto> {
    const group = await this.access.admin(id, viewer.id);
    const gameId = body.gameId === undefined ? group.gameId : body.gameId;
    const shape = groupShapeErrors({ kind: group.kind, gameId });
    if (shape) throw invalid(shape);
    if (body.gameId !== undefined) await this.checkGame(body.gameId);
    if (body.name !== undefined) await this.checkName(body.name, id);
    const changes: Partial<typeof groups.$inferInsert> = {};
    for (const key of ['name', 'short', 'place', 'about', 'rules', 'tone', 'approval'] as const) {
      if (body[key] !== undefined) Object.assign(changes, { [key]: body[key] });
    }
    if (body.gameId !== undefined) changes.gameId = body.gameId;
    if (Object.keys(changes).length) {
      await this.db
        .update(groups)
        .set(changes)
        .where(eq(groups.id, id))
        .catch((e: unknown) => {
          if (uniqueViolation(e) === 'groups_name_unique') throw nameTaken();
          throw e;
        });
    }
    return this.get(viewer, id);
  }

  /** Locks the group row, so joins, leaves and role changes on it go one at a time. */
  private async lock(tx: Tx, id: string) {
    await tx.select({ id: groups.id }).from(groups).where(eq(groups.id, id)).for('update');
  }

  private async bump(tx: Tx, id: string, by: 1 | -1) {
    await tx
      .update(groups)
      .set({ memberCount: sql`greatest(${groups.memberCount} + ${by}, 0)` })
      .where(eq(groups.id, id));
  }

  /** In straight away, or pending on approval groups (its admins are told). 30 a day. */
  async join(viewer: User, id: string): Promise<GroupDto> {
    const group = await this.access.visible(id);
    const mine = await this.access.membership(id, viewer.id);
    const already = () => conflict('already_member', "You're already in this group.");
    if (mine?.status === 'member') throw already();
    if (mine?.status === 'pending') return this.get(viewer, id);
    await checkRate(
      this.db,
      groupMembers,
      { user: groupMembers.userId, createdAt: groupMembers.createdAt },
      viewer.id,
      JOINS_PER_DAY,
      DAY_MS,
      'join requests',
      { verb: 'send', per: 'a day' },
    );
    await this.db
      .transaction(async (tx) => {
        await this.lock(tx, id);
        const pending = group.approval;
        await tx.insert(groupMembers).values({
          groupId: id,
          userId: viewer.id,
          role: 'member',
          status: pending ? 'pending' : 'member',
          joinedAt: pending ? null : new Date(),
        });
        if (pending) await this.notifier.joinRequested(tx, group, viewer.id);
        else await this.bump(tx, id, 1);
      })
      .catch((e: unknown) => {
        if (uniqueViolation(e) === 'group_members_group_id_user_id_pk') throw already();
        throw e;
      });
    return this.get(viewer, id);
  }

  /**
   * Leave, or cancel your request. The only admin can't leave while others
   * remain (409 last_admin); the last member leaving archives the group.
   */
  async leave(viewer: User, id: string): Promise<void> {
    await this.db.transaction(async (tx) => {
      await this.lock(tx, id);
      const [mine] = await tx
        .select()
        .from(groupMembers)
        .where(and(eq(groupMembers.groupId, id), eq(groupMembers.userId, viewer.id)));
      if (!mine) return;
      if (mine.status === 'member') {
        const [others] = await tx
          .select({
            members: sql<number>`count(*)::int`,
            admins: sql<number>`count(*) filter (where ${groupMembers.role} = 'admin')::int`,
          })
          .from(groupMembers)
          .where(
            and(
              eq(groupMembers.groupId, id),
              eq(groupMembers.status, 'member'),
              ne(groupMembers.userId, viewer.id),
            ),
          );
        if (mine.role === 'admin' && others!.admins === 0 && others!.members > 0) {
          throw lastAdmin();
        }
        if (others!.members === 0) {
          await tx
            .update(groups)
            .set({ status: 'deleted', memberCount: 0 })
            .where(and(eq(groups.id, id), eq(groups.status, 'live')));
          await tx.delete(groupMembers).where(eq(groupMembers.groupId, id));
          return;
        }
        await this.bump(tx, id, -1);
      }
      await tx
        .delete(groupMembers)
        .where(and(eq(groupMembers.groupId, id), eq(groupMembers.userId, viewer.id)));
    });
  }

  /** Members, admins first then by when they joined; status=pending: the requests, admins only. */
  async members(viewer: User, id: string, q: GroupMembersQuery): Promise<GroupMemberPageDto> {
    const status: MembershipStatus = q.status ?? 'member';
    if (status === 'pending') await this.access.admin(id, viewer.id);
    else await this.access.visible(id);
    const limit = q.limit ?? 20;
    const since = status === 'member' ? groupMembers.joinedAt : groupMembers.createdAt;
    const after = decodeKey(q.cursor, ['role', 'time', 'uuid']);
    const rows = await this.db
      .select({ member: groupMembers, user: users, at: sql<string>`${since}::text` })
      .from(groupMembers)
      .innerJoin(users, eq(users.id, groupMembers.userId))
      .where(
        and(
          eq(groupMembers.groupId, id),
          eq(groupMembers.status, status),
          visibleTo(this.db, viewer.id),
          after
            ? sql`(${groupMembers.role}, ${since}, ${groupMembers.userId}) > (${after[0]}::group_role, ${after[1]}::timestamptz, ${after[2]}::uuid)`
            : undefined,
        ),
      )
      .orderBy(asc(groupMembers.role), asc(since), asc(groupMembers.userId))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    const cards = await this.profiles.cards(items.map((r) => r.user));
    const last = items.at(-1);
    return {
      items: items.map((r, i) => ({
        user: cards[i]!,
        role: r.member.role,
        status: r.member.status,
        joinedAt: r.member.joinedAt,
      })),
      nextCursor:
        rows.length > limit && last
          ? encodeKey(last.member.role, last.at, last.member.userId)
          : null,
    };
  }

  /** Admins let a request in; tells them. Already a member: nothing to do. */
  async approve(viewer: User, id: string, userId: string): Promise<void> {
    const group = await this.access.admin(id, viewer.id);
    await this.db.transaction(async (tx) => {
      await this.lock(tx, id);
      const [row] = await tx
        .update(groupMembers)
        .set({ status: 'member', joinedAt: new Date() })
        .where(
          and(
            eq(groupMembers.groupId, id),
            eq(groupMembers.userId, userId),
            eq(groupMembers.status, 'pending'),
          ),
        )
        .returning();
      if (!row) {
        const [member] = await tx
          .select({ id: groupMembers.userId })
          .from(groupMembers)
          .where(and(eq(groupMembers.groupId, id), eq(groupMembers.userId, userId)));
        if (member) return;
        throw notFound('That request');
      }
      await this.bump(tx, id, 1);
      await this.notifier.approved(tx, group, viewer.id, userId);
    });
  }

  /** Admins turn a request down, without telling them. */
  async decline(viewer: User, id: string, userId: string): Promise<void> {
    await this.access.admin(id, viewer.id);
    const removed = await this.db
      .delete(groupMembers)
      .where(
        and(
          eq(groupMembers.groupId, id),
          eq(groupMembers.userId, userId),
          eq(groupMembers.status, 'pending'),
        ),
      )
      .returning({ id: groupMembers.userId });
    if (removed.length === 0) throw notFound('That request');
  }

  /** Admins make a member admin, or back. A group keeps at least one admin (409 last_admin). */
  async setRole(viewer: User, id: string, userId: string, role: GroupRole): Promise<void> {
    await this.access.admin(id, viewer.id);
    await this.db.transaction(async (tx) => {
      await this.lock(tx, id);
      const [target] = await tx
        .select()
        .from(groupMembers)
        .where(
          and(
            eq(groupMembers.groupId, id),
            eq(groupMembers.userId, userId),
            eq(groupMembers.status, 'member'),
          ),
        );
      if (!target) throw notFound('That member');
      if (target.role === role) return;
      if (role === 'member') {
        const [admins] = await tx
          .select({ n: sql<number>`count(*)::int` })
          .from(groupMembers)
          .where(
            and(
              eq(groupMembers.groupId, id),
              eq(groupMembers.status, 'member'),
              eq(groupMembers.role, 'admin'),
            ),
          );
        if (admins!.n <= 1) throw lastAdmin();
      }
      await tx
        .update(groupMembers)
        .set({ role })
        .where(and(eq(groupMembers.groupId, id), eq(groupMembers.userId, userId)));
    });
  }

  /** Admins take someone out (or drop their request). Not yourself: leave instead. */
  async removeMember(viewer: User, id: string, userId: string): Promise<void> {
    await this.access.admin(id, viewer.id);
    if (userId === viewer.id) {
      throw invalid({ userId: 'To leave the group, use Leave' });
    }
    await this.db.transaction(async (tx) => {
      await this.lock(tx, id);
      const [row] = await tx
        .delete(groupMembers)
        .where(and(eq(groupMembers.groupId, id), eq(groupMembers.userId, userId)))
        .returning();
      if (!row) throw notFound('That member');
      if (row.status === 'member') await this.bump(tx, id, -1);
    });
  }

  private async build(rows: GroupRow[], viewerId: string): Promise<GroupDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((r) => r.group.id);
    // Up to 3 members per group, your connections first, then the earliest joined.
    const ranked = this.db
      .select({
        groupId: groupMembers.groupId,
        userId: groupMembers.userId,
        rank: sql<number>`row_number() over (partition by ${groupMembers.groupId}
          order by ${connectedTo(this.db, viewerId, groupMembers.userId)} desc,
            ${groupMembers.joinedAt}, ${groupMembers.userId})`.as('rank'),
      })
      .from(groupMembers)
      .innerJoin(users, eq(users.id, groupMembers.userId))
      .where(
        and(
          inArray(groupMembers.groupId, ids),
          eq(groupMembers.status, 'member'),
          visibleTo(this.db, viewerId),
        ),
      )
      .as('ranked');
    const creatorIds = [...new Set(rows.map((r) => r.group.createdBy))];
    const [mine, preview, next, creators] = await Promise.all([
      this.db
        .select()
        .from(groupMembers)
        .where(and(eq(groupMembers.userId, viewerId), inArray(groupMembers.groupId, ids))),
      this.db
        .select({ groupId: ranked.groupId, user: users })
        .from(ranked)
        .innerJoin(users, eq(users.id, ranked.userId))
        .where(lte(ranked.rank, 3))
        .orderBy(ranked.groupId, ranked.rank),
      this.events.next(ids, viewerId),
      this.db.select().from(users).where(inArray(users.id, creatorIds)),
    ]);
    const creatorCards = await this.profiles.cards(creators);
    const creatorOf = new Map(creators.map((u, i) => [u.id, creatorCards[i]!]));
    const cards = await this.profiles.cards(preview.map((p) => p.user));
    const previewOf = new Map<string, typeof cards>();
    preview.forEach((p, i) =>
      previewOf.set(p.groupId, [...(previewOf.get(p.groupId) ?? []), cards[i]!]),
    );
    const me = new Map(mine.map((m) => [m.groupId, m]));
    return rows.map(({ group: g, game }) => {
      const m = me.get(g.id);
      return {
        id: g.id,
        name: g.name,
        short: g.short,
        kind: g.kind,
        game,
        place: g.place,
        about: g.about,
        rules: g.rules,
        tone: g.tone,
        approval: g.approval,
        memberCount: g.memberCount,
        membersPreview: previewOf.get(g.id) ?? [],
        nextEvent: next.get(g.id) ?? null,
        myRole: m?.status === 'member' ? m.role : null,
        myStatus: m?.status ?? null,
        createdBy: creatorOf.get(g.createdBy)!,
        shareUrl: `${env.publicWebUrl}/app/groups/${g.id}`,
        createdAt: g.createdAt,
      };
    });
  }
}
