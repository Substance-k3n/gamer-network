import { readFileSync } from 'node:fs';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { serveOpenApi } from '../src/openapi.js';
import { createTestApp } from './app.js';

const committed = JSON.parse(
  readFileSync(new URL('../../../packages/api-spec/openapi.json', import.meta.url), 'utf8'),
);

describe('GET /openapi.json', () => {
  let app: INestApplication<App>;
  beforeAll(async () => {
    ({ app } = await createTestApp());
    serveOpenApi(app);
  });
  afterAll(() => app.close());

  it('serves every operation of the committed spec, outside /v1', async () => {
    const res = await request(app.getHttpServer())
      .get('/openapi.json')
      .expect(200)
      .expect('Content-Type', /application\/json/);
    // Schema bodies come from the nest build plugin, which vitest skips,
    // so compare the operations; CI's spec check covers the rest.
    const operations = (doc: { paths: Record<string, object> }) =>
      Object.entries(doc.paths).flatMap(([path, item]) =>
        Object.keys(item).map((method) => `${method} ${path}`),
      );
    expect(operations(res.body).sort()).toEqual(operations(committed).sort());
  });

  it('documents a summary and the error shape on every operation', () => {
    type Operation = { summary?: string; responses: Record<string, unknown> };
    const paths: Record<string, Record<string, Operation>> = committed.paths;
    const missing = Object.entries(paths).flatMap(([path, item]) =>
      Object.entries(item)
        .filter(([, op]) => !op.summary || !op.responses.default)
        .map(([method]) => `${method} ${path}`),
    );
    expect(missing).toEqual([]);
  });
});
