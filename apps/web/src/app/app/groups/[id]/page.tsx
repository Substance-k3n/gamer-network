'use client';

import Link from 'next/link';
import { use, useState } from 'react';
import { pad2 } from '../../_lib/data';
import { FaceStack, GroupTile, JoinButton, useGroupLine, useMember } from '../../_lib/groupui';
import {
  addGroupEvent,
  groupCount,
  groupSize,
  postInGroup,
  toggleGoing,
  toggleGroupGG,
  useGroups,
  type Group,
} from '../../_lib/groups';
import { useApp } from '../../_lib/store';
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
  Label,
  Pill,
  Rows,
  TypeTag,
} from '../../_lib/ui';

const tabs = ['Feed', 'Members', 'Events', 'About'] as const;
type Tab = (typeof tabs)[number];

/** A group's page (sample data): header, join, and Feed / Members / Events / About. */
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
  const { groups } = useGroups();
  const line = useGroupLine();
  const [tab, setTab] = useState<Tab>(tabs.includes(start as Tab) ? (start as Tab) : 'Feed');
  const g = groups.find((x) => x.id === id);
  if (!g)
    return (
      <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6 }}>
        <BackBtn href="/app/groups" />
        <EmptyNote>This group no longer exists.</EmptyNote>
      </div>
    );
  const member = g.members.includes('me');
  const admin = g.admins.includes('me');
  const invite = () => toast('Invite link copied');
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
      <div className="row rl-pad" style={{ gap: 8, paddingTop: 4 }}>
        <BackBtn href="/app/groups" />
        <span className="grow" />
        {admin && <TypeTag bg="var(--soft)">YOU’RE ADMIN</TypeTag>}
        <CircleBtn onClick={invite} label="Share group">
          <Icon name="share" size={18} />
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
                <div style={{ fontSize: 13, opacity: 0.8, marginTop: 4 }}>{line(g)}</div>
                <div style={{ marginTop: 6 }}>
                  <Label size={8} color="var(--accent-text)">
                    {g.approval ? 'ADMINS APPROVE NEW MEMBERS' : 'OPEN TO EVERYONE'}
                  </Label>
                </div>
              </div>
            </div>
            <div className="row" style={{ gap: 8 }}>
              {/* No comma: segment fonts lack one. */}
              {stat(`${groupSize(g)}`, 'MEMBERS')}
              {stat(pad2(g.events.length), 'EVENTS')}
              {stat(pad2(g.posts.length), 'POSTS')}
            </div>
          </div>
        </Card>
      </div>
      <div className="row rl-pad" style={{ gap: 8, marginTop: 14 }}>
        <span className="grow" style={{ display: 'flex' }}>
          <JoinButton g={g} big />
        </span>
        <span className="grow" style={{ display: 'flex' }}>
          <Pill h={46} size={15} bold expand shadow={3} onClick={invite}>
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
      <div className="gap rl-pad" style={{ gap: 12, marginTop: 10 }}>
        {tab === 'Feed' && <Feed g={g} member={member} />}
        {tab === 'Members' && <Members g={g} />}
        {tab === 'Events' && <Events g={g} member={member} admin={admin} />}
        {tab === 'About' && <About g={g} />}
      </div>
    </div>
  );
}

/** Sample members aren't real players: only "me" opens a profile. */
function Who({ who, children }: { who: string; children: React.ReactNode }) {
  return who === 'me' ? (
    <Link href="/app/you" style={{ display: 'flex', minWidth: 0 }}>
      {children}
    </Link>
  ) : (
    <span style={{ display: 'flex', minWidth: 0 }}>{children}</span>
  );
}

