'use client';

import { useState } from 'react';
import type { GamingIdKind, Me, Platform, PlayTag } from './api';
import {
  customGame,
  gameMatches,
  idKindLabel,
  idKinds,
  platformLabel,
  platforms,
  tagLabel,
  type Game,
} from './data';
import { useApp } from './store';
import { Chip, Dialog, Field, Icon, Label, Pill } from './ui';

/** Games with ranks and roles, platforms, tags and gaming IDs, as edited. */
export type GamerDraft = {
  games: string[];
  /** Custom games' names by key (`x:<name>`), as typed. */
  custom: Record<string, string>;
  /** Game key → rank id (catalog) or free text (custom). */
  ranks: Record<string, string>;
  roles: Record<string, string>;
  platforms: Platform[];
  tags: PlayTag[];
  /** Row key (`discord`, `in_game:codm`…) → value / public. */
  ids: Record<string, string>;
  idVis: Record<string, boolean>;
};

export function draftFrom(me: Me): GamerDraft {
  const d: GamerDraft = {
    games: [],
    custom: {},
    ranks: {},
    roles: {},
    platforms: [...me.platforms],
    tags: [...me.tags],
    ids: {},
    idVis: {},
  };
  for (const g of me.games) {
    const key = g.game?.id ?? `x:${(g.customGameName ?? '?').toLowerCase()}`;
    if (!g.game) d.custom[key] = g.customGameName ?? '?';
    d.games.push(key);
    const r = g.rank?.id ?? g.rankText;
    if (r) d.ranks[key] = r;
    if (g.role) d.roles[key] = g.role.id;
  }
  for (const x of me.gamingIds) {
    const k = x.kind === 'in_game' ? `in_game:${x.game?.id}` : x.kind;
    d.ids[k] = x.value;
    d.idVis[k] = x.visibility === 'public';
  }
  return d;
}

export const sameDraft = (a: GamerDraft, b: GamerDraft) =>
  JSON.stringify(normal(a)) === JSON.stringify(normal(b));
const normal = (d: GamerDraft) => ({
  ...d,
  ids: Object.fromEntries(Object.entries(d.ids).filter(([, v]) => v.trim())),
  idVis: Object.fromEntries(Object.entries(d.idVis).filter(([k]) => (d.ids[k] ?? '').trim())),
});

/** Looks a draft game up: the catalog, or a custom one with its typed name. */
export function useGameOf() {
  const { game } = useApp();
  return (d: GamerDraft, key: string): Game =>
    d.custom[key] ? customGame(d.custom[key]) : game(key);
}

/** ID rows: the fixed kinds, plus an in-game ID per mobile game. */
export function idRows(d: GamerDraft, gameOf: (d: GamerDraft, k: string) => Game) {
  return [
    ...idKinds.map((k) => k as string),
    ...d.games
      .filter((k) => !d.custom[k] && gameOf(d, k).platforms.includes('mobile'))
      .map((k) => `in_game:${k}`),
  ];
}

export function gameInputs(d: GamerDraft, gameOf: (d: GamerDraft, k: string) => Game) {
  return d.games.map((k) => {
    if (d.custom[k]) {
      const t = d.ranks[k]?.trim();
      return { customGameName: d.custom[k], ...(t ? { rankText: t } : {}) };
    }
    const g = gameOf(d, k);
    const rankId = g.ranks.find((r) => r.id === d.ranks[k])?.id;
    const roleId = g.roles.find((r) => r.id === d.roles[k])?.id;
    return { gameId: k, ...(rankId ? { rankId } : {}), ...(roleId ? { roleId } : {}) };
  });
}

export function idInputs(d: GamerDraft, gameOf: (d: GamerDraft, k: string) => Game) {
  return idRows(d, gameOf)
    .filter((k) => (d.ids[k] ?? '').trim())
    .map((k) => {
      const inGame = k.startsWith('in_game:');
      return {
        kind: (inGame ? 'in_game' : k) as GamingIdKind,
        ...(inGame ? { gameId: k.slice(8) } : {}),
        value: d.ids[k]!.trim(),
        visibility: d.idVis[k] ? ('public' as const) : ('connections' as const),
      };
    });
}

