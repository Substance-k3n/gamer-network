'use client';

import { useRouter } from 'next/navigation';
import { useRef, useState, type ReactNode } from 'react';
import { api, query, uuid, type Comment, type Gg, type Page, type Post } from './api';
import { ago, postTypeInfo, rankLine, toneFor } from './data';
import { PhotoGrid, PollView, RecruitBox } from './postparts';
import { ReportDialog } from './safety';
import { useApp, useLoad } from './store';
import {
  Avatar,
  Dialog,
  GameBadge,
  Icon,
  Label,
  Pill,
  Spinner,
  TypeTag,
  keepFocus,
  toneColor,
  useConfirm,
  type IconName,
} from './ui';

// A timeline post as apps/mobile/lib/screens/home.dart draws it (FeedPost):
// avatar gutter, header, body, the action row, and its comments when open.

/** Copies the post's share link (the /p/<id> page). */
export async function sharePost(p: Post, toast: (m: string) => void) {
  try {
    await navigator.clipboard.writeText(p.shareUrl);
    toast('Link copied — paste it in Telegram or WhatsApp');
  } catch {
    toast(p.shareUrl);
  }
}

/** "Play" on a post: Find Players for its launch game, else the poster. */
function usePlay() {
  const { game } = useApp();
  const router = useRouter();
  return (p: Post) =>
    p.game && game(p.game.id).isLaunch
      ? router.push(`/app/find?game=${encodeURIComponent(p.game.id)}`)
      : router.push(`/app/players/${p.author.username}`);
}

/** The bordered "GG" mark of the action row. */
const GgBox = ({ color }: { color: string }) => (
  <span
    style={{
      border: `1.8px solid ${color}`,
      borderRadius: 5,
      padding: '1px 3px',
      fontSize: 10,
      fontWeight: 700,
      lineHeight: 1.2,
      color,
    }}
  >
    GG
  </span>
);

function Action({
  icon,
  label,
  onClick,
  on,
  aria,
}: {
  icon: IconName | 'gg';
  label: string;
  onClick: () => void;
  on?: boolean;
  aria: string;
}) {
  const c = on ? 'var(--acc)' : 'var(--muted)';
  return (
    <button
      type="button"
      className="row"
      onClick={onClick}
      aria-label={aria}
      aria-pressed={on}
      style={{
        height: 34,
        padding: '0 8px',
        gap: 6,
        background: 'none',
        border: 0,
        cursor: 'pointer',
        color: c,
        fontSize: 13,
        fontWeight: 500,
      }}
    >
      {icon === 'gg' ? <GgBox color={c} /> : <Icon name={icon} size={18} color={c} />}
      {label && <span>{label}</span>}
    </button>
  );
}

