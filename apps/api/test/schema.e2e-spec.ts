import { and, count, eq } from 'drizzle-orm';
import { createDb, type Db } from '../src/db/db.js';
import {
  connections,
  gameModes,
  gameRanks,
  games,
  gamingIds,
  listings,
  userGames,
  users,
} from '../src/db/schema/index.js';
import { seedCatalog } from '../src/db/seed.js';
import { TEST_DATABASE_URL } from './test-db.js';

// The rules docs/DATA_MODEL.md says the database itself enforces. Each case
// runs in a transaction that is rolled back, so the test database keeps
// only the seeded catalog. A failed statement aborts its transaction, so a
// case that expects a failure ends with it.

const ROLLBACK = Symbol('rollback');
type Tx = Parameters<Parameters<Db['transaction']>[0]>[0];

let conn: ReturnType<typeof createDb>;
let db: Db;

beforeAll(() => {
  conn = createDb(TEST_DATABASE_URL);
  db = conn.db;
});
afterAll(() => conn.client.end());

async function inRollback(fn: (tx: Tx) => Promise<void>) {
  try {
    await db.transaction(async (tx) => {
      await fn(tx);
      throw ROLLBACK;
    });
  } catch (e) {
    if (e !== ROLLBACK) throw e;
  }
}

/** The Postgres error code a statement fails with (23505 unique, 23503 FK, 23514 check). */
async function pgCode(p: PromiseLike<unknown>): Promise<string | undefined> {
  try {
    await p;
    return undefined;
  } catch (e) {
    const err = e as { code?: string; cause?: { code?: string } };
    return err.cause?.code ?? err.code;
  }
}

let n = 0;
const newUser = (tx: Tx, overrides: Partial<typeof users.$inferInsert> = {}) =>
  tx
    .insert(users)
    .values({
      email: `p${++n}@example.com`,
      username: `player${n}`,
      displayName: `Player ${n}`,
      ageRange: '18_24',
      ...overrides,
    })
    .returning()
    .then((r) => r[0]!);

const rankOf = async (tx: Tx, gameId: string, name: string) =>
  (
    await tx
      .select()
      .from(gameRanks)
      .where(and(eq(gameRanks.gameId, gameId), eq(gameRanks.name, name)))
  )[0]!;

const listing = (ownerId: string, overrides: Partial<typeof listings.$inferInsert> = {}) => {
  const now = new Date();
  return {
    ownerId,
    gameId: 'val',
    platform: 'pc' as const,
    partySize: 2,
    voice: 'required' as const,
    style: 'competitive' as const,
    playWhen: 'now' as const,
    durationHours: 2,
    startsAt: now,
    expiresAt: new Date(now.getTime() + 2 * 3600_000),
    city: 'Addis Ababa',
    ...overrides,
  };
};

describe('catalog seed', () => {
  it('loads the app catalog with ladders in order', async () => {
    const [{ value }] = await db.select({ value: count() }).from(games);
    expect(value).toBe(49);
    const val = await db
      .select({ name: gameRanks.name })
      .from(gameRanks)
      .where(eq(gameRanks.gameId, 'val'))
      .orderBy(gameRanks.tier);
    expect(val.map((r) => r.name)).toEqual([
      'Iron',
      'Bronze',
      'Silver',
      'Gold',
      'Platinum',
      'Diamond',
      'Ascendant',
      'Immortal',
      'Radiant',
    ]);
  });

  it('gives unranked games no Ranked mode', async () => {
    const mc = await db.select().from(gameModes).where(eq(gameModes.gameId, 'mc'));
    expect(mc.map((m) => m.name).sort()).toEqual(['Casual', 'Unrated']);
  });

  it('can run again without duplicating anything', async () => {
    const before = await db.select({ value: count() }).from(gameRanks);
    await seedCatalog(db);
    const after = await db.select({ value: count() }).from(gameRanks);
    expect(after).toEqual(before);
  });
});

describe('schema rules', () => {
  it('rejects usernames with capitals or spaces', () =>
    inRollback(async (tx) => {
      expect(await pgCode(newUser(tx, { username: 'Kaleb' }))).toBe('23514');
    }));

  it('treats emails as case-insensitive', () =>
    inRollback(async (tx) => {
      await newUser(tx, { email: 'kaleb@example.com', username: 'kaleb' });
      expect(await pgCode(newUser(tx, { email: 'KALEB@example.com' }))).toBe('23505');
    }));

  it("won't store a rank from another game", () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      const fcRank = await rankOf(tx, 'fc', 'Div 3');
      expect(
        await pgCode(
          tx.insert(userGames).values({ userId: u.id, gameId: 'val', rankId: fcRank.id }),
        ),
      ).toBe('23503');
    }));

  it('needs either a catalog game or a custom name, not both', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      expect(
        await pgCode(
          tx.insert(userGames).values({ userId: u.id, gameId: 'val', customGameName: 'X' }),
        ),
      ).toBe('23514');
    }));

  it('allows one live listing per person', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      await tx.insert(listings).values(listing(u.id));
      expect(await pgCode(tx.insert(listings).values(listing(u.id)))).toBe('23505');
    }));

  it('allows a new listing once the old one is closed', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      await tx.insert(listings).values(listing(u.id, { status: 'closed' }));
      await tx.insert(listings).values(listing(u.id));
    }));

  it('only takes 2, 6 or 24 hour listings', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      expect(await pgCode(tx.insert(listings).values(listing(u.id, { durationHours: 3 })))).toBe(
        '23514',
      );
    }));

  it('stores each connection once, smaller id first', () =>
    inRollback(async (tx) => {
      const [a, b] = [await newUser(tx), await newUser(tx)].sort((x, y) => (x.id < y.id ? -1 : 1));
      await tx.insert(connections).values({ userAId: a!.id, userBId: b!.id });
      expect(await pgCode(tx.insert(connections).values({ userAId: b!.id, userBId: a!.id }))).toBe(
        '23514',
      );
    }));

  it('refuses an in-game ID without its game', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      expect(
        await pgCode(tx.insert(gamingIds).values({ userId: u.id, kind: 'in_game', value: '5123' })),
      ).toBe('23514');
    }));

  it('stores an in-game ID with its game', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      await tx
        .insert(gamingIds)
        .values({ userId: u.id, kind: 'in_game', gameId: 'pubg', value: '5123' });
    }));

  it('keeps gaming IDs private to connections by default', () =>
    inRollback(async (tx) => {
      const u = await newUser(tx);
      const [row] = await tx
        .insert(gamingIds)
        .values({ userId: u.id, kind: 'riot', value: 'kaleb#ADD' })
        .returning();
      expect(row!.visibility).toBe('connections');
    }));
});
