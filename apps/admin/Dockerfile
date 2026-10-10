# Production image for apps/admin (docs/DEPLOY.md).
# Build context: the repo root (pnpm workspace and its lockfile).

FROM node:22-alpine AS build
RUN corepack enable
WORKDIR /repo
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
COPY apps/admin/package.json apps/admin/
COPY packages/api-spec/package.json packages/api-spec/
RUN pnpm install --frozen-lockfile --filter @app/admin... --ignore-scripts
COPY packages/api-spec packages/api-spec
COPY apps/admin apps/admin
ENV NEXT_TELEMETRY_DISABLED=1
RUN pnpm --filter @app/admin build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 PORT=3001 HOSTNAME=0.0.0.0
# Standalone output keeps the monorepo layout: server.js lives under
# apps/admin and its static assets must sit beside it.
COPY --from=build --chown=node:node /repo/apps/admin/.next/standalone ./
COPY --from=build --chown=node:node /repo/apps/admin/.next/static ./apps/admin/.next/static
USER node
EXPOSE 3001
CMD ["node", "apps/admin/server.js"]
