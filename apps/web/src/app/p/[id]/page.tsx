import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import { getPublicPost, type PublicPost } from '@/lib/api';
import { BRAND, config } from '@/lib/config';
import { Brand, Footer } from '../../brand';

type Props = { params: Promise<{ id: string }> };

const kindLabel = (p: PublicPost) => p.type.replace(/_/g, ' ');
const titleOf = (p: PublicPost) => `${p.author.displayName}${p.game ? ` · ${p.game.name}` : ''}`;

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const post = await getPublicPost((await params).id);
  if (!post) return { title: 'Post not found', robots: { index: false } };
  const title = titleOf(post);
  const description = post.text.length > 200 ? `${post.text.slice(0, 197)}…` : post.text;
  return {
    title,
    description,
    robots: { index: false },
    openGraph: { title, description, siteName: BRAND, type: 'article', url: `/p/${post.id}` },
    twitter: { card: 'summary', title, description },
  };
}

/** The share page for a post (docs/FEED_AND_GROUPS_API.md): text only, no sign-in. */
export default async function PostPage({ params }: Props) {
  const post = await getPublicPost((await params).id);
  if (!post) notFound();
  return (
    <main className="page">
      <Brand />
      <article className="card">
        <span className="label">{kindLabel(post)}</span>
        <div className="host">
          {post.author.avatarUrl ? (
            // eslint-disable-next-line @next/next/no-img-element -- storage URL, not optimised
            <img className="avatar" src={post.author.avatarUrl} alt="" />
          ) : (
            <span className="avatar" aria-hidden>
              {post.author.displayName.slice(0, 1).toUpperCase()}
            </span>
          )}
          <div>
            <strong>{post.author.displayName}</strong>
            <div className="muted">
              @{post.author.username}
              {post.game ? ` · ${post.game.name}` : ''}
            </div>
          </div>
        </div>
        <p className="note" style={{ whiteSpace: 'pre-wrap' }}>
          {post.text}
          {post.text.length >= 300 ? '…' : ''}
        </p>
        <div className="actions">
          <a className="button primary" href={`/app/posts/${post.id}`}>
            Open in the web app
          </a>
          {config.playStoreUrl ? (
            <a className="button" href={config.playStoreUrl}>
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
