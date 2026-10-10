'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import { api, ApiError, query, type AdminReport, type Page } from './api';
import type { Range, Screen, Severity } from './data';

export type UserFilter = 'All' | 'Active' | 'Banned' | 'Deleted';

export type State = {
  screen: Screen;
  range: Range;
  toast: string | null;
  globalQ: string;
  me: string | null;
  /** The open queue, oldest first, as the API sends it. Also feeds the badge and Overview. */
  openReports: AdminReport[];
  openMore: string | null;
  repStatus: 'open' | 'closed';
  repSev: 'ALL' | Severity;
  repSel: string | null;
  userF: UserFilter;
  userQ: string;
  userSel: string | null;
  /** Bumped by the header search, which remounts Users with the new query. */
  searchSeq: number;
  /** Bumped after a moderation action; screens are keyed by it, so they refetch. */
  version: number;
};

const initial = (screen: Screen): State => ({
  screen,
  range: '30D',
  toast: null,
  globalQ: '',
  me: null,
  openReports: [],
  openMore: null,
  repStatus: 'open',
  repSev: 'ALL',
  repSel: null,
  userF: 'All',
  userQ: '',
  userSel: null,
  searchSeq: 0,
  version: 0,
});

export type Patch = Partial<State> | ((s: State) => Partial<State>);

export type Admin = {
  s: State;
  set: (p: Patch) => void;
  go: (screen: Screen, extra?: Partial<State>) => void;
  toast: (msg: string) => void;
  /** Toasts the API's message; for catch handlers. */
  fail: (e: unknown) => void;
  /** After a ban, resolve… so every screen refetches. */
  changed: () => void;
  signOut: () => Promise<void>;
};

export function useAdmin(startScreen: Screen): Admin {
  const [s, setRaw] = useState(() => initial(startScreen));
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);

  const set = useCallback(
    (p: Patch) => setRaw((prev) => ({ ...prev, ...(typeof p === 'function' ? p(prev) : p) })),
    [],
  );

  useEffect(() => () => clearTimeout(timer.current), []);

  const toast = useCallback(
    (msg: string) => {
      clearTimeout(timer.current);
      set({ toast: msg });
      timer.current = setTimeout(() => set({ toast: null }), 2600);
    },
    [set],
  );

  const fail = useCallback(
    (e: unknown) => toast(e instanceof ApiError ? e.message : 'Something went wrong. Try again.'),
    [toast],
  );

  // Who is signed in, for the sidebar card.
  useEffect(() => {
    api<{ displayName: string }>('me')
      .then((me) => set({ me: me.displayName }))
      .catch(fail);
  }, [set, fail]);

  // The open queue: the nav badge, Overview and the Reports screen share it.
  const loadOpen = useCallback(() => {
    api<Page<AdminReport>>(`admin/reports${query({ status: 'open', limit: 50 })}`)
      .then((p) => set({ openReports: p.items, openMore: p.nextCursor }))
      .catch(fail);
  }, [set, fail]);
  useEffect(loadOpen, [loadOpen]);

  const go = (screen: Screen, extra?: Partial<State>) => {
    set({ screen, ...extra });
    window.scrollTo(0, 0);
  };

  const changed = () => {
    set((st) => ({ version: st.version + 1 }));
    loadOpen();
  };

  const signOut = async () => {
    await fetch('/api/session', { method: 'DELETE' });
    window.location.href = '/login';
  };

  return { s, set, go, toast, fail, changed, signOut };
}
