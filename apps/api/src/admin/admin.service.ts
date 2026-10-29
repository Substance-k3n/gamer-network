import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import {
  and,
  countDistinct,
  desc,
  eq,
  exists,
  gte,
  ilike,
  inArray,
  isNotNull,
  isNull,
  lt,
  max,
  or,
  sql,
} from 'drizzle-orm';
import { AppError, notFound } from '../common/app-error.js';
import { decodeCursor, encodeCursor } from '../common/cursor.js';
import { SessionsService, type User } from '../auth/sessions.service.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  adminActions,
  checkIns,
  comments,
  connectionRequests,
  connections,
  games,
  groupMembers,
  groups,
  listings,
  posts,
  reports,
  sessions,
  userGames,
  users,
  waitlist,
} from '../db/schema/index.js';
import { MediaService } from '../feed/media.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { SafetyService } from '../safety/safety.service.js';
import { hashPassword } from '../auth/crypto.js';
import { uniqueViolation } from '../common/db-errors.js';
import type { CreateUserBody, UpdateUserBody } from './admin-catalog.dto.js';
import type {
  AdminReportDto,
  AdminReportPageDto,
  AdminUserDto,
  AdminUserNumberPageDto,
  AdminUsersQuery,
  MetricsDto,
  ResolveAction,
} from './admin.dto.js';

type UserRow = typeof users.$inferSelect;
const DAY_MS = 24 * 3600_000;

