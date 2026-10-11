import { INestApplication } from '@nestjs/common';
import { DocumentBuilder, getSchemaPath, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { ErrorResponse } from './common/error.dto.js';
import { env } from './env.js';

// The single source of packages/api-spec/openapi.json (ADR-0003).
export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('gamer-network API')
    .setVersion('0.0.0')
    .setDescription('Conventions: docs/API.md. Every non-2xx response is an ErrorResponse.')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config, {
    extraModels: [ErrorResponse],
    // HealthController.check -> "healthCheck": the method name the
    // generated Dart and TypeScript clients get.
    operationIdFactory: (controllerKey, methodKey) => {
      const resource = controllerKey.replace(/Controller$/, '');
      return (
        resource.charAt(0).toLowerCase() +
        resource.slice(1) +
        methodKey.charAt(0).toUpperCase() +
        methodKey.slice(1)
      );
    },
  });
  // Every non-2xx answer is an ErrorResponse (common/error.filter.ts), so
  // say so once per operation instead of on every handler.
  const error = {
    description: 'Any error: see docs/API.md for the codes.',
    content: { 'application/json': { schema: { $ref: getSchemaPath(ErrorResponse) } } },
  };
  for (const item of Object.values(document.paths)) {
    for (const method of ['get', 'put', 'post', 'delete', 'patch'] as const) {
      const operation = item[method];
      if (operation) operation.responses = { ...operation.responses, default: error };
    }
  }
  return document;
}

/**
 * The contract as JSON at /openapi.json, in every environment, so the app
 * and the dashboard can generate clients from the running API. The
 * browsable docs at /docs stay off in production.
 */
export function serveOpenApi(app: INestApplication) {
  SwaggerModule.setup('docs', app, buildOpenApiDocument(app), {
    ui: !env.production,
    raw: ['json'],
    jsonDocumentUrl: 'openapi.json',
  });
}
