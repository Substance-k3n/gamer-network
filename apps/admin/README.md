# apps/admin — moderation dashboard

Next.js (App Router). A 1:1 port of the "Rally Admin" design from the
rally prototype: Overview, Reports, Users, Games & ranks, Groups, and the
player drawer.

```bash
pnpm --filter @app/admin dev    # http://localhost:3001
```

All data is mock (`src/admin/data.ts`) and all state is client-side
(`src/admin/state.ts`). Nothing reaches the API yet; wire each action to
`@app/api-spec` once the moderation endpoints exist.

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
