'use client';

import { useSyncExternalStore } from 'react';
import type { Tone } from './data';

// Groups run on this sample data until the API has groups
// (docs/FEED_AND_GROUPS_API.md, phase 3): the same groups, people, posts and
// events as apps/mobile/lib/groups_data.dart. Nothing here leaves the
// browser, and a reload starts over.

export const groupKinds = ['Game', 'City', 'Campus', 'Squad'] as const;
export type GroupKind = (typeof groupKinds)[number];

/** Someone in a sample group. "me" is the signed-in player. */
export type Member = { name: string; handle: string; tone: Tone; rank: string };

/** The sample people groups are made of, by key. */
export const members: Record<string, Member> = {
  dave: { name: 'Dave', handle: 'dave.exe', tone: 'soft', rank: 'Diamond · Valorant' },
  hana: { name: 'Hana', handle: 'hanaplays', tone: 'lav', rank: 'Div 2 · EA SPORTS FC' },
  yonas: { name: 'Yonas', handle: 'yonasjg', tone: 'grey', rank: 'Emerald · League of Legends' },
  meron: { name: 'Meron', handle: 'meron.codm', tone: 'accent', rank: 'Legendary · CoD Mobile' },
  abel: { name: 'Abel', handle: 'abelsmokes', tone: 'soft', rank: 'Platinum · Valorant' },
  liya: { name: 'Liya', handle: 'liya.mc', tone: 'lav', rank: 'Creative · Minecraft' },
};

export type GroupPost = { who: string; text: string; time: string; gg: number };
export type GroupEvent = {
  id: string;
  title: string;
  when: string;
  gameId?: string;
  going: string[];
};

/** A community. `members` holds the people the app knows; `extra` stands in for everyone else. */
export type Group = {
  id: string;
  name: string;
  short: string;
  kind: GroupKind;
  gameId?: string;
  place: string;
  about: string;
  tone: Tone;
  members: string[];
  admins: string[];
  extra: number;
  approval: boolean;
  since: string;
  rules: string[];
  posts: GroupPost[];
  events: GroupEvent[];
};

export type GroupDraft = {
  name: string;
  place: string;
  about: string;
  kind: GroupKind;
  gameId?: string;
  approval: boolean;
  tone: Tone;
};

export const groupSize = (g: Group) => g.members.length + g.extra;

/** "1,204" style member counts. */
export const groupCount = (n: number) =>
  n >= 1000 ? `${Math.floor(n / 1000)},${String(n % 1000).padStart(3, '0')}` : `${n}`;

/** "Valorant · Ethiopia", or "City · Addis Ababa". */
export const groupLine = (g: Group, gameName: (id: string) => string) =>
  g.kind === 'Game' && g.gameId ? `${gameName(g.gameId)} · ${g.place}` : `${g.kind} · ${g.place}`;

const post = (who: string, text: string, time: string, gg = 0): GroupPost => ({
  who,
  text,
  time,
  gg,
});

