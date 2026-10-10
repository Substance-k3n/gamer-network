import { Brand, Footer } from './brand';

export default function NotFound() {
  return (
    <main className="page">
      <Brand />
      <div className="card">
        <p className="game">Not here.</p>
        <p className="note">
          This listing doesn&apos;t exist anymore, or the link is wrong. Open the app to see
          who&apos;s looking to play right now.
        </p>
      </div>
      <Footer />
    </main>
  );
}
