import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createTestApp } from './app.js';

// docs/API.md "Conventions".
describe('API conventions', () => {
  let app: INestApplication<App>;
  const prevMin = process.env.MIN_APP_VERSION;

  beforeAll(async () => {
    process.env.MIN_APP_VERSION = '1.2.0';
    app = await createTestApp();
  });
  afterAll(async () => {
    process.env.MIN_APP_VERSION = prevMin;
    await app.close();
  });

  it('answers unknown routes with the error shape', () =>
    request(app.getHttpServer())
      .get('/v1/nope')
      .expect(404)
      .expect((res) => {
        expect(res.body).toEqual({
          error: { code: 'not_found', message: "That doesn't exist or isn't visible to you." },
        });
      }));

  it('serves everything but /health under /v1', async () => {
    await request(app.getHttpServer()).get('/games').expect(404);
    await request(app.getHttpServer()).get('/v1/health').expect(404);
  });

  it('tells apps older than MIN_APP_VERSION to update', () =>
    request(app.getHttpServer())
      .get('/v1/games')
      .set('X-App-Version', '1.1.9')
      .expect(426)
      .expect((res) => expect(res.body.error.code).toBe('update_required')));

  it('still gives old apps the config, so they can show the update screen', () =>
    request(app.getHttpServer())
      .get('/v1/app/config')
      .set('X-App-Version', '1.0.0')
      .expect(200)
      .expect((res) => expect(res.body.minSupportedVersion).toBe('1.2.0')));

  it('lets current apps and header-less clients through', async () => {
    await request(app.getHttpServer())
      .get('/v1/app/config')
      .set('X-App-Version', '1.2.0')
      .expect(200);
    await request(app.getHttpServer()).get('/v1/app/config').expect(200);
  });

  it('allows the PWA origin to call from the browser', () =>
    request(app.getHttpServer())
      .options('/v1/games')
      .set('Origin', 'http://localhost:8080')
      .set('Access-Control-Request-Method', 'GET')
      .set('Access-Control-Request-Headers', 'authorization,x-app-version')
      .expect(204)
      .expect('Access-Control-Allow-Origin', 'http://localhost:8080'));

  it('does not allow other origins', () =>
    request(app.getHttpServer())
      .options('/v1/games')
      .set('Origin', 'https://evil.example')
      .set('Access-Control-Request-Method', 'GET')
      .expect((res) => expect(res.headers['access-control-allow-origin']).toBeUndefined()));
});
