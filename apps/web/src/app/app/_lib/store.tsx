'use client';

import { usePathname, useRouter } from 'next/navigation';
import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  useSyncExternalStore,
  type ReactNode,
} from 'react';
import {
  api,
  ApiError,
  setSignedOutHandler,
  type AppConfig,
  type Me,
  type PlayInvite,
} from './api';
import { customGame, type Game } from './data';

export type Skin = 'inked' | 'soft' | 'dot' | 'glass';
export const skins: { id: Skin; name: string; tagline: string; bg: string }[] = [
  { id: 'inked', name: 'Inked', tagline: 'Hard shadows, segment digits', bg: '#e9e6e0' },
  { id: 'soft', name: 'Soft clay', tagline: 'Pillowy, mint on stone', bg: '#ededea' },
  { id: 'dot', name: 'Dot matrix', tagline: 'Matte black, signal red', bg: '#101010' },
  { id: 'glass', name: 'Glass', tagline: 'Frosted panels, aurora glow', bg: '#0e1128' },
];

// The skin is remembered on the device (localStorage, or memory when
// storage is off) and read as an external store: right on the first render.
const skinListeners = new Set<() => void>();
let memorySkin: Skin | null = null;
function readSkin(): Skin {
  if (memorySkin) return memorySkin;
  try {
    const s = localStorage.getItem('skin') as Skin | null;
    if (s && skins.some((x) => x.id === s)) return s;
  } catch {}
  return 'inked';
}
function subscribeSkin(cb: () => void) {
  skinListeners.add(cb);
  return () => skinListeners.delete(cb);
}

/** Pages that work signed out; everything else needs a session. */
const PUBLIC = ['/app/welcome', '/app/login', '/app/signup', '/app/forgot'];

/**
 * Whether `path` may render for this player right now. Anything else waits
 * for the redirect, so a page never calls the API without a session.
 */
export function mayShow(path: string, me: Me | null) {
  if (PUBLIC.some((p) => path.startsWith(p))) return true;
  if (!me) return false;
  return !!me.onboardedAt || path.startsWith('/app/onboarding') || path === '/app/verify';
}

type Sheet =
  { kind: 'listing' } | { kind: 'invite'; userId: string; name: string; games: string[] };

type Store = {
  ready: boolean;
  waking: boolean;
  offline: boolean;
  config: AppConfig | null;
  games: Game[];
  game: (id: string) => Game;
  addCustomGame: (name: string) => string;
  me: Me | null;
  setMe: (m: Me | null) => void;
  refreshMe: () => Promise<Me | null>;
  unread: number;
  setUnread: (n: number) => void;
  invites: PlayInvite[];
  setInvites: (i: PlayInvite[]) => void;
  toastMsg: string | null;
  toast: (msg: string) => void;
  busy: boolean;
  /** Runs an API call: toasts its error and returns null on failure. */
  run: <T>(f: () => Promise<T>, opts?: { quiet?: boolean; busy?: boolean }) => Promise<T | null>;
  skin: Skin;
  setSkin: (s: Skin) => void;
  sheet: Sheet | null;
  setSheet: (s: Sheet | null) => void;
  /** Bumped after something changes elsewhere (a post, a ban…); pages reload on it. */
  version: number;
  bump: () => void;
  boot: () => Promise<void>;
  signedIn: (m: Me) => void;
  /** Back within the app; `fallback` when this page was opened directly (a link). */
  back: (fallback?: string) => void;
};

const Ctx = createContext<Store | null>(null);

export function useApp() {
  const s = useContext(Ctx);
  if (!s) throw new Error('useApp outside AppProvider');
  return s;
}

