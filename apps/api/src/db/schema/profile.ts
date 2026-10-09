import { sql } from 'drizzle-orm';
import {
  check,
  foreignKey,
  pgTable,
  primaryKey,
  smallint,
  text,
  unique,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { gameRanks, gameRoles, games } from './catalog.js';
import { gamingIdKind, idVisibility, platform, playTag } from './enums.js';
import { users } from './identity.js';
import { id } from './types.js';

export const userGames = pgTable(
  'user_games',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    gameId: text('game_id').references(() => games.id),
    customGameName: text('custom_game_name'), // a game not in the catalog
    rankId: uuid('rank_id'),
    rankText: text('rank_text'), // free-text level for custom games
    roleId: uuid('role_id'),
    position: smallint('position').notNull().default(0),
  },
  (t) => [
    // A rank or role must belong to the same game.
    foreignKey({
      name: 'user_games_rank_of_game_fk',
      columns: [t.gameId, t.rankId],
      foreignColumns: [gameRanks.gameId, gameRanks.id],
    }),
    foreignKey({
      name: 'user_games_role_of_game_fk',
      columns: [t.gameId, t.roleId],
      foreignColumns: [gameRoles.gameId, gameRoles.id],
    }),
    uniqueIndex('user_games_user_game_unique')
      .on(t.userId, t.gameId)
      .where(sql`${t.gameId} is not null`),
    uniqueIndex('user_games_user_custom_unique')
      .on(t.userId, sql`lower(${t.customGameName})`)
      .where(sql`${t.customGameName} is not null`),
    check('user_games_game_or_custom', sql`(${t.gameId} is null) <> (${t.customGameName} is null)`),
    check('user_games_custom_name_length', sql`char_length(${t.customGameName}) <= 40`),
    check('user_games_rank_text_length', sql`char_length(${t.rankText}) <= 30`),
  ],
);

export const userPlatforms = pgTable(
  'user_platforms',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    platform: platform('platform').notNull(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.platform] })],
);

export const userTags = pgTable(
  'user_tags',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    tag: playTag('tag').notNull(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.tag] })],
);

export const gamingIds = pgTable(
  'gaming_ids',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    kind: gamingIdKind('kind').notNull(),
    gameId: text('game_id').references(() => games.id),
    value: text('value').notNull(),
    visibility: idVisibility('visibility').notNull().default('connections'),
  },
  (t) => [
    unique('gaming_ids_user_kind_game_unique').on(t.userId, t.kind, t.gameId).nullsNotDistinct(),
    check(
      'gaming_ids_in_game_needs_game',
      sql`(${t.kind} = 'in_game') = (${t.gameId} is not null)`,
    ),
    check('gaming_ids_value_length', sql`char_length(${t.value}) between 1 and 64`),
  ],
);