/** One timeline entry. `onChange` gets the post back after GG, save or a comment. */
export function FeedPost({
  p,
  onChange,
  onGone,
  openComments = false,
  openApplications = false,
  moderator = false,
}: {
  p: Post;
  onChange: (p: Post) => void;
  onGone: () => void;
  openComments?: boolean;
  /** Mine with recruitment: the applications sheet starts open (an alert). */
  openApplications?: boolean;
  /** A group admin looking at a post in their group: may delete it and its comments. */
  moderator?: boolean;
}) {
  const { run, toast } = useApp();
  const router = useRouter();
  const play = usePlay();
  const [open, setOpen] = useState(openComments);
  const [menu, setMenu] = useState(false);
  const a = p.author;
  const info = postTypeInfo(p.type);
  const big = p.kind === 'discussion' || p.kind === 'poll' || p.type === 'question';
  const top = p.topComment;
  const profile = () => router.push(`/app/players/${a.username}`);
  const rank = rankLine(a.topGame);

  const gg = async () => {
    const on = !p.myGG;
    // Show it at once; the API's count replaces the guess.
    onChange({ ...p, myGG: on, ggCount: p.ggCount + (on ? 1 : -1) });
    const r = await run(() => api<Gg>(`posts/${p.id}/gg`, { method: on ? 'PUT' : 'DELETE' }), {
      busy: false,
    });
    onChange(r ? { ...p, ...r } : p);
  };
  const save = async () => {
    const on = !p.saved;
    onChange({ ...p, saved: on });
    const ok = await run(
      () => api(`posts/${p.id}/save`, { method: on ? 'PUT' : 'DELETE' }).then(() => true),
      { busy: false },
    );
    if (!ok) return onChange(p);
    if (on) toast('Saved to your bookmarks');
  };

  return (
    <article
      className="row"
      style={{
        alignItems: 'flex-start',
        gap: 11,
        padding: '12px 14px 2px',
        borderBottom: '1.5px solid var(--divider)',
      }}
    >
      {menu && (
        <PostMenu p={p} moderator={moderator} onClose={() => setMenu(false)} onGone={onGone} />
      )}
      <Avatar
        name={a.displayName}
        tone={toneFor(a.id)}
        url={a.avatarUrl}
        size={42}
        onClick={profile}
      />
      <div className="grow gap" style={{ gap: 8 }}>
        <div className="gap" style={{ gap: 2 }}>
          <div className="row" style={{ gap: 5 }}>
            <button
              type="button"
              className="u ellipsis"
              onClick={profile}
              style={{ textDecoration: 'none', fontSize: 15, fontWeight: 700, flex: '0 1 auto' }}
            >
              {a.displayName}
            </button>
            <span className="grow muted ellipsis" style={{ fontSize: 14 }}>
              @{a.username} · {ago(p.createdAt)}
            </span>
            <button
              type="button"
              className="u muted"
              onClick={() => setMenu(true)}
              aria-label="Post options"
              style={{
                textDecoration: 'none',
                paddingLeft: 8,
                fontSize: 14,
                fontWeight: 700,
                letterSpacing: 1,
              }}
            >
              ···
            </button>
          </div>
          <div className="row" style={{ gap: '4px 6px', flexWrap: 'wrap' }}>
            {rank && (
              <span className="muted" style={{ fontSize: 12 }}>
                {rank}
              </span>
            )}
            <TypeTag bg={toneColor(info.tone)} size={8} pad="2px 7px">
              {p.type === 'discussion' ? 'GAME DISCUSSION' : info.label.toUpperCase()}
            </TypeTag>
            {p.game && <GameBadge pad="2px 7px">{p.game.shortCode}</GameBadge>}
            {p.audience === 'connections' && <Label size={8}>CONNECTIONS</Label>}
          </div>
        </div>
        <div
          style={{
            fontSize: big ? 19 : 15,
            fontWeight: big ? 700 : 400,
            lineHeight: 1.4,
            whiteSpace: 'pre-wrap',
            overflowWrap: 'anywhere',
          }}
        >
          {p.text}
        </div>
        <PhotoGrid media={p.media} />
        {p.poll && <PollView p={p} onChange={onChange} />}
        {p.recruit && <RecruitBox p={p} onChange={onChange} openApplications={openApplications} />}
        {top && (
          <button
            type="button"
            className="dashed row"
            onClick={() => setOpen(!open)}
            style={{
              borderRadius: 16,
              padding: '10px 12px',
              gap: 8,
              alignItems: 'flex-start',
              background: 'transparent',
              textAlign: 'left',
              cursor: 'pointer',
            }}
          >
            <b style={{ fontSize: 14, flex: 'none' }}>{top.author.displayName}</b>
            <span
              className="muted grow"
              style={{
                fontSize: 14,
                display: '-webkit-box',
                WebkitLineClamp: 3,
                WebkitBoxOrient: 'vertical',
                overflow: 'hidden',
                overflowWrap: 'anywhere',
              }}
            >
              {top.text}
            </span>
          </button>
        )}
        {/* Actions bleed 8px each side so icons line up with the text. */}
        <div className="row" style={{ justifyContent: 'space-between', margin: '0 -8px' }}>
          <Action
            icon="comment"
            label={`${p.commentCount}`}
            onClick={() => setOpen(!open)}
            on={open}
            aria={p.kind === 'discussion' ? 'Answers' : 'Comments'}
          />
          <Action icon="gg" label={`${p.ggCount}`} onClick={gg} on={p.myGG} aria="GG" />
          <Action icon="play" label={p.mine ? '' : 'Play'} onClick={() => play(p)} aria="Play" />
          <Action
            icon="bookmark"
            label=""
            onClick={save}
            on={p.saved}
            aria={p.saved ? 'Saved' : 'Save'}
          />
          <Action icon="share" label="" onClick={() => sharePost(p, toast)} aria="Share" />
        </div>
        {open && (
          <Comments
            p={p}
            moderator={moderator}
            onCount={(n) => onChange({ ...p, commentCount: Math.max(0, p.commentCount + n) })}
          />
        )}
      </div>
    </article>
  );
}

