import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { randomBytes } from 'node:crypto';
import { App } from 'supertest/types.js';
import { AppModule } from '../src/app.module.js';
import { configureApp } from '../src/app.setup.js';
import { GOOGLE_VERIFIER, type GoogleProfile, type GoogleVerifier } from '../src/auth/google.js';
import { type Mail, MAILER, type Mailer } from '../src/mail/mailer.js';
import { type Push, PUSHER, type Pusher } from '../src/notifications/pusher.js';

/** Keeps sent mail so tests can read the codes. */
export class MemoryMailer implements Mailer {
  readonly sent: Mail[] = [];
  async send(mail: Mail) {
    this.sent.push(mail);
  }
  /** The newest 6-digit code sent to `to`. */
  lastCode(to: string): string {
    const mail = this.sent.filter((m) => m.to === to).at(-1);
    const code = mail?.subject.match(/\d{6}/)?.[0];
    if (!code) throw new Error(`no code sent to ${to}`);
    return code;
  }
}

/** Accepts tokens of the form "google:<sub>:<email>". */
export class FakeGoogle implements GoogleVerifier {
  async verify(idToken: string): Promise<GoogleProfile | null> {
    const [kind, sub, email] = idToken.split(':');
    if (kind !== 'google' || !sub || !email) return null;
    return { sub, email, emailVerified: true, name: 'Google Name' };
  }
}

/** Keeps pushes; tokens starting with "dead" are reported invalid, like FCM would. */
export class MemoryPusher implements Pusher {
  readonly sent: { tokens: string[]; push: Push }[] = [];
  async send(tokens: string[], push: Push) {
    this.sent.push({ tokens, push });
    return { invalidTokens: tokens.filter((t) => t.startsWith('dead')) };
  }
  /** Pushes that reached `token`. */
  to(token: string) {
    return this.sent.filter((s) => s.tokens.includes(token)).map((s) => s.push);
  }
}

export interface TestApp {
  app: INestApplication<App>;
  mailer: MemoryMailer;
  pusher: MemoryPusher;
}

/** The real app (same setup as main.ts) on the test database, with mail, Google and push faked. */
export async function createTestApp(): Promise<TestApp> {
  const mailer = new MemoryMailer();
  const pusher = new MemoryPusher();
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(MAILER)
    .useValue(mailer)
    .overrideProvider(GOOGLE_VERIFIER)
    .useValue(new FakeGoogle())
    .overrideProvider(PUSHER)
    .useValue(pusher)
    .compile();
  const app = moduleRef.createNestApplication<INestApplication<App>>({ logger: false });
  configureApp(app);
  await app.init();
  return { app, mailer, pusher };
}

/** Unique per run, so tests never collide with rows left from earlier runs. */
export const uniq = () => randomBytes(4).toString('hex');
