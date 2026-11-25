'use client';

import { useRouter } from 'next/navigation';
import { api, type Me } from '../../_lib/api';
import { OnboardFrame, StepHeader, titleStyle } from '../../_lib/frame';
import { gameInputs, IdRows, idInputs, PlatformChips, TagChips, useGameOf } from '../../_lib/gamer';
import { useApp } from '../../_lib/store';
import { BigButton, Label } from '../../_lib/ui';
import { useOnboard } from '../../_lib/onboard';

/** Last step: where you play, play style and usernames, then "Go live". */
export default function Platforms() {
  const { run, busy, toast, setMe, games } = useApp();
  const only = games.filter((g) => g.isLaunch).length === 1;
  const [draft, setDraft] = useOnboard();
  const gameOf = useGameOf();
  const router = useRouter();

  const goLive = async () => {
    const m = await run(async () => {
      await api('me/games', { method: 'PUT', body: { games: gameInputs(draft, gameOf) } });
      await api('me/platforms', { method: 'PUT', body: { platforms: draft.platforms } });
      await api('me/tags', { method: 'PUT', body: { tags: draft.tags } });
      await api('me/gaming-ids', { method: 'PUT', body: { gamingIds: idInputs(draft) } });
      await api('me/onboard', { method: 'POST' });
      return api<Me>('me');
    });
    if (!m) return;
    setMe(m);
    toast(`Profile live — welcome, ${m.displayName}`);
    router.replace('/app');
  };

  return (
    <OnboardFrame
      blob={{ left: 40, top: -120, borderRadius: '52% 48% 40% 60% / 50% 45% 55% 50%' }}
      bottom={
        <BigButton accent onClick={goLive} disabled={busy}>
          {busy ? 'Going live…' : 'Go live'}
        </BigButton>
      }
    >
      <StepHeader back="/app/onboarding/ranks" fraction={1} label={only ? 'Step 3' : 'Step 4'} />
      <h1 style={titleStyle}>{'Where you play\n& usernames.'}</h1>
      <Label>PLAYS ON</Label>
      <PlatformChips
        value={draft.platforms}
        onChange={(platforms) => setDraft({ ...draft, platforms })}
      />
      <Label>PLAY STYLE · UP TO 6</Label>
      <TagChips value={draft.tags} onChange={(tags) => setDraft({ ...draft, tags })} />
      <Label>USERNAMES · YOU CHOOSE WHO SEES THEM</Label>
      <IdRows draft={draft} onChange={setDraft} />
    </OnboardFrame>
  );
}
