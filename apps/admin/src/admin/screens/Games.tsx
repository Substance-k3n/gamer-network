import type { CSSProperties } from 'react';
import { PLATS, type Game } from '../data';
import { emptyGame, type Admin } from '../state';
import { Chip } from '../ui';
import {
  ACC,
  C1,
  DK,
  DOTO,
  LINE,
  MUT,
  PANEL,
  RING,
  RULE,
  TX,
  fmt,
  grot,
  label,
  mono,
  pad2,
} from '../tokens';

const field: CSSProperties = {
  height: 44,
  borderRadius: 12,
  border: `1px solid ${LINE}`,
  background: PANEL,
  color: TX,
  padding: '0 14px',
  fontSize: 15,
  outline: 'none',
};

const iconBtn: CSSProperties = {
  width: 30,
  height: 30,
  borderRadius: 8,
  border: `1px solid ${LINE}`,
  background: 'transparent',
  color: TX,
  cursor: 'pointer',
  fontSize: 13,
};

export function Games({ admin }: { admin: Admin }) {
  const { s, set, toast } = admin;
  const isNew = s.gameSel === 'new';
  const cur: Omit<Game, 'id' | 'players'> & { id?: string } = isNew
    ? s.newG
    : (s.games.find((g) => g.id === s.gameSel) ?? s.games[0]);

  const upd = (patch: Partial<Game>) =>
    isNew
      ? set((st) => ({ newG: { ...st.newG, ...patch } }))
      : set((st) => ({ games: st.games.map((g) => (g.id === cur.id ? { ...g, ...patch } : g)) }));
  const move = (i: number, d: number) => {
    const r = [...cur.ranks];
    const j = i + d;
    if (j < 0 || j >= r.length) return;
    [r[i], r[j]] = [r[j], r[i]];
    upd({ ranks: r });
  };
  const addRank = () => {
    const v = s.rankDraft.trim();
    if (!v) return;
    upd({ ranks: [...cur.ranks, v] });
    set({ rankDraft: '' });
  };
  const save = () => {
    if (!cur.name.trim()) {
      toast('Give the game a name');
      return;
    }
    if (isNew) {
      const id = `g${Date.now()}`;
      const g: Game = {
        ...cur,
        id,
        short: cur.short || cur.name.slice(0, 4).toUpperCase(),
        players: 0,
      };
      set((st) => ({ games: [...st.games, g], gameSel: id, newG: emptyGame() }));
      toast(`${g.name} added — players can pick it now`);
    } else toast(`${cur.name} saved`);
  };
  const del = () => {
    const rest = s.games.filter((g) => g.id !== cur.id);
    set({ games: rest, gameSel: rest[0] ? rest[0].id : 'new' });
    toast(`${cur.name} removed from catalog`);
  };
  const n = cur.ranks.length;

  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit,minmax(380px,1fr))',
        gap: 16,
        alignItems: 'start',
      }}
    >
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fill,minmax(170px,1fr))',
          gap: 12,
        }}
      >
        <div
          onClick={() => set({ gameSel: 'new', rankDraft: '' })}
          style={{
            border: `1.5px dashed ${isNew ? ACC : '#444444'}`,
            borderRadius: 22,
            minHeight: 150,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 6,
            cursor: 'pointer',
            color: TX,
          }}
        >
          <span
            style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 40, lineHeight: 1, color: ACC }}
          >
            +
          </span>
          <span style={{ fontWeight: 600, fontSize: 14 }}>Add game</span>
        </div>
        {s.games.map((g) => {
          const sel = !isNew && g.id === cur.id;
          return (
            <div
              key={g.id}
              onClick={() => set({ gameSel: g.id, rankDraft: '' })}
              style={{
                background: C1,
                border: `1px solid ${sel ? ACC : LINE}`,
                borderRadius: 22,
                padding: 14,
                minHeight: 150,
                boxSizing: 'border-box',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
                cursor: 'pointer',
                opacity: g.enabled ? 1 : 0.55,
                boxShadow: sel ? '0 10px 26px rgba(255,77,42,.22)' : '0 14px 30px rgba(0,0,0,.45)',
              }}
            >
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'flex-start',
                }}
              >
                <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 26 }}>{g.short}</span>
                <span style={{ font: mono(700, 10), color: g.enabled ? ACC : MUT }}>
                  {g.enabled ? 'LIVE' : 'HIDDEN'}
                </span>
              </div>
              <div>
                <div style={{ fontWeight: 600, fontSize: 15 }}>{g.name}</div>
                <div style={{ font: mono(400, 11), color: MUT, marginTop: 4 }}>
                  {fmt(g.players)} PLAYERS · {g.ranks.length} TIERS
                </div>
              </div>
            </div>
          );
        })}
      </div>

      <div
        style={{
          background: C1,
          borderRadius: 24,
          boxShadow: RING,
          padding: 20,
          display: 'flex',
          flexDirection: 'column',
          gap: 14,
          position: 'sticky',
          top: 20,
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 26 }}>
            {isNew ? 'New game' : cur.name || 'Untitled'}
          </span>
          <div
            onClick={() => upd({ enabled: !cur.enabled })}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              cursor: 'pointer',
              font: mono(700, 11),
            }}
          >
            <span>{cur.enabled ? 'VISIBLE' : 'HIDDEN'}</span>
            <div
              style={{
                width: 44,
                height: 24,
                borderRadius: 99,
                background: cur.enabled ? ACC : '#3A3A3A',
                position: 'relative',
                transition: 'background .2s',
              }}
            >
              <div
                style={{
                  position: 'absolute',
                  top: 3,
                  left: 3,
                  width: 18,
                  height: 18,
                  borderRadius: '50%',
                  background: TX,
                  transform: `translateX(${cur.enabled ? '20px' : '0px'})`,
                  transition: 'transform .2s',
                }}
              />
            </div>
          </div>
        </div>

        <div
          style={{ display: 'grid', gridTemplateColumns: 'minmax(0,2fr) minmax(0,1fr)', gap: 10 }}
        >
          <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            <span style={label}>NAME</span>
            <input
              value={cur.name}
              onChange={(e) => upd({ name: e.target.value })}
              placeholder="e.g. Apex Legends"
              style={field}
            />
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            <span style={label}>SHORT CODE</span>
            <input
              value={cur.short}
              onChange={(e) => upd({ short: e.target.value.toUpperCase().slice(0, 5) })}
              placeholder="APEX"
              style={{ ...field, font: mono(700, 14), textTransform: 'uppercase' }}
            />
          </div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <span style={label}>PLATFORMS</span>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {PLATS.map((p) => {
              const sel = cur.platforms.includes(p);
              return (
                <Chip
                  key={p}
                  on={sel}
                  height={34}
                  size={13}
                  padX={13}
                  onClick={() =>
                    upd({
                      platforms: sel ? cur.platforms.filter((x) => x !== p) : [...cur.platforms, p],
                    })
                  }
                >
                  {p}
                </Chip>
              );
            })}
          </div>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <span style={label}>RANK LADDER · LOWEST FIRST</span>
            <span style={label}>{pad2(n)} TIERS</span>
          </div>
          <div
            style={{
              border: `1px solid ${LINE}`,
              borderRadius: 16,
              background: PANEL,
              overflow: 'hidden',
            }}
          >
            {cur.ranks.map((r, i) => (
              <div
                key={`${r}-${i}`}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 10,
                  padding: '7px 8px 7px 12px',
                  borderTop: i ? `1px solid ${RULE}` : 'none',
                }}
              >
                <span style={{ font: mono(700, 11), color: MUT, width: 22 }}>{pad2(i + 1)}</span>
                <div
                  style={{
                    flex: 'none',
                    height: 8,
                    width: 10 + Math.round(((i + 1) / n) * 44),
                    background: ACC,
                    borderRadius: 4,
                    opacity: 0.35 + (0.65 * (i + 1)) / n,
                  }}
                />
                <span style={{ flex: 1, fontWeight: 600, fontSize: 14 }}>{r}</span>
                <button type="button" onClick={() => move(i, -1)} title="Move up" style={iconBtn}>
                  ↑
                </button>
                <button type="button" onClick={() => move(i, 1)} title="Move down" style={iconBtn}>
                  ↓
                </button>
                <button
                  type="button"
                  onClick={() => upd({ ranks: cur.ranks.filter((_, j) => j !== i) })}
                  title="Remove"
                  style={{ ...iconBtn, color: ACC, fontSize: 15 }}
                >
                  ×
                </button>
              </div>
            ))}
            {!n && (
              <div style={{ padding: 14, fontSize: 13, color: MUT }}>
                No tiers yet. Unranked games can use play styles like “Casual” or “Co-op”.
              </div>
            )}
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <input
              value={s.rankDraft}
              onChange={(e) => set({ rankDraft: e.target.value })}
              onKeyDown={(e) => {
                if (e.key === 'Enter') addRank();
              }}
              placeholder="Add a tier, e.g. Predator"
              style={{ ...field, flex: 1, minWidth: 0, height: 40, fontSize: 14 }}
            />
            <button
              type="button"
              onClick={addRank}
              style={{
                height: 40,
                padding: '0 16px',
                borderRadius: 12,
                border: `1px solid ${LINE}`,
                background: '#232323',
                color: TX,
                font: grot(600, 14),
                cursor: 'pointer',
              }}
            >
              Add tier
            </button>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 8, marginTop: 4 }}>
          <button
            type="button"
            onClick={save}
            style={{
              flex: 1,
              height: 46,
              borderRadius: 99,
              border: 'none',
              background: ACC,
              color: DK,
              font: grot(700, 15),
              cursor: 'pointer',
            }}
          >
            {isNew ? 'Add game to catalog' : 'Save changes'}
          </button>
          {!isNew && (
            <button
              type="button"
              onClick={del}
              style={{
                height: 46,
                padding: '0 18px',
                borderRadius: 99,
                border: `1px solid ${LINE}`,
                background: 'transparent',
                color: MUT,
                font: grot(600, 14),
                cursor: 'pointer',
              }}
            >
              Delete
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
