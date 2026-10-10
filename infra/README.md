# infra

- `docker/dev/compose.yml` — local Postgres (port 5470, so it doesn't
  clash with abro's 5460) and RustFS for avatars (S3 API on 9470,
  console on 9471, user `gn-media` / `password123`).
  `setup-bucket.sh` creates the `gn-media` bucket with public reads under
  `avatars/`; compose and CI both run it.
- `docker/prod/` — the production stack on one VPS: Caddy, api (+ a
  migrate step), web, admin, Postgres, daily backups and their off-server
  copy to R2 (ADR-0004). How to run it: [docs/DEPLOY.md](../docs/DEPLOY.md).
