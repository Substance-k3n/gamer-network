'use client';

import { useRouter } from 'next/navigation';
import { GroupCard } from '../_lib/groupui';
import { groupKinds, setGroupsView, useGroups } from '../_lib/groups';
import { Header } from '../_lib/shell';
import { useApp } from '../_lib/store';
import { Card, Chip, EmptyNote, Field, Icon, Label, Pill, Segmented } from '../_lib/ui';

/** Groups: discover and your groups, on sample data until the API has groups. */
export default function Groups() {
  const { game } = useApp();
  const router = useRouter();
  const s = useGroups();
  const mine = s.groups.filter((g) => g.members.includes('me'));
  const pool = s.tab === 'Yours' ? mine : s.groups;
  const q = s.query.trim().toLowerCase();
  const shown = pool.filter((g) => {
    const kindOk = s.kind === 'All' || g.kind === s.kind;
    const text = `${g.name} ${g.place} ${g.gameId ? game(g.gameId).name : ''}`.toLowerCase();
    return kindOk && (!q || text.includes(q));
  });
  return (
    <>
      <Header title="Groups" />
      <div className="gap rl-pad" style={{ gap: 14 }}>
        <Card dark pad={18} radius={26}>
          <div className="gap" style={{ gap: 12 }}>
            <Label color="var(--accent-text)">START A GROUP</Label>
            <div
              className="t-display"
              style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6, lineHeight: 1.1 }}
            >
              Your squad, your game, your city or campus.
            </div>
            <div>
              <Pill
                h={42}
                padH={16}
                size={14}
                bold
                look="accent"
                onClick={() => router.push('/app/groups/new')}
              >
                <Icon name="plus" size={16} /> Create group
              </Pill>
            </div>
          </div>
        </Card>
        <Segmented
          options={[
            { id: 'Discover', label: 'Discover' },
            { id: 'Yours', label: `Yours (${mine.length})` },
          ]}
          value={s.tab}
          onChange={(tab) => setGroupsView({ tab })}
        />
        <Field
          value={s.query}
          onChange={(query) => setGroupsView({ query })}
          placeholder="Search groups, games, cities"
          h={46}
          leading={<Icon name="search" size={18} color="var(--muted)" />}
          aria-label="Search groups"
        />
        <div className="scroller">
          {(['All', ...groupKinds] as const).map((k) => (
            <Chip
              key={k}
              on={s.kind === k}
              onClick={() => setGroupsView({ kind: k })}
              h={32}
              padH={12}
            >
              {k}
            </Chip>
          ))}
        </div>
        <Label style={{ paddingLeft: 6 }}>
          {shown.length} {s.tab === 'Yours' ? 'JOINED' : 'GROUPS'}
        </Label>
        {shown.length === 0 && (
          <EmptyNote>
            {s.tab === 'Yours' && mine.length === 0
              ? 'You haven’t joined any groups yet. Discover one, or start your own.'
              : 'No groups match. Try another search, or create it.'}
          </EmptyNote>
        )}
        {shown.map((g) => (
          <GroupCard key={g.id} g={g} />
        ))}
      </div>
    </>
  );
}
