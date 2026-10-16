import { sql } from 'drizzle-orm';
import {
  type AnyPgColumn,
  check,
  index,
  pgTable,
  primaryKey,
  text,
  uuid,
} from 'drizzle-orm/pg-core';
import { games } from './catalog.js';
import { contentStatus, postAudience, postType } from './enums.js';
import { users } from './identity.js';
import { createdAt, id, ts } from './types.js';

// docs/FEED_AND_GROUPS_API.md "Data model". GG and comment counts are counted
// from the rows when read, so bans, blocks and deletions never leave them wrong.

export const posts = pgTable(
  'posts',
  {
    id: id(),
    authorId: uuid('author_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    type: postType('type').notNull(),
    /** Null: "Any game". */
    gameId: text('game_id').references(() => games.id),
    text: text('text').notNull(),
    audience: postAudience('audience').notNull().default('everyone'),
    status: contentStatus('status').notNull().default('live'),
    createdAt: createdAt(),
    removedAt: ts('removed_at'),
    removedBy: uuid('removed_by').references(() => users.id, { onDelete: 'set null' }),
  },
  (t) => [
    index('posts_feed').on(t.status, t.id.desc()),
    index('posts_by_author').on(t.authorId, t.id.desc()),
    check('posts_text_length', sql`char_length(${t.text}) between 1 and 2000`),
  ],
);

export const comments = pgTable(
  'comments',
  {
    id: id(),
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    authorId: uuid('author_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    /** Null for a top-level comment. One level of replies: always a top-level comment. */
    parentId: uuid('parent_id').references((): AnyPgColumn => comments.id, {
      onDelete: 'cascade',
    }),
    text: text('text').notNull(),
    status: contentStatus('status').notNull().default('live'),
    createdAt: createdAt(),
    removedAt: ts('removed_at'),
    removedBy: uuid('removed_by').references(() => users.id, { onDelete: 'set null' }),
  },
  (t) => [
    index('comments_of_post').on(t.postId, t.id),
    index('comments_replies').on(t.parentId, t.id),
    check('comments_text_length', sql`char_length(${t.text}) between 1 and 500`),
  ],
);

export const postGg = pgTable(
  'post_gg',
  {
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.postId, t.userId] })],
);

export const commentGg = pgTable(
  'comment_gg',
  {
    commentId: uuid('comment_id')
      .notNull()
      .references(() => comments.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.commentId, t.userId] })],
);

export const savedPosts = pgTable(
  'saved_posts',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    createdAt: createdAt(),
  },
  (t) => [
    primaryKey({ columns: [t.userId, t.postId] }),
    index('saved_posts_recent').on(t.userId, t.createdAt.desc()),
  ],
);
