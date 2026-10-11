import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { idempotencyKeys, listings, reports, users } from '../src/db/schema/index.js';
import { JobRunner } from '../src/jobs/jobs.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Idempotency".

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

async function player() {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `i_${id}@example.com`,
      password: 'correct horse battery',
      displayName: 'Abel',
      username: `abel_${id}`,
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
  await conn.db.update(users).set({ emailVerifiedAt: new Date() }).where(eq(users.id, userId));
  return {
    id: userId,
    auth,
    post: (path: string, body: object, key?: string) => {
      const req = http().post(path).set(auth);
      if (key !== undefined) req.set('Idempotency-Key', key);
      return req.send(body);
    },
  };
}

const listing = (overrides: object = {}) => ({
  gameId: 'pubg',
  platform: 'mobile',
  partySize: 4,
  voice: 'required',
  style: 'competitive',
  playWhen: 'now',
  durationHours: 2,
  ...overrides,
});

const keyRow = (userId: string, key: string) =>
  and(eq(idempotencyKeys.userId, userId), eq(idempotencyKeys.key, key));

describe('Idempotency-Key', () => {
  it('returns the first listing on a retry instead of posting twice', async () => {
    const me = await player();
    const key = randomUUID();
    const first = (await me.post('/v1/listings', listing(), key).expect(201)).body;
    const again = (await me.post('/v1/listings', listing(), key).expect(201)).body;
    expect(again).toEqual(first);
    expect(await conn.db.$count(listings, eq(listings.ownerId, me.id))).toBe(1);
  });

  it('changes nothing without the header', async () => {
    const me = await player();
    await me.post('/v1/listings', listing()).expect(201);
    const res = await me.post('/v1/listings', listing()).expect(409);
    expect(res.body.error.code).toBe('listing_already_open');
  });

  it('replays connection requests and play invites too', async () => {
    const me = await player();
    const them = await player();
    const reqKey = randomUUID();
    const req = (
      await me.post('/v1/connection-requests', { toUserId: them.id }, reqKey).expect(201)
    ).body;
    expect(
      (await me.post('/v1/connection-requests', { toUserId: them.id }, reqKey).expect(201)).body.id,
    ).toBe(req.id);

    await http().post(`/v1/connection-requests/${req.id}/accept`).set(them.auth).expect(200);
    const inviteKey = randomUUID();
    const invite = { toUserId: them.id, gameId: 'pubg', playWhen: 'now' };
    const sent = (await me.post('/v1/play-invites', invite, inviteKey).expect(201)).body;
    expect((await me.post('/v1/play-invites', invite, inviteKey).expect(201)).body).toEqual(sent);
  });

  it('files one report for a retried 204', async () => {
    const me = await player();
    const them = await player();
    const key = randomUUID();
    const body = { userId: them.id, reason: 'spam' };
    await me.post('/v1/reports', body, key).expect(204);
    await me.post('/v1/reports', body, key).expect(204);
    expect(await conn.db.$count(reports, eq(reports.reporterId, me.id))).toBe(1);
  });

  it('keeps no errors, so the key works once the request is fixed', async () => {
    const me = await player();
    const them = await player();
    const key = randomUUID();
    await me.post('/v1/reports', { userId: me.id, reason: 'spam' }, key).expect(422);
    await me.post('/v1/reports', { userId: them.id, reason: 'spam' }, key).expect(204);
  });

  it('refuses a key reused for a different request', async () => {
    const me = await player();
    const key = randomUUID();
    await me.post('/v1/listings', listing(), key).expect(201);
    const res = await me.post('/v1/listings', listing({ partySize: 3 }), key).expect(422);
    expect(res.body.error.code).toBe('idempotency_key_reused');
  });

  it('keeps keys per user', async () => {
    const a = await player();
    const b = await player();
    const key = randomUUID();
    const first = (await a.post('/v1/listings', listing(), key).expect(201)).body;
    const second = (await b.post('/v1/listings', listing(), key).expect(201)).body;
    expect(second.id).not.toBe(first.id);
  });

  it('refuses a key that is not a UUID', async () => {
    const me = await player();
    const res = await me.post('/v1/listings', listing(), 'retry-1').expect(400);
    expect(res.body.error.code).toBe('bad_idempotency_key');
  });

  it('answers 409 while the first request is still running, and runs again once it looks dead', async () => {
    const me = await player();
    const them = await player();
    const key = randomUUID();
    const body = { userId: them.id, reason: 'spam' };
    await me.post('/v1/reports', body, key).expect(204);
    await conn.db.update(idempotencyKeys).set({ completedAt: null }).where(keyRow(me.id, key));
    const res = await me.post('/v1/reports', body, key).expect(409);
    expect(res.body.error.code).toBe('idempotency_in_progress');

    await conn.db
      .update(idempotencyKeys)
      .set({ createdAt: new Date(Date.now() - 2 * 60_000) })
      .where(keyRow(me.id, key));
    await me.post('/v1/reports', body, key).expect(204);
    expect(await conn.db.$count(reports, eq(reports.reporterId, me.id))).toBe(2);
  });

  it('forgets keys after 24 hours', async () => {
    const me = await player();
    const them = await player();
    const key = randomUUID();
    const body = { userId: them.id, reason: 'spam' };
    await me.post('/v1/reports', body, key).expect(204);
    const dayAgo = new Date(Date.now() - 24 * 3600_000 - 60_000);
    await conn.db.update(idempotencyKeys).set({ createdAt: dayAgo }).where(keyRow(me.id, key));

    // Before the cleanup job runs, an old key is simply taken again.
    await me.post('/v1/reports', body, key).expect(204);
    expect(await conn.db.$count(reports, eq(reports.reporterId, me.id))).toBe(2);

    await conn.db.update(idempotencyKeys).set({ createdAt: dayAgo }).where(keyRow(me.id, key));
    expect(await jobs.runOnce('idempotency-keys')).toBe(true);
    expect(await conn.db.$count(idempotencyKeys, keyRow(me.id, key))).toBe(0);
  });
});
