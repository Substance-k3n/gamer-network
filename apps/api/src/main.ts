import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module.js';
import { configureApp } from './app.setup.js';
import { env } from './env.js';
import { serveOpenApi } from './openapi.js';

async function bootstrap() {
  const app = configureApp(await NestFactory.create(AppModule));
  serveOpenApi(app);
  app.enableShutdownHooks();
  await app.listen(env.port);
}
await bootstrap();
