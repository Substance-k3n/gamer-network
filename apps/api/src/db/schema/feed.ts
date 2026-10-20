import { sql } from 'drizzle-orm';
import {
  type AnyPgColumn,
  check,
  index,
  integer,
  pgTable,
  primaryKey,
  smallint,
  text,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';
import { games } from './catalog.js';
import { applicationStatus, contentStatus, mediaKind, postAudience, postType } from './enums.js';
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

/** Signed upload URLs handed out for post media. A post may use a key once, before it expires. */
export const mediaUploads = pgTable(
  'media_uploads',
  {
    key: text('key').primaryKey(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    kind: mediaKind('kind').notNull(),
    /** What the upload URL was signed for; the object is checked against these. */
    contentType: text('content_type').notNull(),
    size: integer('size').notNull(),
    expiresAt: ts('expires_at').notNull(),
    usedAt: ts('used_at'),
    createdAt: createdAt(),
  },
  (t) => [
    index('media_uploads_by_user').on(t.userId, t.createdAt),
    index('media_uploads_unused')
      .on(t.createdAt)
      .where(sql`${t.usedAt} is null`),
  ],
);

export const postMedia = pgTable(
  'post_media',
  {
    id: id(),
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    position: smallint('position').notNull(),
    kind: mediaKind('kind').notNull(),
    key: text('key').notNull(),
    contentType: text('content_type').notNull(),
    size: integer('size').notNull(),
    /** Null until clients send them; the upload flow takes keys only for now. */
    width: integer('width'),
    height: integer('height'),
    /** Videos only. */
    durationMs: integer('duration_ms'),
    posterKey: text('poster_key'),
    createdAt: createdAt(),
  },
  (t) => [
    unique('post_media_position').on(t.postId, t.position),
    check('post_media_position_range', sql`${t.position} between 0 and 3`),
  ],
);

export const polls = pgTable('polls', {
  postId: uuid('post_id')
    .primaryKey()
    .references(() => posts.id, { onDelete: 'cascade' }),
  endsAt: ts('ends_at').notNull(),
  createdAt: createdAt(),
});

// Votes are counted from poll_votes when read (no stored count), like GG.
export const pollOptions = pgTable(
  'poll_options',
  {
    postId: uuid('post_id')
      .notNull()
      .references(() => polls.postId, { onDelete: 'cascade' }),
    position: smallint('position').notNull(),
    label: text('label').notNull(),
    createdAt: createdAt(),
  },
  (t) => [
    primaryKey({ columns: [t.postId, t.position] }),
    check('poll_options_position_range', sql`${t.position} between 0 and 3`),
    check('poll_options_label_length', sql`char_length(${t.label}) between 1 and 60`),
  ],
);

/** One vote per person, final. */
export const pollVotes = pgTable(
  'poll_votes',
  {
    postId: uuid('post_id')
      .notNull()
      .references(() => polls.postId, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    position: smallint('position').notNull(),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.postId, t.userId] })],
);

export const recruitments = pgTable(
  'recruitments',
  {
    postId: uuid('post_id')
      .primaryKey()
      .references(() => posts.id, { onDelete: 'cascade' }),
    slots: smallint('slots').notNull(),
    /** Free text, e.g. "Sniper, Support"; empty when not given. */
    roles: text('roles').notNull().default(''),
    createdAt: createdAt(),
  },
  (t) => [
    check('recruitments_slots_range', sql`${t.slots} between 1 and 10`),
    check('recruitments_roles_length', sql`char_length(${t.roles}) <= 80`),
  ],
);

export const recruitApplications = pgTable(
  'recruit_applications',
  {
    id: id(),
    postId: uuid('post_id')
      .notNull()
      .references(() => recruitments.postId, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    status: applicationStatus('status').notNull().default('pending'),
    createdAt: createdAt(),
    decidedAt: ts('decided_at'),
  },
  (t) => [
    unique('recruit_applications_once').on(t.postId, t.userId),
    index('recruit_applications_of_post').on(t.postId, t.id),
    index('recruit_applications_by_user').on(t.userId, t.createdAt),
  ],
);
