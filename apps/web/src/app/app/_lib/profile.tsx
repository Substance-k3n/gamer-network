'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useRef, useState } from 'react';
import { api, type Connection, type Me, type Page, type Profile, type UserGame } from './api';
import { idKindLabel, pad2, platformLabel, rankLine, statusLook, tagLabel, toneFor } from './data';
import { PlayerMenu } from './safety';
import { skins, useApp, useLoad, type Skin } from './store';
import {
  Avatar,
  BackBtn,
  Card,
  Chip,
  CircleBtn,
  Dialog,
  Dot,
  EmptyNote,
  Icon,
  Label,
  PasswordField,
  Pill,
  Rows,
  toneColor,
  useConfirm,
  Wordmark,
} from './ui';

type View = Profile & { isMe: boolean };

/** Your profile (me) or someone else's: the gamer ID, tabs, and actions. */
export function ProfileView({ p, onReload }: { p: View; onReload: () => void }) {
  const { me, setSheet, run, busy, toast, bump } = useApp();
  const router = useRouter();
  const [tab, setTab] = useState('Overview');
  const [menu, setMenu] = useState(false);
  const [ask, confirm] = useConfirm();
  const tabs = p.isMe ? ['Overview', 'Games', 'Connections'] : ['Overview', 'Games'];

  const connect = async () => {
    if (p.relationship === 'none') {
      const r = await run(() =>
        api('connection-requests', {
          method: 'POST',
          key: crypto.randomUUID(),
          body: { toUserId: p.id },
        }),
      );
      if (r !== null) toast(`Request sent to ${p.displayName}`);
    } else if (p.relationship === 'incoming_request' && p.incomingRequestId) {
      const r = await run(() =>
        api(`connection-requests/${p.incomingRequestId}/accept`, { method: 'POST' }),
      );
      if (r !== null) toast(`Connected with ${p.displayName}`);
    } else if (p.relationship === 'outgoing_request') {
      if (
        !(await ask(
          'Withdraw your request?',
          `${p.displayName} won’t see it any more. You can ask again later.`,
          'Withdraw',
          'Keep it',
        ))
      )
        return;
      const ok = await run(async () => {
        if (p.outgoingRequestId)
          await api(`connection-requests/${p.outgoingRequestId}`, { method: 'DELETE' });
        return true;
      });
      if (ok) toast(`Request to ${p.displayName} withdrawn`);
    }
    onReload();
  };
  const look =
    p.relationship === 'connected'
      ? { label: 'Connected ✓', cls: 'strong' as const }
      : p.relationship === 'outgoing_request'
        ? { label: 'Requested…', cls: 'quiet' as const }
        : p.relationship === 'incoming_request'
          ? { label: 'Accept request', cls: 'accent' as const }
          : { label: 'Connect', cls: 'accent' as const };

  return (
    <div style={{ paddingBottom: 20 }}>
      <IdCard p={p} />
      <div className="row rl-pad" style={{ gap: 8, marginTop: 14 }}>
        {p.isMe ? (
          <>
            <Link
              href="/app/you/edit"
              className="pill expand"
              style={{ height: 46, fontSize: 15, fontWeight: 700, boxShadow: 'var(--sh3)' }}
            >
              Edit profile
            </Link>
            <Pill
              h={46}
              size={15}
              bold
              expand
              look="accent"
              shadow={3}
              onClick={() => setSheet({ kind: 'listing' })}
            >
              Find players
            </Pill>
          </>
        ) : (
          <>
            <Pill
              h={46}
              size={15}
              bold
              expand
              look={look.cls}
              shadow={3}
              onClick={p.relationship === 'connected' ? undefined : connect}
              disabled={busy || p.relationship === 'connected'}
            >
              {look.label}
            </Pill>
            {p.relationship === 'connected' && (
              <Pill
                h={46}
                size={15}
                bold
                expand
                look="accent"
                shadow={3}
                onClick={() =>
                  setSheet({
                    kind: 'invite',
                    userId: p.id,
                    name: p.displayName,
                    games: p.games.map((g) => g.game?.id).filter((x): x is string => !!x),
                  })
                }
              >
                Play together
              </Pill>
            )}
            <CircleBtn
              size={46}
              shadow={3}
              onClick={() => setMenu(true)}
              label={`More for ${p.displayName}`}
            >
              <Icon name="more" />
            </CircleBtn>
          </>
        )}
      </div>
      <div className="scroller" style={{ padding: '16px 16px 4px' }}>
        {tabs.map((t) => (
          <Chip key={t} on={tab === t} onClick={() => setTab(t)} h={36} padH={14} size={14}>
            {t}
          </Chip>
        ))}
      </div>
      <div className="gap rl-pad" style={{ gap: 12, marginTop: 10 }}>
        {(tab === 'Overview' || tab === 'Games') &&
          (p.games.length ? (
            p.games.map((g) => <GameRow key={g.id} g={g} />)
          ) : (
            <EmptyNote>No games on this profile yet.</EmptyNote>
          ))}
        {tab === 'Overview' && <Overview p={p} />}
        {tab === 'Overview' && p.isMe && (
          <>
            <ThemePicker />
            <Settings me={me!} />
          </>
        )}
        {tab === 'Connections' && <Connections />}
      </div>
      {menu && (
        <PlayerMenu
          userId={p.id}
          name={p.displayName}
          connected={p.relationship === 'connected'}
          onClose={() => setMenu(false)}
          onDone={(what) => {
            bump();
            // They're hidden from you now: their profile would 404.
            if (what === 'blocked') router.replace('/app');
            else onReload();
          }}
        />
      )}
      {confirm}
    </div>
  );
}

