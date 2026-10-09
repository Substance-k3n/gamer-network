import type { Admin } from '../state';
import { Chip } from '../ui';
import { ACC, C1, DOTO, LINE, MUT, PINK, RULE, ST, TX, fmt, mono, pad2, pill } from '../tokens';

const COLS = 'minmax(200px,2fr) 1.1fr 1.4fr 0.9fr 0.7fr 0.9fr';
const FILTERS = ['All', 'Flagged', 'Active', 'Warned', 'Suspended', 'Banned'];

export function Users({ admin }: { admin: Admin }) {
  const { s, set } = admin;
  const q = s.userQ.trim().toLowerCase();
  const rows = s.users.filter(
    (u) =>
      (s.userF === 'All' || (s.userF === 'Flagged' ? u.reports > 0 : u.status === s.userF)) &&
      (!q || `${u.name} ${u.handle} ${u.city} ${u.main}`.toLowerCase().includes(q)),
  );
  const cnt = (st: string) => s.users.filter((u) => u.status === st).length;
  const total = s.users.length * 1450 + 16580;
  const stats = [
    { label: 'TOTAL PLAYERS', value: fmt(total), fg: TX },
    { label: 'ACTIVE TODAY', value: fmt(4910), fg: TX },
    { label: 'WARNED', value: pad2(cnt('Warned')), fg: PINK },
    { label: 'SUSPENDED / BANNED', value: pad2(cnt('Suspended') + cnt('Banned')), fg: ACC },
  ];

  return (
    <>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(160px,1fr))',
          gap: 12,
        }}
      >
        {stats.map((k) => (
          <div
            key={k.label}
            style={{
              background: C1,
              border: `1px solid ${LINE}`,
              borderRadius: 20,
              padding: '14px 16px',
            }}
          >
            <div style={{ font: mono(400, 11), color: MUT }}>{k.label}</div>
            <div
              style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 30, marginTop: 6, color: k.fg }}
            >
              {k.value}
            </div>
          </div>
        ))}
      </div>

      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {FILTERS.map((f) => (
          <Chip key={f} on={s.userF === f} onClick={() => set({ userF: f })}>
            {f}
          </Chip>
        ))}
        <span style={{ flex: 1 }} />
        <input
          placeholder="Filter by name, handle, city…"
          value={s.userQ}
          onChange={(e) => set({ userQ: e.target.value })}
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
            <span>REPORTS</span>
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
                  {u.name[0]}
                </div>
                <div style={{ minWidth: 0 }}>
                  <div style={{ fontWeight: 600, fontSize: 14 }}>{u.name}</div>
                  <div style={{ fontSize: 12, color: MUT }}>@{u.handle}</div>
                </div>
              </div>
              <span style={{ fontSize: 14 }}>{u.city}</span>
              <span style={{ fontSize: 14 }}>{u.main}</span>
              <span style={{ font: mono(400, 12) }}>{u.joined}</span>
              <span
                style={{
                  font: mono(700, 12),
                  color: u.reports >= 3 ? ACC : u.reports ? PINK : MUT,
                }}
              >
                {pad2(u.reports)}
              </span>
              <span
                style={{
                  ...pill(ST[u.status].bg, ST[u.status].fg, '4px 9px'),
                  justifySelf: 'start',
                }}
              >
                {u.status.toUpperCase()}
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
    </>
  );
}
