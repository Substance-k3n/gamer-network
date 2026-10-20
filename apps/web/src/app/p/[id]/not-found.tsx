import { Brand, Footer } from '../../brand';

/** A post that was deleted, removed or isn't public (the root page talks about listings). */
export default function PostNotFound() {
  return (
    <main className="page">
      <Brand />
      <div className="card">
        <p className="game">Not here.</p>
        <p className="note">
          This post doesn&apos;t exist anymore, or the link is wrong. Open the app to see what
          players are talking about right now.
        </p>
      </div>
      <Footer />
    </main>
  );
}
