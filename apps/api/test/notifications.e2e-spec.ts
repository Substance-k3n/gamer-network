import { INestApplication } from '@nestjs/common';
import { eq, isNull } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { blocks, devices, notifications, users } from '../src/db/schema/index.js';
import { NotificationsService } from '../src/notifications/notifications.service.js';
import { createTestApp, MemoryPusher, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/API.md "Notifications" and "Push".

let app: INestApplication<App>;
let pusher: MemoryPusher;
let notifier: NotificationsService;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => {
  ({ app, pusher } = await createTestApp());
  notifier = app.get(NotificationsService);
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
      email: `n_${id}@example.com`,
      password: 'correct horse battery',
      displayName: `Selam ${id}`,
      username: `selam_${id}`,
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
    username: res.body.user.username as string,
    displayName: `Selam ${id}`,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body: object) => http().put(path).set(auth).send(body),
    /** Registers a phone for push. */
    device: (token: string) =>
      p.put('/v1/me/devices', { fcmToken: token, platform: 'android', appVersion: '1.0.0' }),
    ask: async (to: { id: string }) =>
      (await p.post('/v1/connection-requests', { toUserId: to.id }).expect(201)).body,
  };
  return p;
}

const token = () => `fcm-${uniq()}-${uniq()}-token`;

describe('Alerts', () => {
  it('lists notifications with ready text, counts unread and marks them read', async () => {
    const a = await player();
    const b = await player();
    const req = await a.ask(b);
    await b.post(`/v1/connection-requests/${req.id}/accept`).expect(200);

    const list = (await b.get('/v1/notifications').expect(200)).body;
    expect(list.items).toHaveLength(1);
    expect(list.items[0]).toMatchObject({
      type: 'connection_request',
      actor: { id: a.id },
      connectionRequestId: req.id,
      text: `${a.displayName} wants to connect`,
      route: '/alerts',
      readAt: null,
    });
    expect((await a.get('/v1/notifications')).body.items[0]).toMatchObject({
      type: 'connection_accepted',
      route: `/players/${b.username}`,
    });

    expect((await b.get('/v1/notifications/unread-count')).body).toEqual({ count: 1 });
    await b.post('/v1/notifications/read', { ids: [list.items[0].id] }).expect(204);
    expect((await b.get('/v1/notifications/unread-count')).body).toEqual({ count: 0 });
    await a.post('/v1/notifications/read', { all: true }).expect(204);
    expect((await a.get('/v1/notifications/unread-count')).body).toEqual({ count: 0 });
    await a.post('/v1/notifications/read', {}).expect(422);
  });

  it('hides notifications from people you blocked', async () => {
    const a = await player();
    const b = await player();
    await a.ask(b);
    await conn.db.insert(blocks).values({ blockerId: b.id, blockedId: a.id });
    expect((await b.get('/v1/notifications')).body.items).toEqual([]);
    expect((await b.get('/v1/notifications/unread-count')).body.count).toBe(0);
  });

  it('pages newest first', async () => {
    const me = await player();
    for (let i = 0; i < 3; i++) await (await player()).ask(me);
    const first = (await me.get('/v1/notifications?limit=2')).body;
    const second = (await me.get(`/v1/notifications?limit=2&cursor=${first.nextCursor}`)).body;
    expect(first.items).toHaveLength(2);
    expect(second.items).toHaveLength(1);
    expect(second.nextCursor).toBeNull();
  });
});

describe('push', () => {
  it('sends each notification once to every signed-in device, with its route', async () => {
    const a = await player();
    const b = await player();
    const phone = token();
    const tablet = token();
    await b.device(phone).expect(204);
    await b.device(tablet).expect(204);
    await a.ask(b);
    await notifier.dispatchAll();
    await notifier.dispatchAll();
    expect(pusher.to(phone)).toHaveLength(1);
    expect(pusher.to(phone)[0]).toMatchObject({
      title: 'Connection request',
      body: `${a.displayName} wants to connect`,
      data: { type: 'connection_request', route: '/alerts' },
    });
    expect(pusher.to(tablet)).toHaveLength(1);
    const left = await conn.db
      .select({ id: notifications.id })
      .from(notifications)
      .where(isNull(notifications.pushedAt));
    expect(left).toEqual([]);
  });

  it('stops pushing to a phone once it logs out', async () => {
    const a = await player();
    const b = await player();
    const phone = token();
    await b.device(phone).expect(204);
    await b.post('/v1/auth/logout').expect(204);
    await a.ask(b);
    await notifier.dispatchAll();
    expect(pusher.to(phone)).toEqual([]);
    expect(await conn.db.select().from(devices).where(eq(devices.fcmToken, phone))).toEqual([]);
  });

  it('moves a token to whoever signed in on the phone last', async () => {
    const a = await player();
    const b = await player();
    const c = await player();
    const shared = token();
    await b.device(shared).expect(204);
    await c.device(shared).expect(204);
    await a.ask(b);
    await notifier.dispatchAll();
    expect(pusher.to(shared)).toEqual([]);
  });

  it('forgets tokens FCM reports as dead', async () => {
    const a = await player();
    const b = await player();
    const dead = `dead-${token()}`;
    await b.device(dead).expect(204);
    await a.ask(b);
    await notifier.dispatchAll();
    expect(pusher.to(dead)).toHaveLength(1);
    expect(await conn.db.select().from(devices).where(eq(devices.fcmToken, dead))).toEqual([]);
  });
});
