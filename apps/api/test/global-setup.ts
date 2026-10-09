import postgres from 'postgres';
import { createDb } from '../src/db/db.js';
import { runMigrations } from '../src/db/migrate.js';
import { seedCatalog } from '../src/db/seed.js';
import { TEST_DATABASE_URL } from './test-db.js';

/** Creates the test database if needed, migrates it and seeds the catalog. */
export default async function setup() {
  const url = new URL(TEST_DATABASE_URL);
  const name = url.pathname.slice(1);
  const admin = postgres({ ...parse(url), database: 'postgres', onnotice: () => {} });
  const [exists] = await admin`select 1 from pg_database where datname = ${name}`;
  if (!exists) await admin.unsafe(`create database "${name}"`);
  await admin.end();

  await runMigrations(TEST_DATABASE_URL);
  const { client, db } = createDb(TEST_DATABASE_URL);
  await seedCatalog(db);
  await client.end();
}

function parse(url: URL) {
  return {
    host: url.hostname,
    port: Number(url.port || 5432),
    username: decodeURIComponent(url.username),
    password: decodeURIComponent(url.password),
  };
}
