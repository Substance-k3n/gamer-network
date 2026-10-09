import { ApiProperty } from '@nestjs/swagger';
import { ageRange, playerStatus, userRole } from '../db/schema/index.js';
import type { User } from '../auth/sessions.service.js';

export const AGE_RANGES = ageRange.enumValues;
export type AgeRange = (typeof AGE_RANGES)[number];

/** The signed-in user. Grows into the full profile in phase 3. */
export class MeDto {
  id: string;
  email: string;
  emailVerified: boolean;
  /** False for Google-only accounts, so Settings can offer "Set a password". */
  hasPassword: boolean;
  username: string;
  displayName: string;

  @ApiProperty({ enum: AGE_RANGES, enumName: 'AgeRange' })
  ageRange: AgeRange;

  country: string;
  city: string;

  @ApiProperty({ enum: playerStatus.enumValues, enumName: 'PlayerStatus' })
  status: (typeof playerStatus.enumValues)[number];

  @ApiProperty({ enum: userRole.enumValues, enumName: 'UserRole' })
  role: (typeof userRole.enumValues)[number];

  /** Null until "Go live"; route to onboarding while null. */
  onboardedAt: Date | null;
  avatarUrl: string | null;
  createdAt: Date;
}

export function toMe(u: User): MeDto {
  return {
    id: u.id,
    email: u.email,
    emailVerified: u.emailVerifiedAt !== null,
    hasPassword: u.passwordHash !== null,
    username: u.username,
    displayName: u.displayName,
    ageRange: u.ageRange,
    country: u.country,
    city: u.city,
    status: u.status,
    role: u.role,
    onboardedAt: u.onboardedAt,
    avatarUrl: null,
    createdAt: u.createdAt,
  };
}
