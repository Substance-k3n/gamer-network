import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { orderedPair } from '../src/connections/connections.service.js';
import { createDb } from '../src/db/db.js';
import {
  adminActions,
  comments,
  connections,
  notifications,
  posts,
  reports,
  users,
} from '../src/db/schema/index.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/FEED_AND_GROUPS_API.md, phase 1: posts, feed, GG, comments, saves,
// reports and admin removal. The feed is shared with other runs, so tests
// look for their own posts by id rather than comparing whole pages.

let app: INestApplication<App>;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => ({ app } = await createTestApp()));
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());
const PASSWORD = 'correct horse battery';

type Player = Awaited<ReturnType<typeof player>>;

async function player({ admin = false } = {}) {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `f_${id}@example.com`,
      password: PASSWORD,
      displayName: `Meron ${id}`,
      username: `meron_${id}`,
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
    .set({ emailVerifiedAt: new Date(), role: admin ? 'admin' : 'player' })
    .where(eq(users.id, userId));
  const p = {
    id: userId,
    username: res.body.user.username as string,
    get: (path: string) => http().get(path).set(auth),
    post: (path: string, body?: object) => http().post(path).set(auth).send(body),
    put: (path: string, body?: object) => http().put(path).set(auth).send(body),
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
    comment: async (postId: string, body: object) =>
      (await http().post(`/v1/posts/${postId}/comments`).set(auth).send(body).expect(201)).body,
  };
  return p;
}

async function connect(x: Player, y: Player) {
  const [userAId, userBId] = orderedPair(x.id, y.id);
  await conn.db.insert(connections).values({ userAId, userBId });
}

const ids = (res: request.Response) => res.body.items.map((i: { id: string }) => i.id);

/** All the posts in `filter` until `stop` is found or the feed runs out. */
async function feedIds(viewer: Player, query: string, stop?: string) {
  const found: string[] = [];
  let cursor: string | null = null;
  for (;;) {
    const res: request.Response = await viewer
      .get(`/v1/feed?${query}&limit=30${cursor ? `&cursor=${cursor}` : ''}`)
      .expect(200);
    found.push(...ids(res));
    cursor = res.body.nextCursor;
    if (!cursor || (stop && found.includes(stop))) return found;
  }
}

const unread = (userId: string) =>
  conn.db.select().from(notifications).where(eq(notifications.userId, userId));

describe('posts', () => {
  it('creates every text type with its kind, and the card the viewer needs', async () => {
    const me = await player();
    const types = [
      'discussion',
      'milestone',
      'question',
      'looking_for_players',
      'tip_guide',
      'review',
      'event',
      'meme',
    ];
    for (const type of types) {
      const post = await me.postIt({ type, gameId: 'pubg', text: `  ${type} text  ` });
      expect(post).toMatchObject({
        type,
        kind: type === 'discussion' ? 'discussion' : 'text',
        text: `${type} text`,
        game: { id: 'pubg' },
        audience: 'everyone',
        author: { id: me.id, username: me.username },
        ggCount: 0,
        commentCount: 0,
        myGG: false,
        saved: false,
        mine: true,
        topComment: null,
      });
      expect(post.shareUrl).toMatch(new RegExp(`/p/${post.id}$`));
    }
    expect((await me.postIt({ gameId: null })).game).toBeNull();
  });

  it('refuses media, poll and recruitment types until their phase, and bad fields', async () => {
    const me = await player();
    for (const type of ['gameplay', 'poll', 'recruitment']) {
      const res = await me.post('/v1/posts', { type, text: 'soon' }).expect(422);
      expect(res.body.error.fields.type).toBeDefined();
    }
    await me.post('/v1/posts', { type: 'milestone', text: '   ' }).expect(422);
    await me.post('/v1/posts', { type: 'milestone', text: 'x'.repeat(2001) }).expect(422);
    await me.post('/v1/posts', { type: 'nope', text: 'x' }).expect(422);
    const res = await me.post('/v1/posts', { type: 'milestone', text: 'x', gameId: 'nope' });
    expect(res.status).toBe(422);
    expect(res.body.error.fields.gameId).toBe('Unknown game');
  });

  it('replays a create with the same Idempotency-Key', async () => {
    const me = await player();
    const key = randomUUID();
    const send = () =>
      me.post('/v1/posts').set('Idempotency-Key', key).send({ type: 'question', text: 'duo?' });
    const first = await send().expect(201);
    const again = await send().expect(201);
    expect(again.body.id).toBe(first.body.id);
    expect(await conn.db.select().from(posts).where(eq(posts.authorId, me.id))).toHaveLength(1);
  });

  it('needs a verified email', async () => {
    const me = await player();
    await conn.db.update(users).set({ emailVerifiedAt: null }).where(eq(users.id, me.id));
    const res = await me.post('/v1/posts', { type: 'question', text: 'hi' }).expect(403);
    expect(res.body.error.code).toBe('email_not_verified');
  });

  it('allows 10 posts an hour, then 429 with Retry-After', async () => {
    const me = await player();
    await conn.db
      .insert(posts)
      .values(
        Array.from({ length: 10 }, () => ({ authorId: me.id, type: 'meme' as const, text: 'lol' })),
      );
    const res = await me.post('/v1/posts', { type: 'meme', text: 'one more' }).expect(429);
    expect(res.body.error.code).toBe('rate_limited');
    expect(Number(res.headers['retry-after'])).toBeGreaterThan(0);
  });

  it('is deleted by its author only', async () => {
    const me = await player();
    const them = await player();
    const post = await me.postIt();
    expect((await them.del(`/v1/posts/${post.id}`).expect(403)).body.error.code).toBe('not_owner');
    await me.del(`/v1/posts/${post.id}`).expect(204);
    await me.get(`/v1/posts/${post.id}`).expect(404);
    await them.get(`/v1/posts/${post.id}`).expect(404);
    await me.get('/v1/posts/not-a-uuid').expect(404);
  });
});

