import { ServiceUnavailableException } from '@nestjs/common';
import type { Db } from '../db/db.js';
import { HealthController } from './health.controller.js';

const fakeDb = (execute: () => Promise<unknown>) => ({ execute }) as unknown as Db;

describe('HealthController', () => {
  it('reports ok when the database answers', async () => {
    const controller = new HealthController(fakeDb(async () => [{ '?column?': 1 }]));
    await expect(controller.check()).resolves.toEqual({ status: 'ok', database: 'ok' });
  });

  it('answers 503 when the database is down', async () => {
    const controller = new HealthController(
      fakeDb(async () => {
        throw new Error('connection refused');
      }),
    );
    await expect(controller.check()).rejects.toBeInstanceOf(ServiceUnavailableException);
  });
});
