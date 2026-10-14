'use client';

import { useRouter } from 'next/navigation';
import { use, useEffect } from 'react';
import { api, type Profile } from '../../_lib/api';
import { ProfileView } from '../../_lib/profile';
import { useApp, useLoad } from '../../_lib/store';
import { BackBtn, EmptyNote, Spinner } from '../../_lib/ui';

/** Someone's profile (GET /users/{username}); mine goes to You. */
export default function Player({ params }: { params: Promise<{ username: string }> }) {
  const { username } = use(params);
  const { me } = useApp();
  const router = useRouter();
  const mine = me?.username === username;
  useEffect(() => {
    if (mine) router.replace('/app/you');
  }, [mine, router]);
  const { data, loaded, reload } = useLoad(
    () => api<Profile>(`users/${encodeURIComponent(username)}`),
    [username],
  );
  if (mine) return null;
  if (!data)
    return (
      <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6 }}>
        <BackBtn />
        {loaded ? (
          <EmptyNote>This player isn’t on rally, or isn’t visible to you.</EmptyNote>
        ) : (
          <Spinner />
        )}
      </div>
    );
  return <ProfileView p={{ ...data, isMe: false }} onReload={reload} />;
}
