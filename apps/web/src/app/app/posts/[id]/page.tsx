'use client';

import { useRouter } from 'next/navigation';
import { use } from 'react';
import { api, type Post } from '../../_lib/api';
import { PostCard } from '../../_lib/feed';
import { useLoad } from '../../_lib/store';
import { BackBtn, EmptyNote, Spinner } from '../../_lib/ui';

/** One post: from an alert (`?comments=1` opens its comments) or a share link. */
export default function PostPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ comments?: string }>;
}) {
  const { id } = use(params);
  const { comments } = use(searchParams);
  const router = useRouter();
  const { data: p, setData, loaded } = useLoad(() => api<Post>(`posts/${id}`), [id]);
  return (
    <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6, paddingBottom: 40 }}>
      <div className="row" style={{ gap: 12 }}>
        <BackBtn href="/app" />
        <h1 style={{ margin: 0, fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>Post</h1>
      </div>
      {!p ? (
        loaded ? (
          <EmptyNote>This post was deleted or isn’t visible to you.</EmptyNote>
        ) : (
          <Spinner />
        )
      ) : (
        <PostCard
          p={p}
          onChange={setData}
          onGone={() => router.push('/app')}
          openComments={comments === '1' || p.kind === 'discussion'}
        />
      )}
    </div>
  );
}
