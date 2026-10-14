'use client';

import { useRouter } from 'next/navigation';
import { api, type Me } from '../../_lib/api';
import { OnboardFrame, StepHeader, titleStyle } from '../../_lib/frame';
import { gameInputs, IdRows, idInputs, PlatformChips, TagChips, useGameOf } from '../../_lib/gamer';
import { useApp } from '../../_lib/store';
import { BigButton, Label } from '../../_lib/ui';
import { useOnboard } from '../../_lib/onboard';

/** Step 4: platforms, play style and gaming IDs, then "Go live". */
export default function Platforms() {
  const { run, busy, toast, setMe } = useApp();
  const [draft, setDraft] = useOnboard();
  const gameOf = useGameOf();
  const router = useRouter();

  const goLive = async () => {
    const m = await run(async () => {
      await api('me/games', { method: 'PUT', body: { games: gameInputs(draft, gameOf) } });
      await api('me/platforms', { method: 'PUT', body: { platforms: draft.platforms } });
      await api('me/tags', { method: 'PUT', body: { tags: draft.tags } });
      await api('me/gaming-ids', { method: 'PUT', body: { gamingIds: idInputs(draft, gameOf) } });
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
      <StepHeader back="/app/onboarding/ranks" fraction={1} label="Step 4" />
      <h1 style={titleStyle}>{'Platforms\n& gaming IDs.'}</h1>
      <Label>PLATFORMS</Label>
      <PlatformChips
        value={draft.platforms}
        onChange={(platforms) => setDraft({ ...draft, platforms })}
      />
      <Label>PLAY STYLE · UP TO 6</Label>
      <TagChips value={draft.tags} onChange={(tags) => setDraft({ ...draft, tags })} />
      <Label>GAMING IDS · YOU CHOOSE WHO SEES THEM</Label>
      <IdRows draft={draft} onChange={setDraft} />
    </OnboardFrame>
  );
}
