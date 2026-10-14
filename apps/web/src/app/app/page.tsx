'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  api,
  type CheckIn,
  type Listing,
  type Me,
  type PlayInvite,
  type PlayerStatus,
} from './_lib/api';
import {
  clock,
  countdown,
  days,
  dayLabel,
  pad2,
  partyLabel,
  platformLabel,
  playWhenLabel,
  statusLook,
  toneFor,
} from './_lib/data';
import { useApp, useLoad, useNow } from './_lib/store';
import { Avatar, Card, Chip, Digits, Dot, Icon, Label, Pill, Wordmark, toneColor } from './_lib/ui';

type HomeData = {
  lookingNow: number;
  listing: Listing | null;
  checkIns: CheckIn[];
  sent: PlayInvite[];
};

/** Home in the MVP (docs/API.md screen map): no feed. */
export default function Home() {
  const { me, run, setMe, setInvites, invites, unread, setUnread, version, toast, setSheet } =
    useApp();
  const { data, setData, reload } = useLoad<HomeData>(async () => {
    const [m, stats, mine, checks, inc, sent, n] = await Promise.all([
      api<Me>('me'),
      api<{ lookingNow: number }>('listings/stats'),
      api<{ listing: Listing | null }>('me/listing'),
      api<{ items: CheckIn[] }>('me/check-ins'),
      api<{ items: PlayInvite[] }>('play-invites?direction=incoming'),
      api<{ items: PlayInvite[] }>('play-invites?direction=outgoing'),
      api<{ count: number }>('notifications/unread-count'),
    ]);
    setMe(m);
    setInvites(inc.items);
    setUnread(n.count);
    return {
      lookingNow: stats.lookingNow,
      listing: mine.listing,
      checkIns: checks.items,
      sent: sent.items,
    };
  }, [version]);
  if (!me) return null;

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
  const setStatus = async (status: PlayerStatus, availableDays?: string[]) => {
    const gameId = status === 'not_available' ? undefined : (me.games[0]?.game?.id ?? undefined);
    const m = await run(
      () => api<Me>('me/status', { method: 'PUT', body: { status, gameId, availableDays } }),
      { busy: false },
    );
    if (m) setMe(m);
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

  return (
    <>
      <TopBar unread={unread} />
      <div className="gap rl-pad" style={{ gap: 14, paddingTop: 14 }}>
        {!me.emailVerified && (
          <Link href="/app/verify" className="dashed row" style={{ padding: '12px 14px', gap: 10 }}>
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
        )}
        {invites.map((i) => (
          <InviteCard key={i.id} i={i} onAnswer={answerInvite} />
        ))}
        {data?.sent.map((i) => (
          <SentInvite key={i.id} i={i} />
        ))}
        {data?.checkIns.map((c) => (
          <Card key={c.id} pad={14} style={{ background: 'var(--soft)' }}>
            <div className="gap" style={{ gap: 10 }}>
              <div className="row" style={{ gap: 10 }}>
                <Avatar
                  name={c.other.displayName}
                  tone={toneFor(c.other.id)}
                  url={c.other.avatarUrl}
                />
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
                <Pill
                  h={42}
                  size={14}
                  bold
                  look="strong"
                  expand
                  onClick={() => answerCheckIn(c, 'played')}
                >
                  Yes, we played
                </Pill>
                <Pill
                  h={42}
                  padH={12}
                  size={14}
                  look="clear"
                  onClick={() => answerCheckIn(c, 'not_yet')}
                >
                  Not yet
                </Pill>
                <Pill
                  h={42}
                  padH={12}
                  size={14}
                  look="clear"
                  onClick={() => answerCheckIn(c, 'no')}
                >
                  No
                </Pill>
              </div>
            </div>
          </Card>
        ))}
        <StatusCard me={me} onStatus={setStatus} />
        {data?.listing ? (
          <MyListing l={data.listing} onClose={closeListing} />
        ) : (
          <Card dark pad={18} radius={26}>
            <div className="gap" style={{ gap: 12 }}>
              <Label color="var(--accent-text)">LOOKING FOR PLAYERS?</Label>
              <div
                className="t-display"
                style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6, lineHeight: 1.1 }}
              >
                Post what you want to play. It’s gone when you’re done.
              </div>
              <div>
                <Pill
                  h={42}
                  padH={16}
                  size={14}
                  bold
                  look="accent"
                  onClick={() => setSheet({ kind: 'listing' })}
                >
                  <Icon name="plus" size={16} /> Post a listing
                </Pill>
              </div>
            </div>
          </Card>
        )}
        <Link href="/app/find" className="card row" style={{ padding: 14, gap: 12 }}>
          <Digits size={28}>{pad2(data?.lookingNow ?? 0)}</Digits>
          <span className="grow" style={{ fontSize: 15, fontWeight: 600, lineHeight: 1.25 }}>
            players looking right now in {me.city}
          </span>
          <span style={{ fontSize: 14, fontWeight: 700, textDecoration: 'underline' }}>Find →</span>
        </Link>
        <button
          type="button"
          className="u muted"
          style={{ fontSize: 13, alignSelf: 'center', textDecoration: 'none' }}
          onClick={reload}
        >
          Refresh
        </button>
      </div>
    </>
  );
}

function TopBar({ unread }: { unread: number }) {
  const { me } = useApp();
  const router = useRouter();
  return (
    <div className="rl-topbar">
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

function StatusCard({
  me,
  onStatus,
}: {
  me: Me;
  onStatus: (s: PlayerStatus, days?: string[]) => void;
}) {
  const [label, tone] = statusLook(me.status, me.statusGame);
  const opts: [PlayerStatus, string][] = [
    ['looking', 'Looking'],
    ['playing', 'Playing'],
    ['available_tonight', 'Tonight'],
    ['not_available', 'Away'],
  ];
  return (
    <Card pad={14}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 7 }}>
          <Label>YOUR STATUS</Label>
          <span className="grow" />
          <Dot color={toneColor(tone)} />
          <b className="ellipsis" style={{ fontSize: 14 }}>
            {label}
          </b>
        </div>
        <div className="wrap">
          {opts.map(([s, t]) => (
            <Chip key={s} on={me.status === s} onClick={() => onStatus(s)} h={34} padH={12}>
              {t}
            </Chip>
          ))}
        </div>
        <Label>DAYS I PLAY</Label>
        <div className="row" style={{ gap: 4 }}>
          {days.map((d) => (
            <span key={d} style={{ flex: 1, display: 'flex' }}>
              <Chip
                on={me.availableDays.includes(d)}
                onClick={() =>
                  onStatus(
                    me.status,
                    me.availableDays.includes(d)
                      ? me.availableDays.filter((x) => x !== d)
                      : [...me.availableDays, d],
                  )
                }
                h={34}
                padH={0}
                size={12}
              >
                <span style={{ width: '100%', minWidth: 30 }}>{dayLabel[d]}</span>
              </Chip>
            </span>
          ))}
        </div>
      </div>
    </Card>
  );
}

function MyListing({ l, onClose }: { l: Listing; onClose: () => void }) {
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
          <Pill h={42} size={14} expand look="clear" onClick={onClose} disabled={busy}>
            Close listing
          </Pill>
        </div>
      </div>
    </Card>
  );
}
