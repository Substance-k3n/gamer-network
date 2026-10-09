import { Logger } from '@nestjs/common';
import { cert, initializeApp, type App } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import { env } from '../env.js';

export const PUSHER = Symbol('PUSHER');

export interface Push {
  title: string;
  body: string;
  /** Read by the app on tap: { type, id, route }. */
  data: Record<string, string>;
}

/** Sends one push to many devices of one person. */
export interface Pusher {
  /** Returns the tokens FCM says are dead, for the caller to forget. */
  send(tokens: string[], push: Push): Promise<{ invalidTokens: string[] }>;
}

const DEAD_TOKEN = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
  'messaging/invalid-argument',
]);

export class FcmPusher implements Pusher {
  private readonly app: App;

  constructor(serviceAccount: string) {
    const json = serviceAccount.trim().startsWith('{')
      ? serviceAccount
      : Buffer.from(serviceAccount, 'base64').toString();
    this.app = initializeApp({ credential: cert(JSON.parse(json)) }, 'gamer-network');
  }

  async send(tokens: string[], push: Push) {
    if (tokens.length === 0) return { invalidTokens: [] };
    const res = await getMessaging(this.app).sendEachForMulticast({
      tokens,
      notification: { title: push.title, body: push.body },
      data: push.data,
      android: { priority: 'high' },
    });
    const invalidTokens = res.responses.flatMap((r, i) =>
      !r.success && r.error && DEAD_TOKEN.has(r.error.code) ? [tokens[i]!] : [],
    );
    return { invalidTokens };
  }
}

/** Dev without Firebase: prints pushes instead of sending them. */
export class ConsolePusher implements Pusher {
  private readonly log = new Logger('Push');

  async send(tokens: string[], push: Push) {
    this.log.log(
      `→ ${tokens.length} device(s): ${push.title} — ${push.body} ${JSON.stringify(push.data)}`,
    );
    return { invalidTokens: [] };
  }
}

export function createPusher(): Pusher {
  if (env.firebaseServiceAccount) return new FcmPusher(env.firebaseServiceAccount);
  if (env.production) throw new Error('FIREBASE_SERVICE_ACCOUNT is required in production.');
  return new ConsolePusher();
}