/** Searchable, platform-filterable catalog with "add your own". */
export function GamePicker({
  draft,
  onChange,
  height = 420,
}: {
  draft: GamerDraft;
  onChange: (d: GamerDraft) => void;
  height?: number | string;
}) {
  const { games } = useApp();
  const [q, setQ] = useState('');
  const [plat, setPlat] = useState<Platform | null>(null);
  const [adding, setAdding] = useState<string | null>(null);
  const pool: Game[] = [...Object.values(draft.custom).map(customGame), ...games];
  const shown = pool.filter(
    (g) => gameMatches(g, q) && (!plat || g.custom || g.platforms.includes(plat)),
  );
  const exact = pool.some((g) => g.name.toLowerCase() === q.trim().toLowerCase());
  const toggle = (id: string) =>
    onChange({
      ...draft,
      games: draft.games.includes(id) ? draft.games.filter((x) => x !== id) : [...draft.games, id],
    });
  const add = (name: string) => {
    const n = name.trim();
    if (!n) return;
    const known = pool.find((g) => g.name.toLowerCase() === n.toLowerCase());
    const key = known?.id ?? customGame(n).id;
    onChange({
      ...draft,
      custom: known ? draft.custom : { ...draft.custom, [key]: n },
      games: draft.games.includes(key) ? draft.games : [...draft.games, key],
    });
    setQ('');
    setAdding(null);
  };
  return (
    <div className="gap" style={{ gap: 10, height }}>
      <Field
        value={q}
        onChange={setQ}
        placeholder={`Search ${games.length}+ games`}
        h={48}
        leading={<Icon name="search" size={18} color="var(--muted)" />}
        aria-label="Search games"
      />
      <div className="scroller">
        <Chip on={!plat} onClick={() => setPlat(null)} h={32} padH={12}>
          All
        </Chip>
        {platforms.map((p) => (
          <Chip key={p} on={plat === p} onClick={() => setPlat(p)} h={32} padH={12}>
            {platformLabel[p]}
          </Chip>
        ))}
      </div>
      <div className="row" style={{ justifyContent: 'space-between', padding: '0 6px' }}>
        <Label>{shown.length} GAMES</Label>
        <Label color={draft.games.length ? 'var(--text)' : undefined}>
          {draft.games.length} SELECTED
        </Label>
      </div>
      <div className="rows grow" style={{ overflowY: 'auto', minHeight: 160 }}>
        {q.trim() && !exact && (
          <AddRow
            label={`Add “${q.trim()}” as your own game`}
            onClick={() => setAdding(q.trim())}
          />
        )}
        {shown.length === 0 && q.trim() && (
          <div
            className="muted"
            style={{ padding: '18px 16px 6px', textAlign: 'center', fontSize: 14 }}
          >
            No match in the catalog.
          </div>
        )}
        {shown.map((g) => {
          const on = draft.games.includes(g.id);
          return (
            <button
              key={g.id}
              type="button"
              className="r"
              aria-pressed={on}
              onClick={() => toggle(g.id)}
              style={{ background: on ? 'var(--soft)' : undefined, padding: '9px 12px' }}
            >
              <span
                className="card dark flat row"
                style={{
                  width: 42,
                  height: 42,
                  borderRadius: 12,
                  justifyContent: 'center',
                  fontSize: 12,
                  fontWeight: 800,
                  padding: 3,
                  border: 0,
                  overflow: 'hidden',
                }}
              >
                {g.shortCode}
              </span>
              <span className="grow">
                <span
                  className="ellipsis"
                  style={{ display: 'block', fontSize: 15, fontWeight: 700 }}
                >
                  {g.name}
                </span>
                <span className="ellipsis muted" style={{ display: 'block', fontSize: 12 }}>
                  {g.custom
                    ? 'Added by you'
                    : platforms
                        .filter((p) => g.platforms.includes(p))
                        .map((p) => platformLabel[p])
                        .join(' · ')}
                </span>
              </span>
              <span
                className="row"
                style={{
                  width: 24,
                  height: 24,
                  borderRadius: 12,
                  justifyContent: 'center',
                  border: `2px solid ${on ? 'var(--accent)' : 'var(--muted)'}`,
                  background: on ? 'var(--accent)' : undefined,
                  color: 'var(--on-accent)',
                }}
              >
                {on && <Icon name="check" size={14} />}
              </span>
            </button>
          );
        })}
        <AddRow label="Can’t find it? Add another game" quiet onClick={() => setAdding('')} />
      </div>
      {adding !== null && (
        <AddGameDialog initial={adding} onAdd={add} onClose={() => setAdding(null)} />
      )}
    </div>
  );
}

