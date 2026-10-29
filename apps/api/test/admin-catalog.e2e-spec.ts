import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { adminActions, listings, users } from '../src/db/schema/index.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Admin → Catalog" and "Admin → Users".

let app: INestApplication<App>;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => ({ app } = await createTestApp()));
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

async function player({ admin = false } = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `c_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Chala ${id}`,
      username: `chala_${id}`,
      ageRange: '25_34',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const userId = res.body.user.id as string;
  await conn.db
    .update(users)
    .set({ emailVerifiedAt: new Date(), role: admin ? 'admin' : 'player' })
    .where(eq(users.id, userId));
  return {
    id: userId,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
    patch: (path: string, body: object) => http().patch(path).set(auth).send(body),
    del: (path: string) => http().delete(path).set(auth),
  };
}

/** A game of its own per test, so deleting it can't touch the seeded catalog. */
async function newGame(admin: Awaited<ReturnType<typeof player>>, extra: object = {}) {
  const id = `t${uniq()}`;
  const res = await admin
    .post('/v1/admin/games', {
      id,
      name: `Test Game ${id}`,
      shortCode: 'tg',
      platforms: ['mobile', 'pc'],
      hasRanks: true,
      maxParty: 4,
      // Off Find Players, so the launch-games tests running alongside don't see it.
      isLaunch: false,
      ...extra,
    })
    .expect(201);
  return res.body as {
    id: string;
    shortCode: string;
    ranks: { id: string; name: string; tier: number }[];
  };
}

const names = (g: { ranks: { name: string }[] }) => g.ranks.map((r) => r.name);

describe('games', () => {
  it('admins only', async () => {
    const p = await player();
    await p.get('/v1/admin/games').expect(403);
    await p.post('/v1/admin/games', {}).expect(403);
  });

  it('creates, pages, edits and logs a game', async () => {
    const admin = await player({ admin: true });
    const g = await newGame(admin);
    expect(g).toMatchObject({ shortCode: 'TG', players: 0, liveListings: 0, deletedAt: null });
    await admin
      .post('/v1/admin/games', {
        id: g.id,
        name: 'Again',
        shortCode: 'AG',
        platforms: ['pc'],
        hasRanks: true,
        maxParty: 4,
        isLaunch: false,
      })
      .expect(409)
      .expect((r) => expect(r.body.error.code).toBe('game_exists'));
    await admin
      .post('/v1/admin/games', {
        id: 'BAD ID',
        name: 'x',
        shortCode: 'x',
        platforms: [],
        hasRanks: true,
        maxParty: 4,
        isLaunch: true,
      })
      .expect(422);

    const page = (await admin.get(`/v1/admin/games?query=Test Game ${g.id}`).expect(200)).body;
    expect(page).toMatchObject({ total: 1, page: 1, pageSize: 20 });
    expect(page.items[0].id).toBe(g.id);
    const all = (await admin.get('/v1/admin/games?pageSize=5&page=2').expect(200)).body;
    expect(all.items).toHaveLength(5);
    expect(all.total).toBeGreaterThan(40);

    const edited = (
      await admin.patch(`/v1/admin/games/${g.id}`, { name: 'Renamed', maxParty: 6 }).expect(200)
    ).body;
    expect(edited).toMatchObject({ name: 'Renamed', maxParty: 6, isLaunch: false });
    expect(
      (await http().get('/v1/games').expect(200)).body.find((x: { id: string }) => x.id === g.id),
    ).toMatchObject({ name: 'Renamed', maxParty: 6 });

    const log = await conn.db
      .select({ kind: adminActions.kind })
      .from(adminActions)
      .where(and(eq(adminActions.adminId, admin.id), eq(adminActions.gameId, g.id)));
    expect(log.map((l) => l.kind).sort()).toEqual(['create_game', 'update_game']);
  });

  it('delete: gone from the catalog and from profiles, live listings close', async () => {
    const admin = await player({ admin: true });
    const g = await newGame(admin, { isLaunch: true });
    const p = await player();
    await p.put('/v1/me/games', { games: [{ gameId: g.id }, { gameId: 'pubg' }] }).expect(200);
    await p.post('/v1/me/onboard').expect(204);
    await p.put('/v1/me/status', { status: 'playing', gameId: g.id }).expect(200);
    const listing = (
      await p
        .post('/v1/listings', {
          gameId: g.id,
          platform: 'mobile',
          partySize: 2,
          voice: 'optional',
          style: 'casual',
          playWhen: 'now',
          durationHours: 2,
        })
        .expect(201)
    ).body;
    expect((await admin.get(`/v1/admin/games/${g.id}`)).body).toMatchObject({
      players: 1,
      liveListings: 1,
    });

    await admin.del(`/v1/admin/games/${g.id}`).expect(204);

    const me = (await p.get('/v1/me').expect(200)).body;
    expect(me.games.map((x: { game: { id: string } | null }) => x.game?.id)).toEqual(['pubg']);
    expect(me.statusGame ?? null).toBeNull();
    const [row] = await conn.db.select().from(listings).where(eq(listings.id, listing.id));
    expect(row!.status).toBe('closed');
    expect((await http().get('/v1/games')).body.map((x: { id: string }) => x.id)).not.toContain(
      g.id,
    );

    // Nothing can pick it again; the admin sees it under deleted, read-only.
    await p.put('/v1/me/games', { games: [{ gameId: g.id }] }).expect(422);
    const deleted = (await admin.get(`/v1/admin/games?state=deleted&query=${g.id}`)).body.items;
    expect(deleted.map((x: { id: string }) => x.id)).toEqual([g.id]);
    await admin.patch(`/v1/admin/games/${g.id}`, { name: 'Back?' }).expect(404);
    await admin.del(`/v1/admin/games/${g.id}`).expect(404);
  });
});

