import { sql } from 'drizzle-orm';
import { char, check, index, pgTable, smallint, text, unique, uuid } from 'drizzle-orm/pg-core';
import { games } from './catalog.js';
import { ageRange, emailCodePurpose, playerStatus, userRole } from './enums.js';
import { bytea, citext, createdAt, id, ts } from './types.js';

export const users = pgTable(
  'users',
  {
    id: id(),
    email: citext('email').notNull().unique(),
    emailVerifiedAt: ts('email_verified_at'),
    passwordHash: text('password_hash'), // argon2id; null for Google-only (ADR-0007)
    username: citext('username').notNull().unique(),
    displayName: text('display_name').notNull(),
    bio: text('bio'),
    avatarKey: text('avatar_key'),
    ageRange: ageRange('age_range').notNull(),
    country: char('country', { length: 2 }).notNull().default('ET'),
    city: text('city').notNull().default('Addis Ababa'),
    status: playerStatus('status').notNull().default('not_available'),
    statusGameId: text('status_game_id').references(() => games.id),
    statusUntil: ts('status_until'),
    availableDays: smallint('available_days').notNull().default(0), // Mon=1 … Sun=64
    role: userRole('role').notNull().default('player'),
    onboardedAt: ts('onboarded_at'),
    bannedAt: ts('banned_at'),
    banReason: text('ban_reason'),
    createdAt: createdAt(),
    updatedAt: ts('updated_at').notNull().defaultNow(),
    deletedAt: ts('deleted_at'),
  },
  (t) => [
    check('users_username_format', sql`${t.username}::text ~ '^[a-z0-9._]{3,20}$'`),
    check('users_display_name_length', sql`char_length(${t.displayName}) between 1 and 30`),
    check('users_bio_length', sql`char_length(${t.bio}) <= 160`),
    check('users_available_days_range', sql`${t.availableDays} between 0 and 127`),
  ],
);

export const authIdentities = pgTable(
  'auth_identities',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    provider: text('provider').notNull(), // 'google'
    subject: text('subject').notNull(),
    createdAt: createdAt(),
  },
  (t) => [unique().on(t.provider, t.subject), index().on(t.userId)],
);

export const emailCodes = pgTable(
  'email_codes',
  {
    id: id(),
    email: citext('email').notNull(),
    purpose: emailCodePurpose('purpose').notNull(),
    codeHash: text('code_hash').notNull(),
    expiresAt: ts('expires_at').notNull(),
    attempts: smallint('attempts').notNull().default(0),
    consumedAt: ts('consumed_at'),
    createdAt: createdAt(),
  },
  (t) => [index().on(t.email, t.purpose, t.createdAt)],
);

export const sessions = pgTable(
  'sessions',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    tokenHash: bytea('token_hash').notNull().unique(), // sha-256 of the bearer token
    userAgent: text('user_agent'),
    createdAt: createdAt(),
    lastSeenAt: ts('last_seen_at').notNull().defaultNow(),
    expiresAt: ts('expires_at').notNull(),
    revokedAt: ts('revoked_at'),
  },
  (t) => [index().on(t.userId)],
);

export const devices = pgTable(
  'devices',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    fcmToken: text('fcm_token').notNull().unique(),
    platform: text('platform').notNull(), // android | ios | web
    appVersion: text('app_version'),
    lastSeenAt: ts('last_seen_at').notNull().defaultNow(),
  },
  (t) => [
    index().on(t.userId),
    check('devices_platform', sql`${t.platform} in ('android', 'ios', 'web')`),
  ],
);