function IdCard({ p }: { p: View }) {
  const { setMe, run, toast, me } = useApp();
  const router = useRouter();
  const file = useRef<HTMLInputElement>(null);
  const [status, tone] = statusLook(p.status, p.statusGame);
  const order = ['looking', 'playing', 'available_tonight', 'not_available'] as const;

  const cycle = async () => {
    if (!p.isMe) return;
    const next = order[(order.indexOf(p.status as (typeof order)[number]) + 1) % order.length]!;
    const m = await run(
      () =>
        api<Me>('me/status', {
          method: 'PUT',
          body: {
            status: next,
            gameId: next === 'not_available' ? undefined : (me?.games[0]?.game?.id ?? undefined),
          },
        }),
      { busy: false },
    );
    if (m) setMe(m);
  };
  const upload = async (f: File | undefined) => {
    if (!f) return;
    const m = await run(async () => {
      const blob = await shrink(f);
      const u = await api<{ uploadUrl: string; headers: Record<string, string>; key: string }>(
        'me/avatar/upload-url',
        { method: 'POST', body: { contentType: 'image/jpeg', size: blob.size } },
      );
      const put = await fetch(u.uploadUrl, { method: 'PUT', headers: u.headers, body: blob });
      if (!put.ok) throw new Error('upload');
      return api<Me>('me/avatar', { method: 'PUT', body: { key: u.key } });
    });
    if (m) {
      setMe(m);
      toast('Photo updated');
    }
  };
  const stat = (n: number, label: string) => (
    <div
      style={{
        flex: 1,
        border: '1.5px solid rgba(247,245,241,.4)',
        borderColor: 'color-mix(in srgb, var(--on-dark) 40%, transparent)',
        borderRadius: 14,
        padding: '8px 10px',
      }}
    >
      <span className="digits big" style={{ fontSize: 18 }}>
        {pad2(n)}
      </span>
      <div style={{ marginTop: 4 }}>
        <Label size={8} color="color-mix(in srgb, var(--on-dark) 75%, transparent)">
          {label}
        </Label>
      </div>
    </div>
  );

  return (
    <div style={{ padding: '0 12px' }}>
      <Card dark flat pad="16px 16px 18px" radius={30}>
        <div className="row" style={{ justifyContent: 'space-between' }}>
          {p.isMe ? (
            <Label color="var(--accent-text)">YOUR GAMER ID</Label>
          ) : (
            <BackBtn size={38} onDark />
          )}
          <CircleBtn size={38} onDark onClick={() => router.push('/app/search')} label="Search">
            <Icon name="search" size={18} />
          </CircleBtn>
        </div>
        <div className="row" style={{ gap: 14, marginTop: 12 }}>
          <span style={{ position: 'relative' }}>
            <Avatar
              name={p.displayName}
              tone={p.isMe ? 'accent' : toneFor(p.id)}
              url={p.avatarUrl}
              size={84}
              onDark
              onClick={p.isMe ? () => file.current?.click() : undefined}
            />
            {p.isMe && (
              <span style={{ position: 'absolute', right: -2, bottom: -2 }}>
                <CircleBtn size={30} onClick={() => file.current?.click()} label="Change photo">
                  <Icon name="image" size={14} color="var(--text)" />
                </CircleBtn>
              </span>
            )}
          </span>
          <div className="grow">
            <div
              className="t-display"
              style={{ fontSize: 28, fontWeight: 800, letterSpacing: -1, lineHeight: 1 }}
            >
              {p.displayName}
            </div>
            <div style={{ fontSize: 14, opacity: 0.8, marginTop: 4 }}>
              @{p.username} · {p.city}
            </div>
            <button
              type="button"
              onClick={cycle}
              disabled={!p.isMe}
              className="row"
              style={{
                marginTop: 9,
                gap: 7,
                padding: '4px 11px',
                borderRadius: 99,
                border: '1.5px solid var(--on-dark-line)',
                background: 'transparent',
                color: 'var(--on-dark)',
                cursor: p.isMe ? 'pointer' : 'default',
              }}
            >
              <Dot color={toneColor(tone)} size={8} />
              <span style={{ fontSize: 13, fontWeight: 600 }}>{status}</span>
            </button>
          </div>
        </div>
        {p.bio && (
          <div style={{ fontSize: 14, lineHeight: 1.4, opacity: 0.9, marginTop: 12 }}>{p.bio}</div>
        )}
        <div className="row" style={{ gap: 8, marginTop: 14 }}>
          {stat(p.stats.connections, 'CONNECTIONS')}
          {stat(p.stats.games, 'GAMES')}
          {stat(p.stats.playedWith, 'PLAYED WITH')}
        </div>
        {p.isMe && (
          <input
            ref={file}
            type="file"
            accept="image/jpeg,image/png,image/webp"
            hidden
            onChange={(e) => upload(e.target.files?.[0])}
          />
        )}
      </Card>
    </div>
  );
}

