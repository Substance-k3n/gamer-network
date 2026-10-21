import { sql } from 'drizzle-orm';
import {
  boolean,
  check,
  index,
  integer,
  pgTable,
  primaryKey,
  text,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { games } from './catalog.js';
import { contentStatus, groupKind, groupRole, groupTone, membershipStatus } from './enums.js';
import { users } from './identity.js';
import { createdAt, id, ts } from './types.js';

// docs/FEED_AND_GROUPS_API.md "Data model". member_count is kept in step
// with group_members (Discover sorts by it); who's going to an event is
// counted from the rows when read, like GG.

export const groups = pgTable(
  'groups',
  {
    id: id(),
    name: text('name').notNull(),
    /** The badge: 2–5 uppercase letters or digits, made from the name when not given. */
    short: text('short').notNull(),
    kind: groupKind('kind').notNull(),
    /** Required when kind = game. */
    gameId: text('game_id').references(() => games.id),
    /** City, campus or country. */
    place: text('place').notNull(),
    about: text('about').notNull().default(''),
    rules: text('rules')
      .array()
      .notNull()
      .default(sql`'{}'::text[]`),
    tone: groupTone('tone').notNull().default('accent'),
    /** New members wait for an admin. */
    approval: boolean('approval').notNull().default(false),
    createdBy: uuid('created_by')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    /** Rows with status member. */
    memberCount: integer('member_count').notNull().default(0),
    /** deleted: its last member left (or the account of its only member went). removed: by an admin. */
    status: contentStatus('status').notNull().default('live'),
    createdAt: createdAt(),
  },
  (t) => [
    // Unique among live groups, so an archived or removed group frees its name.
    uniqueIndex('groups_name_unique')
      .on(sql`lower(${t.name})`)
      .where(sql`${t.status} = 'live'`),
    index('groups_discover').on(t.status, t.memberCount.desc(), t.id.desc()),
    index('groups_by_creator').on(t.createdBy, t.createdAt),
    check('groups_name_length', sql`char_length(${t.name}) between 3 and 40`),
    check('groups_short_format', sql`${t.short} ~ '^[A-Z0-9]{2,5}$'`),
    check('groups_place_length', sql`char_length(${t.place}) between 1 and 60`),
    check('groups_about_length', sql`char_length(${t.about}) <= 500`),
    check('groups_rules_count', sql`coalesce(array_length(${t.rules}, 1), 0) <= 10`),
    check('groups_game_kind', sql`${t.kind} <> 'game' or ${t.gameId} is not null`),
  ],
);

export const groupMembers = pgTable(
  'group_members',
  {
    groupId: uuid('group_id')
      .notNull()
      .references(() => groups.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    role: groupRole('role').notNull().default('member'),
    status: membershipStatus('status').notNull(),
    /** When the request was made (or they joined straight away). */
    createdAt: createdAt(),
    /** Null while pending. */
    joinedAt: ts('joined_at'),
  },
  (t) => [
    primaryKey({ columns: [t.groupId, t.userId] }),
    index('group_members_by_user').on(t.userId, t.status),
    index('group_members_of_group').on(t.groupId, t.status, t.role),
  ],
);

export const groupEvents = pgTable(
  'group_events',
  {
    id: id(),
    groupId: uuid('group_id')
      .notNull()
      .references(() => groups.id, { onDelete: 'cascade' }),
    createdBy: uuid('created_by')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    title: text('title').notNull(),
    startsAt: ts('starts_at').notNull(),
    gameId: text('game_id').references(() => games.id),
    createdAt: createdAt(),
  },
  (t) => [
    index('group_events_upcoming').on(t.groupId, t.startsAt),
    check('group_events_title_length', sql`char_length(${t.title}) between 1 and 80`),
  ],
);

export const groupEventGoing = pgTable(
  'group_event_going',
  {
    eventId: uuid('event_id')
      .notNull()
      .references(() => groupEvents.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.eventId, t.userId] })],
);
