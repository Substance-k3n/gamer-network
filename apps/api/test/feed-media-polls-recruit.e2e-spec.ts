import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { orderedPair } from '../src/connections/connections.service.js';
import { createDb } from '../src/db/db.js';
import {
  connectionRequests,
  connections,
  mediaUploads,
  notifications,
  polls,
  postMedia,
  posts,
  recruitApplications,
  recruitments,
  users,
} from '../src/db/schema/index.js';
import { JobRunner } from '../src/jobs/jobs.js';
import { NotificationsService } from '../src/notifications/notifications.service.js';
import { createTestApp, type MemoryPusher, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/FEED_AND_GROUPS_API.md, phases 2 (photos only) and 3: media uploads
// on posts, polls and recruitment, and their notifications. Uploads go to
// the real S3-compatible server from infra/docker/dev, like avatars.

let app: INestApplication<App>;
let pusher: MemoryPusher;
let jobs: JobRunner;
let notifier: NotificationsService;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => {
  ({ app, pusher } = await createTestApp());
  jobs = app.get(JobRunner);
  notifier = app.get(NotificationsService);
});
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());
const PASSWORD = 'correct horse battery';

// The smallest valid PNG: 1×1, transparent.
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
  'base64',
);

type Player = Awaited<ReturnType<typeof player>>;

