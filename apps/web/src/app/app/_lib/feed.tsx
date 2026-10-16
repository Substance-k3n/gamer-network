'use client';

import { useRouter } from 'next/navigation';
import { useMemo, useState } from 'react';
import {
  api,
  query,
  uuid,
  type Comment,
  type FeedFilter,
  type Gg,
  type Page,
  type Post,
  type PostAudience,
  type PostType,
  type Profile,
} from './api';
import { ago, postTypeLabel, postTypes, rankLine, toneFor } from './data';
import { ReportDialog } from './safety';
import { Group, SheetTitle } from './sheets';
import { useApp, useLoad } from './store';
import {
  Avatar,
  BigButton,
  Card,
  Chip,
  Dialog,
  EmptyNote,
  Icon,
  Label,
  Pill,
  Segmented,
  Sheet,
  TextArea,
  useConfirm,
} from './ui';

// The Home feed (docs/FEED_AND_GROUPS_API.md, phase 1): post cards,
// comments under them, and the composer. Shown when config.feedEnabled.

export async function sharePost(p: Post, toast: (m: string) => void) {
  try {
    if (navigator.share)
      return await navigator.share({ title: 'A post on rally', url: p.shareUrl });
    await navigator.clipboard.writeText(p.shareUrl);
    toast('Link copied — paste it in Telegram or WhatsApp');
  } catch {}
}

/** GG count and toggle, shared by posts and comments. */
function GgButton({
  path,
  gg,
  onChange,
  small,
}: {
  path: string;
  gg: Gg;
  onChange: (g: Gg) => void;
  small?: boolean;
}) {
  const { run } = useApp();
  const toggle = async () => {
    const next = { ggCount: gg.ggCount + (gg.myGG ? -1 : 1), myGG: !gg.myGG };
    onChange(next);
    const r = await run(() => api<Gg>(path, { method: gg.myGG ? 'DELETE' : 'PUT' }), {
      busy: false,
    });
    onChange(r ?? gg);
  };
  return (
    <Pill
      h={small ? 28 : 36}
      padH={small ? 9 : 12}
      size={small ? 12 : 13}
      bold
      look={gg.myGG ? 'accent' : 'clear'}
      onClick={toggle}
      label={gg.myGG ? 'Take back GG' : 'GG'}
    >
      GG{gg.ggCount > 0 && <span> {gg.ggCount}</span>}
    </Pill>
  );
}

