# apps/admin — moderation dashboard

Next.js (App Router). A 1:1 port of the "Rally Admin" design from the
rally prototype: Overview, Reports, Users, Games & ranks, Groups, and the
player drawer.

```bash
pnpm --filter @app/admin dev    # http://localhost:3001
```

All data is mock (`src/admin/data.ts`) and all state is client-side
(`src/admin/state.ts`). The API side is done: see "Admin" in
[docs/API.md](../../docs/API.md). Wiring, screen by screen:

| Screen        | Endpoints                                                             |
| ------------- | --------------------------------------------------------------------- |
| Sign in       | `POST /v1/auth/login`; non-admins get `403 admin_only` on the rest    |
| Overview      | `GET /v1/admin/metrics?from=&to=`                                     |
| Reports       | `GET /v1/admin/reports`, `POST /v1/admin/reports/{id}/resolve`        |
| Users, drawer | `GET /v1/admin/users`, `GET /v1/admin/users/{id}`, `…/ban`, `…/unban` |
| Games & ranks | `GET /v1/games`, `PATCH /v1/admin/games/{id}`                         |
| Groups        | stays mock (not in the MVP)                                           |

Make your account an admin locally with
`pnpm --filter @app/api admin:grant <email>`.

```
src/
├── app/            layout (fonts: Doto, Space Grotesk, Space Mono) + page
└── admin/
    ├── tokens.ts   colors, fonts, shared styles from the design
    ├── data.ts     mock users, reports, games, groups
    ├── state.ts    dashboard state and moderation actions
    ├── ui.tsx      Chip and button styles
    └── screens/    one file per screen, plus the player drawer
```
