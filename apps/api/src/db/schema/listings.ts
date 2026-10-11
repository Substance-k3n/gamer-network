import { sql } from 'drizzle-orm';
import {
  check,
  foreignKey,
  index,
  pgTable,
  smallint,
  text,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { gameModes, gameRanks, games } from './catalog.js';
import { listingStatus, platform, playStyle, playWhen, voice } from './enums.js';
import { users } from './identity.js';
import { createdAt, id, ts } from './types.js';

export const listings = pgTable(
  'listings',
  {
    id: id(),
    ownerId: uuid('owner_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    gameId: text('game_id')
      .notNull()
      .references(() => games.id),
    modeId: uuid('mode_id'),
    rankId: uuid('rank_id'),
    platform: platform('platform').notNull(),
    partySize: smallint('party_size').notNull(), // 2 Duo · 3 Trio · 4 Squad · 5 5-stack
    filled: smallint('filled').notNull().default(0),
    voice: voice('voice').notNull(),
    style: playStyle('style').notNull(),
    playWhen: playWhen('play_when').notNull(),
    durationHours: smallint('duration_hours').notNull(),
    startsAt: ts('starts_at').notNull(),
    expiresAt: ts('expires_at').notNull(),
    note: text('note'),
    city: text('city').notNull(),
    status: listingStatus('status').notNull().default('open'),
    createdAt: createdAt(),
    closedAt: ts('closed_at'),
  },
  (t) => [
    foreignKey({
      name: 'listings_mode_of_game_fk',
      columns: [t.gameId, t.modeId],
      foreignColumns: [gameModes.gameId, gameModes.id],
    }),
    foreignKey({
      name: 'listings_rank_of_game_fk',
      columns: [t.gameId, t.rankId],
      foreignColumns: [gameRanks.gameId, gameRanks.id],
    }),
    // One live listing per person.
    uniqueIndex('listings_one_live_per_owner')
      .on(t.ownerId)
      .where(sql`${t.status} in ('open', 'full')`),
    index('listings_open_feed')
      .on(t.city, t.gameId, t.expiresAt)
      .where(sql`${t.status} = 'open'`),
    check('listings_party_size', sql`${t.partySize} between 2 and 5`),
    check('listings_filled_range', sql`${t.filled} between 0 and ${t.partySize} - 1`),
    check('listings_duration', sql`${t.durationHours} in (2, 6, 24)`),
    check('listings_note_length', sql`char_length(${t.note}) <= 140`),
    check('listings_expires_after_created', sql`${t.expiresAt} > ${t.createdAt}`),
  ],
);
