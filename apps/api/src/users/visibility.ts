import { and, eq, isNotNull, isNull, notExists, or, sql } from 'drizzle-orm';
import type { Db } from '../db/db.js';
import { blocks, users } from '../db/schema/index.js';

/**
 * Rows of `users` that `viewerId` may see: live (onboarded, not banned or
 * deleted) and no block either way (docs/DATA_MODEL.md "Blocks"). Use in
 * any query that has `users` in it, e.g. joined as a listing's owner.
 */
export function visibleTo(db: Db, viewerId: string) {
  return and(
    isLive(),
    notExists(
      db
        .select({ one: sql`1` })
        .from(blocks)
        .where(
          or(
            and(eq(blocks.blockerId, viewerId), eq(blocks.blockedId, users.id)),
            and(eq(blocks.blockerId, users.id), eq(blocks.blockedId, viewerId)),
          ),
        ),
    ),
  );
}

/** Onboarded and not banned or deleted. */
export const isLive = () =>
  and(isNotNull(users.onboardedAt), isNull(users.bannedAt), isNull(users.deletedAt));
