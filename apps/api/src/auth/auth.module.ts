import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { AuthController } from './auth.controller.js';
import { AuthGuard } from './auth.guard.js';
import { AuthService } from './auth.service.js';
import { EmailCodesService } from './email-codes.service.js';
import { GOOGLE_VERIFIER, GoogleIdTokenVerifier } from './google.js';
import { LoginThrottle } from './login-throttle.js';
import { SessionsService } from './sessions.service.js';

@Module({
  controllers: [AuthController],
  providers: [
    AuthService,
    SessionsService,
    EmailCodesService,
    LoginThrottle,
    { provide: GOOGLE_VERIFIER, useClass: GoogleIdTokenVerifier },
    { provide: APP_GUARD, useClass: AuthGuard },
  ],
  exports: [SessionsService],
})
export class AuthModule {}
