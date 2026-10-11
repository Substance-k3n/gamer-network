import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { orderedPair } from '../src/connections/connections.service.js';
import { createDb } from '../src/db/db.js';
import {
  checkIns,
  connections,
  notifications,
  playInvites,
  users,
} from '../src/db/schema/index.js';
import { JobRunner } from '../src/jobs/jobs.js';
import { inviteCheckInDueAt } from '../src/play/play-times.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Play together", docs/DATA_MODEL.md "Accepting a play invite", docs/PRD.md metric.

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
      email: `p_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Naod ${id}`,
      username: `naod_${id}`,
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
  const p = {
    id: userId,
    displayName: `Naod ${id}`,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    invite: (to: { id: string }, playWhen = 'now') =>
      p.post('/v1/play-invites', { toUserId: to.id, gameId: 'codm', playWhen }),
  };
  return p;
}

/** Two players who are already connected. */
async function friends() {
  const a = await player();
  const b = await player();
  const [userAId, userBId] = orderedPair(a.id, b.id);
  await conn.db.insert(connections).values({ userAId, userBId });
  return { a, b };
}

describe('play invites', () => {
  it('invites a connection: starts now, stale 15 min later, shows on their banner', async () => {
    const { a, b } = await friends();
    const { body } = await a.invite(b).expect(201);
    expect(body).toMatchObject({
      from: { id: a.id },
      to: { id: b.id },
      game: { id: 'codm' },
      playWhen: 'now',
      status: 'pending',
    });
    expect(new Date(body.expiresAt).getTime() - new Date(body.startsAt).getTime()).toBe(
      15 * 60_000,
    );
    expect((await b.get('/v1/play-invites')).body.items.map((i: { id: string }) => i.id)).toEqual([
      body.id,
    ]);
    expect((await a.get('/v1/play-invites?direction=outgoing')).body.items).toHaveLength(1);
    const sent = await conn.db
      .select()
      .from(notifications)
      .where(and(eq(notifications.playInviteId, body.id), eq(notifications.type, 'play_invite')));
    expect(sent).toHaveLength(1);
  });

  it('is only between connections, one at a time, for real games', async () => {
    const stranger = await player();
    const { a, b } = await friends();
    expect((await a.invite(stranger).expect(403)).body.error.code).toBe('not_connected');
    await a
      .post('/v1/play-invites', { toUserId: b.id, gameId: 'nope', playWhen: 'now' })
      .expect(422);
    await a.invite(b).expect(201);
    expect((await a.invite(b).expect(409)).body.error.code).toBe('invite_pending');
  });

  it('accepting schedules both check-ins and tells the sender', async () => {
    const { a, b } = await friends();
    const invite = (await a.invite(b, 'in_30_min').expect(201)).body;
    const before = new Date();
    const { body } = await b.post(`/v1/play-invites/${invite.id}/accept`).expect(200);
    expect(body.status).toBe('accepted');
    const rows = await conn.db.select().from(checkIns).where(eq(checkIns.playInviteId, invite.id));
    expect(rows).toHaveLength(2);
    expect(rows[0]!.dueAt.getTime()).toBe(inviteCheckInDueAt(before).getTime());
    const told = await conn.db
      .select()
      .from(notifications)
      .where(and(eq(notifications.userId, a.id), eq(notifications.type, 'play_invite_accepted')));
    expect(told).toHaveLength(1);
    expect((await b.get('/v1/play-invites')).body.items).toEqual([]);
  });

  it('refuses stale invites, and answers once', async () => {
    const { a, b } = await friends();
    const stale = (await a.invite(b).expect(201)).body;
    await conn.db
      .update(playInvites)
      .set({ expiresAt: new Date(Date.now() - 1000) })
      .where(eq(playInvites.id, stale.id));
    expect((await b.post(`/v1/play-invites/${stale.id}/accept`).expect(409)).body.error.code).toBe(
      'invite_expired',
    );
    const fresh = (await a.invite(b).expect(201)).body;
    await a.post(`/v1/play-invites/${fresh.id}/accept`).expect(404);
    await b.post(`/v1/play-invites/${fresh.id}/decline`).expect(204);
    expect((await b.post(`/v1/play-invites/${fresh.id}/accept`).expect(409)).body.error.code).toBe(
      'invite_not_pending',
    );
  });
});

describe('check-ins', () => {
  it('asks once when due, lists it on Home, and one tap answers it', async () => {
    const { a, b } = await friends();
    const [mine] = await conn.db
      .insert(checkIns)
      .values([
        { userId: a.id, otherUserId: b.id, dueAt: new Date(Date.now() - 60_000) },
        { userId: b.id, otherUserId: a.id, dueAt: new Date(Date.now() + 3600_000) },
      ])
      .returning();

    await jobs.runOnce('check-ins-due');
    await jobs.runOnce('check-ins-due');
    const asked = await conn.db
      .select()
      .from(notifications)
      .where(and(eq(notifications.userId, a.id), eq(notifications.type, 'check_in_due')));
    expect(asked).toHaveLength(1);
    expect(asked[0]).toMatchObject({ checkInId: mine!.id, actorId: b.id });
    const alert = (await a.get('/v1/notifications')).body.items[0];
    expect(alert).toMatchObject({
      text: `Did you play with ${b.displayName}?`,
      route: `/check-ins/${mine!.id}`,
    });

    expect((await a.get('/v1/me/check-ins')).body.items).toMatchObject([
      { id: mine!.id, other: { id: b.id } },
    ]);
    expect((await b.get('/v1/me/check-ins')).body.items).toEqual([]);

    await a.post(`/v1/check-ins/${mine!.id}`, { answer: 'played' }).expect(204);
    expect((await a.get('/v1/me/check-ins')).body.items).toEqual([]);
    expect((await a.get('/v1/me')).body.stats.playedWith).toBe(1);
    expect((await a.get('/v1/notifications/unread-count')).body.count).toBe(0);
  });

  it("can change an answer, but not answer someone else's", async () => {
    const { a, b } = await friends();
    const [mine] = await conn.db
      .insert(checkIns)
      .values({ userId: a.id, otherUserId: b.id, dueAt: new Date() })
      .returning();
    await a.post(`/v1/check-ins/${mine!.id}`, { answer: 'not_yet' }).expect(204);
    await a.post(`/v1/check-ins/${mine!.id}`, { answer: 'played' }).expect(204);
    await b.post(`/v1/check-ins/${mine!.id}`, { answer: 'no' }).expect(404);
    const row = await conn.db.query.checkIns.findFirst({ where: eq(checkIns.id, mine!.id) });
    expect(row!.answer).toBe('played');
  });
});