describe('the feed', () => {
  it('filters: for you, connections, LFG and game', async () => {
    const me = await player();
    const friend = await player();
    const stranger = await player();
    await connect(me, friend);
    const friendLfg = await friend.postIt({ type: 'looking_for_players', gameId: 'codm' });
    const strangerPost = await stranger.postIt({ gameId: 'pubg' });
    const mine = await me.postIt({ gameId: 'pubg' });

    const forYou = await feedIds(me, 'filter=for_you', friendLfg.id);
    expect(forYou).toEqual(expect.arrayContaining([mine.id, strangerPost.id, friendLfg.id]));

    const conns = await feedIds(me, 'filter=connections');
    expect(conns).toEqual([mine.id, friendLfg.id]);

    const lfg = await feedIds(me, 'filter=lfg', friendLfg.id);
    expect(lfg).toContain(friendLfg.id);
    expect(lfg).not.toContain(mine.id);

    const pubg = await feedIds(me, 'filter=game&game=pubg', strangerPost.id);
    expect(pubg).toEqual(expect.arrayContaining([mine.id, strangerPost.id]));
    expect(pubg).not.toContain(friendLfg.id);
    await me.get('/v1/feed?filter=game').expect(422);
  });

  it('pages newest first without gaps or repeats', async () => {
    const me = await player();
    const made: string[] = [];
    for (let i = 0; i < 5; i++) made.push((await me.postIt()).id);
    const seen: string[] = [];
    let cursor: string | null = null;
    do {
      const res: request.Response = await me
        .get(`/v1/me/posts?limit=2${cursor ? `&cursor=${cursor}` : ''}`)
        .expect(200);
      seen.push(...ids(res));
      cursor = res.body.nextCursor;
    } while (cursor);
    expect(seen).toEqual([...made].reverse());
    await me.get('/v1/feed?cursor=garbage').expect(422);
  });

  it('shows connections-only posts to connections and the author, not to strangers', async () => {
    const me = await player();
    const friend = await player();
    const stranger = await player();
    await connect(me, friend);
    const post = await me.postIt({ audience: 'connections' });
    await friend.get(`/v1/posts/${post.id}`).expect(200);
    await stranger.get(`/v1/posts/${post.id}`).expect(404);
    expect(await feedIds(stranger, 'filter=for_you', post.id)).not.toContain(post.id);
    expect(ids(await me.get('/v1/me/posts'))).toEqual([post.id]);
    expect(ids(await friend.get(`/v1/users/${me.username}/posts`))).toEqual([post.id]);
    expect(ids(await stranger.get(`/v1/users/${me.username}/posts`))).toEqual([]);
  });

  it('hides blocked people both ways, and banned authors until they are unbanned', async () => {
    const me = await player();
    const them = await player();
    const post = await them.postIt();
    const minePost = await me.postIt();
    await me.post('/v1/blocks', { userId: them.id }).expect(204);
    await me.get(`/v1/posts/${post.id}`).expect(404);
    await them.get(`/v1/posts/${minePost.id}`).expect(404);
    expect(await feedIds(me, 'filter=for_you', minePost.id)).not.toContain(post.id);
    await me.del(`/v1/blocks/${them.id}`).expect(204);
    await me.get(`/v1/posts/${post.id}`).expect(200);

    await conn.db.update(users).set({ bannedAt: new Date() }).where(eq(users.id, them.id));
    await me.get(`/v1/posts/${post.id}`).expect(404);
    await conn.db.update(users).set({ bannedAt: null }).where(eq(users.id, them.id));
    await me.get(`/v1/posts/${post.id}`).expect(200);
  });
});

