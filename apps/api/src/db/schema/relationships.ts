import { sql } from 'drizzle-orm';
import { check, index, pgTable, primaryKey, text, uniqueIndex, uuid } from 'drizzle-orm/pg-core';
import { games } from './catalog.js';
import { checkInAnswer, inviteStatus, inviteWhen, requestStatus } from './enums.js';
import { users } from './identity.js';
import { listings } from './listings.js';
import { createdAt, id, ts } from './types.js';

export const connectionRequests = pgTable(
  'connection_requests',
  {
    id: id(),
    fromUserId: uuid('from_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    toUserId: uuid('to_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    listingId: uuid('listing_id').references(() => listings.id, { onDelete: 'set null' }),
    message: text('message'),
    status: requestStatus('status').notNull().default('pending'),
    createdAt: createdAt(),
    respondedAt: ts('responded_at'),
  },
  (t) => [
    uniqueIndex('connection_requests_one_pending')
      .on(t.fromUserId, t.toUserId)
      .where(sql`${t.status} = 'pending'`),
    index().on(t.toUserId, t.status),
    index().on(t.listingId),
    check('connection_requests_not_self', sql`${t.fromUserId} <> ${t.toUserId}`),
    check('connection_requests_message_length', sql`char_length(${t.message}) <= 140`),
  ],
);

/** Each pair once: user_a_id < user_b_id. */
export const connections = pgTable(
  'connections',
  {
    userAId: uuid('user_a_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    userBId: uuid('user_b_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    sourceRequestId: uuid('source_request_id').references(() => connectionRequests.id, {
      onDelete: 'set null',
    }),
    sourceListingId: uuid('source_listing_id').references(() => listings.id, {
      onDelete: 'set null',
    }),
    createdAt: createdAt(),
  },
  (t) => [
    primaryKey({ columns: [t.userAId, t.userBId] }),
    index().on(t.userBId),
    check('connections_ordered_pair', sql`${t.userAId} < ${t.userBId}`),
  ],
);

export const playInvites = pgTable(
  'play_invites',
  {
    id: id(),
    fromUserId: uuid('from_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    toUserId: uuid('to_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    gameId: text('game_id')
      .notNull()
      .references(() => games.id),
    playWhen: inviteWhen('play_when').notNull(),
    startsAt: ts('starts_at').notNull(),
    status: inviteStatus('status').notNull().default('pending'),
    createdAt: createdAt(),
    expiresAt: ts('expires_at').notNull(),
    respondedAt: ts('responded_at'),
  },
  (t) => [
    index().on(t.toUserId, t.status),
    check('play_invites_not_self', sql`${t.fromUserId} <> ${t.toUserId}`),
  ],
);

/** "Did you play with Dave?" — the MVP's success number (docs/PRD.md). */
export const checkIns = pgTable(
  'check_ins',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    otherUserId: uuid('other_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    listingId: uuid('listing_id').references(() => listings.id, { onDelete: 'set null' }),
    playInviteId: uuid('play_invite_id').references(() => playInvites.id, {
      onDelete: 'set null',
    }),
    dueAt: ts('due_at').notNull(),
    answer: checkInAnswer('answer'),
    answeredAt: ts('answered_at'),
    createdAt: createdAt(),
  },
  (t) => [
    uniqueIndex('check_ins_per_listing')
      .on(t.userId, t.otherUserId, t.listingId)
      .where(sql`${t.listingId} is not null`),
    uniqueIndex('check_ins_per_invite')
      .on(t.userId, t.playInviteId)
      .where(sql`${t.playInviteId} is not null`),
    index().on(t.userId, t.dueAt),
  ],
);
