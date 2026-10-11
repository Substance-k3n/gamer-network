import { Inject, Injectable } from '@nestjs/common';
import { asc } from 'drizzle-orm';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { gameModes, gameRanks, gameRoles, games } from '../db/schema/index.js';
import type { GameDto } from './games.dto.js';

@Injectable()
export class GamesService {
  constructor(@Inject(DB) private readonly db: Db) {}

  async catalog(): Promise<GameDto[]> {
    const [gameRows, ranks, roles, modes] = await Promise.all([
      this.db.select().from(games).orderBy(asc(games.sort)),
      this.db.select().from(gameRanks).orderBy(asc(gameRanks.tier)),
      this.db.select().from(gameRoles).orderBy(asc(gameRoles.name)),
      this.db.select().from(gameModes).orderBy(asc(gameModes.name)),
    ]);
    const byGame = <T extends { gameId: string }>(rows: T[]) => {
      const map = new Map<string, T[]>();
      for (const r of rows) map.set(r.gameId, [...(map.get(r.gameId) ?? []), r]);
      return map;
    };
    const r = byGame(ranks);
    const ro = byGame(roles);
    const m = byGame(modes);

    return gameRows.map((g) => ({
      id: g.id,
      name: g.name,
      shortCode: g.shortCode,
      platforms: g.platforms,
      hasRanks: g.hasRanks,
      maxParty: g.maxParty,
      isLaunch: g.isLaunch,
      ranks: (r.get(g.id) ?? []).map(({ id, name, tier }) => ({ id, name, tier })),
      roles: (ro.get(g.id) ?? []).map(({ id, name }) => ({ id, name })),
      modes: (m.get(g.id) ?? []).map(({ id, name, isRanked }) => ({ id, name, isRanked })),
    }));
  }
}