describe('GG and saves', () => {
  it('toggles safely and the count matches the rows', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const post = await author.postIt();
    expect((await a.put(`/v1/posts/${post.id}/gg`).expect(200)).body).toEqual({
      ggCount: 1,
      myGG: true,
    });
    await a.put(`/v1/posts/${post.id}/gg`).expect(200);
    expect((await b.put(`/v1/posts/${post.id}/gg`).expect(200)).body.ggCount).toBe(2);
    expect((await a.del(`/v1/posts/${post.id}/gg`).expect(200)).body).toEqual({
      ggCount: 1,
      myGG: false,
    });
    await a.del(`/v1/posts/${post.id}/gg`).expect(200);
    expect((await b.get(`/v1/posts/${post.id}`)).body).toMatchObject({ ggCount: 1, myGG: true });
  });

  it('saves, lists most recently saved first, and drops ones you can no longer see', async () => {
    const me = await player();
    const author = await player();
    const first = await author.postIt();
    const second = await author.postIt();
    const third = await author.postIt();
    for (const p of [second, first, third]) {
      await me.put(`/v1/posts/${p.id}/save`).expect(204);
      await me.put(`/v1/posts/${p.id}/save`).expect(204);
    }
    const page1 = await me.get('/v1/me/saved?limit=2').expect(200);
    expect(ids(page1)).toEqual([third.id, first.id]);
    expect(page1.body.items[0].saved).toBe(true);
    const page2 = await me.get(`/v1/me/saved?limit=2&cursor=${page1.body.nextCursor}`).expect(200);
    expect(ids(page2)).toEqual([second.id]);
    expect(page2.body.nextCursor).toBeNull();

    await author.del(`/v1/posts/${first.id}`).expect(204);
    await me.del(`/v1/posts/${third.id}/save`).expect(204);
    expect(ids(await me.get('/v1/me/saved'))).toEqual([second.id]);
  });
});

describe('comments', () => {
  it('attaches replies to the top-level comment and keeps the counts right', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const post = await author.postIt({ type: 'discussion', text: 'Best sniper spot?' });
    const top = await a.comment(post.id, { text: 'Pochinki roofs' });
    const reply = await b.comment(post.id, { text: 'agree', parentId: top.id });
    const deeper = await author.comment(post.id, { text: 'same', parentId: reply.id });
    expect(reply.parentId).toBe(top.id);
    expect(deeper.parentId).toBe(top.id);

    const list = await b.get(`/v1/posts/${post.id}/comments`).expect(200);
    expect(ids(list)).toEqual([top.id]);
    expect(list.body.items[0]).toMatchObject({ replies: 2, mine: false });
    expect(ids(await b.get(`/v1/comments/${top.id}/replies`))).toEqual([reply.id, deeper.id]);
    expect((await b.get(`/v1/posts/${post.id}`)).body.commentCount).toBe(3);

    await a
      .post(`/v1/posts/${post.id}/comments`, { text: 'x', parentId: randomUUID() })
      .expect(422);
  });

  it('is deleted by its author or the post author, and its replies go with it', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const post = await author.postIt();
    const c1 = await a.comment(post.id, { text: 'one' });
    await b.comment(post.id, { text: 'reply', parentId: c1.id });
    const c2 = await b.comment(post.id, { text: 'two' });
    expect((await b.del(`/v1/comments/${c1.id}`).expect(403)).body.error.code).toBe('not_owner');
    await author.del(`/v1/comments/${c1.id}`).expect(204);
    expect((await a.get(`/v1/posts/${post.id}`)).body.commentCount).toBe(1);
    await b.del(`/v1/comments/${c2.id}`).expect(204);
    expect((await a.get(`/v1/posts/${post.id}`)).body.commentCount).toBe(0);
    const removed = await conn.db.query.comments.findFirst({ where: eq(comments.id, c1.id) });
    expect(removed).toMatchObject({ status: 'removed', removedBy: author.id });
  });

  it('GGs a comment, and a discussion shows its most-GG answer', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const post = await author.postIt({ type: 'discussion', text: 'Best gun?' });
    await a.comment(post.id, { text: 'AKM' });
    const best = await b.comment(post.id, { text: 'M416' });
    expect((await a.put(`/v1/comments/${best.id}/gg`).expect(200)).body).toEqual({
      ggCount: 1,
      myGG: true,
    });
    await a.put(`/v1/comments/${best.id}/gg`).expect(200);
    expect((await author.get(`/v1/posts/${post.id}`)).body.topComment).toMatchObject({
      id: best.id,
      ggCount: 1,
    });
    const top = await author.get(`/v1/posts/${post.id}/comments?sort=top&limit=1`).expect(200);
    expect(ids(top)).toEqual([best.id]);
    const next = await author
      .get(`/v1/posts/${post.id}/comments?sort=top&limit=1&cursor=${top.body.nextCursor}`)
      .expect(200);
    expect(next.body.items[0].text).toBe('AKM');
    expect((await a.del(`/v1/comments/${best.id}/gg`).expect(200)).body.ggCount).toBe(0);
  });

  it("can't comment on a post you can't see", async () => {
    const author = await player();
    const stranger = await player();
    const post = await author.postIt({ audience: 'connections' });
    await stranger.post(`/v1/posts/${post.id}/comments`, { text: 'hi' }).expect(404);
    await stranger.get(`/v1/posts/${post.id}/comments`).expect(404);
  });
});

