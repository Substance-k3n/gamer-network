'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { use, useEffect, useState, type ReactNode } from 'react';
import {
  api,
  ApiError,
  uuid,
  type Group,
  type GroupEvent,
  type GroupMember,
  type Page,
  type Post,
} from '../../_lib/api';
import { pad2, rankLine, toneFor } from '../../_lib/data';
import { FeedPost } from '../../_lib/feed';
import {
  FaceStack,
  GroupTile,
  JoinButton,
  NameError,
  RulesEditor,
  ToneSwatches,
} from '../../_lib/groupui';
import { eventDay, eventTime, groupCount, groupLine, kindLabel } from '../../_lib/groups';
import { ReportDialog } from '../../_lib/safety';
import { SheetTitle } from '../../_lib/sheets';
import { useApp, useLoad } from '../../_lib/store';
import {
  Avatar,
  BackBtn,
  Card,
  Chip,
  CircleBtn,
  Dialog,
  Digits,
  EmptyNote,
  Field,
  Icon,
  keepFocus,
  Label,
  Pill,
  Rows,
  Segmented,
  Sheet,
  Spinner,
  TextArea,
  TypeTag,
  useConfirm,
} from '../../_lib/ui';

const tabs = ['Feed', 'Members', 'Events', 'About'] as const;
type Tab = (typeof tabs)[number];

/**
 * A group's page (GET /groups/{id}): header, join, and Feed / Members /
 * Events / About. `?tab=` picks the first tab (About after creating,
 * Members from a join-request alert). A group that's gone goes back to
 * Groups with the API's message.
 */
