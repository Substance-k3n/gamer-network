# ADR-0006: Drizzle for the database layer, migrations as reviewed SQL

**Status:** Accepted (2026-10-08)

## Context

`apps/api` needs a way to define the schema in DATA_MODEL.md, run
migrations and query Postgres from NestJS 12 (ESM). The schema relies on
Postgres features: enums, partial unique indexes, composite foreign keys,
check constraints, `citext`.

## Decision

Drizzle ORM with `drizzle-kit`:

- The schema is TypeScript in `apps/api/src/db/schema/`, one file per
  area (identity, catalog, profile, listings, relationships,
  notifications, safety).
- `drizzle-kit generate` writes plain SQL migrations into
  `apps/api/drizzle/`. They are committed and **reviewed as SQL** in the
  PR. Hand-edit them when Drizzle can't express something (e.g. a check
  constraint it doesn't model).
- Migrations run as a one-shot step before the API starts in production,
  like abro's `migrate` service.
- Tests run against a real Postgres (CI service container), never mocks.

## Alternatives considered

- **Prisma:** popular with NestJS and a nicer schema file, but partial
  indexes and composite FKs to non-PK columns need raw SQL anyway, and
  its generated client adds a build step and a bigger image.
- **TypeORM:** the old Nest default; decorators-on-entities hide the SQL
  and its migrations are easy to get wrong.
- **Kysely or raw SQL:** full control, but we'd hand-write the schema
  types that Drizzle gives us.

## Consequences

- Queries read close to SQL, so what the database does stays visible.
- A schema change is one PR with the TS schema, the generated SQL and the
  DATA_MODEL.md update.
