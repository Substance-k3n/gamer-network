'use client';

import { useState } from 'react';
import { api, query, type Listing, type Page, type Platform } from '../_lib/api';
import { ListingCard } from '../_lib/cards';
import { pad2, partyLabel, platformLabel, platforms } from '../_lib/data';
import { Header } from '../_lib/shell';
import { useApp, useLoad, useNow } from '../_lib/store';
import { Chip, EmptyNote, Label, Pill } from '../_lib/ui';

type Filters = {
  game: string;
  mic: boolean;
  tonight: boolean;
  comp: boolean;
  platform: Platform | null;
  mode: string | null;
  party: number | null;
  myRank: boolean;
};
const none: Filters = {
  game: 'all',
  mic: false,
  tonight: false,
  comp: false,
  platform: null,
  mode: null,
  party: null,
  myRank: false,
};

/** Find Players: open listings with the API's filters (GET /listings). */
export default function Find() {
  const { games, me, run, version } = useApp();
  const [f, setF] = useState<Filters>(none);
  const [more, setMore] = useState<string | null>(null);
  const now = useNow(5000);
  const game = games.find((g) => g.id === f.game);
  const myRank = me?.games.find((g) => g.game?.id === f.game)?.rank?.id;

  const params = (cursor?: string | null) =>
    query({
      game: f.game === 'all' ? null : f.game,
      voice: f.mic ? 'required' : null,
      when: f.tonight ? 'tonight' : null,
      style: f.comp ? 'competitive' : null,
      platform: game ? f.platform : null,
      mode: game ? f.mode : null,
      partySize: game ? f.party : null,
      minRank: game && f.myRank ? myRank : null,
      cursor,
    });
  const { data, setData, loaded, reload } = useLoad(async () => {
    const p = await api<Page<Listing>>(`listings${params()}`);
    setMore(p.nextCursor);
    return p.items;
  }, [JSON.stringify(f), version]);
  const loadMore = async () => {
    const p = await run(() => api<Page<Listing>>(`listings${params(more)}`), { busy: false });
    if (!p) return;
    setData([...(data ?? []), ...p.items]);
    setMore(p.nextCursor);
  };

  const live = (data ?? []).filter((l) => new Date(l.expiresAt).getTime() > now);
  const toggle = (k: 'mic' | 'tonight' | 'comp', label: string) => (
    <button
      key={k}
      type="button"
      className="pill"
      onClick={() => setF({ ...f, [k]: !f[k] })}
      aria-pressed={f[k]}
      style={{
        height: 32,
        padding: '0 12px',
        borderRadius: 10,
        background: f[k] ? 'var(--soft)' : 'transparent',
      }}
    >
      <i className={`check ${f[k] ? 'on' : ''}`} /> {label}
    </button>
  );
  const pickGame = (id: string) =>
    setF({ ...none, mic: f.mic, tonight: f.tonight, comp: f.comp, game: id });

  return (
    <>
      <Header title="Find Players" sub="WHO’S UP" />
      <div className="gap" style={{ gap: 12 }}>
        <div className="scroller rl-pad">
          <Chip on={f.game === 'all'} onClick={() => pickGame('all')} h={38} padH={15} size={14}>
            All games
          </Chip>
          {games
            .filter((g) => g.isLaunch)
            .map((g) => (
              <Chip
                key={g.id}
                on={f.game === g.id}
                onClick={() => pickGame(g.id)}
                h={38}
                padH={15}
                size={14}
              >
                {g.name}
              </Chip>
            ))}
        </div>
        <div className="wrap rl-pad">
          {toggle('mic', 'Mic on')}
          {toggle('tonight', 'Tonight')}
          {toggle('comp', 'Competitive')}
        </div>
        {game && (
          <div className="scroller rl-pad">
            {myRank && (
              <Chip
                on={f.myRank}
                onClick={() => setF({ ...f, myRank: !f.myRank })}
                h={32}
                padH={12}
              >
                My rank and up
              </Chip>
            )}
            {game.platforms.length > 1 &&
              platforms
                .filter((p) => game.platforms.includes(p))
                .map((p) => (
                  <Chip
                    key={p}
                    on={f.platform === p}
                    onClick={() => setF({ ...f, platform: f.platform === p ? null : p })}
                    h={32}
                    padH={12}
                  >
                    {platformLabel[p]}
                  </Chip>
                ))}
            {game.modes.map((m) => (
              <Chip
                key={m.id}
                on={f.mode === m.id}
                onClick={() => setF({ ...f, mode: f.mode === m.id ? null : m.id })}
                h={32}
                padH={12}
              >
                {m.name}
              </Chip>
            ))}
            {Array.from({ length: game.maxParty - 1 }, (_, i) => i + 2).map((n) => (
              <Chip
                key={n}
                on={f.party === n}
                onClick={() => setF({ ...f, party: f.party === n ? null : n })}
                h={32}
                padH={12}
              >
                {partyLabel(n)}
              </Chip>
            ))}
          </div>
        )}
        <div
          className="row"
          style={{ justifyContent: 'space-between', padding: '2px 20px 0', gap: 8 }}
        >
          <Label>{pad2(live.length)} PLAYERS LOOKING</Label>
          <Label>LISTINGS EXPIRE AUTOMATICALLY</Label>
        </div>
        <div className="gap rl-pad" style={{ gap: 14 }}>
          {loaded && live.length === 0 && (
            <EmptyNote>
              No one matches these filters right now. Post a listing and let them find you.
            </EmptyNote>
          )}
          {live.map((l) => (
            <ListingCard key={l.id} l={l} onChanged={reload} />
          ))}
          {more && (
            <div style={{ textAlign: 'center' }}>
              <Pill h={42} padH={18} size={14} bold onClick={loadMore}>
                Load more
              </Pill>
            </div>
          )}
        </div>
      </div>
    </>
  );
}
