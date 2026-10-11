import type { Metadata } from 'next';
import { Doto, Space_Grotesk, Space_Mono } from 'next/font/google';
import './globals.css';

const doto = Doto({ subsets: ['latin'], weight: ['500', '700', '900'], variable: '--font-doto' });
const grotesk = Space_Grotesk({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
  variable: '--font-grotesk',
});
const mono = Space_Mono({ subsets: ['latin'], weight: ['400', '700'], variable: '--font-mono' });

export const metadata: Metadata = {
  title: 'rally. admin',
  description: 'Moderation and catalog admin for rally.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${doto.variable} ${grotesk.variable} ${mono.variable}`}>
      <body>{children}</body>
    </html>
  );
}
