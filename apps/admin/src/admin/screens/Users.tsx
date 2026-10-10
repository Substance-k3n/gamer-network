import { useEffect, useState } from 'react';
import { api, query, type AccountState, type AdminUser, type Page } from '../api';
import { shortDate, STATE_LABEL } from '../data';
import type { Admin, UserFilter } from '../state';
import { Chip, btnSecondary } from '../ui';
import { ACC, C1, LINE, MUT, PINK, RULE, ST, TX, mono, pad2, pill } from '../tokens';

const COLS = 'minmax(200px,2fr) 1.1fr 1.4fr 0.9fr 0.7fr 0.9fr';
const FILTERS: UserFilter[] = ['All', 'Active', 'Banned', 'Deleted'];

function usersPath(q: string, f: UserFilter, cursor?: string) {
  const state = f === 'All' ? undefined : (f.toLowerCase() as AccountState);
  return `admin/users${query({ query: q.trim(), state, limit: 50, cursor })}`;
}

export function Users({ admin }: { admin: Admin }) {
  const { s, set, fail } = admin;
  const [rows, setRows] = useState<AdminUser[]>([]);
  const [more, setMore] = useState<string | null>(null);
  const [q, setQ] = useState(s.userQ);

  // Search as you type, a beat after the last key.
  useEffect(() => {
    const t = setTimeout(() => set({ userQ: q }), 250);
    return () => clearTimeout(t);
  }, [q, set]);

  useEffect(() => {
    api<Page<AdminUser>>(usersPath(s.userQ, s.userF))
      .then((p) => {
        setRows(p.items);
        setMore(p.nextCursor);
      })
      .catch(fail);
  }, [s.userQ, s.userF, fail]);

  const loadMore = () =>
    more &&
    api<Page<AdminUser>>(usersPath(s.userQ, s.userF, more))
      .then((p) => {
        setRows((r) => [...r, ...p.items]);
        setMore(p.nextCursor);
      })
      .catch(fail);

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {FILTERS.map((f) => (
          <Chip key={f} on={s.userF === f} onClick={() => set({ userF: f })}>
            {f}
          </Chip>
        ))}
        <span style={{ flex: 1 }} />
        <input
          placeholder="Username, name or email…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          style={{
            height: 38,
            width: 260,
            maxWidth: '100%',
            borderRadius: 99,
            border: `1px solid ${LINE}`,
            background: C1,
            color: TX,
            padding: '0 16px',
            fontSize: 14,
            outline: 'none',
            boxSizing: 'border-box',
          }}
        />
      </div>

      <div
        style={{ background: C1, border: `1px solid ${LINE}`, borderRadius: 24, overflowX: 'auto' }}
      >
        <div style={{ minWidth: 780 }}>
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: COLS,
              gap: 12,
              padding: '12px 18px',
              font: mono(400, 11),
              letterSpacing: '.04em',
              color: MUT,
              borderBottom: `1px solid ${LINE}`,
            }}
          >
            <span>PLAYER</span>
            <span>CITY</span>
            <span>MAIN GAME</span>
            <span>JOINED</span>
            <span>OPEN REPORTS</span>
            <span>STATUS</span>
          </div>
          {rows.map((u, i) => (
            <div
              key={u.id}
              onClick={() => set({ userSel: u.id })}
              style={{
                display: 'grid',
                gridTemplateColumns: COLS,
                gap: 12,
                padding: '10px 18px',
                alignItems: 'center',
                borderTop: i ? `1px solid ${RULE}` : 'none',
                cursor: 'pointer',
                background: s.userSel === u.id ? '#232323' : 'transparent',
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 10, minWidth: 0 }}>
                <div
                  style={{
                    width: 34,
                    height: 34,
                    borderRadius: '50%',
                    background: '#232323',
                    border: '1px solid #3A3A3A',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontWeight: 700,
                    flex: 'none',
                  }}
                >
                  {u.displayName[0]?.toUpperCase()}
                </div>
                <div style={{ minWidth: 0 }}>
                  <div style={{ fontWeight: 600, fontSize: 14 }}>{u.displayName}</div>
                  <div style={{ fontSize: 12, color: MUT }}>@{u.username}</div>
                </div>
              </div>
              <span style={{ fontSize: 14 }}>{u.city}</span>
              <span style={{ fontSize: 14 }}>{u.mainGame ?? '—'}</span>
              <span style={{ font: mono(400, 12) }}>{shortDate(u.createdAt)}</span>
              <span
                style={{
                  font: mono(700, 12),
                  color: u.openReports >= 3 ? ACC : u.openReports ? PINK : MUT,
                }}
              >
                {pad2(u.openReports)}
              </span>
              <span
                style={{
                  ...pill(ST[u.state].bg, ST[u.state].fg, '4px 9px'),
                  justifySelf: 'start',
                }}
              >
                {STATE_LABEL[u.state].toUpperCase()}
              </span>
            </div>
          ))}
          {!rows.length && (
            <div style={{ padding: 36, textAlign: 'center', color: MUT, fontSize: 14 }}>
              No players match.
            </div>
          )}
        </div>
      </div>
      {more && (
        <button type="button" onClick={loadMore} style={{ ...btnSecondary, alignSelf: 'center' }}>
          Load more
        </button>
      )}
    </>
  );
}
