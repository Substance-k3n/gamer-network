import { and, eq, gt, min, sql } from 'drizzle-orm';
import type { PgColumn, PgTable } from 'drizzle-orm/pg-core';
import type { Db } from '../db/db.js';
import { RateLimited } from './app-error.js';

/**
 * Throws 429 rate_limited when `userId` already made `max` rows in `table`
 * within `windowMs`. Counts rows, so it holds across restarts and instances;
 * deleted posts and comments still count.
 */
export async function checkRate(
  db: Db,
  table: PgTable,
  cols: { user: PgColumn; createdAt: PgColumn },
  userId: string,
  max: number,
  windowMs: number,
  what: string,
): Promise<void> {
  const since = new Date(Date.now() - windowMs);
  const [row] = await db
    .select({ n: sql<number>`count(*)::int`, oldest: min(cols.createdAt) })
    .from(table)
    .where(and(eq(cols.user, userId), gt(cols.createdAt, since)));
  if (row!.n < max) return;
  const freeAt = (row!.oldest as Date).getTime() + windowMs;
  throw new RateLimited(
    `You can post ${max} ${what} an hour. Try again a little later.`,
    Math.max(1, Math.ceil((freeAt - Date.now()) / 1000)),
  );
}
