'use client';

import { useRouter } from 'next/navigation';
import { useMemo, useState, type ReactNode } from 'react';
import {
  api,
  uuid,
  type InviteWhen,
  type Listing,
  type Platform,
  type PlayInvite,
  type PlayWhen,
} from './api';
import { inviteWhenLabel, partyLabel, platformLabel, platforms, playWhenLabel } from './data';
import { useApp } from './store';
import { BigButton, Chip, Field, Label, Sheet } from './ui';

function Group<T extends string | number>({
  label,
  options,
  value,
  onPick,
  labelOf,
}: {
  label: string;
  options: T[];
  value: T;
  onPick: (v: T) => void;
  labelOf: (v: T) => string;
}) {
  return (
    <div className="gap" style={{ gap: 6 }}>
      <Label style={{ paddingTop: 2 }}>{label}</Label>
      <div className="wrap">
        {options.map((o) => (
          <Chip
            key={String(o)}
            on={value === o}
            onClick={() => onPick(o)}
            h={36}
            padH={14}
            size={14}
          >
            {labelOf(o)}
          </Chip>
        ))}
      </div>
    </div>
  );
}

function SheetTitle({ children, onClose }: { children: ReactNode; onClose: () => void }) {
  return (
    <div className="row" style={{ justifyContent: 'space-between', marginBottom: 10 }}>
      <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>{children}</div>
      <button
        type="button"
        className="circle"
        style={{ width: 36, height: 36, background: 'transparent', fontSize: 16 }}
        onClick={onClose}
        aria-label="Close"
      >
        ×
      </button>
    </div>
  );
}

/** "Looking for players": POST /listings with the game's own options. */
export function ListingSheet({ onClose }: { onClose: () => void }) {
  const { games, me, run, busy, toast, bump } = useApp();
  const router = useRouter();
  const launch = games.filter((g) => g.isLaunch);
  const mine = new Set(me?.games.map((g) => g.game?.id));
  const first = launch.find((g) => mine.has(g.id)) ?? launch[0];
  const [gameId, setGameId] = useState(first?.id ?? '');
  const game = launch.find((g) => g.id === gameId);
  const pickPlatform = (ps: Platform[]) =>
    ps.includes('mobile') && me?.platforms.includes('mobile')
      ? 'mobile'
      : (me?.platforms.find((p) => ps.includes(p)) ?? ps[0] ?? 'mobile');
  const [modeId, setModeId] = useState<string | null>(first?.modes[0]?.id ?? null);
  const [party, setParty] = useState(2);
  const [platform, setPlatform] = useState<Platform>(pickPlatform(first?.platforms ?? []));
  const [style, setStyle] = useState<'competitive' | 'casual'>('competitive');
  const [voice, setVoice] = useState<'required' | 'optional'>('required');
  const [when, setWhen] = useState<PlayWhen>('tonight');
  const [dur, setDur] = useState<2 | 6 | 24>(6);
  const [note, setNote] = useState('');
  const key = useMemo(() => uuid(), []);

  if (!game) {
    return (
      <Sheet onClose={onClose}>
        <SheetTitle onClose={onClose}>Looking for players</SheetTitle>
        <p className="muted">Find Players opens soon. No games are live yet.</p>
      </Sheet>
    );
  }

  const setGame = (id: string) => {
    const g = launch.find((x) => x.id === id)!;
    setGameId(id);
    setModeId(g.modes[0]?.id ?? null);
    if (party > g.maxParty) setParty(2);
    if (!g.platforms.includes(platform)) setPlatform(pickPlatform(g.platforms));
  };

  const submit = async () => {
    const l = await run(() =>
      api<Listing>('listings', {
        method: 'POST',
        key,
        body: {
          gameId,
          modeId: modeId ?? undefined,
          platform,
          partySize: party,
          voice,
          style,
          playWhen: when,
          durationHours: dur,
          note: note.trim() || undefined,
        },
      }),
    );
    if (!l) return;
    onClose();
    toast('Listing live — status set to Looking for players');
    bump();
    router.push('/app');
  };

  return (
    <Sheet onClose={onClose}>
      <SheetTitle onClose={onClose}>Looking for players</SheetTitle>
      <div className="gap" style={{ gap: 10 }}>
        <Group
          label="GAME"
          options={launch.map((g) => g.id)}
          value={gameId}
          onPick={setGame}
          labelOf={(id) => launch.find((g) => g.id === id)!.name}
        />
        {game.modes.length > 0 && (
          <Group
            label="MODE"
            options={game.modes.map((m) => m.id)}
            value={modeId ?? ''}
            onPick={setModeId}
            labelOf={(id) => game.modes.find((m) => m.id === id)!.name}
          />
        )}
        <Group
          label="LOOKING FOR"
          options={Array.from({ length: game.maxParty - 1 }, (_, i) => i + 2)}
          value={party}
          onPick={setParty}
          labelOf={partyLabel}
        />
        {game.platforms.length > 1 && (
          <Group
            label="PLATFORM"
            options={platforms.filter((p) => game.platforms.includes(p))}
            value={platform}
            onPick={setPlatform}
            labelOf={(p) => platformLabel[p]}
          />
        )}
        <Group<'competitive' | 'casual'>
          label="STYLE"
          options={['competitive', 'casual']}
          value={style}
          onPick={setStyle}
          labelOf={(s) => (s === 'competitive' ? 'Competitive' : 'Casual')}
        />
        <Group<'required' | 'optional'>
          label="VOICE"
          options={['required', 'optional']}
          value={voice}
          onPick={setVoice}
          labelOf={(v) => (v === 'required' ? 'Mic required' : 'Mic optional')}
        />
        <Group
          label="WHEN"
          options={Object.keys(playWhenLabel) as PlayWhen[]}
          value={when}
          onPick={setWhen}
          labelOf={(w) => playWhenLabel[w]}
        />
        <Group<2 | 6 | 24>
          label="EXPIRES AFTER"
          options={[2, 6, 24]}
          value={dur}
          onPick={setDur}
          labelOf={(h) => `${h}h`}
        />
        <div className="gap" style={{ gap: 6 }}>
          <Label style={{ paddingTop: 2 }}>NOTE</Label>
          <Field
            value={note}
            onChange={setNote}
            placeholder="Looking for a ranked duo tonight."
            h={48}
            radius={16}
            sunken
            maxLength={140}
          />
        </div>
        <BigButton onClick={submit} disabled={busy}>
          {busy ? 'Sending…' : `Post listing · expires in ${dur}h`}
        </BigButton>
      </div>
    </Sheet>
  );
}

