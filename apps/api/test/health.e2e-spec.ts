import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createTestApp } from './app.js';

describe('GET /health', () => {
  let app: INestApplication<App>;
  beforeAll(async () => ({ app } = await createTestApp()));
  afterAll(() => app.close());

  it('answers 200 once the database answers, outside /v1', () =>
    request(app.getHttpServer())
      .get('/health')
      .expect(200)
      .expect({ status: 'ok', database: 'ok' }));
});
