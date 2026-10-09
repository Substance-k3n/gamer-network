import { CanActivate, ExecutionContext, HttpStatus, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AppError } from '../common/app-error.js';
import { type AuthedRequest, IS_PUBLIC, NEEDS_VERIFIED } from './auth.decorators.js';
import { SessionsService } from './sessions.service.js';

const unauthenticated = () =>
  new AppError(HttpStatus.UNAUTHORIZED, 'unauthenticated', 'Sign in to continue.');

/** Global: every route needs `Authorization: Bearer <token>` unless marked @Public(). */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly sessions: SessionsService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    const targets = [ctx.getHandler(), ctx.getClass()];
    if (this.reflector.getAllAndOverride<boolean>(IS_PUBLIC, targets)) return true;

    const req = ctx.switchToHttp().getRequest<AuthedRequest>();
    const [scheme, token] = (req.header('authorization') ?? '').split(' ');
    if (scheme !== 'Bearer' || !token) throw unauthenticated();

    const found = await this.sessions.resolve(token);
    if (!found || found.user.deletedAt) throw unauthenticated();
    if (found.user.bannedAt) {
      throw new AppError(HttpStatus.FORBIDDEN, 'banned', 'This account has been banned.');
    }
    if (
      this.reflector.getAllAndOverride<boolean>(NEEDS_VERIFIED, targets) &&
      !found.user.emailVerifiedAt
    ) {
      throw new AppError(
        HttpStatus.FORBIDDEN,
        'email_not_verified',
        'Verify your email first. We sent you a code.',
      );
    }

    req.user = found.user;
    req.session = found.session;
    return true;
  }
}
