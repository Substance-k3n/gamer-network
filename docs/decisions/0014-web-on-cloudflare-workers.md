# ADR-0014: The web app on Cloudflare Workers, the API alone on Render free

**Status:** Accepted (2026-10-24). Amends ADR-0008's hosting for `gn-web`
and `gn-admin`.

## Context

We run a two-month trial on $0 before paying for hosting. On Render free
every service sleeps after 15 minutes; a cold open of the PWA waited
about 17 s for `gn-web` and then about 24 s for `gn-api`. A free uptime
ping can keep only one service awake: Render gives an account 750 free
instance hours a month, one service awake all month uses about 744, and
running out suspends every free service until the month ends. The API
also needs to stay awake for its timed jobs (`src/jobs`) to run.

## Decision

- `gn-web` runs on Cloudflare Workers' free plan through OpenNext
  (`@opennextjs/cloudflare`), deployed with `wrangler`. Workers don't
  sleep, and Cloudflare serves them from Addis Ababa.
- `gn-admin` isn't deployed during the trial. It builds for Workers the
  same way (about 1.0 MB) and goes there when moderation needs it.
- `gn-api` stays on Render free, kept awake by a cron-job.org ping of
  `/health` every 10 minutes. It is the only Render service.
- Postgres stays on Neon (ADR-0010) and avatars on B2 (ADR-0009).

The API stays a Node server: `@node-rs/argon2` is a native module,
`firebase-admin` needs Node, and the jobs run on in-process timers, none
of which run on Workers without a rewrite.

## Alternatives considered

- **Everything on Render free.** Only one service can stay awake; the
  others cold start on every quiet spell.
- **The API on Workers too.** A rewrite of auth, push and jobs, outside
  the PRD.
- **Paid hosting now** (Render `starter` for the API, or a VPS with
  `infra/docker/prod`). The fix once the trial shows the app is worth
  it; not before.

## Consequences

- $0. Workers' free plan caps the compressed bundle at 3 MB (web is
  about 2.0 MB) and the CPU per request; going over means Workers Paid,
  about $5/month.
- No moderation dashboard until the admin is deployed: reports wait in
  the database (ADR-0005).
- The web URL moves to `gn-web.rally-et.workers.dev`: `PUBLIC_WEB_URL` and
  `WEB_ORIGINS` on the API, and the mobile app's share links and App
  Links, change with them.
- Two hosts to deploy: Render follows `main` for the API; the web
  deploys with `wrangler` (`pnpm --filter @app/web deploy:cf`).
- Neon's free compute is shared with the `/health` ping; watch its usage
  page during the trial.
