import { Injectable } from '@nestjs/common';
import { and, eq, exists, inArray, isNull, ne, not, or, sql } from 'drizzle-orm';
import type { Db, Tx } from '../db/db.js';
import { blocks, notifications, posts, users } from '../db/schema/index.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { isLive } from '../users/visibility.js';
import { connectedTo } from './visibility.js';

type Post = typeof posts.$inferSelect;

/** At most this many @mentions in one post or comment notify anyone. */
export const MAX_MENTIONS = 5;

/** The usernames @mentioned in `text`, lowercase, first MAX_MENTIONS distinct. */
export function mentionedUsernames(text: string): string[] {
  const names = new Set<string>();
  for (const m of text.matchAll(/(?<![a-z0-9._@])@([a-z0-9._]{3,20})/gi)) {
    const name = m[1]!.toLowerCase().replace(/\.+$/, '');
    if (name.length >= 3) names.add(name);
    if (names.size === MAX_MENTIONS) break;
  }
  return [...names];
}

const blockedEitherWay = (db: Db | Tx, x: string, y: typeof users.id) =>
  exists(
    db
      .select({ one: sql`1` })
      .from(blocks)
      .where(
        or(
          and(eq(blocks.blockerId, x), eq(blocks.blockedId, y)),
          and(eq(blocks.blockerId, y), eq(blocks.blockedId, x)),
        ),
      ),
  );

/**
 * docs/FEED_AND_GROUPS_API.md "Notifications": never about your own action,
 * never across a block, never about something the person can't see. Pass
 * the caller's transaction.
 */
@Injectable()
export class FeedNotifier {
  constructor(private readonly notifier: NotificationsService) {}

  /** Of `userIds`, the ones who may see `post` and have no block with `actorId`. */
  private async canSee(tx: Tx, post: Post, actorId: string, userIds: string[]) {
    const ids = [...new Set(userIds)].filter((id) => id !== actorId);
    if (ids.length === 0) return new Set<string>();
    const rows = await tx
      .select({ id: users.id })
      .from(users)
      .where(
        and(
          inArray(users.id, ids),
          isLive(),
          not(blockedEitherWay(tx, actorId, users.id)),
          not(blockedEitherWay(tx, post.authorId, users.id)),
          post.audience === 'everyone'
            ? undefined
            : or(eq(users.id, post.authorId), connectedTo(tx, post.authorId, users.id)),
        ),
      );
    return new Set(rows.map((r) => r.id));
  }

  /**
   * GG doesn't stack: while the author hasn't read it, one post_gg per post
   * names the latest person and Alerts counts the rest. Not pushed. Call with
   * the post row locked, so two first GGs can't both write one.
   */
  async gg(tx: Tx, post: Post, actorId: string): Promise<void> {
    if (post.authorId === actorId) return;
    const [open] = await tx
      .update(notifications)
      .set({ actorId })
      .where(
        and(
          eq(notifications.userId, post.authorId),
          eq(notifications.type, 'post_gg'),
          eq(notifications.postId, post.id),
          isNull(notifications.readAt),
        ),
      )
      .returning({ id: notifications.id });
    if (open) return;
    await tx.insert(notifications).values({
      userId: post.authorId,
      type: 'post_gg',
      actorId,
      postId: post.id,
      pushedAt: new Date(),
    });
  }

  /** A new post: its @mentions. */
  async posted(tx: Tx, post: Post): Promise<void> {
    await this.mentions(tx, post, post.text, null, post.authorId, new Set());
  }

  /** A new comment: the post's author, the parent comment's author, and @mentions. Each person once. */
  async commented(
    tx: Tx,
    post: Post,
    comment: { id: string; text: string; authorId: string },
    parentAuthorId: string | null,
  ): Promise<void> {
    const actorId = comment.authorId;
    const allowed = await this.canSee(tx, post, actorId, [
      post.authorId,
      ...(parentAuthorId ? [parentAuthorId] : []),
    ]);
    const done = new Set<string>();
    const rows: (typeof notifications.$inferInsert)[] = [];
    const base = { actorId, postId: post.id, commentId: comment.id };
    if (parentAuthorId && allowed.has(parentAuthorId)) {
      rows.push({ ...base, userId: parentAuthorId, type: 'comment_reply' });
      done.add(parentAuthorId);
    }
    if (allowed.has(post.authorId) && !done.has(post.authorId)) {
      rows.push({ ...base, userId: post.authorId, type: 'post_comment' });
      done.add(post.authorId);
    }
    await this.notifier.notify(tx, rows);
    await this.mentions(tx, post, comment.text, comment.id, actorId, done);
  }

  private async mentions(
    tx: Tx,
    post: Post,
    text: string,
    commentId: string | null,
    actorId: string,
    skip: Set<string>,
  ): Promise<void> {
    const names = mentionedUsernames(text);
    if (names.length === 0) return;
    const found = await tx
      .select({ id: users.id })
      .from(users)
      .where(and(inArray(users.username, names), ne(users.id, actorId)));
    const allowed = await this.canSee(
      tx,
      post,
      actorId,
      found.map((u) => u.id).filter((id) => !skip.has(id)),
    );
    await this.notifier.notify(
      tx,
      [...allowed].map((userId) => ({
        userId,
        type: 'mention' as const,
        actorId,
        postId: post.id,
        commentId,
      })),
    );
  }
}