/** Square-crops and scales a photo to 512 px JPEG on the device (≤ 2 MB, docs/API.md "Images"). */
async function shrink(f: File): Promise<Blob> {
  const img = await createImageBitmap(f);
  const side = Math.min(img.width, img.height);
  const canvas = document.createElement('canvas');
  canvas.width = canvas.height = Math.min(512, side);
  canvas
    .getContext('2d')!
    .drawImage(
      img,
      (img.width - side) / 2,
      (img.height - side) / 2,
      side,
      side,
      0,
      0,
      canvas.width,
      canvas.height,
    );
  return new Promise((resolve, reject) =>
    canvas.toBlob((b) => (b ? resolve(b) : reject(new Error('image'))), 'image/jpeg', 0.85),
  );
}

function GameRow({ g }: { g: UserGame }) {
  const { game } = useApp();
  const known = g.game ? game(g.game.id) : null;
  const rank = g.rank?.name ?? (g.rankText || (known?.hasRanks ? 'Unranked' : '—'));
  return (
    <Card pad={12} radius={22}>
      <div className="row" style={{ gap: 12 }}>
        <span
          className="card dark flat row"
          style={{
            width: 56,
            height: 56,
            borderRadius: 16,
            justifyContent: 'center',
            fontSize: 14,
            fontWeight: 800,
            padding: 4,
            border: 0,
          }}
        >
          {g.game?.shortCode ?? (g.customGameName ?? '?').slice(0, 4).toUpperCase()}
        </span>
        <div className="grow">
          <div style={{ fontSize: 16, fontWeight: 700 }}>{g.game?.name ?? g.customGameName}</div>
          <div className="muted" style={{ fontSize: 13 }}>
            {g.role?.name ?? (g.game ? 'Self-reported' : 'Added by you')}
          </div>
        </div>
        <span
          className="ellipsis"
          style={{
            maxWidth: '40%',
            background: 'var(--soft)',
            border: 'var(--line-w) solid var(--line)',
            borderRadius: 12,
            padding: '5px 10px',
            fontSize: 14,
            fontWeight: 800,
          }}
        >
          {rank}
        </span>
      </div>
    </Card>
  );
}

