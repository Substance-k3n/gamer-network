import type { Metadata } from 'next';
import { Doto, Space_Grotesk, Space_Mono } from 'next/font/google';
import { BRAND, config } from '@/lib/config';
import './globals.css';

const doto = Doto({ subsets: ['latin'], weight: ['900'], variable: '--font-doto' });
const grotesk = Space_Grotesk({
  subsets: ['latin'],
  weight: ['400', '700'],
  variable: '--font-grotesk',
});
const mono = Space_Mono({ subsets: ['latin'], weight: ['400', '700'], variable: '--font-mono' });

export async function generateMetadata(): Promise<Metadata> {
  return {
    metadataBase: new URL(config.siteUrl),
    title: { default: `${BRAND}. Find people to play with`, template: `%s · ${BRAND}.` },
    description: 'Find gamers in Ethiopia to actually play with.',
  };
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${doto.variable} ${grotesk.variable} ${mono.variable}`}>
      <body>{children}</body>
    </html>
  );
}
