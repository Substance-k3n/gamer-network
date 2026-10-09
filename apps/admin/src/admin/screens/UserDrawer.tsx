import type { Admin } from '../state';
import { btnPrimary, btnSecondary } from '../ui';
import {
  ACC,
  C1,
  DOTO,
  LINE,
  MUT,
  PANEL,
  RULE,
  SOFT,
  ST,
  TX,
  grot,
  label,
  mono,
  pad2,
  pill,
} from '../tokens';

export function UserDrawer({ admin }: { admin: Admin }) {
  const { s, set, toast, setUser } = admin;
  const u = s.users.find((x) => x.id === s.userSel);
  if (!u) return null;

  const history = s.history[u.id] ?? [];
  const [gameName, rank] = u.main.split(' · ');
  const wasReset = !!s.rankReset[u.id];
  const restricted = u.status === 'Suspended' || u.status === 'Banned';
  const close = () => set({ userSel: null });
  const stats = [
    { v: pad2(u.conn), l: 'CONNECTIONS' },
    { v: pad2(u.played), l: 'PLAYED WITH' },
    { v: pad2(u.reports), l: 'REPORTS' },
  ];
  const fill = { ...btnSecondary, flex: 1, padding: undefined };

  return (
    <>
      <div
        onClick={close}
        style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,.55)', zIndex: 40 }}
      />
      <div
        style={{
          position: 'fixed',
          top: 0,
          right: 0,
          bottom: 0,
          width: 400,
          maxWidth: '100%',
          zIndex: 41,
          background: PANEL,
          borderLeft: `1px solid ${LINE}`,
          padding: 22,
          boxSizing: 'border-box',
          overflowY: 'auto',
          display: 'flex',
          flexDirection: 'column',
          gap: 16,
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ font: mono(400, 11), color: MUT }}>PLAYER · JOINED {u.joined}</span>
          <button
            type="button"
            onClick={close}
            style={{
              width: 36,
              height: 36,
              borderRadius: '50%',
              border: `1px solid ${LINE}`,
              background: 'transparent',
              color: TX,
              fontSize: 18,
              cursor: 'pointer',
            }}
          >
            ×
          </button>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          <div
            style={{
              width: 64,
              height: 64,
              borderRadius: '50%',
              background: SOFT,
              border: `1.5px solid ${ACC}`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
              fontSize: 26,
              flex: 'none',
              boxSizing: 'border-box',
            }}
          >
            {u.name[0]}
          </div>
          <div style={{ minWidth: 0 }}>
            <div style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 28, lineHeight: 1 }}>
              {u.name}
            </div>
            <div style={{ fontSize: 14, color: MUT, marginTop: 4 }}>
              @{u.handle} · {u.city}
            </div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          <span style={pill(ST[u.status].bg, ST[u.status].fg, '4px 10px')}>
            {u.status.toUpperCase()}
          </span>
          <span style={{ fontSize: 13, color: MUT }}>Last active {u.last}</span>
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 8 }}>
          {stats.map((k) => (
            <div key={k.l} style={{ border: `1px solid ${LINE}`, borderRadius: 14, padding: 10 }}>
              <div style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 24 }}>{k.v}</div>
              <div style={{ ...label, marginTop: 2 }}>{k.l}</div>
            </div>
          ))}
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <span style={label}>GAMES · SELF-REPORTED RANKS</span>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 10,
              border: `1px solid ${LINE}`,
              background: C1,
              borderRadius: 14,
              padding: '10px 12px',
            }}
          >
            <span style={{ flex: 1, fontWeight: 600, fontSize: 14 }}>{gameName}</span>
            <span style={{ font: mono(700, 12) }}>{wasReset ? 'Unranked' : rank}</span>
            <button
              type="button"
              onClick={() => {
                if (wasReset) return;
                set((st) => ({ rankReset: { ...st.rankReset, [u.id]: true } }));
                toast(`Rank reset — ${u.name} must re-enter it`);
              }}
              style={{
                height: 28,
                padding: '0 10px',
                borderRadius: 99,
                border: `1px solid ${LINE}`,
                background: 'transparent',
                color: MUT,
                font: grot(600, 12),
                cursor: 'pointer',
              }}
            >
              {wasReset ? 'Reset' : 'Reset rank'}
            </button>
          </div>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <span style={label}>MODERATION HISTORY</span>
          {history.map((h, i) => (
            <div
              key={i}
              style={{
                display: 'flex',
                gap: 10,
                fontSize: 13,
                padding: '6px 0',
                borderTop: `1px solid ${RULE}`,
              }}
            >
              <span style={{ font: mono(400, 11), color: MUT, width: 62, flex: 'none' }}>
                {h.t}
              </span>
              <span>{h.text}</span>
            </div>
          ))}
          {!history.length && <div style={{ fontSize: 13, color: MUT }}>Clean record.</div>}
        </div>
        <div style={{ flex: 1 }} />
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {restricted ? (
            <button
              type="button"
              onClick={() => {
                setUser(u.id, 'Active', 'Account restored');
                toast(`${u.name} restored`);
              }}
              style={{ ...btnPrimary, flex: 1, padding: undefined }}
            >
              Restore account
            </button>
          ) : (
            <>
              <button
                type="button"
                onClick={() => {
                  setUser(u.id, 'Warned', 'Warned by admin');
                  toast(`${u.name} warned`);
                }}
                style={fill}
              >
                Warn
              </button>
              <button
                type="button"
                onClick={() => {
                  setUser(u.id, 'Suspended', 'Suspended 7d by admin');
                  toast(`${u.name} suspended for 7 days`);
                }}
                style={fill}
              >
                Suspend 7d
              </button>
              <button
                type="button"
                onClick={() => {
                  setUser(u.id, 'Banned', 'Banned by admin');
                  toast(`${u.name} banned`);
                }}
                style={{ ...btnPrimary, flex: 1, padding: undefined }}
              >
                Ban
              </button>
            </>
          )}
        </div>
      </div>
    </>
  );
}
