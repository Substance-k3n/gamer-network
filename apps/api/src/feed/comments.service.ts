import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, gt, isNull, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import { decodeCursor, page } from '../common/cursor.js';
import { checkRate } from '../common/rate-limit.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { commentGg, comments, posts } from '../db/schema/index.js';
import type { CommentsQuery, CreateCommentBody } from './feed.body.js';
import type { CommentDto, CommentPageDto, GgDto } from './feed.dto.js';
import { FeedNotifier } from './feed-notifier.js';
import { FeedReader } from './feed-reader.js';

const HOUR_MS = 3600_000;
export const COMMENTS_PER_HOUR = 60;

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

/** sort=top pages by GG count, then id: the cursor carries both. */
const encodeTop = (gg: number, id: string) => Buffer.from(`${gg}|${id}`).toString('base64url');
function decodeTop(cursor: string | undefined): [number, string] | undefined {
  if (!cursor) return undefined;
  const [gg, id] = Buffer.from(cursor, 'base64url').toString().split('|');
  if (!gg || !/^\d+$/.test(gg) || !id || !/^[0-9a-f-]{36}$/.test(id)) {
    throw invalid({ cursor: 'Use nextCursor from the previous page' });
  }
  return [Number(gg), id];
}

@Injectable()
export class CommentsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly reader: FeedReader,
    private readonly notifier: FeedNotifier,
  ) {}

  /** Top-level comments of a post you may see: oldest first, or most GG first. */
  async list(viewer: User, postId: string, q: CommentsQuery): Promise<CommentPageDto> {
    await this.reader.postRow(viewer.id, postId);
    const limit = q.limit ?? 20;
    const top = eq(comments.postId, postId);
    if (q.sort === 'top') {
      const after = decodeTop(q.cursor);
      const gg = this.reader.commentGgCount;
      const rows = await this.reader
        .comments(
          viewer.id,
          and(
            top,
            isNull(comments.parentId),
            after
              ? sql`(${gg} < ${after[0]} or (${gg} = ${after[0]} and ${comments.id} > ${after[1]}))`
              : undefined,
          ),
        )
        .orderBy(desc(gg), asc(comments.id))
        .limit(limit + 1);
      const items = await this.reader.buildComments(rows.slice(0, limit), viewer.id);
      const last = items.at(-1);
      return {
        items,
        nextCursor: rows.length > limit && last ? encodeTop(last.ggCount, last.id) : null,
      };
    }
    return this.oldestFirst(viewer, and(top, isNull(comments.parentId)), limit, q.cursor);
  }

  /** Replies under a top-level comment, oldest first. */
  async replies(viewer: User, commentId: string, q: CommentsQuery): Promise<CommentPageDto> {
    const parent = await this.visible(viewer, commentId);
    return this.oldestFirst(viewer, eq(comments.parentId, parent.id), q.limit ?? 20, q.cursor);
  }

  private async oldestFirst(
    viewer: User,
    where: ReturnType<typeof and>,
    limit: number,
    cursor: string | undefined,
  ): Promise<CommentPageDto> {
    const after = decodeCursor(cursor);
    const rows = await this.reader
      .comments(viewer.id, and(where, after ? gt(comments.id, after) : undefined))
      .orderBy(asc(comments.id))
      .limit(limit + 1);
    const { items, nextCursor } = page(
      rows.map((r) => ({ ...r, id: r.comment.id })),
      limit,
    );
    return { items: await this.reader.buildComments(items, viewer.id), nextCursor };
  }

  /** The comment, if you may see it and its post. */
  private async visible(viewer: User, id: string) {
    const [row] = await this.reader.comments(viewer.id, eq(comments.id, id)).limit(1);
    if (!row) throw notFound('That comment');
    await this.reader.postRow(viewer.id, row.comment.postId).catch(() => {
      throw notFound('That comment');
    });
    return row.comment;
  }

  async create(viewer: User, postId: string, body: CreateCommentBody): Promise<CommentDto> {
    const post = await this.reader.postRow(viewer.id, postId);
    let parent: typeof comments.$inferSelect | undefined;
    // Who gets "replied to your comment": the one you answered, even inside a thread.
    let replyTo: string | null = null;
    if (body.parentId) {
      const [row] = await this.reader
        .comments(viewer.id, and(eq(comments.id, body.parentId), eq(comments.postId, postId)))
        .limit(1);
      if (!row) throw invalid({ parentId: 'Not a comment on this post' });
      parent = row.comment;
      replyTo = parent.authorId;
      // One level of replies: a reply to a reply goes under the same top-level comment.
      if (parent.parentId) {
        const top = await this.db.query.comments.findFirst({
          where: eq(comments.id, parent.parentId),
        });
        parent = top!;
      }
    }
    await checkRate(
      this.db,
      comments,
      { user: comments.authorId, createdAt: comments.createdAt },
      viewer.id,
      COMMENTS_PER_HOUR,
      HOUR_MS,
      'comments',
    );
    const id = await this.db.transaction(async (tx) => {
      const [comment] = await tx
        .insert(comments)
        .values({ postId, authorId: viewer.id, parentId: parent?.id ?? null, text: body.text })
        .returning();
      await this.notifier.commented(tx, post, comment!, replyTo);
      return comment!.id;
    });
    const [row] = await this.reader.comments(viewer.id, eq(comments.id, id)).limit(1);
    return (await this.reader.buildComments([row!], viewer.id))[0]!;
  }

  /** Its author, or the post's author. Replies under a deleted comment go with it. */
  async delete(viewer: User, id: string): Promise<void> {
    const comment = await this.visible(viewer, id);
    const post = await this.db.query.posts.findFirst({ where: eq(posts.id, comment.postId) });
    const own = comment.authorId === viewer.id;
    if (!own && post!.authorId !== viewer.id) {
      throw new AppError(
        HttpStatus.FORBIDDEN,
        'not_owner',
        'Only its author or the post’s author can delete it.',
      );
    }
    await this.db
      .update(comments)
      .set(
        own
          ? { status: 'deleted' }
          : { status: 'removed', removedAt: new Date(), removedBy: viewer.id },
      )
      .where(eq(comments.id, id));
  }

  async gg(viewer: User, id: string, on: boolean): Promise<GgDto> {
    await this.visible(viewer, id);
    if (on) {
      await this.db
        .insert(commentGg)
        .values({ commentId: id, userId: viewer.id })
        .onConflictDoNothing();
    } else {
      await this.db
        .delete(commentGg)
        .where(and(eq(commentGg.commentId, id), eq(commentGg.userId, viewer.id)));
    }
    const [row] = await this.reader.comments(viewer.id, eq(comments.id, id)).limit(1);
    const [built] = await this.reader.buildComments([row!], viewer.id);
    return { ggCount: built!.ggCount, myGG: on };
  }
}
