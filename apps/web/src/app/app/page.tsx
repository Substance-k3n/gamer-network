'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useEffect, useRef, useState } from 'react';
import { api, type CheckIn, type Listing, type Me, type PlayInvite } from './_lib/api';
import { clock, countdown, partyLabel, platformLabel, playWhenLabel, toneFor } from './_lib/data';
import { FeedPost } from './_lib/feed';
import { EditListingSheet } from './_lib/sheets';
import { useApp, useLoad, useNow } from './_lib/store';
import { Avatar, Card, Digits, Icon, Label, Pill, Spinner, Wordmark } from './_lib/ui';

type HomeData = {
  listing: Listing | null;
  checkIns: CheckIn[];
  sent: PlayInvite[];
};

/**
 * Home: the timeline (apps/mobile/lib/screens/home.dart). What needs you now
 * (verify, invites, "did you play?", your listing) is pinned above the posts.
 * The top bar slides away while scrolling down and returns on scroll up; past
 * a few posts a pill jumps back to the top.
 */
export default function Home() {
  const {
    me,
    run,
    setMe,
    setInvites,
    invites,
    unread,
    setUnread,
    version,
    toast,
    feed,
    loadPosts,
    putPost,
    dropPost,
  } = useApp();
  const router = useRouter();
  const { data, setData } = useLoad<HomeData>(async () => {
    const [m, mine, checks, inc, sent, n] = await Promise.all([
      api<Me>('me'),
      api<{ listing: Listing | null }>('me/listing'),
      api<{ items: CheckIn[] }>('me/check-ins'),
      api<{ items: PlayInvite[] }>('play-invites?direction=incoming'),
      api<{ items: PlayInvite[] }>('play-invites?direction=outgoing'),
      api<{ count: number }>('notifications/unread-count'),
    ]);
    setMe(m);
    setInvites(inc.items);
    setUnread(n.count);
    return { listing: mine.listing, checkIns: checks.items, sent: sent.items };
  }, [version]);
  const [editing, setEditing] = useState(false);
  const [filterOpen, setFilterOpen] = useState(false);
  const [hideBar, setHideBar] = useState(false);
  const [showPill, setShowPill] = useState(false);
  const [typing, setTyping] = useState(false);

  // The timeline survives moving around the app; it reloads when something
  // changed elsewhere (a block, a new post…).
  const stale = !feed.loaded || feed.at !== version;
  useEffect(() => {
    if (stale) loadPosts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [version]);

  // Hide-on-scroll bar, the jump pill, and the next page near the end.
  const lastY = useRef(0);
  const more = useRef(() => {});
  more.current = () => {
    if (feed.cursor) loadPosts({ more: true });
  };
  useEffect(() => {
    const onScroll = () => {
      const y = window.scrollY;
      const d = y - lastY.current;
      lastY.current = y;
      setHideBar((h) => (y < 60 ? false : d > 4 ? true : d < -4 ? false : h));
      setShowPill(y > 520);
      const left = document.documentElement.scrollHeight - (y + window.innerHeight);
      if (left < 600) more.current();
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);
  // While a text field has focus the floating buttons step aside, like
  // with the keyboard on mobile (D16). They come back only once the press
  // that took focus away is over, so they never appear under a finger or
  // pointer mid-tap and swallow its click (BUG-6).
  useEffect(() => {
    const isField = (t: EventTarget | null) =>
      t instanceof HTMLElement && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA');
    let pressing = false;
    let pending = false;
    const settle = () => setTyping(isField(document.activeElement));
    const on = (e: FocusEvent) => {
      if (isField(e.target)) setTyping(true);
    };
    const off = (e: FocusEvent) => {
      if (isField(e.relatedTarget)) return;
      // On touch the blur comes after pointerup, with the click in the same
      // task: a tick later is after that click either way.
      if (pressing) pending = true;
      else setTimeout(settle, 0);
    };
    const down = () => (pressing = true);
    const up = () =>
      // After the click this press makes.
      setTimeout(() => {
        pressing = false;
        if (pending) {
          pending = false;
          settle();
        }
      }, 0);
    document.addEventListener('focusin', on);
    document.addEventListener('focusout', off);
    document.addEventListener('pointerdown', down, true);
    document.addEventListener('pointerup', up, true);
    document.addEventListener('pointercancel', up, true);
    return () => {
      document.removeEventListener('focusin', on);
      document.removeEventListener('focusout', off);
      document.removeEventListener('pointerdown', down, true);
      document.removeEventListener('pointerup', up, true);
      document.removeEventListener('pointercancel', up, true);
    };
  }, []);
  if (!me) return null;

  const options: [string, string][] = [
    ['for_you', 'For you'],
    ['connections', 'Connections'],
    ['lfg', 'LFG & recruiting'],
    ...me.games.flatMap((g): [string, string][] => (g.game ? [[g.game.id, g.game.name]] : [])),
  ];
  const current = options.find((o) => o[0] === feed.tab) ?? options[0]!;
  const pick = (id: string) => {
    setFilterOpen(false);
    window.scrollTo(0, 0);
    setHideBar(false);
    loadPosts({ tab: id });
  };
  const toTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
    setHideBar(false);
    setShowPill(false);
  };

  const answerCheckIn = async (c: CheckIn, answer: 'played' | 'not_yet' | 'no') => {
    const ok = await run(
      () => api(`check-ins/${c.id}`, { method: 'POST', body: { answer } }).then(() => true),
      { busy: false },
    );
    if (!ok || !data) return;
    setData({ ...data, checkIns: data.checkIns.filter((x) => x.id !== c.id) });
    toast(answer === 'played' ? 'GG — glad you played' : 'Thanks, noted');
  };
  const answerInvite = async (i: PlayInvite, accept: boolean) => {
    const ok = await run(() =>
      api(`play-invites/${i.id}/${accept ? 'accept' : 'decline'}`, { method: 'POST' }).then(
        () => true,
      ),
    );
    if (!ok) return;
    setInvites(invites.filter((x) => x.id !== i.id));
    toast(accept ? `You’re on — ${i.game.name} with ${i.from.displayName}` : 'Invite declined');
  };
  const closeListing = async () => {
    if (!data?.listing) return;
    const r = await run(() =>
      api<Listing>(`listings/${data.listing!.id}/close`, { method: 'POST' }),
    );
    if (!r) return;
    setData({ ...data, listing: null });
    toast('Listing closed');
  };

  const pinned = [
    !me.emailVerified && (
      <Link
        key="verify"
        href="/app/verify"
        className="dashed row"
        style={{ padding: '12px 14px', gap: 10 }}
      >
        <span className="grow">
          <b style={{ display: 'block', fontSize: 15 }}>Confirm your email</b>
          <span className="muted" style={{ fontSize: 13 }}>
            Needed to post a listing or connect. The code is in your inbox.
          </span>
        </span>
        <span style={{ fontSize: 13, fontWeight: 700, textDecoration: 'underline' }}>
          Enter code
        </span>
      </Link>
    ),
    ...invites.map((i) => <InviteCard key={i.id} i={i} onAnswer={answerInvite} />),
    ...(data?.sent ?? []).map((i) => <SentInvite key={i.id} i={i} />),
    ...(data?.checkIns ?? []).map((c) => <CheckInCard key={c.id} c={c} onAnswer={answerCheckIn} />),
    data?.listing && (
      <MyListing
        key="listing"
        l={data.listing}
        onClose={closeListing}
        onEdit={() => setEditing(true)}
      />
    ),
  ].filter(Boolean);

  // Faces of the last few posters on the jump pill.
  const faces = feed.posts
    .filter((p, i, all) => !p.mine && all.findIndex((x) => x.author.id === p.author.id) === i)
    .slice(0, 3)
    .map((p) => p.author);
  const side = 'max(18px, calc(50% - 222px))';

  return (
    <>
      {editing && data?.listing && (
        <EditListingSheet
          l={data.listing}
          onClose={() => setEditing(false)}
          onSaved={(l) => setData({ ...data, listing: l })}
        />
      )}
      <TopBar unread={unread} hidden={hideBar} />
      {pinned.length > 0 && (
        <div
          className="gap"
          style={{
            gap: 14,
            padding: 16,
            paddingTop: 14,
            borderBottom: '1.5px solid var(--divider)',
          }}
        >
          {pinned}
        </div>
      )}
      {feed.posts.map((p) => (
        <FeedPost key={p.id} p={p} onChange={putPost} onGone={() => dropPost(p.id)} />
      ))}
      {!feed.loaded || (stale && feed.posts.length === 0) ? (
        <Spinner />
      ) : (
        feed.posts.length === 0 && (
          <div
            className="muted"
            style={{ padding: '40px 28px', textAlign: 'center', fontSize: 15, lineHeight: 1.45 }}
          >
            {feed.tab === 'connections'
              ? 'Nothing here yet. Connect with players from Find Players and their posts show up here.'
              : 'No posts yet. Tap + and start the conversation.'}
          </div>
        )
      )}

      {showPill && (
        <button
          type="button"
          className="pill accent"
          onClick={toTop}
          aria-label="Back to the top"
          style={{
            position: 'fixed',
            top: 'calc(10px + env(safe-area-inset-top))',
            left: '50%',
            transform: 'translateX(-50%)',
            height: 42,
            padding: '0 8px 0 14px',
            boxShadow: 'var(--sh3)',
            zIndex: 6,
            animation: 'fade .22s ease',
          }}
        >
          <Icon name="up" size={16} />
          {faces.length > 0 && (
            <span
              style={{
                position: 'relative',
                width: 26 + 20 * (faces.length - 1),
                height: 26,
              }}
            >
              {faces.map((a, i) => (
                <span key={a.id} style={{ position: 'absolute', left: 20 * i, top: 0 }}>
                  <Avatar name={a.displayName} tone={toneFor(a.id)} url={a.avatarUrl} size={26} />
                </span>
              ))}
            </span>
          )}
        </button>
      )}

      {filterOpen && (
        <>
          <div
            style={{ position: 'fixed', inset: 0, zIndex: 8 }}
            onClick={() => setFilterOpen(false)}
          />
          <div
            className="gap"
            role="menu"
            style={{
              position: 'fixed',
              left: side,
              bottom: 'calc(162px + env(safe-area-inset-bottom))',
              width: 220,
              maxHeight: 'calc(100dvh - 220px)',
              overflowY: 'auto',
              padding: 8,
              background: 'var(--popover)',
              border: 'var(--line-w) solid var(--line)',
              borderRadius: 22,
              boxShadow: 'var(--sh4)',
              backdropFilter: 'blur(var(--blur))',
              WebkitBackdropFilter: 'blur(var(--blur))',
              zIndex: 9,
            }}
          >
            <div style={{ padding: '6px 10px 4px' }}>
              <Label>SHOW IN FEED</Label>
            </div>
            {options.map(([id, label]) => {
              const on = feed.tab === id;
              return (
                <button
                  key={id}
                  type="button"
                  role="menuitemradio"
                  aria-checked={on}
                  className="row"
                  onClick={() => pick(id)}
                  style={{
                    height: 40,
                    marginTop: 2,
                    padding: '0 12px',
                    gap: 8,
                    border: 0,
                    borderRadius: 14,
                    background: on ? 'var(--accent)' : 'transparent',
                    color: on ? 'var(--on-accent)' : 'var(--text)',
                    fontSize: 14,
                    fontWeight: 600,
                    textAlign: 'left',
                    cursor: 'pointer',
                  }}
                >
                  <span className="grow ellipsis">{label}</span>
                  {on && <b style={{ fontWeight: 800 }}>✓</b>}
                </button>
              );
            })}
          </div>
        </>
      )}
      {!typing && (
        <>
          <div
            style={{
              position: 'fixed',
              left: side,
              bottom: 'calc(102px + env(safe-area-inset-bottom))',
              maxWidth: 'calc(100% - 120px)',
              zIndex: 9,
            }}
          >
            <Pill
              h={50}
              padH={16}
              size={14}
              bold
              shadow={4}
              onClick={() => setFilterOpen(!filterOpen)}
              style={{
                background: 'var(--popover)',
                backdropFilter: 'blur(var(--blur))',
                maxWidth: '100%',
              }}
            >
              <Icon name="filter" size={18} />
              <span className="ellipsis">{current[1]}</span>
            </Pill>
          </div>
          <button
            type="button"
            className="circle"
            aria-label="New post"
            onClick={() => router.push('/app/compose')}
            style={{
              position: 'fixed',
              right: side,
              bottom: 'calc(98px + env(safe-area-inset-bottom))',
              width: 58,
              height: 58,
              background: 'var(--accent)',
              color: 'var(--on-accent)',
              boxShadow: 'var(--sh4)',
              zIndex: 9,
            }}
          >
            <Icon name="plus" size={26} />
          </button>
        </>
      )}
    </>
  );
}

function TopBar({ unread, hidden }: { unread: number; hidden: boolean }) {
  const { me } = useApp();
  const router = useRouter();
  return (
    <div
      className="rl-topbar"
      style={{
        transform: hidden ? 'translateY(-100%)' : undefined,
        transition: 'transform .28s ease',
      }}
    >
      <Avatar
        name={me?.displayName ?? '?'}
        tone="accent"
        url={me?.avatarUrl}
        size={38}
        onClick={() => router.push('/app/you')}
      />
      <span className="grow row" style={{ justifyContent: 'center' }}>
        <Wordmark size={26} />
      </span>
      <Link
        href="/app/alerts"
        aria-label="Alerts"
        style={{
          position: 'relative',
          width: 42,
          height: 42,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Icon name="bell" size={23} />
        {unread > 0 && <span className="badge">{unread > 99 ? '99+' : unread}</span>}
      </Link>
    </div>
  );
}

function InviteCard({
  i,
  onAnswer,
}: {
  i: PlayInvite;
  onAnswer: (i: PlayInvite, accept: boolean) => void;
}) {
  const now = useNow();
  const router = useRouter();
  return (
    <Card dark pad={14}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 10 }}>
          <Avatar
            name={i.from.displayName}
            tone={toneFor(i.from.id)}
            url={i.from.avatarUrl}
            onDark
            onClick={() => router.push(`/app/players/${i.from.username}`)}
          />
          <div className="grow">
            <Label size={8} color="var(--accent-text)">
              PLAY INVITE
            </Label>
            <div style={{ fontSize: 16, fontWeight: 700 }}>
              {i.from.displayName} · {i.game.name}
            </div>
            <div style={{ fontSize: 12, opacity: 0.8 }}>Starts {clock(i.startsAt)}</div>
          </div>
          <Digits size={13}>{countdown(i.expiresAt, now)}</Digits>
        </div>
        <div className="row" style={{ gap: 8 }}>
          <Pill h={42} size={14} bold look="accent" expand onClick={() => onAnswer(i, true)}>
            I’m in
          </Pill>
          <Pill
            h={42}
            size={14}
            look="clear"
            expand
            onClick={() => onAnswer(i, false)}
            style={{ color: 'var(--on-dark)' }}
          >
            Not now
          </Pill>
        </div>
      </div>
    </Card>
  );
}

/** "Did you play with Dave?" — the product's main number, one tap. */
function CheckInCard({
  c,
  onAnswer,
}: {
  c: CheckIn;
  onAnswer: (c: CheckIn, a: 'played' | 'not_yet' | 'no') => void;
}) {
  return (
    <Card pad={14} style={{ background: 'var(--soft)' }}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 10 }}>
          <Avatar name={c.other.displayName} tone={toneFor(c.other.id)} url={c.other.avatarUrl} />
          <div className="grow">
            <div style={{ fontSize: 17, fontWeight: 800, letterSpacing: -0.3 }}>
              Did you play with {c.other.displayName}?
            </div>
            {c.game && (
              <div className="muted" style={{ fontSize: 12 }}>
                {c.game.name}
              </div>
            )}
          </div>
        </div>
        <div className="row" style={{ gap: 6 }}>
          <Pill h={42} size={14} bold look="strong" expand onClick={() => onAnswer(c, 'played')}>
            Yes, we played
          </Pill>
          <Pill h={42} padH={12} size={14} look="clear" onClick={() => onAnswer(c, 'not_yet')}>
            Not yet
          </Pill>
          <Pill h={42} padH={12} size={14} look="clear" onClick={() => onAnswer(c, 'no')}>
            No
          </Pill>
        </div>
      </div>
    </Card>
  );
}

