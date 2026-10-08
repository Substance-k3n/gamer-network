# ADR-0004: Pay for a small VPS from day one

**Status:** Accepted (2026-10-08)

## Context

abro's free hosting slept when idle, so the first open was slow. For a
social app, "it didn't open" on day one loses the user for good.

## Decision

API, Postgres and the web site run on one ~$5/month VPS with Docker
Compose and Caddy (automatic HTTPS), reusing abro's `infra/docker/prod`
pattern. Profile photos go to Cloudflare R2. Daily `pg_dump` backups,
copied off the server.

## Consequences

- About $5–10/month plus $25 once for Google Play. Needs a card that pays
  abroad.
- We run the server ourselves: updates, backups and disk space are on us.
