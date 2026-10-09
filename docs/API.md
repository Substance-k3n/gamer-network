# API guide

How the app talks to `apps/api`. Written for wiring the Flutter app
(and the web site's share pages and admin), before and while the
endpoints are built.

- **This file** explains conventions, flows and which screen calls what.
  It is the plan.
- **`packages/api-spec/openapi.json`** is the exact contract once an
  endpoint exists. Where the two disagree, the spec wins and this file
  gets fixed in the same PR.
- Tables behind each endpoint: [DATA_MODEL.md](DATA_MODEL.md).

## Conventions

**Base URL.** `https://api.<domain>/v1` in production,
`http://10.0.2.2:3300/v1` from the Android emulator. Every endpoint is under
`/v1` except `GET /health`. A breaking change gets `/v2` beside `/v1`:
old app versions stay installed for months.

**Auth.** Sign-in returns an opaque `token`. Send it on every request as
`Authorization: Bearer <token>`. Store it in secure storage
(`flutter_secure_storage`), never in plain prefs. Sessions last 90 days,
extended by use. Any `401` means: drop the token, go to sign-in.

**App version.** Send `X-App-Version: 1.4.0` and `X-Platform: android` on
every request. `GET /v1/app/config` says the minimum supported version;
below it, the app shows "Update to keep playing" and nothing else.

**JSON.** `camelCase` fields. Times are ISO 8601 UTC
(`2026-10-08T18:00:00Z`); the app shows them in local time. IDs are UUID
strings; games use slugs (`valorant`). Enums are the lowercase strings
from DATA_MODEL.md (`available_tonight`, `pc`).

**Errors.** Non-2xx responses have one shape:

```json
{
  "error": {
    "code": "listing_already_open",
    "message": "You already have a live listing. Close it to post another.",
    "fields": {}
  }
}
```

`code` is stable; branch on it, never on `message`. `message` is safe to
show. `fields` (on `422`) maps a field name to its problem, for forms.

| Status | When                                                                    |
| ------ | ----------------------------------------------------------------------- |
| 400    | Malformed request                                                       |
| 401    | No token, expired or revoked (`unauthenticated`)                        |
| 403    | Signed in but not allowed (`banned`, `not_onboarded`, `admin_only`)     |
| 404    | Doesn't exist, or hidden from you (blocked users get 404)               |
| 409    | State conflict (`listing_full`, `already_connected`, `request_pending`) |
| 422    | Validation, with `fields`                                               |
| 426    | App too old (`update_required`)                                         |
| 429    | Rate limit (`rate_limited`), with `Retry-After`                         |

**Lists.** Cursor pagination: `?limit=20&cursor=<opaque>` →
`{ "items": [...], "nextCursor": "..." | null }`. No page numbers.

**Images.** Avatars upload straight to storage: ask the API for an upload
URL, `PUT` the file there, then tell the API the key. Responses give
ready-to-use `avatarUrl`s.

**Idempotency.** `POST` that creates something (listings, requests,
invites, reports) accepts `Idempotency-Key: <uuid>`. Retrying with the
same key returns the first result instead of a duplicate. Use it on bad
connections.

## Shared shapes

```ts
UserCard {            // everywhere a person appears in a list
  id, username, displayName, avatarUrl | null, city,
  status: PlayerStatus, statusGame: GameRef | null,
  topGame: { game: GameRef, rank: string | null } | null
}

Profile extends UserCard {
  bio | null, ageRange, availableDays: Day[],           // ["mon","wed"]
  games: [{ game: GameRef, rank: RankRef | null, role: RoleRef | null }],
  platforms: Platform[], tags: PlayTag[],
  gamingIds: [{ kind, game: GameRef | null, value, visibility }], // only those you may see
  stats: { connections, games, playedWith },
  relationship: "self" | "none" | "outgoing_request" | "incoming_request" | "connected"
  incomingRequestId | null                                // to accept straight from the profile
}

GameRef  { id: "valorant", name: "Valorant", shortCode: "VAL" }
RankRef  { id, name: "Diamond", tier: 7 }

Listing {
  id, owner: UserCard, game: GameRef, mode: { id, name } | null, rank: RankRef | null,
  platform, partySize, filled, voice, style, playWhen, startsAt, expiresAt,
  note | null, status, createdAt,
  myRequest: { id, status } | null,      // so the card can show "Requested…" / "Connected ✓"
  shareUrl                                 // https://<domain>/l/<id>
}
```

## Endpoints

`🔓` = no token needed. Everything else needs a token; endpoints other
than `/me*`, `/auth/*` and `/app/*` also need a finished onboarding.

### App

| Method | Path             | Purpose                                                                                                       |
| ------ | ---------------- | ------------------------------------------------------------------------------------------------------------- |
| GET 🔓 | `/health`        | Liveness (no `/v1`)                                                                                           |
| GET 🔓 | `/v1/app/config` | `{ minSupportedVersion, latestVersion, launchCity, groupsComingSoon: true }`                                  |
| GET 🔓 | `/v1/games`      | Full catalog with `ranks`, `roles`, `modes`, `platforms`, `maxParty`, `isLaunch`. Cache it; it rarely changes |

### Sign-in

| Method  | Path                       | Body → Response                                                                                                          |
| ------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| POST 🔓 | `/v1/auth/signup`          | `{ email, password, displayName, username, ageRange }` → `{ token, user: Me, isNew: true }`. Sends a verification code   |
| POST 🔓 | `/v1/auth/login`           | `{ email, password }` → `{ token, user: Me, isNew: false }`. `401 wrong_credentials` for any mismatch                    |
| POST 🔓 | `/v1/auth/google`          | `{ idToken }` (from Google Sign-In on the device, or Google Identity Services on the web) → `{ token, user: Me, isNew }` |
| POST    | `/v1/auth/verify-email`    | `{ code }` → `Me`. `POST /v1/auth/verify-email/resend` sends a new one                                                   |
| POST 🔓 | `/v1/auth/password/forgot` | `{ email }` → `204`, always, even for unknown emails. Sends a reset code                                                 |
| POST 🔓 | `/v1/auth/password/reset`  | `{ email, code, newPassword }` → `{ token, user: Me }`. Signs out every other device                                     |
| POST    | `/v1/auth/password`        | `{ currentPassword, newPassword }` → `204`. Change password from Settings                                                |
| POST    | `/v1/auth/logout`          | `204`. Revokes this token and unregisters this device                                                                    |

Sign-up covers onboarding step 1 (the app's sign-up screen already asks
for email, display name, username, password and age range). Listings
and connection requests return `403 email_not_verified` until the code
is entered, so show the code screen right after sign-up but let people
skip it and look around.

`isNew` or `user.onboardedAt == null` → onboarding. Otherwise → Home.

### Me and onboarding

| Method | Path                       | Body → Response                                                                                                                                            |
| ------ | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/me`                   | `Me` = `Profile` + `email`, `onboardedAt`, `role`                                                                                                          |
| PATCH  | `/v1/me`                   | `{ displayName?, username?, bio?, ageRange?, city? }` → `Me`                                                                                               |
| GET    | `/v1/usernames/{name}`     | `{ available: boolean, suggestion? }` (debounce while typing)                                                                                              |
| PUT    | `/v1/me/games`             | `[{ gameId?, customGameName?, rankId?, rankText?, roleId? }]` (the full list, in order; `customGameName` + `rankText` for games not in the catalog) → `Me` |
| PUT    | `/v1/me/platforms`         | `["pc","playstation"]` → `Me`                                                                                                                              |
| PUT    | `/v1/me/tags`              | `["competitive","fps"]` (≤ 6) → `Me`                                                                                                                       |
| PUT    | `/v1/me/gaming-ids`        | `[{ kind, gameId?, value, visibility }]` (full list) → `Me`                                                                                                |
| PUT    | `/v1/me/status`            | `{ status, gameId?, availableDays? }` → `Me`                                                                                                               |
| POST   | `/v1/me/avatar/upload-url` | `{ contentType: "image/jpeg" }` → `{ uploadUrl, key }` (PUT the file there, ≤ 2 MB)                                                                        |
| PUT    | `/v1/me/avatar`            | `{ key }` → `Me`                                                                                                                                           |
| POST   | `/v1/me/onboard`           | `204`. "Go live": needs display name, username, age range and ≥ 1 game                                                                                     |
| DELETE | `/v1/me`                   | `204`. Deletes the account (Play requirement)                                                                                                              |
| PUT    | `/v1/me/devices`           | `{ fcmToken, platform, appVersion }` → `204`. Call on every launch and on token refresh                                                                    |
| GET    | `/v1/me/connections`       | `{ items: [{ user: UserCard, connectedAt }], nextCursor }`                                                                                                 |
| GET    | `/v1/me/blocks`            | `{ items: UserCard[] }`                                                                                                                                    |
| GET    | `/v1/me/listing`           | Your live `Listing` or `null`, with its pending requests                                                                                                   |

Onboarding maps one-to-one onto the prototype: step 1 → `PATCH /me`,
step 2 → `PUT /me/games` (no ranks yet), step 3 → `PUT /me/games` (with
ranks), `PUT /me/platforms`, `PUT /me/gaming-ids`, then "Go live" →
`POST /me/onboard`.

### People

| Method | Path                   | Purpose                                                             |
| ------ | ---------------------- | ------------------------------------------------------------------- |
| GET    | `/v1/users/{username}` | `Profile`. Gaming IDs filtered by visibility and connection         |
| GET    | `/v1/users?query=dav`  | Search by username or display name prefix → `{ items: UserCard[] }` |

### Find Players

| Method | Path                       | Body → Response                                                                                                                                                                                                                                                        |
| ------ | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/listings`             | Filters: `game`, `rank` (min tier), `platform`, `mode`, `voice=required`, `when=now\|tonight`, `style`, `partySize`. Newest first → `{ items: Listing[], nextCursor }`. Your own and blocked users' are excluded                                                       |
| GET    | `/v1/listings/stats`       | `{ lookingNow: 43 }` for the Home counter                                                                                                                                                                                                                              |
| POST   | `/v1/listings`             | `{ gameId, modeId?, rankId?, platform, partySize, voice: "required"\|"optional", style, playWhen: "now"\|"tonight"\|"weekend", durationHours: 2\|6\|24, note? }`. The API works out `startsAt` and `expiresAt` → `Listing`. `409 listing_already_open` if you have one |
| GET    | `/v1/listings/{id}`        | `Listing`                                                                                                                                                                                                                                                              |
| POST   | `/v1/listings/{id}/close`  | Owner only → `Listing` (status `closed`)                                                                                                                                                                                                                               |
| GET 🔓 | `/v1/public/listings/{id}` | For share pages: owner display name, game, rank, platform, party, when, note, expiresAt. No IDs or gaming IDs                                                                                                                                                          |

### Connections

| Method | Path                                         | Body → Response                                                                                   |
| ------ | -------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| POST   | `/v1/connection-requests`                    | `{ toUserId, listingId?, message? }` → `ConnectionRequest`. From a listing card, pass `listingId` |
| GET    | `/v1/connection-requests?direction=incoming` | `{ items: ConnectionRequest[] }` (Alerts → "Connection requests")                                 |
| GET    | `/v1/connection-requests?direction=outgoing` | Your pending ones                                                                                 |
| POST   | `/v1/connection-requests/{id}/accept`        | → `{ request, connection }`. Unlocks gaming IDs; schedules check-ins if from a listing            |
| POST   | `/v1/connection-requests/{id}/decline`       | "Not now" → `204`                                                                                 |
| DELETE | `/v1/connection-requests/{id}`               | Cancel your own pending request → `204`                                                           |
| DELETE | `/v1/connections/{userId}`                   | Remove a connection → `204`                                                                       |

`ConnectionRequest { id, from: UserCard, to: UserCard, listing: Listing | null, message, status, createdAt }`

### Play together

| Method | Path                            | Body → Response                                                                                                                                    |
| ------ | ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST   | `/v1/play-invites`              | `{ toUserId, gameId, playWhen: "now"\|"in_30_min"\|"tonight" }` → `PlayInvite` with `startsAt` (connections only; expires 15 min after `startsAt`) |
| POST   | `/v1/play-invites/{id}/accept`  | → `PlayInvite`                                                                                                                                     |
| POST   | `/v1/play-invites/{id}/decline` | → `204`                                                                                                                                            |
| GET    | `/v1/me/check-ins`              | Due, unanswered: `[{ id, other: UserCard, game: GameRef, dueAt }]`                                                                                 |
| POST   | `/v1/check-ins/{id}`            | `{ answer: "played" \| "not_yet" \| "no" }` → `204`                                                                                                |

Show due check-ins as a card on Home: "Did you play with Dave?"
**This answer is the product's main number; make it one tap.**

### Notifications

| Method | Path                             | Purpose                                     |
| ------ | -------------------------------- | ------------------------------------------- |
| GET    | `/v1/notifications`              | `{ items: Notification[], nextCursor }`     |
| GET    | `/v1/notifications/unread-count` | `{ count }` for the bell badge              |
| POST   | `/v1/notifications/read`         | `{ ids: [...] }` or `{ all: true }` → `204` |

`Notification { id, type, actor: UserCard | null, listingId?, connectionRequestId?, playInviteId?, checkInId?, text, readAt, createdAt }`.
`text` is ready to show ("Dave answered your listing").

**Push.** Every notification is also sent through FCM with
`data: { type, id, route }`. `route` is the in-app path to open, e.g.
`/alerts`, `/players/<username>`, `/listings/<id>`, `/check-ins/<id>`.

### Safety

| Method | Path                  | Body → Response                                    |
| ------ | --------------------- | -------------------------------------------------- |
| POST   | `/v1/blocks`          | `{ userId }` → `204`                               |
| DELETE | `/v1/blocks/{userId}` | `204`                                              |
| POST   | `/v1/reports`         | `{ userId, listingId?, reason, details? }` → `204` |

Every profile and listing card needs "Block" and "Report" in its menu
(ADR-0005, Play policy).

### Groups (coming soon)

| Method | Path           | Body → Response                             |
| ------ | -------------- | ------------------------------------------- |
| POST   | `/v1/waitlist` | `{ topic: "groups" }` → `204` ("Notify me") |

### Admin (web only, `role = admin`)

| Method | Path                             | Purpose                                                                       |
| ------ | -------------------------------- | ----------------------------------------------------------------------------- |
| GET    | `/v1/admin/reports?status=open`  | Reports queue                                                                 |
| POST   | `/v1/admin/reports/{id}/resolve` | `{ action: "dismiss" \| "warn" \| "remove_listing" \| "ban", note }`          |
| POST   | `/v1/admin/users/{id}/ban`       | `{ reason }`                                                                  |
| POST   | `/v1/admin/users/{id}/unban`     |                                                                               |
| POST   | `/v1/admin/listings/{id}/remove` | `{ note }`                                                                    |
| GET    | `/v1/admin/metrics?from=&to=`    | `{ listings, listingsWithRequest, listingsPlayed, playedRate, weeklyActive }` |

## Screen → endpoint map (prototype "rally")

| Screen                           | Calls                                                                                                                         |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Splash / onboarding carousel     | `GET /app/config`                                                                                                             |
| Landing, Log in, Sign up         | `POST /auth/login`, `/auth/signup`, `/auth/google`, `/auth/password/forgot`, `/auth/password/reset`, `/auth/verify-email`     |
| Step 1 "Who are you as a gamer?" | Part of sign-up; `GET /usernames/{name}` while typing                                                                         |
| Step 2 "What do you play?"       | `GET /games`, `PUT /me/games`                                                                                                 |
| Step 3 "Ranks, platforms & IDs"  | `PUT /me/games`, `/me/platforms`, `/me/gaming-ids`, `POST /me/onboard`                                                        |
| Home (no feed in the MVP)        | `GET /me`, `PUT /me/status`, `GET /listings/stats`, `GET /me/check-ins`, `GET /me/listing`, `GET /notifications/unread-count` |
| Find Players                     | `GET /listings`, `POST /connection-requests`                                                                                  |
| Post a listing                   | `POST /listings`                                                                                                              |
| Someone's profile                | `GET /users/{username}`, `POST /connection-requests`, `POST /play-invites`, block/report                                      |
| You (own profile), Edit          | `GET /me`, the `PUT /me/*` endpoints, avatar upload                                                                           |
| Alerts                           | `GET /connection-requests?direction=incoming`, accept/decline, `GET /notifications`, `POST /notifications/read`               |
| Groups (coming soon)             | `POST /waitlist`                                                                                                              |
| Settings                         | `POST /auth/logout`, `GET /me/blocks`, `DELETE /blocks/{id}`, `DELETE /me`                                                    |

## Wiring the Flutter app

1. Generate the client from the spec, never by hand:
   `openapi-generator-cli generate -i packages/api-spec/openapi.json -g dart-dio -o apps/mobile/packages/api_client`.
   Regenerate whenever `openapi.json` changes in `dev`.
2. One Dio instance with interceptors: add `Authorization`,
   `X-App-Version`, `X-Platform`; on `401` clear the token and route to
   sign-in; on `426` show the update screen; retry idempotent requests once
   on network errors.
3. Until an endpoint is live, run a mock server from the same spec
   (`npx @stoplight/prism-cli mock packages/api-spec/openapi.json`) so
   screens are built against the real shapes, not invented ones.
4. Deep links: `https://<domain>/l/<id>` opens the listing (Android App
   Links). Push `route` uses the same paths.
