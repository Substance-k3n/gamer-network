import { ImageResponse } from 'next/og';
import { getPublicListing } from '@/lib/api';
import { BRAND } from '@/lib/config';
import { headline, isLive, statusLine, summary } from '@/lib/listing-text';

export const size = { width: 1200, height: 630 };
export const contentType = 'image/png';
export const alt = 'A listing looking for players';

/** The picture Telegram and WhatsApp show under a shared link. */
export default async function Image({ params }: { params: Promise<{ id: string }> }) {
  const listing = await getPublicListing((await params).id);
  const live = listing ? isLive(listing) : false;

  return new ImageResponse(
    <div
      style={{
        width: '100%',
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        padding: 64,
        background: '#0c0c0c',
        color: '#ededed',
        fontSize: 32,
      }}
    >
      <div style={{ display: 'flex', fontSize: 44, fontWeight: 900 }}>
        {BRAND}
        <span style={{ color: '#ff4d2a' }}>.</span>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
        <div style={{ fontSize: 84, fontWeight: 900, lineHeight: 1.05 }}>
          {listing ? listing.game.name : 'Find people to play with'}
        </div>
        {listing && <div style={{ fontSize: 40 }}>{headline(listing)}</div>}
        {listing && <div style={{ color: '#8c8c8c' }}>{summary(listing)}</div>}
      </div>
      {listing && (
        <div style={{ display: 'flex' }}>
          <div
            style={{
              display: 'flex',
              borderRadius: 99,
              padding: '10px 24px',
              background: live ? '#ff4d2a' : '#232323',
              color: live ? '#0e0e0e' : '#8c8c8c',
              fontWeight: 700,
            }}
          >
            {statusLine(listing)}
          </div>
        </div>
      )}
    </div>,
    size,
  );
}
