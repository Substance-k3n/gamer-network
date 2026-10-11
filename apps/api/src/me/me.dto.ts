import { ApiProperty } from '@nestjs/swagger';
import { userRole } from '../db/schema/index.js';
import { ProfileDto } from './profile.dto.js';

export { AGE_RANGES, type AgeRange } from './profile.dto.js';

/** The signed-in user: their own profile plus account details. */
export class MeDto extends ProfileDto {
  email: string;
  emailVerified: boolean;
  /** False for Google-only accounts, so Settings can offer "Set a password". */
  hasPassword: boolean;
  country: string;

  @ApiProperty({ enum: userRole.enumValues, enumName: 'UserRole' })
  role: (typeof userRole.enumValues)[number];

  /** Null until "Go live"; route to onboarding while null. */
  onboardedAt: Date | null;
  createdAt: Date;
}
