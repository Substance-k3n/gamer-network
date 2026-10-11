import { index, pgTable, primaryKey, text, uuid } from 'drizzle-orm/pg-core';
import { users } from './identity.js';
import { createdAt, ts } from './types.js';

/**
 * docs/API.md "Idempotency": the first answer to a create request, so a
 * retry with the same `Idempotency-Key` gets it again instead of a
 * duplicate. Kept 24 hours.
 */
export const idempotencyKeys = pgTable(
  'idempotency_keys',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    key: uuid('key').notNull(),
    /** sha256 of method, path and body: the same key on a different request is refused. */
    requestHash: text('request_hash').notNull(),
    /** The JSON body that was sent; null for 204. */
    response: text('response'),
    /** Null while the first request is still running. */
    completedAt: ts('completed_at'),
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.key] }), index().on(t.createdAt)],
);
