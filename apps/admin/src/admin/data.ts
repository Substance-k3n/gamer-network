// Mock data from the design. Replace with @app/api-spec calls once the API's
// moderation endpoints exist.

export type Screen = 'overview' | 'reports' | 'users' | 'games' | 'groups';
export type UserStatus = 'Active' | 'Warned' | 'Suspended' | 'Banned';
export type Severity = 'HIGH' | 'MED' | 'LOW';
export type GroupStatus = 'Live' | 'Pending' | 'Paused';
export type GroupType = 'Game' | 'City' | 'Campus' | 'Country';

export type User = {
  id: string;
  name: string;
  handle: string;
  city: string;
  main: string;
  joined: string;
  last: string;
  conn: number;
  played: number;
  status: UserStatus;
  reports: number;
};

export type Game = {
  id: string;
  name: string;
  short: string;
  ranks: string[];
  platforms: string[];
  players: number;
  enabled: boolean;
};

export type Report = {
  id: string;
  kind: string;
  target: string;
  reporter: string;
  reason: string;
  sev: Severity;
  age: string;
  count: number;
  excerpt: string;
  clip?: boolean;
  status: 'open' | 'resolved' | 'dismissed';
  outcome?: string | null;
  note: string;
};

export type Group = {
  id: string;
  name: string;
  short: string;
  type: GroupType;
  owner: string;
  members: number;
  posts: number;
  reports: number;
  status: GroupStatus;
};

export type HistoryEntry = { t: string; text: string };

export const PLATS = ['PC', 'PlayStation', 'Xbox', 'Mobile', 'Switch'];

type UserRow = [
  string,
  string,
  string,
  string,
  string,
  string,
  string,
  number,
  number,
  UserStatus,
  number,
];
const userRows: UserRow[] = [
  [
    'dave',
    'Dave',
    'dave.exe',
    'Addis Ababa',
    'Valorant · Diamond',
    'Mar 02',
    '2h ago',
    48,
    31,
    'Active',
    0,
  ],
  [
    'meron',
    'Meron',
    'meron.codm',
    'Addis Ababa',
    'CoD Mobile · Legendary',
    'Jan 18',
    'now',
    91,
    57,
    'Active',
    0,
  ],
  [
    'hana',
    'Hana',
    'hanaplays',
    'Addis Ababa',
    'EA FC 25 · Div 2',
    'Apr 11',
    '1d ago',
    22,
    14,
    'Active',
    0,
  ],
  [
    'yonas',
    'Yonas',
    'yonasjg',
    'Bahir Dar',
    'League of Legends · Emerald',
    'Feb 27',
    '5h ago',
    63,
    40,
    'Active',
    1,
  ],
  [
    'abel',
    'Abel',
    'abelsmokes',
    'Adama',
    'Valorant · Platinum',
    'May 09',
    '3h ago',
    17,
    9,
    'Active',
    0,
  ],
  [
    'liya',
    'Liya',
    'liya.mc',
    'Hawassa',
    'Minecraft · Creative',
    'Jun 21',
    '20m ago',
    35,
    20,
    'Active',
    0,
  ],
  [
    'nati',
    'Natnael',
    'n4ti_aim',
    'Addis Ababa',
    'Valorant · Immortal',
    'Aug 03',
    '1h ago',
    12,
    6,
    'Warned',
    3,
  ],
  [
    'ruth',
    'Ruth',
    'ruthless',
    'Mekelle',
    'PUBG Mobile · Ace',
    'Jul 14',
    '6h ago',
    29,
    18,
    'Active',
    0,
  ],
  [
    'bini',
    'Biniam',
    'binibot',
    'Dire Dawa',
    'EA FC 25 · Elite',
    'Sep 01',
    '2d ago',
    3,
    0,
    'Active',
    4,
  ],
  [
    'sami',
    'Samuel',
    'samiK',
    'Gondar',
    'Dota 2 · Ancient',
    'Mar 30',
    '4h ago',
    41,
    22,
    'Active',
    1,
  ],
  [
    'eden',
    'Eden',
    'edenplays',
    'Addis Ababa',
    'Tekken 8 · Garyu',
    'Aug 19',
    '9h ago',
    19,
    11,
    'Suspended',
    2,
  ],
  ['kid', 'Kidus', 'kidus_x', 'Adama', 'CoD Mobile · Elite', 'Sep 22', '8d ago', 0, 0, 'Banned', 6],
];
export const USERS: User[] = userRows.map((a) => ({
  id: a[0],
  name: a[1],
  handle: a[2],
  city: a[3],
  main: a[4],
  joined: a[5],
  last: a[6],
  conn: a[7],
  played: a[8],
  status: a[9],
  reports: a[10],
}));

