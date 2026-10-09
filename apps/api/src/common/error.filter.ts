import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Response } from 'express';

const DEFAULT_CODES: Record<number, [string, string]> = {
  400: ['bad_request', 'The request is malformed.'],
  401: ['unauthenticated', 'Sign in to continue.'],
  403: ['forbidden', "You can't do that."],
  404: ['not_found', "That doesn't exist or isn't visible to you."],
  409: ['conflict', 'That clashes with something that already exists.'],
  413: ['too_large', 'That is too large.'],
  422: ['validation_failed', 'Some fields need fixing.'],
  426: ['update_required', 'Update the app to keep playing.'],
  429: ['rate_limited', 'Too many tries. Wait a little and try again.'],
  503: ['unavailable', 'The service is down for a moment. Try again shortly.'],
};

/** Turns every thrown error into the one error shape in docs/API.md. */
@Catch()
export class ErrorFilter implements ExceptionFilter {
  private readonly logger = new Logger('Error');

  catch(exception: unknown, host: ArgumentsHost) {
    const res = host.switchToHttp().getResponse<Response>();

    if (!(exception instanceof HttpException)) {
      this.logger.error(exception instanceof Error ? exception.stack : exception);
      res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
        error: { code: 'internal', message: 'Something went wrong on our side. Try again.' },
      });
      return;
    }

    const status = exception.getStatus();
    const body = exception.getResponse();
    const [defaultCode, defaultMessage] = DEFAULT_CODES[status] ?? ['error', exception.message];
    const given =
      typeof body === 'object' && body !== null ? (body as Record<string, unknown>) : {};

    // AppError passes { code, message, fields }; Nest's own exceptions don't.
    const code = typeof given.code === 'string' ? given.code : defaultCode;
    const message =
      typeof given.code === 'string' && typeof given.message === 'string'
        ? given.message
        : defaultMessage;
    const fields = given.fields as Record<string, string> | undefined;

    // /health keeps its own body so monitors can read it.
    if (typeof given.status === 'string') {
      res.status(status).json(given);
      return;
    }
    res.status(status).json({ error: fields ? { code, message, fields } : { code, message } });
  }
}
