import type { Metadata } from 'next';
import { BRAND, config } from '@/lib/config';
import { Brand, Footer } from '../brand';

export const metadata: Metadata = { title: 'Privacy policy' };
export const dynamic = 'force-dynamic';

const UPDATED = '10 October 2026';

// Keep in step with docs/DATA_MODEL.md: if the app starts storing
// something new, it goes here before it ships (Play data safety form too).
export default function Privacy() {
  const contact = config.contactEmail;
  return (
    <main className="page prose">
      <Brand />
      <h1>Privacy policy</h1>
      <p className="muted">Last updated {UPDATED}</p>

      <p>
        {BRAND} helps gamers in Ethiopia find people to play with. This page says what we keep about
        you, why, who else sees it, and how to delete it. The app is for people aged 16 and over.
      </p>

      <h2>What we keep</h2>
      <ul>
        <li>
          <strong>Account:</strong> your email, and a scrambled (hashed) password if you set one. If
          you sign in with Google, we keep your Google account id and email. We never see your
          Google password.
        </li>
        <li>
          <strong>Profile:</strong> display name, username, age range (not your birth date), city,
          bio, photo, the games you play with your rank and role, your platforms, play-style tags,
          the days you usually play and your status.
        </li>
        <li>
          <strong>Gaming IDs:</strong> the in-game names or IDs you add. By default only people you
          have connected with can see them; you choose this per ID.
        </li>
        <li>
          <strong>Activity:</strong> listings you post, connection requests and play invites you
          send or answer, your connections, your answers to &ldquo;Did you play together?&rdquo;,
          and the notifications we send you.
        </li>
        <li>
          <strong>Safety:</strong> people you block and reports you file or that are filed about
          you, with what the moderators decided.
        </li>
        <li>
          <strong>Devices and sign-ins:</strong> a push notification token for each phone you use,
          the app version, and for each sign-in the device type (user agent), when it started and
          when it was last used.
        </li>
      </ul>
      <p>We do not collect phone numbers, contacts, precise location, or payment details.</p>

      <h2>Why</h2>
      <ul>
        <li>To show your profile and listings to other players and match you with them.</li>
        <li>To send you notifications and sign-in or reset codes by email.</li>
        <li>
          To keep people safe: handle reports, ban accounts that break the rules, and stop abuse
          such as spam requests.
        </li>
        <li>
          To learn whether the app works: we count how many listings end in people playing together.
          We look at these numbers in total, not to profile you.
        </li>
      </ul>
      <p>We do not sell your data and we do not show ads.</p>

      <h2>Who else sees it</h2>
      <ul>
        <li>
          <strong>Other players</strong> see your profile and live listing. They don&apos;t see your
          email. Gaming IDs follow the visibility you chose. People you block can&apos;t see you at
          all.
        </li>
        <li>
          <strong>Anyone with a share link</strong> sees that listing&apos;s game, details, note and
          your display name and photo, but not your username or gaming IDs.
        </li>
        <li>
          <strong>Our moderators</strong> see accounts and reports to handle them. Every action they
          take is logged.
        </li>
        <li>
          <strong>Services that run the app for us:</strong> our server and database host, Google
          (sign-in and push notifications through Firebase), our email provider (Resend) and our
          photo storage (Cloudflare). They only process data to provide that service to us.
        </li>
      </ul>

      <h2>Deleting your account</h2>
      <p>
        In the app, go to Settings → Delete account. Your profile disappears from the app at once,
        your live listing closes and your connections are removed. Thirty days later we erase your
        email, names, bio, photo, password, Google link, gaming IDs, games and tags. We keep reports
        and moderation records, and your &ldquo;Did you play together?&rdquo; answers without your
        personal details, for safety and our totals. You can then sign up again with the same email.
      </p>

      <h2>Contact</h2>
      <p>
        {contact ? (
          <>
            Questions or requests about your data: <a href={`mailto:${contact}`}>{contact}</a>.
          </>
        ) : (
          'A contact address for privacy questions will be listed here before launch.'
        )}
      </p>
      <p>If this policy changes, we update the date at the top and tell you in the app.</p>
      <Footer />
    </main>
  );
}
