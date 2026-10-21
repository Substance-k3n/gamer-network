import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { env } from '../src/env.js';
import {
  adminActions,
  groupMembers,
  groups,
  notifications,
  posts,
  reports,
  users,
} from '../src/db/schema/index.js';
import { NotificationsService } from '../src/notifications/notifications.service.js';
import { createTestApp, type MemoryPusher, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/FEED_AND_GROUPS_API.md phases 4 and 5, section 9 items 7–9: groups,
// members and roles, group posts, events and going, their notifications,
// and group moderation.

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
const PASSWORD = 'correct horse battery';
const DAY = 24 * 3600_000;

// The smallest valid PNG: 1×1, transparent.
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
  'base64',
);

type Player = Awaited<ReturnType<typeof player>>;

async function player({ admin = false, verified = true } = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `gr_${id}@example.com`,
      password: PASSWORD,
      displayName: `Yonas ${id}`,
      username: `yonas_${id}`,
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
  await conn.db
    .update(users)
    .set({ emailVerifiedAt: verified ? new Date() : null, role: admin ? 'admin' : 'player' })
    .where(eq(users.id, userId));
  return {
    id: userId,
    username: res.body.user.username as string,
    displayName: res.body.user.displayName as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body?: object) => http().put(path).set(auth).send(body),
    patch: (path: string, body: object) => http().patch(path).set(auth).send(body),
    del: (path: string, body?: object) => http().delete(path).set(auth).send(body),
    /** Creates a group and returns it; 201 expected. */
    group: async (body: object = {}) =>
      (
        await http()
          .post('/v1/groups')
          .set(auth)
          .send({ name: `Squad ${uniq()}`, kind: 'squad', place: 'Addis Ababa', ...body })
          .expect(201)
      ).body,
    /** Posts in a group and returns the post; 201 expected. */
    postIn: async (groupId: string, body: object = {}) =>
      (
        await http()
          .post('/v1/posts')
          .set(auth)
          .send({ type: 'question', text: `who's on tonight ${uniq()}`, groupId, ...body })
          .expect(201)
      ).body,
    photo: async () => {
      const target = (
        await http()
          .post('/v1/media/upload-url')
          .set(auth)
          .send({ contentType: 'image/png', size: PNG.length })
          .expect(200)
      ).body;
      const put = await fetch(target.uploadUrl, {
        method: 'PUT',
        headers: target.headers,
        body: new Uint8Array(PNG),
      });
      expect(put.ok).toBe(true);
      return target.key as string;
    },
    device: (token: string) =>
      http()
        .put('/v1/me/devices')
        .set(auth)
        .send({ fcmToken: token, platform: 'android', appVersion: '1.0.0' }),
  };
}

/** `who` joins `groupId`; an admin approves when it's an approval group. */
async function joined(groupId: string, who: Player, admin?: Player) {
  const res = await who.post(`/v1/groups/${groupId}/join`).expect(200);
  if (res.body.myStatus === 'pending' && admin) {
    await admin.post(`/v1/groups/${groupId}/members/${who.id}/approve`).expect(204);
  }
}

const rowsFor = (userId: string) =>
  conn.db.select().from(notifications).where(eq(notifications.userId, userId));

const ids = (res: request.Response) => res.body.items.map((i: { id: string }) => i.id);