function Overview({ p }: { p: View }) {
  return (
    <>
      <Card flat pad={14} radius={22}>
        <div className="gap" style={{ gap: 8 }}>
          <Label>PLATFORMS</Label>
          <div className="wrap">
            {(p.platforms.length ? p.platforms.map((x) => platformLabel[x]) : ['—']).map((x) => (
              <span
                key={x}
                style={{
                  background: 'var(--strong)',
                  color: 'var(--on-strong)',
                  borderRadius: 99,
                  padding: '5px 12px',
                  fontSize: 13,
                  fontWeight: 600,
                }}
              >
                {x}
              </span>
            ))}
          </div>
          {p.tags.length > 0 && (
            <>
              <Label style={{ marginTop: 4 }}>PLAY STYLE</Label>
              <div className="wrap">
                {p.tags.map((x) => (
                  <span key={x} className="tag" style={{ fontSize: 13 }}>
                    {tagLabel[x]}
                  </span>
                ))}
              </div>
            </>
          )}
        </div>
      </Card>
      <div className="card flat" style={{ borderRadius: 22, overflow: 'hidden' }}>
        <div style={{ padding: '12px 14px 4px' }}>
          <Label>GAMING IDS</Label>
        </div>
        {p.gamingIds.map((x) => (
          <div key={x.id} className="row" style={{ padding: '10px 14px', gap: 10 }}>
            <b style={{ width: 86, fontSize: 13 }}>
              {x.kind === 'in_game' ? (x.game?.shortCode ?? 'In-game') : idKindLabel[x.kind]}
            </b>
            <span
              className="grow"
              style={{
                fontFamily: 'monospace',
                fontSize: 13,
                userSelect: 'all',
                overflowWrap: 'anywhere',
              }}
            >
              {x.value}
            </span>
            <Label size={8}>
              {x.visibility === 'public' ? 'PUBLIC' : p.isMe ? 'CONNECTIONS' : 'CONNECTED'}
            </Label>
          </div>
        ))}
        {!p.isMe && p.relationship !== 'connected' && (
          <div style={{ padding: '4px 12px 12px' }}>
            <div
              className="dashed muted"
              style={{ borderRadius: 14, padding: '10px 12px', fontSize: 13 }}
            >
              Their other IDs unlock once you’re connected.
            </div>
          </div>
        )}
        {p.gamingIds.length === 0 && (p.isMe || p.relationship === 'connected') && (
          <div className="muted" style={{ padding: '4px 14px 14px', fontSize: 13 }}>
            No IDs added.
          </div>
        )}
      </div>
    </>
  );
}

function Connections() {
  const { run } = useApp();
  const [more, setMore] = useState<string | null>(null);
  const { data, setData, loaded } = useLoad(async () => {
    const p = await api<Page<Connection>>('me/connections');
    setMore(p.nextCursor);
    return p.items;
  }, []);
  const loadMore = async () => {
    const p = await run(
      () => api<Page<Connection>>(`me/connections?cursor=${encodeURIComponent(more!)}`),
      { busy: false },
    );
    if (!p) return;
    setData([...(data ?? []), ...p.items]);
    setMore(p.nextCursor);
  };
  if (loaded && !data?.length)
    return <EmptyNote>No connections yet. Find Players is the fastest way to make one.</EmptyNote>;
  return (
    <>
      <Rows>
        {(data ?? []).map((c) => (
          <Link key={c.user.id} href={`/app/players/${c.user.username}`} className="r">
            <Avatar name={c.user.displayName} tone={toneFor(c.user.id)} url={c.user.avatarUrl} />
            <span className="grow">
              <b style={{ display: 'block', fontSize: 15 }}>{c.user.displayName}</b>
              <span className="muted ellipsis" style={{ display: 'block', fontSize: 12 }}>
                {[rankLine(c.user.topGame), statusLook(c.user.status, c.user.statusGame)[0]]
                  .filter(Boolean)
                  .join(' · ')}
              </span>
            </span>
          </Link>
        ))}
      </Rows>
      {more && (
        <div style={{ textAlign: 'center' }}>
          <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
            Load more
          </Pill>
        </div>
      )}
    </>
  );
}

