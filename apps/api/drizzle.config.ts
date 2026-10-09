import { defineConfig } from 'drizzle-kit';

// ADR-0006: migrations are generated into ./drizzle and reviewed as SQL.
export default defineConfig({
  dialect: 'postgresql',
  schema: './src/db/schema/index.ts',
  out: './drizzle',
  dbCredentials: { url: process.env.DATABASE_URL ?? 'postgres://gn:password@localhost:5470/gn' },
  casing: 'snake_case',
  strict: true,
});
