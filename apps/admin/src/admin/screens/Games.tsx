import { useEffect, useState, type CSSProperties } from 'react';
import { api, ApiError, query, type AdminGame, type AdminGamePage, type Platform } from '../api';
import { Icon } from '../icons';
import { PLATFORM, shortDate } from '../data';
import type { Admin } from '../state';
import {
  Chip,
  ConfirmModal,
  ErrorBox,
  Field,
  Modal,
  Pagination,
  SearchBox,
  Switch,
  Table,
  btnPrimary,
  btnSecondary,
  btnSmall,
  input,
  type Col,
} from '../ui';
import { C1, C2, DANGER, LINE, MUT, RULE, SUNK, label, mono, pad2 } from '../tokens';

const PAGE_SIZE = 20;
const PLATFORMS = Object.keys(PLATFORM) as Platform[];
const message = (e: unknown) =>
  e instanceof ApiError ? e.message : 'Something went wrong. Try again.';

type ModalState =
  { kind: 'form'; game: AdminGame | null } | { kind: 'delete'; game: AdminGame } | null;

export function Games({ admin }: { admin: Admin }) {
  const { toast, fail } = admin;
  const [q, setQ] = useState('');
  const [dq, setDq] = useState('');
  const [state, setState] = useState<'live' | 'deleted'>('live');
  const [page, setPage] = useState(1);
  const [data, setData] = useState<AdminGamePage | null>(null);
  const [loaded, setLoaded] = useState('');
  const [err, setErr] = useState<string | null>(null);
  const [tries, setTries] = useState(0);
  const [modal, setModal] = useState<ModalState>(null);
  const [busy, setBusy] = useState<string | null>(null);
  const [delErr, setDelErr] = useState<string | null>(null);

  // Search as you type, a beat after the last key; back to page 1.
  useEffect(() => {
    const t = setTimeout(() => {
      setDq(q.trim());
      setPage(1);
    }, 250);
    return () => clearTimeout(t);
  }, [q]);

  // The key says which request the shown data answers; unequal means a load is under way.
  const path = `admin/games${query({ query: dq, page, pageSize: PAGE_SIZE, state })}`;
  const key = `${path}#${tries}`;
  useEffect(() => {
    let stale = false;
    api<AdminGamePage>(path)
      .then((p) => {
        if (stale) return;
        // Deleting the last row of a page lands on the previous one.
        if (!p.items.length && page > 1) setPage(page - 1);
        else {
          setData(p);
          setErr(null);
          setLoaded(key);
        }
      })
      .catch((e) => {
        if (stale) return;
        setErr(message(e));
        setLoaded(key);
      });
    return () => {
      stale = true;
    };
  }, [path, key, page]);
  const loading = loaded !== key;

  const reload = () => setTries((t) => t + 1);
  /** Puts an updated game into the visible page without a refetch. */
  const replace = (g: AdminGame) =>
    setData((d) => d && { ...d, items: d.items.map((x) => (x.id === g.id ? g : x)) });

  const toggleLaunch = async (g: AdminGame) => {
    setBusy(g.id);
    try {
      const next = await api<AdminGame>(`admin/games/${g.id}`, {
        method: 'PATCH',
        body: { isLaunch: !g.isLaunch },
      });
      replace(next);
      toast(g.isLaunch ? `${g.name} is off Find Players` : `${g.name} is on Find Players`);
    } catch (e) {
      fail(e);
    } finally {
      setBusy(null);
    }
  };

  const remove = async (g: AdminGame) => {
    setBusy(g.id);
    setDelErr(null);
    try {
      await api(`admin/games/${g.id}`, { method: 'DELETE' });
      setModal(null);
      toast(`${g.name} deleted`);
      reload();
    } catch (e) {
      setDelErr(message(e));
    } finally {
      setBusy(null);
    }
  };

  const platforms = (g: AdminGame) => g.platforms.map((p) => PLATFORM[p]).join(', ');
  const ranksText = (g: AdminGame) =>
    g.hasRanks ? `${g.ranks.length} ranks` : `No ranks (${g.ranks.length} levels)`;

  const cols: Col<AdminGame>[] =
    state === 'live'
      ? [
          {
            head: 'Game',
            w: 'minmax(160px,2fr)',
            cell: (g) => (
              <>
                <div style={{ fontWeight: 700 }}>{g.name}</div>
                <div style={{ fontSize: 12, color: MUT }}>{g.id}</div>
              </>
            ),
          },
          { head: 'Code', w: '64px', cell: (g) => <b>{g.shortCode}</b> },
          { head: 'Platforms', w: 'minmax(120px,1.4fr)', cell: platforms },
          { head: 'Ranks', w: 'minmax(90px,1fr)', cell: ranksText },
          { head: 'Party', w: '56px', cell: (g) => g.maxParty },
          {
            head: 'Find Players',
            w: '92px',
            cell: (g) => (
              <Switch
                on={g.isLaunch}
                disabled={busy === g.id}
                title={`${g.name} on Find Players`}
                onChange={() => toggleLaunch(g)}
              />
            ),
          },
          { head: 'Players', w: '70px', cell: (g) => g.players },
          {
            head: 'Actions',
            w: '160px',
            cell: (g) => (
              <div style={{ display: 'flex', gap: 6 }} onClick={(e) => e.stopPropagation()}>
                <button
                  type="button"
                  style={btnSmall}
                  onClick={() => setModal({ kind: 'form', game: g })}
                >
                  Edit
                </button>
                <button
                  type="button"
                  aria-label={`Delete ${g.name}`}
                  title="Delete"
                  style={{ ...btnSmall, color: DANGER, padding: '0 10px' }}
                  onClick={() => {
                    setDelErr(null);
                    setModal({ kind: 'delete', game: g });
                  }}
                >
                  <Icon name="trash" size={16} />
                </button>
              </div>
            ),
          },
        ]
      : [
          {
            head: 'Game',
            w: 'minmax(160px,2fr)',
            cell: (g) => (
              <>
                <div style={{ fontWeight: 700 }}>{g.name}</div>
                <div style={{ fontSize: 12, color: MUT }}>{g.id}</div>
              </>
            ),
          },
          { head: 'Code', w: '64px', cell: (g) => <b>{g.shortCode}</b> },
          { head: 'Platforms', w: 'minmax(120px,1.4fr)', cell: platforms },
          { head: 'Ranks', w: 'minmax(90px,1fr)', cell: ranksText },
          {
            head: 'Deleted',
            w: '110px',
            cell: (g) => (g.deletedAt ? shortDate(g.deletedAt) : '—'),
          },
        ];

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        <Chip
          on={state === 'live'}
          onClick={() => {
            setState('live');
            setPage(1);
          }}
        >
          Live
        </Chip>
        <Chip
          on={state === 'deleted'}
          onClick={() => {
            setState('deleted');
            setPage(1);
          }}
        >
          Deleted
        </Chip>
        <span style={{ flex: 1 }} />
        <SearchBox value={q} onChange={setQ} placeholder="Name, code or id" />
        {state === 'live' && (
          <button
            type="button"
            style={{ ...btnPrimary, display: 'flex', alignItems: 'center', gap: 6 }}
            onClick={() => setModal({ kind: 'form', game: null })}
          >
            <Icon name="plus" size={16} />
            Add game
          </button>
        )}
      </div>

      {err && <ErrorBox message={err} onRetry={reload} />}
      {state === 'deleted' && (
        <div style={{ fontSize: 13, color: MUT }}>
          Deleted games are gone from players&apos; profiles and can&apos;t be edited.
        </div>
      )}

      <Table
        cols={cols}
        rows={data?.items ?? []}
        rowKey={(g) => g.id}
        loading={loading}
        minWidth={state === 'live' ? 900 : 640}
        onRow={state === 'live' ? (g) => setModal({ kind: 'form', game: g }) : undefined}
        empty={
          dq
            ? 'No games match.'
            : state === 'live'
              ? 'No games yet. Add the first one.'
              : 'No deleted games.'
        }
      />
      {data && (
        <Pagination page={data.page} pageSize={data.pageSize} total={data.total} onPage={setPage} />
      )}

      {modal?.kind === 'form' && (
        <GameFormModal
          game={modal.game}
          onClose={() => setModal(null)}
          onSaved={(g, created) => {
            toast(created ? `${g.name} added` : `${g.name} saved`);
            setModal(null);
            reload();
          }}
          onRanks={replace}
          onDelete={(g) => {
            setDelErr(null);
            setModal({ kind: 'delete', game: g });
          }}
        />
      )}
      {modal?.kind === 'delete' && (
        <ConfirmModal
          title={`Delete ${modal.game.name}?`}
          body={
            <>
              It leaves every player&apos;s profile and its live listings close
              {modal.game.liveListings || modal.game.players
                ? ` (${modal.game.players} players, ${modal.game.liveListings} live listings now)`
                : ''}
              . It moves to the Deleted tab and can&apos;t be edited.
            </>
          }
          confirm="Delete game"
          busy={busy === modal.game.id}
          error={delErr}
          onConfirm={() => remove(modal.game)}
          onClose={() => setModal(null)}
        />
      )}
    </>
  );
}

