# ADR-0012: The prototype's feed, groups and Moments join the MVP

**Status:** Accepted (2026-10-16). Amends ADR-0001 (the MVP grows past
Find Players) and the PRD's "Out" list (home feed, posts, comments,
clips, groups).

## Context

ADR-0001 kept the MVP to Find Players, with Groups as a "coming soon" tab
and a waitlist, so a dead-looking feed couldn't hide whether the core
loop works. The PRD puts the feed and groups after the closed beta,
"only if it works".

Since then the Find Players API is complete and every app uses it
(`docs/missing-api.md`: no API gaps left). The rally prototype
(`Natnsis/rally`) has a Home feed, a composer with 11 post types,
comments, Groups with events, and profile Moments, and those screens are
what remains between the apps and the prototype.

[FEED_AND_GROUPS_API.md](../FEED_AND_GROUPS_API.md) writes them up as an
API to build: tables, endpoints, notifications, moderation, tests and a
five-phase build order.

## Decision

- Build the API in `FEED_AND_GROUPS_API.md`, in its phases, one API PR
  per phase, then the screens in separate PRs.
- Ship it dark: `GET /v1/app/config` gains `feedEnabled` and
  `groupsEnabled`, and the apps show Home and Groups only when they're
  true. Today's screens stay as the fallback.
- Moderation (reports, admin removal, blocks, bans) ships with posting,
  as ADR-0005 requires.
- Section 11 of that file is answered as it suggests:
  - "For you" is newest first, not ranked;
  - the feed covers everyone, not only the viewer's city;
  - no editing posts (delete and post again);
  - any player with a verified email can create groups (3 a day), and
    admins can remove them;
  - any member can add events, and group admins can delete them;
  - no profanity filter: we rely on reports;
  - listings don't appear as feed cards, for now;
  - video waits for a check of B2 egress and Render's limits before
    phase 2, with clips capped at 60 s and 50 MB.

## Alternatives considered

- Keep ADR-0001 as it is: build nothing until the closed beta shows
  listings ending in games played. Cheapest, and it keeps the metric
  clean, but the apps stay short of the prototype.
- Groups only (the waitlist already says which ones people want), feed
  later.
- Show listings as cards in a feed instead of posts: helps an empty feed
  at launch, without a second content type.

## Consequences

- The biggest scope change since ADR-0001: about 15 new tables, 40
  endpoints, media uploads (including video bandwidth on B2 and Render)
  and a new moderation surface.
- With the flags off until the beta's number is in, the feed can't hide
  whether Find Players works; switching them on early would.
- `docs/PRD.md` and the README's ADR list change when this is accepted.