/** One post: header, text, the action row, and its comments when opened. */
export function PostCard({
  p,
  onChange,
  onGone,
  openComments = false,
}: {
  p: Post;
  onChange: (p: Post) => void;
  onGone: () => void;
  openComments?: boolean;
}) {
  const { run, toast, setSheet } = useApp();
  const router = useRouter();
  const [comments, setComments] = useState(openComments);
  const [menu, setMenu] = useState(false);
  const a = p.author;
  const discussion = p.kind === 'discussion';
  const profile = () => router.push(`/app/players/${a.username}`);

  const save = async () => {
    onChange({ ...p, saved: !p.saved });
    const ok = await run(
      () => api(`posts/${p.id}/save`, { method: p.saved ? 'DELETE' : 'PUT' }).then(() => true),
      { busy: false },
    );
    if (!ok) onChange(p);
    else toast(p.saved ? 'Removed from saved' : 'Saved');
  };
  /** Play: an invite when connected, otherwise a connection request (the API decides nothing here). */
  const play = async () => {
    const them = await run(() => api<Profile>(`users/${a.username}`), { busy: false });
    if (!them) return;
    if (them.relationship === 'connected') {
      setSheet({
        kind: 'invite',
        userId: a.id,
        name: a.displayName,
        games: them.games.flatMap((g) => (g.game ? [g.game.id] : [])),
      });
    } else if (them.relationship === 'outgoing_request') {
      toast(`You already asked ${a.displayName} to connect`);
    } else if (them.relationship === 'incoming_request') {
      router.push('/app/alerts');
    } else {
      const r = await run(() =>
        api('connection-requests', { method: 'POST', key: uuid(), body: { toUserId: a.id } }),
      );
      if (r !== null) toast(`Request sent — you can play once ${a.displayName} accepts`);
    }
  };

  return (
    <Card pad={14}>
      {menu && <PostMenu p={p} onClose={() => setMenu(false)} onGone={onGone} />}
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 10, alignItems: 'flex-start' }}>
          <Avatar
            name={a.displayName}
            tone={toneFor(a.id)}
            url={a.avatarUrl}
            size={42}
            onClick={profile}
          />
          <div className="grow" style={{ minWidth: 0 }}>
            <button
              type="button"
              className="u"
              onClick={profile}
              style={{ textDecoration: 'none', textAlign: 'left' }}
            >
              <b style={{ fontSize: 15 }}>{a.displayName}</b>{' '}
              <span className="muted" style={{ fontSize: 13 }}>
                @{a.username} · {ago(p.createdAt)}
              </span>
            </button>
            <div className="muted ellipsis" style={{ fontSize: 12 }}>
              {[
                rankLine(a.topGame),
                p.game && p.game.id !== a.topGame?.game?.id ? p.game.name : null,
              ]
                .filter(Boolean)
                .join(' · ')}
            </div>
          </div>
          <span
            style={{
              fontSize: 10,
              fontWeight: 800,
              letterSpacing: 0.6,
              padding: '3px 7px',
              borderRadius: 7,
              border: '1.5px solid var(--line)',
              background: discussion ? 'var(--lav)' : 'var(--soft)',
              color: 'var(--ink)',
              flex: 'none',
            }}
          >
            {postTypeLabel(p.type)}
          </span>
        </div>

        <div
          style={{
            fontSize: discussion ? 20 : 15,
            fontWeight: discussion ? 800 : 500,
            letterSpacing: discussion ? -0.5 : 0,
            lineHeight: discussion ? 1.2 : 1.4,
            whiteSpace: 'pre-wrap',
            overflowWrap: 'anywhere',
          }}
        >
          {p.text}
        </div>
        {p.audience === 'connections' && <Label size={8}>CONNECTIONS ONLY</Label>}

        {discussion && p.topComment && !comments && (
          <button
            type="button"
            className="dashed"
            onClick={() => setComments(true)}
            style={{
              padding: '10px 12px',
              textAlign: 'left',
              background: 'transparent',
              color: 'inherit',
            }}
          >
            <Label size={8}>TOP ANSWER · {p.topComment.author.displayName.toUpperCase()}</Label>
            <div style={{ fontSize: 14, lineHeight: 1.35, marginTop: 4, overflowWrap: 'anywhere' }}>
              {p.topComment.text}
            </div>
          </button>
        )}

        <div className="row" style={{ gap: 6, flexWrap: 'wrap' }}>
          <Pill
            h={36}
            padH={12}
            size={13}
            look={comments ? 'strong' : 'clear'}
            onClick={() => setComments(!comments)}
            label="Comments"
          >
            <Icon name="comment" size={16} />
            {p.commentCount > 0 && <span>{p.commentCount}</span>}
            {discussion && <span>{p.commentCount === 1 ? 'answer' : 'answers'}</span>}
          </Pill>
          <GgButton
            path={`posts/${p.id}/gg`}
            gg={{ ggCount: p.ggCount, myGG: p.myGG }}
            onChange={(g) => onChange({ ...p, ...g })}
          />
          {!p.mine && (
            <Pill h={36} padH={12} size={13} bold onClick={play}>
              <Icon name="play" size={14} /> Play
            </Pill>
          )}
          <span className="grow" />
          <button
            type="button"
            className="circle"
            style={{ width: 36, height: 36 }}
            onClick={save}
            aria-label={p.saved ? 'Unsave' : 'Save'}
            aria-pressed={p.saved}
          >
            <Icon name="bookmark" size={17} color={p.saved ? 'var(--acc)' : undefined} />
          </button>
          <button
            type="button"
            className="circle"
            style={{ width: 36, height: 36 }}
            onClick={() => sharePost(p, toast)}
            aria-label="Share"
          >
            <Icon name="share" size={17} />
          </button>
          <button
            type="button"
            className="circle"
            style={{ width: 36, height: 36 }}
            onClick={() => setMenu(true)}
            aria-label="More"
          >
            <Icon name="more" size={17} />
          </button>
        </div>

        {comments && (
          <Comments
            p={p}
            onCount={(n) => onChange({ ...p, commentCount: Math.max(0, p.commentCount + n) })}
          />
        )}
      </div>
    </Card>
  );
}

