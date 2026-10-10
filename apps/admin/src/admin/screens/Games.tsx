import { useEffect, useState } from 'react';
import { api, type Game } from '../api';
import { PLATFORM } from '../data';
import type { Admin } from '../state';
import { Chip } from '../ui';
import { ACC, C1, C2, DOTO, LINE, MUT, PANEL, RING, RULE, TX, label, mono, pad2 } from '../tokens';

const PARTY: Record<number, string> = { 2: 'Duo', 3: 'Trio', 4: 'Squad', 5: '5-stack' };

export function Games({ admin }: { admin: Admin }) {
  const { toast, fail } = admin;
  const [games, setGames] = useState<Game[] | null>(null);

  useEffect(() => {
    api<Game[]>('games').then(setGames).catch(fail);
  }, [fail]);
  const [sel, setSel] = useState<string | null>(null);
  const [only, setOnly] = useState<'launch' | 'all'>('launch');
  const [busy, setBusy] = useState(false);

  const list = (games ?? []).filter((g) => only === 'all' || g.isLaunch);
  const cur = (games ?? []).find((g) => g.id === sel) ?? list[0];
  const launchCount = (games ?? []).filter((g) => g.isLaunch).length;

  const toggle = async (g: Game) => {
    setBusy(true);
    try {
      await api(`admin/games/${g.id}`, { method: 'PATCH', body: { isLaunch: !g.isLaunch } });
      setGames(
        (all) => all && all.map((x) => (x.id === g.id ? { ...x, isLaunch: !g.isLaunch } : x)),
      );
      toast(g.isLaunch ? `${g.name} is off Find Players` : `${g.name} is on Find Players`);
    } catch (e) {
      fail(e);
    } finally {
      setBusy(false);
    }
  };

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        <Chip on={only === 'launch'} onClick={() => setOnly('launch')}>
          On Find Players ({launchCount})
        </Chip>
        <Chip on={only === 'all'} onClick={() => setOnly('all')}>
          Whole catalog ({games?.length ?? 0})
        </Chip>
        <span style={{ flex: 1 }} />
        <span style={{ fontSize: 13, color: MUT }}>
          Names and ranks come from the API&apos;s seed (apps/api/src/db/seed).
        </span>
      </div>

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
          {list.map((g) => {
            const on = g.id === cur?.id;
            return (
              <div
                key={g.id}
                onClick={() => setSel(g.id)}
                style={{
                  background: C1,
                  border: `1px solid ${on ? ACC : LINE}`,
                  borderRadius: 22,
                  padding: 14,
                  minHeight: 150,
                  boxSizing: 'border-box',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'space-between',
                  cursor: 'pointer',
                  opacity: g.isLaunch ? 1 : 0.55,
                  boxShadow: on ? '0 10px 26px rgba(255,77,42,.22)' : '0 14px 30px rgba(0,0,0,.45)',
                }}
              >
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'flex-start',
                  }}
                >
                  <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 26 }}>
                    {g.shortCode}
                  </span>
                  <span style={{ font: mono(700, 10), color: g.isLaunch ? ACC : MUT }}>
                    {g.isLaunch ? 'LIVE' : 'HIDDEN'}
                  </span>
                </div>
                <div>
                  <div style={{ fontWeight: 600, fontSize: 15 }}>{g.name}</div>
                  <div style={{ font: mono(400, 11), color: MUT, marginTop: 4 }}>
                    {g.ranks.length} {g.hasRanks ? 'TIERS' : 'LEVELS'} ·{' '}
                    {g.platforms
                      .map((p) => PLATFORM[p])
                      .join(' · ')
                      .toUpperCase()}
                  </div>
                </div>
              </div>
            );
          })}
          {games && !list.length && (
            <div style={{ color: MUT, fontSize: 14, padding: 12 }}>
              No launch games. Pick one from the whole catalog.
            </div>
          )}
        </div>

        {cur && (
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
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                gap: 12,
              }}
            >
              <span style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 26 }}>{cur.name}</span>
              <button
                type="button"
                disabled={busy}
                onClick={() => toggle(cur)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 8,
                  cursor: 'pointer',
                  font: mono(700, 11),
                  color: TX,
                  background: 'transparent',
                  border: 'none',
                  flex: 'none',
                }}
              >
                <span>{cur.isLaunch ? 'ON FIND PLAYERS' : 'HIDDEN'}</span>
                <span
                  style={{
                    width: 44,
                    height: 24,
                    borderRadius: 99,
                    background: cur.isLaunch ? ACC : '#3A3A3A',
                    position: 'relative',
                    transition: 'background .2s',
                  }}
                >
                  <span
                    style={{
                      position: 'absolute',
                      top: 3,
                      left: 3,
                      width: 18,
                      height: 18,
                      borderRadius: '50%',
                      background: TX,
                      transform: `translateX(${cur.isLaunch ? '20px' : '0px'})`,
                      transition: 'transform .2s',
                    }}
                  />
                </span>
              </button>
            </div>
            <div style={{ fontSize: 13, color: MUT, lineHeight: 1.45 }}>
              Launch games are the ones players can post listings for. Every switch is logged.
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <span style={label}>PLATFORMS · BIGGEST PARTY</span>
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                {cur.platforms.map((p) => (
                  <span
                    key={p}
                    style={{
                      height: 32,
                      padding: '0 13px',
                      borderRadius: 99,
                      border: `1px solid ${LINE}`,
                      background: C2,
                      display: 'flex',
                      alignItems: 'center',
                      fontSize: 13,
                      fontWeight: 600,
                    }}
                  >
                    {PLATFORM[p]}
                  </span>
                ))}
                <span style={{ ...label, alignSelf: 'center', marginLeft: 6 }}>
                  {(PARTY[cur.maxParty] ?? `${cur.maxParty} PLAYERS`).toUpperCase()}
                </span>
              </div>
            </div>

            {cur.modes.length > 0 && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                <span style={label}>MODES</span>
                <span style={{ fontSize: 14 }}>{cur.modes.map((m) => m.name).join(' · ')}</span>
              </div>
            )}

            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span style={label}>
                  {cur.hasRanks ? 'RANK LADDER · LOWEST FIRST' : 'PLAY-STYLE LEVELS'}
                </span>
                <span style={label}>{pad2(cur.ranks.length)}</span>
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
                    key={r.id}
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: 10,
                      padding: '8px 12px',
                      borderTop: i ? `1px solid ${RULE}` : 'none',
                    }}
                  >
                    <span style={{ font: mono(700, 11), color: MUT, width: 22 }}>
                      {pad2(i + 1)}
                    </span>
                    <div
                      style={{
                        flex: 'none',
                        height: 8,
                        width: 10 + Math.round(((i + 1) / cur.ranks.length) * 44),
                        background: ACC,
                        borderRadius: 4,
                        opacity: 0.35 + (0.65 * (i + 1)) / cur.ranks.length,
                      }}
                    />
                    <span style={{ flex: 1, fontWeight: 600, fontSize: 14 }}>{r.name}</span>
                  </div>
                ))}
                {!cur.ranks.length && (
                  <div style={{ padding: 14, fontSize: 13, color: MUT }}>No ranks.</div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </>
  );
}
