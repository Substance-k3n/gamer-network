import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, lt, or, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import { decodeCursor, page, type PageQuery } from '../common/cursor.js';
import { checkRate } from '../common/rate-limit.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { games, postGg, posts, savedPosts, users } from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import { isLive, visibleTo } from '../users/visibility.js';
import type { CreatePostBody, FeedQuery } from './feed.body.js';
import type { GgDto, PostDto, PostPageDto, PostType, PublicPostDto } from './feed.dto.js';
import { FeedNotifier } from './feed-notifier.js';
import { FeedReader } from './feed-reader.js';
import { connectedTo } from './visibility.js';

const HOUR_MS = 3600_000;
export const POSTS_PER_HOUR = 10;

/** Types that carry media, a poll or slots; they come with the later phases of the feed. */
const NOT_YET: PostType[] = ['gameplay', 'poll', 'recruitment'];
const LFG: PostType[] = ['recruitment', 'looking_for_players'];

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

/** Saved posts page by when they were saved: the cursor is that time and the post id. */
const encodeSaved = (at: string, id: string) => Buffer.from(`${at}|${id}`).toString('base64url');
function decodeSaved(cursor: string | undefined): [string, string] | undefined {
  if (!cursor) return undefined;
  const [at, id] = Buffer.from(cursor, 'base64url').toString().split('|');
  if (!at || !id || Number.isNaN(Date.parse(at)) || !/^[0-9a-f-]{36}$/.test(id)) {
    throw invalid({ cursor: 'Use nextCursor from the previous page' });
  }
  return [at, id];
}

