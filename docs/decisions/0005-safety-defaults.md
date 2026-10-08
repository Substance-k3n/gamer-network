# ADR-0005: Safety defaults from the first release

**Status:** Accepted (2026-10-08)

## Context

Strangers meet through the app, some of them teenagers. Google Play
requires block and report for apps where users post content.

## Decision

- 16+ only. Profiles store an age range, not a birth date.
- Block and report on every profile and listing from day one; the admin
  site can remove content and ban accounts.
- Gaming IDs are visible only to accepted connections by default.
- Ranks are self-reported until game APIs allow verification.
- Sign-in with Google or an emailed code. No phone numbers collected.

## Consequences

- Moderation is a weekly chore for both owners until the user base
  justifies more.
- Fake ranks will happen; reports and a later verification badge handle it.
