'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, type Group, type GroupTone, type UserCard } from './api';
import { toneFor } from './data';
import { eventWhen, groupCount, groupLine } from './groups';
import { useApp } from './store';
import { Avatar, Card, Label, Pill, TypeTag, toneColor, useConfirm } from './ui';

// The shared pieces of the Groups screens (the prototype's groups.dart),
// on the groups API.

/** Square badge with a group's short name. */
export function GroupTile({
  short,
  tone,
  size = 48,
  onDark,
}: {
  short: string;
  tone: GroupTone;
  size?: number;
  onDark?: boolean;
}) {
  return (
    <span
      className="row"
      style={{
        width: size,
        height: size,
        padding: size * 0.12,
        justifyContent: 'center',
        flex: 'none',
        background: toneColor(tone),
        color: 'var(--text)',
        border: `var(--line-w) solid ${onDark ? 'var(--on-dark-line)' : 'var(--line)'}`,
        borderRadius: size * 0.3,
        fontSize: Math.min(size * 0.3, (size * 0.76) / Math.max(1, short.length * 0.72)),
        fontWeight: 800,
        whiteSpace: 'nowrap',
        overflow: 'hidden',
      }}
    >
      {short}
    </span>
  );
}

/** Overlapping faces. */
export function FaceStack({ users, size = 24 }: { users: UserCard[]; size?: number }) {
  const faces = users.slice(0, 4);
  if (!faces.length) return null;
  const step = size * 0.7;
  return (
    <span
      style={{
        position: 'relative',
        width: size + step * (faces.length - 1),
        height: size,
        flex: 'none',
      }}
    >
      {faces.map((u, i) => (
        <span key={u.id} style={{ position: 'absolute', left: step * i, top: 0, display: 'flex' }}>
          <Avatar name={u.displayName} tone={toneFor(u.id)} url={u.avatarUrl} size={size} />
        </span>
      ))}
    </span>
  );
}

/**
 * Join / Ask to join / Requested… / Joined ✓, sized for cards or the group
 * page. `onChange` gets the group back after a join or a leave.
 */
export function JoinButton({
  g,
  big,
  onChange,
}: {
  g: Group;
  big?: boolean;
  onChange: (g: Group) => void;
}) {
  const { run, toast } = useApp();
  const router = useRouter();
  const [ask, confirm] = useConfirm();
  const [label, look] =
    g.myStatus === 'member'
      ? (['Joined ✓', 'strong'] as const)
      : g.myStatus === 'pending'
        ? (['Requested…', 'quiet'] as const)
        : ([g.approval ? 'Ask to join' : 'Join', 'accent'] as const);
  const leave = async () => {
    const ok = await run(() =>
      api(`groups/${g.id}/membership`, { method: 'DELETE' }).then(() => true),
    );
    if (!ok) return false;
    onChange({
      ...g,
      myStatus: null,
      myRole: null,
      memberCount: g.myStatus === 'member' ? Math.max(0, g.memberCount - 1) : g.memberCount,
    });
    return true;
  };
  const tap = async () => {
    if (!g.myStatus) {
      const r = await run(() => api<Group>(`groups/${g.id}/join`, { method: 'POST' }));
      if (!r) return;
      onChange(r);
      toast(r.myStatus === 'pending' ? `Request sent to ${g.name} admins` : `You joined ${g.name}`);
    } else if (g.myStatus === 'pending') {
      if (
        await ask(
          'Cancel your request?',
          `${g.name}’s admins won’t see it any more. You can ask again later.`,
          'Cancel request',
          'Keep it',
        )
      )
        if (await leave()) toast(`Request to ${g.name} cancelled`);
    } else if (!big) {
      router.push(`/app/groups/${g.id}`);
    } else if (
      await ask(
        `Leave ${g.name}?`,
        `You’ll stop seeing its posts and events. You can join again any time${g.approval ? ' (admins approve requests)' : ''}.`,
        'Leave',
        'Stay',
      )
    ) {
      if (await leave()) toast(`You left ${g.name}`);
    }
  };
  return (
    <>
      {confirm}
      <Pill
        h={big ? 46 : 36}
        padH={big ? 18 : 14}
        size={big ? 15 : 13}
        bold
        expand={big}
        look={look}
        shadow={big ? 3 : undefined}
        onClick={tap}
      >
        {label}
      </Pill>
    </>
  );
}

/** Group summary card used in the Groups list and on profiles. */
export function GroupCard({ g, onChange }: { g: Group; onChange: (g: Group) => void }) {
  const router = useRouter();
  const [now] = useState(() => Date.now());
  const next = g.nextEvent && new Date(g.nextEvent.startsAt).getTime() > now - 3_600_000;
  return (
    <Card pad={14} onClick={() => router.push(`/app/groups/${g.id}`)}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ gap: 12 }}>
          <GroupTile short={g.short} tone={g.tone} size={52} />
          <div className="grow">
            <div className="ellipsis" style={{ fontSize: 16, fontWeight: 700 }}>
              {g.name}
            </div>
            <div className="muted ellipsis" style={{ fontSize: 12 }}>
              {groupLine(g)}
            </div>
          </div>
          {/* The button acts on its own; the card opens the group. */}
          <span onClick={(e) => e.stopPropagation()} style={{ flex: 'none' }}>
            <JoinButton g={g} onChange={onChange} />
          </span>
        </div>
        {g.about && (
          <div
            className="muted"
            style={{
              fontSize: 13,
              lineHeight: 1.35,
              display: '-webkit-box',
              WebkitLineClamp: 2,
              WebkitBoxOrient: 'vertical',
              overflow: 'hidden',
              overflowWrap: 'anywhere',
            }}
          >
            {g.about}
          </div>
        )}
        <div className="row" style={{ gap: 8 }}>
          <FaceStack users={g.membersPreview} size={22} />
          <span style={{ fontSize: 12, fontWeight: 600, flex: 'none' }}>
            {groupCount(g.memberCount)} {g.memberCount === 1 ? 'member' : 'members'}
          </span>
          {g.myStatus === 'pending' ? (
            <TypeTag bg="var(--lav)" size={7} pad="2px 6px">
              REQUESTED
            </TypeTag>
          ) : (
            g.approval && (
              <TypeTag bg="var(--soft)" size={7} pad="2px 6px">
                APPROVAL
              </TypeTag>
            )
          )}
          <span className="grow muted ellipsis" style={{ fontSize: 12, textAlign: 'right' }}>
            {next && g.nextEvent ? `Next: ${eventWhen(g.nextEvent.startsAt)}` : ''}
          </span>
        </div>
      </div>
    </Card>
  );
}

