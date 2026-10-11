# ADR-0008: Host on Render instead of our own VPS

**Status:** Accepted (2026-10-11). Supersedes ADR-0004.

## Context

ADR-0004 picked a ~$5/month VPS so the app never "doesn't open" on a
sleeping free host. The stack for it exists (`infra/docker/prod`), but
running a server ourselves (updates, disk, backups, certificates) is
work neither of us wants before the beta.

## Decision

API, share pages, admin and Postgres run on Render, described by
`render.yaml` at the repo root (a Blueprint), in the Frankfurt region
(closest to Ethiopia). `main` auto-deploys; migrations and the game seed
run as the API's pre-deploy command, from the same image. Services are on
paid instances (`starter`), so nothing sleeps: ADR-0004's reason still
holds, it is just met differently. Avatars stay on Cloudflare R2.

## Alternatives considered

- **Keep the VPS (ADR-0004).** Cheaper, but we own the server.
- **Render free instances.** They sleep after 15 minutes, and free
  Postgres expires after 30 days: the exact problem ADR-0004 avoided.

## Consequences

- About $27/month (three `starter` services + `basic-256mb` Postgres)
  instead of $5–10. Plans can change per service in the dashboard; admin
  is the first to drop to free if we need to save money.
- Backups are Render's daily Postgres backups; the R2 off-site copy from
  ADR-0004 is not running. Add a Render cron job if we want one.
- `infra/docker/prod` stays for running the production images locally,
  and as the way back to a VPS.
