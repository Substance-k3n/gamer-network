# apps/api — NestJS API

Owner: Kidus. The only service that touches the database.

Not scaffolded yet. Planned shape (one Nest module per domain):

```
src/
├── auth/           Google sign-in, emailed code, sessions
├── users/          gamer profile: games, ranks, platforms, gaming IDs, age range
├── games/          the 2–3 launch games and their modes/ranks (seeded, not user-made)
├── listings/       Find Players posts, filters, expiry
├── connections/    join requests, accept/decline, gaming-ID unlock, next-day check-in
├── notifications/  FCM push + in-app list
├── moderation/     block, report, admin actions
└── health/         GET /health for uptime checks
```

`pnpm --filter @app/api spec` will write `packages/api-spec/openapi.json`
(ADR-0003). Commit that file with every API change.
