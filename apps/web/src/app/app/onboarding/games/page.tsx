'use client';

import { useRouter } from 'next/navigation';
import { api, type Me } from '../../_lib/api';
import { StepHeader, titleStyle } from '../../_lib/frame';
import { GamePicker, gameInputs, useGameOf } from '../../_lib/gamer';
import { useApp } from '../../_lib/store';
import { BigButton } from '../../_lib/ui';
import { useOnboard } from '../../_lib/onboard';

/** Step 2: "What do you play?" Saves the games (no ranks yet). */
export default function Games() {
  const { run, busy, toast, setMe } = useApp();
  const [draft, setDraft] = useOnboard();
  const gameOf = useGameOf();
  const router = useRouter();
  const n = draft.games.length;

  const next = async () => {
    if (!n) return toast('Pick at least one game');
    const m = await run(() =>
      api<Me>('me/games', { method: 'PUT', body: { games: gameInputs(draft, gameOf) } }),
    );
    if (!m) return;
    setMe(m);
    router.push('/app/onboarding/ranks');
  };
  const logout = async () => {
    await run(() => api<void>('auth/logout', { method: 'POST' }), { quiet: true });
    setMe(null);
    router.replace('/app/welcome');
  };

  return (
    <div
      style={{
        position: 'relative',
        height: '100dvh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <div
        className="blob"
        style={{
          width: 460,
          height: 340,
          left: 60,
          top: -90,
          borderRadius: '60% 40% 45% 55% / 50% 60% 40% 50%',
        }}
      />
      <div className="over" style={{ padding: '8px 20px 0' }}>
        <StepHeader fraction={0.5} label="Step 2" backLabel="Log out" onBackLabel={logout} />
      </div>
      <div className="over gap" style={{ padding: '20px 20px 14px', gap: 8 }}>
        <h1 style={titleStyle}>What do you play?</h1>
        <div className="muted" style={{ fontSize: 14 }}>
          Pick every game you play. You’ll add ranks next.
        </div>
      </div>
      <div className="over grow" style={{ padding: '0 20px', minHeight: 0 }}>
        <GamePicker draft={draft} onChange={setDraft} height="100%" />
      </div>
      <div className="over" style={{ padding: '14px 20px 28px' }}>
        <BigButton onClick={next} disabled={busy}>
          {n === 0 ? 'Pick at least one game' : `Continue with ${n} game${n === 1 ? '' : 's'}`}
        </BigButton>
      </div>
    </div>
  );
}
