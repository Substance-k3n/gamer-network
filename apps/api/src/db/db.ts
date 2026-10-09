import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema/index.js';

export function createDb(url: string) {
  const client = postgres(url, { max: 10, onnotice: () => {} });
  const db = drizzle(client, { schema, casing: 'snake_case' });
  return { client, db };
}

export type Db = ReturnType<typeof createDb>['db'];
/** A transaction handle: has the same query API as Db. */
export type Tx = Parameters<Parameters<Db['transaction']>[0]>[0];
