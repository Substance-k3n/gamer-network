'use client';

import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { api } from '../../_lib/api';
import { StepHeader, titleStyle } from '../../_lib/frame';
import { RankCard, useGameOf } from '../../_lib/gamer';
import { useOnboard } from '../../_lib/onboard';
import { useApp } from '../../_lib/store';

/** Step 3 (2 with Chess alone): "Your rating." Kept in the draft; saved with the last step. */
export default function Ranks() {
  const { games, run, setMe } = useApp();
  const [draft, setDraft] = useOnboard();
  const gameOf = useGameOf();
  const router = useRouter();
  // With Chess alone the games step skips itself, so back means log out.
  const only = games.filter((g) => g.isLaunch).length === 1;
  const logout = async () => {
    await run(() => api<void>('auth/logout', { method: 'POST' }), { quiet: true });
    setMe(null);
    router.replace('/app/welcome');
  };
  return (
    <div
      style={{
        position: 'relative',
        minHeight: '100dvh',
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
          left: -80,
          top: -110,
          borderRadius: '40% 60% 55% 45% / 45% 55% 45% 55%',
        }}
      />
      <div className="over" style={{ padding: '8px 20px 0' }}>
        {only ? (
          <StepHeader fraction={0.66} label="Step 2" backLabel="Log out" onBackLabel={logout} />
        ) : (
          <StepHeader back="/app/onboarding/games" fraction={0.75} label="Step 3" />
        )}
      </div>
      <div className="over gap" style={{ padding: '20px 20px 14px', gap: 8 }}>
        <h1 style={titleStyle}>Your rating.</h1>
        <div className="muted" style={{ fontSize: 14 }}>
          Tap the band your Chess.com or Lichess rating sits in. Skip it if you’re new.
        </div>
      </div>
      <div className="over gap grow" style={{ padding: '2px 20px 8px', gap: 12 }}>
        {draft.games.map((k) => (
          <RankCard
            key={k}
            game={gameOf(draft, k)}
            rank={draft.ranks[k]}
            role={draft.roles[k]}
            onRank={(r) => setDraft({ ...draft, ranks: { ...draft.ranks, [k]: r } })}
            onRole={(r) => setDraft({ ...draft, roles: { ...draft.roles, [k]: r } })}
          />
        ))}
      </div>
      <div className="over" style={{ padding: '14px 20px 28px', position: 'sticky', bottom: 0 }}>
        <Link href="/app/onboarding/platforms" className="pill big expand">
          Continue
        </Link>
      </div>
    </div>
  );
}
