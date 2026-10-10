import { useEffect, useState } from 'react';
import { api, query, type AdminReport, type Page, type ResolveAction } from '../api';
import { ago, REASON, SEV_ORDER, severity, STATE_LABEL } from '../data';
import type { Admin } from '../state';
import { Chip, btnPrimary, btnSecondary } from '../ui';
import { ACC, C1, DOTO, LINE, MUT, PANEL, SEV, TX, card, grot, label, mono, pill } from '../tokens';

const stLabel = (r: AdminReport) =>
  r.status === 'open' ? 'OPEN' : r.status === 'dismissed' ? 'DISMISSED' : 'ACTIONED';
const stFg = (r: AdminReport) => (r.status === 'open' ? ACC : MUT);

const DONE: Record<ResolveAction, string> = {
  dismiss: 'Dismissed',
  warn: 'User warned',
  remove_listing: 'Listing removed',
  ban: 'User banned',
};

/** Closed = actioned + dismissed, newest decision first (the API lists one status at a time). */
async function loadClosed(): Promise<AdminReport[]> {
  const [a, d] = await Promise.all(
    (['actioned', 'dismissed'] as const).map((status) =>
      api<Page<AdminReport>>(`admin/reports${query({ status, limit: 50 })}`),
    ),
  );
  return [...a.items, ...d.items].sort((x, y) =>
    (y.resolvedAt ?? '').localeCompare(x.resolvedAt ?? ''),
  );
}

