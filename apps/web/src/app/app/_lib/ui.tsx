'use client';

import { useRouter } from 'next/navigation';
import {
  useCallback,
  useRef,
  useState,
  type CSSProperties,
  type InputHTMLAttributes,
  type ReactNode,
} from 'react';
import type { Tone } from './data';
import { useApp } from './store';

// The UI kit of apps/mobile/lib/widgets.dart, in the active skin.

const icons = {
  back: ['<path d="M15 5l-7 7 7 7"/>', 2.4],
  bell: ['<path d="M6 16v-5a6 6 0 0112 0v5l2 2H4z"/><path d="M10 21h4"/>', 2.1],
  search: ['<circle cx="11" cy="11" r="6.5"/><path d="M16 16l5 5"/>', 2.4],
  image: [
    '<rect x="3" y="5" width="18" height="14" rx="3"/><circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5-5-8 8"/>',
    2.2,
  ],
  home: ['<path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z"/>', 2.2],
  target: ['<circle cx="12" cy="12" r="6.5"/><path d="M12 2v4M12 18v4M2 12h4M18 12h4"/>', 2.2],
  groups: [
    '<circle cx="8.5" cy="9" r="3"/><circle cx="16" cy="9.5" r="2.5"/><path d="M3 19c0-3 2.5-5 5.5-5s5.5 2 5.5 5M15 14.2c3 0 6 1.5 6 4.8"/>',
    2.2,
  ],
  user: ['<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6.5 8-6.5s8 2.5 8 6.5"/>', 2.2],
  share: [
    '<circle cx="18" cy="5.5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="18.5" r="2.5"/><path d="M8.2 10.8l7.6-4.1M8.2 13.2l7.6 4.1"/>',
    2,
  ],
  plus: ['<path d="M12 5v14M5 12h14"/>', 2.6],
  eye: [
    '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
    2,
  ],
  eyeOff: [
    '<path d="M3 3l18 18"/><path d="M10.6 5.1A10.8 10.8 0 0112 5c6.5 0 10 7 10 7a17.6 17.6 0 01-3.2 4.2M6.6 6.6A17.4 17.4 0 002 12s3.5 7 10 7a10.6 10.6 0 005.4-1.4"/><path d="M9.9 9.9a3 3 0 004.2 4.2"/>',
    2,
  ],
  close: ['<path d="M6 6l12 12M18 6L6 18"/>', 2.4],
  check: ['<path d="M5 12.5l4.5 4.5L19 7.5"/>', 2.8],
  comment: ['<path d="M4 5h16v11H9l-5 4z"/>', 2.1],
  bookmark: ['<path d="M6 3h12v18l-6-4.5L6 21z"/>', 2.1],
  play: ['<path d="M7 4.5v15l12-7.5z"/>', 2.2],
  more: [
    '<circle cx="5" cy="12" r="1.2"/><circle cx="12" cy="12" r="1.2"/><circle cx="19" cy="12" r="1.2"/>',
    2.6,
  ],
} as const;
export type IconName = keyof typeof icons;

export function Icon({
  name,
  size = 20,
  color,
}: {
  name: IconName;
  size?: number;
  color?: string;
}) {
  const [body, stroke] = icons[name];
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke={color ?? 'currentColor'}
      strokeWidth={stroke}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden
      dangerouslySetInnerHTML={{ __html: body }}
    />
  );
}

export function toneColor(t: Tone, avatar = false) {
  return {
    accent: avatar ? 'var(--avatar-accent)' : 'var(--tag-accent)',
    soft: 'var(--soft)',
    lav: 'var(--lav)',
    grey: 'var(--grey)',
    free: 'var(--on-dark)',
    faint: 'var(--faint)',
  }[t];
}

export function Logo({ size = 32 }: { size?: number }) {
  return (
    <span className="logo" style={{ width: size, height: size }} role="img" aria-label="rally">
      <i className="fill" />
      <i className="line" />
    </span>
  );
}

export function Wordmark({ size = 22, logo = true }: { size?: number; logo?: boolean }) {
  return (
    <span className="row" style={{ gap: size * 0.25 }}>
      {logo && <Logo size={size * 1.35} />}
      <span style={{ fontSize: size, fontWeight: 800, letterSpacing: size > 24 ? -1 : -0.8 }}>
        rally<span style={{ color: 'var(--acc)' }}>.</span>
      </span>
    </span>
  );
}

type PillProps = {
  children: ReactNode;
  onClick?: () => void;
  h?: number;
  padH?: number;
  size?: number;
  bold?: boolean;
  look?: 'accent' | 'strong' | 'ink' | 'quiet' | 'clear';
  expand?: boolean;
  shadow?: 2 | 3 | 4;
  disabled?: boolean;
  type?: 'button' | 'submit';
  style?: CSSProperties;
  label?: string;
};