function Feed({ g, member }: { g: Group; member: boolean }) {
  const { me } = useApp();
  const { gg } = useGroups();
  const memberOf = useMember();
  const [draft, setDraft] = useState('');
  const send = () => postInGroup(g, draft) && setDraft('');
  const has = draft.trim().length > 0;
  return (
    <>
      {member ? (
        <Card pad="8px 8px 8px 10px" radius={22}>
          <div className="row" style={{ gap: 10 }}>
            <Avatar name={me?.displayName ?? '?'} tone="accent" url={me?.avatarUrl} size={34} />
            <input
              className="grow"
              value={draft}
              onChange={(e) => setDraft(e.target.value)}
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
      {g.posts.length === 0 && <EmptyNote>No posts yet. Say hi and set the tone.</EmptyNote>}
      {g.posts.map((p, i) => {
        const key = `gp:${g.id}:${g.posts.length - i}`;
        const mine = gg.includes(key);
        const w = memberOf(p.who);
        return (
          <Card key={key} pad={14} radius={22}>
            <div className="gap" style={{ gap: 9 }}>
              <div className="row" style={{ gap: 10 }}>
                <Who who={p.who}>
                  <Avatar
                    name={w.name}
                    tone={w.tone}
                    url={p.who === 'me' ? me?.avatarUrl : null}
                    size={36}
                  />
                </Who>
                <div className="grow">
                  <div className="row" style={{ gap: 6 }}>
                    <Who who={p.who}>
                      <b className="ellipsis" style={{ fontSize: 14 }}>
                        {p.who === 'me' ? `${w.name} (you)` : w.name}
                      </b>
                    </Who>
                    {g.admins.includes(p.who) && (
                      <TypeTag bg="var(--soft)" size={7} pad="1px 6px">
                        ADMIN
                      </TypeTag>
                    )}
                  </div>
                  <div className="muted" style={{ fontSize: 12 }}>
                    {p.time}
                  </div>
                </div>
              </div>
              <div style={{ fontSize: 15, lineHeight: 1.4, overflowWrap: 'anywhere' }}>
                {p.text}
              </div>
              <div>
                <Pill
                  h={32}
                  padH={12}
                  bold
                  look={mine ? 'accent' : 'clear'}
                  onClick={() => toggleGroupGG(key)}
                  label={mine ? 'Take back GG' : 'GG'}
                >
                  GG <Digits size={10}>{p.gg + (mine ? 1 : 0)}</Digits>
                </Pill>
              </div>
            </div>
          </Card>
        );
      })}
    </>
  );
}

function Members({ g }: { g: Group }) {
  const { me } = useApp();
  const memberOf = useMember();
  const known = [...g.members].sort(
    (a, b) => Number(g.admins.includes(b)) - Number(g.admins.includes(a)),
  );
  return (
    <>
      <Label style={{ paddingLeft: 6 }}>{groupCount(groupSize(g))} MEMBERS</Label>
      <Rows>
        {known.map((who) => {
          const w = memberOf(who);
          const body = (
            <>
              <Avatar name={w.name} tone={w.tone} url={who === 'me' ? me?.avatarUrl : null} />
              <span className="grow">
                <span className="row" style={{ gap: 6 }}>
                  <b className="ellipsis" style={{ fontSize: 15 }}>
                    {who === 'me' ? `${w.name} (you)` : w.name}
                  </b>
                  {g.admins.includes(who) && (
                    <TypeTag bg="var(--soft)" size={7} pad="1px 6px">
                      ADMIN
                    </TypeTag>
                  )}
                </span>
                <span className="muted ellipsis" style={{ display: 'block', fontSize: 12 }}>
                  {w.rank}
                </span>
              </span>
            </>
          );
          return who === 'me' ? (
            <Link key={who} href="/app/you" className="r">
              {body}
            </Link>
          ) : (
            <div key={who} className="r">
              {body}
            </div>
          );
        })}
      </Rows>
      {g.extra > 0 && (
        <div className="muted" style={{ fontSize: 13, textAlign: 'center', marginTop: 2 }}>
          + {groupCount(g.extra)} more members
        </div>
      )}
    </>
  );
}

function Events({ g, member, admin }: { g: Group; member: boolean; admin: boolean }) {
  const { toast, game } = useApp();
  const [adding, setAdding] = useState(false);
  return (
    <>
      {adding && <NewEvent g={g} onClose={() => setAdding(false)} />}
      {admin && (
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
      {g.events.length === 0 && (
        <EmptyNote>
          {admin ? 'No events yet. Plan the first one.' : 'No events planned yet.'}
        </EmptyNote>
      )}
      {g.events.map((e) => {
        const going = e.going.includes('me');
        const time = e.when.match(/\d{1,2}:\d{2}/)?.[0] ?? '--:--';
        const day = e.when.replace(time, '').trim();
        return (
          <Card key={e.id} pad={12} radius={22}>
            <div className="row" style={{ gap: 12 }}>
              <Card
                dark
                flat
                pad={10}
                radius={16}
                style={{ width: 76, flex: 'none', textAlign: 'center' }}
              >
                <Label size={8} color="var(--accent-text)" style={{ whiteSpace: 'nowrap' }}>
                  {day ? day.toUpperCase() : 'SOON'}
                </Label>
                <div style={{ marginTop: 4 }}>
                  <Digits size={16}>{time}</Digits>
                </div>
              </Card>
              <div className="grow">
                <div style={{ fontSize: 15, fontWeight: 700, overflowWrap: 'anywhere' }}>
                  {e.title}
                </div>
                <div className="row" style={{ gap: 6, marginTop: 4 }}>
                  <FaceStack who={e.going} size={20} />
                  <span className="muted ellipsis" style={{ fontSize: 12 }}>
                    {e.going.length} going{e.gameId ? ` · ${game(e.gameId).name}` : ''}
                  </span>
                </div>
              </div>
              <Pill
                h={34}
                padH={12}
                bold
                look={going ? 'strong' : member ? 'accent' : 'quiet'}
                onClick={() => (member ? toggleGoing(g, e) : toast('Join the group to RSVP'))}
              >
                {going ? 'Going ✓' : 'I’m in'}
              </Pill>
            </div>
          </Card>
        );
      })}
    </>
  );
}

function NewEvent({ g, onClose }: { g: Group; onClose: () => void }) {
  const { toast, game } = useApp();
  const [title, setTitle] = useState('');
  const [when, setWhen] = useState('Tonight 21:00');
  const [gameId, setGameId] = useState<string | undefined>(g.gameId);
  const add = () => {
    if (!title.trim()) return toast('Give the event a name');
    onClose();
    addGroupEvent(g, title.trim(), when, gameId, toast);
  };
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>New event</div>
      <Field
        value={title}
        onChange={setTitle}
        placeholder="What’s happening?"
        h={50}
        sunken
        autoFocus
        aria-label="Event name"
      />
      <Label>WHEN</Label>
      <div className="wrap">
        {['Tonight 21:00', 'Tomorrow 20:00', 'Sat 18:00', 'Sun 16:00'].map((w) => (
          <Chip key={w} on={when === w} onClick={() => setWhen(w)} h={32} padH={12}>
            {w}
          </Chip>
        ))}
      </div>
      {g.gameId && (
        <>
          <Label>GAME</Label>
          <div className="wrap">
            <Chip on={gameId === g.gameId} onClick={() => setGameId(g.gameId)} h={32} padH={12}>
              {game(g.gameId).name}
            </Chip>
            <Chip on={!gameId} onClick={() => setGameId(undefined)} h={32} padH={12}>
              Any game
            </Chip>
          </div>
        </>
      )}
      <div className="row" style={{ gap: 8 }}>
        <Pill h={46} size={15} expand look="clear" onClick={onClose}>
          Cancel
        </Pill>
        <Pill h={46} size={15} bold expand look="accent" shadow={3} onClick={add}>
          Add event
        </Pill>
      </div>
    </Dialog>
  );
}

function About({ g }: { g: Group }) {
  const { game } = useApp();
  const memberOf = useMember();
  const admins = g.admins.map((w) => (w === 'me' ? 'You' : memberOf(w).name)).join(', ');
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
      <Card pad={16} radius={22}>
        <div style={{ fontSize: 15, lineHeight: 1.45, overflowWrap: 'anywhere' }}>{g.about}</div>
      </Card>
      {g.rules.length > 0 && (
        <>
          <Label style={{ paddingLeft: 6 }}>RULES</Label>
          <Card pad={14} radius={22}>
            <div className="gap" style={{ gap: 10 }}>
              {g.rules.map((r, i) => (
                <div key={r} className="row" style={{ alignItems: 'flex-start' }}>
                  <span style={{ width: 28, flex: 'none' }}>
                    <Digits size={12} color="var(--muted)">
                      {pad2(i + 1)}
                    </Digits>
                  </span>
                  <span className="grow" style={{ fontSize: 14, lineHeight: 1.35 }}>
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
        {detail('Type', g.kind)}
        {g.gameId && detail('Game', game(g.gameId).name)}
        {detail('Place', g.place)}
        {detail('Who can join', g.approval ? 'Admins approve requests' : 'Anyone')}
        {detail('Admins', admins)}
        {detail('Created', g.since)}
      </Rows>
    </>
  );
}
