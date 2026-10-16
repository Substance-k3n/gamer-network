import { HttpException, HttpStatus } from '@nestjs/common';

/**
 * Every non-2xx answer becomes { error: { code, message, fields? } }
 * (docs/API.md "Errors"). Clients branch on `code`, never on `message`;
 * `message` is safe to show to the user.
 */
export class AppError extends HttpException {
  constructor(
    status: HttpStatus,
    readonly code: string,
    message: string,
    readonly fields?: Record<string, string>,
  ) {
    super({ code, message, fields }, status);
  }
}

export const notFound = (what = 'That') =>
  new AppError(HttpStatus.NOT_FOUND, 'not_found', `${what} doesn't exist or isn't visible to you.`);

/** 429 rate_limited with a Retry-After header (docs/FEED_AND_GROUPS_API.md "Rate limits"). */
export class RateLimited extends AppError {
  constructor(
    message: string,
    readonly retryAfterSeconds: number,
  ) {
    super(HttpStatus.TOO_MANY_REQUESTS, 'rate_limited', message);
  }
}
