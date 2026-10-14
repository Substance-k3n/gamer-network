'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, type ConnectionRequest, type Notification, type Page } from '../_lib/api';
import { ago, rankLine, toneFor } from '../_lib/data';
import { Header } from '../_lib/shell';
import { useApp, useLoad } from '../_lib/store';
import { Avatar, BackBtn, Card, EmptyNote, Label, Pill, Rows } from '../_lib/ui';

/** Alerts: connection requests to answer, then activity. Opening marks it read. */
export default function Alerts() {
  const { run, toast, setUnread } = useApp();
  const router = useRouter();
  const [more, setMore] = useState<string | null>(null);
  const reqs = useLoad(
    async () =>
      (await api<{ items: ConnectionRequest[] }>('connection-requests?direction=incoming')).items,
    [],
  );
  const notes = useLoad(async () => {
    const p = await api<Page<Notification>>('notifications');
    setMore(p.nextCursor);
    if (p.items.some((n) => !n.readAt)) {
      await api('notifications/read', { method: 'POST', body: { all: true } });
      setUnread(0);
    }
    return p.items;
  }, []);

  const answer = async (r: ConnectionRequest, accept: boolean) => {
    const ok = await run(() =>
      api(`connection-requests/${r.id}/${accept ? 'accept' : 'decline'}`, { method: 'POST' }).then(
        () => true,
      ),
    );
    if (!ok) return;
    reqs.setData((reqs.data ?? []).filter((x) => x.id !== r.id));
    toast(accept ? `Connected with ${r.from.displayName}` : 'Request hidden');
  };
  const loadMore = async () => {
    const p = await run(
      () => api<Page<Notification>>(`notifications?cursor=${encodeURIComponent(more!)}`),
      { busy: false },
    );
    if (!p) return;
    notes.setData([...(notes.data ?? []), ...p.items]);
    setMore(p.nextCursor);
  };
  /** Follows a notification's route (docs/API.md "Push"). */
  const open = (route: string) => {
    const [kind, id] = route.split('/').filter(Boolean);
    if (kind === 'players' && id) router.push(`/app/players/${id}`);
    else if (kind === 'listings' && id) router.push(`/app/listings/${id}`);
    else if (kind === 'check-ins') router.push('/app');
  };

  const list = reqs.data ?? [];
  return (
    <>
      <Header title="Alerts" back={<BackBtn href="/app" size={40} />} />
      <div className="gap rl-pad" style={{ gap: 12 }}>
        <div className="row" style={{ gap: 8, paddingLeft: 6 }}>
          <Label>CONNECTION REQUESTS</Label>
          <span
            className="digits"
            style={{
              fontSize: 10,
              background: 'var(--accent)',
              color: 'var(--on-accent)',
              border: '1.5px solid var(--line)',
              borderRadius: 6,
              padding: '2px 5px',
            }}
          >
            {list.length}
          </span>
        </div>
        {reqs.loaded && list.length === 0 && <EmptyNote pad={18}>You’re all caught up.</EmptyNote>}
        {list.map((r) => (
          <Card key={r.id} pad={12} radius={22}>
            <div className="gap" style={{ gap: 10 }}>
              <div className="row" style={{ gap: 10 }}>
                <Avatar
                  name={r.from.displayName}
                  tone={toneFor(r.from.id)}
                  url={r.from.avatarUrl}
                  size={44}
                  onClick={() => router.push(`/app/players/${r.from.username}`)}
                />
                <div className="grow">
                  <div style={{ fontSize: 15 }}>
                    <b>{r.from.displayName}</b>{' '}
                    {r.listing
                      ? `wants to join your ${r.listing.game.name} listing`
                      : 'wants to connect'}
                  </div>
                  <div className="muted" style={{ fontSize: 12 }}>
                    {[rankLine(r.from.topGame), r.from.city].filter(Boolean).join(' · ')}
                  </div>
                  {r.message && <div style={{ fontSize: 13, lineHeight: 1.3 }}>“{r.message}”</div>}
                </div>
              </div>
              <div className="row" style={{ gap: 8 }}>
                <Pill h={40} size={14} bold expand look="strong" onClick={() => answer(r, true)}>
                  Accept
                </Pill>
                <Pill h={40} size={14} expand look="clear" onClick={() => answer(r, false)}>
                  Not now
                </Pill>
              </div>
            </div>
          </Card>
        ))}
        <Label style={{ paddingLeft: 6, marginTop: 4 }}>ACTIVITY</Label>
        {notes.loaded && !notes.data?.length && (
          <EmptyNote pad={18}>Requests, accepts and invites show up here.</EmptyNote>
        )}
        {!!notes.data?.length && (
          <Rows>
            {notes.data.map((n) => (
              <button
                key={n.id}
                type="button"
                className="r"
                onClick={() => open(n.route)}
                style={{ padding: '12px 14px' }}
              >
                {n.actor ? (
                  <Avatar
                    name={n.actor.displayName}
                    tone={toneFor(n.actor.id)}
                    url={n.actor.avatarUrl}
                    size={34}
                  />
                ) : (
                  <span
                    className="row"
                    style={{
                      width: 34,
                      height: 34,
                      borderRadius: 10,
                      justifyContent: 'center',
                      background: 'var(--soft)',
                      border: '2px solid var(--line)',
                    }}
                  >
                    <Label>!</Label>
                  </span>
                )}
                <span
                  className="grow"
                  style={{ fontSize: 14, lineHeight: 1.3, fontWeight: n.readAt ? 500 : 700 }}
                >
                  {n.text}
                </span>
                <span className="digits muted" style={{ fontSize: 9 }}>
                  {ago(n.createdAt)}
                </span>
              </button>
            ))}
          </Rows>
        )}
        {more && (
          <div style={{ textAlign: 'center' }}>
            <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
              Load more
            </Pill>
          </div>
        )}
      </div>
    </>
  );
}
