// Labels and lookups between the API's enums and what the app shows. The
// same tables as apps/mobile/lib/data.dart, so both apps read alike.
import type {
  AgeRange,
  Day,
  GameDto,
  GameRef,
  GamingIdKind,
  InviteWhen,
  Platform,
  PlayerStatus,
  PlayTag,
  PlayWhen,
  PostType,
  ReportReason,
  UserGame,
} from './api';

export const platformLabel: Record<Platform, string> = {
  pc: 'PC',
  playstation: 'PlayStation',
  xbox: 'Xbox',
  mobile: 'Mobile',
  switch: 'Switch',
};
export const platforms = Object.keys(platformLabel) as Platform[];

export const tagLabel: Record<PlayTag, string> = {
  competitive: 'Competitive',
  casual: 'Casual',
  fps: 'FPS',
  rpg: 'RPG',
  strategy: 'Strategy',
  co_op: 'Co-op',
  ranked: 'Ranked',
  achievement_hunter: 'Achievement Hunter',
  story: 'Story Games',
};

export const ageLabel: Record<AgeRange, string> = {
  '16_17': '16–17',
  '18_24': '18–24',
  '25_34': '25–34',
  '35_plus': '35+',
};

export const dayLabel: Record<Day, string> = {
  mon: 'MO',
  tue: 'TU',
  wed: 'WE',
  thu: 'TH',
  fri: 'FR',
  sat: 'SA',
  sun: 'SU',
};
export const days = Object.keys(dayLabel) as Day[];

export const reasonLabel: Record<ReportReason, string> = {
  harassment: 'Harassment',
  hate: 'Hate',
  sexual_content: 'Sexual content',
  underage: 'Under 16',
  spam: 'Spam',
  impersonation: 'Impersonation',
  cheating_or_scam: 'Cheating or scam',
  other: 'Something else',
};

export const playWhenLabel: Record<PlayWhen, string> = {
  now: 'Now',
  tonight: 'Tonight',
  weekend: 'Weekend',
};
export const inviteWhenLabel: Record<InviteWhen, string> = {
  now: 'Now',
  in_30_min: 'In 30 min',
  tonight: 'Tonight 21:00',
};

/** "Duo", "Trio"… for a party size (including the poster). */
/** The composer's types, in the prototype's order. Media, poll and recruitment come later. */
export const postTypes: { id: PostType; label: string; placeholder: string }[] = [
  {
    id: 'milestone',
    label: 'Milestone',
    placeholder: 'Hit a new rank? Won a tournament? Share it.',
  },
  {
    id: 'discussion',
    label: 'Discussion',
    placeholder: 'Start a discussion: ask the community anything.',
  },
  { id: 'question', label: 'Question', placeholder: 'What do you want to know?' },
  {
    id: 'looking_for_players',
    label: 'Looking for players',
    placeholder: 'Who are you looking for, and when?',
  },
  { id: 'tip_guide', label: 'Tip / guide', placeholder: 'Share a tip that helped you climb.' },
  { id: 'review', label: 'Review', placeholder: 'What did you think of it?' },
  { id: 'event', label: 'Event', placeholder: 'What’s happening, where and when?' },
  { id: 'meme', label: 'Meme', placeholder: 'Make us laugh.' },
];

export const postTypeLabel = (t: PostType) =>
  (postTypes.find((p) => p.id === t)?.label ?? t.replace(/_/g, ' ')).toUpperCase();

export const partyLabel = (n: number) =>
  ({ 2: 'Duo', 3: 'Trio', 4: 'Squad', 5: '5-stack' })[n] ?? `${n} players`;

/** Gaming ID rows offered, in order; in-game IDs are added per mobile game. */
export const idKinds: GamingIdKind[] = [
  'riot',
  'discord',
  'steam',
  'playstation',
  'xbox',
  'epic',
  'ea',
  'activision',
];
export const idKindLabel: Record<GamingIdKind, string> = {
  riot: 'Riot ID',
  discord: 'Discord',
  steam: 'Steam',
  playstation: 'PlayStation',
  xbox: 'Xbox',
  epic: 'Epic',
  ea: 'EA',
  activision: 'Activision',
  in_game: 'In-game',
};

export type Tone = 'accent' | 'soft' | 'lav' | 'grey' | 'free' | 'faint';

/** Status shown on a player's card, with its dot colour. */
export function statusLook(s: PlayerStatus, game: GameRef | null): [string, Tone] {
  switch (s) {
    case 'looking':
      return [game ? `Looking for ${game.name}` : 'Looking for players', 'accent'];
    case 'playing':
      return [game ? `Playing ${game.name}` : 'Playing', 'lav'];
    case 'available_tonight':
      return ['Available tonight', 'free'];
    default:
      return ['Not available', 'faint'];
  }
}

