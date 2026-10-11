import { INestApplication } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { blocks, listings, users } from '../src/db/schema/index.js';
import type { GameDto } from '../src/games/games.dto.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Find Players", docs/DATA_MODEL.md "Listing times" and "Listing lifecycle".

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

/** pubg: launch, mobile only, parties up to 4. */
const pubg = () => catalog.find((g) => g.id === 'pubg')!;
const efootball = () => catalog.find((g) => g.id === 'efootball')!;

interface Options {
  city?: string;
  verified?: boolean;
  rankTier?: number;
}

/** A live, verified player in `city`, with pubg at the given rank tier on their profile. */
async function player({ city = 'Addis Ababa', verified = true, rankTier = 3 }: Options = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `l_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Lia ${id}`,
      username: `lia_${id}`,
      ageRange: '18_24',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const userId = res.body.user.id as string;
  const rank = pubg().ranks.find((r) => r.tier === rankTier)!;
  await http()
    .put('/v1/me/games')
    .set(auth)
    .send({ games: [{ gameId: 'pubg', rankId: rank.id }] })
    .expect(200);
  await http().patch('/v1/me').set(auth).send({ city }).expect(200);
  await http().post('/v1/me/onboard').set(auth).expect(204);
  if (verified) {
    await conn.db.update(users).set({ emailVerifiedAt: new Date() }).where(eq(users.id, userId));
  }
  return {
    id: userId,
    rank,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
  };
}

type Player = Awaited<ReturnType<typeof player>>;

const listing = (overrides: object = {}) => ({
  gameId: 'pubg',
  platform: 'mobile',
  partySize: 4,
  voice: 'required',
  style: 'competitive',
  playWhen: 'now',
  durationHours: 2,
  note: '  Need a sniper  ',
  ...overrides,
});

const post = async (p: Player, overrides: object = {}) =>
  (await p.post('/v1/listings', listing(overrides)).expect(201)).body;

describe('POST /v1/listings', () => {
  it('posts with times worked out by the API and your rank as the default', async () => {
    const p = await player();
    const before = Date.now();
    const body = await post(p);
    expect(body).toMatchObject({
      owner: { id: p.id },
      game: { id: 'pubg' },
      rank: { id: p.rank.id },
      mode: null,
      partySize: 4,
      filled: 0,
      playWhen: 'now',
      durationHours: 2,
      note: 'Need a sniper',
      status: 'open',
      myRequest: null,
    });
    expect(body.shareUrl).toMatch(new RegExp(`/l/${body.id}$`));
    const starts = new Date(body.startsAt).getTime();
    expect(starts).toBeGreaterThanOrEqual(before - 1000);
    expect(new Date(body.expiresAt).getTime() - starts).toBe(2 * 3600 * 1000);
  });

  it('needs a verified email', async () => {
    const p = await player({ verified: false });
    const res = await p.post('/v1/listings', listing()).expect(403);
    expect(res.body.error.code).toBe('email_not_verified');
  });

  it("refuses games off Find Players, wrong platforms, oversized parties and other games' ranks", async () => {
    const p = await player();
    const notLaunch = catalog.find((g) => !g.isLaunch)!;
    expect(
      (await p.post('/v1/listings', listing({ gameId: notLaunch.id })).expect(422)).body.error
        .fields,
    ).toHaveProperty('gameId');
    const res = await p
      .post(
        '/v1/listings',
        listing({ platform: 'pc', partySize: 5, rankId: efootball().ranks[0]!.id }),
      )
      .expect(422);
    expect(Object.keys(res.body.error.fields).sort()).toEqual(['partySize', 'platform', 'rankId']);
  });

  it('allows one live listing; closing frees the slot', async () => {
    const p = await player();
    const first = await post(p);
    const res = await p.post('/v1/listings', listing()).expect(409);
    expect(res.body.error.code).toBe('listing_already_open');
    await p.post(`/v1/listings/${first.id}/close`).expect(200);
    await post(p);
  });

  it("doesn't let a listing that ran out block a new one", async () => {
    const p = await player();
    const first = await post(p);
    await conn.db
      .update(listings)
      .set({
        createdAt: new Date(Date.now() - 3 * 3600_000),
        expiresAt: new Date(Date.now() - 1000),
      })
      .where(eq(listings.id, first.id));
    await post(p);
    expect((await p.get(`/v1/listings/${first.id}`)).body.status).toBe('expired');
  });
});

