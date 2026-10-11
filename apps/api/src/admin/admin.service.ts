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
  connectionRequests,
  connections,
  games,
  listings,
  reports,
  sessions,
  userGames,
  users,
} from '../db/schema/index.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import type {
  AdminReportDto,
  AdminReportPageDto,
  AdminUserDto,
  AdminUserPageDto,
  AdminUsersQuery,
  MetricsDto,
  ResolveAction,
} from './admin.dto.js';

type UserRow = typeof users.$inferSelect;
const DAY_MS = 24 * 3600_000;

/** `%`, `_` and `\` match literally. */
const likePrefix = (q: string) => `${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

/** Every admin action goes through here and leaves an admin_actions row. */
@Injectable()
export class AdminService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly sessionsService: SessionsService,
    private readonly notifier: NotificationsService,
  ) {}

  private async adminUsers(rows: UserRow[]): Promise<AdminUserDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((u) => u.id);
    const [mains, seen, conns, played, open] = await Promise.all([
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
    ]);
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
      banReason: u.banReason,
      onboarded: u.onboardedAt !== null,
      createdAt: u.createdAt,
      lastSeenAt: lastSeen.get(u.id) ?? null,
      connections: connCount.get(u.id) ?? 0,
      playedWith: playedWith.get(u.id) ?? 0,
      openReports: openReports.get(u.id) ?? 0,
    }));
  }

  async users(q: AdminUsersQuery): Promise<AdminUserPageDto> {
    const limit = q.limit ?? 20;
    const after = decodeCursor(q.cursor);
    const pattern = q.query && likePrefix(q.query);
    const rows = await this.db
      .select()
      .from(users)
      .where(
        and(
          after ? lt(users.id, after) : undefined,
          pattern
            ? or(
                ilike(users.username, pattern),
                ilike(users.displayName, pattern),
                ilike(users.email, pattern),
              )
            : undefined,
          q.state === 'active' ? and(isNull(users.bannedAt), isNull(users.deletedAt)) : undefined,
          q.state === 'banned'
            ? and(isNotNull(users.bannedAt), isNull(users.deletedAt))
            : undefined,
          q.state === 'deleted' ? isNotNull(users.deletedAt) : undefined,
        ),
      )
      .orderBy(desc(users.id))
      .limit(limit + 1);
    const items = await this.adminUsers(rows.slice(0, limit));
    return { items, nextCursor: rows.length > limit ? encodeCursor(items.at(-1)!.id) : null };
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
    return rows.map((r) => ({
      id: r.id,
      reporter: byId.get(r.reporterId)!,
      target: byId.get(r.targetUserId)!,
      listingId: r.listingId,
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
  async setLaunch(admin: User, gameId: string, isLaunch: boolean): Promise<void> {
    await this.db.transaction(async (tx) => {
      const [row] = await tx
        .update(games)
        .set({ isLaunch })
        .where(eq(games.id, gameId))
        .returning();
      if (!row) throw notFound('That game');
      await this.log(tx, {
        adminId: admin.id,
        kind: 'set_launch',
        gameId,
        note: isLaunch ? 'on' : 'off',
      });
    });
  }

  /** docs/DATA_MODEL.md "The metric", for listings created in [from, to). */
  async metrics(from: Date, to: Date): Promise<MetricsDto> {
    const created = and(gte(listings.createdAt, from), lt(listings.createdAt, to));
    const [[all], [requested], [played], [active]] = await Promise.all([
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
    ]);
    return {
      from,
      to,
      listings: all!.n,
      listingsWithRequest: requested!.n,
      listingsPlayed: played!.n,
      playedRate: all!.n ? played!.n / all!.n : 0,
      weeklyActive: active!.n,
    };
  }
}
