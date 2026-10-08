# Product: gamer-network MVP

Last updated 2026-10-08. Replaces the scope in the 2026-10-07 brief where
the two differ; the prototype ("rally") stays the visual reference.

## The bet

Gamers in Addis Ababa will use an app to find people to play with, and
those connections turn into real games played together.

The biggest risk is not the tech. It is the empty room: someone posts
"looking for a duo tonight", nobody answers, they never come back. So the
MVP launches narrow and dense: **one city, two or three games, 50–100
gamers from communities that already exist.**

## Who it's for

Ethiopian gamers aged 16+ who want regular teammates, starting with
mobile games people in Addis already play together (likely PUBG Mobile,
Call of Duty Mobile, eFootball — confirmed by the validation test in
[validation-test.md](validation-test.md) before we choose).

## MVP scope

| In                                                                            | Why                                        |
| ----------------------------------------------------------------------------- | ------------------------------------------ |
| Sign-up: Google, or a code sent by email                                      | SMS costs per message                      |
| Gamer profile: games, rank per game, platforms, gaming IDs, region, age range | The thing people match on                  |
| Find Players: post a listing (game, mode, time, slots), it expires            | The core loop                              |
| Browse and filter listings (game, rank, time, region)                         |                                            |
| Connection requests: ask to join a listing, owner accepts                     | Gaming IDs unlock on accept                |
| Push notifications (FCM)                                                      | Without them nobody sees a reply in time   |
| "Did you play together?" check-in the next day                                | **The metric**                             |
| Block and report; admin can remove content and ban                            | Safety, and Google Play requires it        |
| Share a listing as a link with a proper preview                               | How the app spreads (Telegram, WhatsApp)   |
| Groups tab as "coming soon" with a waitlist                                   | Cheap, and tells us which groups to launch |

**Out until the bet is proven:** home feed, posts, comments, clips,
search beyond players, game pages (games are a filter, not a screen),
iPhone app, groups, rank verification through game APIs.

## The number that matters

**Share of listings that end in at least one "yes, we played".**
Asked once, the day after a connection is accepted, to both people.

Secondary: listings that get at least one request within an hour;
week-2 return rate.

## Milestones

1. **Foundations (weeks 0–2):** repo, this PRD, ADRs, design system from
   the prototype, MVP API spec, validation test running in parallel.
2. **Build (≈6 weeks):** auth, profile, listings, connections,
   notifications, share pages, admin moderation.
3. **Closed beta:** 50–100 gamers from one community, measured on the
   number above.
4. **Only if it works:** feed, game pages, iPhone, groups.

## Open

- The real name, before the Play Store listing.
- Which 2–3 games (validation test).
