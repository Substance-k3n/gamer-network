import { sql } from 'drizzle-orm';
import { check, index, pgTable, primaryKey, text, uuid } from 'drizzle-orm/pg-core';
import { adminActionKind, reportReason, reportStatus } from './enums.js';
import { users } from './identity.js';
import { listings } from './listings.js';
import { createdAt, id, ts } from './types.js';

export const blocks = pgTable(
  'blocks',
  {
    blockerId: uuid('blocker_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    blockedId: uuid('blocked_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    createdAt: createdAt(),
  },
  (t) => [
    primaryKey({ columns: [t.blockerId, t.blockedId] }),
    index().on(t.blockedId),
    check('blocks_not_self', sql`${t.blockerId} <> ${t.blockedId}`),
  ],
);

export const reports = pgTable(
  'reports',
  {
    id: id(),
    reporterId: uuid('reporter_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    targetUserId: uuid('target_user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    listingId: uuid('listing_id').references(() => listings.id, { onDelete: 'set null' }),
    reason: reportReason('reason').notNull(),
    details: text('details'),
    status: reportStatus('status').notNull().default('open'),
    createdAt: createdAt(),
    resolvedBy: uuid('resolved_by').references(() => users.id, { onDelete: 'set null' }),
    resolvedAt: ts('resolved_at'),
    resolutionNote: text('resolution_note'),
  },
  (t) => [
    index().on(t.status, t.createdAt),
    check('reports_details_length', sql`char_length(${t.details}) <= 500`),
  ],
);

/** Audit log: every admin endpoint writes one row. */
export const adminActions = pgTable('admin_actions', {
  id: id(),
  adminId: uuid('admin_id')
    .notNull()
    .references(() => users.id),
  kind: adminActionKind('kind').notNull(),
  targetUserId: uuid('target_user_id').references(() => users.id),
  listingId: uuid('listing_id').references(() => listings.id),
  reportId: uuid('report_id').references(() => reports.id),
  note: text('note').notNull().default(''),
  createdAt: createdAt(),
});

export const waitlist = pgTable(
  'waitlist',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    topic: text('topic').notNull(), // 'groups' for the Groups "Notify me" button
    createdAt: createdAt(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.topic] })],
);
