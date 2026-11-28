# ADR-0015: rally is for chess players, online on Chess.com and Lichess

**Status:** Accepted (2026-11-25). Narrows the PRD's "two or three games"
to one, and replaces the squad-game model the apps were built around.

## Context

The MVP was shaped around mobile squad games (PUBG Mobile, CoD Mobile,
eFootball): listings ask for a party size and voice chat, platforms are
PC / PlayStation / Xbox / mobile / Switch, and gaming IDs are Riot,
Steam, Discord and the like. The live catalog is down to one game
(PUBG Mobile), and the community we are launching with plays chess.

## Decision

- **One game: Chess** (`id: chess`). It is the only game in the seed and,
  once it is live, PUBG Mobile is deleted through the admin (it leaves
  every profile and its live listings close; old posts keep history).
- **Where they play: Chess.com and Lichess** (`chess_com`, `lichess`), as
  the platforms on a profile and a listing. Over the board is out for now.
- **Ladder: rating bands**, tier 0 → 4: Beginner (under 1000),
  1000–1399, 1400–1799, 1800–2199, 2200+. They work whichever site the
  rating is from; admins can edit them (`/v1/admin/games/chess/ranks`).
- **Modes are time controls**: Bullet, Blitz, Rapid, Classical. The
  listing's style reads as Rated (`competitive`) or Casual (`casual`).
- **Every game is 1v1.** A listing's `partySize` is 2 and `voice` is
  `optional` by default, and the apps don't ask for either.
- **Gaming IDs are a Chess.com and a Lichess username** (`chess_com`,
  `lichess` kinds), so an opponent can send the challenge.
- **Groups** keep their kinds; the apps call `squad` a Club.
- The old platform and gaming-ID values stay in the database enums, so
  history still reads, but the API no longer accepts them as input.

## Alternatives considered

- **Keep the squad fields and add Chess as one more game.** Fast, but
  every listing would ask for a party size and a mic, which chess
  doesn't have.
- **Over the board too.** Clubs and cafés matter in Addis, but a
  listing would need a meeting place and safety rules; it waits.
- **Titles (CM, FM, IM, GM) as the ladder.** Almost everyone would be
  "untitled".

## Consequences

- The PRD's "which 2–3 games" question is answered: chess.
- API, spec, mobile, PWA and admin all change, as separate PRs (API
  first). Tests move from the squad catalog to Chess.
- Players who had PUBG Mobile on their profile lose it when it's deleted.
