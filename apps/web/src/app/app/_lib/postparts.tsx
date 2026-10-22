'use client';

import Link from 'next/link';
import { useEffect, useRef, useState } from 'react';
import {
  api,
  uuid,
  type ApplicationStatus,
  type Media,
  type Page,
  type Poll,
  type Post,
  type Recruit,
  type RecruitApplication,
} from './api';
import { pad2, rankLine, toneFor } from './data';
import { useApp, useLoad } from './store';
import { Avatar, CircleBtn, Digits, Icon, Label, Pill, Sheet, Spinner, TypeTag } from './ui';

// What a post can carry beyond text (phases 2–3): photos, a poll, a
// recruitment box. Laid out as the prototype's FeedPost does (D23).

/** After a refused vote or apply, the post as the API has it now. */
async function refresh(p: Post, onChange: (p: Post) => void) {
  try {
    onChange(await api<Post>(`posts/${p.id}`));
  } catch {}
}

/**
 * One photo 220 tall at full width; 2–4 in a 2-column grid of 140,
 * cover-cropped. A tap opens them full screen (unless `still`).
 */
export function PhotoGrid({ media, still }: { media: Media[]; still?: boolean }) {
  const [open, setOpen] = useState<number | null>(null);
  if (!media.length) return null;
  const one = media.length === 1;
  return (
    <>
      {open !== null && <PhotoViewer media={media} start={open} onClose={() => setOpen(null)} />}
      <div style={{ display: 'grid', gridTemplateColumns: one ? '1fr' : '1fr 1fr', gap: 6 }}>
        {media.map((m, i) => (
          <button
            key={m.id}
            type="button"
            onClick={
              still
                ? undefined
                : (e) => {
                    e.preventDefault();
                    setOpen(i);
                  }
            }
            aria-label={still ? undefined : `Open photo ${i + 1} of ${media.length}`}
            tabIndex={still ? -1 : undefined}
            style={{
              height: one ? 220 : 140,
              padding: 0,
              overflow: 'hidden',
              background: 'var(--dark)',
              border: 'var(--line-w) solid var(--line)',
              borderRadius: 16,
              cursor: still ? 'inherit' : 'zoom-in',
              minWidth: 0,
            }}
          >
            {/* eslint-disable-next-line @next/next/no-img-element -- signed storage URL */}
            <img
              src={m.url}
              alt=""
              loading="lazy"
              style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
            />
          </button>
        ))}
      </div>
    </>
  );
}

