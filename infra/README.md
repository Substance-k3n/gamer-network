# infra

- `docker/dev/compose.yml` — local Postgres (port 5470, so it doesn't
  clash with abro's 5460) and RustFS for avatars (S3 API on 9470,
  console on 9471, user `gn-media` / `password123`).
  `setup-bucket.sh` creates the `gn-media` bucket with public reads under
  `avatars/`; compose and CI both run it.
- `docker/prod/` — added with the first deploy: Caddy + api + web +
  Postgres + daily backups on one VPS, same pattern as abro (ADR-0004).
