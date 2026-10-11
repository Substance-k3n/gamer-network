import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { orderedPair } from '../src/connections/connections.service.js';
import { createDb } from '../src/db/db.js';
import {
  connectionRequests,
  connections,
  gamingIds,
  listings,
  playInvites,
  reports,
  users,
  waitlist,
} from '../src/db/schema/index.js';
import { JobRunner } from '../src/jobs/jobs.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Safety", docs/DATA_MODEL.md "Blocks" and account deletion.

let app: INestApplication<App>;
let jobs: JobRunner;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => {
  ({ app } = await createTestApp());
  jobs = app.get(JobRunner);
});
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());
const PASSWORD = 'correct horse battery';

async function player() {
  const id = uniq();
  const email = `s_${id}@example.com`;
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email,
      password: PASSWORD,
      displayName: 'Mekdes',
      username: `mek_${id}`,
      ageRange: '25_34',
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
  await conn.db.update(users).set({ emailVerifiedAt: new Date() }).where(eq(users.id, userId));
  return {
    id: userId,
    email,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
    del: (path: string, body?: object) => http().delete(path).set(auth).send(body),
  };
}

async function connect(x: string, y: string) {
  const [userAId, userBId] = orderedPair(x, y);
  await conn.db.insert(connections).values({ userAId, userBId });
}

describe('blocking', () => {
  it('hides both ways, ends the connection and withdraws everything pending', async () => {
    const me = await player();
    const them = await player();
    await connect(me.id, them.id);
    const invite = (
      await them
        .post('/v1/play-invites', { toUserId: me.id, gameId: 'pubg', playWhen: 'now' })
        .expect(201)
    ).body;
    await conn.db
      .delete(connections)
      .where(eq(connections.userAId, orderedPair(me.id, them.id)[0]));
    const req = (await them.post('/v1/connection-requests', { toUserId: me.id }).expect(201)).body;

    await me.post('/v1/blocks', { userId: them.id }).expect(204);
    await me.post('/v1/blocks', { userId: them.id }).expect(204);

    await me.get(`/v1/users/${them.username}`).expect(404);
    await them.get(`/v1/users/${me.username}`).expect(404);
    const r = await conn.db.query.connectionRequests.findFirst({
      where: eq(connectionRequests.id, req.id),
    });
    expect(r!.status).toBe('cancelled');
    const i = await conn.db.query.playInvites.findFirst({ where: eq(playInvites.id, invite.id) });
    expect(i!.status).toBe('declined');
    expect((await me.get('/v1/me/blocks')).body.items.map((u: { id: string }) => u.id)).toEqual([
      them.id,
    ]);
  });

  it('removes the connection itself', async () => {
    const me = await player();
    const them = await player();
    await connect(me.id, them.id);
    await me.post('/v1/blocks', { userId: them.id }).expect(204);
    expect((await them.get('/v1/me/connections')).body.items).toEqual([]);
  });

  it('can be undone', async () => {
    const me = await player();
    const them = await player();
    await me.post('/v1/blocks', { userId: them.id }).expect(204);
    await me.del(`/v1/blocks/${them.id}`).expect(204);
    await me.del(`/v1/blocks/${them.id}`).expect(404);
    await me.get(`/v1/users/${them.username}`).expect(200);
  });

  it('refuses yourself and unknown people', async () => {
    const me = await player();
    await me.post('/v1/blocks', { userId: me.id }).expect(422);
    await me.post('/v1/blocks', { userId: '01890000-0000-7000-8000-000000000000' }).expect(404);
  });
});