export function Reports({ admin }: { admin: Admin }) {
  const { s, set, toast, fail, changed } = admin;
  const [closed, setClosed] = useState<AdminReport[]>([]);
  const [notes, setNotes] = useState<Record<string, string>>({});
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    if (s.repStatus === 'closed') loadClosed().then(setClosed).catch(fail);
  }, [s.repStatus, fail]);

  const all = s.repStatus === 'open' ? s.openReports : closed;
  const list = all
    .filter((r) => s.repSev === 'ALL' || severity(r) === s.repSev)
    // Most severe first; within a level, the API's order (open: oldest first).
    .sort((a, b) => SEV_ORDER[severity(a)] - SEV_ORDER[severity(b)]);
  const rep = list.find((r) => r.id === s.repSel) ?? list[0];
  const openCount = s.openMore ? `${s.openReports.length}+` : s.openReports.length;

  const resolve = async (r: AdminReport, action: ResolveAction) => {
    const note = (notes[r.id] ?? '').trim();
    if (action === 'ban' && !note) {
      toast('Write the reason in the note first. It is kept with the ban.');
      return;
    }
    setBusy(true);
    try {
      await api(`admin/reports/${r.id}/resolve`, { method: 'POST', body: { action, note } });
      const next = list.find((x) => x.id !== r.id);
      set({ repSel: next?.id ?? null });
      changed();
      toast(`${DONE[action]} · @${r.target.username}`);
    } catch (e) {
      fail(e);
    } finally {
      setBusy(false);
    }
  };

  const loadMore = () => {
    if (!s.openMore) return;
    api<Page<AdminReport>>(
      `admin/reports${query({ status: 'open', limit: 50, cursor: s.openMore })}`,
    )
      .then((p) =>
        set((st) => ({ openReports: [...st.openReports, ...p.items], openMore: p.nextCursor })),
      )
      .catch(fail);
  };

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
            const sel = r.id === rep?.id;
            const sev = severity(r);
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
                <span style={pill(SEV[sev].bg, SEV[sev].fg)}>{sev}</span>
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
                    {REASON[r.reason]}
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
                    {r.listingId ? 'Listing' : 'Profile'} by @{r.target.username}
                  </div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div style={{ font: mono(700, 11) }}>{ago(r.createdAt)}</div>
                  <div style={{ font: mono(400, 10), color: stFg(r), marginTop: 3 }}>
                    {stLabel(r)}
                  </div>
                </div>
              </div>
            );
          })}
          {!list.length && (
            <div style={{ padding: 36, textAlign: 'center', color: MUT, fontSize: 14 }}>
              {s.repStatus === 'open' && s.repSev === 'ALL'
                ? 'Queue is clear.'
                : 'No reports match these filters.'}
            </div>
          )}
          {s.repStatus === 'open' && s.openMore && (
            <button type="button" onClick={loadMore} style={{ ...btnSecondary, margin: 4 }}>
              Load more
            </button>
          )}
        </div>

        {rep && (
          <div style={{ ...card, padding: 20, gap: 16, position: 'sticky', top: 20 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
              <span style={pill(SEV[severity(rep)].bg, SEV[severity(rep)].fg, '3px 9px')}>
                {severity(rep)}
              </span>
              <span style={{ font: mono(400, 11), color: MUT }}>
                {rep.listingId ? 'Listing' : 'Profile'} · {ago(rep.createdAt)}
              </span>
              <span style={{ flex: 1 }} />
              <span style={{ font: mono(700, 11), color: stFg(rep) }}>{stLabel(rep)}</span>
            </div>
            <div style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 28, lineHeight: 1.05 }}>
              {REASON[rep.reason]}
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
              <div style={{ ...label, letterSpacing: '.04em' }}>WHAT THE REPORTER WROTE</div>
              <div style={{ fontSize: 15, lineHeight: 1.45, textWrap: 'pretty' }}>
                {rep.details ? `“${rep.details}”` : <span style={{ color: MUT }}>No details.</span>}
              </div>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
              {(
                [
                  ['REPORTED USER', rep.target],
                  ['REPORTED BY', rep.reporter],
                ] as const
              ).map(([title, u]) => (
                <div
                  key={title}
                  onClick={() => set({ userSel: u.id })}
                  style={{
                    border: `1px solid ${LINE}`,
                    borderRadius: 16,
                    padding: 12,
                    cursor: 'pointer',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: 6,
                    minWidth: 0,
                  }}
                >
                  <div style={label}>{title}</div>
                  <div
                    style={{
                      fontWeight: 700,
                      fontSize: 15,
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    }}
                  >
                    @{u.username}
                  </div>
                  <div style={{ fontSize: 12, color: MUT }}>
                    {STATE_LABEL[u.state]} · {u.openReports} open reports
                  </div>
                </div>
              ))}
            </div>
            {rep.status === 'open' ? (
              <>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                  <div style={label}>NOTE · KEPT IN THE AUDIT LOG; THE BAN REASON WHEN BANNING</div>
                  <textarea
                    rows={2}
                    maxLength={500}
                    placeholder="Visible to admins only"
                    value={notes[rep.id] ?? ''}
                    onChange={(e) => setNotes((n) => ({ ...n, [rep.id]: e.target.value }))}
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
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                  {rep.listingId && (
                    <button
                      type="button"
                      disabled={busy}
                      onClick={() => resolve(rep, 'remove_listing')}
                      style={btnPrimary}
                    >
                      Remove listing
                    </button>
                  )}
                  <button
                    type="button"
                    disabled={busy}
                    onClick={() => resolve(rep, 'warn')}
                    style={btnSecondary}
                  >
                    Warn user
                  </button>
                  <button
                    type="button"
                    disabled={busy}
                    onClick={() => resolve(rep, 'ban')}
                    style={rep.listingId ? btnSecondary : btnPrimary}
                  >
                    Ban user
                  </button>
                  <button
                    type="button"
                    disabled={busy}
                    onClick={() => resolve(rep, 'dismiss')}
                    style={{ ...btnSecondary, background: 'transparent', color: MUT }}
                  >
                    Dismiss
                  </button>
                </div>
              </>
            ) : (
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 4,
                  border: `1px solid ${LINE}`,
                  borderRadius: 14,
                  padding: '10px 12px',
                  font: grot(500, 14),
                }}
              >
                <span>
                  {stLabel(rep) === 'DISMISSED' ? 'Dismissed' : 'Actioned'}
                  {rep.resolvedAt ? ` ${ago(rep.resolvedAt)}` : ''}
                </span>
                {rep.resolutionNote && (
                  <span style={{ color: MUT, fontSize: 13 }}>{rep.resolutionNote}</span>
                )}
              </div>
            )}
          </div>
        )}
      </div>
    </>
  );
}
