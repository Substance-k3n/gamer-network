import { INestApplication } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { users } from '../src/db/schema/index.js';
import type { GameDto } from '../src/games/games.dto.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Me and onboarding".

let app: INestApplication<App>;
let catalog: GameDto[];
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => {
  ({ app } = await createTestApp());
  catalog = (await http().get('/v1/games').expect(200)).body;
});
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

async function signup() {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `me_${id}@example.com`,
      password: 'correct horse battery',
      displayName: 'Hana',
      username: `hana_${id}`,
      ageRange: '18_24',
    })
    .expect(201);
  const token = res.body.token as string;
  const auth = { Authorization: `Bearer ${token}` };
  return {
    id: res.body.user.id as string,
    username: res.body.user.username as string,
    get: () => http().get('/v1/me').set(auth),
    patch: (body: object) => http().patch('/v1/me').set(auth).send(body),
    put: (path: string, body: object) => http().put(`/v1/me/${path}`).set(auth).send(body),
    post: (path: string) => http().post(`/v1/me/${path}`).set(auth),
  };
}

const ranked = () => catalog.find((g) => g.hasRanks && g.ranks.length > 1)!;
const other = (not: GameDto) => catalog.find((g) => g.id !== not.id && g.ranks.length > 0)!;

describe('GET /v1/me', () => {
  it('is the full profile, empty for a new account', async () => {
    const p = await signup();
    const { body } = await p.get().expect(200);
    expect(body).toMatchObject({
      username: p.username,
      displayName: 'Hana',
      bio: null,
      status: 'not_available',
      statusGame: null,
      statusUntil: null,
      topGame: null,
      availableDays: [],
      games: [],
      platforms: [],
      tags: [],
      gamingIds: [],
      stats: { connections: 0, games: 0, playedWith: 0 },
      relationship: 'self',
      incomingRequestId: null,
      onboardedAt: null,
    });
  });

  it('is what sign-in returns too', async () => {
    const id = uniq();
    const res = await http()
      .post('/v1/auth/signup')
      .send({
        email: `same_${id}@example.com`,
        password: 'correct horse battery',
        displayName: 'Hana',
        username: `same_${id}`,
        ageRange: '18_24',
      })
      .expect(201);
    expect(res.body.user).toHaveProperty('games', []);
    expect(res.body.user).toHaveProperty('stats');
  });
});

describe('PATCH /v1/me', () => {
  it('changes only the fields sent', async () => {
    const p = await signup();
    const name = `new_${uniq()}`;
    const { body } = await p
      .patch({ displayName: '  Hana B ', username: name.toUpperCase(), bio: 'Support main' })
      .expect(200);
    expect(body).toMatchObject({
      displayName: 'Hana B',
      username: name,
      bio: 'Support main',
      ageRange: '18_24',
    });
  });

  it('clears the bio with an empty string', async () => {
    const p = await signup();
    await p.patch({ bio: 'x' }).expect(200);
    expect((await p.patch({ bio: '' }).expect(200)).body.bio).toBeNull();
  });

  it('refuses null for required fields', async () => {
    const p = await signup();
    const res = await p.patch({ displayName: null, ageRange: null }).expect(422);
    expect(Object.keys(res.body.error.fields)).toEqual(
      expect.arrayContaining(['displayName', 'ageRange']),
    );
  });

  it('409s on a taken username', async () => {
    const a = await signup();
    const b = await signup();
    const res = await b.patch({ username: a.username }).expect(409);
    expect(res.body.error.code).toBe('username_taken');
  });
});

describe('PUT /v1/me/games', () => {
  it('stores catalog and custom games in order', async () => {
    const p = await signup();
    const g = ranked();
    const rank = g.ranks.at(-1)!;
    const { body } = await p
      .put('games', {
        games: [
          { gameId: g.id, rankId: rank.id },
          { customGameName: 'Dota Underlords', rankText: 'Lord' },
        ],
      })
      .expect(200);
    expect(body.games[0]).toMatchObject({
      game: { id: g.id, name: g.name, shortCode: g.shortCode },
      customGameName: null,
      rank: { id: rank.id, name: rank.name, tier: rank.tier },
      rankText: null,
    });
    expect(body.games[1]).toMatchObject({
      game: null,
      customGameName: 'Dota Underlords',
      rank: null,
      rankText: 'Lord',
    });
    expect(body.topGame).toEqual(body.games[0]);
    expect(body.stats.games).toBe(body.games.length);
  });

  it('replaces the whole list', async () => {
    const p = await signup();
    await p.put('games', { games: [{ gameId: ranked().id }] }).expect(200);
    const { body } = await p.put('games', { games: [{ customGameName: 'Chess' }] }).expect(200);
    expect(body.games).toHaveLength(1);
    expect(body.games[0].customGameName).toBe('Chess');
  });

  it('refuses a rank from another game, ranks on custom games and duplicates', async () => {
    const p = await signup();
    const g = ranked();
    const res = await p
      .put('games', {
        games: [
          { gameId: g.id, rankId: other(g).ranks[0]!.id },
          { gameId: g.id },
          { customGameName: 'Chess', rankId: g.ranks[0]!.id },
          { gameId: 'no-such-game' },
          { gameId: other(g).id, rankText: 'Pro', roleId: g.ranks[0]!.id },
        ],
      })
      .expect(422);
    expect(res.body.error.fields).toMatchObject({
      'games.0.rankId': expect.any(String),
      'games.1': 'Already in your list',
      'games.2.rankId': expect.any(String),
      'games.3.gameId': 'Unknown game',
      'games.4.rankText': expect.any(String),
      'games.4.roleId': 'Not a role of this game',
    });
  });

  it('needs a game id or a name', async () => {
    const p = await signup();
    const res = await p.put('games', { games: [{}] }).expect(422);
    expect(res.body.error.fields).toHaveProperty(['games.0.gameId']);
  });
});

