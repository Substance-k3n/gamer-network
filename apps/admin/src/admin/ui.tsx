import type { CSSProperties, ReactNode } from 'react';
import { ACC, C1, DK, GLOW, LINE, TX, grot, mono } from './tokens';

type ChipProps = {
  on: boolean;
  onClick: () => void;
  children: ReactNode;
  monoFont?: boolean;
  height?: number;
  size?: number;
  padX?: number;
};

// The filter pill used across every screen: accent when selected, card grey otherwise.
export function Chip({
  on,
  onClick,
  children,
  monoFont,
  height = 36,
  size = 14,
  padX = 14,
}: ChipProps) {
  const style: CSSProperties = {
    whiteSpace: 'nowrap',
    flex: 'none',
    height,
    padding: `0 ${padX}px`,
    borderRadius: 99,
    border: `1px solid ${LINE}`,
    background: on ? ACC : C1,
    color: on ? DK : TX,
    font: monoFont ? mono(700, 12) : grot(600, size),
    cursor: 'pointer',
  };
  return (
    <button type="button" onClick={onClick} style={style}>
      {children}
    </button>
  );
}

export const btnPrimary: CSSProperties = {
  height: 44,
  padding: '0 16px',
  borderRadius: 99,
  border: 'none',
  background: ACC,
  color: DK,
  font: grot(700, 14),
  cursor: 'pointer',
};

export const btnSecondary: CSSProperties = {
  height: 44,
  padding: '0 16px',
  borderRadius: 99,
  border: `1px solid ${LINE}`,
  background: '#232323',
  color: TX,
  font: grot(600, 14),
  cursor: 'pointer',
};

export function Toast({ message }: { message: string | null }) {
  if (!message) return null;
  return (
    <div
      style={{
        position: 'fixed',
        bottom: 24,
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 60,
        background: C1,
        border: `1px solid ${ACC}`,
        color: TX,
        borderRadius: 16,
        padding: '12px 18px',
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        fontSize: 14,
        fontWeight: 500,
        boxShadow: GLOW,
      }}
    >
      <div style={{ width: 9, height: 9, borderRadius: '50%', background: ACC }} />
      {message}
    </div>
  );
}
