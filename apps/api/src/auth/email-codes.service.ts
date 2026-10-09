import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gt, isNull } from 'drizzle-orm';
import { AppError } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { emailCodes } from '../db/schema/index.js';
import { MAILER, type Mailer } from '../mail/mailer.js';
import { newEmailCode, sha256 } from './crypto.js';

type Purpose = 'verify_email' | 'reset_password';

const TTL_MS = 10 * 60_000;
const MAX_ATTEMPTS = 5;
const MAX_PER_HOUR = 5;

const hashOf = (email: string, purpose: Purpose, code: string) =>
  sha256(`${purpose}:${email.toLowerCase()}:${code}`).toString('hex');

const MAIL: Record<Purpose, (code: string) => { subject: string; text: string }> = {
  verify_email: (code) => ({
    subject: `${code} is your verification code`,
    text: `Your code is ${code}. It works for 10 minutes.\n\nIf you didn't sign up, ignore this email.`,
  }),
  reset_password: (code) => ({
    subject: `${code} is your password reset code`,
    text: `Your code is ${code}. It works for 10 minutes.\n\nIf you didn't ask to reset your password, ignore this email; your password hasn't changed.`,
  }),
};

@Injectable()
export class EmailCodesService {
  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(MAILER) private readonly mailer: Mailer,
  ) {}

  /** Emails a fresh code. 429 after 5 in an hour for this email and purpose. */
  async send(email: string, purpose: Purpose) {
    const hourAgo = new Date(Date.now() - 3600_000);
    const [{ sent }] = (await this.db
      .select({ sent: count() })
      .from(emailCodes)
      .where(
        and(
          eq(emailCodes.email, email),
          eq(emailCodes.purpose, purpose),
          gt(emailCodes.createdAt, hourAgo),
        ),
      )) as [{ sent: number }];
    if (sent >= MAX_PER_HOUR) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'rate_limited',
        'We sent several codes already. Check your inbox and spam, or try again in an hour.',
      );
    }

    const code = newEmailCode();
    await this.db.insert(emailCodes).values({
      email,
      purpose,
      codeHash: hashOf(email, purpose, code),
      expiresAt: new Date(Date.now() + TTL_MS),
    });
    await this.mailer.send({ to: email, ...MAIL[purpose](code) });
  }

  /**
   * Checks the newest live code. A wrong guess counts against it; after 5
   * it stops working. Throws 422 invalid_code; the caller never learns why.
   */
  async consume(email: string, purpose: Purpose, code: string) {
    const [latest] = await this.db
      .select()
      .from(emailCodes)
      .where(
        and(
          eq(emailCodes.email, email),
          eq(emailCodes.purpose, purpose),
          isNull(emailCodes.consumedAt),
          gt(emailCodes.expiresAt, new Date()),
        ),
      )
      .orderBy(desc(emailCodes.createdAt))
      .limit(1);

    const invalid = new AppError(
      HttpStatus.UNPROCESSABLE_ENTITY,
      'invalid_code',
      "That code didn't work. Check it, or ask for a new one.",
      { code: 'wrong or expired' },
    );
    if (!latest || latest.attempts >= MAX_ATTEMPTS) throw invalid;

    if (latest.codeHash !== hashOf(email, purpose, code)) {
      await this.db
        .update(emailCodes)
        .set({ attempts: latest.attempts + 1 })
        .where(eq(emailCodes.id, latest.id));
      throw invalid;
    }
    await this.db
      .update(emailCodes)
      .set({ consumedAt: new Date() })
      .where(eq(emailCodes.id, latest.id));
  }
}