export default function GroupPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ tab?: string }>;
}) {
  const { id } = use(params);
  const { tab: start } = use(searchParams);
  const { toast } = useApp();
  const router = useRouter();
  const [tab, setTab] = useState<Tab>(tabs.includes(start as Tab) ? (start as Tab) : 'Feed');
  const [gone, setGone] = useState(false);
  const [menu, setMenu] = useState(false);
  const group = useLoad(
    () =>
      api<Group>(`groups/${id}`).catch((e) => {
        if (e instanceof ApiError && e.status === 404) setGone(true);
        throw e;
      }),
    [id],
  );
  useEffect(() => {
    if (gone) router.replace('/app/groups');
  }, [gone, router]);
  const g = group.data;
  const member = g?.myStatus === 'member';
  const admin = member && g?.myRole === 'admin';
  // Members (the About tab names the admins) and events, for everyone.
  const members = useLoad(
    () => api<Page<GroupMember>>(`groups/${id}/members?limit=50`),
    [id, g?.memberCount],
  );
  const events = useLoad(() => api<Page<GroupEvent>>(`groups/${id}/events?limit=50`), [id]);
  // Group posts are for members only.
  const [postsMore, setPostsMore] = useState<string | null>(null);
  const posts = useLoad(async () => {
    if (!member) return [] as Post[];
    const pg = await api<Page<Post>>(`groups/${id}/posts`);
    setPostsMore(pg.nextCursor);
    return pg.items;
  }, [id, member]);

  if (!g)
    return (
      <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6 }}>
        <BackBtn href="/app/groups" />
        {group.loaded && !gone ? (
          <EmptyNote>This group couldn’t load. Try again in a moment.</EmptyNote>
        ) : (
          <Spinner />
        )}
      </div>
    );
  const share = async () => {
    try {
      await navigator.clipboard.writeText(g.shareUrl);
    } catch {}
    toast('Link copied — paste it in Telegram or WhatsApp');
  };
  const setG = (n: Group) => group.setData(n);
  const stat = (n: string, label: string) => (
    <div
      style={{
        flex: 1,
        minWidth: 0,
        border: '1.5px solid color-mix(in srgb, var(--on-dark) 40%, transparent)',
        borderRadius: 14,
        padding: '8px 10px',
      }}
    >
      <span className="digits big" style={{ fontSize: 18 }}>
        {n}
      </span>
      <div style={{ marginTop: 4 }}>
        <Label size={8} color="color-mix(in srgb, var(--on-dark) 75%, transparent)">
          {label}
        </Label>
      </div>
    </div>
  );

  return (
    <div style={{ paddingBottom: 40 }}>
      {menu && <GroupMenu g={g} onShare={share} onClose={() => setMenu(false)} />}
      <div className="row rl-pad" style={{ gap: 8, paddingTop: 4 }}>
        <BackBtn href="/app/groups" />
        <span className="grow" />
        {admin && <TypeTag bg="var(--soft)">YOU’RE ADMIN</TypeTag>}
        <CircleBtn onClick={share} label="Share group">
          <Icon name="share" size={18} />
        </CircleBtn>
        <CircleBtn onClick={() => setMenu(true)} label="More">
          <Icon name="more" size={18} />
        </CircleBtn>
      </div>
      <div className="rl-pad" style={{ marginTop: 12 }}>
        <Card dark pad={16} radius={28}>
          <div className="gap" style={{ gap: 14 }}>
            <div className="row" style={{ gap: 14 }}>
              <GroupTile short={g.short} tone={g.tone} size={66} onDark />
              <div className="grow">
                <div
                  className="t-display"
                  style={{
                    fontSize: 24,
                    fontWeight: 800,
                    letterSpacing: -0.8,
                    lineHeight: 1.05,
                    overflowWrap: 'anywhere',
                  }}
                >
                  {g.name}
                </div>
                <div style={{ fontSize: 13, opacity: 0.8, marginTop: 4 }}>{groupLine(g)}</div>
                <div style={{ marginTop: 6 }}>
                  <Label size={8} color="var(--accent-text)">
                    {g.approval ? 'ADMINS APPROVE NEW MEMBERS' : 'OPEN TO EVERYONE'}
                  </Label>
                </div>
              </div>
            </div>
            <div className="row" style={{ gap: 8 }}>
              {/* No comma: segment fonts lack one. */}
              {stat(`${g.memberCount}`, 'MEMBERS')}
              {stat(
                `${pad2(events.data?.items.length ?? 0)}${events.data?.nextCursor ? '+' : ''}`,
                'EVENTS',
              )}
              {stat(
                member ? `${pad2(posts.data?.length ?? 0)}${postsMore ? '+' : ''}` : '--',
                'POSTS',
              )}
            </div>
          </div>
        </Card>
      </div>
      <div className="row rl-pad" style={{ gap: 8, marginTop: 14 }}>
        <span className="grow" style={{ display: 'flex' }}>
          <JoinButton g={g} big onChange={setG} />
        </span>
        <span className="grow" style={{ display: 'flex' }}>
          <Pill h={46} size={15} bold expand shadow={3} onClick={share}>
            Invite players
          </Pill>
        </span>
      </div>
      <div className="scroller" style={{ padding: '16px 16px 4px' }}>
        {tabs.map((t) => (
          <Chip key={t} on={tab === t} onClick={() => setTab(t)} h={36} padH={14} size={14}>
            {t}
          </Chip>
        ))}
      </div>
      {tab === 'Feed' && (
        <GroupFeed
          g={g}
          posts={posts.data ?? []}
          loaded={posts.loaded}
          more={postsMore}
          onPosts={(p) => posts.setData(p)}
          onMore={setPostsMore}
        />
      )}
      <div className="gap rl-pad" style={{ gap: 12, marginTop: 10 }}>
        {tab === 'Members' && (
          <Members g={g} admin={admin} onGroup={setG} onChanged={() => members.reload()} />
        )}
        {tab === 'Events' && (
          <Events
            g={g}
            member={member}
            admin={admin}
            list={events.data?.items ?? []}
            loaded={events.loaded}
            onList={(items) =>
              events.setData({ items, nextCursor: events.data?.nextCursor ?? null })
            }
          />
        )}
        {tab === 'About' && (
          <About
            g={g}
            admin={admin}
            admins={(members.data?.items ?? []).filter((m) => m.role === 'admin')}
            onGroup={setG}
          />
        )}
      </div>
    </div>
  );
}

