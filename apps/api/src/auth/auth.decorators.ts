import { createParamDecorator, ExecutionContext, SetMetadata } from '@nestjs/common';
import type { Request } from 'express';
import type { Session, User } from './sessions.service.js';

export const IS_PUBLIC = 'isPublic';
/** No token needed (🔓 in docs/API.md). Everything else requires one. */
export const Public = () => SetMetadata(IS_PUBLIC, true);

export const NEEDS_VERIFIED = 'needsVerifiedEmail';
/** 403 email_not_verified until the sign-up code is entered (ADR-0007). */
export const RequireVerifiedEmail = () => SetMetadata(NEEDS_VERIFIED, true);

export interface AuthedRequest extends Request {
  user: User;
  session: Session;
}

/** The signed-in user. Only on non-public routes. */
export const CurrentUser = createParamDecorator(
  (_: unknown, ctx: ExecutionContext) => ctx.switchToHttp().getRequest<AuthedRequest>().user,
);

export const CurrentSession = createParamDecorator(
  (_: unknown, ctx: ExecutionContext) => ctx.switchToHttp().getRequest<AuthedRequest>().session,
);
