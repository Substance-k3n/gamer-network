'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { api, ApiError, uuid, type Group, type GroupKind, type GroupTone } from '../../_lib/api';
import { gameMatches } from '../../_lib/data';
import { GroupTile, NameError, RulesEditor, ToneSwatches } from '../../_lib/groupui';
import { groupKinds, kindLabel, setGroupsView } from '../../_lib/groups';
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
} from '../../_lib/ui';

type Draft = {
  name: string;
  place: string;
  about: string;
  kind: GroupKind;
  gameId?: string;
  approval: boolean;
  tone: GroupTone;
  rules: string[];
};

/** The badge the API makes from a name: initials of up to 4 words, or a word's first 4 letters. */
function shortOf(name: string) {
  const words = name
    .toUpperCase()
    .split(/\s+/)
    .map((w) => w.replace(/[^A-Z0-9]/g, ''))
    .filter(Boolean);
  if (!words.length) return '?';
  return words.length > 1
    ? words
        .slice(0, 4)
        .map((w) => w[0])
        .join('')
    : words[0]!.slice(0, 4);
}

/**
 * New group (POST /groups): name, type, game, place, about, rules, who can
 * join, colour. A taken name is said on its field.
 */
export default function NewGroup() {
  const { me, game, run, toast, back, busy } = useApp();
  const router = useRouter();
  const myGames = (me?.games ?? []).flatMap((g) => (g.game ? [g.game.id] : []));
  const [d, setD] = useState<Draft>(() => ({
    name: '',
    place: me?.city ?? 'Addis Ababa',
    about: '',
    kind: 'game',
    gameId: myGames[0],
    approval: false,
    tone: 'accent',
    rules: [],
  }));
  const [nameError, setNameError] = useState<string | null>(null);
  const [picking, setPicking] = useState(false);
  const [key] = useState(uuid);
  const set = (p: Partial<Draft>) => setD({ ...d, ...p });
  const ready = d.name.trim().length >= 3 && (d.kind !== 'game' || !!d.gameId);
  const gameIds = [...myGames, ...(d.gameId && !myGames.includes(d.gameId) ? [d.gameId] : [])];
  const short = shortOf(d.name);
  const placeHint =
    d.kind === 'campus' ? 'Addis Ababa University' : d.kind === 'game' ? 'Ethiopia' : 'Addis Ababa';

  const create = async () => {
    if (d.name.trim().length < 3) return setNameError('Give your group a name (3+ characters)');
    if (d.kind === 'game' && !d.gameId) return toast('Pick the game this group is for');
    if (!d.place.trim()) return toast('Add a city, campus or country');
    const g = await run(async () => {
      try {
        return await api<Group>('groups', {
          method: 'POST',
          key,
          body: {
            name: d.name.trim(),
            kind: d.kind,
            ...(d.kind === 'game' ? { gameId: d.gameId } : {}),
            place: d.place.trim(),
            about: d.about.trim(),
            rules: d.rules.map((r) => r.trim()).filter(Boolean),
            approval: d.approval,
            tone: d.tone,
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
    if (!g) return;
    setGroupsView({ tab: 'mine' });
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
          disabled={busy}
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
                {d.kind === 'game' && d.gameId ? game(d.gameId).name : kindLabel[d.kind]} ·{' '}
                {d.place.trim() || placeHint}
              </div>
            </div>
          </div>
        </Card>
        {labeled(
          'NAME',
          <>
            <Field
              value={d.name}
              onChange={(name) => {
                set({ name: name.slice(0, 40) });
                setNameError(null);
              }}
              placeholder="e.g. Valorant Addis Duo Queue"
              h={50}
              maxLength={40}
              aria-label="Group name"
            />
            {nameError && <NameError text={nameError} />}
          </>,
        )}
        {labeled(
          'TYPE',
          <Segmented
            options={groupKinds.map((k) => ({ id: k, label: kindLabel[k] }))}
            value={d.kind}
            onChange={(kind) => set({ kind })}
          />,
        )}
        {d.kind === 'game' &&
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
          d.kind === 'campus' ? 'CAMPUS' : 'CITY OR COUNTRY',
          <Field
            value={d.place}
            onChange={(place) => set({ place: place.slice(0, 60) })}
            placeholder={placeHint}
            h={50}
            maxLength={60}
            aria-label={d.kind === 'campus' ? 'Campus' : 'City or country'}
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
        {labeled('RULES', <RulesEditor rules={d.rules} onChange={(rules) => set({ rules })} />)}
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
        {labeled('COLOUR', <ToneSwatches tone={d.tone} onChange={(tone) => set({ tone })} />)}
        <div className="muted" style={{ fontSize: 13 }}>
          You’ll be the admin. You can post events and approve members.
        </div>
      </div>
    </div>
  );
}

/** "Other game": one game from the catalog (a group's game must be one). */
function PickGame({
  selected,
  onPick,
  onClose,
}: {
  selected?: string;
  onPick: (id: string) => void;
  onClose: () => void;
}) {
  const { games } = useApp();
  const [q, setQ] = useState('');
  const shown = games.filter((g) => gameMatches(g, q));
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
