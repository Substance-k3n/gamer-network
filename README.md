# gamer-network

Working name. A place for gamers in Ethiopia to find people to actually play
with. The real brand comes before the Play Store listing.

The MVP proves one thing: **two gamers who connect here go on to play
together.** Everything else waits. See [docs/PRD.md](docs/PRD.md).

## Layout

```
gamer-network/
├── apps/
│   ├── api/            NestJS + PostgreSQL. The only thing that talks to the DB.
│   ├── mobile/         Flutter app, Android first. The product.
│   └── web/            Next.js: listing share pages + admin (moderation).
├── packages/
│   └── api-spec/       openapi.json generated from apps/api. The contract
│                       between the API and both clients.
├── infra/              Docker Compose for local dev and the production VPS.
├── docs/               PRD, decisions (ADRs), validation test.
└── .claude/skills/     How we work, for anyone (or any session) picking it up.
```

| Area                                                | Owner                       |
| --------------------------------------------------- | --------------------------- |
| `apps/mobile`                                       | Natnael Sisay (@Natnsis)    |
| `apps/api`, `apps/web`, `infra`, `.github`          | Kidus Ezra (@Substance-k3n) |
| `packages/api-spec`, `docs`, `.claude`, root config | Both                        |

`.github/CODEOWNERS` enforces this: a PR asks the owner of each folder it
touches for review, and merging into `dev` or `main` needs one approval
from the other person.

## Why it looks like this

The short version is in [docs/decisions](docs/decisions). The biggest
calls:

1. [ADR-0001](docs/decisions/0001-mvp-is-find-players-only.md) MVP is Find Players, not a social feed.
2. [ADR-0002](docs/decisions/0002-flutter-android-first.md) Flutter app, Android first. Web is only for share pages and admin.
3. [ADR-0003](docs/decisions/0003-nestjs-postgres-api.md) NestJS + Postgres, with the OpenAPI spec as the contract.
4. [ADR-0004](docs/decisions/0004-paid-vps-hosting.md) A paid VPS from day one, so the app never "doesn't open".
5. [ADR-0005](docs/decisions/0005-safety-defaults.md) 16+, block and report, gaming IDs private by default.
6. [ADR-0006](docs/decisions/0006-drizzle-orm.md) Drizzle for the database, migrations reviewed as SQL.

## Docs

| File                                               | For                                                     |
| -------------------------------------------------- | ------------------------------------------------------- |
| [docs/PRD.md](docs/PRD.md)                         | What the MVP is and the number that decides if it works |
| [docs/BUILD_PLAN.md](docs/BUILD_PLAN.md)           | Phases from empty repo to closed beta, with status      |
| [docs/DATA_MODEL.md](docs/DATA_MODEL.md)           | Every table, enum and rule                              |
| [docs/API.md](docs/API.md)                         | Endpoints, conventions and how to wire the app          |
| [docs/validation-test.md](docs/validation-test.md) | The manual Telegram test                                |

## Getting started

Requirements: Node 22 (`nvm use`), pnpm 10, Docker, Flutter (stable).

```bash
pnpm install                                  # root tooling + git hooks
docker compose -f infra/docker/dev/compose.yml up -d   # Postgres on :5470
```

The apps themselves are scaffolded in their own PRs; each one's README
says how to run it.

## Branches and commits

- `main` is what's released, `dev` is where work lands. Never commit to
  either directly: branch, PR into `dev`, get the other person's approval.
- Conventional commits, enforced by a hook:
  `feat(api): listings expire after their end time`.
- No AI is credited anywhere: not as author, co-author or contributor, in
  commits, PRs or docs.
