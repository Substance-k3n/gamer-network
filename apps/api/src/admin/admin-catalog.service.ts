import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import {
  and,
  asc,
  count,
  eq,
  gt,
  ilike,
  inArray,
  isNotNull,
  isNull,
  max,
  or,
  sql,
} from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import { uniqueViolation } from '../common/db-errors.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  adminActions,
  gameRanks,
  games,
  gamingIds,
  listings,
  playInvites,
  userGames,
  users,
} from '../db/schema/index.js';
import type { RankDto } from '../games/games.dto.js';
import type {
  AdminGameDto,
  AdminGamePageDto,
  AdminGamesQuery,
  CreateGameBody,
  CreateRankBody,
  UpdateGameBody,
  UpdateRankBody,
} from './admin-catalog.dto.js';

type GameRow = typeof games.$inferSelect;

const likePrefix = (q: string) => `${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

/** Admin games and ranks (docs/API.md "Admin → Catalog"). Every change is logged in admin_actions. */
@Injectable()
export class AdminCatalogService {
  constructor(@Inject(DB) private readonly db: Db) {}

  private log(tx: Tx, values: typeof adminActions.$inferInsert) {
    return tx.insert(adminActions).values(values);
  }

  private async build(rows: GameRow[]): Promise<AdminGameDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((g) => g.id);
    const [ranks, players, live] = await Promise.all([
      this.db
        .select()
        .from(gameRanks)
        .where(inArray(gameRanks.gameId, ids))
        .orderBy(asc(gameRanks.tier)),
      this.db
        .select({ gameId: userGames.gameId, n: count() })
        .from(userGames)
        .innerJoin(users, eq(users.id, userGames.userId))
        .where(and(inArray(userGames.gameId, ids), isNull(users.deletedAt)))
        .groupBy(userGames.gameId),
      this.db
        .select({ gameId: listings.gameId, n: count() })
        .from(listings)
        .where(
          and(
            inArray(listings.gameId, ids),
            inArray(listings.status, ['open', 'full']),
            gt(listings.expiresAt, new Date()),
          ),
        )
        .groupBy(listings.gameId),
    ]);
    const ranksOf = new Map<string, RankDto[]>();
    for (const r of ranks) {
      ranksOf.set(r.gameId, [
        ...(ranksOf.get(r.gameId) ?? []),
        { id: r.id, name: r.name, tier: r.tier },
      ]);
    }
    const playersOf = new Map(players.map((p) => [p.gameId, p.n]));
    const liveOf = new Map(live.map((l) => [l.gameId, l.n]));
    return rows.map((g) => ({
      id: g.id,
      name: g.name,
      shortCode: g.shortCode,
      platforms: g.platforms,
      hasRanks: g.hasRanks,
      maxParty: g.maxParty,
      isLaunch: g.isLaunch,
      sort: g.sort,
      ranks: ranksOf.get(g.id) ?? [],
      players: playersOf.get(g.id) ?? 0,
      liveListings: liveOf.get(g.id) ?? 0,
      deletedAt: g.deletedAt,
    }));
  }

  async games(q: AdminGamesQuery): Promise<AdminGamePageDto> {
    const page = q.page ?? 1;
    const pageSize = q.pageSize ?? 20;
    const pattern = q.query ? likePrefix(q.query) : null;
    const where = and(
      q.state === 'deleted' ? isNotNull(games.deletedAt) : isNull(games.deletedAt),
      pattern
        ? or(
            ilike(games.name, pattern),
            ilike(games.shortCode, pattern),
            ilike(games.id, pattern),
            ilike(games.name, `% ${pattern}`),
          )
        : undefined,
    );
    const [rows, [total]] = await Promise.all([
      this.db
        .select()
        .from(games)
        .where(where)
        .orderBy(asc(games.sort), asc(games.name))
        .limit(pageSize)
        .offset((page - 1) * pageSize),
      this.db.select({ n: count() }).from(games).where(where),
    ]);
    return { items: await this.build(rows), total: total!.n, page, pageSize };
  }

  async game(id: string): Promise<AdminGameDto> {
    const row = await this.db.query.games.findFirst({ where: eq(games.id, id) });
    if (!row) throw notFound('That game');
    return (await this.build([row]))[0]!;
  }

  /** A live game, for changes: deleted ones are read-only. */
  private async liveGame(tx: Tx | Db, id: string): Promise<GameRow> {
    const row = await tx.query.games.findFirst({
      where: and(eq(games.id, id), isNull(games.deletedAt)),
    });
    if (!row) throw notFound('That game');
    return row;
  }

  async createGame(admin: User, body: CreateGameBody): Promise<AdminGameDto> {
    await this.db.transaction(async (tx) => {
      const [{ top } = { top: null }] = await tx.select({ top: max(games.sort) }).from(games);
      await tx
        .insert(games)
        .values({
          id: body.id,
          name: body.name,
          shortCode: body.shortCode,
          platforms: body.platforms,
          hasRanks: body.hasRanks,
          maxParty: body.maxParty,
          isLaunch: body.isLaunch,
          sort: body.sort ?? (top ?? 0) + 1,
        })
        .catch((e: unknown) => {
          if (uniqueViolation(e)) {
            throw new AppError(HttpStatus.CONFLICT, 'game_exists', 'A game already uses that id.', {
              id: 'taken',
            });
          }
          throw e;
        });
      await this.log(tx, {
        adminId: admin.id,
        kind: 'create_game',
        gameId: body.id,
        note: body.name,
      });
    });
    return this.game(body.id);
  }

  async updateGame(admin: User, id: string, body: UpdateGameBody): Promise<AdminGameDto> {
    await this.db.transaction(async (tx) => {
      await this.liveGame(tx, id);
      const set = Object.fromEntries(Object.entries(body).filter(([, v]) => v !== undefined));
      if (Object.keys(set).length > 0) await tx.update(games).set(set).where(eq(games.id, id));
      // Launch on/off keeps its own kind, so the history reads like before.
      const kind =
        Object.keys(set).length === 1 && 'isLaunch' in set ? 'set_launch' : 'update_game';
      const note =
        kind === 'set_launch' ? (body.isLaunch ? 'on' : 'off') : Object.keys(set).join(', ');
      await this.log(tx, { adminId: admin.id, kind, gameId: id, note });
    });
    return this.game(id);
  }

  /**
   * Takes a game out of the catalog. It leaves every profile (and its
   * gaming IDs and "playing" statuses), its live listings close and its
   * pending play invites lapse. Old listings, posts and groups keep their
   * history, so the row stays with `deletedAt` set.
   */
  async deleteGame(admin: User, id: string): Promise<void> {
    const now = new Date();
    await this.db.transaction(async (tx) => {
      await this.liveGame(tx, id);
      await tx.update(games).set({ deletedAt: now, isLaunch: false }).where(eq(games.id, id));
      await tx.delete(userGames).where(eq(userGames.gameId, id));
      await tx.delete(gamingIds).where(eq(gamingIds.gameId, id));
      await tx
        .update(users)
        .set({ statusGameId: null, updatedAt: now })
        .where(eq(users.statusGameId, id));
      await tx
        .update(listings)
        .set({ status: 'closed', closedAt: now })
        .where(and(eq(listings.gameId, id), inArray(listings.status, ['open', 'full'])));
      await tx
        .update(playInvites)
        .set({ status: 'declined', respondedAt: now })
        .where(and(eq(playInvites.gameId, id), eq(playInvites.status, 'pending')));
      await this.log(tx, { adminId: admin.id, kind: 'delete_game', gameId: id });
    });
  }

  // ---- ranks ----

  private async rank(tx: Tx, gameId: string, rankId: string) {
    const r = await tx.query.gameRanks.findFirst({
      where: and(eq(gameRanks.id, rankId), eq(gameRanks.gameId, gameId)),
    });
    if (!r) throw notFound('That rank');
    return r;
  }

  /** Lifts every rank at or above [tier] one step, top first so the unique (game, tier) holds. */
  private async makeRoom(tx: Tx, gameId: string, tier: number) {
    const above = await tx
      .select({ id: gameRanks.id, tier: gameRanks.tier })
      .from(gameRanks)
      .where(and(eq(gameRanks.gameId, gameId), sql`${gameRanks.tier} >= ${tier}`))
      .orderBy(sql`${gameRanks.tier} desc`);
    for (const r of above) {
      await tx
        .update(gameRanks)
        .set({ tier: r.tier + 1 })
        .where(eq(gameRanks.id, r.id));
    }
  }

  async createRank(admin: User, gameId: string, body: CreateRankBody): Promise<AdminGameDto> {
    await this.db.transaction(async (tx) => {
      await this.liveGame(tx, gameId);
      const [{ top } = { top: null }] = await tx
        .select({ top: max(gameRanks.tier) })
        .from(gameRanks)
        .where(eq(gameRanks.gameId, gameId));
      const next = top === null ? 0 : top + 1;
      const tier = body.tier === undefined ? next : Math.min(body.tier, next);
      if (tier < next) await this.makeRoom(tx, gameId, tier);
      await tx.insert(gameRanks).values({ gameId, name: body.name, tier });
      await this.log(tx, { adminId: admin.id, kind: 'create_rank', gameId, note: body.name });
    });
    return this.game(gameId);
  }

  async updateRank(
    admin: User,
    gameId: string,
    rankId: string,
    body: UpdateRankBody,
  ): Promise<AdminGameDto> {
    await this.db.transaction(async (tx) => {
      await this.liveGame(tx, gameId);
      const r = await this.rank(tx, gameId, rankId);
      if (body.tier !== undefined && body.tier !== r.tier) {
        const other = await tx.query.gameRanks.findFirst({
          where: and(eq(gameRanks.gameId, gameId), eq(gameRanks.tier, body.tier)),
        });
        if (other) {
          // Swap through a free slot: (game, tier) is unique.
          await tx.update(gameRanks).set({ tier: -1 }).where(eq(gameRanks.id, r.id));
          await tx.update(gameRanks).set({ tier: r.tier }).where(eq(gameRanks.id, other.id));
        }
        await tx.update(gameRanks).set({ tier: body.tier }).where(eq(gameRanks.id, r.id));
      }
      if (body.name !== undefined) {
        await tx.update(gameRanks).set({ name: body.name }).where(eq(gameRanks.id, r.id));
      }
      await this.log(tx, {
        adminId: admin.id,
        kind: 'update_rank',
        gameId,
        note: body.name ?? r.name,
      });
    });
    return this.game(gameId);
  }

  /** Players and listings with this rank keep the game, without a rank. */
  async deleteRank(admin: User, gameId: string, rankId: string): Promise<AdminGameDto> {
    await this.db.transaction(async (tx) => {
      await this.liveGame(tx, gameId);
      const r = await this.rank(tx, gameId, rankId);
      await tx.update(userGames).set({ rankId: null }).where(eq(userGames.rankId, r.id));
      await tx.update(listings).set({ rankId: null }).where(eq(listings.rankId, r.id));
      await tx.delete(gameRanks).where(eq(gameRanks.id, r.id));
      // Close the gap, so tiers stay 0, 1, 2 …
      const above = await tx
        .select({ id: gameRanks.id, tier: gameRanks.tier })
        .from(gameRanks)
        .where(and(eq(gameRanks.gameId, gameId), sql`${gameRanks.tier} > ${r.tier}`))
        .orderBy(asc(gameRanks.tier));
      for (const a of above) {
        await tx
          .update(gameRanks)
          .set({ tier: a.tier - 1 })
          .where(eq(gameRanks.id, a.id));
      }
      await this.log(tx, { adminId: admin.id, kind: 'delete_rank', gameId, note: r.name });
    });
    return this.game(gameId);
  }
}