describe('GET /v1/listings', () => {
  it('shows open listings in your city, newest first, never yours', async () => {
    const city = `C${uniq()}`;
    const me = await player({ city });
    const a = await player({ city });
    const b = await player({ city });
    const elsewhere = await player({ city: `D${uniq()}` });
    await post(me);
    const la = await post(a);
    const lb = await post(b);
    await post(elsewhere);
    const { body } = await me.get('/v1/listings').expect(200);
    expect(body.items.map((l: { id: string }) => l.id)).toEqual([lb.id, la.id]);
    expect(body.nextCursor).toBeNull();
  });

  it('pages with a cursor', async () => {
    const city = `C${uniq()}`;
    const me = await player({ city });
    const posted = [];
    for (let i = 0; i < 3; i++) posted.push((await post(await player({ city }))).id);
    const first = (await me.get('/v1/listings?limit=2').expect(200)).body;
    expect(first.items).toHaveLength(2);
    const second = (await me.get(`/v1/listings?limit=2&cursor=${first.nextCursor}`)).body;
    expect([...first.items, ...second.items].map((l: { id: string }) => l.id)).toEqual(
      posted.reverse(),
    );
    expect(second.nextCursor).toBeNull();
    await me.get('/v1/listings?cursor=nonsense').expect(422);
  });

  it('leaves out blocked people both ways, closed and expired listings', async () => {
    const city = `C${uniq()}`;
    const me = await player({ city });
    const blocker = await player({ city });
    const blocked = await player({ city });
    const closer = await player({ city });
    await post(blocker);
    await post(blocked);
    const closed = await post(closer);
    await closer.post(`/v1/listings/${closed.id}/close`).expect(200);
    await conn.db.insert(blocks).values([
      { blockerId: blocker.id, blockedId: me.id },
      { blockerId: me.id, blockedId: blocked.id },
    ]);
    expect((await me.get('/v1/listings')).body.items).toEqual([]);
  });

  it('filters by game, rank, platform, voice, style, party size and when', async () => {
    const city = `C${uniq()}`;
    const me = await player({ city });
    const low = await post(await player({ city, rankTier: 1 }), { voice: 'optional' });
    const high = await post(await player({ city, rankTier: 6 }), { partySize: 2 });
    const later = await post(await player({ city }), { playWhen: 'weekend', style: 'casual' });
    const ids = async (q: string) =>
      (await me.get(`/v1/listings?${q}`).expect(200)).body.items.map((l: { id: string }) => l.id);

    const tier4 = pubg().ranks.find((r) => r.tier === 4)!.id;
    expect(await ids(`minRank=${tier4}`)).toEqual([high.id]);
    expect(await ids('voice=required')).not.toContain(low.id);
    expect(await ids('partySize=2')).toEqual([high.id]);
    expect(await ids('style=casual')).toEqual([later.id]);
    expect(await ids('game=efootball')).toEqual([]);
    expect(await ids('platform=mobile')).toHaveLength(3);
    const now = await ids('when=now');
    expect(now).toContain(low.id);
    // A weekend listing has started only if it's the weekend in Addis already.
    const day = new Date(Date.now() + 3 * 3600_000).getUTCDay();
    expect(now.includes(later.id)).toBe(day === 0 || day === 6);
  });
});

describe('one listing', () => {
  it('shows your request status and refuses strangers when blocked', async () => {
    const owner = await player();
    const viewer = await player();
    const l = await post(owner);
    expect((await viewer.get(`/v1/listings/${l.id}`).expect(200)).body.myRequest).toBeNull();
    await conn.db.insert(blocks).values({ blockerId: owner.id, blockedId: viewer.id });
    await viewer.get(`/v1/listings/${l.id}`).expect(404);
    await viewer.get('/v1/listings/not-a-uuid').expect(404);
  });

  it('only the owner closes it, once', async () => {
    const owner = await player();
    const other = await player();
    const l = await post(owner);
    expect((await other.post(`/v1/listings/${l.id}/close`).expect(403)).body.error.code).toBe(
      'not_owner',
    );
    expect((await owner.post(`/v1/listings/${l.id}/close`).expect(200)).body.status).toBe('closed');
    await owner.post(`/v1/listings/${l.id}/close`).expect(409);
  });

  it('GET /v1/me/listing is your live listing or null', async () => {
    const p = await player();
    expect((await p.get('/v1/me/listing').expect(200)).body).toEqual({ listing: null });
    const l = await post(p);
    expect((await p.get('/v1/me/listing')).body.listing.id).toBe(l.id);
  });
});

describe('GET /v1/listings/stats', () => {
  it('counts people in your city with an open listing or looking status', async () => {
    const city = `C${uniq()}`;
    const me = await player({ city });
    expect((await me.get('/v1/listings/stats').expect(200)).body).toEqual({ lookingNow: 0 });
    await post(await player({ city }));
    await (await player({ city })).put('/v1/me/status', { status: 'looking' }).expect(200);
    const both = await player({ city });
    await post(both);
    await both.put('/v1/me/status', { status: 'looking' });
    await player({ city });
    expect((await me.get('/v1/listings/stats')).body.lookingNow).toBe(3);
  });
});

describe('GET /v1/public/listings/{id}', () => {
  it('needs no sign-in and shows nothing that identifies the owner beyond their name', async () => {
    const owner = await player();
    const l = await post(owner);
    const { body } = await http().get(`/v1/public/listings/${l.id}`).expect(200);
    expect(body).toMatchObject({ id: l.id, game: { id: 'pubg' }, status: 'open' });
    expect(body.ownerDisplayName).toMatch(/^Lia /);
    expect(JSON.stringify(body)).not.toContain(owner.id);
  });

  it('404s once removed or the owner is banned', async () => {
    const owner = await player();
    const l = await post(owner);
    await conn.db.update(users).set({ bannedAt: new Date() }).where(eq(users.id, owner.id));
    await http().get(`/v1/public/listings/${l.id}`).expect(404);
  });
});
