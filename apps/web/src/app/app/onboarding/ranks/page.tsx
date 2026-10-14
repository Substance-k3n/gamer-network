'use client';

import Link from 'next/link';
import { StepHeader, titleStyle } from '../../_lib/frame';
import { RankCard, useGameOf } from '../../_lib/gamer';
import { useOnboard } from '../../_lib/onboard';

/** Step 3: "Your ranks." Kept in the draft; saved with step 4. */
export default function Ranks() {
  const [draft, setDraft] = useOnboard();
  const gameOf = useGameOf();
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
        <StepHeader back="/app/onboarding/games" fraction={0.75} label="Step 3" />
      </div>
      <div className="over gap" style={{ padding: '20px 20px 14px', gap: 8 }}>
        <h1 style={titleStyle}>Your ranks.</h1>
        <div className="muted" style={{ fontSize: 14 }}>
          Tap your current tier in each game. Skip any you don’t play ranked.
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