describe('notifications', () => {
  it('adds GGs up in one unread row, never notifies yourself, and starts a new row once read', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const c = await player();
    const post = await author.postIt();
    await author.put(`/v1/posts/${post.id}/gg`).expect(200);
    expect(await unread(author.id)).toEqual([]);
    for (const p of [a, b, c]) await p.put(`/v1/posts/${post.id}/gg`).expect(200);

    const rows = await unread(author.id);
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({ type: 'post_gg', actorId: c.id, postId: post.id });
    expect(rows[0]!.pushedAt).not.toBeNull();
    const alerts = (await author.get('/v1/notifications').expect(200)).body.items;
    expect(alerts[0]).toMatchObject({
      type: 'post_gg',
      postId: post.id,
      text: `${(await c.get('/v1/me')).body.displayName} and 2 others reacted GG to your post`,
      route: `/posts/${post.id}`,
    });

    await author.post('/v1/notifications/read', { all: true }).expect(204);
    await a.del(`/v1/posts/${post.id}/gg`).expect(200);
    await a.put(`/v1/posts/${post.id}/gg`).expect(200);
    expect(await unread(author.id)).toHaveLength(2);
  });

  it('tells the post author and the one answered, once each, and @mentions once', async () => {
    const author = await player();
    const a = await player();
    const b = await player();
    const m = await player();
    const post = await author.postIt({ text: `GG @${m.username} and @${m.username}` });
    const top = await a.comment(post.id, { text: 'nice' });
    await b.comment(post.id, {
      text: `@${a.username} @${author.username} @${m.username}`,
      parentId: top.id,
    });

    const types = async (p: Player) => (await unread(p.id)).map((n) => n.type).sort();
    expect(await types(author)).toEqual(['post_comment', 'post_comment']);
    expect(await types(a)).toEqual(['comment_reply']);
    expect(await types(m)).toEqual(['mention', 'mention']);
    expect(await types(b)).toEqual([]);
  });

  it('never notifies across a block or about posts someone cannot see', async () => {
    const author = await player();
    const blocked = await player();
    const stranger = await player();
    await author.post('/v1/blocks', { userId: blocked.id }).expect(204);
    await author.postIt({ text: `hey @${blocked.username}` });
    await author.postIt({ audience: 'connections', text: `hey @${stranger.username}` });
    expect(await unread(blocked.id)).toEqual([]);
    expect(await unread(stranger.id)).toEqual([]);
  });
});

