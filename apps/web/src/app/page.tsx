import { config } from '@/lib/config';
import { Brand, Footer } from './brand';

export const dynamic = 'force-dynamic';

export default function Home() {
  const play = config.playStoreUrl;
  return (
    <main className="page">
      <Brand />
      <div className="card">
        <p className="game">Find people to actually play with.</p>
        <p className="note">
          Post what you want to play tonight, see who else is looking, and squad up. Built for
          gamers in Ethiopia.
        </p>
        <div className="actions">
          {play ? (
            <a className="button primary" href={play}>
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
