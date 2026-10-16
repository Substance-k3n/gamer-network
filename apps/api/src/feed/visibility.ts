import { and, type AnyColumn, eq, exists, isNull, or, sql } from 'drizzle-orm';
import { alias } from 'drizzle-orm/pg-core';
import type { Db, Tx } from '../db/db.js';
import { comments, connections, posts } from '../db/schema/index.js';
import { visibleTo } from '../users/visibility.js';

// docs/FEED_AND_GROUPS_API.md "Endpoints": hidden means 404. A post is
// hidden when deleted or removed, when its author is banned, deleted or
// blocked either way, or when it's for connections and you aren't one.

/** `viewerId` and the user in `other` are connected. */
export const connectedTo = (db: Db | Tx, viewerId: string, other: AnyColumn) =>
  exists(
    db
      .select({ one: sql`1` })
      .from(connections)
      .where(
        or(
          and(eq(connections.userAId, viewerId), eq(connections.userBId, other)),
          and(eq(connections.userAId, other), eq(connections.userBId, viewerId)),
        ),
      ),
  );

/** Posts `viewerId` may see. The query must join `users` as the post's author. */
export const postVisibleTo = (db: Db, viewerId: string) =>
  and(
    eq(posts.status, 'live'),
    visibleTo(db, viewerId),
    or(
      eq(posts.audience, 'everyone'),
      eq(posts.authorId, viewerId),
      connectedTo(db, viewerId, posts.authorId),
    ),
  );

const parent = alias(comments, 'parent');

/** Live comments under a live parent (or top-level). Join `users` as the comment's author and add visibleTo or isLive. */
export const commentLive = (db: Db) =>
  and(
    eq(comments.status, 'live'),
    or(
      isNull(comments.parentId),
      exists(
        db
          .select({ one: sql`1` })
          .from(parent)
          .where(and(eq(parent.id, comments.parentId), eq(parent.status, 'live'))),
      ),
    ),
  );
