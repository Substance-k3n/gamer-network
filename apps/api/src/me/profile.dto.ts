import { ApiProperty } from '@nestjs/swagger';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';
import { ageRange, gamingIdKind, idVisibility, playerStatus, playTag } from '../db/schema/index.js';

export const AGE_RANGES = ageRange.enumValues;
export type AgeRange = (typeof AGE_RANGES)[number];
export const PLAYER_STATUSES = playerStatus.enumValues;
export type PlayerStatus = (typeof PLAYER_STATUSES)[number];
export const PLAY_TAGS = playTag.enumValues;
export type PlayTag = (typeof PLAY_TAGS)[number];
export const GAMING_ID_KINDS = gamingIdKind.enumValues;
export type GamingIdKind = (typeof GAMING_ID_KINDS)[number];
export const ID_VISIBILITIES = idVisibility.enumValues;
export type IdVisibility = (typeof ID_VISIBILITIES)[number];

/** Bit order of users.available_days: mon = 1 … sun = 64. */
export const DAYS = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'] as const;
export type Day = (typeof DAYS)[number];

export const daysToMask = (days: Day[]) => days.reduce((m, d) => m | (1 << DAYS.indexOf(d)), 0);
export const maskToDays = (mask: number) => DAYS.filter((_, i) => mask & (1 << i));

export class GameRefDto {
  id: string;
  name: string;
  shortCode: string;
}

export class RankRefDto {
  id: string;
  name: string;
  tier: number;
}

export class RoleRefDto {
  id: string;
  name: string;
}

/** One game on a profile: a catalog game, or a custom one added by name. */
export class UserGameDto {
  id: string;
  /** Null for a custom game. */
  game: GameRefDto | null;
  /** Set only for a custom game. */
  customGameName: string | null;
  rank: RankRefDto | null;
  /** Free-text level, custom games only. */
  rankText: string | null;
  role: RoleRefDto | null;
}

export class GamingIdDto {
  id: string;

  @ApiProperty({ enum: GAMING_ID_KINDS, enumName: 'GamingIdKind' })
  kind: GamingIdKind;

  /** Set when kind is in_game. */
  game: GameRefDto | null;
  value: string;

  @ApiProperty({ enum: ID_VISIBILITIES, enumName: 'IdVisibility' })
  visibility: IdVisibility;
}

export class ProfileStatsDto {
  connections: number;
  games: number;
  /** Different people you checked in "played" with. */
  playedWith: number;
}

/** Everywhere a person appears in a list. */
export class UserCardDto {
  id: string;
  username: string;
  displayName: string;
  avatarUrl: string | null;
  city: string;

  /** Already reset to not_available once its time has passed. */
  @ApiProperty({ enum: PLAYER_STATUSES, enumName: 'PlayerStatus' })
  status: PlayerStatus;

  /** The game behind "Playing …". */
  statusGame: GameRefDto | null;
  /** First game on the profile. */
  topGame: UserGameDto | null;
}

export const RELATIONSHIPS = [
  'self',
  'none',
  'outgoing_request',
  'incoming_request',
  'connected',
] as const;
export type Relationship = (typeof RELATIONSHIPS)[number];

export class ProfileDto extends UserCardDto {
  bio: string | null;

  @ApiProperty({ enum: AGE_RANGES, enumName: 'AgeRange' })
  ageRange: AgeRange;

  @ApiProperty({ enum: DAYS, enumName: 'Day', isArray: true })
  availableDays: Day[];

  /** When available_tonight or playing clears itself. */
  statusUntil: Date | null;

  /** In profile order. */
  games: UserGameDto[];

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  platforms: Platform[];

  @ApiProperty({ enum: PLAY_TAGS, enumName: 'PlayTag', isArray: true })
  tags: PlayTag[];

  /** Only the ones you may see. */
  gamingIds: GamingIdDto[];
  stats: ProfileStatsDto;

  @ApiProperty({ enum: RELATIONSHIPS, enumName: 'Relationship' })
  relationship: Relationship;

  /** Set when relationship is incoming_request, to accept from the profile. */
  incomingRequestId: string | null;
}

export class AvatarUploadDto {
  /**
   * PUT the file here before `expiresAt`, with `headers`. The body must be
   * exactly the `size` you asked for (the URL is signed for it); let the
   * HTTP client set Content-Length.
   */
  uploadUrl: string;
  /** Send these with the upload (Content-Type). */
  headers: Record<string, string>;
  /** Send to PUT /v1/me/avatar once the upload succeeds. */
  key: string;
  expiresAt: Date;
}
