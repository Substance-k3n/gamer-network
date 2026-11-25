import Link from 'next/link';
import { config } from '@/lib/config';
import { Brand, Footer } from './brand';

export const dynamic = 'force-dynamic';

export default function Home() {
  const play = config.playStoreUrl;
  return (
    <main className="page">
      <Brand />
      <div className="card">
        <p className="game">Find chess players to actually play with.</p>
        <p className="note">
          Post the game you want tonight, see who else is looking near your rating, and challenge
          them on Chess.com or Lichess. Built for chess players in Ethiopia.
        </p>
        <div className="actions">
          <Link className="button primary" href="/app">
            Open the web app
          </Link>
          {play ? (
            <a className="button" href={play}>
              Get the app
            </a>
          ) : (
            <span className="button muted">Coming soon to Google Play</span>
          )}
        </div>
      </div>
      <Footer />
    </main>
  );
}