/** ⋯ on a group: copy its link, or report it. */
function GroupMenu({
  g,
  onShare,
  onClose,
}: {
  g: Group;
  onShare: () => void;
  onClose: () => void;
}) {
  const { me } = useApp();
  const [report, setReport] = useState(false);
  // A report names the group and its creator (D36).
  if (report)
    return <ReportDialog userId={g.createdBy.id} name={g.name} groupId={g.id} onClose={onClose} />;
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>{g.name}</div>
      <Pill
        h={48}
        size={15}
        bold
        expand
        look="clear"
        onClick={() => {
          onShare();
          onClose();
        }}
      >
        Copy link
      </Pill>
      {g.createdBy.id !== me?.id && (
        <Pill h={48} size={15} bold expand look="clear" onClick={() => setReport(true)}>
          Report group
        </Pill>
      )}
      <Pill h={44} size={14} expand look="clear" onClick={onClose} style={{ border: 0 }}>
        Cancel
      </Pill>
    </Dialog>
  );
}

/** Members post here (text only); everyone else is asked to join first. */
function GroupFeed({
  g,
  posts,
  loaded,
  more,
  onPosts,
  onMore,
}: {
  g: Group;
  posts: Post[];
  loaded: boolean;
  more: string | null;
  onPosts: (p: Post[]) => void;
  onMore: (c: string | null) => void;
}) {
  const { me, run } = useApp();
  const [draft, setDraft] = useState('');
  const [sending, setSending] = useState(false);
  const [postKey, setPostKey] = useState(uuid);
  const member = g.myStatus === 'member';
  const has = draft.trim().length > 0;
  const send = async () => {
    if (!has || sending) return;
    setSending(true);
    const p = await run(
      () =>
        api<Post>('posts', {
          method: 'POST',
          key: postKey,
          body: { type: 'discussion', text: draft.trim(), audience: 'everyone', groupId: g.id },
        }),
      { busy: false },
    );
    setSending(false);
    if (!p) return;
    setDraft('');
    setPostKey(uuid());
    onPosts([p, ...posts]);
  };
  const loadMore = async () => {
    const pg = await run(
      () => api<Page<Post>>(`groups/${g.id}/posts?cursor=${encodeURIComponent(more!)}`),
      { busy: false },
    );
    if (!pg) return;
    onPosts([...posts, ...pg.items.filter((x) => !posts.some((y) => y.id === x.id))]);
    onMore(pg.nextCursor);
  };
  return (
    <div style={{ marginTop: 10 }}>
      <div className="rl-pad" style={{ marginBottom: 4 }}>
        {member ? (
          <Card pad="8px 8px 8px 10px" radius={22}>
            <div className="row" style={{ gap: 10 }} {...keepFocus}>
              <Avatar name={me?.displayName ?? '?'} tone="accent" url={me?.avatarUrl} size={34} />
              <input
                className="grow"
                value={draft}
                onChange={(e) => setDraft(e.target.value.slice(0, 2000))}
                onKeyDown={(e) => e.key === 'Enter' && send()}
                placeholder={`Share with ${g.name}…`}
                aria-label={`Share with ${g.name}`}
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
              <Pill
                h={36}
                padH={14}
                bold
                look={has ? 'accent' : 'quiet'}
                onClick={send}
                disabled={sending}
                style={{ border: 0 }}
              >
                Post
              </Pill>
            </div>
          </Card>
        ) : (
          <EmptyNote pad={16}>
            {g.approval
              ? 'Ask to join to post and reply in this group.'
              : 'Join to post and reply in this group.'}
          </EmptyNote>
        )}
      </div>
      {member && !loaded && <Spinner />}
      {member && loaded && posts.length === 0 && (
        <div className="rl-pad" style={{ marginTop: 8 }}>
          <EmptyNote>No posts yet. Say hi and set the tone.</EmptyNote>
        </div>
      )}
      {posts.map((p) => (
        <FeedPost
          key={p.id}
          p={p}
          moderator={g.myRole === 'admin'}
          onChange={(n) => onPosts(posts.map((x) => (x.id === n.id ? n : x)))}
          onGone={() => onPosts(posts.filter((x) => x.id !== p.id))}
        />
      ))}
      {more && (
        <div style={{ textAlign: 'center', padding: 14 }}>
          <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
            Load more
          </Pill>
        </div>
      )}
    </div>
  );
}

