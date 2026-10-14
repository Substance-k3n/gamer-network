# apps/web — Next.js: share pages and the player PWA

Owner: Kidus (ADR-0002, ADR-0011). Moderation lives in `apps/admin`.

| Path                              | What                                                                                           |
| --------------------------------- | ---------------------------------------------------------------------------------------------- |
| `/l/[id]`                         | Public share page for a listing, from `GET /v1/public/listings/{id}`. "Open in app" on Android |
| `/l/[id]/opengraph-image`         | The 1200×630 preview Telegram and WhatsApp show under the link                                 |
| `/privacy`                        | Privacy policy (the Play listing links here). Keep it in step with docs/DATA_MODEL.md          |
| `/.well-known/assetlinks.json`    | Android App Links, so the app opens `/l/<id>` itself. `[]` until `ANDROID_CERT_SHA256` is set  |
| `/`                               | One-screen landing: "Open the web app", "Get the app"                                          |
| `/app/*`                          | The player PWA (ADR-0011): every MVP screen of `apps/mobile`, the same four skins              |
| `/api/v1/*`                       | The PWA's proxy to the API: adds the session from the `gn_session` httpOnly cookie             |
| `/manifest.webmanifest`, `/sw.js` | Install and offline shell for the PWA                                                          |

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

## The player PWA (`/app`)

The same screens as `apps/mobile`, on the same API, in React. The browser
never sees the session token: sign-in answers go through `/api/v1/auth/*`,
which keeps the token in an httpOnly cookie and returns the rest, and every
other call goes through the same proxy (so no CORS). Code:

| Where                      | What                                                                   |
| -------------------------- | ---------------------------------------------------------------------- |
| `src/app/api/v1/[...path]` | The proxy; `/admin/*` stays unreachable from here                      |
| `src/app/app/_lib/`        | API client and types, state (`store.tsx`), the UI kit, sheets, profile |
| `src/app/app/app.css`      | The four skins as CSS variables, from `apps/mobile/lib/theme.dart`     |
| `src/app/app/*/page.tsx`   | One file per screen, named like the mobile ones                        |
| `public/sw.js`             | Caches built assets and the `/app` shell; never caches `/api/*`        |

Run it like the share pages above and open http://localhost:3000/app.
Locally the API prints email codes to its console instead of sending them.