const chipStyle = (on: boolean): CSSProperties => ({
  height: 34,
  padding: '0 13px',
  borderRadius: 99,
  border: `1px solid ${on ? 'transparent' : LINE}`,
  background: on ? 'var(--accent)' : C1,
  color: on ? 'var(--on-accent)' : 'var(--tx)',
  font: '600 13px var(--font-manrope), sans-serif',
  cursor: 'pointer',
});

/** Add (game = null) or edit. The id is read-only once the game exists. */
function GameFormModal({
  game,
  onClose,
  onSaved,
  onRanks,
  onDelete,
}: {
  game: AdminGame | null;
  onClose: () => void;
  onSaved: (g: AdminGame, created: boolean) => void;
  /** A rank change came back with the updated game: keep the table row in step. */
  onRanks: (g: AdminGame) => void;
  onDelete: (g: AdminGame) => void;
}) {
  const [cur, setCur] = useState(game);
  const [id, setId] = useState(game?.id ?? '');
  const [name, setName] = useState(game?.name ?? '');
  const [code, setCode] = useState(game?.shortCode ?? '');
  const [plats, setPlats] = useState<Platform[]>(game?.platforms ?? []);
  const [hasRanks, setHasRanks] = useState(game?.hasRanks ?? true);
  const [party, setParty] = useState(String(game?.maxParty ?? 5));
  const [launch, setLaunch] = useState(game?.isLaunch ?? false);
  const [sort, setSort] = useState(game ? String(game.sort) : '');
  const [idErr, setIdErr] = useState<string | null>(null);
  const [formErr, setFormErr] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const togglePlat = (p: Platform) =>
    setPlats((l) => (l.includes(p) ? l.filter((x) => x !== p) : [...l, p]));

  const save = async () => {
    setIdErr(null);
    setFormErr(null);
    const maxParty = Number(party);
    if (!game && !/^[a-z0-9]{2,20}$/.test(id)) {
      setIdErr('2 to 20 lowercase letters or digits.');
      return;
    }
    if (!name.trim() || !code.trim()) return setFormErr('Name and short code are required.');
    if (!plats.length) return setFormErr('Pick at least one platform.');
    if (!Number.isInteger(maxParty) || maxParty < 2 || maxParty > 10)
      return setFormErr('Max party is a number from 2 to 10.');
    if (sort.trim() && !(Number(sort) >= 0 && Number(sort) <= 999))
      return setFormErr('Catalog order is a number from 0 to 999.');

    const body = {
      name: name.trim(),
      shortCode: code.trim(),
      platforms: plats,
      hasRanks,
      maxParty,
      isLaunch: launch,
      ...(sort.trim() ? { sort: Number(sort) } : {}),
    };
    setSaving(true);
    try {
      const saved = game
        ? await api<AdminGame>(`admin/games/${game.id}`, { method: 'PATCH', body })
        : await api<AdminGame>('admin/games', { method: 'POST', body: { id, ...body } });
      onSaved(saved, !game);
    } catch (e) {
      if (e instanceof ApiError && e.code === 'game_exists') setIdErr(e.message);
      else setFormErr(message(e));
      setSaving(false);
    }
  };

  return (
    <Modal
      title={game ? `Edit ${game.name}` : 'Add game'}
      onClose={onClose}
      width={600}
      footer={
        <>
          {game && (
            <button
              type="button"
              onClick={() => onDelete(cur ?? game)}
              style={{ ...btnSecondary, color: DANGER, marginRight: 'auto' }}
            >
              Delete game
            </button>
          )}
          <button type="button" onClick={onClose} style={btnSecondary}>
            Cancel
          </button>
          <button type="button" disabled={saving} onClick={save} style={btnPrimary}>
            {saving ? 'Saving…' : game ? 'Save changes' : 'Add game'}
          </button>
        </>
      }
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit,minmax(200px,1fr))',
            gap: 12,
          }}
        >
          <Field
            label="Id"
            error={idErr}
            hint={game ? 'Can’t change later.' : 'Lowercase letters or digits, e.g. val.'}
          >
            <input
              value={id}
              readOnly={!!game}
              maxLength={20}
              onChange={(e) => setId(e.target.value.toLowerCase())}
              style={{ ...input, opacity: game ? 0.7 : 1 }}
            />
          </Field>
          <Field label="Short code" hint="Tile label, e.g. VAL.">
            <input
              value={code}
              maxLength={6}
              onChange={(e) => setCode(e.target.value)}
              style={input}
            />
          </Field>
        </div>
        <Field label="Name">
          <input
            value={name}
            maxLength={60}
            onChange={(e) => setName(e.target.value)}
            style={input}
          />
        </Field>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <span style={label}>Platforms</span>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {PLATFORMS.map((p) => (
              <button
                key={p}
                type="button"
                aria-pressed={plats.includes(p)}
                onClick={() => togglePlat(p)}
                style={chipStyle(plats.includes(p))}
              >
                {PLATFORM[p]}
              </button>
            ))}
          </div>
        </div>
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit,minmax(160px,1fr))',
            gap: 12,
          }}
        >
          <Field label="Max party" hint="Largest party a listing can ask for, 2 to 10.">
            <input
              type="number"
              min={2}
              max={10}
              value={party}
              onChange={(e) => setParty(e.target.value)}
              style={input}
            />
          </Field>
          <Field label="Catalog order" hint="Lowest first. Optional.">
            <input
              type="number"
              min={0}
              max={999}
              value={sort}
              onChange={(e) => setSort(e.target.value)}
              style={input}
            />
          </Field>
        </div>
        <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <Switch on={hasRanks} onChange={setHasRanks} title="Has ranks" />
            <span style={{ fontSize: 14, fontWeight: 600 }}>Has ranks</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <Switch on={launch} onChange={setLaunch} title="On Find Players" />
            <span style={{ fontSize: 14, fontWeight: 600 }}>On Find Players</span>
          </div>
        </div>
        {formErr && (
          <div role="alert" style={{ fontSize: 13, fontWeight: 600, color: DANGER }}>
            {formErr}
          </div>
        )}
        {cur && (
          <Ranks
            game={cur}
            onChange={(g) => {
              setCur(g);
              onRanks(g);
            }}
          />
        )}
        {!cur && (
          <div style={{ fontSize: 13, color: MUT }}>Ranks can be added once the game exists.</div>
        )}
      </div>
    </Modal>
  );
}