function seedGroups(): Group[] {
  return [
    {
      id: 'g-val',
      name: 'Valorant Ethiopia',
      short: 'VAL',
      kind: 'Game',
      gameId: 'val',
      place: 'Ethiopia',
      tone: 'accent',
      members: ['me', 'dave', 'abel', 'meron'],
      admins: ['dave'],
      extra: 1197,
      approval: false,
      since: 'Mar 2025',
      about:
        'The home of Valorant in Ethiopia. Find a duo, organise 5-stacks, share clips and talk agents. Every rank welcome — Iron to Radiant.',
      rules: [
        'Be decent. No slurs, no harassment.',
        'LFG posts go in the feed with your rank and region.',
        'No account selling or boosting.',
      ],
      posts: [
        post(
          'dave',
          'Customs tonight at 21:00 — need two more for the second team. Reply here.',
          '25m',
          14,
        ),
        post(
          'abel',
          'Smoke lineups for Sunset B site, thread below. Took me a week to get these clean.',
          '3h',
          31,
        ),
        post('meron', 'Anyone else getting 120ms on the Bahrain server since the patch?', '5h', 6),
      ],
      events: [
        {
          id: 'e1',
          title: '5-stack customs',
          when: 'Tonight 21:00',
          gameId: 'val',
          going: ['dave', 'abel'],
        },
        {
          id: 'e2',
          title: 'Unrated night — new players welcome',
          when: 'Sat 19:00',
          gameId: 'val',
          going: ['meron'],
        },
      ],
    },
    {
      id: 'g-fc',
      name: 'Ethiopian FC Players',
      short: 'FC',
      kind: 'Game',
      gameId: 'fc',
      place: 'Ethiopia',
      tone: 'lav',
      members: ['hana', 'yonas'],
      admins: ['hana'],
      extra: 858,
      approval: false,
      since: 'Sep 2024',
      about:
        'Ultimate Team, Pro Clubs and Rivals. Weekend clubs nights and a monthly local tournament.',
      rules: ['Tag your platform in LFG posts.', 'Keep trades out of the feed.'],
      posts: [
        post(
          'hana',
          'Pro Clubs: we need a CB and a striker for Sunday. Div 2 club, chill vibes.',
          '1h',
          9,
        ),
      ],
      events: [
        { id: 'e3', title: 'Pro Clubs night', when: 'Sun 20:00', gameId: 'fc', going: ['hana'] },
      ],
    },
    {
      id: 'g-mc',
      name: 'Addis Minecraft Community',
      short: 'MC',
      kind: 'City',
      gameId: 'mc',
      place: 'Addis Ababa',
      tone: 'soft',
      members: ['liya'],
      admins: ['liya'],
      extra: 339,
      approval: false,
      since: 'Jan 2025',
      about:
        'We’re building Addis block by block on our own server. Builders, redstoners and explorers all welcome.',
      rules: ['No griefing on the shared server.', 'Ask before building next to someone.'],
      posts: [
        post(
          'liya',
          'Meskel Square is done! Next up: the light rail. Who wants to plan the route?',
          '2h',
          22,
        ),
      ],
      events: [
        {
          id: 'e4',
          title: 'Build night: light rail',
          when: 'Fri 20:00',
          gameId: 'mc',
          going: ['liya'],
        },
      ],
    },
    {
      id: 'g-aau',
      name: 'AAU Gamers',
      short: 'AAU',
      kind: 'Campus',
      place: 'Addis Ababa University',
      tone: 'grey',
      members: ['meron', 'dave', 'hana'],
      admins: ['meron'],
      extra: 212,
      approval: true,
      since: 'Oct 2025',
      about:
        'Students and alumni of Addis Ababa University. Campus LAN days, inter-faculty tournaments and study-break sessions.',
      rules: ['Current students and alumni only.', 'Tournament sign-ups close 48h before start.'],
      posts: [
        post('meron', 'Inter-faculty CODM tournament sign-ups are open. Squads of 5.', '1d', 18),
      ],
      events: [{ id: 'e5', title: 'Campus LAN day', when: 'Sat 14:00', going: ['meron', 'dave'] }],
    },
    {
      id: 'g-codm',
      name: 'Addis CODM Squads',
      short: 'CODM',
      kind: 'Squad',
      gameId: 'codm',
      place: 'Addis Ababa',
      tone: 'accent',
      members: ['meron'],
      admins: ['meron'],
      extra: 74,
      approval: false,
      since: 'Jun 2026',
      about: 'Competitive CODM squads in Addis. Scrims every week, ranked pushes every night.',
      rules: ['Mic required for scrims.'],
      posts: [post('meron', 'Scrim vs Hawassa squad on Thursday. Need a sniper sub.', '6h', 7)],
      events: [],
    },
  ];
}

export type GroupsState = {
  groups: Group[];
  /** The Groups tab's own filters, kept while moving around. */
  tab: 'Discover' | 'Yours';
  kind: 'All' | GroupKind;
  query: string;
  /** Approval groups I asked to join, waiting. */
  requests: string[];
  /** Group posts I GG'd, by key. */
  gg: string[];
};

const fresh = (): GroupsState => ({
  groups: seedGroups(),
  tab: 'Discover',
  kind: 'All',
  query: '',
  requests: [],
  gg: [],
});
let state = fresh();
const initial = state;
const listeners = new Set<() => void>();
let timers: ReturnType<typeof setTimeout>[] = [];

function set(f: (s: GroupsState) => GroupsState) {
  state = f(state);
  listeners.forEach((l) => l());
}
const subscribe = (l: () => void) => {
  listeners.add(l);
  return () => listeners.delete(l);
};

export function useGroups() {
  return useSyncExternalStore(
    subscribe,
    () => state,
    () => initial,
  );
}

