import { useState } from 'react';
import type { MetricsDay } from './api';
import { ACC, ACCTX, C1, FAINT, LINE, MUT, RULE, TX, fmt, mono } from './tokens';

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** "2026-10-28" (an Addis Ababa date) as "Oct 28", without a timezone shift. */
export const dayLabel = (day: string) => {
  const [, m, d] = day.split('-');
  return `${MONTHS[Number(m) - 1]} ${Number(d)}`;
};

/** Rounds the top of the axis up to 1, 2, 5 × 10ⁿ so the gridlines read cleanly. */
function niceMax(v: number) {
  if (v <= 4) return 4;
  const pow = 10 ** Math.floor(Math.log10(v));
  const f = v / pow;
  return (f <= 1 ? 1 : f <= 2 ? 2 : f <= 5 ? 5 : 10) * pow;
}

const W = 720;
const H = 240;
const PAD = { l: 42, r: 14, t: 14, b: 30 };

/** Daily values as a line over a soft area, with gridlines and a hover readout. */
export function LineChart({
  days,
  field,
}: {
  days: MetricsDay[];
  field: Exclude<keyof MetricsDay, 'day'>;
}) {
  const [hover, setHover] = useState<number | null>(null);
  const n = days.length;
  const values = days.map((d) => d[field]);
  const max = niceMax(Math.max(0, ...values));
  const iw = W - PAD.l - PAD.r;
  const ih = H - PAD.t - PAD.b;
  const x = (i: number) => PAD.l + (n === 1 ? iw / 2 : (i * iw) / (n - 1));
  const y = (v: number) => PAD.t + ih - (v / max) * ih;

  const line = values
    .map((v, i) => `${i ? 'L' : 'M'}${x(i).toFixed(1)} ${y(v).toFixed(1)}`)
    .join(' ');
  const area = `${line} L${x(n - 1).toFixed(1)} ${PAD.t + ih} L${x(0).toFixed(1)} ${PAD.t + ih} Z`;
  const ticks = [0, 1, 2, 3, 4].map((t) => (max * t) / 4);
  const every = Math.max(1, Math.ceil(n / 6));
  const total = values.reduce((a, b) => a + b, 0);

  const onMove = (e: React.PointerEvent<SVGRectElement>) => {
    const box = e.currentTarget.getBoundingClientRect();
    const px = ((e.clientX - box.left) / box.width) * W;
    const i = n === 1 ? 0 : Math.round(((px - PAD.l) / iw) * (n - 1));
    setHover(Math.min(n - 1, Math.max(0, i)));
  };

  const h = hover !== null ? days[hover] : null;
  return (
    <div style={{ position: 'relative' }}>
      <svg
        viewBox={`0 0 ${W} ${H}`}
        width="100%"
        role="img"
        aria-label={`${field} per day, ${total} in total over ${n} days`}
        style={{ display: 'block', touchAction: 'pan-y' }}
      >
        {ticks.map((t) => (
          <g key={t}>
            <line x1={PAD.l} x2={W - PAD.r} y1={y(t)} y2={y(t)} stroke={RULE} strokeWidth="1" />
            <text x={PAD.l - 8} y={y(t) + 4} textAnchor="end" fontSize="11" fill={FAINT}>
              {fmt(t)}
            </text>
          </g>
        ))}
        {days.map((d, i) =>
          i % every === 0 ? (
            <text key={d.day} x={x(i)} y={H - 8} textAnchor="middle" fontSize="11" fill={MUT}>
              {dayLabel(d.day)}
            </text>
          ) : null,
        )}
        <path d={area} fill={ACC} fillOpacity="0.28" />
        <path
          d={line}
          fill="none"
          stroke={ACCTX}
          strokeWidth="2.5"
          strokeLinejoin="round"
          strokeLinecap="round"
        />
        {n <= 31 &&
          values.map((v, i) => (
            <circle key={days[i]!.day} cx={x(i)} cy={y(v)} r="2.5" fill={ACCTX} />
          ))}
        {hover !== null && (
          <g>
            <line
              x1={x(hover)}
              x2={x(hover)}
              y1={PAD.t}
              y2={PAD.t + ih}
              stroke={FAINT}
              strokeDasharray="3 3"
            />
            <circle
              cx={x(hover)}
              cy={y(values[hover]!)}
              r="5"
              fill={C1}
              stroke={ACCTX}
              strokeWidth="2.5"
            />
          </g>
        )}
        <rect
          x={PAD.l}
          y={PAD.t}
          width={iw}
          height={ih}
          fill="transparent"
          onPointerMove={onMove}
          onPointerDown={onMove}
          onPointerLeave={() => setHover(null)}
        />
      </svg>
      {h && hover !== null && (
        <div
          style={{
            position: 'absolute',
            top: 0,
            left: `${(x(hover) / W) * 100}%`,
            transform: `translateX(${hover > n * 0.65 ? '-108%' : '8%'})`,
            pointerEvents: 'none',
            background: C1,
            border: `1px solid ${LINE}`,
            borderRadius: 14,
            boxShadow: 'var(--shadow)',
            padding: '8px 12px',
            fontSize: 12,
            color: TX,
            display: 'flex',
            flexDirection: 'column',
            gap: 2,
            whiteSpace: 'nowrap',
          }}
        >
          <span style={{ color: MUT, font: mono(700, 11) }}>{dayLabel(h.day)}</span>
          <span style={{ font: mono(800, 16) }}>{fmt(h[field])}</span>
        </div>
      )}
    </div>
  );
}

/** Horizontal bars, widest = the top value. Pure HTML, so it wraps and reflows. */
export function BarList({
  items,
  unit,
}: {
  items: { key: string; label: string; value: number }[];
  unit: string;
}) {
  const top = Math.max(1, ...items.map((i) => i.value));
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      {items.map((it) => (
        <div
          key={it.key}
          title={`${it.label}: ${fmt(it.value)} ${unit}`}
          style={{
            display: 'grid',
            gridTemplateColumns: 'minmax(80px,140px) minmax(0,1fr) 44px',
            alignItems: 'center',
            gap: 12,
          }}
        >
          <span
            style={{
              fontWeight: 700,
              fontSize: 14,
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {it.label}
          </span>
          <div
            style={{
              height: 14,
              borderRadius: 99,
              overflow: 'hidden',
              background: 'var(--sunken)',
            }}
          >
            <div
              style={{
                height: '100%',
                width: `${(it.value / top) * 100}%`,
                minWidth: it.value ? 6 : 0,
                background: ACC,
                borderRadius: 99,
              }}
            />
          </div>
          <span style={{ font: mono(800, 13), textAlign: 'right' }}>{fmt(it.value)}</span>
        </div>
      ))}
    </div>
  );
}
