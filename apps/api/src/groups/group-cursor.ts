import { HttpStatus } from '@nestjs/common';
import { AppError } from '../common/app-error.js';

// Groups page by more than the id (most members first, recent activity,
// admins first, soonest event), so their cursors carry each sort key, like
// the saved posts cursor. Times are Postgres's own text, so no precision
// is lost on the way round.

type Part = 'int' | 'time' | 'uuid' | 'role';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
const valid: Record<Part, (v: string) => boolean> = {
  int: (v) => /^\d{1,9}$/.test(v),
  time: (v) => !Number.isNaN(Date.parse(v)),
  uuid: (v) => UUID.test(v),
  role: (v) => v === 'admin' || v === 'member',
};

export const encodeKey = (...parts: (string | number)[]) =>
  Buffer.from(parts.join('|')).toString('base64url');

/** The sort keys to continue after, or undefined for the first page. */
export function decodeKey(cursor: string | undefined, kinds: Part[]): string[] | undefined {
  if (!cursor) return undefined;
  const parts = Buffer.from(cursor, 'base64url').toString().split('|');
  if (parts.length !== kinds.length || kinds.some((k, i) => !valid[k](parts[i]!))) {
    throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Bad cursor.', {
      cursor: 'Use nextCursor from the previous page',
    });
  }
  return parts;
}
