'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { api, type UserCard } from '../_lib/api';
import { gameMatches, rankLine, statusLook, toneFor } from '../_lib/data';
import { useApp } from '../_lib/store';
import { Avatar, BackBtn, Dot, EmptyNote, Field, Label, Rows, toneColor } from '../_lib/ui';

/** Search: gamers by name or username (≥ 2 letters), and launch games. */
export default function Search() {
  const { games } = useApp();
  const [q, setQ] = useState('');
  const [found, setFound] = useState<UserCard[]>([]);
  const ql = q.trim();
  useEffect(() => {
    if (ql.length < 2) return;
    const t = setTimeout(async () => {
      try {
        setFound((await api<{ items: UserCard[] }>(`users?query=${encodeURIComponent(ql)}`)).items);
      } catch {
        setFound([]);
      }
    }, 300);
    return () => clearTimeout(t);
  }, [ql]);
  // Results stay hidden while the query is too short to search.
  const shown = ql.length >= 2 ? found : [];
  const launch = games.filter((g) => g.isLaunch && gameMatches(g, ql)).slice(0, 4);

  return (
    <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6, paddingBottom: 40 }}>
      <div className="row" style={{ gap: 8 }}>
        <BackBtn />
        <div className="grow">
          <Field
            value={q}
            onChange={setQ}
            placeholder="Gamers by name or username"
            h={48}
            autoFocus
            style={{ fontSize: 16 }}
            aria-label="Search gamers"
          />
        </div>
      </div>
      {shown.length > 0 && (
        <>
          <Label style={{ paddingLeft: 6 }}>GAMERS</Label>
          <Rows>
            {shown.map((u) => {
              const [status, tone] = statusLook(u.status, u.statusGame);
              return (
                <Link key={u.id} href={`/app/players/${u.username}`} className="r">
                  <Avatar name={u.displayName} tone={toneFor(u.id)} url={u.avatarUrl} />
                  <span className="grow">
                    <b style={{ display: 'block', fontSize: 15 }}>{u.displayName}</b>
                    <span className="muted ellipsis" style={{ display: 'block', fontSize: 12 }}>
                      {[`@${u.username}`, rankLine(u.topGame), status].filter(Boolean).join(' · ')}
                    </span>
                  </span>
                  <Dot color={toneColor(tone)} />
                </Link>
              );
            })}
          </Rows>
        </>
      )}
      {launch.length > 0 && (
        <>
          <Label style={{ paddingLeft: 6 }}>FIND PLAYERS FOR</Label>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            {launch.map((g) => (
              <Link
                key={g.id}
                href="/app/find"
                className="card dark"
                style={{ padding: 12, borderRadius: 20 }}
              >
                <div style={{ fontSize: 20, fontWeight: 800 }}>{g.shortCode}</div>
                <div style={{ fontSize: 12, opacity: 0.85 }}>{g.name}</div>
                <div
                  style={{
                    fontSize: 12,
                    fontWeight: 700,
                    color: 'var(--accent-text)',
                    marginTop: 8,
                  }}
                >
                  Find players →
                </div>
              </Link>
            ))}
          </div>
        </>
      )}
      {ql.length >= 2 && shown.length === 0 && launch.length === 0 && (
        <EmptyNote>No gamers called “{ql}” yet.</EmptyNote>
      )}
    </div>
  );
}
