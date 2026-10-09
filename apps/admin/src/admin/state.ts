'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import {
  GAMES,
  GROUPS,
  HISTORY,
  REPORTS,
  USERS,
  type Game,
  type Group,
  type GroupType,
  type HistoryEntry,
  type Range,
  type Report,
  type Screen,
  type Severity,
  type User,
  type UserStatus,
} from './data';

export type State = {
  screen: Screen;
  range: Range;
  toast: string | null;
  globalQ: string;
  reports: Report[];
  repStatus: 'open' | 'closed';
  repSev: 'ALL' | Severity;
  repSel: string | null;
  users: User[];
  userF: string;
  userQ: string;
  userSel: string | null;
  history: Record<string, HistoryEntry[]>;
  rankReset: Record<string, boolean>;
  games: Game[];
  gameSel: string;
  newG: Omit<Game, 'id' | 'players'>;
  rankDraft: string;
  groups: Group[];
  groupF: string;
  gDraft: { name: string; type: GroupType };
};

export const emptyGame = (): State['newG'] => ({
  name: '',
  short: '',
  ranks: [],
  platforms: ['PC'],
  enabled: true,
});

const initial = (screen: Screen): State => ({
  screen,
  range: '30D',
  toast: null,
  globalQ: '',
  reports: REPORTS,
  repStatus: 'open',
  repSev: 'ALL',
  repSel: 'R-2041',
  users: USERS,
  userF: 'All',
  userQ: '',
  userSel: null,
  history: HISTORY,
  rankReset: {},
  games: GAMES,
  gameSel: 'val',
  newG: emptyGame(),
  rankDraft: '',
  groups: GROUPS,
  groupF: 'All',
  gDraft: { name: '', type: 'Game' },
});

export type Patch = Partial<State> | ((s: State) => Partial<State>);

export type Admin = {
  s: State;
  set: (p: Patch) => void;
  go: (screen: Screen, extra?: Partial<State>) => void;
  toast: (msg: string) => void;
  setUser: (id: string, status: UserStatus, note: string) => void;
  closeRep: (id: string, outcome: string, userAct: UserStatus | null) => void;
};

export function useAdmin(startScreen: Screen): Admin {
  const [s, setRaw] = useState(() => initial(startScreen));
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);

  const set = useCallback(
    (p: Patch) => setRaw((prev) => ({ ...prev, ...(typeof p === 'function' ? p(prev) : p) })),
    [],
  );

  useEffect(() => () => clearTimeout(timer.current), []);

  const toast = (msg: string) => {
    clearTimeout(timer.current);
    set({ toast: msg });
    timer.current = setTimeout(() => set({ toast: null }), 2600);
  };

  const go = (screen: Screen, extra?: Partial<State>) => {
    set({ screen, ...extra });
    window.scrollTo(0, 0);
  };

  const setUser = (id: string, status: UserStatus, note: string) => {
    const t = new Date().toLocaleDateString('en-US', { month: 'short', day: '2-digit' });
    set((st) => ({
      users: st.users.map((u) => (u.id === id ? { ...u, status } : u)),
      history: { ...st.history, [id]: [{ t, text: note }, ...(st.history[id] ?? [])] },
    }));
  };

  const closeRep = (id: string, outcome: string, userAct: UserStatus | null) => {
    const r = s.reports.find((x) => x.id === id);
    if (!r) return;
    const u = s.users.find((x) => x.handle === r.target);
    set((st) => ({
      reports: st.reports.map((x) =>
        x.id === id
          ? { ...x, status: outcome === 'Dismissed' ? 'dismissed' : 'resolved', outcome }
          : x,
      ),
    }));
    if (userAct && u) setUser(u.id, userAct, `${outcome} — ${r.reason.toLowerCase()}`);
    const next = s.reports.find((x) => x.id !== id && x.status === 'open');
    set({ repSel: next ? next.id : id });
    toast(`${outcome} · ${id}`);
  };

  return { s, set, go, toast, setUser, closeRep };
}