/** Full screen: one photo at a time, arrows or keys to move, Esc to close. Stops at the first and last (D38). */
function PhotoViewer({
  media,
  start,
  onClose,
}: {
  media: Media[];
  start: number;
  onClose: () => void;
}) {
  const [i, setI] = useState(start);
  const n = media.length;
  const from = useRef<number | null>(null);
  const swiped = useRef(false);
  useEffect(() => {
    const key = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
      else if (e.key === 'ArrowRight') setI((x) => Math.min(x + 1, n - 1));
      else if (e.key === 'ArrowLeft') setI((x) => Math.max(x - 1, 0));
    };
    window.addEventListener('keydown', key);
    return () => window.removeEventListener('keydown', key);
  }, [n, onClose]);
  const nav = (d: number, label: string) => (
    <CircleBtn
      size={40}
      onDark
      disabled={d > 0 ? i >= n - 1 : i <= 0}
      onClick={() => setI((x) => Math.min(Math.max(x + d, 0), n - 1))}
      label={label}
    >
      <span style={{ display: 'flex', transform: d > 0 ? 'rotate(180deg)' : undefined }}>
        <Icon name="back" size={18} />
      </span>
    </CircleBtn>
  );
  return (
    <div
      role="dialog"
      aria-modal
      aria-label="Photo"
      onClick={() => (swiped.current ? (swiped.current = false) : onClose())}
      // A swipe moves to the next or previous photo (D35); a tap still closes.
      onPointerDown={(e) => (from.current = e.clientX)}
      onPointerUp={(e) => {
        const dx = e.clientX - (from.current ?? e.clientX);
        from.current = null;
        if (Math.abs(dx) > 50 && n > 1) {
          swiped.current = true;
          setI((x) => Math.min(Math.max(x + (dx < 0 ? 1 : -1), 0), n - 1));
        }
      }}
      onPointerCancel={() => (from.current = null)}
      style={{
        touchAction: 'pan-y',
        position: 'fixed',
        inset: 0,
        zIndex: 70,
        background: 'rgba(0, 0, 0, 0.92)',
        color: '#fff',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        animation: 'fade .18s ease',
      }}
    >
      {/* eslint-disable-next-line @next/next/no-img-element -- signed storage URL */}
      <img
        src={media[i]!.url}
        alt=""
        onClick={(e) => e.stopPropagation()}
        style={{ maxWidth: '100%', maxHeight: '100%', objectFit: 'contain' }}
      />
      <div
        className="row"
        onClick={(e) => e.stopPropagation()}
        style={
          {
            position: 'absolute',
            top: 'calc(12px + env(safe-area-inset-top))',
            left: 12,
            right: 12,
            justifyContent: 'space-between',
            '--on-dark': '#fff',
            '--on-dark-line': 'rgba(255,255,255,.6)',
          } as React.CSSProperties
        }
      >
        <span className="digits" style={{ fontSize: 13 }}>
          {n > 1 ? `${pad2(i + 1)}/${pad2(n)}` : ''}
        </span>
        <CircleBtn size={40} onDark onClick={onClose} label="Close">
          <Icon name="close" size={18} />
        </CircleBtn>
      </div>
      {n > 1 && (
        <div
          className="row"
          onClick={(e) => e.stopPropagation()}
          style={
            {
              position: 'absolute',
              bottom: 'calc(20px + env(safe-area-inset-bottom))',
              gap: 16,
              '--on-dark': '#fff',
              '--on-dark-line': 'rgba(255,255,255,.6)',
            } as React.CSSProperties
          }
        >
          {nav(-1, 'Previous photo')}
          {nav(1, 'Next photo')}
        </div>
      )}
    </div>
  );
}

/** "2 DAYS", "5 HOURS", "30 MIN": how long a poll still runs, in its largest whole unit (D29). */
function endsIn(iso: string) {
  const m = Math.max(1, Math.floor((new Date(iso).getTime() - Date.now()) / 60000));
  const n = (k: number, one: string, many: string) => `${k} ${k === 1 ? one : many}`;
  if (m >= 1440) return n(Math.floor(m / 1440), 'DAY', 'DAYS');
  if (m >= 60) return n(Math.floor(m / 60), 'HOUR', 'HOURS');
  return `${m} MIN`;
}

/** Options; the bars show once I've voted, and to everyone once it's closed (D29). */
export function PollView({ p, onChange }: { p: Post; onChange: (p: Post) => void }) {
  const { run } = useApp();
  const [sending, setSending] = useState(false);
  const pl = p.poll!;
  const voted = pl.myVote !== null;
  const bars = voted || pl.closed;
  const vote = async (position: number) => {
    if (voted || pl.closed || sending) return;
    setSending(true);
    const r = await run(
      () => api<Poll>(`posts/${p.id}/vote`, { method: 'POST', body: { position } }),
      { busy: false },
    );
    setSending(false);
    if (r) onChange({ ...p, poll: r });
    else refresh(p, onChange);
  };
  return (
    <div className="gap" style={{ gap: 7 }}>
      {pl.options.map((o) => {
        const pct = Math.round((o.votes / Math.max(1, pl.totalVotes)) * 100);
        const mine = pl.myVote === o.position;
        return (
          <button
            key={o.position}
            type="button"
            onClick={() => vote(o.position)}
            disabled={bars}
            aria-pressed={mine}
            style={{
              position: 'relative',
              height: 42,
              padding: 0,
              overflow: 'hidden',
              background: 'var(--surface)',
              border: 'var(--line-w) solid var(--line)',
              borderRadius: 14,
              cursor: bars ? 'default' : 'pointer',
              color: 'var(--text)',
              textAlign: 'left',
            }}
          >
            <i
              style={{
                position: 'absolute',
                inset: 0,
                width: bars ? `${pct}%` : 0,
                background: mine ? 'var(--poll-mine)' : 'var(--soft)',
                transition: 'width .5s ease',
              }}
            />
            <span
              className="row"
              style={{
                position: 'relative',
                height: '100%',
                padding: '0 12px',
                gap: 8,
                justifyContent: 'space-between',
              }}
            >
              <span className="ellipsis" style={{ fontSize: 14, fontWeight: 600 }}>
                {o.label}
                {mine ? '  ✓' : ''}
              </span>
              {bars && <Digits size={11}>{pad2(pct)}%</Digits>}
            </span>
          </button>
        );
      })}
      <Label style={{ paddingLeft: 4 }}>
        {pl.totalVotes} {pl.totalVotes === 1 ? 'VOTE' : 'VOTES'} ·{' '}
        {pl.closed ? 'CLOSED' : voted ? 'YOU VOTED' : `ENDS IN ${endsIn(pl.endsAt)}`}
      </Label>
    </div>
  );
}

