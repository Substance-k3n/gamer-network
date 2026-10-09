import { INestApplication } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { blocks, connectionRequests, connections, users } from '../src/db/schema/index.js';
import type { GameDto } from '../src/games/games.dto.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "People", docs/DATA_MODEL.md "Gaming ID visibility" and "Blocks".

let app: INestApplication<App>;
let game: GameDto;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => {
  ({ app } = await createTestApp());
  game = (await http().get('/v1/games').expect(200)).body.find((g: GameDto) => g.hasRanks);
});
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

/** A signed-up player; live (onboarded with one game) unless `live` is false. */
async function player(name = 'player', live = true) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `${name}_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `${name} ${id}`,
      username: `${name}_${id}`,
      ageRange: '18_24',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const p = {
    id: res.body.user.id as string,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
  };
  if (live) {
    await p.put('/v1/me/games', { games: [{ gameId: game.id }] }).expect(200);
    await http().post('/v1/me/onboard').set(auth).expect(204);
  }
  return p;
}

const pair = (x: string, y: string) => (x < y ? [x, y] : [y, x]) as [string, string];
const connect = (x: string, y: string) => {
  const [userAId, userBId] = pair(x, y);
  return conn.db.insert(connections).values({ userAId, userBId });
};

describe('onboarding gate', () => {
  it('403s routes outside /me and /auth until "Go live"', async () => {
    const p = await player('new', false);
    const res = await p.get('/v1/users?query=ab').expect(403);
    expect(res.body.error.code).toBe('not_onboarded');
    await p.get('/v1/me').expect(200);
  });
});

describe('GET /v1/users/{username}', () => {
  it('shows a live profile with public gaming IDs only', async () => {
    const owner = await player('owner');
    const viewer = await player('viewer');
    await owner
      .put('/v1/me/gaming-ids', {
        gamingIds: [
          { kind: 'discord', value: 'secret#1' },
          { kind: 'steam', value: 'open', visibility: 'public' },
        ],
      })
      .expect(200);
    const { body } = await viewer.get(`/v1/users/${owner.username.toUpperCase()}`).expect(200);
    expect(body).toMatchObject({
      username: owner.username,
      relationship: 'none',
      incomingRequestId: null,
      stats: { games: 1 },
    });
    expect(body).not.toHaveProperty('email');
    expect(body.gamingIds.map((g: { value: string }) => g.value)).toEqual(['open']);
  });

  it('shows every gaming ID to a connection', async () => {
    const owner = await player('owner');
    const friend = await player('friend');
    await owner
      .put('/v1/me/gaming-ids', { gamingIds: [{ kind: 'discord', value: 'secret#1' }] })
      .expect(200);
    await connect(owner.id, friend.id);
    const { body } = await friend.get(`/v1/users/${owner.username}`).expect(200);
    expect(body.relationship).toBe('connected');
    expect(body.gamingIds).toHaveLength(1);
    expect(body.stats.connections).toBe(1);
  });

  it('tells incoming from outgoing requests', async () => {
    const a = await player('a');
    const b = await player('b');
    const [req] = await conn.db
      .insert(connectionRequests)
      .values({ fromUserId: a.id, toUserId: b.id })
      .returning();
    expect((await a.get(`/v1/users/${b.username}`)).body).toMatchObject({
      relationship: 'outgoing_request',
      incomingRequestId: null,
    });
    expect((await b.get(`/v1/users/${a.username}`)).body).toMatchObject({
      relationship: 'incoming_request',
      incomingRequestId: req!.id,
    });
  });

  it('is self for your own username', async () => {
    const p = await player('self');
    expect((await p.get(`/v1/users/${p.username}`)).body.relationship).toBe('self');
  });

  it('404s for blocks either way, people not live yet, banned and unknown users', async () => {
    const viewer = await player('viewer');
    const blocker = await player('blocker');
    const blocked = await player('blocked');
    const fresh = await player('fresh', false);
    const banned = await player('banned');
    await conn.db.insert(blocks).values([
      { blockerId: blocker.id, blockedId: viewer.id },
      { blockerId: viewer.id, blockedId: blocked.id },
    ]);
    await conn.db.update(users).set({ bannedAt: new Date() }).where(eq(users.id, banned.id));
    for (const name of [blocker.username, blocked.username, fresh.username, banned.username]) {
      const res = await viewer.get(`/v1/users/${name}`).expect(404);
      expect(res.body.error.code).toBe('not_found');
    }
    await viewer.get('/v1/users/nobody_here_at_all').expect(404);
  });
});

describe('GET /v1/users?query=', () => {
  it('finds people by username or display name prefix, never yourself', async () => {
    const tag = uniq();
    const me = await player(`s${tag}`);
    const other = await player(`s${tag}`);
    await other.put('/v1/me/status', { status: 'playing', gameId: game.id }).expect(200);
    const { body } = await me.get(`/v1/users?query=S${tag}`).expect(200);
    expect(body.items).toHaveLength(1);
    expect(body.items[0]).toMatchObject({
      username: other.username,
      status: 'playing',
      statusGame: { id: game.id },
      topGame: { game: { id: game.id } },
    });
    expect(body.items[0]).not.toHaveProperty('userId');
    expect(body.items[0].topGame).not.toHaveProperty('userId');
  });

  it('leaves out blocked people', async () => {
    const tag = uniq();
    const me = await player(`b${tag}`);
    const other = await player(`b${tag}`);
    await conn.db.insert(blocks).values({ blockerId: other.id, blockedId: me.id });
    expect((await me.get(`/v1/users?query=b${tag}`)).body.items).toEqual([]);
  });

  it('treats % and _ literally', async () => {
    const me = await player('pct');
    expect((await me.get('/v1/users?query=%25%25')).body.items).toEqual([]);
  });

  it('needs at least 2 characters', async () => {
    const me = await player('short');
    await me.get('/v1/users?query=a').expect(422);
    await me.get('/v1/users').expect(422);
  });
});
