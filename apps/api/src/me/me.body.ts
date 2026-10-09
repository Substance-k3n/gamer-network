import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  MaxLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { USERNAME, USERNAME_RULE } from '../auth/auth.dto.js';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';
import {
  AGE_RANGES,
  type AgeRange,
  type Day,
  DAYS,
  GAMING_ID_KINDS,
  type GamingIdKind,
  ID_VISIBILITIES,
  type IdVisibility,
  PLAY_TAGS,
  PLAYER_STATUSES,
  type PlayerStatus,
  type PlayTag,
} from './profile.dto.js';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);
const trimLower = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toLowerCase() : value;
/** "" clears an optional text field. */
const trimOrNull = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() || null : value;

/** May be left out, but not sent as null (the column can't be empty). */
const Absent = () => ValidateIf((_: unknown, v: unknown) => v !== undefined);

export const MAX_GAMES = 20;
export const MAX_TAGS = 6;
export const MAX_GAMING_IDS = 20;

/** Only the fields sent change. Onboarding step 1 and Edit profile. */
export class UpdateMeBody {
  @Absent()
  @Transform(trim)
  @IsString()
  @Length(1, 30, { message: 'Use 1 to 30 characters' })
  displayName?: string;

  /** Stored lowercase. */
  @Absent()
  @Transform(trimLower)
  @Matches(USERNAME, { message: USERNAME_RULE })
  username?: string;

  /** Send "" or null to clear. */
  @IsOptional()
  @Transform(trimOrNull)
  @IsString()
  @MaxLength(160, { message: 'Keep it under 160 characters' })
  bio?: string | null;

  @ApiPropertyOptional({ enum: AGE_RANGES, enumName: 'AgeRange' })
  @Absent()
  @IsIn(AGE_RANGES, { message: 'Pick an age range' })
  ageRange?: AgeRange;

  @Absent()
  @Transform(trim)
  @IsString()
  @Length(1, 60)
  city?: string;
}

/** A catalog game (gameId) or one added by name (customGameName), never both. */
export class UserGameInput {
  @ValidateIf((o: UserGameInput) => o.customGameName === undefined)
  @IsString({ message: 'Pick a game or type its name' })
  gameId?: string;

  @ValidateIf((o: UserGameInput) => o.gameId === undefined || o.customGameName !== undefined)
  @Transform(trim)
  @IsString()
  @Length(1, 40, { message: 'Use 1 to 40 characters' })
  customGameName?: string;

  /** A rank of this game, from GET /v1/games. Catalog games only. */
  @IsOptional()
  @IsUUID('7')
  rankId?: string;

  /** Free-text level. Custom games only. */
  @IsOptional()
  @Transform(trimOrNull)
  @IsString()
  @MaxLength(30)
  rankText?: string | null;

  /** A role of this game. Catalog games only. */
  @IsOptional()
  @IsUUID('7')
  roleId?: string;
}

export class SetGamesBody {
  /** The full list, in profile order. Replaces what was there. */
  @IsArray()
  @ArrayMaxSize(MAX_GAMES)
  @ValidateNested({ each: true })
  @Type(() => UserGameInput)
  games: UserGameInput[];
}

export class SetPlatformsBody {
  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  @IsArray()
  @ArrayUnique()
  @IsIn(PLATFORMS, { each: true })
  platforms: Platform[];
}

export class SetTagsBody {
  /** At most 6. */
  @ApiProperty({ enum: PLAY_TAGS, enumName: 'PlayTag', isArray: true })
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(MAX_TAGS, { message: `Pick up to ${MAX_TAGS}` })
  @IsIn(PLAY_TAGS, { each: true })
  tags: PlayTag[];
}

export class GamingIdInput {
  @ApiProperty({ enum: GAMING_ID_KINDS, enumName: 'GamingIdKind' })
  @IsIn(GAMING_ID_KINDS)
  kind: GamingIdKind;

  /** Required for in_game (e.g. a PUBG Mobile UID), absent otherwise. */
  @ValidateIf((o: GamingIdInput) => o.kind === 'in_game' || o.gameId !== undefined)
  @IsString({ message: 'Pick the game this ID is for' })
  gameId?: string;

  @Transform(trim)
  @IsString()
  @Length(1, 64, { message: 'Use 1 to 64 characters' })
  value: string;

  /** Defaults to connections. */
  @ApiPropertyOptional({ enum: ID_VISIBILITIES, enumName: 'IdVisibility' })
  @IsOptional()
  @IsIn(ID_VISIBILITIES)
  visibility?: IdVisibility;
}

export class SetGamingIdsBody {
  /** The full list. Replaces what was there. */
  @IsArray()
  @ArrayMaxSize(MAX_GAMING_IDS)
  @ValidateNested({ each: true })
  @Type(() => GamingIdInput)
  gamingIds: GamingIdInput[];
}

export class SetStatusBody {
  /** available_tonight clears at 04:00, playing after 4 hours. */
  @ApiProperty({ enum: PLAYER_STATUSES, enumName: 'PlayerStatus' })
  @IsIn(PLAYER_STATUSES)
  status: PlayerStatus;

  /** The game for "Playing …" or "Looking …". Ignored for not_available. */
  @IsOptional()
  @IsString()
  gameId?: string;

  /** The MO–SU row. Left as is when absent. */
  @ApiPropertyOptional({ enum: DAYS, enumName: 'Day', isArray: true })
  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @IsIn(DAYS, { each: true })
  availableDays?: Day[];
}
