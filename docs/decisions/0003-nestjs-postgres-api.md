# ADR-0003: NestJS + PostgreSQL, with a generated OpenAPI spec as the contract

**Status:** Accepted (2026-10-08)

## Context

Two clients (Flutter and the Next.js site) talk to one API. abro was
rewritten from NestJS to Go by preference, not for a technical reason
(abro ADR-007). This ADR exists so that doesn't happen again without one.

## Decision

- `apps/api`: NestJS on PostgreSQL. Swagger decorators generate
  `packages/api-spec/openapi.json`, committed to the repo.
- `apps/mobile` generates its Dart client from that file;
  `apps/web` generates TypeScript types from it.
- CI fails if the committed spec is out of date with the API.

## Alternatives considered

- Go (as in abro): fast and small, but the spec would be hand-written or
  annotation-driven, and the web/admin side loses shared TypeScript.
- Firebase/Supabase as the whole backend: fastest start, but moderation,
  expiry and matching rules end up spread across clients and policies.

## Consequences

- Any API change shows up as a diff in `openapi.json`, which both owners
  review (CODEOWNERS). That diff is the conversation between backend and
  mobile.
- Switching backend language needs a new ADR with a reason.