/** Horizontal row of the groups a player belongs to (profile Overview). */
export function GroupStrip({ groups, onAll }: { groups: Group[]; onAll: () => void }) {
  const router = useRouter();
  if (!groups.length) return null;
  return (
    <Card pad="12px 0 12px 14px" radius={22}>
      <div className="gap" style={{ gap: 10 }}>
        <div className="row" style={{ paddingRight: 14 }}>
          <Label>GROUPS · {groups.length}</Label>
          <span className="grow" />
          <button
            type="button"
            className="u"
            onClick={onAll}
            style={{ fontSize: 12, fontWeight: 700 }}
          >
            See all
          </button>
        </div>
        <div className="scroller" style={{ gap: 8, paddingRight: 14 }}>
          {groups.map((g) => (
            <button
              key={g.id}
              type="button"
              className="row"
              onClick={() => router.push(`/app/groups/${g.id}`)}
              style={{
                gap: 8,
                padding: '5px 12px 5px 5px',
                flex: 'none',
                background: 'var(--sunken)',
                border: '1.5px solid var(--line)',
                borderRadius: 99,
                cursor: 'pointer',
              }}
            >
              <GroupTile short={g.short} tone={g.tone} size={30} />
              <span style={{ fontSize: 13, fontWeight: 700, whiteSpace: 'nowrap' }}>{g.name}</span>
            </button>
          ))}
        </div>
      </div>
    </Card>
  );
}

/** Up to 10 rules of 140 characters, one field each. */
export function RulesEditor({
  rules,
  onChange,
}: {
  rules: string[];
  onChange: (r: string[]) => void;
}) {
  return (
    <div className="gap" style={{ gap: 7 }}>
      {rules.map((r, i) => (
        <div
          key={i}
          className="row"
          style={{
            minHeight: 44,
            padding: '0 6px 0 12px',
            gap: 6,
            background: 'var(--surface)',
            border: 'var(--line-w) solid var(--line)',
            borderRadius: 14,
          }}
        >
          <span className="digits muted" style={{ width: 22, flex: 'none', fontSize: 10 }}>
            {String(i + 1).padStart(2, '0')}
          </span>
          <input
            className="grow"
            value={r}
            onChange={(e) =>
              onChange(rules.map((x, j) => (j === i ? e.target.value.slice(0, 140) : x)))
            }
            maxLength={140}
            placeholder={`Rule ${i + 1}`}
            aria-label={`Rule ${i + 1}`}
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
          <button
            type="button"
            className="circle"
            onClick={() => onChange(rules.filter((_, j) => j !== i))}
            aria-label={`Remove rule ${i + 1}`}
            style={{ width: 28, height: 28, background: 'transparent', fontSize: 14 }}
          >
            ×
          </button>
        </div>
      ))}
      {rules.length < 10 && (
        <button
          type="button"
          className="dashed"
          onClick={() => onChange([...rules, ''])}
          style={{
            height: 40,
            borderRadius: 14,
            background: 'transparent',
            fontSize: 14,
            fontWeight: 600,
            cursor: 'pointer',
          }}
        >
          + Add rule
        </button>
      )}
    </div>
  );
}

export const groupTones: GroupTone[] = ['accent', 'lav', 'soft', 'grey'];

/** The group's colour, as four swatches. */
export function ToneSwatches({
  tone,
  onChange,
}: {
  tone: GroupTone;
  onChange: (t: GroupTone) => void;
}) {
  return (
    <div className="row" style={{ gap: 10 }}>
      {groupTones.map((t) => (
        <button
          key={t}
          type="button"
          aria-pressed={tone === t}
          aria-label={`${t} colour`}
          onClick={() => onChange(t)}
          style={{
            width: 44,
            height: 44,
            padding: 4,
            borderRadius: '50%',
            border: `2.5px solid ${tone === t ? 'var(--text)' : 'transparent'}`,
            background: 'transparent',
            cursor: 'pointer',
            transition: 'border-color .15s',
          }}
        >
          <i
            style={{
              display: 'block',
              width: '100%',
              height: '100%',
              borderRadius: '50%',
              background: toneColor(t),
              border: '1.5px solid var(--line)',
            }}
          />
        </button>
      ))}
    </div>
  );
}

/** A problem with the name, under its field. */
export function NameError({ text }: { text: string }) {
  return (
    <span
      role="alert"
      style={{ fontSize: 13, fontWeight: 600, color: 'var(--acc)', paddingLeft: 14 }}
    >
      {text}
    </span>
  );
}
