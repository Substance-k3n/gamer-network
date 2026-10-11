# Production image for apps/api (ADR-0003, ADR-0004, docs/DEPLOY.md).
# Build context: the repo root (pnpm workspace and its lockfile).
# The same image runs the API (default) and the migrate step
# (`node dist/db/migrate.js && node dist/db/seed.js`).

FROM node:22-alpine AS build
RUN corepack enable
WORKDIR /repo
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY apps/api/package.json apps/api/
RUN pnpm install --frozen-lockfile --filter @app/api --ignore-scripts
COPY apps/api apps/api
RUN pnpm --filter @app/api build \
 && pnpm --filter @app/api deploy --legacy --prod /out

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production PORT=3300
COPY --from=build --chown=node:node /out/node_modules ./node_modules
COPY --from=build --chown=node:node /out/package.json ./
COPY --from=build --chown=node:node /repo/apps/api/dist ./dist
COPY --from=build --chown=node:node /repo/apps/api/drizzle ./drizzle
USER node
EXPOSE 3300
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD wget -qO- http://127.0.0.1:3300/health || exit 1
CMD ["node", "dist/main.js"]
