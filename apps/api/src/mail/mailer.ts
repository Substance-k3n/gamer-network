import { Logger } from '@nestjs/common';
import { env } from '../env.js';

export interface Mail {
  to: string;
  subject: string;
  text: string;
}

/** Inject with `@Inject(MAILER) mailer: Mailer`. Tests swap in a memory mailer. */
export const MAILER = Symbol('MAILER');

export interface Mailer {
  send(mail: Mail): Promise<void>;
}

/** Resend's HTTP API (same provider as abro). No SDK needed. */
export class ResendMailer implements Mailer {
  constructor(
    private readonly apiKey: string,
    private readonly from: string,
  ) {}

  async send(mail: Mail) {
    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: { Authorization: `Bearer ${this.apiKey}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        from: this.from,
        to: mail.to,
        subject: mail.subject,
        text: mail.text,
      }),
    });
    if (!res.ok) throw new Error(`Resend answered ${res.status}: ${await res.text()}`);
  }
}

/** Local development without an API key: the email goes to the console. */
export class ConsoleMailer implements Mailer {
  private readonly logger = new Logger('Mail');

  async send(mail: Mail) {
    this.logger.log(`to ${mail.to} · ${mail.subject}\n${mail.text}`);
  }
}

export function createMailer(): Mailer {
  if (env.resendApiKey) return new ResendMailer(env.resendApiKey, env.mailFrom);
  if (env.production) throw new Error('RESEND_API_KEY is required in production.');
  return new ConsoleMailer();
}
