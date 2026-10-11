import { addisAt, hoursFrom } from '../common/addis-time.js';

export type PlayWhen = 'now' | 'tonight' | 'weekend';

const ADDIS_OFFSET_MS = 3 * 60 * 60 * 1000;
/** 0 = Sunday … 6 = Saturday, on the Addis calendar. */
const addisWeekday = (at: Date) => new Date(at.getTime() + ADDIS_OFFSET_MS).getUTCDay();
const addisHour = (at: Date) => new Date(at.getTime() + ADDIS_OFFSET_MS).getUTCHours();

/**
 * When play starts (docs/DATA_MODEL.md "Listing times"), in Addis time:
 * - now: right away.
 * - tonight: 20:00 today, or right away if it's already evening or still
 *   the small hours (before 04:00 is still "tonight").
 * - weekend: 10:00 the coming Saturday, or right away on Saturday/Sunday.
 */
export function startsAt(playWhen: PlayWhen, now: Date): Date {
  switch (playWhen) {
    case 'now':
      return now;
    case 'tonight': {
      const eight = addisAt(now, 20);
      return addisHour(now) < 4 || now >= eight ? now : eight;
    }
    case 'weekend': {
      const day = addisWeekday(now);
      if (day === 6 || day === 0) return now;
      return addisAt(now, 10, 6 - day);
    }
  }
}

/** The listing lives for `durationHours` from when play starts. */
export function listingTimes(playWhen: PlayWhen, durationHours: number, now: Date) {
  const start = startsAt(playWhen, now);
  return { startsAt: start, expiresAt: hoursFrom(start, durationHours) };
}
