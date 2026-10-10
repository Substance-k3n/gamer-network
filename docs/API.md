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

**Images.** Avatars upload straight to storage, never through the API:

1. Resize and compress on the phone (≤ 2 MB; 512 × 512 JPEG is plenty).
2. `POST /v1/me/avatar/upload-url` with `{ contentType, size }` (the exact
   byte count) → `{ uploadUrl, headers, key, expiresAt }`.
3. `PUT` the bytes to `uploadUrl` with `headers` within 5 minutes. The URL
   is signed for that type and size; anything else gets `403`.
4. `PUT /v1/me/avatar` with `{ key }` → `Me` with the new `avatarUrl`.

Responses give ready-to-use public `avatarUrl`s.

**Idempotency.** `POST` that creates something (`/listings`,
`/connection-requests`, `/play-invites`, `/reports`) accepts
`Idempotency-Key: <uuid>`. Retrying with the same key returns the first
result instead of a duplicate. Use it on bad connections: make one key
per thing the user creates and reuse it for every retry of that tap.

- Keys are per user and kept 24 hours.
- Only successes are kept. After an error the same key can be sent
  again, for example with the fields fixed.
- `400 bad_idempotency_key`: not a UUID.
- `409 idempotency_in_progress`: the first request is still running; try
  again in a moment.
- `422 idempotency_key_reused`: the key was used for a different request
  (another path or body).

## Shared shapes

```ts
UserCard {            // everywhere a person appears in a list
  id, username, displayName, avatarUrl | null, city,
  status: PlayerStatus,             // already not_available once statusUntil passed
  statusGame: GameRef | null,
  topGame: UserGame | null          // the first game on the profile
}

UserGame {            // a catalog game, or a custom one added by name
  id, game: GameRef | null, customGameName | null,
  rank: RankRef | null, rankText | null, role: RoleRef | null
}

Profile extends UserCard {
  bio | null, ageRange, availableDays: Day[],           // ["mon","wed"]
  statusUntil | null,
  games: UserGame[],                                    // profile order
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

| Method | Path                       | Body → Response                                                                                                                                                             |
| ------ | -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/me`                   | `Me` = `Profile` + `email`, `emailVerified`, `hasPassword`, `country`, `onboardedAt`, `role`, `createdAt`                                                                   |
| PATCH  | `/v1/me`                   | `{ displayName?, username?, bio?, ageRange?, city? }` → `Me`. Only fields sent change; `bio: ""` or `null` clears it. `409 username_taken`                                  |
| GET    | `/v1/usernames/{name}`     | `{ available: boolean, suggestion? }` (debounce while typing)                                                                                                               |
| PUT    | `/v1/me/games`             | `{ games: [{ gameId?, customGameName?, rankId?, rankText?, roleId? }] }` (≤ 20, the full list, in order; `customGameName` + `rankText` for games not in the catalog) → `Me` |
| PUT    | `/v1/me/platforms`         | `{ platforms: ["pc","playstation"] }` → `Me`                                                                                                                                |
| PUT    | `/v1/me/tags`              | `{ tags: ["competitive","fps"] }` (≤ 6) → `Me`                                                                                                                              |
| PUT    | `/v1/me/gaming-ids`        | `{ gamingIds: [{ kind, gameId?, value, visibility? }] }` (full list; `gameId` only and always for `in_game`; visibility defaults to `connections`) → `Me`                   |
| PUT    | `/v1/me/status`            | `{ status, gameId?, availableDays? }` → `Me`. `available_tonight` clears at 04:00, `playing` after 4 h, `looking` after 12 h                                                |
| POST   | `/v1/me/avatar/upload-url` | `{ contentType: "image/jpeg" \| "image/png" \| "image/webp", size }` → `{ uploadUrl, headers, key, expiresAt }` (see "Images")                                              |
| PUT    | `/v1/me/avatar`            | `{ key }` → `Me`. The previous avatar is deleted                                                                                                                            |
| DELETE | `/v1/me/avatar`            | → `Me` without an avatar                                                                                                                                                    |
| POST   | `/v1/me/onboard`           | `204`. "Go live": needs ≥ 1 game, else `422 profile_incomplete`. Safe to repeat                                                                                             |
| GET    | `/v1/me/listing`           | `{ listing: Listing \| null }` (see Find Players)                                                                                                                           |

Onboarding maps one-to-one onto the prototype: step 1 → `PATCH /me`,
step 2 → `PUT /me/games` (no ranks yet), step 3 → `PUT /me/games` (with
ranks), `PUT /me/platforms`, `PUT /me/gaming-ids`, then "Go live" →
`POST /me/onboard`.

List bodies are wrapped in an object (`{ games: [...] }`, not a bare
array) so each can grow a field later without breaking old apps.

### People

