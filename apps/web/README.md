# apps/web — Next.js: share pages

Owner: Kidus (ADR-0002). Moderation lives in `apps/admin`.

| Path                           | What                                                                                           |
| ------------------------------ | ---------------------------------------------------------------------------------------------- |
| `/l/[id]`                      | Public share page for a listing, from `GET /v1/public/listings/{id}`. "Open in app" on Android |
| `/l/[id]/opengraph-image`      | The 1200×630 preview Telegram and WhatsApp show under the link                                 |
| `/privacy`                     | Privacy policy (the Play listing links here). Keep it in step with docs/DATA_MODEL.md          |
| `/.well-known/assetlinks.json` | Android App Links, so the app opens `/l/<id>` itself. `[]` until `ANDROID_CERT_SHA256` is set  |
| `/`                            | One-screen landing with "Get the app"                                                          |

API types are generated from `@app/api-spec` into `src/lib/api.gen.ts`
(git-ignored) by `pnpm api-types`, which `dev`, `build` and `typecheck`
run first.

## Run it

```bash
cp .env.example .env.local     # API_URL, PUBLIC_WEB_URL, Android and Play settings
pnpm --filter @app/api dev     # the API on :3300
pnpm --filter @app/web dev     # this site on :3000
```

Post a listing through the API and open its `shareUrl`. Listings that
are removed, or whose owner is banned or deleted, answer 404.
