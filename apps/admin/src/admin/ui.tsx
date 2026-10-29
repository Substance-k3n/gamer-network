import { useEffect, useRef, type CSSProperties, type ReactNode } from 'react';
import { Icon } from './icons';
import {
  ACC,
  C1,
  C2,
  DANGER,
  DK,
  FAINT,
  GLOW,
  LINE,
  MUT,
  ONDANGER,
  RULE,
  SHADOW,
  SUNK,
  TX,
  grot,
  heading,
  label,
  mono,
} from './tokens';

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
    border: `1px solid ${on ? 'transparent' : LINE}`,
    background: on ? ACC : C1,
    color: on ? DK : TX,
    font: monoFont ? mono(700, 12) : grot(600, size),
    cursor: 'pointer',
    boxShadow: on ? GLOW : 'none',
  };
  return (
    <button type="button" onClick={onClick} aria-pressed={on} style={style}>
      {children}
    </button>
  );
}

export const btnPrimary: CSSProperties = {
  height: 44,
  padding: '0 18px',
  borderRadius: 99,
  border: 'none',
  background: ACC,
  color: DK,
  font: grot(700, 14),
  cursor: 'pointer',
  boxShadow: GLOW,
};

export const btnSecondary: CSSProperties = {
  height: 44,
  padding: '0 18px',
  borderRadius: 99,
  border: `1px solid ${LINE}`,
  background: C2,
  color: TX,
  font: grot(600, 14),
  cursor: 'pointer',
};

export const btnDanger: CSSProperties = {
  ...btnPrimary,
  background: DANGER,
  color: ONDANGER,
  boxShadow: 'none',
};

export const btnSmall: CSSProperties = {
  ...btnSecondary,
  height: 34,
  padding: '0 13px',
  fontSize: 13,
};

export const input: CSSProperties = {
  height: 44,
  borderRadius: 14,
  border: `1px solid ${LINE}`,
  background: SUNK,
  color: TX,
  padding: '0 14px',
  fontSize: 14,
  outline: 'none',
  boxSizing: 'border-box',
  width: '100%',
};

/** The soft rounded search box used above the tables. */
export function SearchBox({
  value,
  onChange,
  placeholder,
}: {
  value: string;
  onChange: (v: string) => void;
  placeholder: string;
}) {
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: 8,
        height: 40,
        border: `1px solid ${LINE}`,
        borderRadius: 99,
        background: C1,
        padding: '0 14px',
        width: 280,
        maxWidth: '100%',
        boxSizing: 'border-box',
        color: MUT,
      }}
    >
      <Icon name="search" size={16} />
      <input
        aria-label={placeholder}
        placeholder={placeholder}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        style={{
          flex: 1,
          minWidth: 0,
          border: 'none',
          background: 'transparent',
          fontSize: 14,
          outline: 'none',
          color: TX,
        }}
      />
    </div>
  );
}

/** A labelled form field with an inline error (409s land here, per SPEC). */
export function Field({
  label: text,
  error,
  hint,
  children,
}: {
  label: string;
  error?: string | null;
  hint?: string;
  children: ReactNode;
}) {
  return (
    <label style={{ display: 'flex', flexDirection: 'column', gap: 6, minWidth: 0 }}>
      <span style={label}>{text}</span>
      {children}
      {error ? (
        <span role="alert" style={{ fontSize: 13, color: DANGER, fontWeight: 600 }}>
          {error}
        </span>
      ) : hint ? (
        <span style={{ fontSize: 12, color: FAINT }}>{hint}</span>
      ) : null}
    </label>
  );
}

/** On/off switch (launch toggles, "has ranks"). */
export function Switch({
  on,
  onChange,
  disabled,
  title,
}: {
  on: boolean;
  onChange: (next: boolean) => void;
  disabled?: boolean;
  title?: string;
}) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      aria-label={title}
      title={title}
      disabled={disabled}
      onClick={(e) => {
        e.stopPropagation();
        onChange(!on);
      }}
      style={{
        width: 44,
        height: 24,
        borderRadius: 99,
        border: 'none',
        padding: 0,
        background: on ? ACC : C2,
        position: 'relative',
        cursor: 'pointer',
        flex: 'none',
        transition: 'background .2s',
      }}
    >
      <span
        style={{
          position: 'absolute',
          top: 3,
          left: 3,
          width: 18,
          height: 18,
          borderRadius: '50%',
          background: on ? DK : MUT,
          transform: `translateX(${on ? 20 : 0}px)`,
          transition: 'transform .2s',
        }}
      />
    </button>
  );
}

