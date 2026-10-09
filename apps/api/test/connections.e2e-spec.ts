import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { checkInDueAt } from '../src/connections/connections.service.js';
import { createDb } from '../src/db/db.js';
import {
  blocks,
  checkIns,
  connectionRequests,
  listings,
  notifications,
  users,
} from '../src/db/schema/index.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Connections", docs/DATA_MODEL.md "Accepting a request from a listing" and "Limits".

let app: INestApplication<App>;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => ({ app } = await createTestApp()));
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

/** A live, verified player with pubg on their profile. */
async function player({ verified = true } = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `c_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Dawit ${id}`,
      username: `dawit_${id}`,
      ageRange: '18_24',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const userId = res.body.user.id as string;
  await http()
    .put('/v1/me/games')
    .set(auth)
    .send({ games: [{ gameId: 'pubg' }] })
    .expect(200);
  await http().post('/v1/me/onboard').set(auth).expect(204);
  if (verified) {
    await conn.db.update(users).set({ emailVerifiedAt: new Date() }).where(eq(users.id, userId));
  }
  const p = {
    id: userId,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
    del: (path: string) => http().delete(path).set(auth),
    /** Sends a connection request to `to`, expecting 201. */
    ask: async (to: { id: string }, extra: object = {}) =>
      (await p.post('/v1/connection-requests', { toUserId: to.id, ...extra }).expect(201)).body,
    /** Posts a live pubg listing. */
    list: async (partySize = 4) =>
      (
        await p
          .post('/v1/listings', {
            gameId: 'pubg',
            platform: 'mobile',
            partySize,
            voice: 'optional',
            style: 'casual',
            playWhen: 'now',
            durationHours: 2,
          })
          .expect(201)
      ).body,
  };
  return p;
}

const notified = (userId: string, type: 'connection_request' | 'connection_accepted') =>
  conn.db
    .select()
    .from(notifications)
    .where(and(eq(notifications.userId, userId), eq(notifications.type, type)));

describe('sending a request', () => {
  it('from a profile: pending, listed both ways, and the other person is notified', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b, { message: '  run some ranked? ' });
    expect(req).toMatchObject({
      from: { id: a.id },
      to: { id: b.id },
      listing: null,
      message: 'run some ranked?',
      status: 'pending',
    });
    expect((await a.get('/v1/connection-requests?direction=outgoing')).body.items[0].id).toBe(
      req.id,
    );
    expect((await b.get('/v1/connection-requests')).body.items[0].id).toBe(req.id);
    expect(await notified(b.id, 'connection_request')).toHaveLength(1);
    expect((await a.get(`/v1/users/${b.username}`)).body.relationship).toBe('outgoing_request');
  });

  it('refuses yourself, people you can’t see, and unverified senders', async () => {
    const a = await player();
    const b = await player();
    await a.post('/v1/connection-requests', { toUserId: a.id }).expect(422);
    await conn.db.insert(blocks).values({ blockerId: b.id, blockedId: a.id });
    await a.post('/v1/connection-requests', { toUserId: b.id }).expect(404);
    const unverified = await player({ verified: false });
    const res = await unverified.post('/v1/connection-requests', { toUserId: a.id }).expect(403);
    expect(res.body.error.code).toBe('email_not_verified');
  });

  it('refuses a second request, and points to theirs when they asked first', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b);
    const again = await a.post('/v1/connection-requests', { toUserId: b.id }).expect(409);
    expect(again.body.error.code).toBe('request_pending');
    const back = await b.post('/v1/connection-requests', { toUserId: a.id }).expect(409);
    expect(back.body.error).toMatchObject({
      code: 'request_waiting_for_you',
      fields: { requestId: req.id },
    });
  });

  it('needs the listing to be theirs and still open', async () => {
    const a = await player();
    const b = await player();
    const c = await player();
    const cListing = await c.list();
    await a.post('/v1/connection-requests', { toUserId: b.id, listingId: cListing.id }).expect(422);
    const bListing = await b.list();
    await b.post(`/v1/listings/${bListing.id}/close`).expect(200);
    const res = await a
      .post('/v1/connection-requests', { toUserId: b.id, listingId: bListing.id })
      .expect(409);
    expect(res.body.error.code).toBe('listing_not_open');
  });

  it('allows 30 a day', async () => {
    const a = await player();
    const b = await player();
    const others = await conn.db.select({ id: users.id }).from(users).limit(31);
    await conn.db.insert(connectionRequests).values(
      others
        .filter((o) => o.id !== a.id && o.id !== b.id)
        .slice(0, 30)
        .map((o) => ({ fromUserId: a.id, toUserId: o.id, status: 'cancelled' as const })),
    );
    const res = await a.post('/v1/connection-requests', { toUserId: b.id }).expect(429);
    expect(res.body.error.code).toBe('daily_limit');
  });
});

