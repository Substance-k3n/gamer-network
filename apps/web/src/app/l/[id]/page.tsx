import type { Metadata } from 'next';
import { headers } from 'next/headers';
import { notFound } from 'next/navigation';
import { getPublicListing } from '@/lib/api';
import { BRAND, config } from '@/lib/config';
import {
  headline,
  isLive,
  partyLabel,
  platformLabel,
  statusLine,
  summary,
  whenLabel,
} from '@/lib/listing-text';
import { Brand, Footer } from '../../brand';

type Props = { params: Promise<{ id: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const listing = await getPublicListing((await params).id);
  if (!listing) return { title: 'Listing not found', robots: { index: false } };
  const title = headline(listing);
  const description = listing.note ? `${summary(listing)}. “${listing.note}”` : summary(listing);
  return {
    title,
    description,
    robots: { index: false },
    openGraph: { title, description, siteName: BRAND, type: 'website', url: `/l/${listing.id}` },
    twitter: { card: 'summary_large_image', title, description },
  };
}

/**
 * Android: an intent:// link opens the app straight to the listing, and
 * falls back to the store when it isn't installed. Elsewhere there's no
 * app yet, so only "Get the app".
 */
function openInAppHref(id: string) {
  const site = new URL(config.siteUrl);
  const fallback = config.playStoreUrl ?? `${config.siteUrl}/l/${id}`;
  return (
    `intent://${site.host}/l/${id}#Intent;scheme=${site.protocol.replace(':', '')};` +
    `package=${config.androidPackage};` +
    `S.browser_fallback_url=${encodeURIComponent(fallback)};end`
  );
}

export default async function ListingPage({ params }: Props) {
  const listing = await getPublicListing((await params).id);
  if (!listing) notFound();
  const android = /android/i.test((await headers()).get('user-agent') ?? '');
  const live = isLive(listing);

  return (
    <main className="page">
      <Brand />
      <article className="card">
        <span className="label">Looking for players</span>
        <h1 className="game">{listing.game.name}</h1>

        <div className="host">
          {listing.ownerAvatarUrl ? (
            // eslint-disable-next-line @next/next/no-img-element -- storage URL, not optimised
            <img className="avatar" src={listing.ownerAvatarUrl} alt="" />
          ) : (
            <span className="avatar" aria-hidden>
              {listing.ownerDisplayName.slice(0, 1).toUpperCase()}
            </span>
          )}
          <div>
            <strong>{listing.ownerDisplayName}</strong>
            <div className="muted">{whenLabel(listing)}</div>
          </div>
        </div>

        <div className="chips">
          {listing.mode && <span className="chip">{listing.mode.name}</span>}
          {listing.rank && <span className="chip">{listing.rank.name}</span>}
          <span className="chip">{platformLabel(listing)}</span>
          <span className="chip">{partyLabel(listing)}</span>
          <span className="chip">
            {listing.voice === 'required' ? 'Voice on' : 'Voice optional'}
          </span>
        </div>

        {listing.note && <p className="note">“{listing.note}”</p>}

        <span className={live ? 'status' : 'status ended'}>{statusLine(listing)}</span>

        <div className="actions">
          {android && live && (
            <a className="button primary" href={openInAppHref(listing.id)}>
              Open in app
            </a>
          )}
          {config.playStoreUrl ? (
            <a className={android && live ? 'button' : 'button primary'} href={config.playStoreUrl}>
              Get the app
            </a>
          ) : (
            <span className="button muted">Coming soon to Google Play</span>
          )}
        </div>
      </article>
      <Footer />
    </main>
  );
}