/** Back to the sample data (a different player signed in). */
export function resetGroups() {
  timers.forEach(clearTimeout);
  timers = [];
  set(fresh);
}

export const setGroupsView = (v: Partial<Pick<GroupsState, 'tab' | 'kind' | 'query'>>) =>
  set((s) => ({ ...s, ...v }));

function putGroup(id: string, f: (g: Group) => Group) {
  set((s) => ({ ...s, groups: s.groups.map((g) => (g.id === id ? f(g) : g)) }));
}

export const groupsOf = (s: GroupsState, who: string) =>
  s.groups.filter((g) => g.members.includes(who));

/**
 * Joins right away, or asks when the group needs approval (approved after a
 * moment, standing in for an admin).
 */
export function joinGroup(g: Group, toast: (m: string) => void) {
  if (g.members.includes('me') || state.requests.includes(g.id)) return;
  if (!g.approval) {
    putGroup(g.id, (x) => ({ ...x, members: [...x.members, 'me'] }));
    return toast(`You joined ${g.name}`);
  }
  set((s) => ({ ...s, requests: [...s.requests, g.id] }));
  toast(`Request sent to ${g.name} admins`);
  timers.push(
    setTimeout(() => {
      if (!state.requests.includes(g.id)) return;
      set((s) => ({ ...s, requests: s.requests.filter((r) => r !== g.id) }));
      putGroup(g.id, (x) => ({ ...x, members: [...x.members, 'me'] }));
      toast(`You’re in — ${g.name} approved your request`);
    }, 3500),
  );
}

export function leaveGroup(g: Group, toast: (m: string) => void) {
  if (g.admins.includes('me') && g.admins.length === 1)
    return toast('Make someone else admin before leaving');
  putGroup(g.id, (x) => ({
    ...x,
    members: x.members.filter((m) => m !== 'me'),
    admins: x.admins.filter((m) => m !== 'me'),
  }));
  toast(`You left ${g.name}`);
}

export function postInGroup(g: Group, text: string) {
  const t = text.trim();
  if (!t) return false;
  putGroup(g.id, (x) => ({ ...x, posts: [post('me', t, 'now'), ...x.posts] }));
  return true;
}

export const toggleGroupGG = (key: string) =>
  set((s) => ({
    ...s,
    gg: s.gg.includes(key) ? s.gg.filter((k) => k !== key) : [...s.gg, key],
  }));

export const toggleGoing = (g: Group, e: GroupEvent) =>
  putGroup(g.id, (x) => ({
    ...x,
    events: x.events.map((y) =>
      y.id !== e.id
        ? y
        : {
            ...y,
            going: y.going.includes('me') ? y.going.filter((m) => m !== 'me') : [...y.going, 'me'],
          },
    ),
  }));

export function addGroupEvent(
  g: Group,
  title: string,
  when: string,
  gameId: string | undefined,
  toast: (m: string) => void,
) {
  putGroup(g.id, (x) => ({
    ...x,
    events: [{ id: `e${Date.now()}`, title, when, gameId, going: ['me'] }, ...x.events],
  }));
  toast('Event added — members will see it');
}

/** A group's badge text: the game's short code, or the name's initials. */
export function groupShort(d: GroupDraft, shortCode: (id: string) => string) {
  const name = d.name.trim();
  if (d.kind === 'Game' && d.gameId) return shortCode(d.gameId);
  if (!name) return '?';
  const words = name.split(/\s+/).filter(Boolean);
  return (
    words.length > 1
      ? words
          .slice(0, 3)
          .map((w) => w[0])
          .join('')
      : name.slice(0, 3)
  ).toUpperCase();
}

/** Makes the group with me as its admin; "Yours" shows it from now on. */
export function createGroup(d: GroupDraft, short: string): Group {
  const about = d.about.trim();
  const g: Group = {
    id: `g-${Date.now()}`,
    name: d.name.trim(),
    short,
    kind: d.kind,
    gameId: d.kind === 'Game' ? d.gameId : undefined,
    place: d.place.trim(),
    about: about || 'A new group on rally.',
    tone: d.tone,
    members: ['me'],
    admins: ['me'],
    extra: 0,
    approval: d.approval,
    since: 'Today',
    rules: [],
    posts: [],
    events: [],
  };
  set((s) => ({ ...s, groups: [g, ...s.groups], tab: 'Yours' }));
  return g;
}
