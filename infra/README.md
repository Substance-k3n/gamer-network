# infra

- `docker/dev/compose.yml` — local Postgres (port 5470, so it doesn't
  clash with abro's 5460) and RustFS for avatars (S3 API on 9470,
  console on 9471, user `gn-media` / `password123`).
  `setup-bucket.sh` creates the `gn-media` bucket with public reads under
  `avatars/`; compose and CI both run it.
- `docker/prod/` — the production images as one Compose stack: Caddy,
  api (+ a migrate step), web, admin, Postgres and backups. Production
  itself runs on Render (`render.yaml`, ADR-0008); this stays for trying
  the images locally and as the way back to a VPS (ADR-0004).
  [docs/DEPLOY.md](../docs/DEPLOY.md).
