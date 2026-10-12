# ADR-0010: Postgres on Neon's free tier, not Render's

**Status:** Accepted (2026-10-12). Amends ADR-0008's database.

## Context

Render's free Postgres is deleted 30 days after it is created unless
upgraded (about $6/month). We want the beta to run on $0 without a
deadline.

## Decision

Production Postgres is a Neon project (Postgres 17, AWS Frankfurt, next
to Render's Frankfurt region). `gn-api` gets Neon's direct (not pooled)
connection string as `DATABASE_URL`; direct, because the API holds its
own small pool and uses advisory locks for jobs. Nothing in the code
changes: it is plain Postgres over TLS.

## Alternatives considered

- **Render free Postgres.** Same dashboard, but expires in 30 days.
- **Render paid Postgres.** About $6/month before there are users.
- **Supabase.** Also free, but pauses projects after a week without use.

## Consequences

- No expiry. 0.5 GB of storage; the database pauses when idle and the
  first query after that waits a moment.
- The API reaches the database over the public internet with TLS rather
  than Render's private network.
- Neon's free restore history is short: we still take `pg_dump`s
  ourselves (docs/DEPLOY.md §3).