/** SLOTS, ROLES NEEDED, and Apply (or, on mine, the applications). */
export function RecruitBox({
  p,
  onChange,
  openApplications = false,
}: {
  p: Post;
  onChange: (p: Post) => void;
  openApplications?: boolean;
}) {
  const { run, toast } = useApp();
  const [list, setList] = useState(openApplications && p.mine);
  const [key] = useState(uuid);
  const r = p.recruit!;
  const apply = async () => {
    if (p.mine) return setList(true);
    if (r.myApplication) return;
    const res = await run(() => api<Recruit>(`posts/${p.id}/apply`, { method: 'POST', key }));
    if (res) {
      onChange({ ...p, recruit: res });
      toast(`Applied — ${p.author.displayName} gets a notification`);
    } else refresh(p, onChange);
  };
  const done = p.mine || !!r.myApplication;
  return (
    <>
      {list && <ApplicationsSheet p={p} onClose={() => setList(false)} />}
      <div
        className="row"
        style={{
          gap: 12,
          padding: '10px 12px',
          background: 'var(--soft)',
          border: 'var(--line-w) solid var(--line)',
          borderRadius: 16,
          flexWrap: 'wrap',
        }}
      >
        <div style={{ textAlign: 'center', flex: 'none' }}>
          <Digits size={22}>{r.slots}</Digits>
          <div style={{ marginTop: 3 }}>
            <Label size={8}>SLOTS</Label>
          </div>
        </div>
        <div className="grow" style={{ minWidth: 100 }}>
          <Label>ROLES NEEDED</Label>
          <div style={{ fontSize: 14, fontWeight: 700, marginTop: 2, overflowWrap: 'anywhere' }}>
            {r.roles || 'Any role'}
          </div>
        </div>
        <Pill h={36} padH={14} bold look={done ? 'strong' : 'accent'} onClick={apply}>
          {p.mine
            ? `Yours · ${r.applications} applied`
            : r.myApplication === 'accepted'
              ? 'Accepted ✓'
              : r.myApplication
                ? 'Applied ✓'
                : 'Apply'}
        </Pill>
      </div>
    </>
  );
}

