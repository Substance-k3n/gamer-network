# Build plan

The map from an empty repo to a closed beta. Update the status marks
(`todo` / `in progress` / `done`) and tick boxes as PRs merge; this file
is the map, not a one-time plan. Scope: [PRD.md](PRD.md). Tables:
[DATA_MODEL.md](DATA_MODEL.md). Endpoints: [API.md](API.md).

## How we work through it

- **Two tracks, one phase apart.** Kidus builds the API for phase N while
  Natnael builds the screens for phase N against the mock server, then
  wires them to the real API once its PR merges.
- **Contract first.** Each backend phase opens with a small PR that adds
  the phase's DTOs and routes to `openapi.json` (handlers return `501`).
  Natnael reviews it (CODEOWNERS), generates the Dart client and starts
  building. The logic PRs that follow must not change the shapes without
  another spec review.
- **Small PRs into `dev`**, each approved by the other owner. A phase is
  done when its acceptance line is met on a real phone against the real
  API, not when the PRs merge.
- **Real database in tests.** API tests run against Postgres (CI service
  container), never mocked repositories.
- Mobile work items are a suggestion; Natnael owns how `apps/mobile` is
  built.

## Phase 0 — Foundations `[in progress]`

- [x] Repo, CODEOWNERS, CI, hooks, ADR-0001…0005, PRD (`03938d8`)
- [x] NestJS scaffold, `/health`, generated spec, spec-freshness CI (#1)
- [x] Data model, API guide, this plan, ADR-0006 Drizzle (#2)
- [ ] GitHub: invite @Natnsis, branch protection on `main` and `dev`
      (1 approval from a code owner, CI green)
- [ ] Validation test running in one Telegram group
      ([validation-test.md](validation-test.md)); pick the 2–3 launch games
- [ ] Name shortlist (needed before the Play listing in phase 9)

**Mobile:** `flutter create` in `apps/mobile` (Android first), folder
structure, lints, `flutter analyze` + `flutter test` CI job, design
tokens and type from the rally prototype, bottom nav (Home, Players,
Groups, You).

**Acceptance:** both of you can clone, run the API and the app locally,
and open a PR that the other has to approve.

## Phase 1 — Data layer `[done on the API side]`

Branch: `feature/api-db`.

- [x] Drizzle + `drizzle-kit`, `src/db/schema/*` for every table in
      DATA_MODEL.md, first migration reviewed as SQL (#3)
- [x] `DbModule` providing the connection; `/health` checks the database (#3)
- [x] Seed: the prototype's 49 games with ranks and modes; codm, pubg and
      efootball provisionally `is_launch` (#3)
- [x] CI `api` job gets a Postgres service; migrations run before tests (#3)
- [x] Shared pieces: error envelope + error codes, UUIDv7, request
      validation (class-validator), app version gate (#4)
- [ ] Cursor pagination and `Idempotency-Key`: built with the first list
      and create endpoints (phase 4)
- [x] `GET /v1/app/config`, `GET /v1/games` (#4)

**Mobile:** generated `api_client` package, Dio setup (auth header,
version headers, 401/426 handling), Prism mock server script, splash +
onboarding carousel calling `/app/config`.

**Acceptance:** fresh database → `migrate` → `seed` → the app lists the
games from the real API.

## Phase 2 — Sign-in `[done on the API side]`

Branch: `feature/api-auth`.

- [x] Email + password: `/auth/signup`, `/auth/login`, argon2id hashes,
      lockout after 10 failures in 15 min (ADR-0007) (#5)
- [x] Email codes: verify email, forgot/reset password; hashed codes,
      10 min expiry, 5 attempts, 5 sends/hour. Email via Resend (#5)
- [x] Google: `/auth/google` verifies the ID token server side; links to
      an existing account with the same email (#5)
- [x] Sessions: opaque token, sha-256 stored, 90-day sliding expiry,
      `AuthGuard`, `@CurrentUser()`, `@RequireVerifiedEmail()` (#5),
      `403 not_onboarded` outside `/me` and `/auth` (`@BeforeOnboarding()`).
      The admin check comes with the admin routes (phase 8)
- [x] `/auth/logout`, `/auth/password` (change), `GET /me` (#5)

**Mobile:** wire the existing Log in and Sign up screens, verify-email
code screen, Forgot password → code → new password, Google Sign-In,
secure token storage, signed-in/out routing.

**Acceptance:** sign up with email + password, sign in with Google, and
reset a password, on a real Android phone; kill the app; it opens signed in.

## Phase 3 — Gamer profile `[done on the API side]`

Branch: `feature/api-profile`.

- [x] `PATCH /me`, username availability, `PUT /me/games`,
      `/me/platforms`, `/me/tags`, `/me/gaming-ids`, `/me/status`
- [x] Avatar: presigned upload URL, `PUT`/`DELETE /me/avatar`; RustFS in
      dev and CI, an R2 bucket in production (phase 9)
- [x] `POST /me/onboard` ("Go live") rules
- [x] `GET /users/{username}` with gaming-ID visibility and
      `relationship`; `GET /users?query=`
- [x] Profile stats (connections, games, played with)

**Mobile:** onboarding steps 1–3 exactly as the prototype; You tab
(Overview + Games tabs only); Edit profile; status card on Home with
the days row.

**Acceptance:** a new user goes from sign-in to "Go live" in under 2
minutes and sees their gamer ID; a second account sees only the public
gaming IDs.

## Phase 4 — Find Players `[todo]`

Branch: `feature/api-listings`.

- [ ] `POST /listings` with the expiry rules and one-live-listing rule
- [ ] `GET /listings` with all filters, cursor paging, block filtering
- [ ] `GET /listings/{id}`, `/close`, `GET /me/listing`, `/listings/stats`
- [ ] Expiry job (every minute) + `listing_expiring` 15 min before
- [ ] Tests for every expiry case (`now`, `tonight` before and after
      02:00, `scheduled`, 24 h cap) in `Africa/Addis_Ababa`

**Mobile:** Find Players list with filter chips and live countdowns,
listing card, Post a listing sheet, your live listing on Home.

**Acceptance:** two phones: A posts, B sees it within seconds with the
right countdown; it disappears from B's list when it expires.

## Phase 5 — Connections `[todo]`

Branch: `feature/api-connections`.

- [ ] Connection requests: send (from listing or profile), list,
      accept, decline, cancel; rate limits and 7-day re-request rule
- [ ] Accept transaction: connection, `filled`, `full`, check-ins
- [ ] `GET /me/connections`, `DELETE /connections/{userId}`
- [ ] Gaming IDs unlock on accept (covered by a test)

**Mobile:** Connect button states (Connect → Requested… → Connected ✓),
someone's profile, Alerts "Connection requests" with Accept / Not now.

**Acceptance:** B connects from A's listing, A accepts in Alerts, B sees
A's `connections`-only Riot ID.

## Phase 6 — Notifications and push `[todo]`

Branch: `feature/api-notifications`.

- [ ] `notifications` written by every event in phases 4–5
- [ ] FCM via Firebase Admin SDK; `PUT /me/devices`; invalid tokens
      removed
- [ ] `GET /notifications`, unread count, mark read

**Mobile:** FCM setup, permission prompt at a sensible moment (after the
first listing or request, not at launch), Alerts activity list, bell
badge, tapping a push opens its `route`.

**Acceptance:** with the app closed, A gets a push for B's request within
5 seconds; tapping it opens the request.

## Phase 7 — Play together and check-ins `[todo]`

Branch: `feature/api-play`.

- [ ] Play invites: send, accept, decline, 15-min expiry
- [ ] Check-ins: created on accept, due 12:00 next day, `check_in_due`
      push, `POST /check-ins/{id}`
- [ ] "Played with" stat

**Mobile:** Play together button and the invite banner with countdown;
"Did you play with Dave?" card on Home (one tap).

**Acceptance:** the next day after a listing connection, both people get
the question and their answers show in `GET /admin/metrics`.

## Phase 8 — Safety and admin `[todo]`

Branches: `feature/api-safety`, `feature/web-admin`.

- [ ] Blocks with every effect in DATA_MODEL.md "Blocks"; reports
- [ ] Admin endpoints + `admin_actions` audit log; bans revoke sessions
- [ ] `DELETE /me` + the 30-day scrub job
- [ ] `apps/web` scaffold (Next.js), admin sign-in, reports queue,
      ban/remove, the metric on one page

**Mobile:** Block / Report in every profile and listing menu, Blocked
users in Settings, Delete account in Settings.

**Acceptance:** A reports B; an admin bans B from the web; B is signed
out and gone from A's lists.

## Phase 9 — Share pages and release `[todo]`

Branches: `feature/web-share`, `chore/infra-prod`.

- [ ] `/l/[id]` share page from `/public/listings/{id}` with Open Graph
      preview, "Open in app" / "Get the app"; `assetlinks.json` for
      Android App Links
- [ ] Dockerfiles, `infra/docker/prod` (Caddy, api, web, Postgres,
      migrate, backups) on the VPS; uptime check on `/health`
- [ ] Off-server backup copy; `docs/DEPLOY.md`

**Mobile:** release signing, app icon and name, Play Console internal
testing track, privacy policy URL (served by `apps/web`), data safety
form.

**Acceptance:** a listing link pasted in Telegram shows the preview, and
on a phone with the app installed it opens the listing.

## Phase 10 — Closed beta `[todo]`

- [ ] 50–100 gamers from one community, invited through the Play
      internal or closed testing track
- [ ] Weekly: read the metric, the reports queue, and talk to 5 users
- [ ] Decide with the numbers: keep going, change the loop, or stop

## Later (only if the beta works)

Home feed and posts, game pages, iPhone build (Codemagic), Groups, chat,
rank verification. Each starts with an ADR that supersedes the relevant
part of ADR-0001.
