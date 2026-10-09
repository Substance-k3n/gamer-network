import { INestApplication } from '@nestjs/common';
import { DocumentBuilder, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { ErrorResponse } from './common/error.dto.js';

// The single source of packages/api-spec/openapi.json (ADR-0003).
export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('gamer-network API')
    .setVersion('0.0.0')
    .setDescription('Conventions: docs/API.md. Every non-2xx response is an ErrorResponse.')
    .addBearerAuth()
    .build();
  return SwaggerModule.createDocument(app, config, {
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
}
