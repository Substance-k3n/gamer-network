import type { CSSProperties } from 'react';

// Soft clay skin (SPEC): every colour is a CSS variable defined in app/globals.css,
// so the light and dark themes switch without a re-render.
export const ACC = 'var(--accent)'; // fills: primary buttons, selected chips
export const ACCTX = 'var(--acc)'; // accent as text or link
export const DK = 'var(--on-accent)';
export const TX = 'var(--tx)';
export const C1 = 'var(--surface)';
export const C2 = 'var(--grey)';
export const SUNK = 'var(--sunken)';
export const SOFT = 'var(--soft)';
export const LAV = 'var(--lav)';
export const MUT = 'var(--mut)';
export const FAINT = 'var(--faint)';
export const STRONG = 'var(--strong)';
export const LINE = 'var(--line)';
export const RULE = 'var(--row-line)';
export const DIVIDER = 'var(--divider)';
export const DASH = 'var(--dash)';
export const PANEL = 'var(--surface)';
export const DANGER = 'var(--danger)';
export const ONDANGER = 'var(--on-danger)';

export const FONT = 'var(--font-manrope), system-ui, sans-serif';
export const DOTO = FONT;
export const GROT = FONT;
export const MONO = FONT;

export const mono = (weight: number, size: number) => `${weight} ${size}px ${MONO}`;
export const grot = (weight: number, size: number) => `${weight} ${size}px ${GROT}`;

export const SHADOW = 'var(--shadow)';
export const GLOW = 'var(--glow)';
export const RING = `0 0 0 1.5px ${ACC},${GLOW}`;

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
  fontWeight: 800,
  fontSize: size,
  letterSpacing: -0.4,
});

export const label: CSSProperties = { font: mono(700, 12), color: MUT };

export const pill = (bg: string, fg: string, padding = '3px 9px'): CSSProperties => ({
  font: mono(700, 11),
  background: bg,
  color: fg,
  borderRadius: 99,
  padding,
});

export const SEV = {
  HIGH: { bg: DANGER, fg: ONDANGER },
  MED: { bg: LAV, fg: TX },
  LOW: { bg: C2, fg: TX },
} as const;

export const ST = {
  active: { bg: SOFT, fg: ACCTX },
  banned: { bg: DANGER, fg: ONDANGER },
  deleted: { bg: C2, fg: MUT },
} as const;

export const fmt = (n: number) => Math.round(n).toLocaleString('en-US');
export const pad2 = (n: number) => String(n).padStart(2, '0');