function SentInvite({ i }: { i: PlayInvite }) {
  const now = useNow();
  return (
    <Link
      href={`/app/players/${i.to.username}`}
      className="card row"
      style={{ padding: 12, gap: 10, borderRadius: 22 }}
    >
      <Avatar name={i.to.displayName} tone={toneFor(i.to.id)} url={i.to.avatarUrl} size={36} />
      <span className="grow">
        <Label size={8}>INVITE SENT</Label>
        <span style={{ display: 'block', fontSize: 14, fontWeight: 600 }}>
          Waiting for {i.to.displayName} · {i.game.name} at {clock(i.startsAt)}
        </span>
      </span>
      <Digits size={12}>{countdown(i.expiresAt, now)}</Digits>
    </Link>
  );
}

function MyListing({
  l,
  onClose,
  onEdit,
}: {
  l: Listing;
  onClose: () => void;
  onEdit: () => void;
}) {
  const now = useNow();
  const { toast, busy } = useApp();
  const share = async () => {
    try {
      if (navigator.share)
        await navigator.share({ title: `${l.game.name} on rally`, url: l.shareUrl });
      else {
        await navigator.clipboard.writeText(l.shareUrl);
        toast('Link copied — paste it in Telegram or WhatsApp');
      }
    } catch {}
  };
  return (
    <Card pad={14}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 4 }}>
          <Label>YOUR LIVE LISTING</Label>
          <span className="grow" />
          <Label size={8}>EXPIRES IN</Label>
          <Digits>{countdown(l.expiresAt, now)}</Digits>
        </div>
        <Card dark flat pad="10px 12px" radius={16}>
          <div className="row">
            <div className="grow">
              <Label size={9} color="var(--accent-text)">
                {(
                  l.mode?.name ?? (l.style === 'competitive' ? 'Competitive' : 'Casual')
                ).toUpperCase()}
              </Label>
              <div style={{ fontSize: 17, fontWeight: 700 }}>{l.game.name}</div>
              <div style={{ fontSize: 12, opacity: 0.85 }}>
                {partyLabel(l.partySize)} · {playWhenLabel[l.playWhen]} ·{' '}
                {platformLabel[l.platform]}
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <Label size={8} color="inherit">
                FILLED
              </Label>
              <div>
                <Digits size={16}>
                  {l.filled}/{l.partySize - 1}
                </Digits>
              </div>
            </div>
          </div>
        </Card>
        <div className="row" style={{ gap: 8 }}>
          <Pill h={42} size={14} bold expand onClick={share}>
            <Icon name="share" size={16} /> Share link
          </Pill>
          <Pill h={42} padH={16} size={14} onClick={onEdit} disabled={busy}>
            Edit
          </Pill>
          <Pill h={42} size={14} expand look="clear" onClick={onClose} disabled={busy}>
            Close listing
          </Pill>
        </div>
      </div>
    </Card>
  );
}