/** A member row: their profile on tap; the admin's actions beside. */
function MemberRow({ m, children }: { m: GroupMember; children?: ReactNode }) {
  const { me } = useApp();
  const mine = m.user.id === me?.id;
  return (
    <div className="r" style={{ flexWrap: 'wrap' }}>
      <Link
        href={mine ? '/app/you' : `/app/players/${m.user.username}`}
        className="row"
        style={{ gap: 12, flex: '1 1 160px', minWidth: 0 }}
      >
        <Avatar name={m.user.displayName} tone={toneFor(m.user.id)} url={m.user.avatarUrl} />
        <span className="grow">
          <span className="row" style={{ gap: 6 }}>
            <b className="ellipsis" style={{ fontSize: 15 }}>
              {mine ? `${m.user.displayName} (you)` : m.user.displayName}
            </b>
            {m.role === 'admin' && m.status === 'member' && (
              <TypeTag bg="var(--soft)" size={7} pad="1px 6px">
                ADMIN
              </TypeTag>
            )}
          </span>
          <span className="muted ellipsis" style={{ display: 'block', fontSize: 12 }}>
            {rankLine(m.user.topGame) || `@${m.user.username}`}
          </span>
        </span>
      </Link>
      {children && (
        <span className="row" style={{ gap: 6, marginLeft: 'auto' }}>
          {children}
        </span>
      )}
    </div>
  );
}

