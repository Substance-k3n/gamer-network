# Missing from the API

What the mobile app needs that `apps/api` doesn't offer yet, found while
wiring every endpoint in `packages/api-spec/openapi.json` into
`apps/mobile`. Everything else the app uses exists and is integrated.

Last checked: 2026-10-15, against the spec on `dev`.

## API gaps

Closed on 2026-10-15 (`feature/api-missing-fields`):

- `outgoingRequestId` on `Profile`: withdraw from someone's profile in one
  call.
- `waitlist` on `Me`: Groups keeps "You're on the list ✓" after a restart.
- `username` on `POST /v1/auth/login`: the prototype's "Email or username"
  login field.
- `waitlist` counts on `GET /v1/admin/metrics`: the admin Overview shows
  which groups people want (PRD: the waitlist "tells us which groups to
  launch").
- `PATCH /v1/listings/{id}` (`voice`, `style`, `playWhen`, `note`): fix a
  live listing without closing it, so its requests and link stay.

The apps don't use these yet; wiring them is the next PR.

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