describe('platforms, tags and gaming IDs', () => {
  it('replaces platforms and tags', async () => {
    const p = await signup();
    await p.put('platforms', { platforms: ['pc', 'mobile'] }).expect(200);
    const { body } = await p.put('tags', { tags: ['fps', 'competitive'] }).expect(200);
    expect(body.platforms.sort()).toEqual(['mobile', 'pc']);
    expect(body.tags.sort()).toEqual(['competitive', 'fps']);
  });

  it('allows at most 6 tags', async () => {
    const p = await signup();
    const tags = ['competitive', 'casual', 'fps', 'rpg', 'strategy', 'co_op', 'ranked'];
    await p.put('tags', { tags }).expect(422);
  });

  it('stores gaming IDs, private to connections by default', async () => {
    const p = await signup();
    const g = ranked();
    const { body } = await p
      .put('gaming-ids', {
        gamingIds: [
          { kind: 'discord', value: 'hana#1' },
          { kind: 'in_game', gameId: g.id, value: '5123456789', visibility: 'public' },
        ],
      })
      .expect(200);
    expect(body.gamingIds).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ kind: 'discord', game: null, visibility: 'connections' }),
        expect.objectContaining({ kind: 'in_game', game: expect.objectContaining({ id: g.id }) }),
      ]),
    );
  });

  it('needs a game for in-game IDs', async () => {
    const p = await signup();
    const res = await p.put('gaming-ids', { gamingIds: [{ kind: 'in_game', value: '1' }] });
    expect(res.status).toBe(422);
    expect(res.body.error.fields).toHaveProperty(['gamingIds.0.gameId']);
  });

  it('refuses a game on other IDs, and the same ID twice', async () => {
    const p = await signup();
    const res = await p
      .put('gaming-ids', {
        gamingIds: [
          { kind: 'steam', gameId: ranked().id, value: '2' },
          { kind: 'discord', value: 'a' },
          { kind: 'discord', value: 'b' },
        ],
      })
      .expect(422);
    expect(res.body.error.fields).toMatchObject({
      'gamingIds.0.gameId': 'Only in-game IDs take a game',
      'gamingIds.2': 'You already added this ID',
    });
  });
});

describe('PUT /v1/me/status', () => {
  it('sets a status that clears itself, with a game and days', async () => {
    const p = await signup();
    const g = ranked();
    const { body } = await p
      .put('status', { status: 'available_tonight', gameId: g.id, availableDays: ['sat', 'mon'] })
      .expect(200);
    expect(body.status).toBe('available_tonight');
    expect(body.statusGame).toMatchObject({ id: g.id });
    expect(new Date(body.statusUntil).getTime()).toBeGreaterThan(Date.now());
    expect(body.availableDays).toEqual(['mon', 'sat']);
  });

  it('shows not_available once the time has passed', async () => {
    const p = await signup();
    await p.put('status', { status: 'playing', gameId: ranked().id }).expect(200);
    await conn.db
      .update(users)
      .set({ statusUntil: new Date(Date.now() - 1000) })
      .where(eq(users.id, p.id));
    const { body } = await p.get().expect(200);
    expect(body).toMatchObject({ status: 'not_available', statusGame: null, statusUntil: null });
  });

  it('not_available drops the game and keeps the days', async () => {
    const p = await signup();
    await p.put('status', { status: 'looking', gameId: ranked().id, availableDays: ['fri'] });
    const { body } = await p.put('status', { status: 'not_available', gameId: ranked().id });
    expect(body).toMatchObject({ statusGame: null, statusUntil: null, availableDays: ['fri'] });
  });
});

describe('POST /v1/me/onboard', () => {
  it('needs at least one game', async () => {
    const p = await signup();
    const res = await p.post('onboard').expect(422);
    expect(res.body.error.code).toBe('profile_incomplete');
  });

  it('goes live once, and is safe to repeat', async () => {
    const p = await signup();
    await p.put('games', { games: [{ gameId: ranked().id }] }).expect(200);
    await p.post('onboard').expect(204);
    const first = (await p.get()).body.onboardedAt;
    expect(first).not.toBeNull();
    await p.post('onboard').expect(204);
    expect((await p.get()).body.onboardedAt).toBe(first);
  });
});
