import { addisAt, endOfTonight } from './addis-time.js';

// Addis is UTC+3, so 04:00 Addis is 01:00 UTC.

describe('addisAt', () => {
  it('uses the Addis calendar day, not the UTC one', () => {
    // 22:30 UTC on the 9th is already 01:30 on the 10th in Addis.
    expect(addisAt(new Date('2026-10-09T22:30:00Z'), 20).toISOString()).toBe(
      '2026-10-10T17:00:00.000Z',
    );
  });
});

describe('endOfTonight', () => {
  it('is 04:00 the next morning during the evening', () => {
    expect(endOfTonight(new Date('2026-10-09T18:00:00Z')).toISOString()).toBe(
      '2026-10-10T01:00:00.000Z',
    );
  });

  it('is 04:00 this morning after midnight', () => {
    expect(endOfTonight(new Date('2026-10-09T23:30:00Z')).toISOString()).toBe(
      '2026-10-10T01:00:00.000Z',
    );
  });

  it('rolls to the next night once 04:00 has passed', () => {
    expect(endOfTonight(new Date('2026-10-10T01:00:00Z')).toISOString()).toBe(
      '2026-10-11T01:00:00.000Z',
    );
  });
});
