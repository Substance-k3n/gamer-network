import { migrate } from 'drizzle-orm/postgres-js/migrator';
import { fileURLToPath } from 'node:url';
import { env } from '../env.js';
import { createDb } from './db.js';

/** Applies drizzle/*.sql in order. Used by `pnpm db:migrate`, tests and the deploy. */
export async function runMigrations(url: string) {
  const { client, db } = createDb(url);
  try {
    await migrate(db, {
      migrationsFolder: fileURLToPath(new URL('../../drizzle', import.meta.url)),
    });
  } finally {
    await client.end();
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  await runMigrations(env.databaseUrl);
  console.info('migrations applied');
}
