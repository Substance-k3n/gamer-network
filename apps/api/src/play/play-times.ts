import { addisAt, hoursFrom } from '../common/addis-time.js';

export type InviteWhen = 'now' | 'in_30_min' | 'tonight';

const ADDIS_OFFSET_MS = 3 * 60 * 60 * 1000;
const addisHour = (at: Date) => new Date(at.getTime() + ADDIS_OFFSET_MS).getUTCHours();

/** An invite nobody answered by startsAt + 15 min is stale. */
export const INVITE_TTL_MS = 15 * 60 * 1000;

/**
 * docs/DATA_MODEL.md play_invites: now; in 30 minutes; or 21:00 Addis
 * tonight (right away if it's already past 21:00 or before 04:00).
 */
export function inviteStartsAt(when: InviteWhen, now: Date): Date {
  switch (when) {
    case 'now':
      return now;
    case 'in_30_min':
      return new Date(now.getTime() + 30 * 60 * 1000);
    case 'tonight': {
      const nine = addisAt(now, 21);
      return addisHour(now) < 4 || now >= nine ? now : nine;
    }
  }
}

/** Check-ins for a listing: 12:00 Addis the next day. */
export const listingCheckInDueAt = (acceptedAt: Date) => addisAt(acceptedAt, 12, 1);

/** Check-ins for a play invite: 12:00 Addis the next day, or 6 h later if accepted before 06:00. */
export function inviteCheckInDueAt(acceptedAt: Date): Date {
  return addisHour(acceptedAt) < 6 ? hoursFrom(acceptedAt, 6) : addisAt(acceptedAt, 12, 1);
}
