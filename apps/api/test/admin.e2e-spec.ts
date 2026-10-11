import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import {
  adminActions,
  checkIns,
  games,
  listings,
  notifications,
  users,
} from '../src/db/schema/index.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Admin", docs/DATA_MODEL.md "The metric".

let app: INestApplication<App>;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => ({ app } = await createTestApp()));
afterAll(async () => {
  await conn.db.update(games).set({ isLaunch: true }).where(eq(games.id, 'efootball'));
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

async function player({ admin = false, live = true } = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `a_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Abebe ${id}`,
      username: `abebe_${id}`,
      ageRange: '25_34',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const userId = res.body.user.id as string;
  if (live) {
    await http()
      .put('/v1/me/games')
      .set(auth)
      .send({ games: [{ gameId: 'pubg' }] })
      .expect(200);
    await http().post('/v1/me/onboard').set(auth).expect(204);
  }
  await conn.db
    .update(users)
    .set({ emailVerifiedAt: new Date(), role: admin ? 'admin' : 'player' })
    .where(eq(users.id, userId));
  return {
    id: userId,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    patch: (path: string, body: object) => http().patch(path).set(auth).send(body),
    list: async (gameId = 'pubg') =>
      (
        await http()
          .post('/v1/listings')
          .set(auth)
          .send({
            gameId,
            platform: 'mobile',
            partySize: 2,
            voice: 'optional',
            style: 'casual',
            playWhen: 'now',
            durationHours: 2,
          })
          .expect(201)
      ).body,
  };
}

const audit = (kind: (typeof adminActions.$inferSelect)['kind'], targetUserId: string) =>
  conn.db
    .select()
    .from(adminActions)
    .where(and(eq(adminActions.kind, kind), eq(adminActions.targetUserId, targetUserId)));

describe('access', () => {
  it('is for admins only, who need no gamer profile', async () => {
    const p = await player();
    expect((await p.get('/v1/admin/reports').expect(403)).body.error.code).toBe('admin_only');
    const admin = await player({ admin: true, live: false });
    await admin.get('/v1/admin/reports').expect(200);
  });
});

describe('reports queue', () => {
  it('shows open reports with both people, and resolving with warn tells the reporter', async () => {
    const admin = await player({ admin: true });
    const reporter = await player();
    const target = await player();
    await reporter
      .post('/v1/reports', { userId: target.id, reason: 'spam', details: 'ads' })
      .expect(204);

    const open = (await admin.get('/v1/admin/reports?limit=50')).body.items;
    const mine = open.find((r: { reporter: { id: string } }) => r.reporter.id === reporter.id);
    expect(mine).toMatchObject({
      target: { id: target.id, state: 'active', openReports: 1 },
      reason: 'spam',
      details: 'ads',
      status: 'open',
    });

    const done = (
      await admin
        .post(`/v1/admin/reports/${mine.id}/resolve`, { action: 'warn', note: 'first warning' })
        .expect(200)
    ).body;
    expect(done).toMatchObject({ status: 'actioned', resolutionNote: 'first warning' });
    expect(await audit('warn', target.id)).toHaveLength(1);
    const told = await conn.db
      .select()
      .from(notifications)
      .where(and(eq(notifications.userId, reporter.id), eq(notifications.type, 'report_resolved')));
    expect(told).toHaveLength(1);
    expect(
      (
        await admin
          .post(`/v1/admin/reports/${mine.id}/resolve`, { action: 'dismiss', note: '' })
          .expect(409)
      ).body.error.code,
    ).toBe('report_closed');
  });

  it('ban from a report signs them out and removes their listing', async () => {
    const admin = await player({ admin: true });
    const reporter = await player();
    const target = await player();
    const listing = await target.list();
    await reporter.post('/v1/reports', { userId: target.id, reason: 'harassment' }).expect(204);
    const report = (await admin.get('/v1/admin/reports?limit=50')).body.items.find(
      (r: { target: { id: string } }) => r.target.id === target.id,
    );
    await admin
      .post(`/v1/admin/reports/${report.id}/resolve`, { action: 'ban', note: 'slurs in voice' })
      .expect(200);

    await target.get('/v1/me').expect(401);
    await reporter.get(`/v1/users/${target.username}`).expect(404);
    const row = await conn.db.query.listings.findFirst({ where: eq(listings.id, listing.id) });
    expect(row!.status).toBe('removed');
    expect((await admin.get(`/v1/admin/users/${target.id}`)).body).toMatchObject({
      state: 'banned',
      banReason: 'slurs in voice',
    });
  });

  it('removes the reported listing, and needs one to do so', async () => {
    const admin = await player({ admin: true });
    const reporter = await player();
    const target = await player();
    await reporter.post('/v1/reports', { userId: target.id, reason: 'spam' }).expect(204);
    const listing = await target.list();
    await reporter
      .post('/v1/reports', { userId: target.id, listingId: listing.id, reason: 'spam' })
      .expect(204);
    const [noListing, withListing] = (
      await admin.get('/v1/admin/reports?limit=50')
    ).body.items.filter((r: { target: { id: string } }) => r.target.id === target.id);
    await admin
      .post(`/v1/admin/reports/${noListing.id}/resolve`, { action: 'remove_listing', note: '' })
      .expect(422);
    await admin
      .post(`/v1/admin/reports/${withListing.id}/resolve`, {
        action: 'remove_listing',
        note: 'spam',
      })
      .expect(200);
    expect((await reporter.get(`/v1/listings/${listing.id}`)).status).toBe(404);
  });
});

describe('users', () => {
  it('bans and unbans directly, never yourself', async () => {
    const admin = await player({ admin: true });
    const target = await player();
    expect(
      (await admin.post(`/v1/admin/users/${target.id}/ban`, { reason: 'scam links' }).expect(200))
        .body.state,
    ).toBe('banned');
    expect(
      (await admin.post(`/v1/admin/users/${target.id}/unban`, { note: 'appeal ok' }).expect(200))
        .body.state,
    ).toBe('active');
    expect(await audit('ban', target.id)).toHaveLength(1);
    expect(await audit('unban', target.id)).toHaveLength(1);
    await admin.post(`/v1/admin/users/${admin.id}/ban`, { reason: 'x' }).expect(422);
  });

  it('searches by username and filters by state', async () => {
    const admin = await player({ admin: true });
    const target = await player();
    const found = (await admin.get(`/v1/admin/users?query=${target.username}`)).body.items;
    expect(found.map((u: { id: string }) => u.id)).toEqual([target.id]);
    expect(found[0]).toMatchObject({ mainGame: 'PUBG Mobile', onboarded: true });
    expect(
      (await admin.get(`/v1/admin/users?query=${target.username}&state=banned`)).body.items,
    ).toEqual([]);
  });
});

describe('games', () => {
  it('takes a game off Find Players', async () => {
    const admin = await player({ admin: true });
    const p = await player();
    await admin.patch('/v1/admin/games/efootball', { isLaunch: false }).expect(204);
    await p
      .post('/v1/listings', {
        gameId: 'efootball',
        platform: 'mobile',
        partySize: 2,
        voice: 'optional',
        style: 'casual',
        playWhen: 'now',
        durationHours: 2,
      })
      .expect(422);
    await admin.patch('/v1/admin/games/efootball', { isLaunch: true }).expect(204);
    await p.list('efootball');
    await admin.patch('/v1/admin/games/nope', { isLaunch: true }).expect(404);
  });
});

describe('metrics', () => {
  it('counts listings, ones with a request, and ones that led to a game', async () => {
    const admin = await player({ admin: true });
    const from = new Date();
    const a = await player();
    const b = await player();
    const c = await player();
    const played = await a.list();
    await b.list();
    await c.list();
    await b.post('/v1/connection-requests', { toUserId: a.id, listingId: played.id }).expect(201);
    await conn.db.insert(checkIns).values({
      userId: a.id,
      otherUserId: b.id,
      listingId: played.id,
      dueAt: new Date(),
      answer: 'played',
    });
    const to = new Date(Date.now() + 1000);
    const m = (
      await admin
        .get(`/v1/admin/metrics?from=${from.toISOString()}&to=${to.toISOString()}`)
        .expect(200)
    ).body;
    expect(m).toMatchObject({ listings: 3, listingsWithRequest: 1, listingsPlayed: 1 });
    expect(m.playedRate).toBeCloseTo(1 / 3);
    expect(m.weeklyActive).toBeGreaterThanOrEqual(4);
  });
});
