import { useEffect, useState } from 'react';
import {
  api,
  ApiError,
  query,
  type AccountState,
  type AdminUser,
  type AdminUserPage,
  type AgeRange,
  type UserRole,
} from '../api';
import { Icon } from '../icons';
import { shortDate, STATE_LABEL } from '../data';
import type { Admin, UserFilter } from '../state';
import {
  Chip,
  ConfirmModal,
  ErrorBox,
  Field,
  Modal,
  Pagination,
  SearchBox,
  Table,
  btnPrimary,
  btnSecondary,
  btnSmall,
  input,
  type Col,
} from '../ui';
import { DANGER, MUT, ST, mono, pad2, pill } from '../tokens';

const PAGE_SIZE = 20;
const FILTERS: UserFilter[] = ['All', 'Active', 'Banned', 'Deleted'];
const AGES: [AgeRange, string][] = [
  ['16_17', '16 to 17'],
  ['18_24', '18 to 24'],
  ['25_34', '25 to 34'],
  ['35_plus', '35 and over'],
];
const message = (e: unknown) =>
  e instanceof ApiError ? e.message : 'Something went wrong. Try again.';

type ModalState =
  { kind: 'form'; user: AdminUser | null } | { kind: 'delete'; user: AdminUser } | null;

export function Users({ admin }: { admin: Admin }) {
  const { s, set, toast } = admin;
  const [data, setData] = useState<AdminUserPage | null>(null);
  const [loaded, setLoaded] = useState('');
  const [err, setErr] = useState<string | null>(null);
  const [tries, setTries] = useState(0);
  const [q, setQ] = useState(s.userQ);
  const [modal, setModal] = useState<ModalState>(null);
  const [busy, setBusy] = useState(false);
  const [delErr, setDelErr] = useState<string | null>(null);

  // Search as you type, a beat after the last key; back to page 1.
  useEffect(() => {
    const t = setTimeout(() => {
      const next = q.trim();
      set((st) => (st.userQ === next ? {} : { userQ: next, userPage: 1 }));
    }, 250);
    return () => clearTimeout(t);
  }, [q, set]);

  // The key says which request the shown data answers; unequal means a load is under way.
  const state = s.userF === 'All' ? undefined : (s.userF.toLowerCase() as AccountState);
  const path = `admin/users${query({ query: s.userQ, state, page: s.userPage, pageSize: PAGE_SIZE })}`;
  const key = `${path}#${tries}`;
  useEffect(() => {
    let stale = false;
    api<AdminUserPage>(path)
      .then((p) => {
        if (stale) return;
        // Deleting the last row of a page lands on the previous one.
        if (!p.items.length && s.userPage > 1) set({ userPage: s.userPage - 1 });
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
  }, [path, key, s.userPage, set]);
  const loading = loaded !== key;

  const reload = () => setTries((t) => t + 1);

  const remove = async (u: AdminUser) => {
    setBusy(true);
    setDelErr(null);
    try {
      await api(`admin/users/${u.id}`, { method: 'DELETE' });
      setModal(null);
      toast(`${u.displayName} deleted`);
      reload();
    } catch (e) {
      setDelErr(message(e));
    } finally {
      setBusy(false);
    }
  };

  const cols: Col<AdminUser>[] = [
    {
      head: 'Player',
      w: 'minmax(190px,2fr)',
      cell: (u) => (
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, minWidth: 0 }}>
          <div
            style={{
              width: 34,
              height: 34,
              borderRadius: '50%',
              background: 'var(--soft)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 800,
              flex: 'none',
            }}
          >
            {u.displayName[0]?.toUpperCase()}
          </div>
          <div style={{ minWidth: 0 }}>
            <div style={{ fontWeight: 700, overflow: 'hidden', textOverflow: 'ellipsis' }}>
              {u.displayName}
              {u.role === 'admin' && (
                <span style={{ ...pill('var(--lav)', 'var(--tx)'), marginLeft: 6 }}>Admin</span>
              )}
            </div>
            <div style={{ fontSize: 12, color: MUT, overflow: 'hidden', textOverflow: 'ellipsis' }}>
              @{u.username}
            </div>
          </div>
        </div>
      ),
    },
    { head: 'City', w: 'minmax(80px,1fr)', cell: (u) => u.city },
    { head: 'Main game', w: 'minmax(90px,1.1fr)', cell: (u) => u.mainGame ?? '—' },
    {
      head: 'Joined',
      w: '80px',
      cell: (u) => <span style={{ font: mono(600, 13) }}>{shortDate(u.createdAt)}</span>,
    },
    {
      head: 'Reports',
      w: '64px',
      cell: (u) => (
        <span style={{ font: mono(800, 13), color: u.openReports ? DANGER : MUT }}>
          {pad2(u.openReports)}
        </span>
      ),
    },
    {
      head: 'Status',
      w: '84px',
      cell: (u) => (
        <span style={pill(ST[u.state].bg, ST[u.state].fg, '4px 10px')}>{STATE_LABEL[u.state]}</span>
      ),
    },
    {
      head: 'Actions',
      w: '150px',
      cell: (u) =>
        u.state === 'deleted' ? (
          <span style={{ color: MUT, fontSize: 13 }}>—</span>
        ) : (
          <div style={{ display: 'flex', gap: 6 }} onClick={(e) => e.stopPropagation()}>
            <button
              type="button"
              style={btnSmall}
              onClick={() => setModal({ kind: 'form', user: u })}
            >
              Edit
            </button>
            <button
              type="button"
              aria-label={`Delete ${u.displayName}`}
              title="Delete"
              style={{ ...btnSmall, color: DANGER, padding: '0 10px' }}
              onClick={() => {
                setDelErr(null);
                setModal({ kind: 'delete', user: u });
              }}
            >
              <Icon name="trash" size={16} />
            </button>
          </div>
        ),
    },
  ];

  return (
    <>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
        {FILTERS.map((f) => (
          <Chip key={f} on={s.userF === f} onClick={() => set({ userF: f, userPage: 1 })}>
            {f}
          </Chip>
        ))}
        <span style={{ flex: 1 }} />
        <SearchBox value={q} onChange={setQ} placeholder="Username, name or email" />
        <button
          type="button"
          style={{ ...btnPrimary, display: 'flex', alignItems: 'center', gap: 6 }}
          onClick={() => setModal({ kind: 'form', user: null })}
        >
          <Icon name="plus" size={16} />
          Add player
        </button>
      </div>

      {err && <ErrorBox message={err} onRetry={reload} />}

      <Table
        cols={cols}
        rows={data?.items ?? []}
        rowKey={(u) => u.id}
        loading={loading}
        minWidth={860}
        selected={s.userSel}
        onRow={(u) => set({ userSel: u.id })}
        empty="No players match."
      />
      {data && (
        <Pagination
          page={data.page}
          pageSize={data.pageSize}
          total={data.total}
          onPage={(p) => set({ userPage: p })}
        />
      )}

      {modal?.kind === 'form' && (
        <UserFormModal
          user={modal.user}
          onClose={() => setModal(null)}
          onSaved={(u, created) => {
            toast(created ? `${u.displayName} added` : `${u.displayName} saved`);
            setModal(null);
            reload();
          }}
        />
      )}
      {modal?.kind === 'delete' && (
        <ConfirmModal
          title={`Delete ${modal.user.displayName}?`}
          body={
            <>@{modal.user.username} is signed out now and their account is erased in 30 days.</>
          }
          confirm="Delete player"
          busy={busy}
          error={delErr}
          onConfirm={() => remove(modal.user)}
          onClose={() => setModal(null)}
        />
      )}
    </>
  );
}

