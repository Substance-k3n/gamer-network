import { hash, verify } from '@node-rs/argon2';
import { createHash, randomBytes, randomInt } from 'node:crypto';

/** Opaque bearer token handed to the client; only its sha-256 is stored. */
export const newSessionToken = () => randomBytes(32).toString('base64url');

export const sha256 = (value: string) => createHash('sha256').update(value).digest();

/** 6 digits, leading zeros kept. */
export const newEmailCode = () => randomInt(0, 1_000_000).toString().padStart(6, '0');

// argon2id with the library defaults (m=19 MiB, t=2, p=1: OWASP's minimum).
export const hashPassword = (password: string) => hash(password);

export const verifyPassword = (passwordHash: string, password: string) =>
  verify(passwordHash, password).catch(() => false);

/**
 * Checked against unknown emails so "no such account" takes as long as
 * "wrong password" and can't be told apart by timing.
 */
let dummyHash: Promise<string> | undefined;
export async function burnPasswordCheck(password: string) {
  dummyHash ??= hash('not-a-real-password');
  await verifyPassword(await dummyHash, password);
}
