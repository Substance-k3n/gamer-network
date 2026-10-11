import { inviteCheckInDueAt, inviteStartsAt, listingCheckInDueAt } from './play-times.js';

// Addis is UTC+3.
const at = (iso: string) => new Date(iso);
const iso = (d: Date) => d.toISOString();

describe('inviteStartsAt', () => {
  it('now, and in 30 minutes', () => {
    const now = at('2026-10-07T09:00:00Z');
    expect(inviteStartsAt('now', now)).toEqual(now);
    expect(iso(inviteStartsAt('in_30_min', now))).toBe('2026-10-07T09:30:00.000Z');
  });

  it('tonight is 21:00 Addis, or right away late at night', () => {
    expect(iso(inviteStartsAt('tonight', at('2026-10-07T09:00:00Z')))).toBe(
      '2026-10-07T18:00:00.000Z',
    );
    const late = at('2026-10-07T19:00:00Z'); // 22:00 Addis
    expect(inviteStartsAt('tonight', late)).toEqual(late);
    const small = at('2026-10-07T22:30:00Z'); // 01:30 Addis
    expect(inviteStartsAt('tonight', small)).toEqual(small);
  });
});

describe('check-in due times', () => {
  it('listings: 12:00 Addis the next day', () => {
    expect(iso(listingCheckInDueAt(at('2026-10-07T19:00:00Z')))).toBe('2026-10-08T09:00:00.000Z');
  });

  it('invites: 12:00 the next day, or 6 h later when accepted before 06:00', () => {
    expect(iso(inviteCheckInDueAt(at('2026-10-07T17:00:00Z')))).toBe('2026-10-08T09:00:00.000Z');
    expect(iso(inviteCheckInDueAt(at('2026-10-07T23:00:00Z')))).toBe('2026-10-08T05:00:00.000Z');
  });
});
