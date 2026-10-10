import { useEffect, useState } from 'react';
import { api, query, type Metrics } from '../api';
import { ago, RANGES, REASON, SEV_ORDER, severity } from '../data';
import type { Admin } from '../state';
import {
  ACC,
  C1,
  DOTO,
  LINE,
  MUT,
  PANEL,
  PINK,
  SEV,
  SHADOW,
  TX,
  card,
  cardHot,
  fmt,
  heading,
  mono,
  pad2,
  pill,
} from '../tokens';

const pct = (part: number, whole: number) => (whole ? Math.round((part / whole) * 100) : 0);

export function Overview({ admin }: { admin: Admin }) {
  const { s, go, fail } = admin;
  const days = RANGES[s.range];
  const [m, setM] = useState<Metrics | null>(null);

  useEffect(() => {
    const from = new Date(Date.now() - days * 86_400_000).toISOString();
    api<Metrics>(`admin/metrics${query({ from })}`)
      .then(setM)
      .catch(fail);
  }, [days, fail]);

  const open = s.openReports;
  const openCount = s.openMore ? `${open.length}+` : pad2(open.length);
  const high = open.filter((r) => severity(r) === 'HIGH').length;

  const kpis = [
    {
      label: 'PLAYED TOGETHER',
      value: m ? `${Math.round(m.playedRate * 100)}%` : '—',
      delta: m ? `${fmt(m.listingsPlayed)} OF ${fmt(m.listings)} LISTINGS` : '',
      accent: true,
    },
    { label: 'LISTINGS', value: m ? fmt(m.listings) : '—', delta: `LAST ${days} DAYS` },
    {
      label: 'GOT A REQUEST',
      value: m ? fmt(m.listingsWithRequest) : '—',
      delta: m ? `${pct(m.listingsWithRequest, m.listings)}% OF LISTINGS` : '',
    },
    { label: 'WEEKLY ACTIVE', value: m ? fmt(m.weeklyActive) : '—', delta: 'LAST 7 DAYS' },
    {
      label: 'OPEN REPORTS',
      value: openCount,
      delta: `${high} HIGH SEVERITY`,
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

  return (
    <>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(168px,1fr))',
          gap: 14,
        }}
      >
        {kpis.map((k) => (
          <div
            key={k.label}
            onClick={k.onClick}
            style={{
              background: C1,
              border: `1px solid ${k.hot ? ACC : LINE}`,
              borderRadius: 22,
              boxShadow: SHADOW,
              padding: 16,
              display: 'flex',
              flexDirection: 'column',
              gap: 10,
              cursor: k.onClick ? 'pointer' : 'default',
            }}
          >
            <div style={{ font: mono(400, 11), letterSpacing: '.04em', color: MUT }}>{k.label}</div>
            <div
              style={{
                fontFamily: DOTO,
                fontWeight: 900,
                fontSize: 34,
                lineHeight: 1,
                color: k.hot || k.accent ? ACC : TX,
              }}
            >
              {k.value}
            </div>
            <div style={{ font: mono(700, 11), color: k.hot ? PINK : MUT }}>{k.delta}</div>
          </div>
        ))}
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(360px,1fr))',
          gap: 16,
        }}
      >
        <div style={{ ...card, gap: 14 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(22)}>Listings → played</span>
            <span style={{ font: mono(400, 11), color: MUT }}>LAST {days} DAYS</span>
          </div>
          <div style={{ fontSize: 13, color: MUT, lineHeight: 1.45 }}>
            Listings posted in this period, how many got a connection request, and how many ended
            with someone answering &ldquo;we played&rdquo;. The last one is the number that decides
            the MVP.
          </div>
          {funnel.map((f, i) => (
            <div
              key={f.label}
              style={{
                display: 'grid',
                gridTemplateColumns: '130px minmax(0,1fr) 90px',
                alignItems: 'center',
                gap: 12,
              }}
            >
              <span style={{ fontWeight: 600, fontSize: 14 }}>{f.label}</span>
              <div
                style={{ height: 14, borderRadius: 99, overflow: 'hidden', background: '#232323' }}
              >
                <div
                  style={{
                    height: '100%',
                    width: `${pct(f.n, funnel[0].n)}%`,
                    background: i === funnel.length - 1 ? ACC : '#5A5A5A',
                    borderRadius: 99,
                  }}
                />
              </div>
              <span style={{ font: mono(700, 12), textAlign: 'right' }}>
                {fmt(f.n)} · {pct(f.n, funnel[0].n)}%
              </span>
            </div>
          ))}
          {m && !m.listings && (
            <div style={{ fontSize: 14, color: MUT }}>No listings in this period yet.</div>
          )}
        </div>

        <div style={{ ...cardHot, gap: 10 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(22)}>Needs attention</span>
            <span
              onClick={() => go('reports')}
              style={{
                fontSize: 13,
                fontWeight: 600,
                textDecoration: 'underline',
                cursor: 'pointer',
                color: ACC,
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
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 12,
                  border: `1px solid ${LINE}`,
                  background: PANEL,
                  borderRadius: 14,
                  padding: '10px 12px',
                  cursor: 'pointer',
                }}
              >
                <span style={{ ...pill(SEV[sev].bg, SEV[sev].fg), flex: 'none' }}>{sev}</span>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div
                    style={{
                      fontWeight: 600,
                      fontSize: 14,
                      whiteSpace: 'nowrap',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {REASON[r.reason]} · @{r.target.username}
                  </div>
                  <div style={{ fontSize: 12, color: MUT }}>
                    {r.listingId ? 'Listing' : 'Profile'} · {ago(r.createdAt)}
                  </div>
                </div>
              </div>
            );
          })}
          {!urgent.length && (
            <div style={{ fontSize: 14, color: MUT, padding: '8px 0' }}>Queue is clear.</div>
          )}
        </div>
      </div>
    </>
  );
}
