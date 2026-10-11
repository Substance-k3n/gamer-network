# ADR-0007: Sign in with email + password or Google

**Status:** Accepted (2026-10-09). Replaces the "emailed code" sign-in in
ADR-0005 and the first draft of API.md.

## Context

The mobile app already has Log in and Sign up screens with email and
password, and "Forgot password". The brief also lists "reset password".
The first API draft used one-time emailed codes instead.

## Decision

- Two ways in: **email + password**, or **Google**.
- Passwords hashed with argon2id; 8–72 characters.
- Emailed 6-digit codes are still used, but only to verify an email after
  sign-up and to reset a forgotten password.
- Listings and connection requests need a verified email, so throwaway
  sign-ups can't spam Find Players.
- Google sign-in with an email that already has an account links to it.
  If that account's email was never verified, its password is cleared,
  so someone who signed up with an email they don't own loses access.

## Alternatives considered

- **Emailed code only:** no passwords to store or reset, but it needs a
  working inbox for every sign-in, and the screens were already built.
- **Phone + SMS:** familiar in Ethiopia, but costs money per message.

## Consequences

- We store password hashes, so the database backups need the same care
  as the live database.
- Brute-force protection (lockout, rate limits) is on us.
