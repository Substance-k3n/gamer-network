# packages/api-spec — the API contract

Owners: both. `openapi.json` is **generated** from `apps/api`; never edit
it by hand. A PR that changes it changes what the app can rely on, so the
mobile owner reviews it (CODEOWNERS).

- Flutter generates its Dart client from it.
- `apps/web` generates TypeScript types from it.
- CI fails if it is stale.
