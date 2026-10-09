import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, IsUUID, Max, MaxLength, Min } from 'class-validator';
import { PageQuery } from '../common/cursor.js';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';
import {
  type Duration,
  DURATIONS,
  PLAY_STYLES,
  PLAY_WHENS,
  type PlayStyle,
  type PlayWhen,
  type Voice,
  VOICES,
} from './listings.dto.js';

const trimOrNull = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() || null : value;

export class CreateListingBody {
  /** A launch game (isLaunch in GET /v1/games). */
  @IsString()
  gameId: string;

  @IsOptional()
  @IsUUID('7')
  modeId?: string;

  /** The rank this group plays at. Defaults to your rank in this game. */
  @IsOptional()
  @IsUUID('7')
  rankId?: string;

  /** One of the game's platforms. */
  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform' })
  @IsIn(PLATFORMS)
  platform: Platform;

  /** Whole party including you, up to the game's maxParty. */
  @IsInt()
  @Min(2)
  @Max(5)
  partySize: number;

  @ApiProperty({ enum: VOICES, enumName: 'Voice' })
  @IsIn(VOICES)
  voice: Voice;

  @ApiProperty({ enum: PLAY_STYLES, enumName: 'PlayStyle' })
  @IsIn(PLAY_STYLES)
  style: PlayStyle;

  @ApiProperty({ enum: PLAY_WHENS, enumName: 'PlayWhen' })
  @IsIn(PLAY_WHENS)
  playWhen: PlayWhen;

  /** How long it stays up once play starts. */
  @ApiProperty({ enum: DURATIONS })
  @IsIn(DURATIONS, { message: 'Pick 2, 6 or 24 hours' })
  durationHours: Duration;

  @IsOptional()
  @Transform(trimOrNull)
  @IsString()
  @MaxLength(140, { message: 'Keep it under 140 characters' })
  note?: string | null;
}

export const FEED_WHENS = ['now', 'tonight'] as const;

export class ListingFeedQuery extends PageQuery {
  /** Game id. */
  @IsOptional()
  @IsString()
  game?: string;

  /** A rank id: listings at this rank or higher in the same game. */
  @IsOptional()
  @IsUUID('7')
  minRank?: string;

  @ApiPropertyOptional({ enum: PLATFORMS, enumName: 'Platform' })
  @IsOptional()
  @IsIn(PLATFORMS)
  platform?: Platform;

  /** Mode id. */
  @IsOptional()
  @IsUUID('7')
  mode?: string;

  /** Only "Mic required" listings. */
  @ApiPropertyOptional({ enum: ['required'] })
  @IsOptional()
  @IsIn(['required'])
  voice?: 'required';

  /** now: already started. tonight: starts before 04:00. */
  @ApiPropertyOptional({ enum: FEED_WHENS })
  @IsOptional()
  @IsIn(FEED_WHENS)
  when?: (typeof FEED_WHENS)[number];

  @ApiPropertyOptional({ enum: PLAY_STYLES, enumName: 'PlayStyle' })
  @IsOptional()
  @IsIn(PLAY_STYLES)
  style?: PlayStyle;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(2)
  @Max(5)
  partySize?: number;
}