/** The author's list of applicants: Accept or Decline each. */
function ApplicationsSheet({ p, onClose }: { p: Post; onClose: () => void }) {
  const { run, toast } = useApp();
  const [more, setMore] = useState<string | null>(null);
  const [answering, setAnswering] = useState<string | null>(null);
  const list = useLoad(async () => {
    const pg = await api<Page<RecruitApplication>>(`posts/${p.id}/applications?limit=50`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [p.id]);
  const items = list.data ?? [];
  const loadMore = async () => {
    const pg = await run(
      () =>
        api<Page<RecruitApplication>>(
          `posts/${p.id}/applications?limit=50&cursor=${encodeURIComponent(more!)}`,
        ),
      { busy: false },
    );
    if (!pg) return;
    list.setData([...items, ...pg.items]);
    setMore(pg.nextCursor);
  };
  const answer = async (a: RecruitApplication, to: 'accept' | 'decline') => {
    setAnswering(a.id);
    const r = await run(
      () =>
        api<{ id: string; status: ApplicationStatus }>(`recruit-applications/${a.id}/${to}`, {
          method: 'POST',
        }),
      { busy: false },
    );
    setAnswering(null);
    if (!r) return;
    list.setData(items.map((x) => (x.id === a.id ? { ...x, status: r.status } : x)));
    toast(
      r.status === 'accepted'
        ? `Accepted — ${a.user.displayName} can see your gamer ID`
        : 'Declined',
    );
  };
  return (
    <Sheet onClose={onClose}>
      <div className="row" style={{ justifyContent: 'space-between', marginBottom: 10 }}>
        <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>Applications</div>
        <CircleBtn size={36} onClick={onClose} label="Close">
          <Icon name="close" size={16} />
        </CircleBtn>
      </div>
      <Label style={{ paddingLeft: 6 }}>
        {p.recruit!.slots} {p.recruit!.slots === 1 ? 'SLOT' : 'SLOTS'} ·{' '}
        {p.recruit!.roles.trim() ? p.recruit!.roles.toUpperCase() : 'ANY ROLE'}
      </Label>
      <div className="gap" style={{ gap: 8, marginTop: 10 }}>
        {!list.loaded && <Spinner />}
        {list.loaded && items.length === 0 && (
          <div className="dashed muted" style={{ padding: 18, textAlign: 'center', fontSize: 14 }}>
            No applications yet. They show up here.
          </div>
        )}
        {items.length > 0 && (
          <div className="rows">
            {items.map((a) => (
              <div key={a.id} className="r" style={{ flexWrap: 'wrap' }}>
                <Link
                  href={`/app/players/${a.user.username}`}
                  className="row"
                  style={{ gap: 12, flex: '1 1 130px', minWidth: 0 }}
                >
                  <Avatar
                    name={a.user.displayName}
                    tone={toneFor(a.user.id)}
                    url={a.user.avatarUrl}
                    size={38}
                  />
                  <span style={{ flex: 1, minWidth: 0 }}>
                    <b className="ellipsis" style={{ display: 'block', fontSize: 15 }}>
                      {a.user.displayName}
                    </b>
                    <span className="muted ellipsis" style={{ display: 'block', fontSize: 12 }}>
                      {rankLine(a.user.topGame) || `@${a.user.username}`}
                    </span>
                  </span>
                </Link>
                {a.status === 'pending' ? (
                  <span className="row" style={{ gap: 6, marginLeft: 'auto' }}>
                    <Pill
                      h={34}
                      padH={12}
                      look="clear"
                      onClick={() => answer(a, 'decline')}
                      disabled={answering === a.id}
                    >
                      Decline
                    </Pill>
                    <Pill
                      h={34}
                      padH={12}
                      bold
                      look="accent"
                      onClick={() => answer(a, 'accept')}
                      disabled={answering === a.id}
                    >
                      Accept
                    </Pill>
                  </span>
                ) : (
                  // The author may change the answer by tapping the tag (D24).
                  <button
                    type="button"
                    onClick={() =>
                      answering !== a.id &&
                      answer(a, a.status === 'accepted' ? 'decline' : 'accept')
                    }
                    aria-label={
                      a.status === 'accepted'
                        ? 'Accepted, tap to decline'
                        : 'Declined, tap to accept'
                    }
                    style={{
                      marginLeft: 'auto',
                      padding: 0,
                      background: 'none',
                      border: 0,
                      cursor: 'pointer',
                    }}
                  >
                    <TypeTag bg={a.status === 'accepted' ? 'var(--accent)' : 'var(--grey)'}>
                      {a.status === 'accepted' ? 'ACCEPTED' : 'DECLINED'}
                    </TypeTag>
                  </button>
                )}
              </div>
            ))}
          </div>
        )}
        {more && (
          <div style={{ textAlign: 'center' }}>
            <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
              Load more
            </Pill>
          </div>
        )}
      </div>
    </Sheet>
  );
}
