import { useEffect, useState } from 'react';
import { api, ApiError, query, type Metrics, type MetricsDay } from '../api';
import { BarList, LineChart } from '../charts';
import { ago, RANGES, REASON, SEV_ORDER, severity, subject } from '../data';
import type { Admin } from '../state';
import { Chip, ErrorBox } from '../ui';
import {
  ACC,
  ACCTX,
  C1,
  DANGER,
  LINE,
  MUT,
  SEV,
  SHADOW,
  SUNK,
  TX,
  card,
  cardHot,
  fmt,
  heading,
  mono,
  pad2,
  pill,
} from '../tokens';

/** Waitlist topics the apps send (POST /v1/waitlist). */
const TOPIC: Record<string, string> = { groups: 'Groups' };

const pct = (part: number, whole: number) => (whole ? Math.round((part / whole) * 100) : 0);
const DAY = 86_400_000;

type Field = Exclude<keyof MetricsDay, 'day'>;
const CHARTS: { field: Field; label: string; empty: string }[] = [
  { field: 'signups', label: 'Sign-ups', empty: 'No one signed up in this period.' },
  { field: 'listings', label: 'Listings', empty: 'No listings were posted in this period.' },
  { field: 'posts', label: 'Posts', empty: 'No posts in this period.' },
  { field: 'played', label: 'Games played', empty: 'No "we played" answers in this period.' },
];

const sum = (m: Metrics | null, f: Field) => (m ? m.series.reduce((a, d) => a + d[f], 0) : 0);

/** "▲ 12%" against the period before; null when there is nothing to compare. */
function change(cur: number, prev: number | null) {
  if (prev === null) return null;
  if (!prev) return cur ? { text: 'New', color: ACCTX } : null;
  const p = Math.round(((cur - prev) / prev) * 100);
  if (!p) return { text: 'No change', color: MUT };
  return { text: `${p > 0 ? '▲' : '▼'} ${Math.abs(p)}%`, color: p > 0 ? ACCTX : DANGER };
}

function Skeleton({ h }: { h: number }) {
  return <div className="skeleton" style={{ height: h, borderRadius: 18 }} />;
}