/** "Play with Dave": POST /play-invites to a connection. */
export function InviteSheet({
  sheet,
  onClose,
}: {
  sheet: { userId: string; name: string; games: string[] };
  onClose: () => void;
}) {
  const { game, games, run, busy, toast } = useApp();
  const options = sheet.games.length
    ? sheet.games
    : games.filter((g) => g.isLaunch).map((g) => g.id);
  const [gameId, setGameId] = useState(options[0] ?? '');
  const [when, setWhen] = useState<InviteWhen>('tonight');
  const key = useMemo(() => uuid(), []);
  const submit = async () => {
    const i = await run(() =>
      api<PlayInvite>('play-invites', {
        method: 'POST',
        key,
        body: { toUserId: sheet.userId, gameId, playWhen: when },
      }),
    );
    if (!i) return;
    onClose();
    toast(`Invite sent — ${sheet.name} gets a notification`);
  };
  return (
    <Sheet onClose={onClose}>
      <SheetTitle onClose={onClose}>Play with {sheet.name}</SheetTitle>
      <div className="gap" style={{ gap: 10 }}>
        <Group
          label="GAME"
          options={options}
          value={gameId}
          onPick={setGameId}
          labelOf={(id) => game(id).name}
        />
        <Group
          label="WHEN"
          options={Object.keys(inviteWhenLabel) as InviteWhen[]}
          value={when}
          onPick={setWhen}
          labelOf={(w) => inviteWhenLabel[w]}
        />
        <BigButton onClick={submit} disabled={busy || !gameId}>
          {busy ? 'Sending…' : 'Send session invite'}
        </BigButton>
      </div>
    </Sheet>
  );
}