export function Pill({
  children,
  onClick,
  h = 34,
  padH = 13,
  size = 13,
  bold,
  look,
  expand,
  shadow,
  disabled,
  type = 'button',
  style,
  label,
}: PillProps) {
  return (
    <button
      type={type}
      className={`pill ${look ?? ''} ${expand ? 'expand' : ''}`}
      onClick={onClick}
      disabled={disabled}
      aria-label={label}
      style={{
        height: h,
        padding: `0 ${padH}px`,
        fontSize: size,
        fontWeight: bold ? 700 : undefined,
        boxShadow: shadow ? `var(--sh${shadow})` : undefined,
        ...style,
      }}
    >
      {children}
    </button>
  );
}

export function Chip({
  children,
  on,
  onClick,
  h = 34,
  padH = 13,
  size = 13,
}: {
  children: ReactNode;
  on: boolean;
  onClick: () => void;
  h?: number;
  padH?: number;
  size?: number;
}) {
  return (
    <button
      type="button"
      className={`pill chip ${on ? 'on' : ''}`}
      aria-pressed={on}
      onClick={onClick}
      style={{ height: h, padding: `0 ${padH}px`, fontSize: size, flex: 'none' }}
    >
      {children}
    </button>
  );
}

export function BigButton({
  children,
  onClick,
  accent,
  disabled,
  type = 'button',
}: {
  children: ReactNode;
  onClick?: () => void;
  accent?: boolean;
  disabled?: boolean;
  type?: 'button' | 'submit';
}) {
  return (
    <button
      type={type}
      className={`pill big expand ${accent ? 'accent' : ''}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
}

export function Card({
  children,
  dark,
  flat,
  pad = 14,
  radius = 24,
  onClick,
  style,
  className,
}: {
  children: ReactNode;
  dark?: boolean;
  flat?: boolean;
  pad?: number | string;
  radius?: number;
  onClick?: () => void;
  style?: CSSProperties;
  className?: string;
}) {
  return (
    <div
      className={`card ${dark ? 'dark' : ''} ${flat ? 'flat' : ''} ${onClick ? 'tap' : ''} ${className ?? ''}`}
      onClick={onClick}
      role={onClick ? 'button' : undefined}
      style={{ padding: pad, borderRadius: radius, ...style }}
    >
      {children}
    </div>
  );
}

export function Label({
  children,
  size = 9,
  color,
  style,
}: {
  children: ReactNode;
  size?: number;
  color?: string;
  style?: CSSProperties;
}) {
  return (
    <span
      className="label"
      style={{ fontSize: `calc(${size}px + var(--label-delta))`, color, ...style }}
    >
      {children}
    </span>
  );
}

export function Digits({
  children,
  size = 13,
  color,
}: {
  children: ReactNode;
  size?: number;
  color?: string;
}) {
  return (
    <span className={`digits ${size >= 16 ? 'big' : ''}`} style={{ fontSize: size, color }}>
      {children}
    </span>
  );
}

export function Avatar({
  name,
  tone,
  url,
  size = 40,
  onClick,
  onDark,
}: {
  name: string;
  tone: Tone;
  url?: string | null;
  size?: number;
  onClick?: () => void;
  onDark?: boolean;
}) {
  const [failed, setFailed] = useState(false);
  const inner =
    url && !failed ? (
      // eslint-disable-next-line @next/next/no-img-element
      <img src={url} alt="" onError={() => setFailed(true)} />
    ) : (
      (name.trim()[0] ?? '?').toUpperCase()
    );
  const style: CSSProperties = {
    width: size,
    height: size,
    fontSize: size * 0.4,
    background: toneColor(tone, true),
    borderColor: onDark ? 'var(--on-dark-line)' : undefined,
  };
  return onClick ? (
    <button
      type="button"
      className="avatar"
      style={{ ...style, padding: 0, cursor: 'pointer' }}
      onClick={onClick}
      aria-label={name}
    >
      {inner}
    </button>
  ) : (
    <span className="avatar" style={style}>
      {inner}
    </span>
  );
}

export const Dot = ({ color, size = 9 }: { color: string; size?: number }) => (
  <i className="dot" style={{ width: size, height: size, background: color }} />
);

export const Progress = ({ value }: { value: number }) => (
  <div className="progress" role="progressbar" aria-valuenow={Math.round(value * 100)}>
    <i style={{ width: `${value * 100}%` }} />
  </div>
);

type FieldProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'onChange' | 'value' | 'size'> & {
  value: string;
  onChange: (v: string) => void;
  h?: number;
  radius?: number;
  sunken?: boolean;
  leading?: ReactNode;
  trailing?: ReactNode;
};

export function Field({
  value,
  onChange,
  h = 54,
  radius = 99,
  sunken,
  leading,
  trailing,
  ...rest
}: FieldProps) {
  return (
    <label
      className={`field ${sunken ? 'sunken' : ''}`}
      style={{ height: h, borderRadius: radius }}
    >
      {leading}
      <input value={value} onChange={(e) => onChange(e.target.value)} {...rest} />
      {trailing}
    </label>
  );
}

export function PasswordField({
  value,
  onChange,
  placeholder = 'Password',
  h = 54,
  autoComplete = 'current-password',
}: {
  value: string;
  onChange: (v: string) => void;
  placeholder?: string;
  h?: number;
  autoComplete?: string;
}) {
  const [show, setShow] = useState(false);
  return (
    <Field
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      type={show ? 'text' : 'password'}
      autoComplete={autoComplete}
      h={h}
      trailing={
        <button
          type="button"
          className="u"
          onClick={() => setShow(!show)}
          aria-label={show ? 'Hide password' : 'Show password'}
          style={{ textDecoration: 'none', display: 'flex' }}
        >
          <Icon name={show ? 'eyeOff' : 'eye'} size={20} color="var(--muted)" />
        </button>
      }
    />
  );
}

export function TextArea({
  value,
  onChange,
  placeholder,
  rows = 3,
}: {
  value: string;
  onChange: (v: string) => void;
  placeholder?: string;
  rows?: number;
}) {
  return (
    <label className="field" style={{ borderRadius: 22, padding: '14px 18px' }}>
      <textarea
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        rows={rows}
        style={{ lineHeight: 1.4 }}
      />
    </label>
  );
}

export function Segmented<T extends string>({
  options,
  value,
  onChange,
}: {
  options: { id: T; label: string }[];
  value: T;
  onChange: (v: T) => void;
}) {
  return (
    <div className="segmented" role="radiogroup">
      {options.map((o) => (
        <button
          key={o.id}
          type="button"
          role="radio"
          aria-checked={value === o.id}
          className={value === o.id ? 'on' : ''}
          onClick={() => onChange(o.id)}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

export function EmptyNote({ children, pad = 22 }: { children: ReactNode; pad?: number }) {
  return (
    <div className="dashed muted" style={{ padding: pad, textAlign: 'center', fontSize: 14 }}>
      {children}
    </div>
  );
}

export function CircleBtn({
  children,
  onClick,
  size = 44,
  onDark,
  shadow,
  label,
}: {
  children: ReactNode;
  onClick?: () => void;
  size?: number;
  onDark?: boolean;
  shadow?: number;
  label?: string;
}) {
  return (
    <button
      type="button"
      className={`circle ${onDark ? 'on-dark' : ''}`}
      style={{ width: size, height: size, boxShadow: shadow ? `var(--sh${shadow})` : undefined }}
      onClick={onClick}
      aria-label={label}
    >
      {children}
    </button>
  );
}

export function BackBtn({
  onClick,
  size = 44,
  onDark,
  href,
}: {
  onClick?: () => void;
  size?: number;
  onDark?: boolean;
  href?: string;
}) {
  const router = useRouter();
  const { back } = useApp();
  return (
    <CircleBtn
      size={size}
      onDark={onDark}
      label="Back"
      onClick={onClick ?? (() => (href ? router.push(href) : back()))}
    >
      <Icon name="back" size={size * 0.45} />
    </CircleBtn>
  );
}

export function Toast() {
  const { toastMsg } = useApp();
  if (!toastMsg) return null;
  return (
    <div className="toast" role="status" key={toastMsg}>
      <Dot color="var(--accent)" />
      <span>{toastMsg}</span>
    </div>
  );
}

export function Sheet({ children, onClose }: { children: ReactNode; onClose: () => void }) {
  return (
    <>
      <div className="scrim" onClick={onClose} />
      <div className="sheet" role="dialog" aria-modal>
        <div className="handle" />
        {children}
      </div>
    </>
  );
}

export function Dialog({ children, onClose }: { children: ReactNode; onClose: () => void }) {
  return (
    <>
      <div className="scrim" style={{ zIndex: 50 }} onClick={onClose} />
      <div className="dialog gap" style={{ gap: 12 }} role="dialog" aria-modal>
        {children}
      </div>
    </>
  );
}

/**
 * A yes/no question. `ask(...)` resolves true on yes; render `dialog`
 * somewhere in the component.
 */
export function useConfirm() {
  const [q, setQ] = useState<{ title: string; body: string; yes: string; no: string } | null>(null);
  const resolver = useRef<(v: boolean) => void>(undefined);
  const ask = useCallback(
    (title: string, body: string, yes: string, no = 'Cancel') =>
      new Promise<boolean>((resolve) => {
        resolver.current = resolve;
        setQ({ title, body, yes, no });
      }),
    [],
  );
  const answer = (v: boolean) => {
    setQ(null);
    resolver.current?.(v);
  };
  const dialog = q ? (
    <Dialog onClose={() => answer(false)}>
      <div style={{ fontSize: 22, fontWeight: 800, letterSpacing: -0.6 }}>{q.title}</div>
      <div className="muted" style={{ fontSize: 14, lineHeight: 1.35 }}>
        {q.body}
      </div>
      <div className="row" style={{ gap: 8 }}>
        <Pill h={46} size={15} expand look="clear" onClick={() => answer(false)}>
          {q.no}
        </Pill>
        <Pill h={46} size={15} expand bold look="strong" onClick={() => answer(true)}>
          {q.yes}
        </Pill>
      </div>
    </Dialog>
  ) : null;
  return [ask, dialog] as const;
}

/** Rows inside one card, separated by the skin's row rule. */
export const Rows = ({ children }: { children: ReactNode }) => (
  <div className="rows">{children}</div>
);

export function Spinner() {
  return <div className="spinner" role="progressbar" aria-label="Loading" />;
}
