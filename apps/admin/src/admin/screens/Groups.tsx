import type { Group, GroupStatus, GroupType } from '../data';
import type { Admin } from '../state';
import { Chip } from '../ui';
import {
  ACC,
  C1,
  DK,
  DOTO,
  GST,
  LINE,
  MUT,
  PANEL,
  RING,
  SHADOW,
  TX,
  fmt,
  grot,
  label,
  mono,
  pad2,
  pill,
} from '../tokens';

const TYPES: GroupType[] = ['Game', 'City', 'Campus', 'Country'];
const stat = { fontFamily: DOTO, fontWeight: 900, fontSize: 24 } as const;

export function Groups({ admin }: { admin: Admin }) {
  const { s, set, go, toast } = admin;
  const pending = s.groups.filter((g) => g.status === 'Pending').length;
  const list = s.groups.filter((g) => s.groupF === 'All' || g.status === s.groupF);

  const setStatus = (id: string, status: GroupStatus, msg: string) => {
    set((st) => ({ groups: st.groups.map((g) => (g.id === id ? { ...g, status } : g)) }));
    toast(msg);
  };
  const drop = (g: Group, msg: string) => {
    set((st) => ({ groups: st.groups.filter((x) => x.id !== g.id) }));
    toast(msg);
  };
  const actions = (g: Group): [string, () => void, string, () => void] =>
    g.status === 'Pending'
      ? [
          'Approve',
          () => setStatus(g.id, 'Live', `${g.name} approved`),
          'Reject',
          () => drop(g, `${g.name} rejected`),
        ]
      : g.status === 'Live'
        ? [
            'Pause',
            () => setStatus(g.id, 'Paused', `${g.name} paused`),
            'View reports',
            () => go('reports'),
          ]
        : [
            'Resume',
            () => setStatus(g.id, 'Live', `${g.name} is live again`),
            'Archive',
            () => drop(g, `${g.name} archived`),
          ];

  const create = () => {
    const nm = s.gDraft.name.trim();
    if (!nm) {
      toast('Name the group first');
      return;
    }
    const short = nm
      .replace(/[^A-Za-z0-9 ]/g, '')
      .split(' ')
      .map((w) => w[0])
      .join('')
      .slice(0, 3)
      .toUpperCase();
    const g: Group = {
      id: `g${Date.now()}`,
      name: nm,
      short,
      type: s.gDraft.type,
      owner: 'rally.admin',
      members: 0,
      posts: 0,
      reports: 0,
      status: 'Live',
    };
    set((st) => ({ groups: [g, ...st.groups], gDraft: { name: '', type: 'Game' }, groupF: 'All' }));
    toast(`${nm} created`);
  };

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {['All', 'Pending', 'Live', 'Paused'].map((f) => (
          <Chip key={f} on={s.groupF === f} onClick={() => set({ groupF: f })}>
            {f === 'Pending' ? `Pending (${pending})` : f}
          </Chip>
        ))}
        <span style={{ flex: 1 }} />
        <span style={{ font: mono(400, 11), color: MUT }}>
          GROUPS ARE “COMING SOON” IN THE APP — ONLY LIVE ONES ARE VISIBLE TO PLAYERS
        </span>
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fill,minmax(270px,1fr))',
          gap: 14,
        }}
      >
        <div
          style={{
            background: C1,
            borderRadius: 22,
            boxShadow: RING,
            padding: 16,
            display: 'flex',
            flexDirection: 'column',
            gap: 10,
          }}
        >
          <div style={{ fontFamily: DOTO, fontWeight: 900, fontSize: 22 }}>New group</div>
          <input
            value={s.gDraft.name}
            onChange={(e) => {
              const v = e.target.value;
              set((st) => ({ gDraft: { ...st.gDraft, name: v } }));
            }}
            placeholder="e.g. AAU Gamers"
            style={{
              height: 42,
              borderRadius: 12,
              border: `1px solid ${LINE}`,
              background: PANEL,
              color: TX,
              padding: '0 14px',
              fontSize: 14,
              outline: 'none',
            }}
          />
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {TYPES.map((t) => (
              <Chip
                key={t}
                on={s.gDraft.type === t}
                height={32}
                size={13}
                padX={12}
                onClick={() => set((st) => ({ gDraft: { ...st.gDraft, type: t } }))}
              >
                {t}
              </Chip>
            ))}
          </div>
          <button
            type="button"
            onClick={create}
            style={{
              height: 42,
              borderRadius: 99,
              border: 'none',
              background: ACC,
              color: DK,
              font: grot(700, 14),
              cursor: 'pointer',
              marginTop: 'auto',
            }}
          >
            Create &amp; publish
          </button>
        </div>

        {list.map((g) => {
          const [pLabel, primary, sLabel, secondary] = actions(g);
          const prim = g.status !== 'Live';
          return (
            <div
              key={g.id}
              style={{
                background: C1,
                border: `1px solid ${LINE}`,
                borderRadius: 22,
                boxShadow: SHADOW,
                padding: 16,
                display: 'flex',
                flexDirection: 'column',
                gap: 12,
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div
                  style={{
                    width: 46,
                    height: 46,
                    borderRadius: 14,
                    background: '#232323',
                    border: '1px solid #3A3A3A',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    font: mono(700, 12),
                    flex: 'none',
                  }}
                >
                  {g.short}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontWeight: 700, fontSize: 15 }}>{g.name}</div>
                  <div style={{ fontSize: 12, color: MUT }}>
                    {g.type} · owner @{g.owner}
                  </div>
                </div>
                <span style={{ ...pill(GST[g.status].bg, GST[g.status].fg), flex: 'none' }}>
                  {g.status.toUpperCase()}
                </span>
              </div>
              <div style={{ display: 'flex', gap: 16 }}>
                <div>
                  <div style={stat}>{fmt(g.members)}</div>
                  <div style={label}>MEMBERS</div>
                </div>
                <div>
                  <div style={stat}>{pad2(g.posts)}</div>
                  <div style={label}>POSTS / WK</div>
                </div>
                <div>
                  <div style={{ ...stat, color: g.reports ? ACC : TX }}>{pad2(g.reports)}</div>
                  <div style={label}>REPORTS</div>
                </div>
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button
                  type="button"
                  onClick={primary}
                  style={{
                    whiteSpace: 'nowrap',
                    flex: 1,
                    height: 38,
                    borderRadius: 99,
                    border: prim ? 'none' : `1px solid ${LINE}`,
                    background: prim ? ACC : '#232323',
                    color: prim ? DK : TX,
                    font: grot(700, 13),
                    cursor: 'pointer',
                  }}
                >
                  {pLabel}
                </button>
                <button
                  type="button"
                  onClick={secondary}
                  style={{
                    whiteSpace: 'nowrap',
                    flex: 'none',
                    height: 38,
                    padding: '0 14px',
                    borderRadius: 99,
                    border: `1px solid ${LINE}`,
                    background: 'transparent',
                    color: MUT,
                    font: grot(600, 13),
                    cursor: 'pointer',
                  }}
                >
                  {sLabel}
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}
