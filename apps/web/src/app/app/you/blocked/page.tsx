'use client';

import { api, type UserCard } from '../../_lib/api';
import { toneFor } from '../../_lib/data';
import { useApp, useLoad } from '../../_lib/store';
import { Avatar, BackBtn, EmptyNote, Pill, Rows, Spinner } from '../../_lib/ui';

/** Settings → Blocked users. */
export default function Blocked() {
  const { run, toast } = useApp();
  const { data, setData, loaded } = useLoad(
    async () => (await api<{ items: UserCard[] }>('me/blocks')).items,
    [],
  );
  const unblock = async (u: UserCard) => {
    const ok = await run(() => api(`blocks/${u.id}`, { method: 'DELETE' }).then(() => true));
    if (!ok) return;
    setData((data ?? []).filter((x) => x.id !== u.id));
    toast(`${u.displayName} unblocked`);
  };
  return (
    <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6, paddingBottom: 40 }}>
      <div className="row" style={{ gap: 12 }}>
        <BackBtn href="/app/you" />
        <h1 style={{ margin: 0, fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>
          Blocked users
        </h1>
      </div>
      {!loaded ? (
        <Spinner />
      ) : !data?.length ? (
        <EmptyNote>No one is blocked.</EmptyNote>
      ) : (
        <Rows>
          {data.map((u) => (
            <div key={u.id} className="r">
              <Avatar name={u.displayName} tone={toneFor(u.id)} url={u.avatarUrl} />
              <span className="grow">
                <b style={{ display: 'block', fontSize: 15 }}>{u.displayName}</b>
                <span className="muted" style={{ fontSize: 12 }}>
                  @{u.username}
                </span>
              </span>
              <Pill h={36} padH={14} size={13} bold onClick={() => unblock(u)}>
                Unblock
              </Pill>
            </div>
          ))}
        </Rows>
      )}
    </div>
  );
}
