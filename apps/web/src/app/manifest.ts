import type { MetadataRoute } from 'next';
import { BRAND } from '@/lib/config';

// Installable player app (ADR-0011). Inked skin colours.
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: `${BRAND}. Find people to play with`,
    short_name: `${BRAND}.`,
    description: 'Find gamers in Ethiopia to actually play with.',
    start_url: '/app',
    scope: '/',
    display: 'standalone',
    orientation: 'portrait',
    background_color: '#E9E6E0',
    theme_color: '#E9E6E0',
    icons: [
      { src: '/icons/Icon-192.png', sizes: '192x192', type: 'image/png' },
      { src: '/icons/Icon-512.png', sizes: '512x512', type: 'image/png' },
      {
        src: '/icons/Icon-maskable-192.png',
        sizes: '192x192',
        type: 'image/png',
        purpose: 'maskable',
      },
      {
        src: '/icons/Icon-maskable-512.png',
        sizes: '512x512',
        type: 'image/png',
        purpose: 'maskable',
      },
    ],
  };
}
