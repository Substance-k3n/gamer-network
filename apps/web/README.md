# apps/web — Next.js: share pages + admin

Owner: Kidus (ADR-0002).

Not scaffolded yet. Two jobs only:

- `/l/[id]` public share page for a listing: Open Graph preview for
  Telegram/WhatsApp, "Open in app" (Android App Link) or "Get the app".
- `/admin` behind login: reports queue, remove content, ban accounts.

API types come from `@app/api-spec`.