function AddRow({
  label,
  onClick,
  quiet,
}: {
  label: string;
  onClick: () => void;
  quiet?: boolean;
}) {
  return (
    <button type="button" className="r" onClick={onClick} style={{ padding: 12 }}>
      <span
        className="row"
        style={{
          width: 42,
          height: 42,
          borderRadius: 12,
          justifyContent: 'center',
          border: '1.5px solid var(--line)',
          background: quiet ? 'transparent' : 'var(--accent)',
          color: quiet ? 'var(--text)' : 'var(--on-accent)',
        }}
      >
        <Icon name="plus" size={18} />
      </span>
      <span style={{ fontSize: 14, fontWeight: 700, color: quiet ? 'var(--muted)' : undefined }}>
        {label}
      </span>
    </button>
  );
}

function AddGameDialog({
  initial,
  onAdd,
  onClose,
}: {
  initial: string;
  onAdd: (n: string) => void;
  onClose: () => void;
}) {
  const [name, setName] = useState(initial);
  return (
    <Dialog onClose={onClose}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>Add another game</div>
      <div className="muted" style={{ fontSize: 14, lineHeight: 1.35 }}>
        It’ll show on your profile. You can type your rank or level for it.
      </div>
      <Field value={name} onChange={setName} placeholder="Game name" h={50} sunken autoFocus />
      <div className="row" style={{ gap: 8 }}>
        <Pill h={46} size={15} expand look="clear" onClick={onClose}>
          Cancel
        </Pill>
        <Pill h={46} size={15} expand bold look="accent" shadow={3} onClick={() => onAdd(name)}>
          Add game
        </Pill>
      </div>
    </Dialog>
  );
}

/** One game's rank (chips, or text for custom games) and role. */
export function RankCard({
  game,
  rank,
  role,
  onRank,
  onRole,
  onRemove,
}: {
  game: Game;
  rank?: string;
  role?: string;
  onRank: (v: string) => void;
  onRole?: (v: string) => void;
  onRemove?: () => void;
}) {
  const picked = game.custom ? rank : game.ranks.find((r) => r.id === rank)?.name;
  return (
    <div className="card gap" style={{ padding: '12px 0 12px 14px', borderRadius: 22, gap: 10 }}>
      <div className="row" style={{ paddingRight: onRemove ? 8 : 14, gap: 8 }}>
        <span className="grow ellipsis" style={{ fontSize: 16, fontWeight: 700 }}>
          {game.name}
        </span>
        <Label color={picked ? 'var(--text)' : undefined} style={{ maxWidth: '45%' }}>
          <span className="ellipsis" style={{ display: 'block' }}>
            {picked ? picked.toUpperCase() : `PICK A ${game.hasRanks ? 'RANK' : 'LEVEL'}`}
          </span>
        </Label>
        {onRemove && (
          <button
            type="button"
            className="u"
            style={{ display: 'flex', padding: 6 }}
            onClick={onRemove}
            aria-label={`Remove ${game.name}`}
          >
            <Icon name="close" size={16} color="var(--muted)" />
          </button>
        )}
      </div>
      {game.custom || game.ranks.length === 0 ? (
        <div style={{ paddingRight: 14 }}>
          <Field
            value={rank ?? ''}
            onChange={onRank}
            placeholder="Your rank or level (optional)"
            h={42}
            sunken
            style={{ fontSize: 14 }}
          />
        </div>
      ) : (
        <div className="scroller" style={{ paddingRight: 14 }}>
          {game.ranks.map((r) => (
            <Chip key={r.id} on={rank === r.id} onClick={() => onRank(r.id)}>
              {r.name}
            </Chip>
          ))}
        </div>
      )}
      {onRole && game.roles.length > 0 && (
        <>
          <Label>ROLE</Label>
          <div className="scroller" style={{ paddingRight: 14 }}>
            {game.roles.map((r) => (
              <Chip key={r.id} on={role === r.id} onClick={() => onRole(r.id)}>
                {r.name}
              </Chip>
            ))}
          </div>
        </>
      )}
    </div>
  );
}

