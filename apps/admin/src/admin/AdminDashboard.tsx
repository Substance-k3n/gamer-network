'use client';

import type { Screen } from './data';
import { RANGES } from './data';
import { Games } from './screens/Games';
import { Overview } from './screens/Overview';
import { Reports } from './screens/Reports';
import { UserDrawer } from './screens/UserDrawer';
import { Users } from './screens/Users';
import { useAdmin } from './state';
import { Toast } from './ui';
import { ACC, C1, DK, DOTO, LINE, MUT, PANEL, RULE, SOFT, TX, grot, mono } from './tokens';

const TITLES: Record<Screen, [string, string]> = {
  overview: ['DASHBOARD', 'Overview'],
  reports: ['TRUST & SAFETY', 'Reports'],
  users: ['COMMUNITY', 'Users'],
  games: ['CATALOG', 'Games & ranks'],
};

export function AdminDashboard({ startScreen = 'overview' }: { startScreen?: Screen }) {
  const admin = useAdmin(startScreen);
  const { s, set, go, signOut } = admin;
  const scr = s.screen;
  const openReps = s.openReports.length;
  const nav: [Screen, string, string | null][] = [
    ['overview', 'Overview', null],
    ['reports', 'Reports', openReps ? `${openReps}${s.openMore ? '+' : ''}` : null],
    ['users', 'Users', null],
    ['games', 'Games & ranks', null],
  ];

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'grid',
        gridTemplateColumns: '232px minmax(0,1fr)',
        backgroundColor: '#101010',
        backgroundImage: 'radial-gradient(rgba(255,255,255,.045) 1px,transparent 1px)',
        backgroundSize: '14px 14px',
      }}
    >
      <aside
        style={{
          background: PANEL,
          borderRight: `1px solid ${RULE}`,
          padding: '22px 14px',
          display: 'flex',
          flexDirection: 'column',
          gap: 4,
          position: 'sticky',
          top: 0,
          height: '100vh',
          boxSizing: 'border-box',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, padding: '0 10px 20px' }}>
          <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 32, letterSpacing: -1 }}>
            rally<span style={{ color: ACC }}>.</span>
          </span>
          <span style={{ font: mono(400, 10), letterSpacing: '.06em', color: ACC }}>ADMIN</span>
        </div>
        {nav.map(([k, label, badge], i) => {
          const on = scr === k;
          return (
            <button
              key={k}
              type="button"
              onClick={() => go(k)}
              style={{
                height: 44,
                borderRadius: 12,
                border: `1px solid ${on ? LINE : 'transparent'}`,
                background: on ? C1 : 'transparent',
                color: on ? TX : MUT,
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                padding: '0 12px',
                font: grot(600, 15),
                cursor: 'pointer',
                textAlign: 'left',
              }}
            >
              <span style={{ font: mono(700, 11), width: 20, color: on ? ACC : '#5A5A5A' }}>
                {String(i + 1).padStart(2, '0')}
              </span>
              <span style={{ flex: 1 }}>{label}</span>
              {badge ? (
                <span
                  style={{
                    minWidth: 22,
                    height: 20,
                    borderRadius: 10,
                    background: ACC,
                    color: DK,
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
        <div
          style={{
            border: `1px solid ${LINE}`,
            background: C1,
            borderRadius: 16,
            padding: 12,
            display: 'flex',
            alignItems: 'center',
            gap: 10,
          }}
        >
          <div
            style={{
              width: 36,
              height: 36,
              borderRadius: '50%',
              background: SOFT,
              border: `1.5px solid ${ACC}`,
              color: TX,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
              flex: 'none',
              boxSizing: 'border-box',
            }}
          >
            {s.me?.[0]?.toUpperCase() ?? ''}
          </div>
          <div style={{ minWidth: 0, flex: 1 }}>
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
                font: mono(400, 10),
                letterSpacing: '.04em',
                color: MUT,
                background: 'none',
                border: 'none',
                padding: 0,
                cursor: 'pointer',
                textDecoration: 'underline',
              }}
            >
              SIGN OUT
            </button>
          </div>
        </div>
      </aside>

      <main
        style={{
          padding: '24px 28px 56px',
          minWidth: 0,
          display: 'flex',
          flexDirection: 'column',
          gap: 18,
        }}
      >
        <header style={{ display: 'flex', alignItems: 'flex-end', gap: 14, flexWrap: 'wrap' }}>
          <div style={{ flex: 1, minWidth: 220 }}>
            <div style={{ font: mono(400, 11), letterSpacing: '.06em', color: MUT }}>
              {TITLES[scr][0]}
            </div>
            <div
              style={{
                fontFamily: DOTO,
                fontWeight: 900,
                fontSize: 40,
                letterSpacing: -1,
                lineHeight: 1.05,
                marginTop: 4,
              }}
            >
              {TITLES[scr][1]}
            </div>
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
            }}
          >
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke={MUT}
              strokeWidth="2.2"
              strokeLinecap="round"
            >
              <circle cx="11" cy="11" r="6.5" />
              <path d="M16 16l5 5" />
            </svg>
            <input
              placeholder="Search users — press Enter"
              value={s.globalQ}
              onChange={(e) => set({ globalQ: e.target.value })}
              onKeyDown={(e) => {
                if (e.key === 'Enter')
                  go('users', { userQ: s.globalQ, userF: 'All', searchSeq: s.searchSeq + 1 });
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
          {scr === 'overview' && (
            <div
              style={{
                display: 'flex',
                border: `1px solid ${LINE}`,
                borderRadius: 99,
                padding: 3,
                background: C1,
              }}
            >
              {(Object.keys(RANGES) as (keyof typeof RANGES)[]).map((k) => (
                <button
                  key={k}
                  type="button"
                  onClick={() => set({ range: k })}
                  style={{
                    whiteSpace: 'nowrap',
                    flex: 'none',
                    height: 36,
                    padding: '0 14px',
                    borderRadius: 99,
                    border: 'none',
                    background: s.range === k ? ACC : 'transparent',
                    color: s.range === k ? DK : TX,
                    font: mono(700, 12),
                    cursor: 'pointer',
                  }}
                >
                  {k}
                </button>
              ))}
            </div>
          )}
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