describe('groups', () => {
  it('creates a group with you as admin; names are unique ignoring case', async () => {
    const me = await player();
    const tag = uniq();
    const name = `Valorant Ethiopia ${tag}`;
    const group = await me.group({
      name,
      kind: 'game',
      gameId: 'val',
      about: 'Ranked and customs',
      rules: [' Be kind ', 'No cheats'],
      tone: 'lav',
      approval: true,
    });
    expect(group).toMatchObject({
      name,
      short: `VE${tag[0]!.toUpperCase()}`,
      kind: 'game',
      game: { id: 'val' },
      place: 'Addis Ababa',
      rules: ['Be kind', 'No cheats'],
      tone: 'lav',
      approval: true,
      memberCount: 1,
      myRole: 'admin',
      myStatus: 'member',
      nextEvent: null,
    });
    expect(group.membersPreview.map((u: { id: string }) => u.id)).toEqual([me.id]);
    expect((await me.get(`/v1/groups/${group.id}`).expect(200)).body.id).toBe(group.id);

    const dup = await me
      .post('/v1/groups', { name: name.toUpperCase(), kind: 'city', place: 'Adama' })
      .expect(409);
    expect(dup.body.error.code).toBe('group_name_taken');
    expect(
      (await me.post('/v1/groups', { name: 'x', kind: 'city', place: 'A' }).expect(422)).body.error
        .fields.name,
    ).toBeDefined();
  });

  it('needs a game for game groups, a verified email, and allows 3 a day', async () => {
    const me = await player();
    const noGame = await me
      .post('/v1/groups', { name: `G ${uniq()}`, kind: 'game', place: 'Addis' })
      .expect(422);
    expect(noGame.body.error.fields.gameId).toBe('Pick the game for a game group');
    await me
      .post('/v1/groups', { name: `G ${uniq()}`, kind: 'game', gameId: 'nope', place: 'Addis' })
      .expect(422);
    await me
      .post('/v1/groups', {
        name: `G ${uniq()}`,
        kind: 'city',
        place: 'Addis',
        rules: Array(11).fill('r'),
      })
      .expect(422);

    const unverified = await player({ verified: false });
    const res = await unverified
      .post('/v1/groups', { name: `G ${uniq()}`, kind: 'city', place: 'Addis' })
      .expect(403);
    expect(res.body.error.code).toBe('email_not_verified');

    for (let i = 0; i < 3; i++) await me.group();
    const limited = await me
      .post('/v1/groups', { name: `G ${uniq()}`, kind: 'city', place: 'Addis' })
      .expect(429);
    expect(limited.body.error.code).toBe('rate_limited');
  });

  it('replays a create with the same Idempotency-Key', async () => {
    const me = await player();
    const key = randomUUID();
    const body = { name: `Campus ${uniq()}`, kind: 'campus', place: 'AAU' };
    const first = await me.post('/v1/groups', body).set('Idempotency-Key', key);
    const again = await me.post('/v1/groups', body).set('Idempotency-Key', key);
    expect(first.status).toBe(201);
    expect(again.body.id).toBe(first.body.id);
  });

  it('joins open groups straight away and approval groups as pending', async () => {
    const admin = await player();
    const a = await player();
    const b = await player();
    const open = await admin.group();
    const res = await a.post(`/v1/groups/${open.id}/join`).expect(200);
    expect(res.body).toMatchObject({ myStatus: 'member', myRole: 'member', memberCount: 2 });
    const again = await a.post(`/v1/groups/${open.id}/join`).expect(409);
    expect(again.body.error.code).toBe('already_member');

    const closed = await admin.group({ approval: true });
    expect((await a.post(`/v1/groups/${closed.id}/join`).expect(200)).body).toMatchObject({
      myStatus: 'pending',
      myRole: null,
      memberCount: 1,
    });
    await b.post(`/v1/groups/${closed.id}/join`).expect(200);

    // Requests are for admins only.
    const forbidden = await a.get(`/v1/groups/${closed.id}/members?status=pending`).expect(403);
    expect(forbidden.body.error.code).toBe('not_group_admin');
    const pending = await admin.get(`/v1/groups/${closed.id}/members?status=pending`).expect(200);
    expect(pending.body.items.map((m: { user: { id: string } }) => m.user.id)).toEqual([
      a.id,
      b.id,
    ]);
    expect(pending.body.items[0]).toMatchObject({
      status: 'pending',
      role: 'member',
      joinedAt: null,
    });

    await admin.post(`/v1/groups/${closed.id}/members/${a.id}/approve`).expect(204);
    await admin.post(`/v1/groups/${closed.id}/members/${b.id}/decline`).expect(204);
    await admin.post(`/v1/groups/${closed.id}/members/${b.id}/decline`).expect(404);
    expect((await a.get(`/v1/groups/${closed.id}`)).body).toMatchObject({
      myStatus: 'member',
      memberCount: 2,
    });
    expect((await b.get(`/v1/groups/${closed.id}`)).body.myStatus).toBeNull();

    const members = await b.get(`/v1/groups/${closed.id}/members`).expect(200);
    expect(
      members.body.items.map((m: { user: { id: string }; role: string }) => [m.user.id, m.role]),
    ).toEqual([
      [admin.id, 'admin'],
      [a.id, 'member'],
    ]);

    // Cancelling a request.
    await b.post(`/v1/groups/${closed.id}/join`).expect(200);
    await b.del(`/v1/groups/${closed.id}/membership`).expect(204);
    expect((await b.get(`/v1/groups/${closed.id}`)).body.myStatus).toBeNull();
  });

  it('keeps an admin: the last admin cannot leave while others remain', async () => {
    const admin = await player();
    const a = await player();
    const group = await admin.group();
    await joined(group.id, a);
    const res = await admin.del(`/v1/groups/${group.id}/membership`).expect(409);
    expect(res.body.error.code).toBe('last_admin');
    expect(
      (
        await admin
          .put(`/v1/groups/${group.id}/members/${admin.id}/role`, { role: 'member' })
          .expect(409)
      ).body.error.code,
    ).toBe('last_admin');
    await a.put(`/v1/groups/${group.id}/members/${admin.id}/role`, { role: 'member' }).expect(403);

    await admin.put(`/v1/groups/${group.id}/members/${a.id}/role`, { role: 'admin' }).expect(204);
    await admin.del(`/v1/groups/${group.id}/membership`).expect(204);
    expect((await a.get(`/v1/groups/${group.id}`)).body).toMatchObject({
      memberCount: 1,
      myRole: 'admin',
    });
    // The last member leaving archives it.
    await a.del(`/v1/groups/${group.id}/membership`).expect(204);
    await a.get(`/v1/groups/${group.id}`).expect(404);
    const [row] = await conn.db.select().from(groups).where(eq(groups.id, group.id));
    expect(row).toMatchObject({ status: 'deleted', memberCount: 0 });
    // Its name is free again.
    await a.group({ name: group.name });
  });

  it('lets admins edit the group and remove members', async () => {
    const admin = await player();
    const a = await player();
    const group = await admin.group();
    await joined(group.id, a);
    await a.patch(`/v1/groups/${group.id}`, { about: 'mine now' }).expect(403);
    const name = `Renamed ${uniq()}`;
    const res = await admin
      .patch(`/v1/groups/${group.id}`, { name, rules: ['One'], tone: 'grey', approval: true })
      .expect(200);
    expect(res.body).toMatchObject({ name, rules: ['One'], tone: 'grey', approval: true });
    const other = await admin.group();
    expect(
      (await admin.patch(`/v1/groups/${other.id}`, { name: name.toLowerCase() }).expect(409)).body
        .error.code,
    ).toBe('group_name_taken');

    await admin.del(`/v1/groups/${group.id}/members/${admin.id}`).expect(422);
    await admin.del(`/v1/groups/${group.id}/members/${a.id}`).expect(204);
    expect((await a.get(`/v1/groups/${group.id}`)).body).toMatchObject({
      myStatus: null,
      memberCount: 1,
    });
  });

  it('keeps group posts for members, off Home and Moments', async () => {
    const admin = await player();
    const member = await player();
    const stranger = await player();
    const group = await admin.group({ tone: 'soft' });
    await joined(group.id, member);

    const notIn = await stranger
      .post('/v1/posts', { type: 'question', text: 'hi', groupId: group.id })
      .expect(403);
    expect(notIn.body.error.code).toBe('not_member');
    const audience = await member
      .post('/v1/posts', {
        type: 'question',
        text: 'hi',
        groupId: group.id,
        audience: 'connections',
      })
      .expect(422);
    expect(audience.body.error.fields.audience).toBeDefined();

    const post = await member.postIn(group.id);
    expect(post.group).toEqual({
      id: group.id,
      name: group.name,
      short: group.short,
      tone: 'soft',
    });
    expect(ids(await admin.get(`/v1/groups/${group.id}/posts`).expect(200))).toEqual([post.id]);
    expect((await stranger.get(`/v1/groups/${group.id}/posts`).expect(403)).body.error.code).toBe(
      'not_member',
    );
    await stranger.get(`/v1/posts/${post.id}`).expect(404);
    await stranger.put(`/v1/posts/${post.id}/save`).expect(404);
    await http().get(`/v1/public/posts/${post.id}`).expect(404);

    expect(ids(await member.get('/v1/feed?limit=30'))).not.toContain(post.id);
    expect(ids(await member.get('/v1/me/posts'))).not.toContain(post.id);
    expect(ids(await admin.get(`/v1/users/${member.username}/posts`))).not.toContain(post.id);
    // Saved by a member, then they leave: gone from their saved list.
    await member.put(`/v1/posts/${post.id}/save`).expect(204);
    expect(ids(await member.get('/v1/me/saved'))).toEqual([post.id]);
    await member.del(`/v1/groups/${group.id}/membership`).expect(204);
    expect(ids(await member.get('/v1/me/saved'))).toEqual([]);
  });

  it('lets group admins remove any post or comment in their group', async () => {
    const admin = await player();
    const member = await player();
    const other = await player();
    const group = await admin.group();
    await joined(group.id, member);
    await joined(group.id, other);
    const post = await member.postIn(group.id);
    const comment = (
      await member.post(`/v1/posts/${post.id}/comments`, { text: 'me!' }).expect(201)
    ).body;
    await other.del(`/v1/comments/${comment.id}`).expect(403);
    await admin.del(`/v1/comments/${comment.id}`).expect(204);
    expect((await member.get(`/v1/posts/${post.id}`)).body.commentCount).toBe(0);

    await other.del(`/v1/posts/${post.id}`).expect(403);
    await admin.del(`/v1/posts/${post.id}`).expect(204);
    await member.get(`/v1/posts/${post.id}`).expect(404);
    const [row] = await conn.db.select().from(posts).where(eq(posts.id, post.id));
    expect(row).toMatchObject({ status: 'removed', removedBy: admin.id });

    // Being a group admin gives no rights over Home posts.
    const home = (
      await member.post('/v1/posts', { type: 'milestone', text: 'Diamond' }).expect(201)
    ).body;
    await admin.del(`/v1/posts/${home.id}`).expect(403);
  });

  it('has events within 60 days, with going', async () => {
    const admin = await player();
    const member = await player();
    const stranger = await player();
    const group = await admin.group();
    await joined(group.id, member);
    const startsAt = new Date(Date.now() + 2 * 3600_000).toISOString();

    expect(
      (
        await stranger
          .post(`/v1/groups/${group.id}/events`, { title: 'Customs', startsAt })
          .expect(403)
      ).body.error.code,
    ).toBe('not_member');
    const far = await member
      .post(`/v1/groups/${group.id}/events`, {
        title: 'Later',
        startsAt: new Date(Date.now() + 61 * DAY).toISOString(),
      })
      .expect(422);
    expect(far.body.error.fields.startsAt).toBe('Pick a time within the next 60 days');
    await member
      .post(`/v1/groups/${group.id}/events`, {
        title: 'Past',
        startsAt: new Date(Date.now() - 1000).toISOString(),
      })
      .expect(422);

    const later = (
      await member
        .post(`/v1/groups/${group.id}/events`, {
          title: 'Weekend scrims',
          startsAt: new Date(Date.now() + 3 * DAY).toISOString(),
        })
        .expect(201)
    ).body;
    const event = (
      await member
        .post(`/v1/groups/${group.id}/events`, {
          title: '5-stack customs',
          startsAt,
          gameId: 'val',
        })
        .expect(201)
    ).body;
    expect(event).toMatchObject({
      groupId: group.id,
      title: '5-stack customs',
      game: { id: 'val' },
      goingCount: 0,
      imGoing: false,
      createdBy: { id: member.id },
    });

    // Anyone may see the events, soonest first; the group shows the next one.
    expect(ids(await stranger.get(`/v1/groups/${group.id}/events`).expect(200))).toEqual([
      event.id,
      later.id,
    ]);
    expect((await stranger.get(`/v1/groups/${group.id}`)).body.nextEvent.id).toBe(event.id);
    const firstPage = await stranger.get(`/v1/groups/${group.id}/events?limit=1`);
    const second = await stranger.get(
      `/v1/groups/${group.id}/events?limit=1&cursor=${firstPage.body.nextCursor}`,
    );
    expect(ids(second)).toEqual([later.id]);

    await stranger.put(`/v1/group-events/${event.id}/going`).expect(403);
    const going = await admin.put(`/v1/group-events/${event.id}/going`).expect(200);
    expect(going.body).toMatchObject({ goingCount: 1, imGoing: true });
    await admin.put(`/v1/group-events/${event.id}/going`).expect(200);
    await member.put(`/v1/group-events/${event.id}/going`).expect(200);
    expect((await stranger.get(`/v1/groups/${group.id}`)).body.nextEvent).toMatchObject({
      goingCount: 2,
    });
    expect((await admin.del(`/v1/group-events/${event.id}/going`).expect(200)).body).toMatchObject({
      goingCount: 1,
      imGoing: false,
    });

    // Its creator or an admin deletes it.
    const third = await player();
    await joined(group.id, third);
    await third.del(`/v1/group-events/${event.id}`).expect(403);
    await admin.del(`/v1/group-events/${event.id}`).expect(204);
    await member.del(`/v1/group-events/${later.id}`).expect(204);
    expect(ids(await stranger.get(`/v1/groups/${group.id}/events`))).toEqual([]);
  });

  it('finds groups on Discover, Yours and profiles', async () => {
    const me = await player();
    const them = await player();
    const tag = uniq();
    const city = await them.group({ name: `Adama ${tag}`, kind: 'city' });
    const game = await them.group({
      name: `PUBG ${tag}`,
      kind: 'game',
      gameId: 'pubg',
      approval: true,
    });
    const campus = await them.group({
      name: `Campus ${tag}`,
      kind: 'campus',
      place: `Hall ${tag}`,
    });
    await joined(city.id, me);
    await me.post(`/v1/groups/${game.id}/join`).expect(200);

    // Search matches the name and the place; kind narrows it. Most members first.
    expect(ids(await me.get(`/v1/groups?query=${tag}`))).toEqual([city.id, campus.id, game.id]);
    expect(ids(await me.get(`/v1/groups?query=${tag}&kind=campus`))).toEqual([campus.id]);
    await me.get('/v1/groups?query=a').expect(422);
    const p1 = await me.get(`/v1/groups?query=${tag}&limit=2`);
    expect(ids(p1)).toEqual([city.id, campus.id]);
    expect(
      ids(await me.get(`/v1/groups?query=${tag}&limit=2&cursor=${p1.body.nextCursor}`)),
    ).toEqual([game.id]);

    // Yours includes the request; profiles of others show memberships only.
    const mine = await me.get('/v1/groups?tab=mine').expect(200);
    expect(ids(mine).sort()).toEqual([city.id, game.id].sort());
    expect(ids(await me.get('/v1/me/groups')).sort()).toEqual([city.id, game.id].sort());
    expect(
      (await me.get('/v1/me/groups')).body.items.find((g: { id: string }) => g.id === game.id)
        .myStatus,
    ).toBe('pending');
    expect(ids(await them.get(`/v1/users/${me.username}/groups`))).toEqual([city.id]);
    // A post makes a group the most recent activity.
    await me.postIn(city.id);
    expect(ids(await me.get('/v1/me/groups'))[0]).toBe(city.id);
  });
});