/** Add (user = null) or edit. The 409s land under the field they are about. */
function UserFormModal({
  user,
  onClose,
  onSaved,
}: {
  user: AdminUser | null;
  onClose: () => void;
  onSaved: (u: AdminUser, created: boolean) => void;
}) {
  const [displayName, setDisplayName] = useState(user?.displayName ?? '');
  const [username, setUsername] = useState(user?.username ?? '');
  const [email, setEmail] = useState(user?.email ?? '');
  const [city, setCity] = useState(user?.city ?? '');
  const [password, setPassword] = useState('');
  const [age, setAge] = useState<AgeRange>('18_24');
  const [role, setRole] = useState<UserRole>(user?.role ?? 'player');
  const [errs, setErrs] = useState<Record<string, string>>({});
  const [saving, setSaving] = useState(false);

  const save = async () => {
    const bad: Record<string, string> = {};
    if (!displayName.trim()) bad.displayName = 'Display name is required.';
    if (!username.trim()) bad.username = 'Username is required.';
    if (!/^\S+@\S+\.\S+$/.test(email.trim())) bad.email = 'Enter a valid email.';
    if (user && !city.trim()) bad.city = 'City is required.';
    if (!user && (password.length < 8 || password.length > 72))
      bad.password = 'Password is 8 to 72 characters.';
    setErrs(bad);
    if (Object.keys(bad).length) return;

    setSaving(true);
    try {
      const base = {
        displayName: displayName.trim(),
        username: username.trim(),
        email: email.trim(),
        role,
      };
      const saved = user
        ? await api<AdminUser>(`admin/users/${user.id}`, {
            method: 'PATCH',
            body: { ...base, city: city.trim() },
          })
        : await api<AdminUser>('admin/users', {
            method: 'POST',
            body: { ...base, password, ageRange: age },
          });
      onSaved(saved, !user);
    } catch (e) {
      const field: Record<string, string> = {
        email_taken: 'email',
        username_taken: 'username',
        own_role: 'role',
      };
      const code = e instanceof ApiError ? e.code : '';
      setErrs({ [field[code] ?? 'form']: message(e) });
      setSaving(false);
    }
  };

  return (
    <Modal
      title={user ? `Edit ${user.displayName}` : 'Add player'}
      onClose={onClose}
      footer={
        <>
          <button type="button" onClick={onClose} style={btnSecondary}>
            Cancel
          </button>
          <button type="button" disabled={saving} onClick={save} style={btnPrimary}>
            {saving ? 'Saving…' : user ? 'Save changes' : 'Add player'}
          </button>
        </>
      }
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Field label="Display name" error={errs.displayName}>
          <input
            value={displayName}
            maxLength={30}
            onChange={(e) => setDisplayName(e.target.value)}
            style={input}
          />
        </Field>
        <Field label="Username" error={errs.username}>
          <input value={username} onChange={(e) => setUsername(e.target.value)} style={input} />
        </Field>
        <Field label="Email" error={errs.email}>
          <input
            type="email"
            value={email}
            maxLength={254}
            onChange={(e) => setEmail(e.target.value)}
            style={input}
          />
        </Field>
        {user ? (
          <Field label="City" error={errs.city}>
            <input
              value={city}
              maxLength={60}
              onChange={(e) => setCity(e.target.value)}
              style={input}
            />
          </Field>
        ) : (
          <>
            <Field
              label="Password"
              error={errs.password}
              hint="They can change it after signing in."
            >
              <input
                type="password"
                autoComplete="new-password"
                value={password}
                maxLength={72}
                onChange={(e) => setPassword(e.target.value)}
                style={input}
              />
            </Field>
            <Field label="Age range">
              <select
                value={age}
                onChange={(e) => setAge(e.target.value as AgeRange)}
                style={input}
              >
                {AGES.map(([v, l]) => (
                  <option key={v} value={v}>
                    {l}
                  </option>
                ))}
              </select>
            </Field>
          </>
        )}
        <Field label="Role" error={errs.role}>
          <select value={role} onChange={(e) => setRole(e.target.value as UserRole)} style={input}>
            <option value="player">Player</option>
            <option value="admin">Admin</option>
          </select>
        </Field>
        {errs.form && (
          <div role="alert" style={{ fontSize: 13, fontWeight: 600, color: DANGER }}>
            {errs.form}
          </div>
        )}
      </div>
    </Modal>
  );
}
