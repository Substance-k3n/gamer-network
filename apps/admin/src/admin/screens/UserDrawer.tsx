import { useEffect, useState } from 'react';
import { api, type AdminUser } from '../api';
import { lastSeen, shortDate, STATE_LABEL } from '../data';
import type { Admin } from '../state';
import { ConfirmModal, btnDanger, btnSecondary } from '../ui';
import {
  ACC,
  C1,
  DANGER,
  DOTO,
  LINE,
  MUT,
  PANEL,
  SOFT,
  ST,
  SUNK,
  TX,
  label,
  mono,
  pad2,
  pill,
} from '../tokens';

export function UserDrawer({ admin }: { admin: Admin }) {
  const { s, set, toast, fail, changed } = admin;
  const [u, setU] = useState<AdminUser | null>(null);
  const [reason, setReason] = useState('');
  const [busy, setBusy] = useState(false);
  const [askBan, setAskBan] = useState(false);

  // Keyed by the user id (AdminDashboard), so state starts fresh per user.
  useEffect(() => {
    if (s.userSel) api<AdminUser>(`admin/users/${s.userSel}`).then(setU).catch(fail);
  }, [s.userSel, fail]);

  if (!s.userSel) return null;
  const close = () => set({ userSel: null });

  /** Banning asks first; the reason is required before the question. */
  const askToBan = () => {
    if (!reason.trim()) {
      toast('Write why first. Only admins see it.');
      return;
    }
    setAskBan(true);
  };

  const act = async (kind: 'ban' | 'unban') => {
    if (!u) return;
    const note = reason.trim();
    if (kind === 'ban' && !note) {
      toast('Write why first. Only admins see it.');
      return;
    }
    setBusy(true);
    try {
      const next = await api<AdminUser>(`admin/users/${u.id}/${kind}`, {
        method: 'POST',
        body: kind === 'ban' ? { reason: note } : note ? { note } : {},
      });
      setU(next);
      setReason('');
      changed();
      toast(
        kind === 'ban' ? `${u.displayName} banned and signed out` : `${u.displayName} restored`,
      );
    } catch (e) {
      fail(e);
    } finally {
      setBusy(false);
    }
  };

  const stats = u
    ? [
        { v: pad2(u.connections), l: 'Connections' },
        { v: pad2(u.playedWith), l: 'Played with' },
        { v: pad2(u.openReports), l: 'Open reports' },
        { v: pad2(u.postsCount), l: 'Posts' },
        { v: pad2(u.groupsCount), l: 'Groups' },
      ]
    : [];

  return (
    <>
      <div
        onClick={close}
        style={{ position: 'fixed', inset: 0, background: 'var(--scrim)', zIndex: 40 }}
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
          <span style={{ font: mono(700, 12), color: MUT }}>
            Player{u ? ` · joined ${shortDate(u.createdAt)}` : ''}
          </span>
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
        {!u ? (
          <div style={{ color: MUT, fontSize: 14 }}>Loading…</div>
        ) : (
          <>
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
                {u.displayName[0]?.toUpperCase()}
              </div>
              <div style={{ minWidth: 0 }}>
                <div style={{ fontFamily: DOTO, fontWeight: 800, fontSize: 28, lineHeight: 1 }}>
                  {u.displayName}
                </div>
                <div style={{ fontSize: 14, color: MUT, marginTop: 4 }}>
                  @{u.username} · {u.city}
                </div>
              </div>
            </div>
            <div style={{ display: 'flex', gap: 8, alignItems: 'center', flexWrap: 'wrap' }}>
              <span style={pill(ST[u.state].bg, ST[u.state].fg, '4px 10px')}>
                {STATE_LABEL[u.state]}
              </span>
              <span style={{ fontSize: 13, color: MUT }}>Last active {lastSeen(u)}</span>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 8 }}>
              {stats.map((k) => (
                <div
                  key={k.l}
                  style={{ border: `1px solid ${LINE}`, borderRadius: 14, padding: 10 }}
                >
                  <div style={{ fontFamily: DOTO, fontWeight: 800, fontSize: 24 }}>{k.v}</div>
                  <div style={{ ...label, marginTop: 2 }}>{k.l}</div>
                </div>
              ))}
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <span style={label}>Account</span>
              <div
                style={{
                  border: `1px solid ${LINE}`,
                  background: C1,
                  borderRadius: 14,
                  padding: '10px 12px',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 6,
                  fontSize: 14,
                }}
              >
                <span style={{ overflowWrap: 'anywhere' }}>{u.email}</span>
                <span style={{ color: MUT }}>
                  Main game: {u.mainGame ?? '—'} · {u.onboarded ? 'Profile live' : 'Not onboarded'}
                </span>
                {u.banReason && (
                  <span style={{ color: DANGER, fontWeight: 600 }}>Banned: {u.banReason}</span>
                )}
              </div>
            </div>
            <div style={{ flex: 1 }} />
            {u.state !== 'deleted' && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                <span style={label}>
                  {u.state === 'banned' ? 'Note (optional)' : 'Why · admins only'}
                </span>
                <textarea
                  rows={2}
                  maxLength={500}
                  value={reason}
                  onChange={(e) => setReason(e.target.value)}
                  placeholder={
                    u.state === 'banned' ? 'Why they get another chance' : 'Keep it factual'
                  }
                  style={{
                    border: `1px solid ${LINE}`,
                    borderRadius: 14,
                    background: SUNK,
                    color: TX,
                    padding: '10px 12px',
                    fontSize: 14,
                    outline: 'none',
                    resize: 'vertical',
                  }}
                />
                {u.state === 'banned' ? (
                  <button
                    type="button"
                    disabled={busy}
                    onClick={() => act('unban')}
                    style={{ ...btnSecondary, width: '100%' }}
                  >
                    Restore account
                  </button>
                ) : (
                  <button
                    type="button"
                    disabled={busy}
                    onClick={askToBan}
                    style={{ ...btnDanger, width: '100%' }}
                  >
                    Ban, signs them out everywhere
                  </button>
                )}
              </div>
            )}
          </>
        )}
      </div>
      {askBan && u && (
        <ConfirmModal
          title={`Ban ${u.displayName}?`}
          body="They are signed out everywhere now and can't sign in until restored. Your reason is kept for admins."
          confirm="Ban player"
          onConfirm={() => {
            setAskBan(false);
            act('ban');
          }}
          onClose={() => setAskBan(false)}
        />
      )}
    </>
  );
}
