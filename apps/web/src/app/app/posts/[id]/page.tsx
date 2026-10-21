'use client';

import { useRouter } from 'next/navigation';
import { use, useEffect, useState } from 'react';
import { api, ApiError, type Post } from '../../_lib/api';
import { FeedPost } from '../../_lib/feed';
import { useApp, useLoad } from '../../_lib/store';
import { BackBtn, EmptyNote, Spinner } from '../../_lib/ui';

/**
 * One post: from an alert (`?comments=1` opens its comments, `?applications=1`
 * the applications of my recruitment post) or a share link.
 * A post that's gone or hidden (404) goes Home; its message is the toast (D14).
 */
export default function PostPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ comments?: string; applications?: string }>;
}) {
  const { id } = use(params);
  const { comments, applications } = use(searchParams);
  const router = useRouter();
  const { putPost, dropPost } = useApp();
  const [gone, setGone] = useState(false);
  const {
    data: p,
    setData,
    loaded,
  } = useLoad(
    () =>
      api<Post>(`posts/${id}`).catch((e) => {
        if (e instanceof ApiError && e.status === 404) setGone(true);
        throw e;
      }),
    [id],
  );
  useEffect(() => {
    if (gone) router.replace('/app');
  }, [gone, router]);
  return (
    <div style={{ paddingBottom: 40 }}>
      <div className="row rl-pad" style={{ gap: 12, paddingTop: 6, paddingBottom: 6 }}>
        <BackBtn href="/app" />
        <h1 style={{ margin: 0, fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>Post</h1>
      </div>
      {!p ? (
        <div className="rl-pad">
          {loaded && !gone ? (
            <EmptyNote>This post was deleted or isn’t visible to you.</EmptyNote>
          ) : (
            <Spinner />
          )}
        </div>
      ) : (
        <FeedPost
          p={p}
          onChange={(n) => {
            setData(n);
            // The same post on Home shows the change too.
            putPost(n);
          }}
          onGone={() => {
            dropPost(p.id);
            router.push('/app');
          }}
          openComments={comments === '1' || p.kind === 'discussion'}
          openApplications={applications === '1'}
        />
      )}
    </div>
  );
}
