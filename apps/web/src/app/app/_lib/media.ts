'use client';

import { api, ApiError, type MediaUpload } from './api';

// Photos on posts (docs/FEED_AND_GROUPS_API.md phase 2, images only): resized
// in the browser, then uploaded straight to storage through a signed URL.

export const MAX_PHOTOS = 4;
const LONGEST = 1600;
export const photoTypes = ['image/jpeg', 'image/png', 'image/webp'];

/** A picked photo: resized, previewable, and its upload once done. */
export type Photo = {
  id: string;
  blob: Blob;
  preview: string;
  upload?: { key: string; expiresAt: string };
};

/** Scales a photo down to a longest side of 1600 px, as a JPEG. */
export async function resizePhoto(f: File): Promise<Blob> {
  const img = await createImageBitmap(f);
  const scale = Math.min(1, LONGEST / Math.max(img.width, img.height));
  const canvas = document.createElement('canvas');
  canvas.width = Math.round(img.width * scale);
  canvas.height = Math.round(img.height * scale);
  const g = canvas.getContext('2d')!;
  // PNGs may be transparent; a JPEG has no alpha.
  g.fillStyle = '#fff';
  g.fillRect(0, 0, canvas.width, canvas.height);
  g.drawImage(img, 0, 0, canvas.width, canvas.height);
  img.close();
  return new Promise((resolve, reject) =>
    canvas.toBlob((b) => (b ? resolve(b) : reject(new Error('image'))), 'image/jpeg', 0.85),
  );
}

/**
 * The photo's upload key: asks for a signed URL and PUTs the file there.
 * A key from an earlier try is reused while it's valid, so a retry after a
 * failed post doesn't upload again.
 */
export async function uploadPhoto(p: Photo): Promise<{ key: string; expiresAt: string }> {
  if (p.upload && new Date(p.upload.expiresAt).getTime() - Date.now() > 60_000) return p.upload;
  const u = await api<MediaUpload>('media/upload-url', {
    method: 'POST',
    body: { contentType: 'image/jpeg', size: p.blob.size },
  });
  let ok = false;
  try {
    ok = (await fetch(u.uploadUrl, { method: 'PUT', headers: u.headers, body: p.blob })).ok;
  } catch {}
  if (!ok)
    throw new ApiError(
      0,
      'upload_failed',
      'A photo didn’t upload. Check your connection and try again.',
    );
  return { key: u.key, expiresAt: u.expiresAt };
}
