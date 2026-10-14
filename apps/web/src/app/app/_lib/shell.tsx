'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useEffect, type ReactNode } from 'react';
import { InviteSheet, ListingSheet } from './sheets';
import { AppProvider, mayShow, skins, useApp } from './store';
import { Icon, Logo, Pill, Toast, Wordmark, type IconName } from './ui';

const tabs: [string, IconName, string][] = [
  ['/app', 'home', 'HOME'],
  ['/app/find', 'target', 'PLAYERS'],
  ['/app/groups', 'groups', 'GROUPS'],
  ['/app/you', 'user', 'YOU'],
];
const withNav = ['/app', '/app/find', '/app/groups', '/app/you', '/app/alerts'];

export function Shell({ children }: { children: ReactNode }) {
  return (
    <AppProvider>
      <Frame>{children}</Frame>
    </AppProvider>
  );
}

function Frame({ children }: { children: ReactNode }) {
  const { skin, ready, waking, offline, boot, sheet, setSheet, me } = useApp();
  const path = usePathname();

  useEffect(() => {
    if ('serviceWorker' in navigator && process.env.NODE_ENV === 'production') {
      navigator.serviceWorker.register('/sw.js').catch(() => undefined);
    }
  }, []);
  // The browser chrome follows the skin.
  useEffect(() => {
    const bg = skins.find((s) => s.id === skin)!.bg;
    document.querySelector('meta[name="theme-color"]')?.setAttribute('content', bg);
    document.body.style.background = bg;
    return () => {
      document.body.style.background = '';
    };
  }, [skin]);

  const nav = ready && me?.onboardedAt && withNav.includes(path);
  return (
    <div className="rl" data-skin={skin}>
      <div className={`rl-page ${nav ? '' : 'bare'}`}>
        {ready && mayShow(path, me) ? (
          children
        ) : ready ? null : (
          <div
            className="gap"
            style={{
              minHeight: '100dvh',
              alignItems: 'center',
              justifyContent: 'center',
              padding: 32,
              gap: 18,
              textAlign: 'center',
            }}
          >
            <Logo size={96} />
            <Wordmark size={30} logo={false} />
            {offline ? (
              <>
                <div style={{ fontWeight: 700, fontSize: 16 }}>Can’t reach rally right now.</div>
                <div className="muted" style={{ fontSize: 14 }}>
                  Check your connection and try again.
                </div>
                <Pill h={44} padH={20} size={15} bold shadow={3} onClick={boot}>
                  Try again
                </Pill>
              </>
            ) : waking ? (
              <div className="muted" style={{ fontSize: 14 }}>
                Waking up rally… this can take up to a minute.
              </div>
            ) : null}
          </div>
        )}
      </div>
      {nav && (
        <>
          {path === '/app/find' && (
            <div className="fab">
              <Pill
                h={52}
                padH={20}
                size={15}
                bold
                look="accent"
                shadow={4}
                onClick={() => setSheet({ kind: 'listing' })}
              >
                <span style={{ fontSize: 22, lineHeight: 1 }}>+</span> Post a listing
              </Pill>
            </div>
          )}
          <nav className="rl-nav" aria-label="Main">
            {tabs.map(([href, icon, label]) => (
              <Link
                key={href}
                href={href}
                className={path === href ? 'on' : ''}
                aria-current={path === href ? 'page' : undefined}
              >
                <span>
                  <Icon name={icon} />
                </span>
                <span>{label}</span>
              </Link>
            ))}
          </nav>
        </>
      )}
      {sheet?.kind === 'listing' && <ListingSheet onClose={() => setSheet(null)} />}
      {sheet?.kind === 'invite' && <InviteSheet sheet={sheet} onClose={() => setSheet(null)} />}
      <Toast />
    </div>
  );
}

/** Title row for Find, Groups and Alerts, with search. */
export function Header({ title, sub, back }: { title: string; sub?: string; back?: ReactNode }) {
  return (
    <div className="rl-header">
      {back}
      <div className="row grow" style={{ gap: 10 }}>
        <h1
          className="ellipsis"
          style={{ margin: 0, fontSize: 28, fontWeight: 800, letterSpacing: -1 }}
        >
          {title}
        </h1>
        {sub && <span className="label">{sub}</span>}
      </div>
      <Link
        href="/app/search"
        className="circle"
        style={{ width: 44, height: 44, boxShadow: 'var(--sh3)' }}
        aria-label="Search"
      >
        <Icon name="search" />
      </Link>
    </div>
  );
}
