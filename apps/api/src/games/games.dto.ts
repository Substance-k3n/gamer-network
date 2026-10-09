import { ApiProperty } from '@nestjs/swagger';
import { type Platform, PLATFORMS } from '../common/enums.dto.js';

export class RankDto {
  id: string;
  /** e.g. "Diamond", "Div 3" */
  name: string;
  /** Position on the ladder, 0 = lowest. */
  tier: number;
}

export class RoleDto {
  id: string;
  name: string;
}

export class ModeDto {
  id: string;
  /** Ranked, Unrated or Casual */
  name: string;
  isRanked: boolean;
}

export class GameDto {
  /** Short id shared with the app's catalog, e.g. "val". */
  id: string;
  name: string;
  /** Tile label, e.g. "VAL". */
  shortCode: string;

  @ApiProperty({ enum: PLATFORMS, enumName: 'Platform', isArray: true })
  platforms: Platform[];

  /** False when the ladder is play-style levels rather than ranks. */
  hasRanks: boolean;
  /** Largest party a listing can ask for: 2 = Duo … 5 = 5-stack. */
  maxParty: number;
  /** Launch games are the ones Find Players offers. */
  isLaunch: boolean;
  /** Lowest first. */
  ranks: RankDto[];
  roles: RoleDto[];
  modes: ModeDto[];
}