/** ⋯ on a post: delete your own, or report and share someone else's. */
function PostMenu({ p, onClose, onGone }: { p: Post; onClose: () => void; onGone: () => void }) {
  const { run, toast } = useApp();
  const [mode, setMode] = useState<'menu' | 'report'>('menu');
  const [ask, confirm] = useConfirm();
  const del = async () => {
    if (!(await ask('Delete this post?', 'It’s gone for everyone, with its comments.', 'Delete')))
      return;
    const ok = await run(() => api(`posts/${p.id}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    toast('Post deleted');
    onClose();
    onGone();
  };
  if (confirm) return confirm;
  if (mode === 'report')
    return (
      <ReportDialog
        userId={p.author.id}
        name={p.author.displayName}
        postId={p.id}
        onClose={onClose}
      />
    );
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>Post</div>
      <Pill
        h={48}
        size={15}
        bold
        expand
        look="clear"
        onClick={() => sharePost(p, toast).then(onClose)}
      >
        Copy share link
      </Pill>
      {p.mine ? (
        <Pill h={48} size={15} bold expand look="strong" onClick={del}>
          Delete post
        </Pill>
      ) : (
        <Pill h={48} size={15} bold expand look="clear" onClick={() => setMode('report')}>
          Report post
        </Pill>
      )}
      <Pill h={44} size={14} expand look="clear" onClick={onClose} style={{ border: 0 }}>
        Cancel
      </Pill>
    </Dialog>
  );
}

/** Comments under a post: top-level first, replies on demand, and the write field. */
function Comments({ p, onCount }: { p: Post; onCount: (n: number) => void }) {
  const { run, me } = useApp();
  const [more, setMore] = useState<string | null>(null);
  const [replyTo, setReplyTo] = useState<Comment | null>(null);
  const [text, setText] = useState('');
  const [sending, setSending] = useState(false);
  const [key, setKey] = useState(uuid);
  const [replies, setReplies] = useState<Record<string, Comment[]>>({});
  const sort = p.kind === 'discussion' ? 'top' : undefined;
  const list = useLoad(async () => {
    const pg = await api<Page<Comment>>(`posts/${p.id}/comments${query({ sort })}`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [p.id]);
  const top = list.data ?? [];

  const loadMore = async () => {
    const pg = await run(
      () => api<Page<Comment>>(`posts/${p.id}/comments${query({ sort, cursor: more })}`),
      { busy: false },
    );
    if (!pg) return;
    list.setData([...top, ...pg.items]);
    setMore(pg.nextCursor);
  };
  const loadReplies = async (c: Comment) => {
    const pg = await run(() => api<Page<Comment>>(`comments/${c.id}/replies?limit=50`), {
      busy: false,
    });
    if (pg) setReplies({ ...replies, [c.id]: pg.items });
  };
  const send = async () => {
    const body = text.trim();
    if (!body || sending) return;
    setSending(true);
    const c = await run(
      () =>
        api<Comment>(`posts/${p.id}/comments`, {
          method: 'POST',
          key,
          body: { text: body, ...(replyTo ? { parentId: replyTo.id } : {}) },
        }),
      { busy: false },
    );
    setSending(false);
    if (!c) return;
    setText('');
    setKey(uuid());
    setReplyTo(null);
    onCount(1);
    if (c.parentId) {
      setReplies({ ...replies, [c.parentId]: [...(replies[c.parentId] ?? []), c] });
      list.setData(top.map((t) => (t.id === c.parentId ? { ...t, replies: t.replies + 1 } : t)));
    } else list.setData([...top, c]);
  };
  const update = (c: Comment) => {
    if (c.parentId)
      setReplies({
        ...replies,
        [c.parentId]: (replies[c.parentId] ?? []).map((r) => (r.id === c.id ? c : r)),
      });
    else list.setData(top.map((t) => (t.id === c.id ? c : t)));
  };
  const gone = (c: Comment) => {
    if (c.parentId) {
      setReplies({
        ...replies,
        [c.parentId]: (replies[c.parentId] ?? []).filter((r) => r.id !== c.id),
      });
      list.setData(top.map((t) => (t.id === c.parentId ? { ...t, replies: t.replies - 1 } : t)));
      onCount(-1);
    } else {
      list.setData(top.filter((t) => t.id !== c.id));
      onCount(-1 - c.replies);
    }
  };

  return (
    <div className="gap" style={{ gap: 10, borderTop: '1.5px dashed var(--line)', paddingTop: 10 }}>
      {list.loaded && top.length === 0 && (
        <div className="muted" style={{ fontSize: 13, textAlign: 'center' }}>
          {p.kind === 'discussion'
            ? 'No answers yet. Add the first.'
            : 'No comments yet. Say something.'}
        </div>
      )}
      {top.map((c) => (
        <div key={c.id} className="gap" style={{ gap: 8 }}>
          <CommentRow
            c={c}
            post={p}
            onChange={update}
            onGone={() => gone(c)}
            onReply={() => setReplyTo(c)}
          />
          {(replies[c.id] ?? []).map((r) => (
            <div key={r.id} style={{ paddingLeft: 40 }}>
              <CommentRow
                c={r}
                post={p}
                onChange={update}
                onGone={() => gone(r)}
                onReply={() => setReplyTo(r)}
              />
            </div>
          ))}
          {c.replies > (replies[c.id]?.length ?? 0) && (
            <button
              type="button"
              className="u muted"
              style={{ fontSize: 12, paddingLeft: 40, textAlign: 'left' }}
              onClick={() => loadReplies(c)}
            >
              View {c.replies} {c.replies === 1 ? 'reply' : 'replies'}
            </button>
          )}
        </div>
      ))}
      {more && (
        <button
          type="button"
          className="u"
          style={{ fontSize: 13, alignSelf: 'center' }}
          onClick={loadMore}
        >
          More comments
        </button>
      )}
      {replyTo && (
        <div className="row muted" style={{ gap: 6, fontSize: 12 }}>
          Replying to {replyTo.author.displayName}
          <button
            type="button"
            className="u"
            onClick={() => setReplyTo(null)}
            aria-label="Cancel reply"
          >
            ×
          </button>
        </div>
      )}
      <div className="row" style={{ gap: 8 }}>
        <Avatar name={me?.displayName ?? '?'} tone="accent" url={me?.avatarUrl} size={32} />
        <label className="field sunken grow" style={{ height: 44, borderRadius: 99 }}>
          <input
            value={text}
            onChange={(e) => setText(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && send()}
            placeholder={p.kind === 'discussion' ? 'Add your answer…' : 'Write a comment…'}
            maxLength={500}
            aria-label="Comment"
          />
        </label>
        <Pill
          h={40}
          padH={14}
          size={13}
          bold
          look={text.trim() ? 'accent' : 'quiet'}
          onClick={send}
          disabled={!text.trim() || sending}
        >
          Send
        </Pill>
      </div>
    </div>
  );
}

function CommentRow({
  c,
  post,
  onChange,
  onGone,
  onReply,
}: {
  c: Comment;
  post: Post;
  onChange: (c: Comment) => void;
  onGone: () => void;
  onReply: () => void;
}) {
  const { run, toast } = useApp();
  const router = useRouter();
  const [ask, confirm] = useConfirm();
  const [report, setReport] = useState(false);
  const a = c.author;
  const del = async () => {
    if (!(await ask('Delete this comment?', 'Its replies go with it.', 'Delete'))) return;
    const ok = await run(() => api(`comments/${c.id}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    toast('Comment deleted');
    onGone();
  };
  return (
    <div className="row" style={{ gap: 8, alignItems: 'flex-start' }}>
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
        size={32}
        onClick={() => router.push(`/app/players/${a.username}`)}
      />
      <div className="grow gap" style={{ gap: 4, minWidth: 0 }}>
        <div style={{ fontSize: 14, lineHeight: 1.35, overflowWrap: 'anywhere' }}>
          <b>{a.displayName}</b> <span style={{ whiteSpace: 'pre-wrap' }}>{c.text}</span>
        </div>
        <div className="row muted" style={{ gap: 12, fontSize: 12 }}>
          <span>{ago(c.createdAt)}</span>
          <button
            type="button"
            className="u"
            onClick={onReply}
            style={{ textDecoration: 'none', fontWeight: 700 }}
          >
            Reply
          </button>
          {c.mine || post.mine ? (
            <button type="button" className="u" onClick={del} style={{ textDecoration: 'none' }}>
              Delete
            </button>
          ) : (
            <button
              type="button"
              className="u"
              onClick={() => setReport(true)}
              style={{ textDecoration: 'none' }}
            >
              Report
            </button>
          )}
        </div>
      </div>
      <GgButton
        small
        path={`comments/${c.id}/gg`}
        gg={{ ggCount: c.ggCount, myGG: c.myGG }}
        onChange={(g) => onChange({ ...c, ...g })}
      />
    </div>
  );
}

/** The + button: type, game, audience, text. */
export function ComposeSheet({ onClose }: { onClose: () => void }) {
  const { me, game, run, busy, toast, bump } = useApp();
  const [type, setType] = useState<PostType>('milestone');
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game.id] : []));
  const [gameId, setGameId] = useState<string>(myGames[0] ?? '');
  const [audience, setAudience] = useState<PostAudience>('everyone');
  const [text, setText] = useState('');
  const key = useMemo(() => uuid(), []);
  const placeholder = postTypes.find((t) => t.id === type)!.placeholder;
  const submit = async () => {
    const p = await run(() =>
      api<Post>('posts', {
        method: 'POST',
        key,
        body: { type, text: text.trim(), gameId: gameId || null, audience },
      }),
    );
    if (!p) return;
    onClose();
    toast('Posted');
    bump();
  };
  return (
    <Sheet onClose={onClose}>
      <SheetTitle onClose={onClose}>New post</SheetTitle>
      <div className="gap" style={{ gap: 12 }}>
        <Group
          label="TYPE"
          options={postTypes.map((t) => t.id)}
          value={type}
          onPick={setType}
          labelOf={(t) => postTypes.find((x) => x.id === t)!.label}
        />
        <Group
          label="GAME"
          options={['', ...myGames]}
          value={gameId}
          onPick={setGameId}
          labelOf={(id) => (id ? game(id).name : 'Any game')}
        />
        <div className="gap" style={{ gap: 6 }}>
          <Label>WHO SEES IT</Label>
          <Segmented
            options={[
              { id: 'everyone', label: 'Everyone' },
              { id: 'connections', label: 'Connections' },
            ]}
            value={audience}
            onChange={setAudience}
          />
        </div>
        <TextArea
          value={text}
          onChange={(v) => setText(v.slice(0, 2000))}
          placeholder={placeholder}
          rows={4}
        />
        <div className="muted" style={{ fontSize: 12, textAlign: 'right' }}>
          {text.length}/2000
        </div>
        <BigButton accent onClick={submit} disabled={busy || !text.trim()}>
          {busy ? 'Posting…' : 'Post'}
        </BigButton>
      </div>
    </Sheet>
  );
}