/** `%`, `_` and `\` match literally. */
const likePrefix = (q: string) => `${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

const notAbout = (what: string) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    `This report has no ${what.slice(2)}.`,
    {
      action: `This report is not about ${what}`,
    },
  );

/** Every admin action goes through here and leaves an admin_actions row. */
@Injectable()
export class AdminService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly sessionsService: SessionsService,
    private readonly notifier: NotificationsService,
    private readonly media: MediaService,
    private readonly safety: SafetyService,
  ) {}

  private async adminUsers(rows: UserRow[]): Promise<AdminUserDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((u) => u.id);
    const [mains, seen, conns, played, open, postCounts, groupCounts] = await Promise.all([
      this.db
        .select({
          userId: userGames.userId,
          name: sql<string>`coalesce(${games.name}, ${userGames.customGameName})`,
        })
        .from(userGames)
        .leftJoin(games, eq(games.id, userGames.gameId))
        .where(and(inArray(userGames.userId, ids), eq(userGames.position, 0))),
      this.db
        .select({ userId: sessions.userId, at: max(sessions.lastSeenAt) })
        .from(sessions)
        .where(inArray(sessions.userId, ids))
        .groupBy(sessions.userId),
      this.db
        .select({ a: connections.userAId, b: connections.userBId })
        .from(connections)
        .where(or(inArray(connections.userAId, ids), inArray(connections.userBId, ids))),
      this.db
        .select({ userId: checkIns.userId, n: countDistinct(checkIns.otherUserId) })
        .from(checkIns)
        .where(and(inArray(checkIns.userId, ids), eq(checkIns.answer, 'played')))
        .groupBy(checkIns.userId),
      this.db
        .select({ userId: reports.targetUserId, n: sql<number>`count(*)::int` })
        .from(reports)
        .where(and(inArray(reports.targetUserId, ids), eq(reports.status, 'open')))
        .groupBy(reports.targetUserId),
      this.db
        .select({ userId: posts.authorId, n: sql<number>`count(*)::int` })
        .from(posts)
        .where(and(inArray(posts.authorId, ids), eq(posts.status, 'live')))
        .groupBy(posts.authorId),
      this.db
        .select({ userId: groupMembers.userId, n: sql<number>`count(*)::int` })
        .from(groupMembers)
        .innerJoin(groups, eq(groups.id, groupMembers.groupId))
        .where(
          and(
            inArray(groupMembers.userId, ids),
            eq(groupMembers.status, 'member'),
            eq(groups.status, 'live'),
          ),
        )
        .groupBy(groupMembers.userId),
    ]);
    const postsOf = new Map(postCounts.map((p) => [p.userId, p.n]));
    const groupsOf = new Map(groupCounts.map((g) => [g.userId, g.n]));
    const main = new Map(mains.map((m) => [m.userId, m.name]));
    const lastSeen = new Map(seen.map((s) => [s.userId, s.at]));
    const connCount = new Map<string, number>();
    for (const c of conns) {
      connCount.set(c.a, (connCount.get(c.a) ?? 0) + 1);
      connCount.set(c.b, (connCount.get(c.b) ?? 0) + 1);
    }
    const playedWith = new Map(played.map((p) => [p.userId, p.n]));
    const openReports = new Map(open.map((o) => [o.userId, o.n]));
    return rows.map((u) => ({
      id: u.id,
      username: u.username,
      displayName: u.displayName,
      email: u.email,
      city: u.city,
      mainGame: main.get(u.id) ?? null,
      state: u.deletedAt ? 'deleted' : u.bannedAt ? 'banned' : 'active',
      role: u.role,
      ageRange: u.ageRange,
      banReason: u.banReason,
      onboarded: u.onboardedAt !== null,
      createdAt: u.createdAt,
      lastSeenAt: lastSeen.get(u.id) ?? null,
      connections: connCount.get(u.id) ?? 0,
      playedWith: playedWith.get(u.id) ?? 0,
      openReports: openReports.get(u.id) ?? 0,
      postsCount: postsOf.get(u.id) ?? 0,
      groupsCount: groupsOf.get(u.id) ?? 0,
    }));
  }

  async users(q: AdminUsersQuery): Promise<AdminUserNumberPageDto> {
    const page = q.page ?? 1;
    const pageSize = q.pageSize ?? 20;
    const pattern = q.query && likePrefix(q.query);
    const where = and(
      pattern
        ? or(
            ilike(users.username, pattern),
            ilike(users.displayName, pattern),
            ilike(users.email, pattern),
          )
        : undefined,
      q.state === 'active' ? and(isNull(users.bannedAt), isNull(users.deletedAt)) : undefined,
      q.state === 'banned' ? and(isNotNull(users.bannedAt), isNull(users.deletedAt)) : undefined,
      q.state === 'deleted' ? isNotNull(users.deletedAt) : undefined,
    );
    const [rows, [total]] = await Promise.all([
      this.db
        .select()
        .from(users)
        .where(where)
        .orderBy(desc(users.createdAt), desc(users.id))
        .limit(pageSize)
        .offset((page - 1) * pageSize),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(users)
        .where(where),
    ]);
    return { items: await this.adminUsers(rows), total: total!.n, page, pageSize };
  }

  /** Turns a clash on email or username into a 409 the form can show. */
  private clash(e: unknown): never {
    const c = uniqueViolation(e);
    if (c?.includes('email')) {
      throw new AppError(HttpStatus.CONFLICT, 'email_taken', 'That email already has an account.', {
        email: 'taken',
      });
    }
    if (c?.includes('username')) {
      throw new AppError(HttpStatus.CONFLICT, 'username_taken', 'That username is taken.', {
        username: 'taken',
      });
    }
    throw e;
  }

  /** An account made by an admin: email already verified, onboarding still to do. */
  async createUser(admin: User, body: CreateUserBody): Promise<AdminUserDto> {
    const passwordHash = await hashPassword(body.password);
    const id = await this.db.transaction(async (tx) => {
      const [u] = await tx
        .insert(users)
        .values({
          email: body.email,
          emailVerifiedAt: new Date(),
          passwordHash,
          username: body.username,
          displayName: body.displayName,
          ageRange: body.ageRange,
          role: body.role ?? 'player',
        })
        .returning({ id: users.id })
        .catch((e: unknown) => this.clash(e));
      await this.log(tx, { adminId: admin.id, kind: 'create_user', targetUserId: u!.id });
      return u!.id;
    });
    return this.user(id);
  }

  async updateUser(admin: User, id: string, body: UpdateUserBody): Promise<AdminUserDto> {
    if (body.role === 'player' && id === admin.id) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'own_role',
        'You can’t take away your own admin role.',
        { role: 'Ask another admin' },
      );
    }
    await this.db.transaction(async (tx) => {
      const row = await tx.query.users.findFirst({ where: eq(users.id, id) });
      if (!row || row.deletedAt) throw notFound('That user');
      const set = Object.fromEntries(Object.entries(body).filter(([, v]) => v !== undefined));
      if (Object.keys(set).length === 0) return;
      // A new email is one an admin vouches for, so it counts as verified.
      if (body.email && body.email !== row.email) set.emailVerifiedAt = new Date();
      await tx
        .update(users)
        .set({ ...set, updatedAt: new Date() })
        .where(eq(users.id, id))
        .catch((e: unknown) => this.clash(e));
      await this.log(tx, {
        adminId: admin.id,
        kind: 'update_user',
        targetUserId: id,
        note: Object.keys(body)
          .filter((k) => body[k as keyof UpdateUserBody] !== undefined)
          .join(', '),
      });
    });
    return this.user(id);
  }

  /** Same as them deleting their account (DELETE /me): signed out, erased in 30 days. */
  async deleteUser(admin: User, id: string): Promise<void> {
    if (id === admin.id) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'own_account',
        'You can’t delete your own account here.',
      );
    }
    const row = await this.db.query.users.findFirst({ where: eq(users.id, id) });
    if (!row || row.deletedAt) throw notFound('That user');
    await this.safety.closeAccount(id);
    await this.db.transaction((tx) =>
      this.log(tx, { adminId: admin.id, kind: 'delete_user', targetUserId: id }),
    );
  }

  async user(id: string): Promise<AdminUserDto> {
    const row = await this.db.query.users.findFirst({ where: eq(users.id, id) });
    if (!row) throw notFound('That user');
    return (await this.adminUsers([row]))[0]!;
  }

  private async buildReports(rows: (typeof reports.$inferSelect)[]): Promise<AdminReportDto[]> {
    if (rows.length === 0) return [];
    const people = await this.db
      .select()
      .from(users)
      .where(inArray(users.id, [...new Set(rows.flatMap((r) => [r.reporterId, r.targetUserId]))]));
    const byId = new Map((await this.adminUsers(people)).map((u) => [u.id, u]));
    const postIds = rows.flatMap((r) => (r.postId ? [r.postId] : []));
    const commentIds = rows.flatMap((r) => (r.commentId ? [r.commentId] : []));
    const groupIds = rows.flatMap((r) => (r.groupId ? [r.groupId] : []));
    const [postTexts, commentTexts, groupRows, images] = await Promise.all([
      postIds.length
        ? this.db
            .select({ id: posts.id, text: posts.text })
            .from(posts)
            .where(inArray(posts.id, postIds))
        : [],
      commentIds.length
        ? this.db
            .select({ id: comments.id, text: comments.text })
            .from(comments)
            .where(inArray(comments.id, commentIds))
        : [],
      groupIds.length
        ? this.db
            .select({ id: groups.id, name: groups.name, about: groups.about })
            .from(groups)
            .where(inArray(groups.id, groupIds))
        : [],
      this.media.forPosts(postIds, true),
    ]);
    const text = new Map([...postTexts, ...commentTexts].map((t) => [t.id, t.text]));
    const groupOf = new Map(groupRows.map((g) => [g.id, g]));
    return rows.map((r) => ({
      id: r.id,
      reporter: byId.get(r.reporterId)!,
      target: byId.get(r.targetUserId)!,
      listingId: r.listingId,
      postId: r.postId,
      commentId: r.commentId,
      groupId: r.groupId,
      excerpt:
        (r.groupId
          ? groupOf.get(r.groupId)?.about
          : text.get(r.commentId ?? r.postId ?? '')
        )?.slice(0, 300) ?? null,
      groupName: (r.groupId && groupOf.get(r.groupId)?.name) || null,
      image: (r.postId && !r.commentId && images.get(r.postId)?.[0]) || null,
      reason: r.reason,
      details: r.details,
      status: r.status,
      createdAt: r.createdAt,
      resolvedAt: r.resolvedAt,
      resolutionNote: r.resolutionNote,
    }));
  }

  /** The queue: open reports oldest first (first in, first handled); others newest first. */
  async reports(
    status: AdminReportDto['status'],
    limit = 20,
    cursor?: string,
  ): Promise<AdminReportPageDto> {
    const after = decodeCursor(cursor);
    const oldestFirst = status === 'open';
    const rows = await this.db
      .select()
      .from(reports)
      .where(
        and(
          eq(reports.status, status),
          after ? (oldestFirst ? sql`${reports.id} > ${after}` : lt(reports.id, after)) : undefined,
        ),
      )
      .orderBy(oldestFirst ? reports.id : desc(reports.id))
      .limit(limit + 1);
    const items = await this.buildReports(rows.slice(0, limit));
    return { items, nextCursor: rows.length > limit ? encodeCursor(items.at(-1)!.id) : null };
  }

  private async log(tx: Tx, values: typeof adminActions.$inferInsert) {
    await tx.insert(adminActions).values(values);
  }

  /** Bans inside `tx`: marks the user, closes their live listing, withdraws what's pending. */
  private async banIn(tx: Tx, admin: User, userId: string, reason: string, reportId?: string) {
    const now = new Date();
    const [banned] = await tx
      .update(users)
      .set({ bannedAt: now, banReason: reason, updatedAt: now })
      .where(and(eq(users.id, userId), isNull(users.bannedAt)))
      .returning({ id: users.id });
    if (!banned) return;
    await tx
      .update(listings)
      .set({ status: 'removed', closedAt: now })
      .where(and(eq(listings.ownerId, userId), inArray(listings.status, ['open', 'full'])));
    await tx
      .update(connectionRequests)
      .set({ status: 'cancelled', respondedAt: now })
      .where(
        and(
          eq(connectionRequests.status, 'pending'),
          or(eq(connectionRequests.fromUserId, userId), eq(connectionRequests.toUserId, userId)),
        ),
      );
    await this.log(tx, {
      adminId: admin.id,
      kind: 'ban',
      targetUserId: userId,
      reportId,
      note: reason,
    });
  }

  async ban(admin: User, userId: string, reason: string): Promise<AdminUserDto> {
    if (userId === admin.id) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        "You can't ban yourself.",
      );
    }
    await this.user(userId);
    await this.db.transaction((tx) => this.banIn(tx, admin, userId, reason));
    // Signed out everywhere, and no more pushes.
    await this.sessionsService.revokeAll(userId);
    return this.user(userId);
  }

  async unban(admin: User, userId: string, note = ''): Promise<AdminUserDto> {
    await this.user(userId);
    await this.db.transaction(async (tx) => {
      const [row] = await tx
        .update(users)
        .set({ bannedAt: null, banReason: null, updatedAt: new Date() })
        .where(and(eq(users.id, userId), isNotNull(users.bannedAt)))
        .returning({ id: users.id });
      if (row) await this.log(tx, { adminId: admin.id, kind: 'unban', targetUserId: userId, note });
    });
    return this.user(userId);
  }

  async removeListing(admin: User, listingId: string, note = '', tx?: Tx, reportId?: string) {
    const run = async (t: Tx) => {
      const [row] = await t
        .update(listings)
        .set({ status: 'removed', closedAt: new Date() })
        .where(eq(listings.id, listingId))
        .returning({ ownerId: listings.ownerId });
      if (!row) throw notFound('That listing');
      await this.log(t, {
        adminId: admin.id,
        kind: 'remove_listing',
        listingId,
        targetUserId: row.ownerId,
        reportId,
        note,
      });
    };
    if (tx) await run(tx);
    else await this.db.transaction(run);
  }

  /** Takes a post down: hidden everywhere, logged. */
  async removePost(admin: User, postId: string, note = '', tx?: Tx, reportId?: string) {
    const run = async (t: Tx) => {
      const [row] = await t
        .update(posts)
        .set({ status: 'removed', removedAt: new Date(), removedBy: admin.id })
        .where(eq(posts.id, postId))
        .returning({ authorId: posts.authorId });
      if (!row) throw notFound('That post');
      await this.log(t, {
        adminId: admin.id,
        kind: 'remove_post',
        postId,
        targetUserId: row.authorId,
        reportId,
        note,
      });
    };
    if (tx) await run(tx);
    else await this.db.transaction(run);
  }

  /** Takes a comment down, and the replies under it with it. */
  async removeComment(admin: User, commentId: string, note = '', tx?: Tx, reportId?: string) {
    const run = async (t: Tx) => {
      const [row] = await t
        .update(comments)
        .set({ status: 'removed', removedAt: new Date(), removedBy: admin.id })
        .where(eq(comments.id, commentId))
        .returning({ authorId: comments.authorId });
      if (!row) throw notFound('That comment');
      await this.log(t, {
        adminId: admin.id,
        kind: 'remove_comment',
        commentId,
        targetUserId: row.authorId,
        reportId,
        note,
      });
    };
    if (tx) await run(tx);
    else await this.db.transaction(run);
  }

  /** Takes a group down: it, its posts and its events are hidden everywhere, logged. */
  async removeGroup(admin: User, groupId: string, note = '', tx?: Tx, reportId?: string) {
    const run = async (t: Tx) => {
      const [row] = await t
        .update(groups)
        .set({ status: 'removed' })
        .where(eq(groups.id, groupId))
        .returning({ createdBy: groups.createdBy });
      if (!row) throw notFound('That group');
      await this.log(t, {
        adminId: admin.id,
        kind: 'remove_group',
        groupId,
        targetUserId: row.createdBy,
        reportId,
        note,
      });
    };
    if (tx) await run(tx);
    else await this.db.transaction(run);
  }

  /** Closes a report with an action; the reporter hears back unless it was dismissed. */
  async resolve(admin: User, reportId: string, action: ResolveAction, note: string) {
    let banned: string | undefined;
    await this.db.transaction(async (tx) => {
      const [report] = await tx
        .select()
        .from(reports)
        .where(eq(reports.id, reportId))
        .for('update');
      if (!report) throw notFound('That report');
      if (report.status !== 'open') {
        throw new AppError(
          HttpStatus.CONFLICT,
          'report_closed',
          'That report was already handled.',
        );
      }
      const now = new Date();
      switch (action) {
        case 'dismiss':
          await this.log(tx, {
            adminId: admin.id,
            kind: 'dismiss_report',
            reportId,
            targetUserId: report.targetUserId,
            note,
          });
          break;
        case 'warn':
          await this.log(tx, {
            adminId: admin.id,
            kind: 'warn',
            reportId,
            targetUserId: report.targetUserId,
            note,
          });
          break;
        case 'remove_listing':
          if (!report.listingId) {
            throw new AppError(
              HttpStatus.UNPROCESSABLE_ENTITY,
              'validation_failed',
              'This report has no listing.',
              {
                action: 'This report is not about a listing',
              },
            );
          }
          await this.removeListing(admin, report.listingId, note, tx, reportId);
          break;
        case 'remove_post':
          if (!report.postId) throw notAbout('a post');
          await this.removePost(admin, report.postId, note, tx, reportId);
          break;
        case 'remove_comment':
          if (!report.commentId) throw notAbout('a comment');
          await this.removeComment(admin, report.commentId, note, tx, reportId);
          break;
        case 'remove_group':
          if (!report.groupId) throw notAbout('a group');
          await this.removeGroup(admin, report.groupId, note, tx, reportId);
          break;
        case 'ban':
          await this.banIn(tx, admin, report.targetUserId, note || report.reason, reportId);
          banned = report.targetUserId;
          break;
      }
      await tx
        .update(reports)
        .set({
          status: action === 'dismiss' ? 'dismissed' : 'actioned',
          resolvedBy: admin.id,
          resolvedAt: now,
          resolutionNote: note,
        })
        .where(eq(reports.id, reportId));
      if (action !== 'dismiss') {
        await this.notifier.notify(tx, [{ userId: report.reporterId, type: 'report_resolved' }]);
      }
    });
    if (banned) await this.sessionsService.revokeAll(banned);
    const [row] = await this.db.select().from(reports).where(eq(reports.id, reportId));
    return (await this.buildReports([row!]))[0]!;
  }

  /** Puts a game on Find Players or takes it off. Live listings for it stay until they end. */
  /** docs/DATA_MODEL.md "The metric", for listings created in [from, to). */
  async metrics(from: Date, to: Date): Promise<MetricsDto> {
    const created = and(gte(listings.createdAt, from), lt(listings.createdAt, to));
    const [[all], [requested], [played], [active], waiting] = await Promise.all([
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(listings)
        .where(created),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(listings)
        .where(
          and(
            created,
            exists(
              this.db
                .select({ one: sql`1` })
                .from(connectionRequests)
                .where(eq(connectionRequests.listingId, listings.id)),
            ),
          ),
        ),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(listings)
        .where(
          and(
            created,
            exists(
              this.db
                .select({ one: sql`1` })
                .from(checkIns)
                .where(and(eq(checkIns.listingId, listings.id), eq(checkIns.answer, 'played'))),
            ),
          ),
        ),
      this.db
        .select({ n: countDistinct(sessions.userId) })
        .from(sessions)
        .where(
          and(
            gte(sessions.lastSeenAt, new Date(to.getTime() - 7 * DAY_MS)),
            lt(sessions.lastSeenAt, to),
          ),
        ),
      this.db
        .select({ topic: waitlist.topic, count: sql<number>`count(*)::int` })
        .from(waitlist)
        .groupBy(waitlist.topic)
        .orderBy(desc(sql`count(*)`), waitlist.topic),
    ]);
    return {
      from,
      to,
      listings: all!.n,
      listingsWithRequest: requested!.n,
      listingsPlayed: played!.n,
      playedRate: all!.n ? played!.n / all!.n : 0,
      weeklyActive: active!.n,
      waitlist: waiting,
      ...(await this.dashboard(from, to)),
    };
  }

  /** The dashboard's charts: a row per Addis Ababa day, top games and today's totals. */
  private async dashboard(from: Date, to: Date) {
    const day = (col: unknown) =>
      sql<string>`to_char((${col} at time zone 'Africa/Addis_Ababa')::date, 'YYYY-MM-DD')`;
    const perDay = async (table: string, col: string, extra = sql``) => {
      const rows = await this.db.execute<{ day: string; n: number }>(sql`
        select ${day(sql.raw(col))} as day, count(*)::int as n
        from ${sql.raw(table)}
        where ${sql.raw(col)} >= ${from.toISOString()} and ${sql.raw(col)} < ${to.toISOString()} ${extra}
        group by 1`);
      return new Map(rows.map((r) => [r.day, Number(r.n)]));
    };
    const [signups, made, posted, playedOn, top, [totals]] = await Promise.all([
      perDay('users', 'created_at'),
      perDay('listings', 'created_at'),
      perDay('posts', 'created_at', sql`and status = 'live'`),
      perDay('check_ins', 'answered_at', sql`and answer = 'played'`),
      this.db
        .select({ gameId: games.id, name: games.name, listings: sql<number>`count(*)::int` })
        .from(listings)
        .innerJoin(games, eq(games.id, listings.gameId))
        .where(and(gte(listings.createdAt, from), lt(listings.createdAt, to)))
        .groupBy(games.id, games.name)
        .orderBy(desc(sql`count(*)`))
        .limit(8),
      this.db.execute<{
        players: number;
        banned: number;
        games: number;
        open_reports: number;
        live_groups: number;
      }>(sql`select
        (select count(*)::int from users where deleted_at is null and banned_at is null) as players,
        (select count(*)::int from users where deleted_at is null and banned_at is not null) as banned,
        (select count(*)::int from games where deleted_at is null) as games,
        (select count(*)::int from reports where status = 'open') as open_reports,
        (select count(*)::int from groups where status = 'live') as live_groups`),
    ]);
    const series = [];
    // Walk Addis days: UTC+3 all year, no DST.
    const addis = (d: Date) => new Date(d.getTime() + 3 * 3600_000).toISOString().slice(0, 10);
    for (let d = addis(from); d <= addis(new Date(to.getTime() - 1));) {
      series.push({
        day: d,
        signups: signups.get(d) ?? 0,
        listings: made.get(d) ?? 0,
        posts: posted.get(d) ?? 0,
        played: playedOn.get(d) ?? 0,
      });
      d = new Date(new Date(`${d}T00:00:00Z`).getTime() + DAY_MS).toISOString().slice(0, 10);
    }
    return {
      series,
      topGames: top,
      totals: {
        players: Number(totals!.players),
        banned: Number(totals!.banned),
        games: Number(totals!.games),
        openReports: Number(totals!.open_reports),
        liveGroups: Number(totals!.live_groups),
      },
    };
  }
}
