import type { PublicListing } from './api';

const PLATFORM: Record<PublicListing['platform'], string> = {
  pc: 'PC',
  playstation: 'PlayStation',
  xbox: 'Xbox',
  mobile: 'Mobile',
  switch: 'Switch',
};

const PARTY: Record<number, string> = { 2: 'Duo', 3: 'Trio', 4: 'Squad', 5: 'Five' };

export const platformLabel = (l: PublicListing) => PLATFORM[l.platform];
export const partyLabel = (l: PublicListing) => PARTY[l.partySize] ?? `${l.partySize} players`;
/** Free slots: the owner counts toward partySize but not toward filled. */
export const openSlots = (l: PublicListing) => Math.max(0, l.partySize - 1 - l.filled);
export const isLive = (l: PublicListing) => l.status === 'open' || l.status === 'full';

/** "Tonight 21:00", shown in Addis time like the app. */
export function whenLabel(l: PublicListing, now = new Date()): string {
  const starts = new Date(l.startsAt);
  const time = new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Africa/Addis_Ababa',
    hour: '2-digit',
    minute: '2-digit',
  }).format(starts);
  if (starts <= now) return 'Playing now';
  const day = new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Africa/Addis_Ababa',
    weekday: 'short',
  });
  return day.format(starts) === day.format(now) ? `Today ${time}` : `${day.format(starts)} ${time}`;
}

export function statusLine(l: PublicListing): string {
  switch (l.status) {
    case 'open': {
      const n = openSlots(l);
      return `${n} spot${n === 1 ? '' : 's'} left`;
    }
    case 'full':
      return 'Party full';
    case 'closed':
      return 'Closed by the host';
    default:
      return 'This listing has ended';
  }
}

/** For the link preview: "Hana needs 2 for PUBG Mobile". */
export function headline(l: PublicListing): string {
  if (l.status !== 'open') return `${l.ownerDisplayName}'s ${l.game.name} squad`;
  const n = openSlots(l);
  return `${l.ownerDisplayName} needs ${n} for ${l.game.name}`;
}

export function summary(l: PublicListing): string {
  const parts = [
    l.mode?.name,
    l.rank?.name,
    platformLabel(l),
    partyLabel(l),
    l.voice === 'required' ? 'Voice on' : null,
    whenLabel(l),
  ].filter(Boolean);
  return parts.join(' · ');
}