/** Avatar colour for someone without a photo; stable per person. */
export function toneFor(id: string): Tone {
  let n = 0;
  for (const c of id) n += c.charCodeAt(0);
  return (['soft', 'lav', 'grey', 'accent'] as const)[n % 4]!;
}

export const initialOf = (name: string) => name.trim().charAt(0).toUpperCase() || '?';

/** "Diamond · CoD Mobile": a player's headline game. */
export function rankLine(g: UserGame | null | undefined) {
  if (!g) return '';
  const game = g.game?.name ?? g.customGameName ?? '';
  const rank = g.rank?.name ?? g.rankText;
  return rank ? `${rank} · ${game}` : game;
}

/** Search words people use for games beyond their name. */
const aliases: Record<string, string[]> = {
  lol: ['league', 'lol'],
  cs2: ['cs', 'csgo', 'counter strike', 'premier'],
  ow: ['overwatch 2', 'ow2'],
  r6: ['siege', 'r6', 'rainbow'],
  bo7: ['cod', 'call of duty', 'black ops'],
  wz: ['cod', 'warzone'],
  pubgpc: ['pubg', 'battlegrounds'],
  fc: ['fifa', 'fc 26', 'fc 27', 'ultimate team', 'football', 'soccer'],
  efootball: ['pes', 'football', 'soccer'],
  codm: ['cod', 'call of duty mobile'],
  pubg: ['pubg', 'bgmi'],
  ff: ['ff max', 'garena'],
  mlbb: ['ml', 'mobile legends'],
  wr: ['wild rift', 'league'],
  coc: ['clash'],
  cr: ['clash'],
  unite: ['pokemon'],
  gta: ['gta v', 'gta 5', 'grand theft auto'],
  elden: ['nightreign'],
  bf6: ['battlefield'],
  mhw: ['monster hunter'],
  nba2k: ['basketball'],
  mkw: ['mario kart'],
};

/** A catalog game, or one the player typed in (id `x:<name>`). */
export type Game = GameDto & { custom?: boolean };

export function gameMatches(g: Game, q: string) {
  const s = q.trim().toLowerCase();
  if (!s) return true;
  return (
    g.name.toLowerCase().includes(s) ||
    g.shortCode.toLowerCase().includes(s) ||
    (aliases[g.id] ?? []).some((a) => a.includes(s))
  );
}

export function customGame(name: string): Game {
  const n = name.trim();
  const words = n.split(/\s+/).filter(Boolean);
  const short =
    words.length > 1
      ? words
          .slice(0, 4)
          .map((w) => w[0])
          .join('')
          .toUpperCase()
      : n.slice(0, 4).toUpperCase();
  return {
    id: `x:${n.toLowerCase()}`,
    name: n,
    shortCode: short,
    hasRanks: false,
    maxParty: 5,
    isLaunch: false,
    platforms: [],
    ranks: [],
    roles: [],
    modes: [],
    custom: true,
  };
}

/** "02:14:09" until `to`. */
export function countdown(to: string, now: number) {
  const s = Math.max(0, Math.floor((new Date(to).getTime() - now) / 1000));
  const p = (n: number) => String(n).padStart(2, '0');
  return `${p(Math.floor(s / 3600))}:${p(Math.floor((s % 3600) / 60))}:${p(s % 60)}`;
}

/** "21:00" in local time. */
export const clock = (iso: string) =>
  new Date(iso).toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' });

/** "now", "5m", "3h", "2d". */
export function ago(iso: string) {
  const m = Math.floor((Date.now() - new Date(iso).getTime()) / 60000);
  if (m < 1) return 'now';
  if (m < 60) return `${m}m`;
  if (m < 1440) return `${Math.floor(m / 60)}h`;
  return `${Math.floor(m / 1440)}d`;
}

export const pad2 = (n: number) => String(n).padStart(2, '0');

export const intros = [
  {
    kicker: 'Who are you as a gamer?',
    step: 'Step 1 · Build your gamer ID',
    body: 'Your games, ranks, platforms and IDs in one profile — not split across six apps.',
  },
  {
    kicker: 'Who’s up for a game tonight?',
    step: 'Step 2 · Find players who fit',
    body: 'Browse short-lived “Looking for Players” listings, or post your own in seconds.',
  },
  {
    kicker: 'Stop queueing with strangers.',
    step: 'Step 3 · Connect & play',
    body: 'Send a request, get connected, and lock in a session together.',
  },
];
