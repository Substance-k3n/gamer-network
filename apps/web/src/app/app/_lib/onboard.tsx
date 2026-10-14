'use client';

import { createContext, useContext, useState, type ReactNode } from 'react';
import { draftFrom, type GamerDraft } from './gamer';
import { useApp } from './store';

// Onboarding steps 2–4 share one draft (docs/API.md "Me and onboarding").
const Ctx = createContext<[GamerDraft, (d: GamerDraft) => void] | null>(null);

export function useOnboard() {
  const c = useContext(Ctx);
  if (!c) throw new Error('useOnboard outside OnboardProvider');
  return c;
}

export function OnboardProvider({ children }: { children: ReactNode }) {
  const { me } = useApp();
  const state = useState<GamerDraft>(() =>
    me
      ? draftFrom(me)
      : {
          games: [],
          custom: {},
          ranks: {},
          roles: {},
          platforms: [],
          tags: [],
          ids: {},
          idVis: {},
        },
  );
  return <Ctx.Provider value={state}>{children}</Ctx.Provider>;
}
