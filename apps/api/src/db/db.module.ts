import { Global, Inject, Module, OnApplicationShutdown } from '@nestjs/common';
import type { Sql } from 'postgres';
import { env } from '../env.js';
import { createDb } from './db.js';

/** Inject with `@Inject(DB) private readonly db: Db`. */
export const DB = Symbol('DB');
const DB_CLIENT = Symbol('DB_CLIENT');

@Global()
@Module({
  providers: [
    { provide: DB_CLIENT, useFactory: () => createDb(env.databaseUrl) },
    { provide: DB, inject: [DB_CLIENT], useFactory: (c: ReturnType<typeof createDb>) => c.db },
  ],
  exports: [DB],
})
export class DbModule implements OnApplicationShutdown {
  constructor(@Inject(DB_CLIENT) private readonly conn: { client: Sql }) {}

  async onApplicationShutdown() {
    await this.conn.client.end({ timeout: 5 });
  }
}