describe('group notifications', () => {
  it('tells admins about requests and the new member when approved, never across a block', async () => {
    const admin = await player();
    const coAdmin = await player();
    const asker = await player();
    const group = await admin.group({ approval: true });
    await joined(group.id, coAdmin, admin);
    await admin
      .put(`/v1/groups/${group.id}/members/${coAdmin.id}/role`, { role: 'admin' })
      .expect(204);
    await coAdmin.post('/v1/blocks', { userId: asker.id }).expect(204);

    await asker.post(`/v1/groups/${group.id}/join`).expect(200);
    const alerts = await admin.get('/v1/notifications').expect(200);
    expect(alerts.body.items[0]).toMatchObject({
      type: 'group_join_request',
      groupId: group.id,
      actor: { id: asker.id },
      text: `${asker.displayName} wants to join ${group.name}`,
      route: `/groups/${group.id}/members?status=pending`,
    });
    expect((await rowsFor(coAdmin.id)).filter((n) => n.type === 'group_join_request')).toEqual([]);
    expect(await rowsFor(asker.id)).toEqual([]);

    // Cancelling and asking again doesn't stack a second unread request.
    await asker.del(`/v1/groups/${group.id}/membership`).expect(204);
    await asker.post(`/v1/groups/${group.id}/join`).expect(200);
    expect((await rowsFor(admin.id)).filter((n) => n.type === 'group_join_request')).toHaveLength(
      2,
    );

    await admin.post(`/v1/groups/${group.id}/members/${asker.id}/approve`).expect(204);
    const mine = await asker.get('/v1/notifications').expect(200);
    expect(mine.body.items).toMatchObject([
      {
        type: 'group_join_approved',
        groupId: group.id,
        text: `You're in ${group.name}`,
        route: `/groups/${group.id}`,
      },
    ]);
  });

  it('tells members about a new event, pushing at most once an hour per group', async () => {
    const admin = await player();
    const member = await player();
    const blocked = await player();
    const group = await admin.group();
    await joined(group.id, member);
    await joined(group.id, blocked);
    await blocked.post('/v1/blocks', { userId: admin.id }).expect(204);
    const phone = `tok_${uniq()}`;
    await member.device(phone).expect(204);

    const startsAt = new Date(Date.now() + 2 * 3600_000).toISOString();
    const event = (
      await admin
        .post(`/v1/groups/${group.id}/events`, { title: '5-stack customs', startsAt })
        .expect(201)
    ).body;
    await admin.post(`/v1/groups/${group.id}/events`, { title: 'Second', startsAt }).expect(201);
    await notifier.dispatchAll();

    const rows = (await rowsFor(member.id)).filter((n) => n.type === 'group_event');
    expect(rows).toHaveLength(2);
    expect(await rowsFor(admin.id)).toEqual([]);
    expect((await rowsFor(blocked.id)).filter((n) => n.type === 'group_event')).toEqual([]);
    const pushes = pusher.to(phone);
    expect(pushes).toHaveLength(1);
    expect(pushes[0]).toMatchObject({
      title: 'New event',
      data: { type: 'group_event', route: `/groups/${group.id}` },
    });
    expect(pushes[0]!.body).toMatch(new RegExp(`^New event in ${group.name}: 5-stack customs, `));
    const alert = (await member.get('/v1/notifications')).body.items.find(
      (n: { groupEventId: string }) => n.groupEventId === event.id,
    );
    expect(alert).toMatchObject({ type: 'group_event', groupId: group.id });
  });

  it('notifies about group posts only members who can see them', async () => {
    const admin = await player();
    const member = await player();
    const stranger = await player();
    const group = await admin.group();
    await joined(group.id, member);
    const post = await member.postIn(group.id, {
      text: `hey @${admin.username} and @${stranger.username}`,
    });
    expect((await rowsFor(admin.id)).filter((n) => n.postId === post.id)).toHaveLength(1);
    expect(await rowsFor(stranger.id)).toEqual([]);
  });
});

