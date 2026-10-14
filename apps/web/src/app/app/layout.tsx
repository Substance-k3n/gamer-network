import type { Metadata, Viewport } from 'next';
import { Manrope, Outfit, Plus_Jakarta_Sans, Silkscreen } from 'next/font/google';
import localFont from 'next/font/local';
import { BRAND } from '@/lib/config';
import { Shell } from './_lib/shell';
import './app.css';

// Inked (the default skin) loads up front; the other skins' fonts only
// when picked. Doto, Space Grotesk and Space Mono come from the root layout.
const outfit = Outfit({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-outfit',
});
const silkscreen = Silkscreen({
  subsets: ['latin'],
  weight: ['400'],
  variable: '--font-silkscreen',
});
const dseg = localFont({
  src: './_fonts/DSEG7Classic-Bold.ttf',
  variable: '--font-dseg',
  display: 'swap',
});
const manrope = Manrope({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-manrope',
  preload: false,
});
const jakarta = Plus_Jakarta_Sans({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-jakarta',
  preload: false,
});

export const metadata: Metadata = {
  title: { absolute: `${BRAND}.` },
  description: 'Find gamers in Ethiopia to actually play with.',
  appleWebApp: { capable: true, title: `${BRAND}.`, statusBarStyle: 'default' },
  robots: { index: false },
};

export const viewport: Viewport = {
  themeColor: '#E9E6E0',
  width: 'device-width',
  initialScale: 1,
  viewportFit: 'cover',
};

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div
      className={`${outfit.variable} ${silkscreen.variable} ${dseg.variable} ${manrope.variable} ${jakarta.variable}`}
    >
      <Shell>{children}</Shell>
    </div>
  );
}
