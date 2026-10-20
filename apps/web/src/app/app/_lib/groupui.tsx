'use client';

import { useRouter } from 'next/navigation';
import { rankLine } from './data';
import {
  groupCount,
  groupLine,
  groupSize,
  joinGroup,
  leaveGroup,
  members,
  useGroups,
  type Group,
  type Member,
} from './groups';
import { useApp } from './store';
import { Avatar, Card, Label, Pill, TypeTag, toneColor, useConfirm } from './ui';

// The shared pieces of the Groups screens (the prototype's groups.dart).

/** A sample member as the screens show them; "me" is the player. */
export function useMember() {
  const { me } = useApp();
  return (who: string): Member =>
    who === 'me'
      ? {
          name: me?.displayName ?? 'You',
          handle: me?.username ?? '',
          tone: 'accent',
          rank: rankLine(me?.games[0]),
        }
      : members[who]!;
}

/** "Valorant · Ethiopia" with the catalog's game names. */
export function useGroupLine() {
  const { game } = useApp();
  return (g: Group) => groupLine(g, (id) => game(id).name);
}

/** Square badge with a group's short name. */
export function GroupTile({
  short,
  tone,
  size = 48,
  onDark,
}: {
  short: string;
  tone: Group['tone'];
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

/** Overlapping member faces. */
export function FaceStack({ who, size = 24 }: { who: string[]; size?: number }) {
  const member = useMember();
  const faces = who.slice(0, 4);
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
      {faces.map((w, i) => {
        const m = member(w);
        return (
          <span key={w} style={{ position: 'absolute', left: step * i, top: 0, display: 'flex' }}>
            <Avatar name={m.name} tone={m.tone} size={size} />
          </span>
        );
      })}
    </span>
  );
}

/** Join / Ask to join / Requested… / Joined ✓, sized for cards or the group page. */
export function JoinButton({ g, big }: { g: Group; big?: boolean }) {
  const { toast } = useApp();
  const { requests } = useGroups();
  const router = useRouter();
  const [ask, confirm] = useConfirm();
  const member = g.members.includes('me');
  const requested = requests.includes(g.id);
  const [label, look] = member
    ? (['Joined ✓', 'strong'] as const)
    : requested
      ? (['Requested…', 'quiet'] as const)
      : ([g.approval ? 'Ask to join' : 'Join', 'accent'] as const);
  const tap = async () => {
    if (!member) return joinGroup(g, toast);
    if (!big) return router.push(`/app/groups/${g.id}`);
    if (
      await ask(
        `Leave ${g.name}?`,
        `You’ll stop seeing its posts and events. You can join again any time${g.approval ? ' (admins approve requests)' : ''}.`,
        'Leave',
        'Stay',
      )
    )
      leaveGroup(g, toast);
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
export function GroupCard({ g }: { g: Group }) {
  const router = useRouter();
  const line = useGroupLine();
  const faces = g.members.filter((m) => m !== 'me');
  const next = g.events[0];
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
              {line(g)}
            </div>
          </div>
          {/* The button acts on its own; the card opens the group. */}
          <span onClick={(e) => e.stopPropagation()} style={{ flex: 'none' }}>
            <JoinButton g={g} />
          </span>
        </div>
        <div
          className="muted"
          style={{
            fontSize: 13,
            lineHeight: 1.35,
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical',
            overflow: 'hidden',
          }}
        >
          {g.about}
        </div>
        <div className="row" style={{ gap: 8 }}>
          <FaceStack who={faces} size={22} />
          <span style={{ fontSize: 12, fontWeight: 600, flex: 'none' }}>
            {groupCount(groupSize(g))} members
          </span>
          {g.approval && (
            <TypeTag bg="var(--soft)" size={7} pad="2px 6px">
              APPROVAL
            </TypeTag>
          )}
          <span className="grow muted ellipsis" style={{ fontSize: 12, textAlign: 'right' }}>
            {next ? `Next: ${next.when}` : ''}
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