/** 2×2 skins; each card is a live miniature in its own skin. */
function ThemePicker() {
  const { skin, setSkin } = useApp();
  return (
    <div className="gap" style={{ gap: 8 }}>
      <Label style={{ paddingLeft: 6 }}>APP THEME</Label>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        {skins.map((s) => (
          <button
            key={s.id}
            type="button"
            aria-pressed={skin === s.id}
            aria-label={`${s.name} theme`}
            onClick={() => setSkin(s.id as Skin)}
            style={{
              padding: 4,
              borderRadius: 24,
              border: `2.5px solid ${skin === s.id ? 'var(--text)' : 'transparent'}`,
              background: 'transparent',
              textAlign: 'left',
              cursor: 'pointer',
            }}
          >
            <div
              className="rl"
              data-skin={s.id}
              style={{
                minHeight: 0,
                borderRadius: 19,
                overflow: 'hidden',
                padding: 10,
                height: 134,
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
              }}
            >
              <Wordmark size={15} />
              <div className="gap" style={{ gap: 8 }}>
                <div
                  className="card row"
                  style={{ padding: 8, borderRadius: 14, gap: 6, boxShadow: 'var(--sh3)' }}
                >
                  <Avatar name="Kaleb" tone="accent" size={24} />
                  <div className="grow">
                    <div style={{ fontSize: 12, fontWeight: 800, lineHeight: 1.1 }}>Kaleb</div>
                    <Label size={6}>GOLD · VAL</Label>
                  </div>
                  <span className="digits" style={{ fontSize: 11 }}>
                    21:00
                  </span>
                </div>
                <div className="row" style={{ gap: 4 }}>
                  <span
                    className="pill accent"
                    style={{
                      height: 22,
                      padding: '0 8px',
                      fontSize: 10,
                      fontWeight: 700,
                      borderWidth: 1,
                    }}
                  >
                    Connect
                  </span>
                  <span
                    className="pill ink"
                    style={{ height: 22, padding: '0 8px', fontSize: 10, border: 0 }}
                  >
                    Duo
                  </span>
                </div>
              </div>
            </div>
            <div style={{ padding: '8px 6px 2px' }}>
              <div style={{ fontSize: 14, fontWeight: 700 }}>{s.name}</div>
              <div className="muted ellipsis" style={{ fontSize: 11 }}>
                {s.tagline}
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

/** Settings on your own profile: account and safety. */
function Settings({ me }: { me: Me }) {
  const { run, toast, setMe, busy } = useApp();
  const router = useRouter();
  const [dialog, setDialog] = useState<'password' | 'delete' | null>(null);
  const [current, setCurrent] = useState('');
  const [next, setNext] = useState('');

  const logout = async () => {
    await run(() => api('auth/logout', { method: 'POST' }), { quiet: true });
    setMe(null);
    router.replace('/app/welcome');
  };
  const change = async () => {
    if (next.length < 8) return toast('New password needs at least 8 characters');
    const ok = await run(() =>
      api('auth/password', {
        method: 'POST',
        body: { currentPassword: current, newPassword: next },
      }).then(() => true),
    );
    if (!ok) return;
    toast('Password changed');
    setDialog(null);
    setCurrent('');
    setNext('');
  };
  const remove = async () => {
    const ok = await run(() =>
      api('me', { method: 'DELETE', body: me.hasPassword ? { password: current } : {} }).then(
        () => true,
      ),
    );
    if (!ok) return;
    setMe(null);
    toast('Account deleted. Your data is erased in 30 days.');
    router.replace('/app/welcome');
  };
  const row = (label: string, onClick: () => void, trailing = '→') => (
    <button type="button" className="r" onClick={onClick} style={{ padding: 14 }}>
      <span className="grow" style={{ fontSize: 15, fontWeight: 600 }}>
        {label}
      </span>
      <span className="muted ellipsis" style={{ fontSize: 14, maxWidth: '50%' }}>
        {trailing}
      </span>
    </button>
  );
  return (
    <div className="gap" style={{ gap: 8 }}>
      <Label style={{ paddingLeft: 6 }}>SETTINGS</Label>
      <Rows>
        {!me.emailVerified &&
          row('Confirm your email', () => router.push('/app/verify'), 'Not confirmed')}
        {me.hasPassword && row('Change password', () => setDialog('password'))}
        {row('Blocked users', () => router.push('/app/you/blocked'))}
        {row('Log out', logout, me.email)}
        {row('Delete account', () => setDialog('delete'))}
      </Rows>
      {dialog === 'password' && (
        <Dialog onClose={() => setDialog(null)}>
          <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>Change password</div>
          <div className="muted" style={{ fontSize: 14 }}>
            Other phones signed in to your account stay signed in.
          </div>
          <PasswordField
            value={current}
            onChange={setCurrent}
            placeholder="Current password"
            h={50}
          />
          <PasswordField
            value={next}
            onChange={setNext}
            placeholder="New password, 8+ characters"
            h={50}
            autoComplete="new-password"
          />
          <div className="row" style={{ gap: 8 }}>
            <Pill h={46} size={15} expand look="clear" onClick={() => setDialog(null)}>
              Cancel
            </Pill>
            <Pill h={46} size={15} bold expand look="accent" onClick={change} disabled={busy}>
              Change
            </Pill>
          </div>
        </Dialog>
      )}
      {dialog === 'delete' && (
        <Dialog onClose={() => setDialog(null)}>
          <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>
            Delete your account?
          </div>
          <div className="muted" style={{ fontSize: 14, lineHeight: 1.35 }}>
            Your listing closes, your connections end and your profile disappears now. Everything is
            erased after 30 days.
          </div>
          {me.hasPassword && (
            <PasswordField
              value={current}
              onChange={setCurrent}
              placeholder="Your password"
              h={50}
            />
          )}
          <div className="row" style={{ gap: 8 }}>
            <Pill h={46} size={15} expand look="clear" onClick={() => setDialog(null)}>
              Keep it
            </Pill>
            <Pill h={46} size={15} bold expand look="strong" onClick={remove} disabled={busy}>
              Delete
            </Pill>
          </div>
        </Dialog>
      )}
    </div>
  );
}
