import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray, isNotNull, lte, notLike } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import {
  authIdentities,
  devices,
  emailCodes,
  gamingIds,
  sessions,
  userGames,
  userPlatforms,
  users,
  userTags,
} from '../db/schema/index.js';
import type { Job } from '../jobs/jobs.js';
import { MEDIA_STORAGE, type MediaStorage } from '../storage/storage.js';

export const SCRUB_AFTER_DAYS = 30;
/** Scrubbed accounts get an address on this reserved domain, which also marks them done. */
const SCRUBBED_DOMAIN = '@deleted.invalid';

/**
 * docs/DATA_MODEL.md: deleted accounts keep their row so references
 * hold, but 30 days after deletion everything personal goes: email,
 * names, bio, avatar, password, Google link, gaming IDs, games and tags.
 * Reports, check-in answers and the audit log stay.
 */
@Injectable()
export class AccountScrubJob implements Job {
  readonly name = 'account-scrub';
  readonly everyMs = 60 * 60 * 1000;

  constructor(@Inject(MEDIA_STORAGE) private readonly storage: MediaStorage) {}

  async run(tx: Tx, now: Date): Promise<void> {
    const due = await tx
      .select({ id: users.id, email: users.email, avatarKey: users.avatarKey })
      .from(users)
      .where(
        and(
          isNotNull(users.deletedAt),
          lte(users.deletedAt, new Date(now.getTime() - SCRUB_AFTER_DAYS * 24 * 3600_000)),
          notLike(users.email, `%${SCRUBBED_DOMAIN}`),
        ),
      )
      .limit(100);
    if (due.length === 0) return;
    const ids = due.map((u) => u.id);

    for (const u of due) {
      await tx
        .update(users)
        .set({
          email: `${u.id}${SCRUBBED_DOMAIN}`,
          // Fits the 3–20 [a-z0-9._] rule and stays unique.
          username: `deleted_${u.id.replaceAll('-', '').slice(-12)}`,
          displayName: 'Deleted player',
          bio: null,
          avatarKey: null,
          passwordHash: null,
          statusGameId: null,
          availableDays: 0,
          updatedAt: now,
        })
        .where(eq(users.id, u.id));
    }
    await tx.delete(authIdentities).where(inArray(authIdentities.userId, ids));
    await tx.delete(gamingIds).where(inArray(gamingIds.userId, ids));
    await tx.delete(userGames).where(inArray(userGames.userId, ids));
    await tx.delete(userPlatforms).where(inArray(userPlatforms.userId, ids));
    await tx.delete(userTags).where(inArray(userTags.userId, ids));
    await tx.delete(devices).where(inArray(devices.userId, ids));
    await tx.delete(sessions).where(inArray(sessions.userId, ids));
    await tx.delete(emailCodes).where(
      inArray(
        emailCodes.email,
        due.map((u) => u.email),
      ),
    );
    // Files last: if the transaction failed above, the avatar is still referenced.
    for (const u of due) {
      if (u.avatarKey) await this.storage.delete(u.avatarKey).catch(() => undefined);
    }
  }
}
