# Deploying

Production runs on Render (ADR-0008), described by `render.yaml` at the
repo root. `main` deploys itself: merging a release is the deploy.

| Render service | What it does                                                          |
| -------------- | --------------------------------------------------------------------- |
| `gn-api`       | NestJS API. Pre-deploy runs the migrations and seeds the game catalog |
| `gn-web`       | Share pages, privacy policy, App Links                                |
| `gn-admin`     | Moderation dashboard                                                  |
| `gn-db`        | Postgres 17, private, daily backups by Render                         |

`gn-web` and `gn-admin` call the API over Render's private network.
Avatars go straight from the phone to Cloudflare R2 (API.md "Images").

## 1. One-time setup on Render

1. **Cloudflare R2.** A `gn-media` bucket with public access (the
   `r2.dev` URL or a custom domain); that URL is `MEDIA_PUBLIC_URL`. Add
   a CORS rule allowing `PUT` from any origin with the `Content-Type`
   header, so phones can upload. Create an API token with Object Read &
   Write on the bucket.
2. **Keys.** Production refuses to start without them (the API exits
   with e.g. `RESEND_API_KEY is not set.`):
   - `RESEND_API_KEY`, and `MAIL_FROM` on a domain verified in Resend.
   - `FIREBASE_SERVICE_ACCOUNT`: Firebase console → Project settings →
     Service accounts → Generate new private key, then
     `base64 -w0 key.json`.
   - The R2 settings above: `S3_ENDPOINT`
     (`https://<account id>.r2.cloudflarestorage.com`),
     `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`, `MEDIA_PUBLIC_URL`.
   - `GOOGLE_CLIENT_IDS` is optional: leave it empty and only email +
     password sign-in works.
3. **Blueprint.** Render dashboard → New → Blueprint → connect this
   GitHub repo, branch `main`. Render reads `render.yaml` and asks for
   every value marked `sync: false`. The URLs come from the service
   names, so fill them in as:
   - `PUBLIC_WEB_URL` (on `gn-api` and `gn-web`): `https://gn-web.onrender.com`
   - `WEB_ORIGINS`: `https://gn-web.onrender.com,https://gn-admin.onrender.com`

   If Render gives a service a different `onrender.com` name, or you add
   your own domains later (service → Settings → Custom Domains), change
   these two to match and redeploy.

4. **Check it.**

   ```sh
   curl https://gn-api.onrender.com/health        # {"status":"ok","database":"ok"}
   curl https://gn-api.onrender.com/openapi.json  # the contract, for the app
   ```

5. **Admin account.** Sign up in the app (or with `POST /v1/auth/signup`),
   then in `gn-api` → Shell: `node dist/db/grant-admin.js <email>`, and
   sign in at `https://gn-admin.onrender.com`.
6. **Uptime check.** Add `https://gn-api.onrender.com/health` to a free
   monitor (UptimeRobot, Better Stack) with email alerts. It answers 503
   when the database is down.

## 2. Updating

Release `dev` → `main` (`release/YYYY-MM-DD`). Render builds the three
images, runs the pre-deploy step and switches over only if `/health`
answers. A failed migration stops the deploy and the old version keeps
running. Roll back from the service's Events page ("Rollback").

**Check the new code is really live**, not just that the server
answers: the deploy in the service's Events page should show the merge
commit, and a route the release added or changed should answer the new
way.

## 3. Backups and restore

Render backs up `gn-db` daily (paid plans) and restores from the
database's Recovery page. For a copy to keep elsewhere:

```sh
pg_dump -Fc "<external connection string>" -f gn-$(date +%Y%m%d).dump
```

(The database has no outside access by default: add your IP under
`gn-db` → Networking first, and remove it after.)

## Running the production images yourself

`infra/docker/prod/` is the same three images plus Caddy, Postgres and
backups as one Compose stack: the way to try production locally, and
the way back to a VPS (ADR-0004).

