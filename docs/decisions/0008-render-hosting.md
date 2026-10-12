# ADR-0008: Host on Render instead of our own VPS

**Status:** Accepted (2026-10-11). Supersedes ADR-0004. Database amended
by ADR-0010.

## Context

ADR-0004 picked a ~$5/month VPS so the app never "doesn't open" on a
sleeping free host. The stack for it exists (`infra/docker/prod`), but
running a server ourselves (updates, disk, backups, certificates) is
work neither of us wants before the beta.

## Decision

API, share pages, admin and Postgres run on Render, described by
`render.yaml` at the repo root (a Blueprint), in the Frankfurt region
(closest to Ethiopia). `main` auto-deploys; the API runs the migrations
and the game seed when it starts, from the same image as the code.
Everything starts on the **free tier**, to pay nothing until there are
users. Avatars stay in an S3 bucket outside Render (ADR-0009).

## Alternatives considered

- **Keep the VPS (ADR-0004).** Cheaper, but we own the server.
- **Render paid instances from day one** (`starter`, about $27/month
  with Postgres). Nothing sleeps, but it costs money before there are
  any users. It's a plan change away when the beta starts.

## Consequences

- $0 for now, with the cost ADR-0004 warned about: services sleep after
  15 minutes and take about a minute to wake, and timed jobs pause while
  the API sleeps. Before real users arrive, move `gn-api` and `gn-web`
  to `starter` (about $7/month each).
- The free database expires 30 days after creation and has no backups.
  ADR-0010 moves Postgres to Neon instead.
- Free services can't receive private-network traffic, so web and admin
  call the API on its public URL.
- `infra/docker/prod` stays for running the production images locally,
  and as the way back to a VPS.
