import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, type SQL, sql } from 'drizzle-orm';
import { notFound } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  commentGg,
  comments,
  games,
  groups,
  pollOptions,
  polls,
  pollVotes,
  postGg,
  posts,
  recruitApplications,
  recruitments,
  savedPosts,
  users,
} from '../db/schema/index.js';
import { env } from '../env.js';
import { ProfileService } from '../me/profile.service.js';
import { isLive, visibleTo } from '../users/visibility.js';
import {
  type CommentDto,
  kindOf,
  type PollDto,
  type PostDto,
  type RecruitDto,
} from './feed.dto.js';
import { MediaService } from './media.service.js';
import { commentLive, postVisibleTo } from './visibility.js';

type Counts = Map<string, number>;

/** Builds posts and comments as a viewer sees them; shared by the feed's services. */
@Injectable()
export class FeedReader {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
    private readonly media: MediaService,
  ) {}

  /** Posts `viewerId` may see, with author and game. Add filters with `where`. */
  posts(viewerId: string, where?: SQL) {
    return this.db
      .select({
        post: posts,
        author: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
      })
      .from(posts)
      .innerJoin(users, eq(users.id, posts.authorId))
      .leftJoin(games, eq(games.id, posts.gameId))
      .where(and(postVisibleTo(this.db, viewerId), where));
  }

  /** The post, or 404 when it's hidden from `viewerId`. */
  async post(viewerId: string, id: string): Promise<PostDto> {
    const [built] = await this.buildPosts(
      await this.posts(viewerId, eq(posts.id, id)).limit(1),
      viewerId,
    );
    if (!built) throw notFound('That post');
    return built;
  }

  /** The bare post row, or 404 when it's hidden from `viewerId`. */
  async postRow(viewerId: string, id: string) {
    const [row] = await this.posts(viewerId, eq(posts.id, id)).limit(1);
    if (!row) throw notFound('That post');
    return row.post;
  }

  async buildPosts(
    rows: {
      post: typeof posts.$inferSelect;
      author: typeof users.$inferSelect;
      game: PostDto['game'];
    }[],
    viewerId: string,
  ): Promise<PostDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((r) => r.post.id);
    const ofType = (type: PostDto['type']) =>
      rows.filter((r) => r.post.type === type).map((r) => r.post.id);
    const groupIds = [...new Set(rows.flatMap((r) => (r.post.groupId ? [r.post.groupId] : [])))];
    const [authors, ggs, commentCounts, mine, saved, tops, media, pollOf, recruitOf, groupRows] =
      await Promise.all([
        this.profiles.cards(rows.map((r) => r.author)),
        this.ggCounts(ids),
        this.commentCounts(ids),
        this.mineIn(postGg, postGg.postId, postGg.userId, ids, viewerId),
        this.mineIn(savedPosts, savedPosts.postId, savedPosts.userId, ids, viewerId),
        this.topComments(ofType('discussion'), viewerId),
        this.media.forPosts(ids),
        this.polls(ofType('poll'), viewerId),
        this.recruits(ofType('recruitment'), viewerId),
        groupIds.length
          ? this.db
              .select({ id: groups.id, name: groups.name, short: groups.short, tone: groups.tone })
              .from(groups)
              .where(inArray(groups.id, groupIds))
          : [],
      ]);
    const groupOf = new Map(groupRows.map((g) => [g.id, g]));
    return rows.map(({ post: p, game }, i) => ({
      id: p.id,
      type: p.type,
      kind: kindOf(p.type),
      author: authors[i]!,
      group: (p.groupId && groupOf.get(p.groupId)) || null,
      game,
      text: p.text,
      audience: p.audience,
      media: media.get(p.id) ?? [],
      poll: pollOf.get(p.id) ?? null,
      recruit: recruitOf.get(p.id) ?? null,
      topComment: tops.get(p.id) ?? null,
      ggCount: ggs.get(p.id) ?? 0,
      commentCount: commentCounts.get(p.id) ?? 0,
      myGG: mine.has(p.id),
      saved: saved.has(p.id),
      mine: p.authorId === viewerId,
      shareUrl: `${env.publicWebUrl}/p/${p.id}`,
      createdAt: p.createdAt,
    }));
  }

  /** Polls on `postIds`, as `viewerId` sees them. Votes from people no longer live don't count. */
  async polls(
    postIds: string[],
    viewerId: string,
    now = new Date(),
  ): Promise<Map<string, PollDto>> {
    if (postIds.length === 0) return new Map();
    const [heads, options, votes, mine] = await Promise.all([
      this.db.select().from(polls).where(inArray(polls.postId, postIds)),
      this.db
        .select()
        .from(pollOptions)
        .where(inArray(pollOptions.postId, postIds))
        .orderBy(asc(pollOptions.postId), asc(pollOptions.position)),
      this.db
        .select({
          id: pollVotes.postId,
          position: pollVotes.position,
          n: sql<number>`count(*)::int`,
        })
        .from(pollVotes)
        .innerJoin(users, eq(users.id, pollVotes.userId))
        .where(and(inArray(pollVotes.postId, postIds), isLive()))
        .groupBy(pollVotes.postId, pollVotes.position),
      this.db
        .select({ id: pollVotes.postId, position: pollVotes.position })
        .from(pollVotes)
        .where(and(eq(pollVotes.userId, viewerId), inArray(pollVotes.postId, postIds))),
    ]);
    const count = new Map(votes.map((v) => [`${v.id}:${v.position}`, v.n]));
    const myVote = new Map(mine.map((m) => [m.id, m.position]));
    return new Map(
      heads.map((h) => {
        const opts = options
          .filter((o) => o.postId === h.postId)
          .map((o) => ({
            position: o.position,
            label: o.label,
            votes: count.get(`${h.postId}:${o.position}`) ?? 0,
          }));
        return [
          h.postId,
          {
            options: opts,
            totalVotes: opts.reduce((sum, o) => sum + o.votes, 0),
            myVote: myVote.get(h.postId) ?? null,
            endsAt: h.endsAt,
            closed: h.endsAt <= now,
          },
        ];
      }),
    );
  }

  /**
   * Recruitment on `postIds`. Applications count only from people `viewerId`
   * may see (live, no block either way), so the author's count matches the list.
   */
  async recruits(postIds: string[], viewerId: string): Promise<Map<string, RecruitDto>> {
    if (postIds.length === 0) return new Map();
    const [heads, counts, mine] = await Promise.all([
      this.db.select().from(recruitments).where(inArray(recruitments.postId, postIds)),
      this.db
        .select({ id: recruitApplications.postId, n: sql<number>`count(*)::int` })
        .from(recruitApplications)
        .innerJoin(users, eq(users.id, recruitApplications.userId))
        .where(and(inArray(recruitApplications.postId, postIds), visibleTo(this.db, viewerId)))
        .groupBy(recruitApplications.postId),
      this.db
        .select({ id: recruitApplications.postId, status: recruitApplications.status })
        .from(recruitApplications)
        .where(
          and(
            eq(recruitApplications.userId, viewerId),
            inArray(recruitApplications.postId, postIds),
          ),
        ),
    ]);
    const applications = new Map(counts.map((c) => [c.id, c.n]));
    const myApplication = new Map(mine.map((m) => [m.id, m.status]));
    return new Map(
      heads.map((h) => [
        h.postId,
        {
          slots: h.slots,
          roles: h.roles,
          applications: applications.get(h.postId) ?? 0,
          myApplication: myApplication.get(h.postId) ?? null,
        },
      ]),
    );
  }

  /** GGs from people still live. */
  async ggCounts(ids: string[]): Promise<Counts> {
    if (ids.length === 0) return new Map();
    const rows = await this.db
      .select({ id: postGg.postId, n: sql<number>`count(*)::int` })
      .from(postGg)
      .innerJoin(users, eq(users.id, postGg.userId))
      .where(and(inArray(postGg.postId, ids), isLive()))
      .groupBy(postGg.postId);
    return new Map(rows.map((r) => [r.id, r.n]));
  }

  /** Live comments and replies by live people. */
  private async commentCounts(ids: string[]): Promise<Counts> {
    const rows = await this.db
      .select({ id: comments.postId, n: sql<number>`count(*)::int` })
      .from(comments)
      .innerJoin(users, eq(users.id, comments.authorId))
      .where(and(inArray(comments.postId, ids), commentLive(this.db), isLive()))
      .groupBy(comments.postId);
    return new Map(rows.map((r) => [r.id, r.n]));
  }

  /** Which of `ids` the viewer has a row for in a (thing, user) table. */
  private async mineIn(
    table: typeof postGg | typeof savedPosts | typeof commentGg,
    idCol: typeof postGg.postId | typeof savedPosts.postId | typeof commentGg.commentId,
    userCol: typeof postGg.userId | typeof savedPosts.userId | typeof commentGg.userId,
    ids: string[],
    viewerId: string,
  ): Promise<Set<string>> {
    if (ids.length === 0) return new Set();
    const rows = await this.db
      .select({ id: idCol })
      .from(table)
      .where(and(eq(userCol, viewerId), inArray(idCol, ids)));
    return new Set(rows.map((r) => r.id));
  }

  /** Comments `viewerId` may see, with their author. The post itself is checked by the caller. */
  comments(viewerId: string, where?: SQL) {
    return this.db
      .select({ comment: comments, author: users })
      .from(comments)
      .innerJoin(users, eq(users.id, comments.authorId))
      .where(and(commentLive(this.db), visibleTo(this.db, viewerId), where));
  }

  /** The number of GGs on a comment, as a sortable expression. */
  readonly commentGgCount = sql<number>`(
    select count(*)::int from ${commentGg}
    inner join ${users} as gg_user on gg_user.id = ${commentGg.userId}
    where ${commentGg.commentId} = ${comments.id}
      and gg_user.onboarded_at is not null and gg_user.banned_at is null and gg_user.deleted_at is null
  )`;

  async buildComments(
    rows: { comment: typeof comments.$inferSelect; author: typeof users.$inferSelect }[],
    viewerId: string,
  ): Promise<CommentDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((r) => r.comment.id);
    const [authors, ggs, replies, mine] = await Promise.all([
      this.profiles.cards(rows.map((r) => r.author)),
      this.db
        .select({ id: commentGg.commentId, n: sql<number>`count(*)::int` })
        .from(commentGg)
        .innerJoin(users, eq(users.id, commentGg.userId))
        .where(and(inArray(commentGg.commentId, ids), isLive()))
        .groupBy(commentGg.commentId),
      this.db
        .select({ id: comments.parentId, n: sql<number>`count(*)::int` })
        .from(comments)
        .innerJoin(users, eq(users.id, comments.authorId))
        .where(and(inArray(comments.parentId, ids), eq(comments.status, 'live'), isLive()))
        .groupBy(comments.parentId),
      this.mineIn(commentGg, commentGg.commentId, commentGg.userId, ids, viewerId),
    ]);
    const gg = new Map(ggs.map((r) => [r.id, r.n]));
    const replyCount = new Map(replies.map((r) => [r.id!, r.n]));
    return rows.map(({ comment: c }, i) => ({
      id: c.id,
      postId: c.postId,
      parentId: c.parentId,
      author: authors[i]!,
      text: c.text,
      ggCount: gg.get(c.id) ?? 0,
      myGG: mine.has(c.id),
      mine: c.authorId === viewerId,
      replies: replyCount.get(c.id) ?? 0,
      createdAt: c.createdAt,
    }));
  }

  /** Discussions: the most-GG'd top-level answer of each post, oldest first on a tie. */
  private async topComments(postIds: string[], viewerId: string): Promise<Map<string, CommentDto>> {
    if (postIds.length === 0) return new Map();
    const rows = await this.db
      .selectDistinctOn([comments.postId], { comment: comments, author: users })
      .from(comments)
      .innerJoin(users, eq(users.id, comments.authorId))
      .where(
        and(
          inArray(comments.postId, postIds),
          isNull(comments.parentId),
          eq(comments.status, 'live'),
          visibleTo(this.db, viewerId),
        ),
      )
      .orderBy(comments.postId, desc(this.commentGgCount), asc(comments.id));
    const built = await this.buildComments(rows, viewerId);
    return new Map(built.map((c) => [c.postId, c]));
  }
}