/** The ⋯ menu on a post: delete your own, report or block anyone else's. */
function PostMenu({
  p,
  moderator,
  onClose,
  onGone,
}: {
  p: Post;
  moderator: boolean;
  onClose: () => void;
  onGone: () => void;
}) {
  const { run, toast, bump } = useApp();
  const [mode, setMode] = useState<'menu' | 'report'>('menu');
  const [ask, confirm] = useConfirm();
  const a = p.author;
  const del = async () => {
    if (!(await ask('Delete this post?', 'It’s gone for everyone, with its comments.', 'Delete')))
      return onClose();
    const ok = await run(() => api(`posts/${p.id}`, { method: 'DELETE' }).then(() => true));
    onClose();
    if (!ok) return;
    toast('Post deleted');
    onGone();
  };
  const block = async () => {
    if (
      !(await ask(
        `Block ${a.displayName}?`,
        'You won’t see each other anywhere on rally. Any connection between you ends, and they aren’t told.',
        'Block',
      ))
    )
      return onClose();
    const ok = await run(() =>
      api('blocks', { method: 'POST', body: { userId: a.id } }).then(() => true),
    );
    onClose();
    if (!ok) return;
    toast(`${a.displayName} is blocked. You won’t see each other.`);
    // Their posts leave the feed on the reload.
    bump();
  };
  if (confirm) return confirm;
  if (mode === 'report')
    return <ReportDialog userId={a.id} name={a.displayName} postId={p.id} onClose={onClose} />;
  const item = (label: string, onClick: () => void, strong = false) => (
    <Pill h={48} size={15} bold expand look={strong ? 'strong' : 'clear'} onClick={onClick}>
      {label}
    </Pill>
  );
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>
        {p.mine ? 'Your post' : `Post by ${a.displayName}`}
      </div>
      {item('Copy link', () => sharePost(p, toast).then(onClose))}
      {p.mine ? (
        item('Delete post', del, true)
      ) : (
        <>
          {item('Report post', () => setMode('report'))}
          {item(`Block ${a.displayName}`, block, true)}
          {moderator && item('Delete post', del, true)}
        </>
      )}
      <Pill h={44} size={14} expand look="clear" onClick={onClose} style={{ border: 0 }}>
        Cancel
      </Pill>
    </Dialog>
  );
}