/** A game's rank ladder, lowest first: add, rename, move (tier swap), delete. */
function Ranks({ game, onChange }: { game: AdminGame; onChange: (g: AdminGame) => void }) {
  const [newName, setNewName] = useState('');
  const [editing, setEditing] = useState<{ id: string; name: string } | null>(null);
  const [del, setDel] = useState<AdminGame['ranks'][number] | null>(null);
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  /** One rank call; the API answers with the whole updated game. */
  const run = async (path: string, init: { method: string; body?: unknown }) => {
    setBusy(true);
    setErr(null);
    try {
      onChange(await api<AdminGame>(`admin/games/${game.id}/ranks${path}`, init));
      return true;
    } catch (e) {
      setErr(message(e));
      return false;
    } finally {
      setBusy(false);
    }
  };

  if (!game.hasRanks)
    return (
      <div style={{ ...rankBox, padding: 14, fontSize: 13, color: MUT }}>
        This game has no ranks; players pick a play-style level instead. Turn on &ldquo;Has
        ranks&rdquo; and save to manage a rank ladder.
      </div>
    );

  const { ranks } = game;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <span style={label}>Ranks, lowest first</span>
        <span style={label}>{pad2(ranks.length)}</span>
      </div>
      <div style={rankBox}>
        {ranks.map((r, i) => (
          <div
            key={r.id}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              padding: '8px 12px',
              borderTop: i ? `1px solid ${RULE}` : 'none',
            }}
          >
            <span style={{ font: mono(700, 12), color: MUT, width: 22 }}>{pad2(i + 1)}</span>
            {editing?.id === r.id ? (
              <form
                style={{ flex: 1, display: 'flex', gap: 6, minWidth: 0 }}
                onSubmit={async (e) => {
                  e.preventDefault();
                  const name = editing.name.trim();
                  if (!name) return;
                  if (
                    name === r.name ||
                    (await run(`/${r.id}`, { method: 'PATCH', body: { name } }))
                  )
                    setEditing(null);
                }}
              >
                <input
                  autoFocus
                  aria-label="Rank name"
                  maxLength={30}
                  value={editing.name}
                  onChange={(e) => setEditing({ id: r.id, name: e.target.value })}
                  style={{ ...input, height: 34, minWidth: 0 }}
                />
                <button type="submit" disabled={busy} style={btnSmall}>
                  Save
                </button>
                <button type="button" onClick={() => setEditing(null)} style={btnSmall}>
                  Cancel
                </button>
              </form>
            ) : (
              <>
                <span style={{ flex: 1, fontWeight: 700, fontSize: 14, minWidth: 0 }}>
                  {r.name}
                </span>
                <button
                  type="button"
                  aria-label={`Move ${r.name} up`}
                  title="Move up"
                  disabled={busy || !i}
                  onClick={() =>
                    run(`/${r.id}`, { method: 'PATCH', body: { tier: ranks[i - 1]!.tier } })
                  }
                  style={iconBtn}
                >
                  <Icon name="up" size={15} />
                </button>
                <button
                  type="button"
                  aria-label={`Move ${r.name} down`}
                  title="Move down"
                  disabled={busy || i === ranks.length - 1}
                  onClick={() =>
                    run(`/${r.id}`, { method: 'PATCH', body: { tier: ranks[i + 1]!.tier } })
                  }
                  style={iconBtn}
                >
                  <Icon name="down" size={15} />
                </button>
                <button
                  type="button"
                  aria-label={`Rename ${r.name}`}
                  title="Rename"
                  onClick={() => setEditing({ id: r.id, name: r.name })}
                  style={iconBtn}
                >
                  <Icon name="edit" size={15} />
                </button>
                <button
                  type="button"
                  aria-label={`Delete ${r.name}`}
                  title="Delete"
                  onClick={() => {
                    setErr(null);
                    setDel(r);
                  }}
                  style={{ ...iconBtn, color: DANGER }}
                >
                  <Icon name="trash" size={15} />
                </button>
              </>
            )}
          </div>
        ))}
        {!ranks.length && (
          <div style={{ padding: 14, fontSize: 13, color: MUT }}>No ranks yet.</div>
        )}
      </div>
      <form
        style={{ display: 'flex', gap: 8 }}
        onSubmit={async (e) => {
          e.preventDefault();
          const name = newName.trim();
          if (name && (await run('', { method: 'POST', body: { name } }))) setNewName('');
        }}
      >
        <input
          aria-label="New rank name"
          placeholder="New rank, added at the top"
          maxLength={30}
          value={newName}
          onChange={(e) => setNewName(e.target.value)}
          style={{ ...input, height: 38 }}
        />
        <button
          type="submit"
          disabled={busy || !newName.trim()}
          style={{ ...btnPrimary, height: 38 }}
        >
          Add
        </button>
      </form>
      {err && !del && (
        <div role="alert" style={{ fontSize: 13, fontWeight: 600, color: DANGER }}>
          {err}
        </div>
      )}
      {del && (
        <ConfirmModal
          title={`Delete ${del.name}?`}
          body="Players with this rank keep the game without a rank."
          confirm="Delete rank"
          busy={busy}
          error={err}
          onConfirm={async () => {
            if (await run(`/${del.id}`, { method: 'DELETE' })) setDel(null);
          }}
          onClose={() => setDel(null)}
        />
      )}
    </div>
  );
}

const rankBox: CSSProperties = {
  border: `1px solid ${LINE}`,
  borderRadius: 16,
  background: SUNK,
  overflow: 'hidden',
};

const iconBtn: CSSProperties = {
  width: 30,
  height: 30,
  borderRadius: '50%',
  border: `1px solid ${LINE}`,
  background: C2,
  color: 'var(--tx)',
  cursor: 'pointer',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  padding: 0,
  flex: 'none',
};