type GameRow = [string, string, string, string[], string[], number];
const gameRows: GameRow[] = [
  [
    'val',
    'Valorant',
    'VAL',
    ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Ascendant', 'Immortal', 'Radiant'],
    ['PC'],
    3820,
  ],
  [
    'codm',
    'CoD Mobile',
    'CODM',
    ['Rookie', 'Veteran', 'Elite', 'Pro', 'Master', 'Grandmaster', 'Legendary'],
    ['Mobile'],
    3410,
  ],
  [
    'fc',
    'EA FC 25',
    'FC',
    ['Div 10', 'Div 7', 'Div 5', 'Div 3', 'Div 2', 'Div 1', 'Elite'],
    ['PlayStation', 'Xbox', 'PC'],
    2960,
  ],
  [
    'pubg',
    'PUBG Mobile',
    'PUBG',
    ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Crown', 'Ace', 'Conqueror'],
    ['Mobile'],
    2240,
  ],
  [
    'lol',
    'League of Legends',
    'LoL',
    ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Emerald', 'Diamond', 'Master'],
    ['PC'],
    1580,
  ],
  [
    'dota',
    'Dota 2',
    'DOTA',
    ['Herald', 'Guardian', 'Crusader', 'Archon', 'Legend', 'Ancient', 'Divine', 'Immortal'],
    ['PC'],
    1120,
  ],
  [
    'tekken',
    'Tekken 8',
    'T8',
    ['Beginner', 'Fighter', 'Vanquisher', 'Garyu', 'Tekken King', 'God'],
    ['PlayStation', 'PC'],
    640,
  ],
  ['mc', 'Minecraft', 'MC', [], ['PC', 'Mobile', 'Switch'], 890],
  ['elden', 'Elden Ring', 'ER', [], ['PC', 'PlayStation'], 410],
];
export const GAMES: Game[] = gameRows.map((a) => ({
  id: a[0],
  name: a[1],
  short: a[2],
  ranks: a[3],
  platforms: a[4],
  players: a[5],
  enabled: true,
}));

