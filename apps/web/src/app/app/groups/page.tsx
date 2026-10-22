'use client';

import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { api, query, type Group, type Page } from '../_lib/api';
import { GroupCard } from '../_lib/groupui';
import { groupKinds, kindLabel, setGroupsView, useGroupsView } from '../_lib/groups';
import { Header } from '../_lib/shell';
import { useApp, useLoad } from '../_lib/store';
import { Card, Chip, EmptyNote, Field, Icon, Label, Pill, Segmented, Spinner } from '../_lib/ui';

/** Groups: Discover and Yours, kinds and search (GET /groups), paged by cursor. */
export default function Groups() {
  const { run, version } = useApp();
  const router = useRouter();
  const v = useGroupsView();
  // The search waits for a pause in typing and needs 2+ characters.
  const [q, setQ] = useState(v.query.trim().length >= 2 ? v.query.trim() : '');
  useEffect(() => {
    const t = setTimeout(() => {
      const s = v.query.trim();
      setQ(s.length >= 2 ? s : '');
    }, 300);
    return () => clearTimeout(t);
  }, [v.query]);
  const [more, setMore] = useState<string | null>(null);
  const params = (cursor?: string | null) =>
    query({
      tab: v.tab,
      kind: v.kind === 'all' ? null : v.kind,
      query: q || null,
      cursor,
    });
  const list = useLoad(async () => {
    const pg = await api<Page<Group>>(`groups${params()}`);
    setMore(pg.nextCursor);
    return pg.items;
  }, [v.tab, v.kind, q, version]);
  // "Yours (n)": my groups and requests.
  const mine = useLoad(() => api<Page<Group>>('groups?tab=mine&limit=50'), [version]);
  const mineCount = mine.data ? `${mine.data.items.length}${mine.data.nextCursor ? '+' : ''}` : '…';
  const shown = list.data ?? [];
  const loadMore = async () => {
    const pg = await run(() => api<Page<Group>>(`groups${params(more)}`), { busy: false });
    if (!pg) return;
    list.setData([...shown, ...pg.items.filter((x) => !shown.some((y) => y.id === x.id))]);
    setMore(pg.nextCursor);
  };
  const changed = (g: Group) => {
    list.setData(shown.map((x) => (x.id === g.id ? g : x)));
    mine.reload();
  };

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
            { id: 'discover', label: 'Discover' },
            { id: 'mine', label: `Yours (${mineCount})` },
          ]}
          value={v.tab}
          onChange={(tab) => setGroupsView({ tab })}
        />
        <Field
          value={v.query}
          onChange={(text) => setGroupsView({ query: text.slice(0, 40) })}
          placeholder="Search groups, games, cities"
          h={46}
          leading={<Icon name="search" size={18} color="var(--muted)" />}
          aria-label="Search groups"
        />
        <div className="scroller">
          <Chip
            on={v.kind === 'all'}
            onClick={() => setGroupsView({ kind: 'all' })}
            h={32}
            padH={12}
          >
            All
          </Chip>
          {groupKinds.map((k) => (
            <Chip
              key={k}
              on={v.kind === k}
              onClick={() => setGroupsView({ kind: k })}
              h={32}
              padH={12}
            >
              {kindLabel[k]}
            </Chip>
          ))}
        </div>
        <Label style={{ paddingLeft: 6 }}>
          {shown.length}
          {more ? '+' : ''} {v.tab === 'mine' ? 'JOINED' : 'GROUPS'}
        </Label>
        {!list.loaded && <Spinner />}
        {list.loaded && shown.length === 0 && (
          <EmptyNote>
            {v.tab === 'mine' && v.kind === 'all' && !q
              ? 'You haven’t joined any groups yet. Discover one, or start your own.'
              : 'No groups match. Try another search, or create it.'}
          </EmptyNote>
        )}
        {shown.map((g) => (
          <GroupCard key={g.id} g={g} onChange={changed} />
        ))}
        {more && (
          <div style={{ textAlign: 'center' }}>
            <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
              Load more
            </Pill>
          </div>
        )}
      </div>
    </>
  );
}
