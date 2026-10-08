# gamer-network

Read `README.md` for the layout and `docs/PRD.md` for scope. Decisions
live in `docs/decisions/` — follow them, or propose a new ADR; don't
quietly diverge.

- Load `.claude/skills/gn-git-workflow` before any git action. Never credit
  an AI anywhere.
- Scope discipline: if it isn't in the PRD's "In" table, it waits (ADR-0001).
- `packages/api-spec/openapi.json` is generated; never hand-edit it.
