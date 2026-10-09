import { Injectable } from '@nestjs/common';

const WINDOW_MS = 15 * 60_000;
const MAX_FAILURES = 10;

/**
 * 10 wrong passwords for one email within 15 minutes locks that email for
 * the rest of the window (docs/DATA_MODEL.md "Passwords and accounts").
 * Kept in memory: the API runs as one process on one VPS (ADR-0004), and a
 * restart only shortens a lockout. Move to Postgres if it ever scales out.
 */
@Injectable()
export class LoginThrottle {
  private readonly failures = new Map<string, number[]>();

  private recent(email: string, now: number) {
    const list = (this.failures.get(email) ?? []).filter((t) => now - t < WINDOW_MS);
    if (list.length) this.failures.set(email, list);
    else this.failures.delete(email);
    return list;
  }

  /** Seconds until the email can try again, or 0. */
  lockedFor(email: string, now = Date.now()): number {
    const list = this.recent(email.toLowerCase(), now);
    if (list.length < MAX_FAILURES) return 0;
    return Math.ceil((list[0]! + WINDOW_MS - now) / 1000);
  }

  fail(email: string, now = Date.now()) {
    const key = email.toLowerCase();
    this.failures.set(key, [...this.recent(key, now), now]);
  }

  succeed(email: string) {
    this.failures.delete(email.toLowerCase());
  }
}
