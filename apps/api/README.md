# apps/api — NestJS API

Owner: Kidus. The only service that touches the database (ADR-0003).

## Run

```bash
cp .env.example .env
pnpm --filter @app/api dev        # http://localhost:3300, Swagger UI at /docs
pnpm --filter @app/api test       # unit tests, src/**/*.spec.ts
pnpm --filter @app/api test:e2e   # HTTP tests, test/**/*.e2e-spec.ts
pnpm --filter @app/api spec       # rewrite packages/api-spec/openapi.json
```

**Commit `openapi.json` with every API change.** CI fails if it is stale.

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
└── health/         GET /health  ✓
```