export function Overview({ admin }: { admin: Admin }) {
  const { s, set, go } = admin;
  const days = RANGES[s.range];
  const [tries, setTries] = useState(0);
  const [field, setField] = useState<Field>('signups');
  // One result per request; a stale one (other period, or a Retry) reads as loading.
  const key = `${days}#${tries}`;
  const [res, setRes] = useState<{
    key: string;
    m: Metrics | null;
    prev: Metrics | null;
    err: string | null;
  }>({ key: '', m: null, prev: null, err: null });
  const fresh = res.key === key;
  const m = fresh ? res.m : null;
  // The period before this one, only for the "vs previous" figures.
  const prev = fresh ? res.prev : null;
  const err = fresh ? res.err : null;

  useEffect(() => {
    let stale = false;
    const now = Date.now();
    const iso = (t: number) => new Date(t).toISOString();
    const fetchM = (from: number, to: number) =>
      api<Metrics>(`admin/metrics${query({ from: iso(from), to: iso(to) })}`);
    Promise.all([
      fetchM(now - days * DAY, now),
      fetchM(now - 2 * days * DAY, now - days * DAY).catch(() => null),
    ])
      .then(([cur, before]) => !stale && setRes({ key, m: cur, prev: before, err: null }))
      .catch(
        (e) =>
          !stale &&
          setRes({
            key,
            m: null,
            prev: null,
            err: e instanceof ApiError ? e.message : 'Could not load the metrics.',
          }),
      );
    return () => {
      stale = true;
    };
  }, [days, key]);

  const open = s.openReports;
  const openCount = s.openMore ? `${open.length}+` : pad2(open.length);
  const high = open.filter((r) => severity(r) === 'HIGH').length;
  const vs = `vs previous ${days} days`;

  const tiles = [
    {
      label: 'Players',
      value: m ? fmt(m.totals.players) : null,
      note: m ? `${fmt(m.totals.banned)} banned` : '',
    },
    {
      label: 'New sign-ups',
      value: m ? fmt(sum(m, 'signups')) : null,
      delta: m && prev ? change(sum(m, 'signups'), sum(prev, 'signups')) : null,
    },
    {
      label: 'Listings',
      value: m ? fmt(m.listings) : null,
      delta: m && prev ? change(m.listings, prev.listings) : null,
    },
    {
      label: 'Posts',
      value: m ? fmt(sum(m, 'posts')) : null,
      delta: m && prev ? change(sum(m, 'posts'), sum(prev, 'posts')) : null,
    },
    {
      label: 'Games played',
      value: m ? fmt(sum(m, 'played')) : null,
      delta: m && prev ? change(sum(m, 'played'), sum(prev, 'played')) : null,
    },
    {
      label: 'Open reports',
      value: openCount,
      note: `${high} high severity`,
      onClick: () => go('reports', { repStatus: 'open' }),
      hot: true,
    },
  ];

  const funnel = m
    ? [
        { label: 'Posted', n: m.listings },
        { label: 'Got a request', n: m.listingsWithRequest },
        { label: 'Played together', n: m.listingsPlayed },
      ]
    : [];
  const urgent = open
    .slice()
    .sort((a, b) => SEV_ORDER[severity(a)] - SEV_ORDER[severity(b)])
    .slice(0, 3);
  const chart = CHARTS.find((c) => c.field === field)!;
  const hasData = !!m && m.series.some((d) => d[field] > 0);

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {(Object.keys(RANGES) as (keyof typeof RANGES)[]).map((k) => (
          <Chip key={k} monoFont on={s.range === k} onClick={() => set({ range: k })}>
            {k.toLowerCase()}
          </Chip>
        ))}
        <span style={{ fontSize: 13, color: MUT }}>Last {days} days, Addis Ababa time</span>
      </div>

      {err && <ErrorBox message={err} onRetry={() => setTries((t) => t + 1)} />}

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(160px,1fr))',
          gap: 14,
        }}
      >
        {tiles.map((k) => (
          <div
            key={k.label}
            onClick={k.onClick}
            style={{
              background: C1,
              border: `1px solid ${LINE}`,
              borderRadius: 24,
              boxShadow: k.hot ? `${SHADOW}, 0 0 0 1.5px ${ACC}` : SHADOW,
              padding: 16,
              display: 'flex',
              flexDirection: 'column',
              gap: 8,
              cursor: k.onClick ? 'pointer' : 'default',
            }}
          >
            <div style={{ font: mono(700, 12), color: MUT }}>{k.label}</div>
            {k.value === null && !err ? (
              <Skeleton h={34} />
            ) : (
              <div style={{ ...heading(32), lineHeight: 1.1, color: k.hot ? ACCTX : TX }}>
                {k.value ?? '—'}
              </div>
            )}
            <div style={{ font: mono(600, 12), color: MUT, minHeight: 16 }}>
              {k.delta ? (
                <>
                  <span style={{ color: k.delta.color, fontWeight: 800 }}>{k.delta.text}</span> {vs}
                </>
              ) : (
                k.note
              )}
            </div>
          </div>
        ))}
      </div>

      <div style={{ ...card, gap: 14 }}>
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            gap: 10,
            flexWrap: 'wrap',
          }}
        >
          <span style={heading(20)}>Daily activity</span>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {CHARTS.map((c) => (
              <Chip
                key={c.field}
                height={32}
                size={13}
                on={field === c.field}
                onClick={() => setField(c.field)}
              >
                {c.label}
              </Chip>
            ))}
          </div>
        </div>
        {!m && !err && <Skeleton h={240} />}
        {m && hasData && <LineChart days={m.series} field={field} />}
        {m && !hasData && (
          <div
            style={{
              height: 200,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: MUT,
              fontSize: 14,
              textAlign: 'center',
              border: `1px dashed var(--dash)`,
              borderRadius: 18,
              padding: 16,
            }}
          >
            {chart.empty}
          </div>
        )}
        {err && !m && <div style={{ color: MUT, fontSize: 14 }}>The chart needs the metrics.</div>}
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(min(100%,360px),1fr))',
          gap: 16,
        }}
      >
        <div style={{ ...card, gap: 14 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(20)}>Top games</span>
            <span style={{ font: mono(600, 12), color: MUT }}>By listings</span>
          </div>
          {!m && !err && <Skeleton h={160} />}
          {m && m.topGames.length > 0 && (
            <BarList
              unit="listings"
              items={m.topGames.map((g) => ({ key: g.gameId, label: g.name, value: g.listings }))}
            />
          )}
          {m && !m.topGames.length && (
            <div style={{ fontSize: 14, color: MUT }}>No listings in this period yet.</div>
          )}
        </div>

        <div style={{ ...card, gap: 14 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(20)}>Listings → played</span>
            <span style={{ font: mono(600, 12), color: MUT }}>
              {m ? `${fmt(m.weeklyActive)} weekly active` : ''}
            </span>
          </div>
          <div style={{ fontSize: 13, color: MUT, lineHeight: 1.45 }}>
            Listings posted in this period, how many got a connection request, and how many ended
            with someone answering &ldquo;we played&rdquo;. The last one is the number that decides
            the MVP.
          </div>
          {!m && !err && <Skeleton h={100} />}
          {funnel.map((f, i) => (
            <div
              key={f.label}
              style={{
                display: 'grid',
                gridTemplateColumns: 'minmax(90px,130px) minmax(0,1fr) 90px',
                alignItems: 'center',
                gap: 12,
              }}
            >
              <span style={{ fontWeight: 700, fontSize: 14 }}>{f.label}</span>
              <div style={{ height: 14, borderRadius: 99, overflow: 'hidden', background: SUNK }}>
                <div
                  style={{
                    height: '100%',
                    width: `${pct(f.n, funnel[0]!.n)}%`,
                    background: i === funnel.length - 1 ? ACC : 'var(--grey)',
                    borderRadius: 99,
                  }}
                />
              </div>
              <span style={{ font: mono(800, 12), textAlign: 'right' }}>
                {fmt(f.n)} · {pct(f.n, funnel[0]!.n)}%
              </span>
            </div>
          ))}
          {m && !m.listings && (
            <div style={{ fontSize: 14, color: MUT }}>No listings in this period yet.</div>
          )}
        </div>

        <div style={{ ...cardHot, gap: 10 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(20)}>Needs attention</span>
            <span
              onClick={() => go('reports')}
              style={{
                fontSize: 13,
                fontWeight: 700,
                textDecoration: 'underline',
                cursor: 'pointer',
                color: ACCTX,
              }}
            >
              All reports
            </span>
          </div>
          {urgent.map((r) => {
            const sev = severity(r);
            return (
              <div
                key={r.id}
                onClick={() => go('reports', { repSel: r.id, repStatus: 'open', repSev: 'ALL' })}
                className="row-hover"
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 12,
                  border: `1px solid ${LINE}`,
                  background: SUNK,
                  borderRadius: 16,
                  padding: '10px 12px',
                  cursor: 'pointer',
                }}
              >
                <span style={{ ...pill(SEV[sev].bg, SEV[sev].fg), flex: 'none' }}>{sev}</span>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{
                      fontWeight: 700,
                      fontSize: 14,
                      whiteSpace: 'nowrap',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {REASON[r.reason]} · @{r.target.username}
                  </div>
                  <div style={{ fontSize: 12, color: MUT }}>
                    {subject(r).kind} · {ago(r.createdAt)}
                  </div>
                </div>
              </div>
            );
          })}
          {!urgent.length && (
            <div style={{ fontSize: 14, color: MUT, padding: '8px 0' }}>Queue is clear.</div>
          )}
        </div>

        <div style={{ ...card, gap: 14 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(20)}>Waitlist</span>
            <span style={{ font: mono(600, 12), color: MUT }}>All time</span>
          </div>
          <div style={{ fontSize: 13, color: MUT, lineHeight: 1.45 }}>
            People who tapped &ldquo;Notify me&rdquo; on a feature that isn&rsquo;t built yet. It
            says which one to launch first.
          </div>
          {!m && !err && <Skeleton h={40} />}
          {m && m.waitlist.length > 0 && (
            <BarList
              unit="people"
              items={m.waitlist.map((w) => ({
                key: w.topic,
                label: TOPIC[w.topic] ?? w.topic,
                value: w.count,
              }))}
            />
          )}
          {m && !m.waitlist.length && (
            <div style={{ fontSize: 14, color: MUT }}>Nobody has joined a waitlist yet.</div>
          )}
        </div>
      </div>
    </>
  );
}