describe('ranks', () => {
  it('adds on top or at a tier, moves by swapping, deletes and closes the gap', async () => {
    const admin = await player({ admin: true });
    let g = await newGame(admin);
    for (const name of ['Bronze', 'Silver', 'Gold']) {
      g = (await admin.post(`/v1/admin/games/${g.id}/ranks`, { name }).expect(201)).body;
    }
    expect(names(g)).toEqual(['Bronze', 'Silver', 'Gold']);
    g = (await admin.post(`/v1/admin/games/${g.id}/ranks`, { name: 'Iron', tier: 0 }).expect(201))
      .body;
    expect(names(g)).toEqual(['Iron', 'Bronze', 'Silver', 'Gold']);
    expect(g.ranks.map((r) => r.tier)).toEqual([0, 1, 2, 3]);

    const gold = g.ranks.find((r) => r.name === 'Gold')!;
    g = (
      await admin
        .patch(`/v1/admin/games/${g.id}/ranks/${gold.id}`, { tier: 2, name: 'Gold I' })
        .expect(200)
    ).body;
    expect(names(g)).toEqual(['Iron', 'Bronze', 'Gold I', 'Silver']);

    const p = await player();
    const bronze = g.ranks.find((r) => r.name === 'Bronze')!;
    await p.put('/v1/me/games', { games: [{ gameId: g.id, rankId: bronze.id }] }).expect(200);
    g = (await admin.del(`/v1/admin/games/${g.id}/ranks/${bronze.id}`).expect(200)).body;
    expect(names(g)).toEqual(['Iron', 'Gold I', 'Silver']);
    expect(g.ranks.map((r) => r.tier)).toEqual([0, 1, 2]);
    const mine = (await p.get('/v1/me')).body.games[0];
    expect(mine).toMatchObject({ game: { id: g.id }, rank: null });

    await admin.del(`/v1/admin/games/${g.id}/ranks/${bronze.id}`).expect(404);
    await admin.del(`/v1/admin/games/pubg/ranks/${g.ranks[0]!.id}`).expect(404);
  });
});

describe('users', () => {
  it('pages by number with a total', async () => {
    const admin = await player({ admin: true });
    const res = (await admin.get('/v1/admin/users?pageSize=2&page=1').expect(200)).body;
    expect(res).toMatchObject({ page: 1, pageSize: 2 });
    expect(res.items).toHaveLength(2);
    expect(res.total).toBeGreaterThanOrEqual(2);
    expect(res.items[0]).toHaveProperty('role');
  });

  it('creates, edits and deletes an account', async () => {
    const admin = await player({ admin: true });
    const id = uniq();
    const made = (
      await admin
        .post('/v1/admin/users', {
          email: `new_${id}@example.com`,
          username: `new_${id}`,
          displayName: 'Made Here',
          password: 'long enough pw',
          ageRange: '18_24',
        })
        .expect(201)
    ).body;
    expect(made).toMatchObject({ role: 'player', state: 'active', onboarded: false });
    // They can sign in with it.
    await http()
      .post('/v1/auth/login')
      .send({ email: `new_${id}@example.com`, password: 'long enough pw' })
      .expect(200);

    await admin
      .post('/v1/admin/users', {
        email: `new_${id}@example.com`,
        username: `other_${id}`,
        displayName: 'x',
        password: 'long enough pw',
        ageRange: '18_24',
      })
      .expect(409)
      .expect((r) => expect(r.body.error.code).toBe('email_taken'));

    const edited = (
      await admin
        .patch(`/v1/admin/users/${made.id}`, { displayName: 'Renamed', role: 'admin' })
        .expect(200)
    ).body;
    expect(edited).toMatchObject({ displayName: 'Renamed', role: 'admin' });
    await admin
      .patch(`/v1/admin/users/${made.id}`, { username: admin.username })
      .expect(409)
      .expect((r) => expect(r.body.error.code).toBe('username_taken'));
    await admin
      .patch(`/v1/admin/users/${admin.id}`, { role: 'player' })
      .expect(409)
      .expect((r) => expect(r.body.error.code).toBe('own_role'));

    await admin.del(`/v1/admin/users/${made.id}`).expect(204);
    expect((await admin.get(`/v1/admin/users/${made.id}`)).body.state).toBe('deleted');
    await http()
      .post('/v1/auth/login')
      .send({ email: `new_${id}@example.com`, password: 'long enough pw' })
      .expect(401);
    await admin.del(`/v1/admin/users/${made.id}`).expect(404);
    await admin.del(`/v1/admin/users/${admin.id}`).expect(409);
  });
});

describe('dashboard metrics', () => {
  it('has a row per day, top games and totals', async () => {
    const admin = await player({ admin: true });
    const to = new Date();
    const from = new Date(to.getTime() - 7 * 24 * 3600_000);
    const m = (
      await admin
        .get(`/v1/admin/metrics?from=${from.toISOString()}&to=${to.toISOString()}`)
        .expect(200)
    ).body;
    expect(m.series.length).toBeGreaterThanOrEqual(7);
    expect(m.series.at(-1)).toMatchObject({ day: expect.stringMatching(/^\d{4}-\d{2}-\d{2}$/) });
    expect(
      m.series.reduce((n: number, d: { signups: number }) => n + d.signups, 0),
    ).toBeGreaterThan(0);
    expect(m.totals).toMatchObject({ players: expect.any(Number), games: expect.any(Number) });
    expect(m.totals.games).toBeGreaterThan(40);
    expect(Array.isArray(m.topGames)).toBe(true);
  });
});
