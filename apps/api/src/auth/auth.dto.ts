import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsEmail, IsIn, IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';
import { AGE_RANGES, type AgeRange, MeDto } from '../me/me.dto.js';

const trimLower = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toLowerCase() : value;
const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

export const USERNAME = /^[a-z0-9._]{3,20}$/;
const USERNAME_RULE = '3–20 characters: lowercase letters, numbers, dots and underscores';

class PasswordField {
  /** 8–72 characters. */
  @IsString()
  @Length(8, 72, { message: 'Use 8 to 72 characters' })
  password: string;
}

export class SignupBody extends PasswordField {
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  @MaxLength(254)
  email: string;

  @Transform(trim)
  @IsString()
  @Length(1, 30, { message: 'Use 1 to 30 characters' })
  displayName: string;

  /** Stored lowercase. */
  @Transform(trimLower)
  @Matches(USERNAME, { message: USERNAME_RULE })
  username: string;

  @ApiProperty({ enum: AGE_RANGES, enumName: 'AgeRange' })
  @IsIn(AGE_RANGES, { message: 'Pick an age range' })
  ageRange: AgeRange;
}

export class LoginBody {
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  email: string;

  @IsString()
  @Length(1, 72)
  password: string;
}

export class GoogleBody {
  /** From Google Sign-In on the device, or Google Identity Services on the web. */
  @IsString()
  @Length(10, 4096)
  idToken: string;

  /** Only for a new account: send after a 422 signup_details_required. */
  @IsOptional()
  @Transform(trimLower)
  @Matches(USERNAME, { message: USERNAME_RULE })
  username?: string;

  @ApiPropertyOptional({ enum: AGE_RANGES, enumName: 'AgeRange' })
  @IsOptional()
  @IsIn(AGE_RANGES, { message: 'Pick an age range' })
  ageRange?: AgeRange;

  /** Defaults to the name on the Google account. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 30)
  displayName?: string;
}

export class CodeBody {
  /** The 6 digits from the email. */
  @Transform(trim)
  @Matches(/^\d{6}$/, { message: 'Enter the 6-digit code' })
  code: string;
}

export class ForgotPasswordBody {
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  email: string;
}

export class ResetPasswordBody extends CodeBody {
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  email: string;

  @IsString()
  @Length(8, 72, { message: 'Use 8 to 72 characters' })
  newPassword: string;
}

export class ChangePasswordBody {
  /** Required unless the account has no password yet (Google-only). */
  @IsOptional()
  @IsString()
  @Length(1, 72)
  currentPassword?: string;

  @IsString()
  @Length(8, 72, { message: 'Use 8 to 72 characters' })
  newPassword: string;
}

export class AuthResponse {
  /** Send as `Authorization: Bearer <token>`. Keep it in secure storage. */
  token: string;
  user: MeDto;
  /** True when this call created the account: go to onboarding. */
  isNew: boolean;
}
