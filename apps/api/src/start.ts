// Render's entry point (render.yaml): free instances have no pre-deploy
// step, so the schema and the game catalog are brought up to date here,
// from the same image as the code, before the API starts listening.
import { createDb } from './db/db.js';
import { runMigrations } from './db/migrate.js';
import { seedCatalog } from './db/seed.js';
import { env } from './env.js';

await runMigrations(env.databaseUrl);
console.info('migrations applied');
const { client, db } = createDb(env.databaseUrl);
console.info(`seeded ${await seedCatalog(db)} games`);
await client.end();

await import('./main.js');