| Method | Path                   | Purpose                                                             |
| ------ | ---------------------- | ------------------------------------------------------------------- |
| GET    | `/v1/users/{username}` | `Profile`. Gaming IDs filtered by visibility and connection         |
| GET    | `/v1/users?query=dav`  | Search by username or display name prefix → `{ items: UserCard[] }` |

`404 not_found` for anyone you can't see: not live yet, banned, deleted,
or blocked either way. Search needs ≥ 2 characters, returns up to 20 by
username, and never includes you.

### Find Players

| Method | Path                       | Body → Response                                                                                                                                                                                                        |
| ------ | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/listings`             | Filters: `game`, `minRank` (a rank id: that tier or higher), `platform`, `mode`, `voice=required`, `when=now\|tonight`, `style`, `partySize`, plus `limit`/`cursor`. Newest first → `{ items: Listing[], nextCursor }` |
| GET    | `/v1/listings/stats`       | `{ lookingNow: 43 }` for the Home counter                                                                                                                                                                              |
| POST   | `/v1/listings`             | `{ gameId, modeId?, rankId?, platform, partySize, voice, style, playWhen, durationHours: 2\|6\|24, note? }` → `201 Listing`. Needs a verified email. `409 listing_already_open` if you have one                        |
| GET    | `/v1/listings/{id}`        | `Listing`, any status (a shared link can say "expired")                                                                                                                                                                |
| POST   | `/v1/listings/{id}/close`  | Owner only (`403 not_owner`) → `Listing` with status `closed`. `409 listing_not_live` once it has ended                                                                                                                |
| GET    | `/v1/me/listing`           | `{ listing: Listing \| null }`: your open or full listing                                                                                                                                                              |
| GET 🔓 | `/v1/public/listings/{id}` | For share pages: owner display name and avatar, game, mode, rank, platform, party, voice, when, note, status. No ids or gaming IDs                                                                                     |

The feed shows `open` listings in your city that haven't run out, never
your own and never from someone blocked either way. Posting checks the
game is a launch game, the platform is one of its platforms, the party
fits `maxParty`, and the mode and rank belong to the game; `rankId`
defaults to your rank in that game. `status` reads `expired` as soon as
`expiresAt` passes.

### Connections

| Method | Path                                         | Body → Response                                                                                                                        |
| ------ | -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| POST   | `/v1/connection-requests`                    | `{ toUserId, listingId?, message? }` → `201 ConnectionRequest`. From a listing card, pass `listingId`                                  |
| GET    | `/v1/connection-requests?direction=incoming` | `{ items: ConnectionRequest[] }`, pending, newest first (Alerts → "Connection requests"). Default `incoming`                           |
| GET    | `/v1/connection-requests?direction=outgoing` | Your pending ones                                                                                                                      |
| POST   | `/v1/connection-requests/{id}/accept`        | → `{ request, connection: { user, connectedAt } }`. Unlocks gaming IDs; takes a listing slot and schedules check-ins if from a listing |
| POST   | `/v1/connection-requests/{id}/decline`       | "Not now" → `204`. The sender isn't told                                                                                               |
| DELETE | `/v1/connection-requests/{id}`               | Cancel your own pending request → `204`                                                                                                |
| GET    | `/v1/me/connections`                         | `{ items: [{ user: UserCard, connectedAt }], nextCursor }`, newest first                                                               |
| DELETE | `/v1/connections/{userId}`                   | Remove a connection → `204`                                                                                                            |

`ConnectionRequest { id, from: UserCard, to: UserCard, listing: Listing | null, message, status, createdAt }`

Sending needs a verified email and answers: `404` if you can't see
them, `409 already_connected`, `409 request_pending` (you already
asked), `409 request_waiting_for_you` with `fields.requestId` (they
asked you first: accept that one), `409 listing_not_open`, `429
request_cooldown` (they declined you in the last 7 days), `429
daily_limit` (30 a day). Accept, decline and cancel answer `409
request_not_pending` once a request was already answered. Accepting a
request for a listing that filled up meanwhile still connects you.

### Play together

| Method | Path                                  | Body → Response                                                                                                                       |
| ------ | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| POST   | `/v1/play-invites`                    | `{ toUserId, gameId, playWhen: "now"\|"in_30_min"\|"tonight" }` → `201 PlayInvite`. Connections only; expires 15 min after `startsAt` |
| GET    | `/v1/play-invites?direction=incoming` | `{ items: PlayInvite[] }`: pending, unexpired, for the invite banner. `outgoing` for yours                                            |
| POST   | `/v1/play-invites/{id}/accept`        | → `PlayInvite`. Schedules both check-ins. `409 invite_expired`                                                                        |
| POST   | `/v1/play-invites/{id}/decline`       | → `204`                                                                                                                               |
| GET    | `/v1/me/check-ins`                    | `{ items: [{ id, other: UserCard, game: GameRef \| null, listingId, playInviteId, dueAt }] }`: due, unanswered, oldest first          |
| POST   | `/v1/check-ins/{id}`                  | `{ answer: "played" \| "not_yet" \| "no" }` → `204`. Can be changed later; clears its Alert                                           |

`PlayInvite { id, from: UserCard, to: UserCard, game: GameRef, playWhen, startsAt, expiresAt, status, createdAt }`.
`tonight` means 21:00 Addis time, or right away if it's later than that
or before 04:00. Sending needs a verified email: `403 not_connected`,
`409 invite_pending`, `429 daily_limit` (20 a day). When a check-in is
due, the person gets a `check_in_due` notification and push.

Show due check-ins as a card on Home: "Did you play with Dave?"
**This answer is the product's main number; make it one tap.**

### Notifications

| Method | Path                             | Purpose                                                          |
| ------ | -------------------------------- | ---------------------------------------------------------------- |
| GET    | `/v1/notifications`              | `{ items: Notification[], nextCursor }`, newest first            |
| GET    | `/v1/notifications/unread-count` | `{ count }` for the bell badge                                   |
| POST   | `/v1/notifications/read`         | `{ ids: [...] }` or `{ all: true }` → `204`                      |
| PUT    | `/v1/me/devices`                 | `{ fcmToken, platform: android\|ios\|web, appVersion? }` → `204` |

`Notification { id, type, actor: UserCard | null, listingId, connectionRequestId, playInviteId, checkInId, title, text, route, readAt, createdAt }`.
`text` is ready to show ("Hana wants to play PUBG Mobile with you");
`route` is where tapping it goes. Notifications from people you can no
longer see (blocked, banned) are left out.

**Push.** Every notification is also sent through FCM to each device
the person registered, with `notification: { title, body: text }` and
`data: { type, id, route }`. `route` is the in-app path to open:
`/alerts`, `/players/<username>`, `/listings/<id>`, `/check-ins/<id>`.
Register the device (`PUT /v1/me/devices`) on every launch and when the
token refreshes; it is tied to that sign-in, so logging out stops its
pushes. A token moves to whoever signed in on the phone last.

### Safety

| Method | Path                  | Body → Response                                                                         |
| ------ | --------------------- | --------------------------------------------------------------------------------------- |
| POST   | `/v1/blocks`          | `{ userId }` → `204`. Safe to repeat                                                    |
| DELETE | `/v1/blocks/{userId}` | `204`, or `404` if you hadn't blocked them                                              |
| GET    | `/v1/me/blocks`       | `{ items: UserCard[] }` for Settings → Blocked users                                    |
| POST   | `/v1/reports`         | `{ userId, listingId?, reason, details? }` → `204`. Goes to the admin queue             |
| DELETE | `/v1/me`              | `{ password }` (when `hasPassword`) → `204`. `401 wrong_password`. Signs out everywhere |

Every profile and listing card needs "Block" and "Report" in its menu
(ADR-0005, Play policy). Blocking hides you from each other everywhere,
ends the connection and withdraws pending requests and invites both
ways. Deleting an account closes the live listing, withdraws everything
pending and removes connections at once; personal data is erased 30
days later and the email can then sign up again.

### Groups (coming soon)

| Method | Path           | Body → Response                             |
| ------ | -------------- | ------------------------------------------- |
| POST   | `/v1/waitlist` | `{ topic: "groups" }` → `204` ("Notify me") |

### Admin (web only, `role = admin`)

For `apps/admin`. Admins sign in with `/v1/auth/login` like anyone else;
every route here answers `403 admin_only` to players and works without a
gamer profile. Make an account an admin with
`pnpm --filter @app/api admin:grant <email>` (`--revoke` to undo). Every
action writes an `admin_actions` row.

| Method | Path                             | Purpose                                                                                                          |
| ------ | -------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/admin/reports?status=open`  | Reports queue with reporter and target. `open` oldest first, others newest first; `limit`/`cursor`               |
| POST   | `/v1/admin/reports/{id}/resolve` | `{ action: "dismiss" \| "warn" \| "remove_listing" \| "ban", note }` → report. Reporter is told unless dismissed |
| GET    | `/v1/admin/users?query=&state=`  | Search by username, name or email prefix; `state` = `active` \| `banned` \| `deleted`                            |
| GET    | `/v1/admin/users/{id}`           | The player drawer: account, main game, last seen, connections, played with, open reports                         |
| POST   | `/v1/admin/users/{id}/ban`       | `{ reason }`. Signs them out everywhere and removes their live listing                                           |
| POST   | `/v1/admin/users/{id}/unban`     | `{ note? }`                                                                                                      |
| POST   | `/v1/admin/listings/{id}/remove` | `{ note? }` → `204`                                                                                              |
| PATCH  | `/v1/admin/games/{id}`           | `{ isLaunch }` → `204`. Puts a game on Find Players or takes it off                                              |
| GET    | `/v1/admin/metrics?from=&to=`    | `{ listings, listingsWithRequest, listingsPlayed, playedRate, weeklyActive }`, default the last 30 days          |

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
