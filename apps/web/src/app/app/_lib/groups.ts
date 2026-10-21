'use client';

import { useSyncExternalStore } from 'react';
import type { Group, GroupKind } from './api';

// Groups on the API (docs/FEED_AND_GROUPS_API.md phases 4–5). What's kept
// here: the Groups tab's own filters while moving around, the labels and
// the event times the screens share.

export const groupKinds: GroupKind[] = ['game', 'city', 'campus', 'squad'];
export const kindLabel: Record<GroupKind, string> = {
  game: 'Game',
  city: 'City',
  campus: 'Campus',
  squad: 'Squad',
};

/** "1,204" style member counts. */
export const groupCount = (n: number) =>
  n >= 1000 ? `${Math.floor(n / 1000)},${String(n % 1000).padStart(3, '0')}` : `${n}`;

/** "Valorant · Ethiopia", or "City · Addis Ababa". */
export const groupLine = (g: Pick<Group, 'kind' | 'game' | 'place'>) =>
  `${g.kind === 'game' && g.game ? g.game.name : kindLabel[g.kind]} · ${g.place}`;

const pad = (n: number) => String(n).padStart(2, '0');
const dayKey = (d: Date) => `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;

/**
 * An event's day as the cards say it: "Today", "Tonight" (from 18:00),
 * "Tomorrow", else "Sat 25 Oct". Local time.
 */
export function eventDay(iso: string) {
  const t = new Date(iso);
  const now = new Date();
  const tomorrow = new Date(now);
  tomorrow.setDate(now.getDate() + 1);
  if (dayKey(t) === dayKey(now)) return t.getHours() >= 18 ? 'Tonight' : 'Today';
  if (dayKey(t) === dayKey(tomorrow)) return 'Tomorrow';
  return t.toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short' });
}
export const eventTime = (iso: string) => {
  const t = new Date(iso);
  return `${pad(t.getHours())}:${pad(t.getMinutes())}`;
};
/** "Tonight 21:00", "Sat 25 Oct 18:00". */
export const eventWhen = (iso: string) => `${eventDay(iso)} ${eventTime(iso)}`;

export type GroupsView = {
  tab: 'discover' | 'mine';
  kind: 'all' | GroupKind;
  query: string;
};
const fresh = (): GroupsView => ({ tab: 'discover', kind: 'all', query: '' });
let view = fresh();
const initial = view;
const listeners = new Set<() => void>();
const subscribe = (l: () => void) => {
  listeners.add(l);
  return () => listeners.delete(l);
};

/** The Groups tab's filters, kept while the player moves around. */
export function useGroupsView() {
  return useSyncExternalStore(
    subscribe,
    () => view,
    () => initial,
  );
}
export function setGroupsView(v: Partial<GroupsView>) {
  view = { ...view, ...v };
  listeners.forEach((l) => l());
}
/** Back to the defaults (a different player signed in). */
export const resetGroups = () => setGroupsView(fresh());
