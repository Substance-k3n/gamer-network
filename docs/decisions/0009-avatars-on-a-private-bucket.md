# ADR-0009: Avatars on any S3 bucket, private by default, with signed reads

**Status:** Accepted (2026-10-12). Amends ADR-0008 ("Avatars stay on
Cloudflare R2").

## Context

Avatars were planned for a public Cloudflare R2 bucket. Both R2 and
Backblaze B2 ask for a card before they serve a bucket publicly, and we
want to start on $0 without one. We already run a B2 account for another
project.

## Decision

Avatars live in any S3-compatible bucket (B2 for the first deploy). When
`MEDIA_PUBLIC_URL` is empty the bucket is private and the API returns
signed `GET` URLs: signed as of the start of the UTC day and valid for two
days, so a URL stays the same all day and phones can cache the image.
Setting `MEDIA_PUBLIC_URL` switches back to plain public URLs. The database
stores only the object key, so moving buckets is a copy plus new settings.

## Alternatives considered

- **Public bucket (R2 or B2).** Simplest, but needs a card on file.
- **Serve images through the API.** Every image would wake a sleeping
  free instance and use its bandwidth.

## Consequences

- Avatar URLs change once a day; clients refetch then.
- An avatar URL handed out keeps working up to two days after the avatar
  is removed or replaced.
