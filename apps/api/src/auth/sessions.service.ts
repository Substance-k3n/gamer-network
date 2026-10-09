import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, isNull, ne } from 'drizzle-orm';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { sessions, users } from '../db/schema/index.js';
import { newSessionToken, sha256 } from './crypto.js';

const TTL_MS = 90 * 24 * 3600_000; // 90 days, extended by use
const TOUCH_EVERY_MS = 3600_000; // write last_seen_at at most hourly

export type User = typeof users.$inferSelect;
export type Session = typeof sessions.$inferSelect;

@Injectable()
export class SessionsService {
  constructor(@Inject(DB) private readonly db: Db) {}

  /** Returns the bearer token; it is never stored, only its hash. */
  async create(userId: string, userAgent?: string): Promise<{ token: string; session: Session }> {
    const token = newSessionToken();
    const [session] = await this.db
      .insert(sessions)
      .values({
        userId,
        tokenHash: sha256(token),
        userAgent: userAgent?.slice(0, 200),
        expiresAt: new Date(Date.now() + TTL_MS),
      })
      .returning();
    return { token, session: session! };
  }

  /** The live session and its user for a bearer token, or null. */
  async resolve(token: string): Promise<{ session: Session; user: User } | null> {
    const now = new Date();
    const [row] = await this.db
      .select({ session: sessions, user: users })
      .from(sessions)
      .innerJoin(users, eq(users.id, sessions.userId))
      .where(
        and(
          eq(sessions.tokenHash, sha256(token)),
          isNull(sessions.revokedAt),
          gt(sessions.expiresAt, now),
        ),
      );
    if (!row) return null;

    if (now.getTime() - row.session.lastSeenAt.getTime() > TOUCH_EVERY_MS) {
      await this.db
        .update(sessions)
        .set({ lastSeenAt: now, expiresAt: new Date(now.getTime() + TTL_MS) })
        .where(eq(sessions.id, row.session.id));
    }
    return row;
  }

  async revoke(sessionId: string) {
    await this.db.update(sessions).set({ revokedAt: new Date() }).where(eq(sessions.id, sessionId));
  }

  /** Signs the user out everywhere, except `keepSessionId` when given. */
  async revokeAll(userId: string, keepSessionId?: string) {
    await this.db
      .update(sessions)
      .set({ revokedAt: new Date() })
      .where(
        and(
          eq(sessions.userId, userId),
          isNull(sessions.revokedAt),
          keepSessionId ? ne(sessions.id, keepSessionId) : undefined,
        ),
      );
  }
}
