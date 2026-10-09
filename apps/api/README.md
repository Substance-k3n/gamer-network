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

## Planned modules

```
src/
├── auth/           Google sign-in, emailed code, sessions
├── users/          gamer profile: games, ranks, platforms, gaming IDs, age range
├── games/          the 2–3 launch games and their modes/ranks (seeded, not user-made)
├── listings/       Find Players posts, filters, expiry
├── connections/    join requests, accept/decline, gaming-ID unlock, next-day check-in
├── notifications/  FCM push + in-app list
├── moderation/     block, report, admin actions
└── health/         GET /health (checks the database)  ✓
```
