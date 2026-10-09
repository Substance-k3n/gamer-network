import { CITIES, POST_MIX, RANGES } from '../data';
import type { Admin } from '../state';
import {
  ACC,
  C1,
  DOTO,
  LINE,
  MUT,
  PANEL,
  PINK,
  RULE,
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

const SEV_ORDER = { HIGH: 0, MED: 1, LOW: 2 } as const;

export function Overview({ admin }: { admin: Admin }) {
  const { s, go } = admin;
  const R = RANGES[s.range];
  const m = R.mult;
  const openReps = s.reports.filter((r) => r.status === 'open');
  const total = s.users.length * 1450 + 16580;

  const kpis = [
    {
      label: 'TOTAL PLAYERS',
      value: fmt(total),
      delta: `+${fmt(212 * m)} THIS PERIOD`,
      onClick: () => go('users'),
    },
    { label: 'DAILY ACTIVE', value: fmt(4870 + s.range.length * 40), delta: '+6.2% VS PREV' },
    { label: 'CONNECTIONS MADE', value: fmt(1340 * m), delta: '+11% VS PREV' },
    { label: 'SESSIONS PLAYED', value: fmt(960 * m), delta: '+8% VS PREV' },
    { label: 'LIVE LISTINGS', value: fmt(412), delta: 'AVG 4H 12M LIFETIME' },
    {
      label: 'OPEN REPORTS',
      value: pad2(openReps.length),
      delta: `${openReps.filter((r) => r.sev === 'HIGH').length} HIGH SEVERITY`,
      onClick: () => go('reports', { repStatus: 'open' }),
      hot: true,
    },
  ];

  // Synthetic sign-up curve from the design; swap for real daily counts.
  const vals = Array.from({ length: R.bars }, (_, i) => {
    const x = i / (R.bars - 1 || 1);
    return 0.45 + 0.35 * Math.sin(i * 1.7 + R.days) * 0.5 + 0.4 * x + 0.12 * Math.cos(i * 2.9);
  });
  const mx = Math.max(...vals);
  const per = R.days / R.bars;
  const bars = vals.map((v, i) => ({
    h: `${Math.round((v / mx) * 100)}%`,
    bg: i === vals.length - 1 ? ACC : '#3A3A3A',
    tip: `${fmt(v * 28 * per)} sign-ups`,
  }));

  const top = s.games
    .filter((g) => g.enabled)
    .sort((a, b) => b.players - a.players)
    .slice(0, 6);
  const urgent = openReps
    .slice()
    .sort((a, b) => SEV_ORDER[a.sev] - SEV_ORDER[b.sev])
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
              cursor: 'pointer',
            }}
          >
            <div style={{ font: mono(400, 11), letterSpacing: '.04em', color: MUT }}>{k.label}</div>
            <div
              style={{
                fontFamily: DOTO,
                fontWeight: 900,
                fontSize: 34,
                lineHeight: 1,
                color: k.hot ? ACC : TX,
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
            <span style={heading(22)}>Sign-ups</span>
            <span style={{ font: mono(400, 11), color: MUT }}>LAST {R.days} DAYS</span>
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'flex-end',
              gap: 5,
              height: 190,
              borderBottom: `1px solid ${LINE}`,
              paddingBottom: 2,
            }}
          >
            {bars.map((b, i) => (
              <div
                key={i}
                title={b.tip}
                style={{
                  flex: 1,
                  height: b.h,
                  backgroundColor: b.bg,
                  backgroundImage: 'radial-gradient(rgba(0,0,0,.35) 1px,transparent 1.2px)',
                  backgroundSize: '5px 5px',
                  borderRadius: '6px 6px 2px 2px',
                  minWidth: 4,
                }}
              />
            ))}
          </div>
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              font: mono(400, 11),
              color: MUT,
            }}
          >
            <span>{R.days} DAYS AGO</span>
            <span>TODAY · {bars.length ? bars[bars.length - 1].tip.toUpperCase() : ''}</span>
          </div>
        </div>

        <div style={{ ...card, gap: 12 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span style={heading(22)}>Players by game</span>
            <span
              onClick={() => go('games')}
              style={{
                fontSize: 13,
                fontWeight: 600,
                textDecoration: 'underline',
                cursor: 'pointer',
              }}
            >
              Manage games
            </span>
          </div>
          {top.map((g, i) => (
            <div
              key={g.id}
              style={{
                display: 'grid',
                gridTemplateColumns: '130px minmax(0,1fr) 60px',
                alignItems: 'center',
                gap: 12,
              }}
            >
              <span
                style={{
                  fontWeight: 600,
                  fontSize: 14,
                  whiteSpace: 'nowrap',
                  overflow: 'hidden',
                  textOverflow: 'ellipsis',
                }}
              >
                {g.name}
              </span>
              <div
                style={{ height: 14, borderRadius: 99, overflow: 'hidden', background: '#232323' }}
              >
                <div
                  style={{
                    height: '100%',
                    width: `${Math.round((g.players / top[0].players) * 100)}%`,
                    background: i === 0 ? ACC : '#5A5A5A',
                    borderRadius: 99,
                  }}
                />
              </div>
              <span style={{ font: mono(700, 12), textAlign: 'right' }}>{fmt(g.players)}</span>
            </div>
          ))}
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
          {urgent.map((r) => (
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
              <span style={{ ...pill(SEV[r.sev].bg, SEV[r.sev].fg), flex: 'none' }}>{r.sev}</span>
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
                  {r.reason} · @{r.target}
                </div>
                <div style={{ fontSize: 12, color: MUT }}>
                  {r.kind} · {r.count} reports · {r.age}
                </div>
              </div>
            </div>
          ))}
          {!urgent.length && (
            <div style={{ fontSize: 14, color: MUT, padding: '8px 0' }}>Queue is clear.</div>
          )}
        </div>

        <div style={{ ...card, gap: 6 }}>
          <div style={{ ...heading(22), marginBottom: 6 }}>Top cities</div>
          {CITIES.map(([name, users], i) => (
            <div
              key={name}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: 12,
                padding: '8px 0',
                borderTop: i ? `1px solid ${RULE}` : 'none',
              }}
            >
              <span style={{ font: mono(700, 11), color: MUT, width: 22 }}>{pad2(i + 1)}</span>
              <span style={{ flex: 1, fontWeight: 600, fontSize: 14 }}>{name}</span>
              <span style={{ font: mono(700, 12) }}>{fmt(users)}</span>
            </div>
          ))}
        </div>

        <div style={{ ...card, gap: 12 }}>
          <div style={heading(22)}>Posts by type</div>
          <div
            style={{ display: 'flex', height: 22, borderRadius: 99, overflow: 'hidden', gap: 2 }}
          >
            {POST_MIX.map(([label, pct, bg]) => (
              <div key={label} style={{ width: `${pct}%`, background: bg }} />
            ))}
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px 16px' }}>
            {POST_MIX.map(([label, pct, bg]) => (
              <div
                key={label}
                style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13 }}
              >
                <span
                  style={{ width: 10, height: 10, borderRadius: 3, background: bg, flex: 'none' }}
                />
                <span style={{ flex: 1 }}>{label}</span>
                <span style={{ font: mono(700, 12) }}>{pct}%</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </>
  );
}
