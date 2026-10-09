import { Body, Controller, Headers, HttpCode, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { MeDto } from '../me/me.dto.js';
import { ProfileService } from '../me/profile.service.js';
import { CurrentSession, CurrentUser, Public } from './auth.decorators.js';
import {
  AuthResponse,
  ChangePasswordBody,
  CodeBody,
  ForgotPasswordBody,
  GoogleBody,
  LoginBody,
  ResetPasswordBody,
  SignupBody,
} from './auth.dto.js';
import { AuthService } from './auth.service.js';
import { type Session, SessionsService, type User } from './sessions.service.js';

class ResetResponse {
  token: string;
  user: MeDto;
}

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly auth: AuthService,
    private readonly sessions: SessionsService,
    private readonly profiles: ProfileService,
  ) {}

  /** Create an account with email + password. Sends a verification code. */
  @Public()
  @Post('signup')
  @ApiCreatedResponse({ type: AuthResponse })
  signup(@Body() body: SignupBody, @Headers('user-agent') ua?: string): Promise<AuthResponse> {
    return this.auth.signup(body, ua);
  }

  /** 401 wrong_credentials for any mismatch; 429 after 10 wrong passwords in 15 min. */
  @Public()
  @Post('login')
  @HttpCode(200)
  @ApiOkResponse({ type: AuthResponse })
  login(@Body() body: LoginBody, @Headers('user-agent') ua?: string): Promise<AuthResponse> {
    return this.auth.login(body, ua);
  }

  /**
   * Sign in or sign up with Google. For a new account without `username`
   * and `ageRange`, answers 422 signup_details_required: ask for them and
   * call again with the same idToken.
   */
  @Public()
  @Post('google')
  @HttpCode(200)
  @ApiOkResponse({ type: AuthResponse })
  google(@Body() body: GoogleBody, @Headers('user-agent') ua?: string): Promise<AuthResponse> {
    return this.auth.google(body, ua);
  }

  /** Enter the code sent after sign-up. */
  @ApiBearerAuth()
  @Post('verify-email')
  @HttpCode(200)
  @ApiOkResponse({ type: MeDto })
  async verifyEmail(@CurrentUser() user: User, @Body() body: CodeBody): Promise<MeDto> {
    return this.profiles.me(await this.auth.verifyEmail(user, body.code));
  }

  /** 429 after 5 codes in an hour. */
  @ApiBearerAuth()
  @Post('verify-email/resend')
  @HttpCode(204)
  @ApiNoContentResponse()
  resendVerification(@CurrentUser() user: User): Promise<void> {
    return this.auth.resendVerification(user);
  }

  /** Always 204, whether or not the email has an account. */
  @Public()
  @Post('password/forgot')
  @HttpCode(204)
  @ApiNoContentResponse()
  forgotPassword(@Body() body: ForgotPasswordBody): Promise<void> {
    return this.auth.forgotPassword(body.email);
  }

  /** Sets a new password with the emailed code. Signs out every other device. */
  @Public()
  @Post('password/reset')
  @HttpCode(200)
  @ApiOkResponse({ type: ResetResponse })
  resetPassword(
    @Body() body: ResetPasswordBody,
    @Headers('user-agent') ua?: string,
  ): Promise<ResetResponse> {
    return this.auth.resetPassword(body.email, body.code, body.newPassword, ua);
  }

  /** Change (or, for Google-only accounts, set) the password. Signs out other devices. */
  @ApiBearerAuth()
  @Post('password')
  @HttpCode(204)
  @ApiNoContentResponse()
  changePassword(
    @CurrentUser() user: User,
    @CurrentSession() session: Session,
    @Body() body: ChangePasswordBody,
  ): Promise<void> {
    return this.auth.changePassword(user, session, body.currentPassword, body.newPassword);
  }

  /** Ends this session. */
  @ApiBearerAuth()
  @Post('logout')
  @HttpCode(204)
  @ApiNoContentResponse()
  logout(@CurrentSession() session: Session): Promise<void> {
    return this.sessions.revoke(session.id);
  }
}
