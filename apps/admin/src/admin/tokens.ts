import type { CSSProperties } from 'react';

// Colors from the rally prototype ("Rally Admin" design).
export const ACC = '#FF4D2A';
export const DK = '#0E0E0E';
export const TX = '#EDEDED';
export const C1 = '#1B1B1B';
export const C2 = '#232323';
export const SOFT = '#3A1C14';
export const PINK = '#FFB4A3';
export const MUT = '#8C8C8C';
export const LINE = '#2E2E2E';
export const RULE = '#262626';
export const PANEL = '#141414';

export const DOTO = 'var(--font-doto)';
export const GROT = 'var(--font-grotesk)';
export const MONO = 'var(--font-mono)';

export const mono = (weight: number, size: number) => `${weight} ${size}px ${MONO}`;
export const grot = (weight: number, size: number) => `${weight} ${size}px ${GROT}`;

export const SHADOW = '0 14px 30px rgba(0,0,0,.55),inset 0 1px 0 rgba(255,255,255,.05)';
export const GLOW = '0 10px 26px rgba(255,77,42,.22)';
export const RING = `0 0 0 1px ${ACC},${GLOW}`;

export const card: CSSProperties = {
  background: C1,
  border: `1px solid ${LINE}`,
  borderRadius: 24,
  boxShadow: SHADOW,
  padding: 18,
  display: 'flex',
  flexDirection: 'column',
};

export const cardHot: CSSProperties = {
  background: C1,
  borderRadius: 24,
  boxShadow: RING,
  padding: 18,
  display: 'flex',
  flexDirection: 'column',
};

export const heading = (size: number): CSSProperties => ({
  fontFamily: DOTO,
  fontWeight: 900,
  fontSize: size,
});

export const label: CSSProperties = { font: mono(400, 10), color: MUT };

export const pill = (bg: string, fg: string, padding = '3px 8px'): CSSProperties => ({
  font: mono(700, 10),
  background: bg,
  color: fg,
  borderRadius: 99,
  padding,
});

export const SEV = {
  HIGH: { bg: ACC, fg: DK },
  MED: { bg: SOFT, fg: PINK },
  LOW: { bg: C2, fg: TX },
} as const;

export const ST = {
  Active: { bg: C2, fg: TX },
  Warned: { bg: SOFT, fg: PINK },
  Suspended: { bg: ACC, fg: DK },
  Banned: { bg: TX, fg: DK },
} as const;

export const GST = {
  Live: { bg: ACC, fg: DK },
  Pending: { bg: SOFT, fg: PINK },
  Paused: { bg: C2, fg: MUT },
} as const;

export const fmt = (n: number) => Math.round(n).toLocaleString('en-US');
export const pad2 = (n: number) => String(n).padStart(2, '0');