| Service          | What it does                                                        |
| ---------------- | ------------------------------------------------------------------- |
| `caddy`          | HTTPS (automatic Let's Encrypt) for the three hostnames             |
| `api`            | NestJS API (`apps/api/Dockerfile`)                                  |
| `migrate`        | One-shot: applies migrations and seeds the game catalog, then exits |
| `web`            | Share pages, privacy policy, App Links (`apps/web/Dockerfile`)      |
| `admin`          | Moderation dashboard (`apps/admin/Dockerfile`)                      |
| `postgres`       | Database (no public port)                                           |
| `backup`         | Daily `pg_dump` into `infra/docker/prod/backups/`, 14 days kept     |
| `backup-offsite` | Every 6 h, copies new dumps to a private R2 bucket                  |

Avatars don't live on the server: they go straight from the phone to
Cloudflare R2 (API.md "Images"). `web` calls the API over the internal
network (`http://api:3300`), so share pages don't depend on DNS.

### VPS setup

1. **Server.** A small Linux VPS (2 GB RAM, 20 GB disk) with Docker
   Engine and the Compose plugin. Open ports 22, 80 and 443 only.
   Building the three images needs about 5 GB free.
2. **DNS.** Three records pointing at the server: the bare domain for
   share links (`example.com`), `api.example.com`, `admin.example.com`.
3. **Cloudflare R2.** Two buckets:
   - `gn-media` for avatars. Turn on public access (the `r2.dev` URL or a
     custom domain like `media.example.com`); that URL is
     `MEDIA_PUBLIC_URL`. Add a CORS rule allowing `PUT` from any origin
     with the `Content-Type` header, so phones can upload. Create an API
     token with Object Read & Write on this bucket.
   - `gn-backups`, private. Add a lifecycle rule deleting objects after
     30 days. Create a second token with Object Read & Write on only
     this bucket.
4. **Keys.** Production refuses to start without them (the API exits
   with e.g. `RESEND_API_KEY is required in production.`):
   - `RESEND_API_KEY`, and `MAIL_FROM` on a domain verified in Resend.
   - `FIREBASE_SERVICE_ACCOUNT`: Firebase console → Project settings →
     Service accounts → Generate new private key, then
     `base64 -w0 key.json`.
   - The R2 settings above.
   - `GOOGLE_CLIENT_IDS` is optional: without it only email + password
     sign-in works.
5. **Config.** On the server: clone the repo, then in
   `infra/docker/prod/` copy `.env.example` to `.env` and fill it in.
   Generate `POSTGRES_PASSWORD` with `openssl rand -hex 32`. `.env` is
   gitignored; keep a copy somewhere safe.

### First start

```sh
cd infra/docker/prod
docker compose up -d --build
docker compose ps            # migrate: exited (0); the rest running
docker compose logs migrate  # "migrations applied", "seeded 49 games"
curl https://api.example.com/health   # {"status":"ok","database":"ok"}
```

The first request can take a few seconds while Caddy gets certificates.

**Admin account.** Sign up in the app (or with `POST /v1/auth/signup`),
then:

```sh
docker compose run --rm api node dist/db/grant-admin.js <email>
```

**Uptime check.** Add `https://api.<domain>/health` to a free monitor
(UptimeRobot, Better Stack) with email alerts. It answers 503 when the
database is down.

### Updating

```sh
cd infra/docker/prod
git pull
docker compose up -d --build   # rebuilds what changed; migrate runs before api
```

Migrations only move forward. Roll back by deploying the previous
commit; undoing a migration is a deliberate, manual step.

**Check the new code is really live**, not just that the server
answers: `docker compose ps` should show containers created just now,
and a route the release added or changed should answer the new way
(`/health` answering says nothing about which version is running).

### Backups and restore

`backup` writes `backups/gn-YYYYMMDD-HHMM.dump` when it starts and every
24 h after, and keeps 14 days. `backup-offsite` copies new dumps to the
`gn-backups` bucket every 6 h; its log says
`backups copied <time>` after each run (`docker compose logs backup-offsite`).

Restore:

```sh
docker compose stop api web admin
# gn/gn = POSTGRES_USER/POSTGRES_DB from .env
docker compose exec -T postgres pg_restore -U gn -d gn \
  --clean --if-exists < backups/gn-YYYYMMDD-HHMM.dump
docker compose start api web admin
```

A dump from the bucket: download it first (R2 dashboard, or
`aws s3 cp` with the backup token).

### Useful commands

```sh
docker compose logs -f api web caddy
docker compose exec postgres psql -U gn gn
docker compose run --rm migrate      # re-run migrations by hand
```

### Try it on a laptop

The production stack runs locally too, which is how it was tested.

1. Copy `.env.example` to a file **outside the repo**, set
   `WEB_DOMAIN=web.localhost`, `API_DOMAIN=api.localhost`,
   `ADMIN_DOMAIN=admin.localhost` and any `POSTGRES_PASSWORD`. Caddy
   serves `*.localhost` with its own local certificates.
2. Without real keys the API stops at startup on purpose. For a local
   run only, add an override file:

   ```yaml
   services:
     api:
       environment:
         NODE_ENV: development
     caddy:
       ports: !override
         - '8480:80'
         - '8443:443'
   ```

3. Start everything except `backup-offsite`:

   ```sh
   docker compose -p gn-local --env-file <file> -f compose.yml -f <override> \
     up -d --build caddy api migrate web admin postgres backup
   curl -k --resolve api.localhost:8443:127.0.0.1 https://api.localhost:8443/health
   ```

4. Clean up with `docker compose -p gn-local down -v`.
