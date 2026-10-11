import { boolean, pgTable, smallint, text, unique } from 'drizzle-orm/pg-core';
import { platform } from './enums.js';
import { id } from './types.js';

// Seeded by src/db/seed.ts, never written by users.

export const games = pgTable('games', {
  id: text('id').primaryKey(), // the app's ids: val, codm, fc …
  name: text('name').notNull(),
  shortCode: text('short_code').notNull(),
  platforms: platform('platforms').array().notNull(),
  hasRanks: boolean('has_ranks').notNull().default(true),
  maxParty: smallint('max_party').notNull().default(5),
  isLaunch: boolean('is_launch').notNull().default(false),
  sort: smallint('sort').notNull().default(0),
});

export const gameRanks = pgTable(
  'game_ranks',
  {
    id: id(),
    gameId: text('game_id')
      .notNull()
      .references(() => games.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    tier: smallint('tier').notNull(), // low → high
  },
  (t) => [unique().on(t.gameId, t.tier), unique('game_ranks_game_id_id_unique').on(t.gameId, t.id)],
);

export const gameRoles = pgTable(
  'game_roles',
  {
    id: id(),
    gameId: text('game_id')
      .notNull()
      .references(() => games.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
  },
  (t) => [unique('game_roles_game_id_id_unique').on(t.gameId, t.id)],
);

export const gameModes = pgTable(
  'game_modes',
  {
    id: id(),
    gameId: text('game_id')
      .notNull()
      .references(() => games.id, { onDelete: 'cascade' }),
    name: text('name').notNull(),
    isRanked: boolean('is_ranked').notNull().default(false),
  },
  (t) => [unique().on(t.gameId, t.name), unique('game_modes_game_id_id_unique').on(t.gameId, t.id)],
);
