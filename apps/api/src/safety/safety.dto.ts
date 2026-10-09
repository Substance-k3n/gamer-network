import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsIn, IsOptional, IsString, IsUUID, Length, Matches, MaxLength } from 'class-validator';
import { reportReason } from '../db/schema/index.js';
import { UserCardDto } from '../me/profile.dto.js';

export const REPORT_REASONS = reportReason.enumValues;
export type ReportReason = (typeof REPORT_REASONS)[number];

const trimOrNull = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() || null : value;

export class BlockBody {
  @IsUUID()
  userId: string;
}

export class BlockListDto {
  /** People you blocked, most recent first (Settings → Blocked users). */
  items: UserCardDto[];
}

export class ReportBody {
  @IsUUID()
  userId: string;

  /** When reporting from a listing card: one of their listings. */
  @IsOptional()
  @IsUUID()
  listingId?: string;

  @ApiProperty({ enum: REPORT_REASONS, enumName: 'ReportReason' })
  @IsIn(REPORT_REASONS)
  reason: ReportReason;

  @IsOptional()
  @Transform(trimOrNull)
  @IsString()
  @MaxLength(500, { message: 'Keep it under 500 characters' })
  details?: string | null;
}

export class WaitlistBody {
  /** "groups" for the Groups "Notify me" button. */
  @Matches(/^[a-z_]{1,30}$/)
  topic: string;
}

export class DeleteAccountBody {
  /** Required when the account has a password (hasPassword on Me). */
  @IsOptional()
  @IsString()
  @Length(1, 72)
  password?: string;
}