describe('reports and the waitlist', () => {
  it('files a report for the admin queue', async () => {
    const me = await player();
    const them = await player();
    await me
      .post('/v1/reports', { userId: them.id, reason: 'harassment', details: '  rude in voice ' })
      .expect(204);
    const [row] = await conn.db.select().from(reports).where(eq(reports.reporterId, me.id));
    expect(row).toMatchObject({
      targetUserId: them.id,
      reason: 'harassment',
      details: 'rude in voice',
      status: 'open',
    });
  });

  it("checks the listing is theirs, and that it isn't you", async () => {
    const me = await player();
    const them = await player();
    const other = await player();
    const listing = (
      await other
        .post('/v1/listings', {
          gameId: 'pubg',
          platform: 'mobile',
          partySize: 2,
          voice: 'optional',
          style: 'casual',
          playWhen: 'now',
          durationHours: 2,
        })
        .expect(201)
    ).body;
    await me
      .post('/v1/reports', { userId: them.id, listingId: listing.id, reason: 'spam' })
      .expect(422);
    await me.post('/v1/reports', { userId: me.id, reason: 'spam' }).expect(422);
  });

  it('joins a waitlist once', async () => {
    const me = await player();
    await me.post('/v1/waitlist', { topic: 'groups' }).expect(204);
    await me.post('/v1/waitlist', { topic: 'groups' }).expect(204);
    const rows = await conn.db.select().from(waitlist).where(eq(waitlist.userId, me.id));
    expect(rows).toHaveLength(1);
  });
});

describe('deleting an account', () => {
  it('needs the password, then signs out, closes the listing and disappears', async () => {
    const me = await player();
    const friend = await player();
    await connect(me.id, friend.id);
    const listing = (
      await me
        .post('/v1/listings', {
          gameId: 'pubg',
          platform: 'mobile',
          partySize: 2,
          voice: 'optional',
          style: 'casual',
          playWhen: 'now',
          durationHours: 2,
        })
        .expect(201)
    ).body;
    expect((await me.del('/v1/me', { password: 'nope nope' }).expect(401)).body.error.code).toBe(
      'wrong_password',
    );
    await me.del('/v1/me', {}).expect(401);
    await me.del('/v1/me', { password: PASSWORD }).expect(204);

    await me.get('/v1/me').expect(401);
    await http().post('/v1/auth/login').send({ email: me.email, password: PASSWORD }).expect(401);
    await friend.get(`/v1/users/${me.username}`).expect(404);
    expect((await friend.get('/v1/me/connections')).body.items).toEqual([]);
    const row = await conn.db.query.listings.findFirst({ where: eq(listings.id, listing.id) });
    expect(row!.status).toBe('closed');
  });

  it('works without a password for Google-only accounts', async () => {
    const id = uniq();
    const res = await http()
      .post('/v1/auth/google')
      .send({
        idToken: `google:${id}:g_${id}@example.com`,
        username: `goo_${id}`,
        ageRange: '18_24',
      })
      .expect(200);
    await http()
      .delete('/v1/me')
      .set('Authorization', `Bearer ${res.body.token}`)
      .send({})
      .expect(204);
  });

  it('erases personal data 30 days later', async () => {
    const me = await player();
    await me
      .put('/v1/me/gaming-ids', { gamingIds: [{ kind: 'discord', value: 'me#1' }] })
      .expect(200);
    await me.del('/v1/me', { password: PASSWORD }).expect(204);
    await conn.db
      .update(users)
      .set({ deletedAt: new Date(Date.now() - 31 * 24 * 3600_000) })
      .where(eq(users.id, me.id));
    await jobs.runOnce('account-scrub');
    const row = await conn.db.query.users.findFirst({ where: eq(users.id, me.id) });
    expect(row).toMatchObject({
      email: `${me.id}@deleted.invalid`,
      displayName: 'Deleted player',
      bio: null,
      passwordHash: null,
    });
    expect(row!.username).toMatch(/^deleted_[0-9a-f]{12}$/);
    expect(await conn.db.select().from(gamingIds).where(eq(gamingIds.userId, me.id))).toEqual([]);
    // The address can sign up again.
    await http()
      .post('/v1/auth/signup')
      .send({
        email: me.email,
        password: PASSWORD,
        displayName: 'Back',
        username: `back_${uniq()}`,
        ageRange: '25_34',
      })
      .expect(201);
  });

  it('keeps accounts deleted less than 30 days ago', async () => {
    const me = await player();
    await me.del('/v1/me', { password: PASSWORD }).expect(204);
    await jobs.runOnce('account-scrub');
    const row = await conn.db.query.users.findFirst({
      where: and(eq(users.id, me.id), eq(users.email, me.email)),
    });
    expect(row).toBeDefined();
  });
});
