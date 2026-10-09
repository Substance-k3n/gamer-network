import type { Report } from '../data';
import type { Admin } from '../state';
import { Chip, btnPrimary, btnSecondary } from '../ui';
import { ACC, C1, DOTO, LINE, MUT, PANEL, SEV, TX, card, grot, label, mono, pill } from '../tokens';

const SEV_ORDER = { HIGH: 0, MED: 1, LOW: 2 } as const;
const stLabel = (r: Report) =>
  r.status === 'open' ? 'OPEN' : r.status === 'dismissed' ? 'DISMISSED' : 'RESOLVED';
const stFg = (r: Report) => (r.status === 'open' ? ACC : MUT);

export function Reports({ admin }: { admin: Admin }) {
  const { s, set, go, closeRep } = admin;
  const openCount = s.reports.filter((r) => r.status === 'open').length;
  const list = s.reports
    .filter(
      (r) =>
        (s.repStatus === 'open' ? r.status === 'open' : r.status !== 'open') &&
        (s.repSev === 'ALL' || r.sev === s.repSev),
    )
    .sort((a, b) => SEV_ORDER[a.sev] - SEV_ORDER[b.sev]);
  const rep = s.reports.find((r) => r.id === s.repSel && list.includes(r)) ?? list[0];
  const target = rep && s.users.find((u) => u.handle === rep.target);

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {(
          [
            ['open', `Open (${openCount})`],
            ['closed', 'Closed'],
          ] as const
        ).map(([k, l]) => (
          <Chip key={k} on={s.repStatus === k} onClick={() => set({ repStatus: k, repSel: null })}>
            {l}
          </Chip>
        ))}
        <span style={{ width: 1, height: 24, background: LINE, margin: '0 4px' }} />
        {(['ALL', 'HIGH', 'MED', 'LOW'] as const).map((k) => (
          <Chip key={k} monoFont on={s.repSev === k} onClick={() => set({ repSev: k })}>
            {k}
          </Chip>
        ))}
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit,minmax(380px,1fr))',
          gap: 16,
          alignItems: 'start',
        }}
      >
        <div
          style={{
            background: C1,
            border: `1px solid ${LINE}`,
            borderRadius: 24,
            padding: 8,
            display: 'flex',
            flexDirection: 'column',
            gap: 4,
          }}
        >
          {list.map((r) => {
            const sel = r.id === s.repSel;
            return (
              <div
                key={r.id}
                onClick={() => set({ repSel: r.id })}
                style={{
                  display: 'grid',
                  gridTemplateColumns: 'auto minmax(0,1fr) auto',
                  gap: 12,
                  alignItems: 'center',
                  padding: 12,
                  borderRadius: 16,
                  background: sel ? '#232323' : 'transparent',
                  border: `1px solid ${sel ? ACC : 'transparent'}`,
                  cursor: 'pointer',
                }}
              >
                <span style={pill(SEV[r.sev].bg, SEV[r.sev].fg)}>{r.sev}</span>
                <div style={{ minWidth: 0 }}>
                  <div
                    style={{
                      fontWeight: 600,
                      fontSize: 15,
                      whiteSpace: 'nowrap',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {r.reason}
                  </div>
                  <div
                    style={{
                      fontSize: 12,
                      color: MUT,
                      whiteSpace: 'nowrap',
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    {r.kind} by @{r.target} · {r.count} reports
                  </div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div style={{ font: mono(700, 11) }}>{r.age}</div>
                  <div style={{ font: mono(400, 10), color: stFg(r), marginTop: 3 }}>
                    {stLabel(r)}
                  </div>
                </div>
              </div>
            );
          })}
          {!list.length && (
            <div style={{ padding: 36, textAlign: 'center', color: MUT, fontSize: 14 }}>
              No reports match these filters.
            </div>
          )}
        </div>

        {rep && (
          <div style={{ ...card, padding: 20, gap: 16, position: 'sticky', top: 20 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
              <span style={pill(SEV[rep.sev].bg, SEV[rep.sev].fg, '3px 9px')}>{rep.sev}</span>
              <span style={{ font: mono(400, 11), color: MUT }}>
                #{rep.id} · {rep.kind} · {rep.age} ago
              </span>
              <span style={{ flex: 1 }} />
              <span style={{ font: mono(700, 11), color: stFg(rep) }}>{stLabel(rep)}</span>
            </div>
            <div style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 28, lineHeight: 1.05 }}>
              {rep.reason}
            </div>
            <div
              style={{
                background: PANEL,
                border: '1px dashed #444444',
                borderRadius: 16,
                padding: 14,
                display: 'flex',
                flexDirection: 'column',
                gap: 8,
              }}
            >
              <div style={{ ...label, letterSpacing: '.04em' }}>REPORTED CONTENT</div>
              <div style={{ fontSize: 15, lineHeight: 1.45, textWrap: 'pretty' }}>
                “{rep.excerpt}”
              </div>
              {rep.clip && (
                <div
                  style={{
                    height: 120,
                    borderRadius: 12,
                    background: '#0E0E0E',
                    backgroundImage:
                      'repeating-linear-gradient(135deg,rgba(237,237,237,.05) 0 10px,transparent 10px 20px)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    font: mono(400, 11),
                    color: '#6E6E6E',
                  }}
                >
                  clip preview
                </div>
              )}
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
              <div
                onClick={() => target && go('users', { userSel: target.id })}
                style={{
                  border: `1px solid ${LINE}`,
                  borderRadius: 16,
                  padding: 12,
                  cursor: 'pointer',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 6,
                }}
              >
                <div style={label}>REPORTED USER</div>
                <div style={{ fontWeight: 700, fontSize: 15 }}>@{rep.target}</div>
                <div style={{ fontSize: 12, color: MUT }}>
                  {target ? `${target.status} · ${target.reports} prior reports` : ''}
                </div>
              </div>
              <div
                style={{
                  border: `1px solid ${LINE}`,
                  borderRadius: 16,
                  padding: 12,
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 6,
                }}
              >
                <div style={label}>FIRST REPORTED BY</div>
                <div style={{ fontWeight: 700, fontSize: 15 }}>@{rep.reporter}</div>
                <div style={{ fontSize: 12, color: MUT }}>+{rep.count - 1} others</div>
              </div>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <div style={label}>INTERNAL NOTE</div>
              <textarea
                rows={2}
                placeholder="Visible to admins only"
                value={rep.note}
                onChange={(e) => {
                  const v = e.target.value;
                  set((st) => ({
                    reports: st.reports.map((x) => (x.id === rep.id ? { ...x, note: v } : x)),
                  }));
                }}
                style={{
                  border: `1px solid ${LINE}`,
                  borderRadius: 14,
                  background: PANEL,
                  color: TX,
                  padding: '10px 12px',
                  fontSize: 14,
                  outline: 'none',
                  resize: 'vertical',
                }}
              />
            </div>
            {rep.status === 'open' ? (
              <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                <button
                  type="button"
                  onClick={() => closeRep(rep.id, 'Content removed', null)}
                  style={btnPrimary}
                >
                  Remove content
                </button>
                <button
                  type="button"
                  onClick={() => closeRep(rep.id, 'User warned', 'Warned')}
                  style={btnSecondary}
                >
                  Warn user
                </button>
                <button
                  type="button"
                  onClick={() => closeRep(rep.id, 'Suspended 7 days', 'Suspended')}
                  style={btnSecondary}
                >
                  Suspend 7d
                </button>
                <button
                  type="button"
                  onClick={() => closeRep(rep.id, 'Dismissed', null)}
                  style={{ ...btnSecondary, background: 'transparent', color: MUT }}
                >
                  Dismiss
                </button>
              </div>
            ) : (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 10,
                  border: `1px solid ${LINE}`,
                  borderRadius: 14,
                  padding: '10px 12px',
                }}
              >
                <span style={{ flex: 1, fontSize: 14 }}>{rep.outcome ?? ''}</span>
                <button
                  type="button"
                  onClick={() =>
                    set((st) => ({
                      reports: st.reports.map((x) =>
                        x.id === rep.id ? { ...x, status: 'open', outcome: null } : x,
                      ),
                      repStatus: 'open',
                    }))
                  }
                  style={{
                    height: 34,
                    padding: '0 12px',
                    borderRadius: 99,
                    border: `1px solid ${LINE}`,
                    background: 'transparent',
                    color: TX,
                    font: grot(600, 13),
                    cursor: 'pointer',
                  }}
                >
                  Reopen
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </>
  );
}
