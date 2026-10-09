import { INestApplication } from '@nestjs/common';
import { appVersionGate } from './common/app-version.js';
import { ErrorFilter } from './common/error.filter.js';
import { validationPipe } from './common/validation.js';
import { env } from './env.js';

/**
 * Everything main.ts, the spec writer and the e2e tests share, so the
 * app under test is the app that runs.
 */
export function configureApp(app: INestApplication) {
  app.setGlobalPrefix('v1', { exclude: ['health'] });
  app.useGlobalPipes(validationPipe);
  app.useGlobalFilters(new ErrorFilter());
  app.use(appVersionGate);
  // The PWA build of the app and the web site call the API from the browser.
  app.enableCors({
    origin: env.webOrigins,
    allowedHeaders: [
      'Authorization',
      'Content-Type',
      'Idempotency-Key',
      'X-App-Version',
      'X-Platform',
    ],
    maxAge: 86400,
  });
  return app;
}
