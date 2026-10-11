import { sql } from 'drizzle-orm';
import { env } from '../env.js';
import { createDb, type Db } from './db.js';
import { gameModes, gameRanks, games } from './schema/index.js';
import { seedGames } from './seed/games.js';

const MODES = ['Ranked', 'Unrated', 'Casual'] as const;

/** Idempotent: safe to run on every deploy. Updates names and ladders in place. */
export async function seedCatalog(db: Db) {
  await db.transaction(async (tx) => {
    for (const [i, g] of seedGames.entries()) {
      const row = {
        id: g.id,
        name: g.name,
        shortCode: g.shortCode,
        platforms: g.platforms,
        hasRanks: g.hasRanks,
        maxParty: g.maxParty,
        isLaunch: g.isLaunch,
        sort: i,
      };
      await tx.insert(games).values(row).onConflictDoUpdate({ target: games.id, set: row });

      for (const [tier, name] of g.ranks.entries()) {
        await tx
          .insert(gameRanks)
          .values({ gameId: g.id, tier, name })
          .onConflictDoUpdate({ target: [gameRanks.gameId, gameRanks.tier], set: { name } });
      }
      await tx.execute(
        sql`delete from ${gameRanks} where ${gameRanks.gameId} = ${g.id} and ${gameRanks.tier} >= ${g.ranks.length}`,
      );

      for (const name of MODES) {
        if (name === 'Ranked' && !g.hasRanks) continue;
        await tx
          .insert(gameModes)
          .values({ gameId: g.id, name, isRanked: name === 'Ranked' })
          .onConflictDoNothing();
      }
    }
  });
  return seedGames.length;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const { client, db } = createDb(env.databaseUrl);
  const count = await seedCatalog(db);
  await client.end();
  console.info(`seeded ${count} games`);
}
