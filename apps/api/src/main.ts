import { NestFactory } from '@nestjs/core';
import { SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module.js';
import { env } from './env.js';
import { buildOpenApiDocument } from './openapi.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  if (!env.production) {
    SwaggerModule.setup('docs', app, buildOpenApiDocument(app));
  }
  app.enableShutdownHooks();
  await app.listen(env.port);
}
await bootstrap();
