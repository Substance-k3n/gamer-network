'use client';

import { use } from 'react';
import { api, type Listing } from '../../_lib/api';
import { ListingCard } from '../../_lib/cards';
import { useLoad } from '../../_lib/store';
import { BackBtn, EmptyNote, Spinner } from '../../_lib/ui';

/** One listing: from an alert, or "Open in the web app" on a share page. */
export default function ListingPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const { data: l, loaded, reload } = useLoad(() => api<Listing>(`listings/${id}`), [id]);
  return (
    <div className="gap rl-pad" style={{ gap: 14, paddingTop: 6, paddingBottom: 40 }}>
      <div className="row" style={{ gap: 12 }}>
        <BackBtn href="/app/find" />
        <h1 style={{ margin: 0, fontSize: 24, fontWeight: 800, letterSpacing: -0.8 }}>Listing</h1>
      </div>
      {!l ? (
        loaded ? (
          <EmptyNote>This listing doesn’t exist or isn’t visible to you.</EmptyNote>
        ) : (
          <Spinner />
        )
      ) : (
        <>
          {l.status !== 'open' && l.status !== 'full' && (
            <EmptyNote>This listing has {l.status === 'closed' ? 'closed' : 'ended'}.</EmptyNote>
          )}
          <ListingCard l={l} onChanged={reload} />
        </>
      )}
    </div>
  );
}
