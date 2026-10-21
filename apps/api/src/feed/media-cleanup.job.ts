import { Inject, Injectable } from '@nestjs/common';
import { and, inArray, isNull, lte } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { mediaUploads } from '../db/schema/index.js';
import type { Job } from '../jobs/jobs.js';
import { MEDIA_STORAGE, type MediaStorage } from '../storage/storage.js';

export const UNUSED_UPLOAD_DAYS = 1;

/**
 * docs/FEED_AND_GROUPS_API.md "media_uploads": uploads no post used within
 * a day are deleted, object and row.
 */
@Injectable()
export class MediaCleanupJob implements Job {
  readonly name = 'media-cleanup';
  readonly everyMs = 60 * 60 * 1000;

  constructor(@Inject(MEDIA_STORAGE) private readonly storage: MediaStorage) {}

  async run(tx: Tx, now: Date): Promise<void> {
    const stale = await tx
      .select({ key: mediaUploads.key })
      .from(mediaUploads)
      .where(
        and(
          isNull(mediaUploads.usedAt),
          lte(mediaUploads.createdAt, new Date(now.getTime() - UNUSED_UPLOAD_DAYS * 24 * 3600_000)),
        ),
      )
      .limit(500);
    if (stale.length === 0) return;
    const keys = stale.map((s) => s.key);
    await tx.delete(mediaUploads).where(inArray(mediaUploads.key, keys));
    // Files last: if the transaction failed above, the rows are still there to retry.
    for (const key of keys) await this.storage.delete(key).catch(() => undefined);
  }
}
