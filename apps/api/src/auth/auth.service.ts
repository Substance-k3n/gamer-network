import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { AppError } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { authIdentities, users } from '../db/schema/index.js';
import { toMe } from '../me/me.dto.js';
import type { AuthResponse, GoogleBody, LoginBody, SignupBody } from './auth.dto.js';
import { burnPasswordCheck, hashPassword, verifyPassword } from './crypto.js';
import { EmailCodesService } from './email-codes.service.js';
import { GOOGLE_VERIFIER, type GoogleVerifier } from './google.js';
import { LoginThrottle } from './login-throttle.js';
import { type Session, SessionsService, type User } from './sessions.service.js';

const wrongCredentials = () =>
  new AppError(HttpStatus.UNAUTHORIZED, 'wrong_credentials', 'Wrong email or password.');

/** Postgres unique violation on a named constraint. */
function uniqueViolation(e: unknown): string | undefined {
  const err = e as {
    code?: string;
    constraint_name?: string;
    cause?: { code?: string; constraint_name?: string };
  };
  const c = err.cause ?? err;
  return c.code === '23505' ? c.constraint_name : undefined;
}

@Injectable()
export class AuthService {
  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(GOOGLE_VERIFIER) private readonly googleVerifier: GoogleVerifier,
    private readonly sessions: SessionsService,
    private readonly codes: EmailCodesService,
    private readonly throttle: LoginThrottle,
  ) {}

  private async issue(user: User, isNew: boolean, userAgent?: string): Promise<AuthResponse> {
    const { token } = await this.sessions.create(user.id, userAgent);
    return { token, user: toMe(user), isNew };
  }

  private async insertUser(values: typeof users.$inferInsert): Promise<User> {
    try {
      const [user] = await this.db.insert(users).values(values).returning();
      return user!;
    } catch (e) {
      const constraint = uniqueViolation(e);
      if (constraint === 'users_email_unique') {
        throw new AppError(
          HttpStatus.CONFLICT,
          'email_taken',
          'That email already has an account. Log in instead.',
          {
            email: 'already has an account',
          },
        );
      }
      if (constraint === 'users_username_unique') {
        throw new AppError(HttpStatus.CONFLICT, 'username_taken', 'That username is taken.', {
          username: 'taken',
        });
      }
      throw e;
    }
  }

  private findByEmail(email: string) {
    return this.db.query.users.findFirst({ where: eq(users.email, email) });
  }

  async signup(body: SignupBody, userAgent?: string): Promise<AuthResponse> {
    const user = await this.insertUser({
      email: body.email,
      username: body.username,
      displayName: body.displayName,
      ageRange: body.ageRange,
      passwordHash: await hashPassword(body.password),
    });
    await this.codes.send(user.email, 'verify_email');
    return this.issue(user, true, userAgent);
  }

  async login(body: LoginBody, userAgent?: string): Promise<AuthResponse> {
    const wait = this.throttle.lockedFor(body.email);
    if (wait > 0) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'rate_limited',
        `Too many wrong passwords. Try again in ${Math.ceil(wait / 60)} min, or reset your password.`,
      );
    }

    const user = await this.findByEmail(body.email);
    if (!user?.passwordHash || user.deletedAt) {
      await burnPasswordCheck(body.password);
      this.throttle.fail(body.email);
      throw wrongCredentials();
    }
    if (!(await verifyPassword(user.passwordHash, body.password))) {
      this.throttle.fail(body.email);
      throw wrongCredentials();
    }
    if (user.bannedAt)
      throw new AppError(HttpStatus.FORBIDDEN, 'banned', 'This account has been banned.');

    this.throttle.succeed(body.email);
    return this.issue(user, false, userAgent);
  }

  /**
   * Signs in, links, or creates (ADR-0007). An existing account with the
   * same email gets this Google account linked; if its email was never
   * verified, its password is cleared and its sessions revoked, so whoever
   * signed up with an email they don't own loses access.
   */
  async google(body: GoogleBody, userAgent?: string): Promise<AuthResponse> {
    const profile = await this.googleVerifier.verify(body.idToken);
    if (!profile || !profile.emailVerified) {
      throw new AppError(
        HttpStatus.UNAUTHORIZED,
        'google_token_invalid',
        "Google sign-in didn't work. Try again.",
      );
    }
    const email = profile.email.toLowerCase();

    const linked = await this.db
      .select({ user: users })
      .from(authIdentities)
      .innerJoin(users, eq(users.id, authIdentities.userId))
      .where(and(eq(authIdentities.provider, 'google'), eq(authIdentities.subject, profile.sub)));
    let user = linked[0]?.user;

    if (!user) {
      const existing = await this.findByEmail(email);
      if (existing) {
        user = await this.db.transaction(async (tx) => {
          await tx
            .insert(authIdentities)
            .values({ userId: existing.id, provider: 'google', subject: profile.sub });
          if (existing.emailVerifiedAt) return existing;
          const [updated] = await tx
            .update(users)
            .set({ emailVerifiedAt: new Date(), passwordHash: null, updatedAt: new Date() })
            .where(eq(users.id, existing.id))
            .returning();
          return updated!;
        });
        if (!existing.emailVerifiedAt) await this.sessions.revokeAll(user.id);
      }
    }

    if (user) {
      if (user.deletedAt)
        throw new AppError(HttpStatus.UNAUTHORIZED, 'account_deleted', 'This account was deleted.');
      if (user.bannedAt)
        throw new AppError(HttpStatus.FORBIDDEN, 'banned', 'This account has been banned.');
      return this.issue(user, false, userAgent);
    }

    if (!body.username || !body.ageRange) {
      const fields: Record<string, string> = {};
      if (!body.username) fields.username = 'required';
      if (!body.ageRange) fields.ageRange = 'required';
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'signup_details_required',
        'Pick a username and your age range to finish signing up.',
        fields,
      );
    }

    const created = await this.db.transaction(async (tx) => {
      const [u] = await tx
        .insert(users)
        .values({
          email,
          emailVerifiedAt: new Date(),
          username: body.username!,
          displayName: (body.displayName ?? profile.name ?? body.username!).slice(0, 30),
          ageRange: body.ageRange!,
        })
        .returning()
        .catch((e: unknown) => {
          if (uniqueViolation(e) === 'users_username_unique') {
            throw new AppError(HttpStatus.CONFLICT, 'username_taken', 'That username is taken.', {
              username: 'taken',
            });
          }
          throw e;
        });
      await tx
        .insert(authIdentities)
        .values({ userId: u!.id, provider: 'google', subject: profile.sub });
      return u!;
    });
    return this.issue(created, true, userAgent);
  }

  async verifyEmail(user: User, code: string): Promise<User> {
    if (user.emailVerifiedAt) return user;
    await this.codes.consume(user.email, 'verify_email', code);
    const [updated] = await this.db
      .update(users)
      .set({ emailVerifiedAt: new Date(), updatedAt: new Date() })
      .where(eq(users.id, user.id))
      .returning();
    return updated!;
  }

  async resendVerification(user: User) {
    if (user.emailVerifiedAt) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'already_verified',
        'Your email is already verified.',
      );
    }
    await this.codes.send(user.email, 'verify_email');
  }

  /** Always succeeds from the caller's view, so it can't reveal which emails have accounts. */
  async forgotPassword(email: string) {
    const user = await this.findByEmail(email);
    if (!user || user.deletedAt || user.bannedAt) return;
    try {
      await this.codes.send(user.email, 'reset_password');
    } catch (e) {
      if (!(e instanceof AppError && e.code === 'rate_limited')) throw e;
    }
  }

  /** Sets the password, verifies the email and signs out every other device. */
  async resetPassword(email: string, code: string, newPassword: string, userAgent?: string) {
    const user = await this.findByEmail(email);
    if (!user || user.deletedAt) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'invalid_code',
        "That code didn't work. Check it, or ask for a new one.",
        {
          code: 'wrong or expired',
        },
      );
    }
    await this.codes.consume(user.email, 'reset_password', code);
    const [updated] = await this.db
      .update(users)
      .set({
        passwordHash: await hashPassword(newPassword),
        emailVerifiedAt: user.emailVerifiedAt ?? new Date(),
        updatedAt: new Date(),
      })
      .where(eq(users.id, user.id))
      .returning();
    await this.sessions.revokeAll(user.id);
    this.throttle.succeed(email);
    if (updated!.bannedAt)
      throw new AppError(HttpStatus.FORBIDDEN, 'banned', 'This account has been banned.');
    const { token } = await this.sessions.create(user.id, userAgent);
    return { token, user: toMe(updated!) };
  }

  async changePassword(
    user: User,
    session: Session,
    currentPassword: string | undefined,
    newPassword: string,
  ) {
    if (user.passwordHash) {
      if (!currentPassword || !(await verifyPassword(user.passwordHash, currentPassword))) {
        throw new AppError(
          HttpStatus.UNPROCESSABLE_ENTITY,
          'wrong_password',
          'Your current password is wrong.',
          {
            currentPassword: 'wrong',
          },
        );
      }
    }
    await this.db
      .update(users)
      .set({ passwordHash: await hashPassword(newPassword), updatedAt: new Date() })
      .where(eq(users.id, user.id));
    await this.sessions.revokeAll(user.id, session.id);
  }
}