export function Toast({ message }: { message: string | null }) {
  if (!message) return null;
  return (
    <div
      role="status"
      style={{
        position: 'fixed',
        bottom: 24,
        left: '50%',
        transform: 'translateX(-50%)',
        zIndex: 90,
        maxWidth: 'calc(100vw - 32px)',
        background: C1,
        border: `1px solid ${LINE}`,
        color: TX,
        borderRadius: 18,
        padding: '12px 18px',
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        fontSize: 14,
        fontWeight: 600,
        boxShadow: `${SHADOW}, ${GLOW}`,
      }}
    >
      <div style={{ width: 9, height: 9, borderRadius: '50%', background: ACC, flex: 'none' }} />
      {message}
    </div>
  );
}

const open: HTMLElement[] = [];

/** Centered dialog. Esc and a tap outside close it; the card scrolls on short screens. */
export function Modal({
  title,
  onClose,
  children,
  footer,
  width = 520,
  z = 70,
}: {
  title: string;
  onClose: () => void;
  children: ReactNode;
  footer?: ReactNode;
  width?: number;
  z?: number;
}) {
  const ref = useRef<HTMLDivElement>(null);
  useEffect(() => {
    // Only the top-most modal answers Esc (a confirm over an edit form).
    const me = ref.current!;
    open.push(me);
    const onKey = (e: KeyboardEvent) =>
      e.key === 'Escape' && open[open.length - 1] === me && onClose();
    window.addEventListener('keydown', onKey);
    me.focus();
    return () => {
      window.removeEventListener('keydown', onKey);
      open.splice(open.indexOf(me), 1);
    };
  }, [onClose]);

  return (
    <div
      onMouseDown={(e) => e.target === e.currentTarget && onClose()}
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: z,
        background: 'var(--scrim)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 16,
      }}
    >
      <div
        ref={ref}
        role="dialog"
        aria-modal="true"
        aria-label={title}
        tabIndex={-1}
        className="modal-card"
        style={{
          width,
          maxWidth: '100%',
          maxHeight: 'calc(100vh - 32px)',
          background: C1,
          border: `1px solid ${LINE}`,
          borderRadius: 28,
          boxShadow: SHADOW,
          display: 'flex',
          flexDirection: 'column',
          outline: 'none',
        }}
      >
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: 12,
            padding: '20px 22px 0',
          }}
        >
          <span style={heading(22)}>{title}</span>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close"
            style={{
              width: 36,
              height: 36,
              borderRadius: '50%',
              border: `1px solid ${LINE}`,
              background: C2,
              color: TX,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              padding: 0,
            }}
          >
            <Icon name="close" size={16} />
          </button>
        </div>
        <div style={{ padding: '16px 22px', overflowY: 'auto', minHeight: 0 }}>{children}</div>
        {footer && (
          <div
            style={{
              padding: '0 22px 20px',
              display: 'flex',
              gap: 8,
              justifyContent: 'flex-end',
              flexWrap: 'wrap',
            }}
          >
            {footer}
          </div>
        )}
      </div>
    </div>
  );
}

/** "Are you sure?" for every destructive action; says what happens. Errors show inline. */
export function ConfirmModal({
  title,
  body,
  confirm,
  busy,
  error,
  danger = true,
  onConfirm,
  onClose,
}: {
  title: string;
  body: ReactNode;
  confirm: string;
  busy?: boolean;
  error?: string | null;
  danger?: boolean;
  onConfirm: () => void;
  onClose: () => void;
}) {
  return (
    <Modal
      title={title}
      onClose={onClose}
      width={440}
      z={80}
      footer={
        <>
          <button type="button" onClick={onClose} style={btnSecondary}>
            Cancel
          </button>
          <button
            type="button"
            disabled={busy}
            onClick={onConfirm}
            style={danger ? btnDanger : btnPrimary}
          >
            {busy ? 'Working…' : confirm}
          </button>
        </>
      }
    >
      <div style={{ fontSize: 14, lineHeight: 1.5, color: TX }}>{body}</div>
      {error && (
        <div role="alert" style={{ marginTop: 12, fontSize: 13, fontWeight: 600, color: DANGER }}>
          {error}
        </div>
      )}
    </Modal>
  );
}

export type Col<T> = {
  head: string;
  /** CSS grid track, e.g. '1.4fr' or '90px'. */
  w: string;
  cell: (row: T) => ReactNode;
};

