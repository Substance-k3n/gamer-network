import { listingTimes, startsAt } from './listing-times.js';

// Addis is UTC+3: 20:00 Addis = 17:00 UTC, 10:00 Addis = 07:00 UTC.
// 2026-10-07 is a Wednesday, 2026-10-10 a Saturday.
const at = (iso: string) => new Date(iso);
const iso = (d: Date) => d.toISOString();

describe('startsAt', () => {
  it('now starts right away', () => {
    const now = at('2026-10-07T09:00:00Z');
    expect(startsAt('now', now)).toEqual(now);
  });

  it('tonight starts at 20:00 when posted during the day', () => {
    expect(iso(startsAt('tonight', at('2026-10-07T09:00:00Z')))).toBe('2026-10-07T17:00:00.000Z');
  });

  it('tonight starts right away in the evening', () => {
    const now = at('2026-10-07T18:30:00Z'); // 21:30 Addis
    expect(startsAt('tonight', now)).toEqual(now);
  });

  it('tonight starts right away after midnight, before 04:00', () => {
    const now = at('2026-10-07T23:00:00Z'); // 02:00 Addis on the 8th
    expect(startsAt('tonight', now)).toEqual(now);
  });

  it('tonight posted at 04:00 waits for 20:00', () => {
    expect(iso(startsAt('tonight', at('2026-10-08T01:00:00Z')))).toBe('2026-10-08T17:00:00.000Z');
  });

  it('weekend on a weekday starts at 10:00 the coming Saturday', () => {
    expect(iso(startsAt('weekend', at('2026-10-07T09:00:00Z')))).toBe('2026-10-10T07:00:00.000Z');
  });

  it('weekend late Friday in Addis (already Saturday there) starts right away', () => {
    const now = at('2026-10-09T22:00:00Z'); // 01:00 Saturday Addis
    expect(startsAt('weekend', now)).toEqual(now);
  });

  it('weekend on Sunday starts right away', () => {
    const now = at('2026-10-11T12:00:00Z');
    expect(startsAt('weekend', now)).toEqual(now);
  });
});

describe('listingTimes', () => {
  it('expires durationHours after play starts', () => {
    const t = listingTimes('tonight', 2, at('2026-10-07T07:00:00Z')); // posted 10:00 Addis
    expect(iso(t.startsAt)).toBe('2026-10-07T17:00:00.000Z');
    expect(iso(t.expiresAt)).toBe('2026-10-07T19:00:00.000Z');
  });

  it('a weekend listing posted on Monday lives through Saturday', () => {
    const t = listingTimes('weekend', 24, at('2026-10-05T09:00:00Z'));
    expect(iso(t.expiresAt)).toBe('2026-10-11T07:00:00.000Z');
  });
});
