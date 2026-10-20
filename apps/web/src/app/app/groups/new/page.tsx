'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { gameMatches, type Tone } from '../../_lib/data';
import { GroupTile } from '../../_lib/groupui';
import { createGroup, groupKinds, groupShort, type GroupDraft } from '../../_lib/groups';
import { SheetTitle } from '../../_lib/sheets';
import { useApp } from '../../_lib/store';
import {
  Card,
  Chip,
  CircleBtn,
  Field,
  Icon,
  Label,
  Pill,
  Segmented,
  Sheet,
  TextArea,
  toneColor,
} from '../../_lib/ui';

/** New group (sample data): name, type, game, place, about, who can join, colour. */
export default function NewGroup() {
  const { me, game, toast, back } = useApp();
  const router = useRouter();
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game.id] : []));
  const [d, setD] = useState<GroupDraft>(() => ({
    name: '',
    place: me?.city ?? 'Addis Ababa',
    about: '',
    kind: 'Game',
    gameId: myGames[0],
    approval: false,
    tone: 'accent',
  }));
  const [picking, setPicking] = useState(false);
  const set = (p: Partial<GroupDraft>) => setD({ ...d, ...p });
  const ready = d.name.trim().length >= 3 && (d.kind !== 'Game' || !!d.gameId);
  const gameIds = [...myGames, ...(d.gameId && !myGames.includes(d.gameId) ? [d.gameId] : [])];
  const short = groupShort(d, (id) => game(id).shortCode);
  const placeHint =
    d.kind === 'Campus' ? 'Addis Ababa University' : d.kind === 'Game' ? 'Ethiopia' : 'Addis Ababa';

  const create = () => {
    if (d.name.trim().length < 3) return toast('Give your group a name (3+ characters)');
    if (d.kind === 'Game' && !d.gameId) return toast('Pick the game this group is for');
    if (!d.place.trim()) return toast('Add a city, campus or country');
    const g = createGroup(d, short);
    // The new page replaces this form, so back goes to the Groups tab.
    router.replace(`/app/groups/${g.id}?tab=About`);
    toast(`${g.name} is live — invite your squad`);
  };
  const labeled = (label: string, field: React.ReactNode) => (
    <div className="gap" style={{ gap: 6 }}>
      <Label style={{ paddingLeft: 14 }}>{label}</Label>
      {field}
    </div>
  );

  return (
    <div style={{ paddingBottom: 40 }}>
      {picking && (
        <PickGame
          selected={d.gameId}
          onPick={(id) => {
            set({ gameId: id });
            setPicking(false);
          }}
          onClose={() => setPicking(false)}
        />
      )}
      <div className="row rl-pad" style={{ gap: 8, padding: '4px 16px 10px' }}>
        <CircleBtn onClick={() => back('/app/groups')} label="Close">
          <Icon name="close" size={18} />
        </CircleBtn>
        <h1
          className="grow"
          style={{
            margin: 0,
            textAlign: 'center',
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: -0.5,
          }}
        >
          New group
        </h1>
        <Pill
          h={42}
          padH={20}
          size={15}
          bold
          look={ready ? 'accent' : 'quiet'}
          shadow={3}
          onClick={create}
        >
          Create
        </Pill>
      </div>
      <div className="gap rl-pad" style={{ gap: 14, paddingTop: 4 }}>
        <Card pad={14}>
          <div className="row" style={{ gap: 14 }}>
            <GroupTile short={short} tone={d.tone} size={56} />
            <div className="grow">
              <div
                className="ellipsis"
                style={{ fontSize: 19, fontWeight: 800, letterSpacing: -0.5 }}
              >
                {d.name.trim() || 'Your group'}
              </div>
              <div className="muted ellipsis" style={{ fontSize: 13 }}>
                {d.kind === 'Game' && d.gameId ? game(d.gameId).name : d.kind} ·{' '}
                {d.place.trim() || placeHint}
              </div>
            </div>
          </div>
        </Card>
        {labeled(
          'NAME',
          <Field
            value={d.name}
            onChange={(name) => set({ name: name.slice(0, 60) })}
            placeholder="e.g. Valorant Addis Duo Queue"
            h={50}
            aria-label="Group name"
          />,
        )}
        {labeled(
          'TYPE',
          <Segmented
            options={groupKinds.map((k) => ({ id: k, label: k }))}
            value={d.kind}
            onChange={(kind) => set({ kind })}
          />,
        )}
        {d.kind === 'Game' &&
          labeled(
            'GAME',
            <div className="scroller">
              {gameIds.map((id) => (
                <Chip key={id} on={d.gameId === id} onClick={() => set({ gameId: id })}>
                  {game(id).name}
                </Chip>
              ))}
              <Pill look="clear" onClick={() => setPicking(true)} style={{ flex: 'none' }}>
                <Icon name="search" size={14} /> Other game
              </Pill>
            </div>,
          )}
        {labeled(
          d.kind === 'Campus' ? 'CAMPUS' : 'CITY OR COUNTRY',
          <Field
            value={d.place}
            onChange={(place) => set({ place: place.slice(0, 60) })}
            placeholder={placeHint}
            h={50}
            aria-label={d.kind === 'Campus' ? 'Campus' : 'City or country'}
          />,
        )}
        {labeled(
          'ABOUT',
          <TextArea
            value={d.about}
            onChange={(about) => set({ about: about.slice(0, 500) })}
            placeholder="Who is it for? What do you play, and when?"
            rows={3}
          />,
        )}
        {labeled(
          'WHO CAN JOIN',
          <Segmented
            options={[
              { id: 'Anyone', label: 'Anyone' },
              { id: 'Approval', label: 'Approval' },
            ]}
            value={d.approval ? 'Approval' : 'Anyone'}
            onChange={(v) => set({ approval: v === 'Approval' })}
          />,
        )}
        {labeled(
          'COLOUR',
          <div className="row" style={{ gap: 10 }}>
            {(['accent', 'lav', 'soft', 'grey'] as Tone[]).map((t) => (
              <button
                key={t}
                type="button"
                aria-pressed={d.tone === t}
                aria-label={`${t} colour`}
                onClick={() => set({ tone: t })}
                style={{
                  width: 44,
                  height: 44,
                  padding: 4,
                  borderRadius: '50%',
                  border: `2.5px solid ${d.tone === t ? 'var(--text)' : 'transparent'}`,
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
          </div>,
        )}
        <div className="muted" style={{ fontSize: 13 }}>
          You’ll be the admin. You can post events and approve members.
        </div>
      </div>
    </div>
  );
}

/** "Other game": one game from the catalog, or one typed in. */
function PickGame({
  selected,
  onPick,
  onClose,
}: {
  selected?: string;
  onPick: (id: string) => void;
  onClose: () => void;
}) {
  const { games, addCustomGame } = useApp();
  const [q, setQ] = useState('');
  const shown = games.filter((g) => gameMatches(g, q));
  const exact = games.some((g) => g.name.toLowerCase() === q.trim().toLowerCase());
  return (
    <Sheet onClose={onClose}>
      <SheetTitle onClose={onClose}>Pick the game</SheetTitle>
      <div className="gap" style={{ gap: 10 }}>
        <Field
          value={q}
          onChange={setQ}
          placeholder={`Search ${games.length}+ games`}
          h={48}
          leading={<Icon name="search" size={18} color="var(--muted)" />}
          aria-label="Search games"
          autoFocus
        />
        <div className="rows" style={{ maxHeight: '50dvh', overflowY: 'auto' }}>
          {q.trim() && !exact && (
            <button type="button" className="r" onClick={() => onPick(addCustomGame(q.trim()))}>
              <Icon name="plus" size={16} />
              <span className="grow" style={{ fontSize: 14, fontWeight: 600 }}>
                Add “{q.trim()}” as your own game
              </span>
            </button>
          )}
          {shown.map((g) => (
            <button
              key={g.id}
              type="button"
              className="r"
              aria-pressed={selected === g.id}
              onClick={() => onPick(g.id)}
              style={{ background: selected === g.id ? 'var(--soft)' : undefined }}
            >
              <span className="grow ellipsis" style={{ fontSize: 15, fontWeight: 600 }}>
                {g.name}
              </span>
              <span className="muted" style={{ fontSize: 12 }}>
                {g.shortCode}
              </span>
            </button>
          ))}
        </div>
      </div>
    </Sheet>
  );
}
