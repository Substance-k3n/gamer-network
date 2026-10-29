'use client';

import type { Screen } from './data';
import { Icon } from './icons';
import { Games } from './screens/Games';
import { Overview } from './screens/Overview';
import { Reports } from './screens/Reports';
import { UserDrawer } from './screens/UserDrawer';
import { Users } from './screens/Users';
import { useAdmin } from './state';
import { ThemeToggle } from './theme';
import { Toast } from './ui';
import { ACC, ACCTX, C1, DK, DOTO, LINE, MUT, SOFT, TX, grot, mono } from './tokens';

const TITLES: Record<Screen, [string, string]> = {
  overview: ['Dashboard', 'Overview'],
  reports: ['Trust & safety', 'Reports'],
  users: ['Community', 'Users'],
  games: ['Catalog', 'Games'],
};

// Remembered per browser; try/catch because storage can be blocked.
function toggleRail() {
  const root = document.documentElement;
  const next = root.dataset.sidebar === 'collapsed' ? 'expanded' : 'collapsed';
  if (next === 'collapsed') root.dataset.sidebar = 'collapsed';
  else delete root.dataset.sidebar;
  try {
    localStorage.setItem('gn-sidebar', next);
  } catch {
    /* the rail just resets on reload */
  }
}

export function AdminDashboard({ startScreen = 'overview' }: { startScreen?: Screen }) {
  const admin = useAdmin(startScreen);
  const { s, set, go, signOut } = admin;
  const scr = s.screen;
  const openReps = s.openReports.length;
  const nav: [Screen, string, string | null][] = [
    ['overview', 'Overview', null],
    ['reports', 'Reports', openReps ? `${openReps}${s.openMore ? '+' : ''}` : null],
    ['users', 'Users', null],
    ['games', 'Games', null],
  ];

  return (
    <div className="shell">
      <div
        className={`scrim-nav${s.navOpen ? ' open' : ''}`}
        onClick={() => set({ navOpen: false })}
      />
      <aside className={`side${s.navOpen ? ' open' : ''}`} aria-label="Main">
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: 8,
            padding: '0 10px 18px',
            minHeight: 40,
          }}
        >
          <span style={{ fontFamily: DOTO, fontWeight: 800, fontSize: 28, letterSpacing: -1 }}>
            rally<span style={{ color: ACCTX }}>.</span>
          </span>
          <span className="brand-sub" style={{ font: mono(700, 11), color: ACCTX, flex: 1 }}>
            admin
          </span>
        </div>
        {nav.map(([k, label, badge]) => {
          const on = scr === k;
          return (
            <button
              key={k}
              type="button"
              className="nav-item btn-hover"
              title={label}
              aria-current={on ? 'page' : undefined}
              onClick={() => go(k)}
              style={{
                height: 46,
                borderRadius: 16,
                border: `1px solid ${on ? LINE : 'transparent'}`,
                background: on ? ACC : 'transparent',
                color: on ? DK : MUT,
                boxShadow: on ? 'var(--glow)' : 'none',
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                padding: '0 12px',
                font: grot(700, 15),
                cursor: 'pointer',
                textAlign: 'left',
                position: 'relative',
              }}
            >
              <Icon name={k} />
              <span className="nav-label" style={{ flex: 1 }}>
                {label}
              </span>
              {badge ? (
                <span
                  className="nav-badge-text"
                  style={{
                    minWidth: 22,
                    height: 20,
                    borderRadius: 10,
                    background: on ? DK : ACC,
                    color: on ? ACC : DK,
                    font: mono(700, 11),
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '0 6px',
                    boxSizing: 'border-box',
                  }}
                >
                  {badge}
                </span>
              ) : null}
            </button>
          );
        })}
        <div style={{ flex: 1 }} />
        <button
          type="button"
          className="side-collapse nav-item btn-hover"
          onClick={toggleRail}
          title="Collapse or expand the sidebar"
          aria-label="Collapse or expand the sidebar"
          style={{
            height: 40,
            borderRadius: 14,
            border: 'none',
            background: 'transparent',
            color: MUT,
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            padding: '0 12px',
            font: grot(600, 14),
            cursor: 'pointer',
          }}
        >
          <Icon name="chevron" />
          <span className="nav-label">Collapse</span>
        </button>
        <div
          className="me-card"
          style={{
            border: `1px solid ${LINE}`,
            background: C1,
            borderRadius: 18,
            padding: 12,
            display: 'flex',
            alignItems: 'center',
            gap: 10,
            marginTop: 6,
          }}
        >
          <div
            title={s.me ?? ''}
            style={{
              width: 36,
              height: 36,
              borderRadius: '50%',
              background: SOFT,
              color: TX,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 800,
              flex: 'none',
              boxSizing: 'border-box',
            }}
          >
            {s.me?.[0]?.toUpperCase() ?? ''}
          </div>
          <div className="me-text" style={{ minWidth: 0, flex: 1 }}>
            <div
              style={{
                fontWeight: 700,
                fontSize: 14,
                whiteSpace: 'nowrap',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
            >
              {s.me ?? '…'}
            </div>
            <button
              type="button"
              onClick={signOut}
              style={{
                font: mono(600, 12),
                color: MUT,
                background: 'none',
                border: 'none',
                padding: 0,
                cursor: 'pointer',
                textDecoration: 'underline',
              }}
            >
              Sign out
            </button>
          </div>
        </div>
      </aside>

      <main
        className="main"
        style={{
          padding: '24px 28px 56px',
          minWidth: 0,
          display: 'flex',
          flexDirection: 'column',
          gap: 18,
        }}
      >
        <header style={{ display: 'flex', alignItems: 'flex-end', gap: 12, flexWrap: 'wrap' }}>
          <button
            type="button"
            className="hamburger btn-hover"
            aria-label="Open the menu"
            onClick={() => set({ navOpen: true })}
            style={{
              width: 44,
              height: 44,
              borderRadius: '50%',
              border: `1px solid ${LINE}`,
              background: C1,
              color: TX,
              cursor: 'pointer',
              alignItems: 'center',
              justifyContent: 'center',
              padding: 0,
            }}
          >
            <Icon name="menu" />
          </button>
          <div style={{ flex: 1, minWidth: 180 }}>
            <div style={{ font: mono(700, 12), color: MUT }}>{TITLES[scr][0]}</div>
            <h1
              style={{
                fontFamily: DOTO,
                fontWeight: 800,
                fontSize: 34,
                letterSpacing: -0.8,
                lineHeight: 1.1,
                margin: '2px 0 0',
              }}
            >
              {TITLES[scr][1]}
            </h1>
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              height: 44,
              border: `1px solid ${LINE}`,
              borderRadius: 99,
              background: C1,
              padding: '0 16px',
              width: 300,
              maxWidth: '100%',
              boxSizing: 'border-box',
              color: MUT,
            }}
          >
            <Icon name="search" size={16} />
            <input
              aria-label="Search users"
              placeholder="Search users, press Enter"
              value={s.globalQ}
              onChange={(e) => set({ globalQ: e.target.value })}
              onKeyDown={(e) => {
                if (e.key === 'Enter')
                  go('users', {
                    userQ: s.globalQ,
                    userF: 'All',
                    userPage: 1,
                    searchSeq: s.searchSeq + 1,
                  });
              }}
              style={{
                flex: 1,
                minWidth: 0,
                border: 'none',
                background: 'transparent',
                fontSize: 14,
                outline: 'none',
                color: TX,
              }}
            />
          </div>
          <ThemeToggle size={44} />
        </header>

        <Toast message={s.toast} />

        {/* Keyed by version: after a moderation action the screen remounts and refetches. */}
        {scr === 'overview' && <Overview key={s.version} admin={admin} />}
        {scr === 'reports' && <Reports key={s.version} admin={admin} />}
        {scr === 'users' && <Users key={`${s.version}-${s.searchSeq}`} admin={admin} />}
        {scr === 'games' && <Games admin={admin} />}
      </main>

      <UserDrawer key={s.userSel ?? 'none'} admin={admin} />
    </div>
  );
}
