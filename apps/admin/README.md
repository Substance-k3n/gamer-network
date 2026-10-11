# apps/admin — moderation dashboard

Next.js (App Router). A 1:1 port of the "Rally Admin" design from the
rally prototype: Overview, Reports, Users, Games & ranks and the player
drawer.

```bash
cp .env.example .env.local      # API_URL
pnpm --filter @app/admin dev    # http://localhost:3001
```

Wired to the API ("Admin" in [docs/API.md](../../docs/API.md)); only
admins can sign in. The browser never holds the API token: `/api/session`
signs in through `POST /v1/auth/login` and keeps the token in an httpOnly
cookie, and `/api/v1/*` forwards the dashboard's calls (`admin/*`,
`games`, `me` only) with it. `API_URL` says where the API is
(`.env.example`). Types come from `@app/api-spec` (`pnpm api-types`,
run by `dev`, `build` and `typecheck`).

The screens show only what the API backs. Things in the design with no
API (suspend, warning history, reopen, rank reset, catalog editing,
Groups, the sign-up and city charts) are left out until moderating
needs them. Report severity is worked out from the reason
(`src/admin/data.ts`).

| Screen        | Endpoints                                                                            |
| ------------- | ------------------------------------------------------------------------------------ |
| Sign in       | `POST /v1/auth/login`; non-admins get `admin_only`                                   |
| Overview      | `GET /v1/admin/metrics?from=`, the open reports queue                                |
| Reports       | `GET /v1/admin/reports`, `POST /v1/admin/reports/{id}/resolve`                       |
| Users, drawer | `GET /v1/admin/users`, `GET /v1/admin/users/{id}`, `…/ban`, `…/unban`                |
| Games & ranks | `GET /v1/games`, `PATCH /v1/admin/games/{id}` (launch switch; the catalog is seeded) |

Make your account an admin locally with
`pnpm --filter @app/api admin:grant <email>`.

```
src/
├── app/            layout, page, /login, /api/session, /api/v1 proxy
├── server/         the session cookie (server only)
└── admin/
    ├── api.ts      fetch helper and API types
    ├── tokens.ts   colors, fonts, shared styles from the design
    ├── data.ts     labels, severity, dates
    ├── state.ts    dashboard state, the open queue, sign out
    ├── ui.tsx      Chip and button styles
    └── screens/    one file per screen, plus the player drawer
```