function Members({
  g,
  admin,
  onGroup,
  onChanged,
}: {
  g: Group;
  admin: boolean;
  onGroup: (g: Group) => void;
  onChanged: () => void;
}) {
  const { run, toast, me } = useApp();
  const [ask, confirm] = useConfirm();
  const [more, setMore] = useState<string | null>(null);
  const list = useLoad(async () => {
    const pg = await api<Page<GroupMember>>(`groups/${g.id}/members`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [g.id]);
  const requests = useLoad(
    async () =>
      admin
        ? (await api<Page<GroupMember>>(`groups/${g.id}/members?status=pending&limit=50`)).items
        : [],
    [g.id, admin],
  );
  const items = [...(list.data ?? [])].sort(
    (a, b) => Number(b.role === 'admin') - Number(a.role === 'admin'),
  );
  const pending = requests.data ?? [];
  const loadMore = async () => {
    const pg = await run(
      () => api<Page<GroupMember>>(`groups/${g.id}/members?cursor=${encodeURIComponent(more!)}`),
      { busy: false },
    );
    if (!pg) return;
    list.setData([...(list.data ?? []), ...pg.items]);
    setMore(pg.nextCursor);
  };
  const answer = async (m: GroupMember, to: 'approve' | 'decline') => {
    const ok = await run(() =>
      api(`groups/${g.id}/members/${m.user.id}/${to}`, { method: 'POST' }).then(() => true),
    );
    if (!ok) return;
    requests.setData(pending.filter((x) => x.user.id !== m.user.id));
    toast(
      to === 'approve'
        ? `${m.user.displayName} is in`
        : `Request from ${m.user.displayName} declined`,
    );
    if (to === 'approve') {
      onGroup({ ...g, memberCount: g.memberCount + 1 });
      list.reload();
      onChanged();
    }
  };
  const setRole = async (m: GroupMember, role: 'admin' | 'member') => {
    const ok = await run(() =>
      api(`groups/${g.id}/members/${m.user.id}/role`, {
        method: 'PUT',
        body: { role },
      }).then(() => true),
    );
    if (!ok) return;
    list.setData((list.data ?? []).map((x) => (x.user.id === m.user.id ? { ...x, role } : x)));
    toast(`${m.user.displayName} is ${role === 'admin' ? 'an admin' : 'a member'} now`);
    onChanged();
  };
  const remove = async (m: GroupMember) => {
    if (
      !(await ask(
        `Remove ${m.user.displayName}?`,
        `They leave ${g.name}. They can ask to join again.`,
        'Remove',
      ))
    )
      return;
    const ok = await run(() =>
      api(`groups/${g.id}/members/${m.user.id}`, { method: 'DELETE' }).then(() => true),
    );
    if (!ok) return;
    list.setData((list.data ?? []).filter((x) => x.user.id !== m.user.id));
    toast(`${m.user.displayName} removed from the group`);
    onGroup({ ...g, memberCount: Math.max(0, g.memberCount - 1) });
    onChanged();
  };
  return (
    <>
      {confirm}
      {admin && pending.length > 0 && (
        <>
          <Label style={{ paddingLeft: 6 }}>REQUESTS ({pending.length})</Label>
          <Rows>
            {pending.map((m) => (
              <MemberRow key={m.user.id} m={m}>
                <Pill h={34} padH={12} bold look="accent" onClick={() => answer(m, 'approve')}>
                  Approve
                </Pill>
                <Pill h={34} padH={12} look="clear" onClick={() => answer(m, 'decline')}>
                  Decline
                </Pill>
              </MemberRow>
            ))}
          </Rows>
        </>
      )}
      <Label style={{ paddingLeft: 6 }}>{groupCount(g.memberCount)} MEMBERS</Label>
      {!list.loaded && <Spinner />}
      {items.length > 0 && (
        <Rows>
          {items.map((m) => (
            <MemberRow key={m.user.id} m={m}>
              {admin && m.user.id !== me?.id && (
                <>
                  {m.role !== 'admin' ? (
                    <Pill h={32} padH={11} size={12} bold onClick={() => setRole(m, 'admin')}>
                      Make admin
                    </Pill>
                  ) : (
                    <Pill h={32} padH={11} size={12} bold onClick={() => setRole(m, 'member')}>
                      Make member
                    </Pill>
                  )}
                  <Pill h={32} padH={11} size={12} look="clear" onClick={() => remove(m)}>
                    Remove
                  </Pill>
                </>
              )}
            </MemberRow>
          ))}
        </Rows>
      )}
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

function Events({
  g,
  member,
  admin,
  list,
  loaded,
  onList,
}: {
  g: Group;
  member: boolean;
  admin: boolean;
  list: GroupEvent[];
  loaded: boolean;
  onList: (l: GroupEvent[]) => void;
}) {
  const { run, toast, me } = useApp();
  const [ask, confirm] = useConfirm();
  const [adding, setAdding] = useState(false);
  const going = async (e: GroupEvent) => {
    if (!member) return toast('Join the group to RSVP');
    const r = await run(
      () => api<GroupEvent>(`group-events/${e.id}/going`, { method: e.imGoing ? 'DELETE' : 'PUT' }),
      { busy: false },
    );
    if (r) onList(list.map((x) => (x.id === e.id ? r : x)));
  };
  const del = async (e: GroupEvent) => {
    if (!(await ask('Delete this event?', 'It’s gone for everyone in the group.', 'Delete')))
      return;
    const ok = await run(() => api(`group-events/${e.id}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    onList(list.filter((x) => x.id !== e.id));
    toast('Event deleted');
  };
  return (
    <>
      {confirm}
      {adding && (
        <NewEvent
          g={g}
          onClose={() => setAdding(false)}
          onAdded={(e) => onList([...list, e].sort((a, b) => a.startsAt.localeCompare(b.startsAt)))}
        />
      )}
      {member && (
        <button
          type="button"
          className="dashed row"
          onClick={() => setAdding(true)}
          style={{
            height: 52,
            gap: 8,
            justifyContent: 'center',
            background: 'transparent',
            fontSize: 15,
            fontWeight: 700,
            cursor: 'pointer',
          }}
        >
          <Icon name="plus" size={18} /> New event
        </button>
      )}
      {!loaded && <Spinner />}
      {loaded && list.length === 0 && (
        <EmptyNote>
          {member ? 'No events yet. Plan the first one.' : 'No events planned yet.'}
        </EmptyNote>
      )}
      {list.map((e) => (
        <Card key={e.id} pad={12} radius={22}>
          <div className="row" style={{ gap: 12 }}>
            <Card
              dark
              flat
              pad={10}
              radius={16}
              style={{ width: 84, flex: 'none', textAlign: 'center' }}
            >
              <Label size={8} color="var(--accent-text)" style={{ whiteSpace: 'nowrap' }}>
                {eventDay(e.startsAt).toUpperCase()}
              </Label>
              <div style={{ marginTop: 4 }}>
                <Digits size={16}>{eventTime(e.startsAt)}</Digits>
              </div>
            </Card>
            <div className="grow">
              <div style={{ fontSize: 15, fontWeight: 700, overflowWrap: 'anywhere' }}>
                {e.title}
              </div>
              <div className="row" style={{ gap: 6, marginTop: 4 }}>
                <FaceStack users={e.goingPreview} size={20} />
                <span className="muted ellipsis" style={{ fontSize: 12 }}>
                  {e.goingCount} going{e.game ? ` · ${e.game.name}` : ''}
                </span>
              </div>
              {(admin || e.createdBy.id === me?.id) && (
                <button
                  type="button"
                  className="u muted"
                  onClick={() => del(e)}
                  style={{ fontSize: 12, fontWeight: 700, marginTop: 4, textDecoration: 'none' }}
                >
                  Delete
                </button>
              )}
            </div>
            <Pill
              h={34}
              padH={12}
              bold
              look={e.imGoing ? 'strong' : member ? 'accent' : 'quiet'}
              onClick={() => going(e)}
            >
              {e.imGoing ? 'Going ✓' : 'I’m in'}
            </Pill>
          </div>
        </Card>
      ))}
    </>
  );
}

const isoDay = (d: Date) => `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`;

/** Why an event time won't do: it has passed, or it's past the 60 days. */
function whenProblem(at: Date, last: Date) {
  if (Number.isNaN(at.getTime()) || at.getTime() <= Date.now())
    return 'Pick a time that hasn’t passed';
  if (at.getTime() > last.getTime()) return 'Pick a day in the next 60 days';
  return null;
}

/** A new event: what, which day (the next 60) and time, and the game when the group has one. */
function NewEvent({
  g,
  onClose,
  onAdded,
}: {
  g: Group;
  onClose: () => void;
  onAdded: (e: GroupEvent) => void;
}) {
  const { run, toast, busy } = useApp();
  const [title, setTitle] = useState('');
  const [today] = useState(() => new Date());
  const last = new Date(today.getTime() + 60 * 86_400_000);
  const [day, setDay] = useState(isoDay(today));
  const [time, setTime] = useState('21:00');
  const [gameId, setGameId] = useState<string | null>(g.game?.id ?? null);
  const [key] = useState(uuid);
  const add = async () => {
    if (!title.trim()) return toast('Give the event a name');
    const at = new Date(`${day}T${time}`);
    const problem = whenProblem(at, last);
    if (problem) return toast(problem);
    const e = await run(() =>
      api<GroupEvent>(`groups/${g.id}/events`, {
        method: 'POST',
        key,
        body: { title: title.trim(), startsAt: at.toISOString(), ...(gameId ? { gameId } : {}) },
      }),
    );
    if (!e) return;
    onClose();
    onAdded(e);
    toast('Event added — members get a notification');
  };
  const input = {
    border: 0,
    outline: 0,
    background: 'transparent',
    color: 'var(--text)',
    font: 'inherit',
    fontSize: 16,
    minWidth: 0,
    width: '100%',
  } as const;
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>New event</div>
      <Field
        value={title}
        onChange={(v) => setTitle(v.slice(0, 80))}
        placeholder="What’s happening?"
        h={50}
        sunken
        autoFocus
        maxLength={80}
        aria-label="Event name"
      />
      <Label>WHEN</Label>
      <div className="row" style={{ gap: 8 }}>
        <label
          className="field sunken grow"
          style={{ height: 48, borderRadius: 16, padding: '0 12px' }}
        >
          <input
            type="date"
            value={day}
            min={isoDay(today)}
            max={isoDay(last)}
            onChange={(e) => setDay(e.target.value)}
            aria-label="Day"
            style={input}
          />
        </label>
        <label
          className="field sunken"
          style={{ height: 48, borderRadius: 16, padding: '0 12px', width: 116, flex: 'none' }}
        >
          <input
            type="time"
            value={time}
            onChange={(e) => setTime(e.target.value)}
            aria-label="Time"
            style={input}
          />
        </label>
      </div>
      {g.game && (
        <>
          <Label>GAME</Label>
          <div className="wrap">
            <Chip on={gameId === g.game.id} onClick={() => setGameId(g.game!.id)} h={32} padH={12}>
              {g.game.name}
            </Chip>
            <Chip on={!gameId} onClick={() => setGameId(null)} h={32} padH={12}>
              Any game
            </Chip>
          </div>
        </>
      )}
      <div className="row" style={{ gap: 8 }}>
        <Pill h={46} size={15} expand look="clear" onClick={onClose}>
          Cancel
        </Pill>
        <Pill h={46} size={15} bold expand look="accent" shadow={3} onClick={add} disabled={busy}>
          Add event
        </Pill>
      </div>
    </Dialog>
  );
}

function About({
  g,
  admin,
  admins,
  onGroup,
}: {
  g: Group;
  admin: boolean;
  admins: GroupMember[];
  onGroup: (g: Group) => void;
}) {
  const { me } = useApp();
  const [editing, setEditing] = useState(false);
  const names = admins.map((m) => (m.user.id === me?.id ? 'You' : m.user.displayName)).join(', ');
  const detail = (k: string, v: string) => (
    <div className="row" style={{ padding: '11px 14px', alignItems: 'flex-start' }}>
      <b style={{ width: 104, flex: 'none', fontSize: 13 }}>{k}</b>
      <span className="grow muted" style={{ fontSize: 13, overflowWrap: 'anywhere' }}>
        {v}
      </span>
    </div>
  );
  return (
    <>
      {editing && <EditGroup g={g} onClose={() => setEditing(false)} onSaved={onGroup} />}
      {admin && (
        <div>
          <Pill h={42} padH={16} size={14} bold shadow={3} onClick={() => setEditing(true)}>
            Edit group
          </Pill>
        </div>
      )}
      <Card pad={16} radius={22}>
        <div
          className={g.about ? undefined : 'muted'}
          style={{
            fontSize: 15,
            lineHeight: 1.45,
            overflowWrap: 'anywhere',
            whiteSpace: 'pre-wrap',
          }}
        >
          {g.about || 'No description yet.'}
        </div>
      </Card>
      {g.rules.length > 0 && (
        <>
          <Label style={{ paddingLeft: 6 }}>RULES</Label>
          <Card pad={14} radius={22}>
            <div className="gap" style={{ gap: 10 }}>
              {g.rules.map((r, i) => (
                <div key={i} className="row" style={{ alignItems: 'flex-start' }}>
                  <span style={{ width: 28, flex: 'none' }}>
                    <Digits size={12} color="var(--muted)">
                      {pad2(i + 1)}
                    </Digits>
                  </span>
                  <span
                    className="grow"
                    style={{ fontSize: 14, lineHeight: 1.35, overflowWrap: 'anywhere' }}
                  >
                    {r}
                  </span>
                </div>
              ))}
            </div>
          </Card>
        </>
      )}
      <Label style={{ paddingLeft: 6 }}>DETAILS</Label>
      <Rows>
        {detail('Type', kindLabel[g.kind])}
        {g.game && detail('Game', g.game.name)}
        {detail('Place', g.place)}
        {detail('Who can join', g.approval ? 'Admins approve requests' : 'Anyone')}
        {names && detail('Admins', names)}
        {detail(
          'Created',
          new Date(g.createdAt).toLocaleDateString('en-GB', { month: 'short', year: 'numeric' }),
        )}
      </Rows>
    </>
  );
}

/** Admins: name, place, about, rules, colour, who can join (PATCH /groups/{id}). */
function EditGroup({
  g,
  onClose,
  onSaved,
}: {
  g: Group;
  onClose: () => void;
  onSaved: (g: Group) => void;
}) {
  const { run, toast, busy } = useApp();
  const [name, setName] = useState(g.name);
  const [nameError, setNameError] = useState<string | null>(null);
  const [place, setPlace] = useState(g.place);
  const [about, setAbout] = useState(g.about);
  const [rules, setRules] = useState(g.rules);
  const [tone, setTone] = useState(g.tone);
  const [approval, setApproval] = useState(g.approval);
  const save = async () => {
    if (name.trim().length < 3) return setNameError('Give your group a name (3+ characters)');
    if (!place.trim()) return toast('Add a city, campus or country');
    const r = await run(async () => {
      try {
        return await api<Group>(`groups/${g.id}`, {
          method: 'PATCH',
          body: {
            name: name.trim(),
            place: place.trim(),
            about: about.trim(),
            rules: rules.map((x) => x.trim()).filter(Boolean),
            tone,
            approval,
          },
        });
      } catch (e) {
        // A taken name is said on the field.
        if (e instanceof ApiError && e.code === 'group_name_taken') {
          setNameError(e.message);
          return null;
        }
        throw e;
      }
    });
    if (!r) return;
    onSaved(r);
    onClose();
    toast('Group updated');
  };
  const labeled = (label: string, field: ReactNode) => (
    <div className="gap" style={{ gap: 6 }}>
      <Label style={{ paddingLeft: 14 }}>{label}</Label>
      {field}
    </div>
  );
  return (
    <Sheet onClose={onClose}>
      <SheetTitle onClose={onClose}>Edit group</SheetTitle>
      <div className="gap" style={{ gap: 14 }}>
        {labeled(
          'NAME',
          <>
            <Field
              value={name}
              onChange={(v) => {
                setName(v.slice(0, 40));
                setNameError(null);
              }}
              h={50}
              maxLength={40}
              aria-label="Group name"
            />
            {nameError && <NameError text={nameError} />}
          </>,
        )}
        {labeled(
          'PLACE',
          <Field
            value={place}
            onChange={(v) => setPlace(v.slice(0, 60))}
            h={50}
            maxLength={60}
            aria-label="Place"
          />,
        )}
        {labeled(
          'ABOUT',
          <TextArea value={about} onChange={(v) => setAbout(v.slice(0, 500))} rows={3} />,
        )}
        {labeled('RULES', <RulesEditor rules={rules} onChange={setRules} />)}
        {labeled(
          'WHO CAN JOIN',
          <Segmented
            options={[
              { id: 'anyone', label: 'Anyone' },
              { id: 'approval', label: 'Approval' },
            ]}
            value={approval ? 'approval' : 'anyone'}
            onChange={(v) => setApproval(v === 'approval')}
          />,
        )}
        {labeled('COLOUR', <ToneSwatches tone={tone} onChange={setTone} />)}
        <Pill h={50} size={16} bold expand look="accent" shadow={3} onClick={save} disabled={busy}>
          Save
        </Pill>
      </div>
    </Sheet>
  );
}