export function PlatformChips({
  value,
  onChange,
}: {
  value: Platform[];
  onChange: (v: Platform[]) => void;
}) {
  return (
    <div className="wrap">
      {platforms.map((p) => (
        <Chip
          key={p}
          on={value.includes(p)}
          onClick={() => onChange(value.includes(p) ? value.filter((x) => x !== p) : [...value, p])}
          h={36}
          padH={14}
          size={14}
        >
          {platformLabel[p]}
        </Chip>
      ))}
    </div>
  );
}

export function TagChips({
  value,
  onChange,
}: {
  value: PlayTag[];
  onChange: (v: PlayTag[]) => void;
}) {
  const { toast } = useApp();
  return (
    <div className="wrap">
      {(Object.keys(tagLabel) as PlayTag[]).map((x) => (
        <Chip
          key={x}
          on={value.includes(x)}
          onClick={() => {
            if (value.includes(x)) return onChange(value.filter((y) => y !== x));
            if (value.length >= 6) return toast('Pick up to 6');
            onChange([...value, x]);
          }}
          h={36}
          padH={14}
          size={14}
        >
          {tagLabel[x]}
        </Chip>
      ))}
    </div>
  );
}

/** Gaming ID rows with a public / connections toggle each. */
export function IdRows({
  draft,
  onChange,
}: {
  draft: GamerDraft;
  onChange: (d: GamerDraft) => void;
}) {
  const gameOf = useGameOf();
  return (
    <div className="rows">
      {idRows(draft, gameOf).map((k) => {
        const label = k.startsWith('in_game:')
          ? `${gameOf(draft, k.slice(8)).shortCode} UID`
          : idKindLabel[k as GamingIdKind];
        const pub = draft.idVis[k] ?? false;
        return (
          <div key={k} className="r" style={{ padding: '8px 10px 8px 14px' }}>
            <span className="ellipsis" style={{ width: 84, fontSize: 13, fontWeight: 700 }}>
              {label}
            </span>
            <input
              className="grow"
              value={draft.ids[k] ?? ''}
              onChange={(e) => onChange({ ...draft, ids: { ...draft.ids, [k]: e.target.value } })}
              placeholder="Add ID"
              aria-label={label}
              maxLength={64}
              style={{
                border: 0,
                outline: 0,
                background: 'transparent',
                color: 'var(--text)',
                font: 'inherit',
                fontSize: 16,
              }}
            />
            <button
              type="button"
              className="pill"
              onClick={() => onChange({ ...draft, idVis: { ...draft.idVis, [k]: !pub } })}
              style={{
                height: 28,
                padding: '0 10px',
                background: pub ? 'var(--strong)' : 'transparent',
                color: pub ? 'var(--on-strong)' : 'var(--text)',
                borderWidth: 1.5,
              }}
            >
              <Label size={9} color="inherit">
                {pub ? 'PUBLIC' : 'CONNECTIONS'}
              </Label>
            </button>
          </div>
        );
      })}
    </div>
  );
}
