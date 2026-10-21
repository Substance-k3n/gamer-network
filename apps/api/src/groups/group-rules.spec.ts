import { eventStartError, groupShapeErrors, shortFrom } from './group-rules.js';

describe('shortFrom', () => {
  it('takes the initials of up to 4 words, or the start of one word', () => {
    expect(shortFrom('Valorant Ethiopia')).toBe('VE');
    expect(shortFrom('Addis PUBG Mobile Squad Five')).toBe('APMS');
    expect(shortFrom('Valorant')).toBe('VALO');
    expect(shortFrom('AAU')).toBe('AAU');
  });

  it('ignores accents and punctuation, and falls back to GRP', () => {
    expect(shortFrom('Équipe-Rouge')).toBe('ER');
    expect(shortFrom('  fifa  #1  ')).toBe('F1');
    expect(shortFrom('ቫሎራንት')).toBe('GRP');
    expect(shortFrom('A')).toBe('GRP');
  });

  it('always fits the 2–5 uppercase badge', () => {
    for (const name of ['xo xo', 'Counter-Strike 2 Addis', 'csgo', '99 Problems']) {
      expect(shortFrom(name)).toMatch(/^[A-Z0-9]{2,5}$/);
    }
  });
});

describe('groupShapeErrors', () => {
  it('needs a game for game groups only', () => {
    expect(groupShapeErrors({ kind: 'game' })).toEqual({
      gameId: 'Pick the game for a game group',
    });
    expect(groupShapeErrors({ kind: 'game', gameId: null })).not.toBeNull();
    expect(groupShapeErrors({ kind: 'game', gameId: 'val' })).toBeNull();
    expect(groupShapeErrors({ kind: 'city' })).toBeNull();
    expect(groupShapeErrors({ kind: 'squad', gameId: 'pubg' })).toBeNull();
  });
});

describe('eventStartError', () => {
  const now = new Date('2026-10-20T10:00:00Z');
  const at = (ms: number) => new Date(now.getTime() + ms);
  const DAY = 24 * 3600_000;

  it('takes times in the next 60 days', () => {
    expect(eventStartError(at(60_000), now)).toBeNull();
    expect(eventStartError(at(60 * DAY), now)).toBeNull();
  });

  it('refuses the past and anything later than 60 days', () => {
    expect(eventStartError(now, now)).toBe('Pick a time that is still to come');
    expect(eventStartError(at(-DAY), now)).toBe('Pick a time that is still to come');
    expect(eventStartError(at(60 * DAY + 1), now)).toBe('Pick a time within the next 60 days');
  });
});
