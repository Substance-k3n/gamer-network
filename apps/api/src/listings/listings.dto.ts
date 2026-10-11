import { ApiProperty } from '@nestjs/swagger';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';
import { listingStatus, playStyle, playWhen, requestStatus, voice } from '../db/schema/index.js';
import { GameRefDto, RankRefDto, UserCardDto } from '../me/profile.dto.js';

export const VOICES = voice.enumValues;
export type Voice = (typeof VOICES)[number];
export const PLAY_STYLES = playStyle.enumValues;
export type PlayStyle = (typeof PLAY_STYLES)[number];
export const PLAY_WHENS = playWhen.enumValues;
export type PlayWhen = (typeof PLAY_WHENS)[number];
export const LISTING_STATUSES = listingStatus.enumValues;
export type ListingStatus = (typeof LISTING_STATUSES)[number];
export const REQUEST_STATUSES = requestStatus.enumValues;
export type RequestStatus = (typeof REQUEST_STATUSES)[number];
export const DURATIONS = [2, 6, 24] as const;
export type Duration = (typeof DURATIONS)[number];

export class ModeRefDto {
  id: string;
  name: string;
}

export class MyRequestDto {
  id: string;

  @ApiProperty({ enum: REQUEST_STATUSES, enumName: 'RequestStatus' })
  status: RequestStatus;
}

/** A "Looking for players" post. */
export class ListingDto {
  id: string;
  owner: UserCardDto;
  game: GameRefDto;
  mode: ModeRefDto | null;
  rank: RankRefDto | null;

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform' })
  platform: Platform;

  /** Whole party including the owner: 2 = Duo … 5 = 5-stack. */
  partySize: number;
  /** Players accepted so far, owner not counted. */
  filled: number;

  @ApiProperty({ enum: VOICES, enumName: 'Voice' })
  voice: Voice;

  @ApiProperty({ enum: PLAY_STYLES, enumName: 'PlayStyle' })
  style: PlayStyle;

  @ApiProperty({ enum: PLAY_WHENS, enumName: 'PlayWhen' })
  playWhen: PlayWhen;

  @ApiProperty({ enum: DURATIONS })
  durationHours: Duration;

  startsAt: Date;
  /** Count down to this. */
  expiresAt: Date;
  note: string | null;

  /** expired as soon as expiresAt passes, even before the expiry job runs. */
  @ApiProperty({ enum: LISTING_STATUSES, enumName: 'ListingStatus' })
  status: ListingStatus;

  createdAt: Date;
  /** Your latest request to join, for "Requested…" / "Connected ✓". Null on your own. */
  myRequest: MyRequestDto | null;
  /** Link for Telegram/WhatsApp. */
  shareUrl: string;
}

export class ListingPageDto {
  items: ListingDto[];
  nextCursor: string | null;
}

export class MyListingDto {
  /** Your open or full listing, or null. */
  listing: ListingDto | null;
}

export class ListingStatsDto {
  /** Distinct people in your city with an open listing or a "looking" status. */
  lookingNow: number;
}

/** For share pages: nothing that identifies the owner beyond their display name. */
export class PublicListingDto {
  id: string;
  ownerDisplayName: string;
  ownerAvatarUrl: string | null;
  game: GameRefDto;
  mode: ModeRefDto | null;
  rank: RankRefDto | null;

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform' })
  platform: Platform;

  partySize: number;
  filled: number;

  @ApiProperty({ enum: VOICES, enumName: 'Voice' })
  voice: Voice;

  @ApiProperty({ enum: PLAY_WHENS, enumName: 'PlayWhen' })
  playWhen: PlayWhen;

  startsAt: Date;
  expiresAt: Date;
  note: string | null;

  @ApiProperty({ enum: LISTING_STATUSES, enumName: 'ListingStatus' })
  status: ListingStatus;
}
