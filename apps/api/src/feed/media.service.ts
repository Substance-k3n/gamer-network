import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, inArray, isNull } from 'drizzle-orm';
import { uuidv7 } from 'uuidv7';
import type { User } from '../auth/sessions.service.js';
import { AppError } from '../common/app-error.js';
import { checkRate } from '../common/rate-limit.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { mediaUploads, postMedia } from '../db/schema/index.js';
import { MEDIA_STORAGE, type MediaStorage } from '../storage/storage.js';
import type { MediaUploadBody } from './feed.body.js';
import type { MediaDto, MediaUploadDto } from './feed.dto.js';
import { imageTypeOf, SNIFF_BYTES } from './image-type.js';

const HOUR_MS = 3600_000;
export const UPLOADS_PER_HOUR = 30;
/** How long an upload URL, and the key it gives, stay good. */
export const UPLOAD_TTL_MS = HOUR_MS;

type Upload = typeof mediaUploads.$inferSelect;

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

/**
 * docs/FEED_AND_GROUPS_API.md "Media uploads": the avatar flow (ADR-0009),
 * for posts. Each key is recorded with what it was signed for, so a post can
 * only use its author's own uploads, once, before they expire.
 */
@Injectable()
export class MediaService {
  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(MEDIA_STORAGE) private readonly storage: MediaStorage,
  ) {}

  /** Step 1: where to upload one image. 30 an hour. */
  async uploadUrl(user: User, body: MediaUploadBody): Promise<MediaUploadDto> {
    await checkRate(
      this.db,
      mediaUploads,
      { user: mediaUploads.userId, createdAt: mediaUploads.createdAt },
      user.id,
      UPLOADS_PER_HOUR,
      HOUR_MS,
      'photos',
      { verb: 'upload' },
    );
    const ext = body.contentType.split('/')[1]!.replace('jpeg', 'jpg');
    const key = `media/${user.id}/${uuidv7()}.${ext}`;
    const expiresAt = new Date(Date.now() + UPLOAD_TTL_MS);
    await this.db.insert(mediaUploads).values({
      key,
      userId: user.id,
      kind: 'image',
      contentType: body.contentType,
      size: body.size,
      expiresAt,
    });
    return {
      uploadUrl: await this.storage.uploadUrl(
        key,
        body.contentType,
        body.size,
        UPLOAD_TTL_MS / 1000,
      ),
      headers: { 'Content-Type': body.contentType },
      key,
      expiresAt,
    };
  }

  /**
   * Step 2, before the post is written: every key is the author's, unused,
   * unexpired, and its object is there with the type and size promised and
   * starts like a JPEG, PNG or WebP of that type.
   * 422 otherwise. Returns the uploads in the order given.
   */
  async check(authorId: string, keys: string[]): Promise<Upload[]> {
    if (keys.length === 0) return [];
    const rows = await this.db.select().from(mediaUploads).where(inArray(mediaUploads.key, keys));
    const byKey = new Map(rows.map((r) => [r.key, r]));
    const now = new Date();
    const uploads = keys.map((key) => {
      const u = byKey.get(key);
      if (!u || u.userId !== authorId) throw invalid({ media: 'Not one of your uploads' });
      if (u.usedAt) throw invalid({ media: 'That photo is already on a post' });
      if (u.expiresAt <= now) throw invalid({ media: 'That upload expired. Add the photo again' });
      return u;
    });
    const stored = await Promise.all(
      uploads.map(async (u) => ({
        head: await this.storage.head(u.key),
        start: await this.storage.firstBytes(u.key, SNIFF_BYTES),
      })),
    );
    for (const [i, u] of uploads.entries()) {
      const { head, start } = stored[i]!;
      if (!head || !start) throw invalid({ media: "A photo hasn't finished uploading" });
      const refuse = async (message: string) => {
        await this.storage.delete(u.key).catch(() => undefined);
        return invalid({ media: message });
      };
      if (head.size !== u.size || head.contentType !== u.contentType) {
        throw await refuse("A photo doesn't match its upload. Add it again");
      }
      // The bytes, not just the signed type: only real JPEG, PNG or WebP files.
      const real = imageTypeOf(start);
      if (!real) throw await refuse("That file isn't a JPEG, PNG or WebP photo");
      if (real !== u.contentType)
        throw await refuse("A photo doesn't match its upload. Add it again");
    }
    return uploads;
  }

  /** In the post's transaction: marks the uploads used and attaches them in order. */
  async attach(tx: Tx, postId: string, uploads: Upload[], now: Date): Promise<void> {
    if (uploads.length === 0) return;
    const keys = uploads.map((u) => u.key);
    const used = await tx
      .update(mediaUploads)
      .set({ usedAt: now })
      .where(and(inArray(mediaUploads.key, keys), isNull(mediaUploads.usedAt)))
      .returning({ key: mediaUploads.key });
    // Another post took one in the meantime.
    if (used.length !== keys.length) throw invalid({ media: 'That photo is already on a post' });
    await tx.insert(postMedia).values(
      uploads.map((u, position) => ({
        postId,
        position,
        kind: u.kind,
        key: u.key,
        contentType: u.contentType,
        size: u.size,
      })),
    );
  }

  /** Each post's media in position order, with signed URLs. `firstImageOnly` for share pages. */
  async forPosts(postIds: string[], firstImageOnly = false): Promise<Map<string, MediaDto[]>> {
    if (postIds.length === 0) return new Map();
    const rows = await this.db
      .select()
      .from(postMedia)
      .where(
        and(
          inArray(postMedia.postId, postIds),
          firstImageOnly ? eq(postMedia.kind, 'image') : undefined,
        ),
      )
      .orderBy(asc(postMedia.postId), asc(postMedia.position));
    const out = new Map<string, MediaDto[]>();
    for (const m of rows) {
      const list = out.get(m.postId) ?? [];
      if (firstImageOnly && list.length) continue;
      list.push({
        id: m.id,
        kind: m.kind,
        url: await this.storage.url(m.key),
        posterUrl: m.posterKey && (await this.storage.url(m.posterKey)),
        width: m.width,
        height: m.height,
        durationMs: m.durationMs,
      });
      out.set(m.postId, list);
    }
    return out;
  }
}