export const REPORTS: Report[] = (
  [
    {
      id: 'R-2041',
      kind: 'Comment',
      target: 'n4ti_aim',
      reporter: 'abelsmokes',
      reason: 'Harassment',
      sev: 'HIGH',
      age: '12m',
      count: 5,
      excerpt: 'Uninstall bro, you’re the reason we lost. Don’t ever queue again.',
    },
    {
      id: 'R-2040',
      kind: 'Profile',
      target: 'binibot',
      reporter: 'hanaplays',
      reason: 'Fake rank',
      sev: 'MED',
      age: '48m',
      count: 3,
      excerpt: 'Profile lists EA FC 25 · Elite with 0 sessions played. Claims pro-team membership.',
    },
    {
      id: 'R-2039',
      kind: 'Listing',
      target: 'kidus_x',
      reporter: 'meron.codm',
      reason: 'Scam / selling accounts',
      sev: 'HIGH',
      age: '1h',
      count: 7,
      excerpt: 'Selling Legendary CODM accounts, DM for price. Payment via Telebirr first.',
    },
    {
      id: 'R-2038',
      kind: 'Clip',
      target: 'edenplays',
      reporter: 'ruthless',
      reason: 'Inappropriate clip',
      sev: 'MED',
      age: '3h',
      count: 2,
      excerpt: 'Clip caption: “When the lobby is full of…” (slur in audio at 0:11).',
      clip: true,
    },
    {
      id: 'R-2037',
      kind: 'Post',
      target: 'samiK',
      reporter: 'yonasjg',
      reason: 'Spam',
      sev: 'LOW',
      age: '5h',
      count: 1,
      excerpt: 'Join my Dota discord!!! link link link (posted 6 times in an hour)',
    },
    {
      id: 'R-2036',
      kind: 'Profile',
      target: 'yonasjg',
      reporter: 'binibot',
      reason: 'Impersonation',
      sev: 'LOW',
      age: '9h',
      count: 1,
      excerpt: 'Reporter claims this account copies a streamer’s name and avatar.',
    },
    {
      id: 'R-2035',
      kind: 'Comment',
      target: 'n4ti_aim',
      reporter: 'dave.exe',
      reason: 'Harassment',
      sev: 'MED',
      age: '1d',
      count: 2,
      excerpt: 'Typical Silver brain. Stick to unrated.',
      status: 'resolved',
      outcome: 'User warned',
    },
  ] as Omit<Report, 'status' | 'note'>[]
).map((r) => ({ status: 'open', note: '', ...r }) as Report);

export const GROUPS: Group[] = [
  {
    id: 'g1',
    name: 'Valorant Ethiopia',
    short: 'VAL',
    type: 'Game',
    owner: 'dave.exe',
    members: 1240,
    posts: 86,
    reports: 1,
    status: 'Live',
  },
  {
    id: 'g2',
    name: 'Ethiopian FC Players',
    short: 'FC',
    type: 'Country',
    owner: 'hanaplays',
    members: 860,
    posts: 54,
    reports: 0,
    status: 'Live',
  },
  {
    id: 'g3',
    name: 'Addis Minecraft Community',
    short: 'MC',
    type: 'City',
    owner: 'liya.mc',
    members: 340,
    posts: 21,
    reports: 0,
    status: 'Live',
  },
  {
    id: 'g4',
    name: 'AAU Gamers',
    short: 'AAU',
    type: 'Campus',
    owner: 'samiK',
    members: 0,
    posts: 0,
    reports: 0,
    status: 'Pending',
  },
  {
    id: 'g5',
    name: 'CODM Addis Cup',
    short: 'CUP',
    type: 'Game',
    owner: 'meron.codm',
    members: 0,
    posts: 0,
    reports: 0,
    status: 'Pending',
  },
  {
    id: 'g6',
    name: 'Hawassa LAN Nights',
    short: 'HWS',
    type: 'City',
    owner: 'ruthless',
    members: 112,
    posts: 4,
    reports: 3,
    status: 'Paused',
  },
];

export const HISTORY: Record<string, HistoryEntry[]> = {
  nati: [{ t: 'Oct 02', text: 'Warned — harassment in comments' }],
  eden: [{ t: 'Oct 07', text: 'Suspended 7d — slur in clip audio' }],
  kid: [{ t: 'Oct 01', text: 'Banned — account selling' }],
};

export const RANGES = {
  '7D': { days: 7, bars: 7, mult: 1 },
  '30D': { days: 30, bars: 15, mult: 4.1 },
  '90D': { days: 90, bars: 18, mult: 11.8 },
} as const;
export type Range = keyof typeof RANGES;

export const CITIES: [string, number][] = [
  ['Addis Ababa', 11240],
  ['Adama', 2310],
  ['Hawassa', 1870],
  ['Bahir Dar', 1460],
  ['Mekelle', 1190],
];

export const POST_MIX: [string, number, string][] = [
  ['Discussion', 31, '#FF4D2A'],
  ['Gameplay', 24, '#B8381E'],
  ['Looking for players', 19, '#6E6E6E'],
  ['Recruitment', 14, '#4A4A4A'],
  ['Poll', 12, '#2E2E2E'],
];