/** Grid table: header row, clickable rows, skeletons while loading, an empty message. */
export function Table<T>({
  cols,
  rows,
  rowKey,
  loading,
  empty,
  onRow,
  selected,
  minWidth = 760,
}: {
  cols: Col<T>[];
  rows: T[];
  rowKey: (row: T) => string;
  loading?: boolean;
  empty: string;
  onRow?: (row: T) => void;
  selected?: string | null;
  minWidth?: number;
}) {
  const grid = cols.map((c) => c.w).join(' ');
  const pad = '12px 18px';
  return (
    <div
      style={{
        background: C1,
        border: `1px solid ${LINE}`,
        borderRadius: 24,
        boxShadow: SHADOW,
        overflowX: 'auto',
      }}
    >
      <div style={{ minWidth }}>
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: grid,
            gap: 12,
            padding: pad,
            font: mono(700, 12),
            color: MUT,
            borderBottom: `1px solid ${RULE}`,
          }}
        >
          {cols.map((c) => (
            <span key={c.head}>{c.head}</span>
          ))}
        </div>
        {loading && !rows.length
          ? Array.from({ length: 6 }, (_, i) => (
              <div
                key={i}
                style={{ padding: '14px 18px', borderTop: i ? `1px solid ${RULE}` : 'none' }}
              >
                <div className="skeleton" style={{ height: 22 }} />
              </div>
            ))
          : rows.map((r, i) => {
              const key = rowKey(r);
              return (
                <div
                  key={key}
                  className={onRow ? 'row-hover' : undefined}
                  onClick={onRow ? () => onRow(r) : undefined}
                  style={{
                    display: 'grid',
                    gridTemplateColumns: grid,
                    gap: 12,
                    padding: '10px 18px',
                    alignItems: 'center',
                    borderTop: i ? `1px solid ${RULE}` : 'none',
                    cursor: onRow ? 'pointer' : 'default',
                    background: selected === key ? 'var(--soft)' : undefined,
                    opacity: loading ? 0.6 : 1,
                  }}
                >
                  {cols.map((c) => (
                    <div key={c.head} style={{ minWidth: 0, fontSize: 14 }}>
                      {c.cell(r)}
                    </div>
                  ))}
                </div>
              );
            })}
        {!loading && !rows.length && (
          <div style={{ padding: 36, textAlign: 'center', color: MUT, fontSize: 14 }}>{empty}</div>
        )}
      </div>
    </div>
  );
}

/** Page numbers with prev / next, "21–40 of 134". Hidden when everything fits one page. */
export function Pagination({
  page,
  pageSize,
  total,
  onPage,
}: {
  page: number;
  pageSize: number;
  total: number;
  onPage: (p: number) => void;
}) {
  const last = Math.max(1, Math.ceil(total / pageSize));
  if (total <= pageSize) return null;
  // First, last, and two either side of the current page; gaps become an ellipsis.
  const nums = [...new Set([1, page - 2, page - 1, page, page + 1, page + 2, last])]
    .filter((n) => n >= 1 && n <= last)
    .sort((a, b) => a - b);
  const items: (number | 'gap')[] = [];
  nums.forEach((n, i) => {
    if (i && n - nums[i - 1]! > 1) items.push('gap');
    items.push(n);
  });
  const from = (page - 1) * pageSize + 1;
  const btn = (on: boolean): CSSProperties => ({
    minWidth: 36,
    height: 36,
    padding: '0 10px',
    borderRadius: 99,
    border: `1px solid ${on ? 'transparent' : LINE}`,
    background: on ? ACC : C1,
    color: on ? DK : TX,
    font: mono(700, 13),
    cursor: 'pointer',
  });
  return (
    <nav
      aria-label="Pages"
      style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: 12,
        flexWrap: 'wrap',
      }}
    >
      <span style={{ fontSize: 13, color: MUT }}>
        {from}–{Math.min(total, page * pageSize)} of {total}
      </span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center', flexWrap: 'wrap' }}>
        <button
          type="button"
          disabled={page <= 1}
          onClick={() => onPage(page - 1)}
          style={btn(false)}
        >
          Prev
        </button>
        {items.map((n, i) =>
          n === 'gap' ? (
            <span key={`g${i}`} style={{ color: FAINT }}>
              …
            </span>
          ) : (
            <button
              key={n}
              type="button"
              aria-current={n === page ? 'page' : undefined}
              onClick={() => onPage(n)}
              style={btn(n === page)}
            >
              {n}
            </button>
          ),
        )}
        <button
          type="button"
          disabled={page >= last}
          onClick={() => onPage(page + 1)}
          style={btn(false)}
        >
          Next
        </button>
      </div>
    </nav>
  );
}

/** Error with Retry, for a failed load. */
export function ErrorBox({ message, onRetry }: { message: string; onRetry: () => void }) {
  return (
    <div
      role="alert"
      style={{
        border: `1px solid ${DANGER}`,
        borderRadius: 18,
        padding: '14px 18px',
        display: 'flex',
        alignItems: 'center',
        gap: 12,
        flexWrap: 'wrap',
        color: TX,
      }}
    >
      <span style={{ flex: 1, minWidth: 200, fontSize: 14 }}>{message}</span>
      <button type="button" onClick={onRetry} style={btnSecondary}>
        Retry
      </button>
    </div>
  );
}