describe('moderation', () => {
  it('reports a post or a comment, checking it is theirs', async () => {
    const me = await player();
    const them = await player();
    const other = await player();
    const post = await them.postIt();
    const comment = await them.comment(post.id, { text: 'spam spam' });
    await me.post('/v1/reports', { userId: them.id, postId: post.id, reason: 'spam' }).expect(204);
    await me
      .post('/v1/reports', { userId: them.id, commentId: comment.id, reason: 'spam' })
      .expect(204);
    await me.post('/v1/reports', { userId: other.id, postId: post.id, reason: 'spam' }).expect(422);
    await me
      .post('/v1/reports', {
        userId: them.id,
        postId: post.id,
        commentId: comment.id,
        reason: 'spam',
      })
      .expect(422);
    const rows = await conn.db.select().from(reports).where(eq(reports.reporterId, me.id));
    expect(rows.map((r) => [r.postId, r.commentId]).sort()).toEqual(
      [
        [post.id, null],
        [null, comment.id],
      ].sort(),
    );
  });

  it('lets an admin remove a reported post, and logs it', async () => {
    const admin = await player({ admin: true });
    const me = await player();
    const them = await player();
    const post = await them.postIt({ text: 'buy cheap UC here' });
    await me.post('/v1/reports', { userId: them.id, postId: post.id, reason: 'spam' }).expect(204);
    const [report] = await conn.db.select().from(reports).where(eq(reports.reporterId, me.id));
    const queue = await admin.get('/v1/admin/reports?limit=50').expect(200);
    let item = queue.body.items.find((r: { id: string }) => r.id === report!.id);
    let cursor = queue.body.nextCursor;
    while (!item && cursor) {
      const more = await admin.get(`/v1/admin/reports?limit=50&cursor=${cursor}`).expect(200);
      item = more.body.items.find((r: { id: string }) => r.id === report!.id);
      cursor = more.body.nextCursor;
    }
    expect(item).toMatchObject({ postId: post.id, excerpt: 'buy cheap UC here' });

    await admin
      .post(`/v1/admin/reports/${report!.id}/resolve`, { action: 'remove_comment', note: '' })
      .expect(422);
    await admin
      .post(`/v1/admin/reports/${report!.id}/resolve`, { action: 'remove_post', note: 'spam' })
      .expect(200);
    await me.get(`/v1/posts/${post.id}`).expect(404);
    await them.get(`/v1/posts/${post.id}`).expect(404);
    const [log] = await conn.db
      .select()
      .from(adminActions)
      .where(and(eq(adminActions.postId, post.id), eq(adminActions.kind, 'remove_post')));
    expect(log).toMatchObject({ adminId: admin.id, targetUserId: them.id, reportId: report!.id });
  });

  it('removes a comment directly, and players cannot', async () => {
    const admin = await player({ admin: true });
    const me = await player();
    const post = await me.postIt();
    const comment = await me.comment(post.id, { text: 'oops' });
    await me.post(`/v1/admin/comments/${comment.id}/remove`, {}).expect(403);
    await admin.post(`/v1/admin/comments/${comment.id}/remove`, { note: 'rude' }).expect(204);
    expect((await me.get(`/v1/posts/${post.id}`)).body.commentCount).toBe(0);
    await admin.post(`/v1/admin/posts/${post.id}/remove`, {}).expect(204);
    await me.get(`/v1/posts/${post.id}`).expect(404);
    await admin.post(`/v1/admin/posts/${randomUUID()}/remove`, {}).expect(404);
  });

  it('deleting an account deletes its posts and comments', async () => {
    const me = await player();
    const friend = await player();
    const post = await me.postIt();
    const theirs = await friend.postIt();
    await me.comment(theirs.id, { text: 'bye' });
    await me.del('/v1/me', { password: PASSWORD }).expect(204);
    await friend.get(`/v1/posts/${post.id}`).expect(404);
    expect((await friend.get(`/v1/posts/${theirs.id}`)).body.commentCount).toBe(0);
    const row = await conn.db.query.posts.findFirst({ where: eq(posts.id, post.id) });
    expect(row!.status).toBe('deleted');
  });
});

describe('share pages and the app switch', () => {
  it('serves public posts for everyone without sign-in, nothing else', async () => {
    const me = await player();
    const post = await me.postIt({ text: 'x'.repeat(400), gameId: 'pubg' });
    const res = await http().get(`/v1/public/posts/${post.id}`).expect(200);
    expect(res.body).toMatchObject({
      id: post.id,
      type: 'milestone',
      author: { username: me.username },
      game: { id: 'pubg' },
    });
    expect(res.body.text).toHaveLength(300);
    expect(res.body.author.id).toBeUndefined();
    const hidden = await me.postIt({ audience: 'connections' });
    await http().get(`/v1/public/posts/${hidden.id}`).expect(404);
  });

  it('tells the apps whether the feed is on', async () => {
    const res = await http().get('/v1/app/config').expect(200);
    expect(res.body).toMatchObject({ feedEnabled: false, groupsEnabled: false });
  });
});
