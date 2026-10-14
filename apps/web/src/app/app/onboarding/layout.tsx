import type { ReactNode } from 'react';
import { OnboardProvider } from '../_lib/onboard';

export default function OnboardingLayout({ children }: { children: ReactNode }) {
  return <OnboardProvider>{children}</OnboardProvider>;
}
