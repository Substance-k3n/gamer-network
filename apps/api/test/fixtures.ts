import type { Db } from '../src/db/db.js';
import { gameModes, gameRanks, games } from '../src/db/schema/index.js';

/**
 * Two test-only games next to the seed's Chess, for the cases that need
 * another game: a rank from another game, a game off Find Players. They
 * never exist outside the test database.
 */
export const FIXTURE_GAMES = [
  {
    id: 'practice',
    name: 'Practice Chess',
    shortCode: 'PRAC',
    isLaunch: true,
    hasRanks: true,
    ranks: ['Low', 'Mid', 'High'],
    modes: ['Blitz', 'Rapid'],
  },
  {
    id: 'shelf',
    name: 'Shelf Chess',
    shortCode: 'SHLF',
    isLaunch: false,
    hasRanks: false,
    ranks: ['Easy', 'Hard'],
    modes: ['Casual'],
  },
] as const;

export async function seedFixtures(db: Db) {
  for (const [i, g] of FIXTURE_GAMES.entries()) {
    const [added] = await db
      .insert(games)
      .values({
        id: g.id,
        name: g.name,
        shortCode: g.shortCode,
        platforms: ['chess_com', 'lichess'],
        hasRanks: g.hasRanks,
        maxParty: 2,
        isLaunch: g.isLaunch,
        sort: 100 + i,
      })
      .onConflictDoNothing()
      .returning({ id: games.id });
    if (!added) continue;
    for (const [tier, name] of g.ranks.entries()) {
      await db.insert(gameRanks).values({ gameId: g.id, tier, name });
    }
    for (const name of g.modes) {
      await db.insert(gameModes).values({ gameId: g.id, name });
    }
  }
}
