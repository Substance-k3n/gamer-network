'use client';

import type { CSSProperties, ReactNode } from 'react';
import { BackBtn, Progress } from './ui';

/** Onboarding page: a soft blob behind, content, a CTA pinned to the bottom. */
export function OnboardFrame({
  blob,
  children,
  bottom,
  gap = 12,
  onSubmit,
}: {
  blob: CSSProperties;
  children: ReactNode;
  bottom: ReactNode;
  gap?: number;
  onSubmit?: () => void;
}) {
  const body = (
    <>
      <div className="blob" style={{ width: 460, height: 340, ...blob }} />
      <div className="over gap grow" style={{ padding: '8px 20px 12px', gap }}>
        {children}
      </div>
      <div className="over gap" style={{ padding: '4px 20px 28px', gap: 14 }}>
        {bottom}
      </div>
    </>
  );
  const style: CSSProperties = {
    position: 'relative',
    minHeight: '100dvh',
    overflow: 'hidden',
    display: 'flex',
    flexDirection: 'column',
  };
  return onSubmit ? (
    <form
      style={style}
      onSubmit={(e) => {
        e.preventDefault();
        onSubmit();
      }}
    >
      {body}
    </form>
  ) : (
    <div style={style}>{body}</div>
  );
}

export function StepHeader({
  back,
  fraction,
  label,
  backLabel,
  onBackLabel,
}: {
  back?: string;
  fraction: number;
  label: string;
  backLabel?: string;
  onBackLabel?: () => void;
}) {
  return (
    <div className="row" style={{ justifyContent: 'space-between' }}>
      {backLabel ? (
        <button
          type="button"
          className="u"
          style={{ width: 52, textAlign: 'left', fontSize: 13, fontWeight: 600 }}
          onClick={onBackLabel}
        >
          {backLabel}
        </button>
      ) : (
        <BackBtn href={back} />
      )}
      <Progress value={fraction} />
      <span style={{ width: 52, textAlign: 'right', fontSize: 14, fontWeight: 700 }}>{label}</span>
    </div>
  );
}

export const titleStyle: CSSProperties = {
  fontSize: 36,
  fontWeight: 800,
  letterSpacing: -1.4,
  lineHeight: 1.02,
  margin: 0,
  whiteSpace: 'pre-line',
};

export function Labeled({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="gap" style={{ gap: 4 }}>
      <span
        className="label"
        style={{ fontSize: 'calc(9px + var(--label-delta))', paddingLeft: 18 }}
      >
        {label}
      </span>
      {children}
    </div>
  );
}