async function player() {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `fm_${id}@example.com`,
      password: PASSWORD,
      displayName: `Abel ${id}`,
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
  const p = {
    id: userId,
    username: res.body.user.username as string,
    displayName: res.body.user.displayName as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    del: (path: string, body?: object) => http().delete(path).set(auth).send(body),
    /** Posts and returns the body; 201 expected. */
    postIt: async (body: object = {}) =>
      (
        await http()
          .post('/v1/posts')
          .set(auth)
          .send({ type: 'milestone', text: `hit Diamond ${uniq()}`, ...body })
          .expect(201)
      ).body,
    uploadUrl: (body: object) => http().post('/v1/media/upload-url').set(auth).send(body),
    /** Gets an upload URL, uploads `file` to it and returns the key. */
    photo: async (file = PNG) => {
      const target = (
        await http()
          .post('/v1/media/upload-url')
          .set(auth)
          .send({ contentType: 'image/png', size: file.length })
          .expect(200)
      ).body;
      const put = await fetch(target.uploadUrl, {
        method: 'PUT',
        headers: target.headers,
        body: new Uint8Array(file),
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
  return p;
}

async function connect(x: Player, y: Player) {
  const [userAId, userBId] = orderedPair(x.id, y.id);
  await conn.db.insert(connections).values({ userAId, userBId });
}

const rowsFor = (userId: string) =>
  conn.db.select().from(notifications).where(eq(notifications.userId, userId));

const pollBody = (options = ['Erangel', 'Miramar'], duration = '1d') => ({
  type: 'poll',
  text: 'Best map?',
  poll: { options, duration },
});

describe('upload URLs', () => {
  it('signs a PUT for an image and records the key', async () => {
    const me = await player();
    const res = await me.uploadUrl({ contentType: 'image/webp', size: 1000 }).expect(200);
    expect(res.body).toMatchObject({ headers: { 'Content-Type': 'image/webp' } });
    expect(res.body.key).toMatch(new RegExp(`^media/${me.id}/[0-9a-f-]+\\.webp$`));
    expect(new Date(res.body.expiresAt).getTime()).toBeGreaterThan(Date.now());
    const row = await conn.db.query.mediaUploads.findFirst({
      where: eq(mediaUploads.key, res.body.key),
    });
    expect(row).toMatchObject({ userId: me.id, kind: 'image', size: 1000, usedAt: null });
  });

  it('refuses video, other types and sizes over 10 MB', async () => {
    const me = await player();
    for (const body of [
      { contentType: 'video/mp4', size: 1000 },
      { contentType: 'image/gif', size: 1000 },
      { contentType: 'image/png', size: 10 * 1024 * 1024 + 1 },
      { contentType: 'image/png', size: 0 },
    ]) {
      const res = await me.uploadUrl(body).expect(422);
      expect(res.body.error.code).toBe('validation_failed');
    }
    await me.uploadUrl({ contentType: 'image/jpeg', size: 10 * 1024 * 1024 }).expect(200);
  });

  it('allows 30 an hour, then 429 with Retry-After', async () => {
    const me = await player();
    await conn.db.insert(mediaUploads).values(
      Array.from({ length: 30 }, () => ({
        key: `media/${me.id}/${randomUUID()}.png`,
        userId: me.id,
        kind: 'image' as const,
        contentType: 'image/png',
        size: 10,
        expiresAt: new Date(Date.now() + 3600_000),
      })),
    );
    const res = await me.uploadUrl({ contentType: 'image/png', size: 10 }).expect(429);
    expect(res.body.error.code).toBe('rate_limited');
    expect(Number(res.headers['retry-after'])).toBeGreaterThan(0);
  });
});

describe('posts with photos', () => {
  it('attaches up to 4 photos in order, with URLs that serve them', async () => {
    const before = process.env.MEDIA_PUBLIC_URL;
    process.env.MEDIA_PUBLIC_URL = '';
    try {
      const me = await player();
      const keys = [await me.photo(), await me.photo()];
      const post = await me.postIt({ type: 'gameplay', text: 'clutch', media: keys });
      expect(post.kind).toBe('moment');
      expect(post.media).toHaveLength(2);
      expect(post.media[0]).toMatchObject({
        kind: 'image',
        posterUrl: null,
        width: null,
        height: null,
        durationMs: null,
      });
      expect(post.media[0].url).toContain('X-Amz-Signature=');
      const served = await fetch(post.media[0].url);
      expect(served.status).toBe(200);
      expect(Buffer.from(await served.arrayBuffer())).toEqual(PNG);
      const stored = await conn.db
        .select()
        .from(postMedia)
        .where(eq(postMedia.postId, post.id))
        .orderBy(postMedia.position);
      expect(stored.map((m) => m.key)).toEqual(keys);
      const used = await conn.db.query.mediaUploads.findFirst({
        where: eq(mediaUploads.key, keys[0]!),
      });
      expect(used!.usedAt).not.toBeNull();
    } finally {
      if (before === undefined) delete process.env.MEDIA_PUBLIC_URL;
      else process.env.MEDIA_PUBLIC_URL = before;
    }
  });

  it('lets any type carry photos; gameplay needs one; at most 4', async () => {
    const me = await player();
    const meme = await me.postIt({ type: 'meme', text: 'lol', media: [await me.photo()] });
    expect(meme).toMatchObject({ kind: 'text', media: [{ kind: 'image' }] });
    const none = await me.post('/v1/posts', { type: 'gameplay', text: 'clip' }).expect(422);
    expect(none.body.error.fields.media).toBe('Add at least one photo');
    await me.post('/v1/posts', { type: 'gameplay', text: 'clip', media: [] }).expect(422);
    const five = Array.from({ length: 5 }, () => `media/${me.id}/${randomUUID()}.png`);
    const many = await me.post('/v1/posts', { type: 'meme', text: 'x', media: five }).expect(422);
    expect(many.body.error.fields.media).toBe('Up to 4 photos per post');
  });

  it('only takes your own keys, once, unexpired and uploaded as promised', async () => {
    const me = await player();
    const them = await player();
    const fail = async (media: string[]) =>
      (await me.post('/v1/posts', { type: 'meme', text: 'x', media }).expect(422)).body.error.fields
        .media;

    expect(await fail([await them.photo()])).toBe('Not one of your uploads');
    expect(await fail([`media/${me.id}/${randomUUID()}.png`])).toBe('Not one of your uploads');

    const once = await me.photo();
    await me.postIt({ type: 'meme', media: [once] });
    expect(await fail([once])).toBe('That photo is already on a post');

    const late = await me.photo();
    await conn.db
      .update(mediaUploads)
      .set({ expiresAt: new Date(Date.now() - 1000) })
      .where(eq(mediaUploads.key, late));
    expect(await fail([late])).toBe('That upload expired. Add the photo again');

    const pending = (await me.uploadUrl({ contentType: 'image/png', size: PNG.length })).body.key;
    expect(await fail([pending])).toBe("A photo hasn't finished uploading");

    const wrong = await me.photo();
    await conn.db.update(mediaUploads).set({ size: 999 }).where(eq(mediaUploads.key, wrong));
    expect(await fail([wrong])).toBe("A photo doesn't match its upload. Add it again");

    // A failed post leaves good keys unused.
    const good = await me.photo();
    await me.post('/v1/posts', { type: 'meme', text: 'x', media: [good, once] }).expect(422);
    await me.postIt({ type: 'meme', media: [good] });
  });

  it('replays a photo post with the same Idempotency-Key', async () => {
    const me = await player();
    const key = randomUUID();
    const body = { type: 'gameplay', text: 'ace', media: [await me.photo()] };
    const first = await me.post('/v1/posts').set('Idempotency-Key', key).send(body).expect(201);
    const again = await me.post('/v1/posts').set('Idempotency-Key', key).send(body).expect(201);
    expect(again.body.id).toBe(first.body.id);
    expect(await conn.db.select().from(posts).where(eq(posts.authorId, me.id))).toHaveLength(1);
  });

  it('shows only the first image on the share page', async () => {
    const me = await player();
    const post = await me.postIt({
      type: 'gameplay',
      media: [await me.photo(), await me.photo(), await me.photo()],
    });
    const res = await http().get(`/v1/public/posts/${post.id}`).expect(200);
    expect(res.body.media).toHaveLength(1);
    expect(res.body.media[0].id).toBe(post.media[0].id);
    const plain = await me.postIt();
    expect((await http().get(`/v1/public/posts/${plain.id}`)).body.media).toEqual([]);
  });

  it('deletes unused uploads after a day', async () => {
    const me = await player();
    const stale = await me.photo();
    const fresh = await me.photo();
    await conn.db
      .update(mediaUploads)
      .set({ createdAt: new Date(Date.now() - 25 * 3600_000) })
      .where(eq(mediaUploads.key, stale));
    expect(await jobs.runOnce('media-cleanup')).toBe(true);
    const left = await conn.db.select().from(mediaUploads).where(eq(mediaUploads.userId, me.id));
    expect(left.map((u) => u.key)).toEqual([fresh]);
  });

  it("removes a deleted account's photos in the scrub", async () => {
    const me = await player();
    const key = await me.photo();
    const post = await me.postIt({ type: 'gameplay', media: [key] });
    const url = post.media[0].url as string;
    expect((await fetch(url)).status).toBe(200);
    await me.del('/v1/me', { password: PASSWORD }).expect(204);
    expect((await conn.db.query.posts.findFirst({ where: eq(posts.id, post.id) }))!.status).toBe(
      'deleted',
    );
    await conn.db
      .update(users)
      .set({ deletedAt: new Date(Date.now() - 31 * 24 * 3600_000) })
      .where(eq(users.id, me.id));
    await jobs.runOnce('account-scrub');
    expect(await conn.db.select().from(postMedia).where(eq(postMedia.postId, post.id))).toEqual([]);
    expect((await fetch(url)).status).not.toBe(200);
  });
});

describe('polls', () => {
  it('creates with 2–4 options and a duration, and refuses bad ones', async () => {
    const me = await player();
    const post = await me.postIt(pollBody([' Erangel ', 'Miramar', 'Sanhok'], '1w'));
    expect(post).toMatchObject({
      kind: 'poll',
      poll: {
        options: [
          { position: 0, label: 'Erangel', votes: 0 },
          { position: 1, label: 'Miramar', votes: 0 },
          { position: 2, label: 'Sanhok', votes: 0 },
        ],
        totalVotes: 0,
        myVote: null,
        closed: false,
      },
    });
    const days = (new Date(post.poll.endsAt).getTime() - Date.now()) / (24 * 3600_000);
    expect(days).toBeGreaterThan(6.9);
    expect(days).toBeLessThan(7.1);

    const bad = async (body: object) =>
      (await me.post('/v1/posts', body).expect(422)).body.error.fields;
    expect(await bad({ type: 'poll', text: 'x' })).toEqual({ poll: 'Add 2 to 4 options' });
    expect(Object.keys(await bad({ ...pollBody(), type: 'question' }))).toEqual(['poll']);
    expect(await bad(pollBody(['only one']))).toHaveProperty('poll.options');
    expect(await bad(pollBody(['a', 'b', 'c', 'd', 'e']))).toHaveProperty('poll.options');
    expect(await bad(pollBody(['same', ' same']))).toHaveProperty('poll.options');
    expect(await bad(pollBody(['a', 'x'.repeat(61)]))).toHaveProperty('poll.options');
    expect(await bad(pollBody(['a', '  ']))).toHaveProperty('poll.options');
    expect(await bad(pollBody(['a', 'b'], '7d'))).toHaveProperty('poll.duration');
  });

  it('takes one final vote per person, your own poll included, and adds up', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const post = await author.postIt(pollBody());
    const mine = await author.post(`/v1/posts/${post.id}/vote`, { position: 0 }).expect(200);
    expect(mine.body).toMatchObject({ totalVotes: 1, myVote: 0 });
    await a.post(`/v1/posts/${post.id}/vote`, { position: 1 }).expect(200);
    const last = await b.post(`/v1/posts/${post.id}/vote`, { position: 1 }).expect(200);
    expect(last.body).toMatchObject({
      options: [{ votes: 1 }, { votes: 2 }],
      totalVotes: 3,
      myVote: 1,
    });

    const again = await a.post(`/v1/posts/${post.id}/vote`, { position: 0 }).expect(409);
    expect(again.body.error.code).toBe('already_voted');
    expect((await a.get(`/v1/posts/${post.id}`)).body.poll).toMatchObject({
      totalVotes: 3,
      myVote: 1,
    });

    // A banned voter stops counting, and counts again once unbanned.
    await conn.db.update(users).set({ bannedAt: new Date() }).where(eq(users.id, b.id));
    expect((await a.get(`/v1/posts/${post.id}`)).body.poll.totalVotes).toBe(2);
    await conn.db.update(users).set({ bannedAt: null }).where(eq(users.id, b.id));
    expect((await a.get(`/v1/posts/${post.id}`)).body.poll.totalVotes).toBe(3);
  });

  it('refuses a bad position, a closed poll, and posts that are not polls', async () => {
    const author = await player();
    const voter = await player();
    const post = await author.postIt(pollBody());
    const bad = await voter.post(`/v1/posts/${post.id}/vote`, { position: 2 }).expect(422);
    expect(bad.body.error.fields.position).toBe('Pick one of the options');
    await voter.post(`/v1/posts/${post.id}/vote`, { position: 9 }).expect(422);
    await voter.post(`/v1/posts/${post.id}/vote`, {}).expect(422);

    await conn.db
      .update(polls)
      .set({ endsAt: new Date(Date.now() - 1000) })
      .where(eq(polls.postId, post.id));
    const closed = await voter.post(`/v1/posts/${post.id}/vote`, { position: 0 }).expect(409);
    expect(closed.body.error.code).toBe('poll_closed');
    expect((await voter.get(`/v1/posts/${post.id}`)).body.poll.closed).toBe(true);

    const plain = await author.postIt();
    await voter.post(`/v1/posts/${plain.id}/vote`, { position: 0 }).expect(404);
    await voter.post(`/v1/posts/${randomUUID()}/vote`, { position: 0 }).expect(404);
  });

  it("can't be voted on by someone it's hidden from", async () => {
    const author = await player();
    const blocked = await player();
    const post = await author.postIt(pollBody());
    await author.post('/v1/blocks', { userId: blocked.id }).expect(204);
    await blocked.post(`/v1/posts/${post.id}/vote`, { position: 0 }).expect(404);
  });
});

describe('recruitment', () => {
  const recruitBody = (slots = 2, roles?: string) => ({
    type: 'recruitment',
    text: 'Need 2 for ranked',
    gameId: 'pubg',
    recruit: { slots, roles },
  });

  it('creates with slots and roles, and refuses bad ones', async () => {
    const me = await player();
    const post = await me.postIt(recruitBody(3, ' Sniper, Support '));
    expect(post).toMatchObject({
      kind: 'recruit',
      recruit: { slots: 3, roles: 'Sniper, Support', applications: 0, myApplication: null },
    });
    expect((await me.postIt(recruitBody(1))).recruit.roles).toBe('');

    const bad = async (body: object) =>
      (await me.post('/v1/posts', body).expect(422)).body.error.fields;
    expect(await bad({ type: 'recruitment', text: 'x' })).toEqual({
      recruit: 'Say how many players you need',
    });
    expect(Object.keys(await bad({ ...recruitBody(), type: 'meme' }))).toEqual(['recruit']);
    expect(await bad(recruitBody(0))).toHaveProperty('recruit.slots');
    expect(await bad(recruitBody(11))).toHaveProperty('recruit.slots');
    expect(await bad(recruitBody(2, 'x'.repeat(81)))).toHaveProperty('recruit.roles');
  });

  it('applies once, never to your own post, and tells the author', async () => {
    const author = await player();
    const a = await player();
    const phone = `fcm-${uniq()}-${uniq()}-token`;
    await author.device(phone).expect(204);
    const post = await author.postIt(recruitBody());

    const res = await a.post(`/v1/posts/${post.id}/apply`).expect(200);
    expect(res.body).toEqual({ slots: 2, roles: '', applications: 1, myApplication: 'pending' });
    const again = await a.post(`/v1/posts/${post.id}/apply`).expect(409);
    expect(again.body.error.code).toBe('already_applied');
    const own = await author.post(`/v1/posts/${post.id}/apply`).expect(403);
    expect(own.body.error.code).toBe('own_post');
    expect((await author.get(`/v1/posts/${post.id}`)).body.recruit).toMatchObject({
      applications: 1,
      myApplication: null,
    });

    const [application] = await conn.db
      .select()
      .from(recruitApplications)
      .where(eq(recruitApplications.postId, post.id));
    const alerts = (await author.get('/v1/notifications')).body.items;
    expect(alerts).toHaveLength(1);
    expect(alerts[0]).toMatchObject({
      type: 'recruit_application',
      actor: { id: a.id },
      postId: post.id,
      recruitApplicationId: application!.id,
      text: `${a.displayName} applied to your recruitment post`,
      route: `/posts/${post.id}/applications`,
    });
    await notifier.dispatchAll();
    expect(pusher.to(phone)).toMatchObject([
      { title: 'New applicant', data: { type: 'recruit_application' } },
    ]);

    const plain = await author.postIt();
    await a.post(`/v1/posts/${plain.id}/apply`).expect(404);
  });

  it('replays an apply with the same Idempotency-Key', async () => {
    const author = await player();
    const a = await player();
    const post = await author.postIt(recruitBody());
    const key = randomUUID();
    const first = await a.post(`/v1/posts/${post.id}/apply`).set('Idempotency-Key', key);
    const again = await a.post(`/v1/posts/${post.id}/apply`).set('Idempotency-Key', key);
    expect(first.status).toBe(200);
    expect(again.status).toBe(200);
    expect(again.body).toEqual(first.body);
    expect(await rowsFor(author.id)).toHaveLength(1);
  });

  it('allows 20 applications a day, then 429', async () => {
    const author = await player();
    const me = await player();
    const others: string[] = [];
    for (let i = 0; i < 20; i++) {
      const [p] = await conn.db
        .insert(posts)
        .values({ authorId: author.id, type: 'recruitment', text: 'need 1' })
        .returning();
      others.push(p!.id);
    }
    await conn.db.insert(recruitments).values(others.map((postId) => ({ postId, slots: 1 })));
    await conn.db
      .insert(recruitApplications)
      .values(others.map((postId) => ({ postId, userId: me.id })));
    // A fresh author: the 20 above use up this one's posts for the hour.
    const post = await (await player()).postIt(recruitBody());
    const res = await me.post(`/v1/posts/${post.id}/apply`).expect(429);
    expect(res.body.error.code).toBe('rate_limited');
  });

  it('shows the applications to the author only, without people hidden from them', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const c = await player();
    const post = await author.postIt(recruitBody(5));
    for (const p of [a, b, c]) await p.post(`/v1/posts/${post.id}/apply`).expect(200);

    const page1 = await author.get(`/v1/posts/${post.id}/applications?limit=2`).expect(200);
    expect(page1.body.items.map((i: { user: { id: string } }) => i.user.id)).toEqual([a.id, b.id]);
    expect(page1.body.items[0]).toMatchObject({ status: 'pending' });
    const page2 = await author
      .get(`/v1/posts/${post.id}/applications?limit=2&cursor=${page1.body.nextCursor}`)
      .expect(200);
    expect(page2.body.items.map((i: { user: { id: string } }) => i.user.id)).toEqual([c.id]);
    expect(page2.body.nextCursor).toBeNull();

    const other = await a.get(`/v1/posts/${post.id}/applications`).expect(403);
    expect(other.body.error.code).toBe('not_owner');

    await author.post('/v1/blocks', { userId: b.id }).expect(204);
    const after = await author.get(`/v1/posts/${post.id}/applications`).expect(200);
    expect(after.body.items.map((i: { user: { id: string } }) => i.user.id)).toEqual([a.id, c.id]);
    const [bApp] = await conn.db
      .select()
      .from(recruitApplications)
      .where(and(eq(recruitApplications.postId, post.id), eq(recruitApplications.userId, b.id)));
    await author.post(`/v1/recruit-applications/${bApp!.id}/accept`).expect(404);
  });

  it('accepting tells the applicant, sends a connection request, and fills the slots', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const friend = await player();
    const late = await player();
    await connect(author, friend);
    const post = await author.postIt(recruitBody(2));
    for (const p of [a, b, friend]) await p.post(`/v1/posts/${post.id}/apply`).expect(200);
    const appOf = async (p: Player) =>
      (
        await conn.db
          .select()
          .from(recruitApplications)
          .where(and(eq(recruitApplications.postId, post.id), eq(recruitApplications.userId, p.id)))
      )[0]!;

    const aApp = await appOf(a);
    expect(
      (await a.post(`/v1/recruit-applications/${aApp.id}/accept`).expect(403)).body.error.code,
    ).toBe('not_owner');
    const accepted = await author.post(`/v1/recruit-applications/${aApp.id}/accept`).expect(200);
    expect(accepted.body).toEqual({ id: aApp.id, status: 'accepted' });
    await author.post(`/v1/recruit-applications/${aApp.id}/accept`).expect(200);

    const aAlerts = (await a.get('/v1/notifications')).body.items;
    expect(aAlerts.map((n: { type: string }) => n.type)).toEqual([
      'connection_request',
      'recruit_accepted',
    ]);
    expect(aAlerts[1]).toMatchObject({
      actor: { id: author.id },
      postId: post.id,
      recruitApplicationId: aApp.id,
      text: `${author.displayName} accepted your application`,
      route: `/players/${author.username}`,
    });
    const requests = await conn.db
      .select()
      .from(connectionRequests)
      .where(
        and(eq(connectionRequests.fromUserId, author.id), eq(connectionRequests.toUserId, a.id)),
      );
    expect(requests).toMatchObject([{ status: 'pending' }]);
    expect((await a.get(`/v1/posts/${post.id}`)).body.recruit.myApplication).toBe('accepted');

    // Already connected: no request, but still told.
    await author.post(`/v1/recruit-applications/${(await appOf(friend)).id}/accept`).expect(200);
    const friendTypes = (await rowsFor(friend.id)).map((n) => n.type);
    expect(friendTypes).toEqual(['recruit_accepted']);

    // Full: no more applications or accepts.
    const full = await late.post(`/v1/posts/${post.id}/apply`).expect(409);
    expect(full.body.error.code).toBe('recruitment_full');
    const bApp = await appOf(b);
    const more = await author.post(`/v1/recruit-applications/${bApp.id}/accept`).expect(409);
    expect(more.body.error.code).toBe('recruitment_full');

    // Declining tells no one, and frees nothing that wasn't taken.
    const declined = await author.post(`/v1/recruit-applications/${bApp.id}/decline`).expect(200);
    expect(declined.body).toEqual({ id: bApp.id, status: 'declined' });
    expect(await rowsFor(b.id)).toEqual([]);
    expect((await b.get(`/v1/posts/${post.id}`)).body.recruit.myApplication).toBe('declined');

    await author.post(`/v1/recruit-applications/${randomUUID()}/accept`).expect(404);
    await author.post('/v1/recruit-applications/nope/decline').expect(404);
  });

  it('never notifies across a block', async () => {
    const author = await player();
    const a = await player();
    const post = await author.postIt(recruitBody());
    await a.post(`/v1/posts/${post.id}/apply`).expect(200);
    await a.post('/v1/blocks', { userId: author.id }).expect(204);
    await a.post(`/v1/posts/${post.id}/apply`).expect(404);
    const [application] = await conn.db
      .select()
      .from(recruitApplications)
      .where(eq(recruitApplications.postId, post.id));
    await author.post(`/v1/recruit-applications/${application!.id}/accept`).expect(404);
    expect(await rowsFor(a.id)).toEqual([]);
    expect((await author.get('/v1/notifications')).body.items).toEqual([]);
  });
});
