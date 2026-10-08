# ADR-0002: Players get a Flutter app, Android first; web is share pages and admin

**Status:** Accepted (2026-10-08). Supersedes the earlier plan of a
Next.js PWA for players.

## Context

Most phones in Ethiopia are Android. A social app lives on notifications
and on feeling like a real app. Listings will be shared in Telegram and
WhatsApp groups, so a link must also look good and open somewhere useful.

## Decision

- `apps/mobile`: Flutter, Android first. Google Play costs $25 once. iOS
  comes later from the same code, built in the cloud (Codemagic), when we
  pay Apple's $99/year.
- `apps/web`: one small Next.js site with two jobs: public share pages
  for listings (Open Graph preview, "Open in app / Get the app") and the
  admin dashboard behind login.
- Push via Firebase Cloud Messaging.

## Alternatives considered

- Next.js PWA for players: one codebase and instant links, but web push
  and install prompts on Android are weaker, and it feels like a website.
- Flutter and a PWA both: every screen twice, roughly half the speed.

## Consequences

- Natnael (mobile) owns only `apps/mobile` and can focus on the product.
- Releases go through Play review (usually hours); fixes are not instant.
- Telegram is a channel, never the only one: Ethiopia blocked it for
  months in 2023.
