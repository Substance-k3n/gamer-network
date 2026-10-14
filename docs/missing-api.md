# Missing from the API

What the mobile app needs that `apps/api` doesn't offer yet, found while
wiring every endpoint in `packages/api-spec/openapi.json` into
`apps/mobile`. Everything else the app uses exists and is integrated.

Last checked: 2026-10-13, against the spec on `dev`.

## API gaps

| #   | What the app needs                                    | What happens now                                                                                                                                                            | Suggested change                                                                         |
| --- | ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| 1   | Withdraw my request from someone's profile            | `Profile` says `relationship: outgoing_request` but not which request, so the app lists `GET /connection-requests?direction=outgoing` and finds it by user. One extra call. | `outgoingRequestId` on `Profile`, next to `incomingRequestId`.                           |
| 2   | Show "You're on the list ✓" on Groups after a restart | `POST /waitlist` has no read side; the app forgets after it closes and shows "Notify me" again (joining twice is harmless).                                                 | `waitlist: string[]` (topics joined) on `Me`, or `GET /v1/waitlist`.                     |
| 3   | Fix a typo in a live listing                          | Not possible: close it and post again, which resets its requests and share link.                                                                                            | `PATCH /v1/listings/{id}` for `note`, `voice`, `playWhen`. Fine to leave out of the MVP. |

## Data gaps (seed, not API)

- **Roles are empty for every game.** `GameDto.roles` and
  `UserGameInput.roleId` exist and the app shows a role picker per game,
  but it stays hidden until `apps/api/src/db/seed/games.ts` has roles
  (Duelist, Jungle, IGL, Sniper…).
- **Three launch games** (`efootball`, `codm`, `pubg`). Listings only
  work for launch games; the admin dashboard switches more on.

## Not API work: setup

These are in the API already; what's missing is configuration or app
setup.

| Feature                    | API                                                          | Missing                                                                                               |
| -------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Push notifications         | `PUT /me/devices`; production has `FIREBASE_SERVICE_ACCOUNT` | `firebase_messaging` and `google-services.json` from the same Firebase project in `apps/mobile`.      |
| Google sign-in             | `POST /auth/google`                                          | `GOOGLE_CLIENT_IDS` on the API, an Android OAuth client (release SHA-1), `google_sign_in` in the app. |
| Listing links open the app | `GET /listings/{id}` (the app's listing screen uses it)      | A domain for `apps/web` and Android App Links (`assetlinks.json`, intent filter).                     |

## In the API, not used by the app (on purpose)

- `message` on `POST /connection-requests`: the app sends requests
  without a note, as the prototype does. A note field can come later.
- `POST /notifications/read` with `ids`: opening Alerts marks everything
  read (`all: true`).
- `GET /public/listings/{id}`: for `apps/web` share pages.
- `GET /health` and `/v1/admin/*`: monitoring and the admin dashboard.

## Deploy note

The live API (`gn-api` on Render) still serves the spec from before
release #38: `SetGamesBody`, `AppConfigResponse` and five other schemas
show no fields there. Behaviour is the same, but the deploy of `main`
hasn't happened; see Render → `gn-api` → Events.