/** Comments under a post: top-level first, replies on "View n replies", and the write field. */
function Comments({
  p,
  moderator,
  onCount,
}: {
  p: Post;
  moderator: boolean;
  onCount: (n: number) => void;
}) {
  const { run, me } = useApp();
  const [more, setMore] = useState<string | null>(null);
  const [replyTo, setReplyTo] = useState<Comment | null>(null);
  const [text, setText] = useState('');
  const [replies, setReplies] = useState<Record<string, Comment[]>>({});
  const input = useRef<HTMLInputElement>(null);
  const disc = p.kind === 'discussion';
  const sort = disc ? 'top' : undefined;
  const list = useLoad(async () => {
    const pg = await api<Page<Comment>>(`posts/${p.id}/comments${query({ sort, limit: 50 })}`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [p.id]);
  const top = list.data ?? [];

  const loadMore = async () => {
    const pg = await run(
      () => api<Page<Comment>>(`posts/${p.id}/comments${query({ sort, limit: 50, cursor: more })}`),
      { busy: false },
    );
    if (!pg) return;
    list.setData([...top, ...pg.items.filter((x) => !top.some((y) => y.id === x.id))]);
    setMore(pg.nextCursor);
  };
  const loadReplies = async (c: Comment) => {
    const pg = await run(() => api<Page<Comment>>(`comments/${c.id}/replies?limit=50`), {
      busy: false,
    });
    if (pg) setReplies((r) => ({ ...r, [c.id]: pg.items }));
  };
  const reply = (c: Comment) => {
    setReplyTo(c);
    setText(`@${c.author.username} `);
    input.current?.focus();
  };
  const send = async () => {
    const body = text.trim();
    if (!body) return;
    // A reply to a reply attaches to the same top-level comment.
    const parentId = replyTo ? (replyTo.parentId ?? replyTo.id) : undefined;
    const c = await run(() =>
      api<Comment>(`posts/${p.id}/comments`, {
        method: 'POST',
        key: uuid(),
        body: { text: body, ...(parentId ? { parentId } : {}) },
      }),
    );
    if (!c) return;
    setText('');
    setReplyTo(null);
    onCount(1);
    if (c.parentId) {
      const pid = c.parentId;
      setReplies((r) => ({ ...r, [pid]: [...(r[pid] ?? []), c] }));
      list.setData(top.map((t) => (t.id === pid ? { ...t, replies: t.replies + 1 } : t)));
    } else list.setData([...top, c]);
  };
  const update = (c: Comment) => {
    if (c.parentId) {
      const pid = c.parentId;
      setReplies((r) => ({ ...r, [pid]: (r[pid] ?? []).map((x) => (x.id === c.id ? c : x)) }));
    } else list.setData(top.map((t) => (t.id === c.id ? c : t)));
  };
  const gone = (c: Comment) => {
    if (c.parentId) {
      const pid = c.parentId;
      setReplies((r) => ({ ...r, [pid]: (r[pid] ?? []).filter((x) => x.id !== c.id) }));
      list.setData(top.map((t) => (t.id === pid ? { ...t, replies: t.replies - 1 } : t)));
      onCount(-1);
    } else {
      list.setData(top.filter((t) => t.id !== c.id));
      onCount(-1 - c.replies);
    }
  };

  const indent = (children: ReactNode, key?: string) => (
    <div key={key} style={{ paddingLeft: 39 }}>
      {children}
    </div>
  );
  return (
    <div style={{ paddingBottom: 6 }}>
      <div style={{ borderTop: 'var(--dash-w) dashed var(--dash)', marginBottom: 10 }} />
      <div className="gap" style={{ gap: 10 }}>
        {!list.loaded && (
          <div style={{ transform: 'scale(.8)', margin: '-34px 0' }}>
            <Spinner />
          </div>
        )}
        {top.map((c) => (
          <div key={c.id} className="gap" style={{ gap: 10 }}>
            <CommentRow
              c={c}
              post={p}
              moderator={moderator}
              onChange={update}
              onGone={() => gone(c)}
              onReply={() => reply(c)}
            />
            {c.replies > 0 &&
              !replies[c.id] &&
              indent(
                <button
                  type="button"
                  className="u muted"
                  style={{ textDecoration: 'none', fontSize: 12, fontWeight: 700 }}
                  onClick={() => loadReplies(c)}
                >
                  View {c.replies} {c.replies === 1 ? 'reply' : 'replies'}
                </button>,
              )}
            {(replies[c.id] ?? []).map((r) =>
              indent(
                <CommentRow
                  c={r}
                  post={p}
                  moderator={moderator}
                  onChange={update}
                  onGone={() => gone(r)}
                  onReply={() => reply(r)}
                />,
                r.id,
              ),
            )}
          </div>
        ))}
        {more && (
          <button
            type="button"
            className="u"
            style={{ fontSize: 13, fontWeight: 700, alignSelf: 'center' }}
            onClick={loadMore}
          >
            More comments
          </button>
        )}
        {replyTo && (
          <div className="row" style={{ gap: 8 }} {...keepFocus}>
            <span className="grow muted" style={{ fontSize: 12 }}>
              Replying to {replyTo.author.displayName}
            </span>
            <button
              type="button"
              className="u"
              style={{ fontSize: 12, fontWeight: 700 }}
              onClick={() => {
                setReplyTo(null);
                setText('');
              }}
            >
              Cancel
            </button>
          </div>
        )}
        <div
          className="row"
          {...keepFocus}
          style={{
            gap: 8,
            padding: '4px 4px 4px 5px',
            background: 'var(--surface)',
            border: 'var(--line-w) solid var(--line)',
            borderRadius: 99,
          }}
        >
          <Avatar name={me?.displayName ?? '?'} tone="accent" url={me?.avatarUrl} size={28} />
          <input
            ref={input}
            className="grow"
            value={text}
            onChange={(e) => setText(e.target.value.slice(0, 500))}
            onKeyDown={(e) => e.key === 'Enter' && send()}
            placeholder={disc ? 'Add your answer…' : 'Write a comment…'}
            aria-label={disc ? 'Answer' : 'Comment'}
            style={{
              border: 0,
              outline: 0,
              background: 'transparent',
              color: 'var(--text)',
              font: 'inherit',
              fontSize: 16,
              minWidth: 0,
            }}
          />
          <Pill h={30} padH={13} look="ink" onClick={send} style={{ border: 0 }}>
            Send
          </Pill>
        </div>
      </div>
    </div>
  );
}

function CommentRow({
  c,
  post,
  moderator,
  onChange,
  onGone,
  onReply,
}: {
  c: Comment;
  post: Post;
  moderator: boolean;
  onChange: (c: Comment) => void;
  onGone: () => void;
  onReply: () => void;
}) {
  const { run, toast } = useApp();
  const router = useRouter();
  const [ask, confirm] = useConfirm();
  const [report, setReport] = useState(false);
  const a = c.author;
  const profile = () => router.push(`/app/players/${a.username}`);
  const gg = async () => {
    const on = !c.myGG;
    onChange({ ...c, myGG: on, ggCount: c.ggCount + (on ? 1 : -1) });
    const r = await run(() => api<Gg>(`comments/${c.id}/gg`, { method: on ? 'PUT' : 'DELETE' }), {
      busy: false,
    });
    onChange(r ? { ...c, ...r } : c);
  };
  const del = async () => {
    if (
      !(await ask(
        'Delete this comment?',
        !c.parentId && c.replies > 0 ? 'Its replies go with it.' : 'It’s gone for everyone.',
        'Delete',
      ))
    )
      return;
    const ok = await run(() => api(`comments/${c.id}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    toast('Comment deleted');
    onGone();
  };
  const link = (label: string, onClick: () => void, color?: string) => (
    <button
      type="button"
      className="u"
      onClick={onClick}
      style={{ textDecoration: 'none', fontSize: 12, fontWeight: 700, color }}
    >
      {label}
    </button>
  );
  return (
    <div className="row" style={{ gap: 9, alignItems: 'flex-start' }}>
      {confirm}
      {report && (
        <ReportDialog
          userId={a.id}
          name={a.displayName}
          commentId={c.id}
          onClose={() => setReport(false)}
        />
      )}
      <Avatar
        name={a.displayName}
        tone={toneFor(a.id)}
        url={a.avatarUrl}
        size={30}
        onClick={profile}
      />
      <div className="grow gap" style={{ gap: 4 }}>
        <div
          style={{
            padding: '7px 11px',
            background: 'var(--sunken)',
            border: '1.5px solid var(--line)',
            borderRadius: '4px 16px 16px 16px',
          }}
        >
          <div className="row" style={{ justifyContent: 'space-between', gap: 8 }}>
            <button
              type="button"
              className="u ellipsis"
              onClick={profile}
              style={{ textDecoration: 'none', fontSize: 13, fontWeight: 700 }}
            >
              {c.mine ? `${a.displayName} (you)` : a.displayName}
            </button>
            <span className="digits muted" style={{ fontSize: 8, flex: 'none' }}>
              {ago(c.createdAt)}
            </span>
          </div>
          <div
            style={{
              fontSize: 14,
              lineHeight: 1.35,
              marginTop: 2,
              whiteSpace: 'pre-wrap',
              overflowWrap: 'anywhere',
            }}
          >
            {c.text}
          </div>
        </div>
        <div className="row" style={{ gap: 12, paddingLeft: 6 }}>
          {link(`GG ${c.ggCount}`, gg, c.myGG ? 'var(--acc)' : undefined)}
          {link('Reply', onReply)}
          {c.mine || post.mine || moderator
            ? link('Delete', del, 'var(--muted)')
            : link('Report', () => setReport(true), 'var(--muted)')}
        </div>
      </div>
    </div>
  );
}
