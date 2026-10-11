import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsBoolean, IsDate, IsIn, IsOptional, IsString, Length, MaxLength } from 'class-validator';
import { PageQuery } from '../common/cursor.js';
import { reportStatus } from '../db/schema/index.js';
import { REPORT_REASONS, type ReportReason } from '../safety/safety.dto.js';

export const REPORT_STATUSES = reportStatus.enumValues;
export type ReportStatus = (typeof REPORT_STATUSES)[number];
export const RESOLVE_ACTIONS = ['dismiss', 'warn', 'remove_listing', 'ban'] as const;
export type ResolveAction = (typeof RESOLVE_ACTIONS)[number];
export const ACCOUNT_STATES = ['active', 'banned', 'deleted'] as const;
export type AccountState = (typeof ACCOUNT_STATES)[number];

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

/** A person as the admin sees them: account details and safety history. */
export class AdminUserDto {
  id: string;
  username: string;
  displayName: string;
  email: string;
  city: string;
  /** First game on their profile. */
  mainGame: string | null;

  @ApiProperty({ enum: ACCOUNT_STATES, enumName: 'AccountState' })
  state: AccountState;

  banReason: string | null;
  onboarded: boolean;
  createdAt: Date;
  /** Latest activity on any session. */
  lastSeenAt: Date | null;
  connections: number;
  playedWith: number;
  /** Reports against them still open. */
  openReports: number;
}

export class AdminUserPageDto {
  items: AdminUserDto[];
  nextCursor: string | null;
}

export class AdminUsersQuery extends PageQuery {
  /** Username, display name or email prefix. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 60)
  query?: string;

  @ApiPropertyOptional({ enum: ACCOUNT_STATES, enumName: 'AccountState' })
  @IsOptional()
  @IsIn(ACCOUNT_STATES)
  state?: AccountState;
}

export class AdminReportDto {
  id: string;
  reporter: AdminUserDto;
  target: AdminUserDto;
  listingId: string | null;

  @ApiProperty({ enum: REPORT_REASONS, enumName: 'ReportReason' })
  reason: ReportReason;

  details: string | null;

  @ApiProperty({ enum: REPORT_STATUSES, enumName: 'ReportStatus' })
  status: ReportStatus;

  createdAt: Date;
  resolvedAt: Date | null;
  resolutionNote: string | null;
}

export class AdminReportPageDto {
  items: AdminReportDto[];
  nextCursor: string | null;
}

export class AdminReportsQuery extends PageQuery {
  @ApiPropertyOptional({ enum: REPORT_STATUSES, enumName: 'ReportStatus', default: 'open' })
  @IsOptional()
  @IsIn(REPORT_STATUSES)
  status?: ReportStatus;
}

export class ResolveReportBody {
  /** dismiss: no action. warn, remove_listing (the reported listing), ban (the target). */
  @ApiProperty({ enum: RESOLVE_ACTIONS, enumName: 'ResolveAction' })
  @IsIn(RESOLVE_ACTIONS)
  action: ResolveAction;

  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note: string;
}

export class BanBody {
  /** Shown to nobody but admins; keep it factual. */
  @Transform(trim)
  @IsString()
  @Length(1, 500)
  reason: string;
}

export class NoteBody {
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string;
}

export class SetLaunchBody {
  /** Launch games are the ones Find Players offers. */
  @IsBoolean()
  isLaunch: boolean;
}

export class MetricsQuery {
  /** Start, inclusive. Defaults to 30 days before `to`. */
  @IsOptional()
  @Type(() => Date)
  @IsDate()
  from?: Date;

  /** End, exclusive. Defaults to now. */
  @IsOptional()
  @Type(() => Date)
  @IsDate()
  to?: Date;
}

/** The MVP's numbers for listings created in [from, to) (docs/PRD.md). */
export class MetricsDto {
  from: Date;
  to: Date;
  listings: number;
  /** Got at least one connection request. */
  listingsWithRequest: number;
  /** At least one "played" check-in points at them. */
  listingsPlayed: number;
  /** listingsPlayed / listings: the number that decides the MVP. */
  playedRate: number;
  /** People active in the 7 days before `to`. */
  weeklyActive: number;
}
