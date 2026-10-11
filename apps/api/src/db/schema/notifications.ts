import { sql } from 'drizzle-orm';
import { index, pgTable, uuid } from 'drizzle-orm/pg-core';
import { notificationType } from './enums.js';
import { users } from './identity.js';
import { listings } from './listings.js';
import { checkIns, connectionRequests, playInvites } from './relationships.js';
import { createdAt, id, ts } from './types.js';

export const notifications = pgTable(
  'notifications',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    type: notificationType('type').notNull(),
    actorId: uuid('actor_id').references(() => users.id, { onDelete: 'set null' }),
    listingId: uuid('listing_id').references(() => listings.id, { onDelete: 'cascade' }),
    connectionRequestId: uuid('connection_request_id').references(() => connectionRequests.id, {
      onDelete: 'cascade',
    }),
    playInviteId: uuid('play_invite_id').references(() => playInvites.id, {
      onDelete: 'cascade',
    }),
    checkInId: uuid('check_in_id').references(() => checkIns.id, { onDelete: 'cascade' }),
    readAt: ts('read_at'),
    /** Set once handed to push (or skipped). Null rows are the push outbox. */
    pushedAt: ts('pushed_at'),
    createdAt: createdAt(),
  },
  (t) => [
    index().on(t.userId, t.id.desc()),
    index('notifications_unpushed')
      .on(t.id)
      .where(sql`${t.pushedAt} is null`),
  ],
);