@Injectable()
export class PostsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly reader: FeedReader,
    private readonly notifier: FeedNotifier,
    private readonly profiles: ProfileService,
  ) {}

  async create(author: User, body: CreatePostBody): Promise<PostDto> {
    if (NOT_YET.includes(body.type)) {
      throw invalid({ type: 'Photos, polls and recruitment posts are coming soon' });
    }
    if (body.gameId) {
      const game = await this.db.query.games.findFirst({ where: eq(games.id, body.gameId) });
      if (!game) throw invalid({ gameId: 'Unknown game' });
    }
    await checkRate(
      this.db,
      posts,
      { user: posts.authorId, createdAt: posts.createdAt },
      author.id,
      POSTS_PER_HOUR,
      HOUR_MS,
      'posts',
    );
    const id = await this.db.transaction(async (tx) => {
      const [post] = await tx
        .insert(posts)
        .values({
          authorId: author.id,
          type: body.type,
          gameId: body.gameId ?? null,
          text: body.text,
          audience: body.audience ?? 'everyone',
        })
        .returning();
      await this.notifier.posted(tx, post!);
      return post!.id;
    });
    return this.reader.post(author.id, id);
  }

  /** Home, newest first. */
  async feed(viewer: User, q: FeedQuery): Promise<PostPageDto> {
    const filter = q.filter ?? 'for_you';
    if (filter === 'game' && !q.game) throw invalid({ game: 'Pick a game for filter=game' });
    const limit = q.limit ?? 20;
    const after = decodeCursor(q.cursor);
    const rows = await this.reader
      .posts(
        viewer.id,
        and(
          after ? lt(posts.id, after) : undefined,
          filter === 'connections'
            ? or(eq(posts.authorId, viewer.id), connectedTo(this.db, viewer.id, posts.authorId))
            : undefined,
          filter === 'lfg' ? inArray(posts.type, LFG) : undefined,
          q.game ? eq(posts.gameId, q.game) : undefined,
        ),
      )
      .orderBy(desc(posts.id))
      .limit(limit + 1);
    return this.paged(rows, limit, viewer.id);
  }

  get(viewer: User, id: string): Promise<PostDto> {
    return this.reader.post(viewer.id, id);
  }

  /** Moments: someone's posts you may see, newest first. 404 when you can't see them. */
  async byUser(viewer: User, username: string, q: PageQuery): Promise<PostPageDto> {
    const user = await this.db.query.users.findFirst({
      where: and(eq(users.username, username.trim().toLowerCase()), visibleTo(this.db, viewer.id)),
    });
    if (!user) throw notFound('That player');
    return this.authored(viewer, user.id, q);
  }

  /** Yours, connections-only ones included. */
  mine(viewer: User, q: PageQuery): Promise<PostPageDto> {
    return this.authored(viewer, viewer.id, q);
  }

  private async authored(viewer: User, authorId: string, q: PageQuery): Promise<PostPageDto> {
    const limit = q.limit ?? 20;
    const after = decodeCursor(q.cursor);
    const rows = await this.reader
      .posts(viewer.id, and(eq(posts.authorId, authorId), after ? lt(posts.id, after) : undefined))
      .orderBy(desc(posts.id))
      .limit(limit + 1);
    return this.paged(rows, limit, viewer.id);
  }

  private async paged(
    rows: Awaited<ReturnType<FeedReader['posts']>>,
    limit: number,
    viewerId: string,
  ): Promise<PostPageDto> {
    const { items, nextCursor } = page(
      rows.map((r) => ({ ...r, id: r.post.id })),
      limit,
    );
    return { items: await this.reader.buildPosts(items, viewerId), nextCursor };
  }

  /** Author only; 403 not_owner for anyone else. */
  async delete(viewer: User, id: string): Promise<void> {
    const post = await this.reader.postRow(viewer.id, id);
    if (post.authorId !== viewer.id) {
      throw new AppError(
        HttpStatus.FORBIDDEN,
        'not_owner',
        'Only the person who posted it can delete it.',
      );
    }
    await this.db.update(posts).set({ status: 'deleted' }).where(eq(posts.id, id));
  }

  /** Repeating either is fine. */
  async gg(viewer: User, id: string, on: boolean): Promise<GgDto> {
    await this.reader.postRow(viewer.id, id);
    await this.db.transaction(async (tx) => {
      // Locks the post, so GGs on it (and their notification) go one at a time.
      const [post] = await tx.select().from(posts).where(eq(posts.id, id)).for('update');
      if (!on) {
        await tx.delete(postGg).where(and(eq(postGg.postId, id), eq(postGg.userId, viewer.id)));
        return;
      }
      const added = await tx
        .insert(postGg)
        .values({ postId: id, userId: viewer.id })
        .onConflictDoNothing()
        .returning({ postId: postGg.postId });
      if (added.length) await this.notifier.gg(tx, post!, viewer.id);
    });
    const counts = await this.reader.ggCounts([id]);
    return { ggCount: counts.get(id) ?? 0, myGG: on };
  }

  async save(viewer: User, id: string, on: boolean): Promise<void> {
    if (!on) {
      await this.db
        .delete(savedPosts)
        .where(and(eq(savedPosts.userId, viewer.id), eq(savedPosts.postId, id)));
      return;
    }
    await this.reader.postRow(viewer.id, id);
    await this.db
      .insert(savedPosts)
      .values({ userId: viewer.id, postId: id })
      .onConflictDoNothing();
  }

  /** Most recently saved first; ones you can no longer see are left out. */
  async saved(viewer: User, q: PageQuery): Promise<PostPageDto> {
    const limit = q.limit ?? 20;
    const after = decodeSaved(q.cursor);
    const savedAt = sql<Date>`(select ${savedPosts.createdAt} from ${savedPosts}
      where ${savedPosts.userId} = ${viewer.id} and ${savedPosts.postId} = ${posts.id})`;
    const rows = await this.reader
      .posts(
        viewer.id,
        and(
          sql`${savedAt} is not null`,
          after
            ? sql`(${savedAt}, ${posts.id}) < (${after[0]}::timestamptz, ${after[1]}::uuid)`
            : undefined,
        ),
      )
      .orderBy(desc(savedAt), desc(posts.id))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    let nextCursor: string | null = null;
    if (rows.length > limit) {
      const last = items.at(-1)!;
      const [at] = await this.db
        .select({ at: sql<string>`${savedPosts.createdAt}::text` })
        .from(savedPosts)
        .where(and(eq(savedPosts.userId, viewer.id), eq(savedPosts.postId, last.post.id)));
      nextCursor = encodeSaved(at!.at, last.post.id);
    }
    return { items: await this.reader.buildPosts(items, viewer.id), nextCursor };
  }

  /** For share pages, no sign-in: live posts for everyone by live authors only. */
  async publicPost(id: string): Promise<PublicPostDto> {
    const [row] = await this.db
      .select({
        post: posts,
        author: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
      })
      .from(posts)
      .innerJoin(users, eq(users.id, posts.authorId))
      .leftJoin(games, eq(games.id, posts.gameId))
      .where(
        and(eq(posts.id, id), eq(posts.status, 'live'), eq(posts.audience, 'everyone'), isLive()),
      )
      .limit(1);
    if (!row) throw notFound('That post');
    return {
      id: row.post.id,
      type: row.post.type,
      text: row.post.text.slice(0, 300),
      author: {
        displayName: row.author.displayName,
        username: row.author.username,
        avatarUrl: await this.profiles.avatarUrl(row.author.avatarKey),
      },
      game: row.game,
      createdAt: row.post.createdAt,
    };
  }
}
