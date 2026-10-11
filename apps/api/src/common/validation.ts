import { HttpStatus, ValidationError, ValidationPipe } from '@nestjs/common';
import { AppError } from './app-error.js';

function flatten(errors: ValidationError[], prefix = ''): Record<string, string> {
  const out: Record<string, string> = {};
  for (const e of errors) {
    const path = prefix ? `${prefix}.${e.property}` : e.property;
    const first = e.constraints ? Object.values(e.constraints)[0] : undefined;
    if (first) out[path] = first;
    if (e.children?.length) Object.assign(out, flatten(e.children, path));
  }
  return out;
}

/** Strips unknown fields, converts types, and answers 422 with per-field problems. */
export const validationPipe = new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,
  transform: true,
  exceptionFactory: (errors) =>
    new AppError(
      HttpStatus.UNPROCESSABLE_ENTITY,
      'validation_failed',
      'Some fields need fixing.',
      flatten(errors),
    ),
});
