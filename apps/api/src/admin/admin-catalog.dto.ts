import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsEmail,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { USERNAME, USERNAME_RULE } from '../auth/auth.dto.js';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';
import { AGE_RANGES, type AgeRange } from '../me/profile.dto.js';
import { RankDto } from '../games/games.dto.js';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);
const trimLower = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toLowerCase() : value;

export const USER_ROLES = ['player', 'admin'] as const;
export type UserRole = (typeof USER_ROLES)[number];

/** Page numbers, for the admin's tables. */
export class PageNumberQuery {
  /** 1 = first page. */
  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  /** Rows per page, 1–100, default 20. */
  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number;
}

// ---- games ----

/** A catalog game as the admin sees it, with how many players have it. */
export class AdminGameDto {
  id: string;
  name: string;
  shortCode: string;

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  platforms: Platform[];

  hasRanks: boolean;
  maxParty: number;
  isLaunch: boolean;
  /** Catalog order, lowest first. */
  sort: number;
  /** Lowest first. */
  ranks: RankDto[];
  /** Players with it on their profile. */
  players: number;
  /** Open or full listings for it right now. */
  liveListings: number;
  /** Set when an admin deleted it. */
  deletedAt: Date | null;
}

export class AdminGamePageDto {
  items: AdminGameDto[];
  total: number;
  page: number;
  pageSize: number;
}

export class AdminGamesQuery extends PageNumberQuery {
  /** Name, short code or id. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(60)
  query?: string;

  /** live (default): the catalog players see; deleted: the ones taken out. */
  @ApiPropertyOptional({ enum: ['live', 'deleted'] })
  @IsOptional()
  @IsIn(['live', 'deleted'])
  state?: 'live' | 'deleted';
}

class GameFields {
  @Transform(trim)
  @IsString()
  @Length(1, 60)
  name: string;

  /** Tile label, e.g. "VAL". */
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value,
  )
  @IsString()
  @Length(1, 6)
  shortCode: string;

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  @IsArray()
  @ArrayMinSize(1, { message: 'Pick at least one platform' })
  @IsIn(PLATFORMS, { each: true })
  platforms: Platform[];

  /** False when the ladder is play-style levels rather than ranks. */
  @IsBoolean()
  hasRanks: boolean;

  /** Largest party a listing can ask for, 2–10. */
  @IsInt()
  @Min(2)
  @Max(10)
  maxParty: number;

  /** On Find Players. */
  @IsBoolean()
  isLaunch: boolean;

  /** Catalog order, lowest first. */
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(999)
  sort?: number;
}

export class CreateGameBody extends GameFields {
  /** The id apps and links use, e.g. "val": 2–20 lowercase letters or digits. Can't change later. */
  @Transform(trimLower)
  @Matches(/^[a-z0-9]{2,20}$/, { message: 'Use 2 to 20 lowercase letters or digits' })
  id: string;
}

/** Only the fields sent change. */
export class UpdateGameBody {
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 60)
  name?: string;

  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value,
  )
  @IsString()
  @Length(1, 6)
  shortCode?: string;

  @ApiPropertyOptional({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  @IsOptional()
  @IsArray()
  @ArrayMinSize(1, { message: 'Pick at least one platform' })
  @IsIn(PLATFORMS, { each: true })
  platforms?: Platform[];

  @IsOptional()
  @IsBoolean()
  hasRanks?: boolean;

  @IsOptional()
  @IsInt()
  @Min(2)
  @Max(10)
  maxParty?: number;

  /** On Find Players. */
  @IsOptional()
  @IsBoolean()
  isLaunch?: boolean;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(999)
  sort?: number;
}

// ---- ranks ----

export class CreateRankBody {
  @Transform(trim)
  @IsString()
  @Length(1, 30)
  name: string;

  /** Position on the ladder, 0 = lowest. Defaults to the top. A taken tier moves the ranks above it up. */
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(99)
  tier?: number;
}

/** Rename, or move on the ladder: a taken tier swaps places with that rank. */
export class UpdateRankBody {
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 30)
  name?: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(99)
  tier?: number;
}

// ---- users ----

export class CreateUserBody {
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  @MaxLength(254)
  email: string;

  @Transform(trimLower)
  @Matches(USERNAME, { message: USERNAME_RULE })
  username: string;

  @Transform(trim)
  @IsString()
  @Length(1, 30, { message: 'Use 1 to 30 characters' })
  displayName: string;

  /** They can change it after signing in. */
  @IsString()
  @Length(8, 72, { message: 'Use 8 to 72 characters' })
  password: string;

  @ApiProperty({ enum: AGE_RANGES, enumName: 'AgeRange' })
  @IsIn(AGE_RANGES, { message: 'Pick an age range' })
  ageRange: AgeRange;

  @ApiPropertyOptional({ enum: USER_ROLES, enumName: 'UserRole', default: 'player' })
  @IsOptional()
  @IsIn(USER_ROLES)
  role?: UserRole;
}

/** Only the fields sent change. */
export class UpdateUserBody {
  @IsOptional()
  @Transform(trimLower)
  @IsEmail({}, { message: 'Enter a valid email' })
  @MaxLength(254)
  email?: string;

  @IsOptional()
  @Transform(trimLower)
  @Matches(USERNAME, { message: USERNAME_RULE })
  username?: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 30, { message: 'Use 1 to 30 characters' })
  displayName?: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(1, 60)
  city?: string;

  @ApiPropertyOptional({ enum: USER_ROLES, enumName: 'UserRole' })
  @IsOptional()
  @IsIn(USER_ROLES)
  role?: UserRole;
}

// ---- dashboard ----

export class MetricsDayDto {
  /** Addis Ababa date, YYYY-MM-DD. */
  day: string;
  signups: number;
  listings: number;
  posts: number;
  /** "played" check-ins answered that day. */
  played: number;
}

export class GamePopularityDto {
  gameId: string;
  name: string;
  /** Listings for it in the range. */
  listings: number;
}

export class TotalsDto {
  /** Live accounts (not banned or deleted). */
  players: number;
  banned: number;
  /** Games in the catalog players see. */
  games: number;
  openReports: number;
  liveGroups: number;
}