describe('group moderation', () => {
  it('takes group reports and removes the group on resolve', async () => {
    const reporter = await player();
    const creator = await player();
    const admin = await player({ admin: true });
    const group = await creator.group({ about: 'x'.repeat(400) });

    // userId must be the group's creator, and one thing at a time.
    await reporter
      .post('/v1/reports', { userId: admin.id, groupId: group.id, reason: 'spam' })
      .expect(422);
    await reporter
      .post('/v1/reports', {
        userId: creator.id,
        groupId: group.id,
        postId: randomUUID(),
        reason: 'spam',
      })
      .expect(422);
    await reporter
      .post('/v1/reports', { userId: creator.id, groupId: group.id, reason: 'spam' })
      .expect(204);
    const [report] = await conn.db.select().from(reports).where(eq(reports.groupId, group.id));
    const resolved = await admin
      .post(`/v1/admin/reports/${report!.id}/resolve`, {
        action: 'remove_group',
        note: 'spam group',
      })
      .expect(200);
    expect(resolved.body).toMatchObject({
      groupId: group.id,
      groupName: group.name,
      status: 'actioned',
      image: null,
    });
    expect(resolved.body.excerpt).toHaveLength(300);
    await reporter.get(`/v1/groups/${group.id}`).expect(404);
    await creator.get(`/v1/groups/${group.id}`).expect(404);
    const actions = await conn.db
      .select()
      .from(adminActions)
      .where(and(eq(adminActions.groupId, group.id), eq(adminActions.kind, 'remove_group')));
    expect(actions).toMatchObject([{ reportId: report!.id, targetUserId: creator.id }]);
  });

  it('shows createdBy and shareUrl on every group, and takes a report after the creator steps down', async () => {
    const creator = await player();
    const a = await player();
    const reporter = await player();
    const group = await creator.group();
    const shareUrl = `${env.publicWebUrl}/app/groups/${group.id}`;
    const check = (g: { createdBy: { id: string; username: string }; shareUrl: string }) => {
      expect(g.createdBy).toMatchObject({ id: creator.id, username: creator.username });
      expect(g.shareUrl).toBe(shareUrl);
    };
    check(group);
    await joined(group.id, a);
    check((await reporter.get(`/v1/groups/${group.id}`).expect(200)).body);
    check((await a.get(`/v1/groups/${group.id}`).expect(200)).body);
    const newbie = await player();
    check((await newbie.post(`/v1/groups/${group.id}/join`).expect(200)).body);
    check((await creator.patch(`/v1/groups/${group.id}`, { about: 'new' }).expect(200)).body);
    const found = await reporter.get('/v1/groups').query({ query: group.name }).expect(200);
    check(found.body.items.find((g: { id: string }) => g.id === group.id));

    // The creator hands over and leaves; the report still names them.
    await creator.put(`/v1/groups/${group.id}/members/${a.id}/role`, { role: 'admin' }).expect(204);
    await creator.del(`/v1/groups/${group.id}/membership`).expect(204);
    const after = (await reporter.get(`/v1/groups/${group.id}`).expect(200)).body;
    check(after);
    await reporter
      .post('/v1/reports', { userId: after.createdBy.id, groupId: group.id, reason: 'spam' })
      .expect(204);
    const rows = await conn.db.select().from(reports).where(eq(reports.groupId, group.id));
    expect(rows).toMatchObject([{ targetUserId: creator.id, reporterId: reporter.id }]);
    // Leave the queue as it was.
    const admin = await player({ admin: true });
    await admin
      .post(`/v1/admin/reports/${rows[0]!.id}/resolve`, { action: 'dismiss', note: '' })
      .expect(200);
  });

  it('shows a reported post with its first image, and refuses remove_group on it', async () => {
    const reporter = await player();
    const author = await player();
    const admin = await player({ admin: true });
    const key = await author.photo();
    const photo = (
      await author.post('/v1/posts', { type: 'gameplay', text: 'clutch', media: [key] }).expect(201)
    ).body;
    await reporter
      .post('/v1/reports', { userId: author.id, postId: photo.id, reason: 'spam' })
      .expect(204);
    const [report] = await conn.db.select().from(reports).where(eq(reports.postId, photo.id));
    await admin
      .post(`/v1/admin/reports/${report!.id}/resolve`, { action: 'remove_group', note: '' })
      .expect(422);
    const res = await admin
      .post(`/v1/admin/reports/${report!.id}/resolve`, { action: 'dismiss', note: 'fine' })
      .expect(200);
    expect(res.body).toMatchObject({ excerpt: 'clutch', groupId: null, groupName: null });
    expect(res.body.image).toMatchObject({ id: photo.media[0].id, kind: 'image' });
  });

  it('removes a group directly, hiding its posts and events', async () => {
    const creator = await player();
    const member = await player();
    const admin = await player({ admin: true });
    const group = await creator.group();
    await joined(group.id, member);
    const post = await member.postIn(group.id);
    await admin.post(`/v1/admin/groups/${group.id}/remove`, { note: 'raid' }).expect(204);
    await admin.post(`/v1/admin/groups/${randomUUID()}/remove`, {}).expect(404);
    await member.post(`/v1/admin/groups/${group.id}/remove`, {}).expect(403);
    await member.get(`/v1/groups/${group.id}`).expect(404);
    await member.get(`/v1/posts/${post.id}`).expect(404);
    await member.get(`/v1/groups/${group.id}/events`).expect(404);
    expect(ids(await member.get('/v1/me/groups'))).not.toContain(group.id);
    const actions = await conn.db
      .select()
      .from(adminActions)
      .where(eq(adminActions.groupId, group.id));
    expect(actions).toMatchObject([{ kind: 'remove_group', note: 'raid', adminId: admin.id }]);
  });

  it('hides group content from blocked people both ways; membership stays', async () => {
    const admin = await player();
    const a = await player();
    const b = await player();
    const group = await admin.group();
    await joined(group.id, a);
    await joined(group.id, b);
    const fromA = await a.postIn(group.id);
    const fromB = await b.postIn(group.id);
    await a.post('/v1/blocks', { userId: b.id }).expect(204);
    expect(ids(await a.get(`/v1/groups/${group.id}/posts`))).toEqual([fromA.id]);
    expect(ids(await b.get(`/v1/groups/${group.id}/posts`))).toEqual([fromB.id]);
    const members = await a.get(`/v1/groups/${group.id}/members`);
    expect(members.body.items.map((m: { user: { id: string } }) => m.user.id)).not.toContain(b.id);
    expect((await a.get(`/v1/groups/${group.id}`)).body.memberCount).toBe(3);
  });

  it('hides groups a banned creator is alone in until the unban', async () => {
    const creator = await player();
    const other = await player();
    const admin = await player({ admin: true });
    const alone = await creator.group();
    const shared = await creator.group();
    await joined(shared.id, other);
    await admin.post(`/v1/admin/users/${creator.id}/ban`, { reason: 'spam' }).expect(200);
    await other.get(`/v1/groups/${alone.id}`).expect(404);
    await other.get(`/v1/groups/${shared.id}`).expect(200);
    await admin.post(`/v1/admin/users/${creator.id}/unban`, {}).expect(200);
    await other.get(`/v1/groups/${alone.id}`).expect(200);
  });

  it('archives sole-member groups on account deletion and hands the rest on', async () => {
    const me = await player();
    const other = await player();
    const alone = await me.group();
    const shared = await me.group();
    await joined(shared.id, other);
    await me.del('/v1/me', { password: PASSWORD }).expect(204);
    await other.get(`/v1/groups/${alone.id}`).expect(404);
    expect((await other.get(`/v1/groups/${shared.id}`).expect(200)).body).toMatchObject({
      memberCount: 1,
      myRole: 'admin',
    });
    expect(await conn.db.select().from(groupMembers).where(eq(groupMembers.userId, me.id))).toEqual(
      [],
    );
  });

  it('counts posts and groups in the admin users drawer', async () => {
    const me = await player();
    const admin = await player({ admin: true });
    const group = await me.group();
    await me.postIn(group.id);
    await me.post('/v1/posts', { type: 'milestone', text: 'Diamond' }).expect(201);
    const res = await admin.get(`/v1/admin/users/${me.id}`).expect(200);
    expect(res.body).toMatchObject({ postsCount: 2, groupsCount: 1 });
  });
});