export function AppProvider({ children }: { children: ReactNode }) {
  const router = useRouter();
  const path = usePathname();
  const [ready, setReady] = useState(false);
  const [waking, setWaking] = useState(false);
  const [offline, setOffline] = useState(false);
  const [config, setConfig] = useState<AppConfig | null>(null);
  const [games, setGames] = useState<Game[]>([]);
  const [custom, setCustom] = useState<Record<string, Game>>({});
  const [me, setMe] = useState<Me | null>(null);
  const [unread, setUnread] = useState(0);
  const [invites, setInvites] = useState<PlayInvite[]>([]);
  const [toastMsg, setToast] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const skin = useSyncExternalStore(subscribeSkin, readSkin, () => 'inked' as Skin);
  const [sheet, setSheet] = useState<Sheet | null>(null);
  const [version, setVersion] = useState(0);
  const visited = useRef<string[]>([]);
  const bump = useCallback(() => setVersion((v) => v + 1), []);
  const toastTimer = useRef<ReturnType<typeof setTimeout>>(undefined);
  const busyRef = useRef(false);

  const toast = useCallback((msg: string) => {
    clearTimeout(toastTimer.current);
    setToast(msg);
    toastTimer.current = setTimeout(() => setToast(null), 2600);
  }, []);

  const run = useCallback(
    async <T,>(f: () => Promise<T>, opts?: { quiet?: boolean; busy?: boolean }) => {
      const lock = opts?.busy !== false;
      if (lock && busyRef.current) return null;
      if (lock) {
        busyRef.current = true;
        setBusy(true);
      }
      try {
        return await f();
      } catch (e) {
        const err =
          e instanceof ApiError ? e : new ApiError(0, 'error', 'Something went wrong. Try again.');
        if (err.code === 'email_not_verified') {
          toast('Confirm your email first: we sent you a code.');
          router.push('/app/verify');
        } else if (!opts?.quiet && err.code !== 'unauthenticated') {
          toast(err.detail);
        }
        return null;
      } finally {
        if (lock) {
          busyRef.current = false;
          setBusy(false);
        }
      }
    },
    [router, toast],
  );

  const game = useCallback(
    (id: string): Game =>
      games.find((g) => g.id === id) ?? custom[id] ?? customGame(id.replace(/^x:/, '')),
    [games, custom],
  );

  const addCustomGame = useCallback(
    (name: string) => {
      const n = name.trim().toLowerCase();
      const known = [...games, ...Object.values(custom)].find((g) => g.name.toLowerCase() === n);
      if (known) return known.id;
      const g = customGame(name);
      setCustom((c) => ({ ...c, [g.id]: g }));
      return g.id;
    },
    [games, custom],
  );

  const refreshMe = useCallback(async () => {
    const m = await run(() => api<Me>('me'), { quiet: true, busy: false });
    if (m) setMe(m);
    return m;
  }, [run]);

  const signedIn = useCallback(
    (m: Me) => {
      setMe(m);
      router.replace(m.onboardedAt ? '/app' : '/app/onboarding/games');
    },
    [router],
  );

  const boot = useCallback(async () => {
    const slow = setTimeout(() => setWaking(true), 3000);
    try {
      // Independent, so in parallel: on a slow network each round trip counts.
      const [cfg, list, session] = await Promise.all([
        run(() => api<AppConfig>('app/config'), { quiet: true, busy: false }),
        run(() => api<Game[]>('games'), { quiet: true, busy: false }),
        api<Me>('me', { expect401: true }).then(
          (m) => ({ me: m }),
          (e) => ({ error: e }),
        ),
      ]);
      setOffline(!cfg);
      if (!cfg) return;
      setConfig(cfg);
      if (list) setGames(list);
      if ('error' in session) {
        const e = session.error;
        if (!(e instanceof ApiError) || e.code !== 'unauthenticated') return setOffline(true);
        setMe(null);
      } else {
        setMe(session.me);
      }
      setReady(true);
    } finally {
      clearTimeout(slow);
      setWaking(false);
    }
  }, [run]);

  useEffect(() => {
    setSignedOutHandler(() => {
      setMe(null);
      router.replace('/app/login');
    });
    boot();
  }, [boot, router]);

  // The pages visited in this tab, so back never leaves the app.
  useEffect(() => {
    if (visited.current.at(-1) !== path) visited.current.push(path);
  }, [path]);
  const back = useCallback(
    (fallback = '/app') => (visited.current.length > 1 ? router.back() : router.replace(fallback)),
    [router],
  );

  // Where a page may be: signed out → welcome; not onboarded → onboarding.
  useEffect(() => {
    if (!ready) return;
    const isPublic = PUBLIC.some((p) => path.startsWith(p));
    if (!me && !isPublic) router.replace('/app/welcome');
    // Sign-up and password reset move on by themselves once they have a session.
    else if (me && isPublic && path !== '/app/forgot' && path !== '/app/signup')
      router.replace(me.onboardedAt ? '/app' : '/app/onboarding/games');
    else if (
      me &&
      !me.onboardedAt &&
      !isPublic &&
      !path.startsWith('/app/onboarding') &&
      path !== '/app/verify'
    )
      router.replace('/app/onboarding/games');
  }, [ready, me, path, router]);

  // The bell badge and incoming invites stay fresh while the app is open.
  useEffect(() => {
    if (!me?.onboardedAt) return;
    const tick = async () => {
      const [n, inv] = await Promise.all([
        run(() => api<{ count: number }>('notifications/unread-count'), {
          quiet: true,
          busy: false,
        }),
        run(() => api<{ items: PlayInvite[] }>('play-invites?direction=incoming'), {
          quiet: true,
          busy: false,
        }),
      ]);
      if (n) setUnread(n.count);
      if (inv) setInvites(inv.items);
    };
    tick();
    const t = setInterval(tick, 30_000);
    return () => clearInterval(t);
  }, [me?.onboardedAt, run]);

  const setSkin = useCallback((s: Skin) => {
    memorySkin = s;
    try {
      localStorage.setItem('skin', s);
    } catch {}
    skinListeners.forEach((f) => f());
  }, []);

  const value = useMemo<Store>(
    () => ({
      ready,
      waking,
      offline,
      config,
      games,
      game,
      addCustomGame,
      me,
      setMe,
      refreshMe,
      unread,
      setUnread,
      invites,
      setInvites,
      toastMsg,
      toast,
      busy,
      run,
      skin,
      setSkin,
      sheet,
      setSheet,
      version,
      bump,
      boot,
      signedIn,
      back,
    }),
    [
      ready,
      waking,
      offline,
      config,
      games,
      game,
      addCustomGame,
      me,
      refreshMe,
      unread,
      invites,
      toastMsg,
      toast,
      busy,
      run,
      skin,
      setSkin,
      sheet,
      version,
      bump,
      boot,
      signedIn,
      back,
    ],
  );
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

/** Re-renders every second, for countdowns. */
export function useNow(every = 1000) {
  const [now, setNow] = useState(() => Date.now());
  useEffect(() => {
    const t = setInterval(() => setNow(Date.now()), every);
    return () => clearInterval(t);
  }, [every]);
  return now;
}

/** Loads `f` on mount and whenever `deps` change; `reload` runs it again. */
export function useLoad<T>(f: () => Promise<T>, deps: unknown[]) {
  const { run } = useApp();
  const [data, setData] = useState<T | null>(null);
  const [loaded, setLoaded] = useState(false);
  const fRef = useRef(f);
  fRef.current = f;
  const reload = useCallback(async () => {
    const r = await run(() => fRef.current(), { busy: false });
    if (r !== null) setData(r);
    setLoaded(true);
    return r;
  }, [run]);
  useEffect(() => {
    reload();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
  return { data, setData, loaded, reload };
}

/**
 * Checks a username while it's typed (GET /usernames/{name}, debounced).
 * Null when it's fine, or when it's [mine] already.
 */
export function useUsernameNote(handle: string, mine?: string) {
  const [answer, setAnswer] = useState<{ name: string; note: string | null } | null>(null);
  const name = handle.trim().toLowerCase();
  useEffect(() => {
    if (!name || name === mine) return;
    const t = setTimeout(async () => {
      try {
        const r = await api<{ available: boolean; reason?: 'taken' | 'invalid' }>(
          `usernames/${encodeURIComponent(name)}`,
        );
        setAnswer({
          name,
          note: r.available
            ? null
            : r.reason === 'invalid'
              ? '3–20 characters: lowercase letters, numbers, dots and underscores'
              : `@${name} is taken`,
        });
      } catch {
        setAnswer({ name, note: null });
      }
    }, 400);
    return () => clearTimeout(t);
  }, [name, mine]);
  // Only the answer for what's typed now counts.
  return answer?.name === name && name !== mine ? answer.note : null;
}