/** Home's feed: filters, cards and paging. */
export function Feed() {
  const { me, game, version } = useApp();
  const [filter, setFilter] = useState<{ filter: FeedFilter; game?: string }>({
    filter: 'for_you',
  });
  const [more, setMore] = useState<string | null>(null);
  const { run } = useApp();
  const feed = useLoad(async () => {
    const pg = await api<Page<Post>>(`feed${query({ ...filter, limit: 20 })}`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [filter.filter, filter.game, version]);
  const posts = feed.data ?? [];
  const loadMore = async () => {
    const pg = await run(
      () => api<Page<Post>>(`feed${query({ ...filter, limit: 20, cursor: more })}`),
      { busy: false },
    );
    if (!pg) return;
    feed.setData([...posts, ...pg.items.filter((x) => !posts.some((y) => y.id === x.id))]);
    setMore(pg.nextCursor);
  };
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game.id] : []));
  const chips: [string, { filter: FeedFilter; game?: string }][] = [
    ['For you', { filter: 'for_you' }],
    ['Connections', { filter: 'connections' }],
    ['LFG & recruiting', { filter: 'lfg' }],
    ...myGames.map((id): [string, { filter: FeedFilter; game?: string }] => [
      game(id).name,
      { filter: 'game', game: id },
    ]),
  ];
  return (
    <div className="gap" style={{ gap: 12 }}>
      <div
        className="row"
        style={{ gap: 6, overflowX: 'auto', paddingBottom: 2, scrollbarWidth: 'none' }}
      >
        {chips.map(([label, f]) => (
          <Chip
            key={label}
            on={filter.filter === f.filter && filter.game === f.game}
            onClick={() => setFilter(f)}
          >
            {label}
          </Chip>
        ))}
      </div>
      {feed.loaded && posts.length === 0 && (
        <EmptyNote>
          {filter.filter === 'connections'
            ? 'Nothing from your connections yet.'
            : 'No posts here yet. Tap + and share a milestone.'}
        </EmptyNote>
      )}
      {posts.map((p) => (
        <PostCard
          key={p.id}
          p={p}
          onChange={(n) => feed.setData(posts.map((x) => (x.id === n.id ? n : x)))}
          onGone={() => feed.setData(posts.filter((x) => x.id !== p.id))}
        />
      ))}
      {more && (
        <div style={{ textAlign: 'center' }}>
          <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
            Load more
          </Pill>
        </div>
      )}
      {/* Room for the + Post button over the last card. */}
      <div style={{ height: 64 }} aria-hidden />
    </div>
  );
}
