# infra

- `docker/dev/compose.yml` — local Postgres (port 5470, so it doesn't
  clash with abro's 5460).
- `docker/prod/` — added with the first deploy: Caddy + api + web +
  Postgres + daily backups on one VPS, same pattern as abro (ADR-0004).
