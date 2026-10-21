# ADR-0013: The apps show the prototype's feed, groups and profile without waiting for the flags

**Status:** Proposed (2026-10-19). Amends ADR-0012's "ship it dark".

## Context

ADR-0012 brought the prototype's Home feed, Groups and Moments into the
MVP, built in phases, and said the apps show them only when
`GET /v1/app/config` returns `feedEnabled` / `groupsEnabled` true, with
today's screens as the fallback.

Phase 1 of the feed API (text posts, comments, GG, saves, Moments, share
page, admin removal) is merged and live. Groups has no API yet. The mobile
app and the PWA still show the Find-Players-only screens the integration
cut them down to: a Home without a feed, Groups as "coming soon", and a
profile without Groups, Posts and Moments.

## Decision

- The mobile app and the PWA show the prototype's screens again, always,
  ignoring `feedEnabled` and `groupsEnabled`:
  - Home is the timeline feed, with the composer and comments, on the feed
    API. What the MVP Home had (verify-email nudge, play invites,
    check-ins, your live listing) stays, pinned above the posts; your
    status and play days move to your profile.
  - The composer offers the eight text types the API accepts. Gameplay
    (media), polls and recruitment appear when their API phases ship.
  - Groups (discover, group page, events, create) runs on sample data kept
    on the device until the groups API exists. Nothing about groups is sent
    to the server, and sample members aren't real players.
  - The profile is back to the prototype's layout: Overview, Games, Groups,
    Posts, Moments (and Connections on your own).
- The flags stay in the API for now. A later ADR either removes them or
  uses them again for groups once its API exists.

## Alternatives considered

- Keep ADR-0012 as written: switch `feedEnabled` on in production instead.
  It shows the feed without app changes, but Groups and the profile tabs
  stay cut until the groups API ships.
- Show Groups only once its API exists, and the feed now. Avoids sample
  data that looks real, but leaves the Groups tab as "coming soon".

## Consequences

- The feed is visible to every player at once, so the closed beta's
  "listings that end in games played" number now has a feed next to it
  (the risk ADR-0001 and ADR-0012 named).
- Groups looks live but does nothing beyond the device. Groups and members
  reset when the app restarts. The waitlist is no longer offered.
- When the groups API lands, the apps swap the sample store for API calls;
  the screens stay.