describe('accepting', () => {
  it('connects, unlocks gaming IDs, fills the listing and schedules both check-ins', async () => {
    const owner = await player();
    const joiner = await player();
    await owner
      .put('/v1/me/gaming-ids', { gamingIds: [{ kind: 'riot', value: 'Owner#ET1' }] })
      .expect(200);
    expect((await joiner.get(`/v1/users/${owner.username}`)).body.gamingIds).toEqual([]);
    const listing = await owner.list(2);
    const req = await joiner.ask(owner, { listingId: listing.id });
    expect(req.listing).toMatchObject({ id: listing.id, myRequest: { id: req.id } });

    const before = Date.now();
    const { body } = await owner.post(`/v1/connection-requests/${req.id}/accept`).expect(200);
    expect(body.request.status).toBe('accepted');
    expect(body.connection.user.id).toBe(joiner.id);

    const profile = (await joiner.get(`/v1/users/${owner.username}`)).body;
    expect(profile.relationship).toBe('connected');
    expect(profile.gamingIds.map((g: { value: string }) => g.value)).toEqual(['Owner#ET1']);

    const after = (await owner.get(`/v1/listings/${listing.id}`)).body;
    expect(after).toMatchObject({ filled: 1, status: 'full' });

    const rows = await conn.db.select().from(checkIns).where(eq(checkIns.listingId, listing.id));
    expect(rows.map((r) => [r.userId, r.otherUserId]).sort()).toEqual(
      [
        [owner.id, joiner.id],
        [joiner.id, owner.id],
      ].sort(),
    );
    expect(rows[0]!.dueAt.getTime()).toBe(checkInDueAt(new Date(before)).getTime());
    expect(await notified(joiner.id, 'connection_accepted')).toHaveLength(1);
  });

  it('still connects when the listing filled up meanwhile, without overfilling it', async () => {
    const owner = await player();
    const first = await player();
    const second = await player();
    const listing = await owner.list(2);
    const r1 = await first.ask(owner, { listingId: listing.id });
    const r2 = await second.ask(owner, { listingId: listing.id });
    await owner.post(`/v1/connection-requests/${r1.id}/accept`).expect(200);
    await owner.post(`/v1/connection-requests/${r2.id}/accept`).expect(200);
    const row = await conn.db.query.listings.findFirst({ where: eq(listings.id, listing.id) });
    expect(row).toMatchObject({ filled: 1, status: 'full' });
    expect((await second.get(`/v1/users/${owner.username}`)).body.relationship).toBe('connected');
  });

  it('is only for the recipient, and only once', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b);
    await a.post(`/v1/connection-requests/${req.id}/accept`).expect(404);
    await b.post(`/v1/connection-requests/${req.id}/accept`).expect(200);
    const again = await b.post(`/v1/connection-requests/${req.id}/accept`).expect(409);
    expect(again.body.error.code).toBe('request_not_pending');
    await a.post('/v1/connection-requests', { toUserId: b.id }).expect(409);
  });
});

describe('declining and cancelling', () => {
  it('declined senders wait 7 days to ask again', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b);
    await b.post(`/v1/connection-requests/${req.id}/decline`).expect(204);
    const res = await a.post('/v1/connection-requests', { toUserId: b.id }).expect(429);
    expect(res.body.error.code).toBe('request_cooldown');
    await conn.db
      .update(connectionRequests)
      .set({ respondedAt: new Date(Date.now() - 8 * 24 * 3600_000) })
      .where(eq(connectionRequests.id, req.id));
    await a.ask(b);
  });

  it('only the sender cancels, and only while pending', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b);
    await b.del(`/v1/connection-requests/${req.id}`).expect(404);
    await a.del(`/v1/connection-requests/${req.id}`).expect(204);
    await a.del(`/v1/connection-requests/${req.id}`).expect(409);
    expect((await b.get('/v1/connection-requests')).body.items).toEqual([]);
  });
});

describe('connections', () => {
  it('lists yours newest first with paging, and removes one', async () => {
    const me = await player();
    const friends = [await player(), await player(), await player()];
    for (const f of friends) {
      const req = await f.ask(me);
      await me.post(`/v1/connection-requests/${req.id}/accept`).expect(200);
    }
    const first = (await me.get('/v1/me/connections?limit=2').expect(200)).body;
    const second = (await me.get(`/v1/me/connections?limit=2&cursor=${first.nextCursor}`)).body;
    expect(
      [...first.items, ...second.items].map((c: { user: { id: string } }) => c.user.id),
    ).toEqual(friends.map((f) => f.id).reverse());
    expect(second.nextCursor).toBeNull();

    await me.del(`/v1/connections/${friends[0]!.id}`).expect(204);
    await me.del(`/v1/connections/${friends[0]!.id}`).expect(404);
    expect((await friends[0]!.get('/v1/me/connections')).body.items).toEqual([]);
    expect((await me.get('/v1/me')).body.stats.connections).toBe(2);
  });
});
