import { writeFileSync } from 'node:fs';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module.js';
import { configureApp } from './app.setup.js';
import { buildOpenApiDocument } from './openapi.js';

// `pnpm --filter @app/api spec`: writes the spec without starting a server.
// CI runs it and fails if the committed file differs. No database is
// needed: the client only connects on the first query.
process.env.DATABASE_URL ??= 'postgres://spec@localhost:1/spec';
const app = configureApp(await NestFactory.create(AppModule, { logger: false }));
const document = buildOpenApiDocument(app);
const target = new URL('../../../packages/api-spec/openapi.json', import.meta.url);
writeFileSync(target, `${JSON.stringify(document, null, 2)}\n`);
await app.close();
