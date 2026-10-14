# ADR-0011: Players also get a Next.js PWA in apps/web

**Status:** Proposed (2026-10-14). Amends ADR-0002 (the Flutter app stays;
`apps/web` grows from share pages into the player PWA as well).

## Context

The Flutter app is wired to the API (#37, #39), but it only reaches
people who install an APK or, later, the Play Store build. Listings
spread as links in Telegram and WhatsApp groups; someone tapping one on a
phone without the app should land in something they can use straight
away, not a store page.

We measured both ways of putting the player app on the web, cold load on
a mid-range phone (Chromium, CPU throttled 4×):

| Network               | Flutter web build (`flutter build web`) | Next.js page (`apps/web`) |
| --------------------- | --------------------------------------- | ------------------------- |
| 4G (1.6 Mbps, 150 ms) | 18.4 s to first frame                   | 0.6 s to first paint      |
| 3G (750 kbps, 300 ms) | 38.5 s                                  | 1.0 s                     |
| Downloaded            | 3.3 MB                                  | 195 KB                    |

Even fully brotli-compressed, Flutter web needs about 2 MB before its
first frame (`main.dart.js` 731 KB, a rendering engine 1.2–1.5 MB, fonts),
so over 10 s on that 4G. First visits from a shared link are exactly how
the app spreads, so that is the case that counts.

## Decision

- `apps/web` gains the player app as a PWA under `/app`: every MVP screen
  of `apps/mobile`, the same four skins, installable (manifest, service
  worker), on the same API.
- The browser never holds the session token: `apps/web` signs in through
  its own route handlers, keeps the token in an httpOnly cookie and
  proxies `/api/v1/*` to the API (the pattern `apps/admin` uses). No CORS
  needed.
- The share page `/l/<id>` gains "Open in the web app".
- `apps/mobile` stays the Android app (notifications, Play listing).

## Alternatives considered

- Flutter web build as the PWA: one codebase, but the numbers above.
- No web app: links open a page that only says "Get the app".

## Consequences

- Every player screen exists twice (Flutter and React), the cost ADR-0002
  warned about. Both are thin over the same API and spec, and
  `docs/missing-api.md` and the screen map in `docs/API.md` keep them in
  step.
- `apps/web` gets bigger; its owner (Kidus) reviews it.
- Web push needs FCM's web setup on top of the Firebase project; until
  then the PWA refreshes alerts when open.
