import { OAuth2Client } from 'google-auth-library';
import { env } from '../env.js';

export interface GoogleProfile {
  sub: string;
  email: string;
  emailVerified: boolean;
  name: string | undefined;
}

/** Inject with `@Inject(GOOGLE_VERIFIER)`. Tests swap in a fake. */
export const GOOGLE_VERIFIER = Symbol('GOOGLE_VERIFIER');

export interface GoogleVerifier {
  /** Returns null when the token is invalid, expired or for another app. */
  verify(idToken: string): Promise<GoogleProfile | null>;
}

/**
 * Checks a Google ID token's signature, expiry and audience. The audience
 * is any of our OAuth client ids (Android, iOS, web/PWA).
 */
export class GoogleIdTokenVerifier implements GoogleVerifier {
  private readonly client = new OAuth2Client();

  async verify(idToken: string): Promise<GoogleProfile | null> {
    if (env.googleClientIds.length === 0) return null;
    try {
      const ticket = await this.client.verifyIdToken({ idToken, audience: env.googleClientIds });
      const p = ticket.getPayload();
      if (!p?.sub || !p.email) return null;
      return { sub: p.sub, email: p.email, emailVerified: p.email_verified === true, name: p.name };
    } catch {
      return null;
    }
  }
}
