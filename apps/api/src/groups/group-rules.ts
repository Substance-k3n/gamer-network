// docs/FEED_AND_GROUPS_API.md "Groups": the rules that need no database.
// Names, places, about and rules are checked by the body's validators.

const DAY_MS = 24 * 3600_000;
/** Events start within this many days. */
export const EVENT_MAX_DAYS = 60;
/** The events list (and Discover's "Next: …") keeps an event this long after it starts. */
export const EVENT_SHOWN_AFTER_START_MS = 3600_000;

/**
 * The badge when none is given, as the prototype makes it: the initials of
 * up to 4 words, or the first 4 letters of a single word ("Valorant
 * Ethiopia" → "VE", "Valorant" → "VALO"). "GRP" when the name has no
 * Latin letters or digits to use.
 */
export function shortFrom(name: string): string {
  const words = name
    .normalize('NFD')
    .replace(/\p{M}/gu, '')
    .toUpperCase()
    .split(/[^A-Z0-9]+/)
    .filter(Boolean);
  const short =
    words.length > 1
      ? words
          .slice(0, 4)
          .map((w) => w[0])
          .join('')
      : (words[0] ?? '');
  return short.length >= 2 ? short.slice(0, 4) : 'GRP';
}

/** The fields that don't fit the group's kind, or null when it's fine. */
export function groupShapeErrors(group: {
  kind: string;
  gameId?: string | null;
}): Record<string, string> | null {
  if (group.kind === 'game' && !group.gameId) return { gameId: 'Pick the game for a game group' };
  return null;
}

/** Why an event can't start at `startsAt`, or null: it must be in the next 60 days. */
export function eventStartError(startsAt: Date, now: Date): string | null {
  if (startsAt.getTime() <= now.getTime()) return 'Pick a time that is still to come';
  if (startsAt.getTime() > now.getTime() + EVENT_MAX_DAYS * DAY_MS) {
    return `Pick a time within the next ${EVENT_MAX_DAYS} days`;
  }
  return null;
}
