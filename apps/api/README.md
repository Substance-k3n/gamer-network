# apps/api — NestJS API

Owner: Kidus. The only service that touches the database (ADR-0003).

## Run

```bash
docker compose -f infra/docker/dev/compose.yml up -d   # from the repo root
cp .env.example .env
pnpm --filter @app/api db:migrate # apply apps/api/drizzle/*.sql
pnpm --filter @app/api db:seed    # games, ranks and modes (safe to re-run)
pnpm --filter @app/api dev        # http://localhost:3300, Swagger UI at /docs
pnpm --filter @app/api test       # unit tests, src/**/*.spec.ts
pnpm --filter @app/api test:e2e   # HTTP + database tests against gn_test (created for you)
pnpm --filter @app/api spec       # rewrite packages/api-spec/openapi.json
```

**Commit `openapi.json` with every API change.** CI fails if it is stale.

## Sign-in (ADR-0007)

Every route needs `Authorization: Bearer <token>` unless it's marked
`@Public()`. Use `@CurrentUser()` for the signed-in user and
`@RequireVerifiedEmail()` on routes that need a verified email (posting
listings, sending requests).

Without `RESEND_API_KEY`, emails (and their 6-digit codes) are printed to
the API console. Google sign-in needs `GOOGLE_CLIENT_IDS`.

## Database

Drizzle (ADR-0006). The schema is TypeScript in `src/db/schema/`, one file
per area, matching `docs/DATA_MODEL.md`. To change it:

1. Edit `src/db/schema/*.ts` (and `docs/DATA_MODEL.md`).
2. `pnpm --filter @app/api db:generate` writes the next `drizzle/NNNN_*.sql`.
   Read it; edit it by hand if Drizzle can't express something.
3. `pnpm --filter @app/api db:migrate`, then run the e2e tests.

CI fails if the schema changed without a migration. Never edit a
migration that is already on `dev`; add a new one.

Inject the database with `@Inject(DB) private readonly db: Db`.

The game catalog in `src/db/seed/games.ts` was generated from the app's
`apps/mobile/lib/data.dart`, so game ids match on both sides.

## How the spec is made

`src/openapi.ts` builds it; the `@nestjs/swagger` CLI plugin reads DTO
property types and `/** doc comments */` on handlers, so most endpoints
need no Swagger decorators. Add `@ApiProperty` only where TypeScript
types aren't enough (enums, literal types, formats). Operation IDs are
`<resource><Method>` (e.g. `healthCheck`): that's the method name the
generated Dart client gets, so name handlers for the caller.

## Modules

```
src/
├── auth/           email + password, Google, sessions, email codes, AuthGuard
├── me/             my profile: edit, games, platforms, tags, gaming IDs, status, avatar, onboard
├── users/          someone's profile, search; visibility.ts (live + not blocked) used everywhere
├── games/          catalog (seeded); is_launch games are the ones on Find Players
├── listings/       Find Players: post, feed, close, stats, public share data, expiry job
├── connections/    requests, accept (fills the listing, creates check-ins), my connections
├── play/           play invites (15 min), check-ins ("did you play?"), check-ins-due job
├── notifications/  in-app list + push outbox; PushDispatcher, FCM or console
├── safety/         blocks, reports, waitlist, DELETE /me, 30-day account-scrub job
├── admin/          @AdminOnly: reports queue, bans, remove listing, game switch, metrics
├── storage/        S3-compatible media (RustFS locally, R2 in production)
├── jobs/           JobRunner: timers in the API, one advisory lock per job
├── mail/           Resend or console
├── common/         errors, cursor paging, Addis time helpers
└── health/         GET /health (checks the database)
```

## Jobs and push

Timed jobs (`listing-expiry`, `check-ins-due` every minute,
`account-scrub` hourly, `push-sweep`) run inside the API. Each run takes a
Postgres advisory lock, so a second instance never doubles up.
`JOBS_ENABLED=false` turns them off (tests run them with
`JobRunner.runOnce`).

`NotificationsService.notify(tx, rows)` writes notifications in the
caller's transaction and fires `pg_notify`; `PushDispatcher` listens and
pushes within a second, marking rows `pushed_at`. Without
`FIREBASE_SERVICE_ACCOUNT` pushes are printed to the console.

## Admins

```bash
pnpm --filter @app/api admin:grant you@example.com           # make admin
pnpm --filter @app/api admin:grant you@example.com --revoke  # undo
```

## Production keys

Everything in `.env.example` has a dev default except these, which must
be set in production (the API refuses to start without the `S3_*` and
URL ones): `GOOGLE_CLIENT_IDS`, `RESEND_API_KEY` + `MAIL_FROM`,
`FIREBASE_SERVICE_ACCOUNT`, `S3_*`, `MEDIA_PUBLIC_URL`, `PUBLIC_WEB_URL`,
`WEB_ORIGINS`.
