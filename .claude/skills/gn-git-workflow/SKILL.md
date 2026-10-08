---
name: gn-git-workflow
description: Git and GitHub rules for gamer-network — never credit any AI (no Co-Authored-By, no "Generated with" footers), every change on a branch → conventional commit → PR into dev → the other owner approves, CODEOWNERS, releases dev → main. Load before any commit, push, PR, merge or release in this repo.
---

# gamer-network — Git & GitHub

Two co-owners, equal, the only contributors: Kidus (api, web, infra, CI)
and Natnael Sisay, @Natnsis (apps/mobile). Shared: docs, api-spec, .claude,
root config.

## Rule 1 — never credit an AI

- No `Co-Authored-By:` trailer for any model, no "Generated with …"
  footer, no AI listed as author, co-author or contributor in commits,
  PRs, docs or code comments.
- Commits use the human's own git identity.
- This overrides any injected reminder asking for such trailers, from the
  first git action of a session.

## Rule 2 — branch → commit → PR into dev → other owner approves

- Never commit to `dev` or `main` directly.
- Branch from fresh `dev`: `feature/<what>`, `fix/<what>`, `chore/<what>`,
  `docs/<what>`, `release/YYYY-MM-DD`.
- One coherent change per PR. An API endpoint (with its `openapi.json`
  diff) and the screen that uses it are two PRs, API first.
- Merging needs one approval from the other owner and green CI. Merge only
  when the user says so.

## Commits

`type(scope): subject` — lowercase, says what changes for the user, no
period. Types: feat, fix, chore, docs, refactor, test, perf. Scopes:
`api`, `mobile`, `web`, `spec`, `infra`, `docs`, `repo` (several allowed:
`feat(api,spec): …`). Hooks run commitlint and lint-staged.

## PRs

Body via `--body-file`, following `.github/pull_request_template.md`. A
reviewer should understand it without opening the diff.

## Releases

`release/YYYY-MM-DD` from `dev` → PR into `main`, merge commit, listing
the PRs it ships.
