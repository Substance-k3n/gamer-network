import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, IsUUID } from 'class-validator';
import { checkInAnswer, inviteStatus, inviteWhen } from '../db/schema/index.js';
import { GameRefDto, UserCardDto } from '../me/profile.dto.js';

export const INVITE_WHENS = inviteWhen.enumValues;
export type InviteWhenValue = (typeof INVITE_WHENS)[number];
export const INVITE_STATUSES = inviteStatus.enumValues;
export const CHECK_IN_ANSWERS = checkInAnswer.enumValues;
export type CheckInAnswer = (typeof CHECK_IN_ANSWERS)[number];

/** "Play together" between two connections. */
export class PlayInviteDto {
  id: string;
  from: UserCardDto;
  to: UserCardDto;
  game: GameRefDto;

  @ApiProperty({ enum: INVITE_WHENS, enumName: 'InviteWhen' })
  playWhen: InviteWhenValue;

  startsAt: Date;
  /** Count down to this; unanswered by then, it is expired. */
  expiresAt: Date;

  /** expired as soon as expiresAt passes while pending. */
  @ApiProperty({ enum: INVITE_STATUSES, enumName: 'InviteStatus' })
  status: (typeof INVITE_STATUSES)[number];

  createdAt: Date;
}

export class PlayInviteListDto {
  /** Pending and not expired, newest first. */
  items: PlayInviteDto[];
}

export class SendInviteBody {
  /** One of your connections. */
  @IsUUID()
  toUserId: string;

  /** Any catalog game. */
  @IsString()
  gameId: string;

  @ApiProperty({ enum: INVITE_WHENS, enumName: 'InviteWhen' })
  @IsIn(INVITE_WHENS)
  playWhen: InviteWhenValue;
}

export const INVITE_DIRECTIONS = ['incoming', 'outgoing'] as const;

export class InviteListQuery {
  @ApiPropertyOptional({ enum: INVITE_DIRECTIONS, default: 'incoming' })
  @IsOptional()
  @IsIn(INVITE_DIRECTIONS)
  direction?: (typeof INVITE_DIRECTIONS)[number];
}

/** "Did you play with Dave?" */
export class CheckInDto {
  id: string;
  /** Who you were matched with. */
  other: UserCardDto;
  /** The game of the listing or invite that led here. */
  game: GameRefDto | null;
  listingId: string | null;
  playInviteId: string | null;
  dueAt: Date;
}

export class CheckInListDto {
  /** Due and unanswered, oldest first. */
  items: CheckInDto[];
}

export class AnswerCheckInBody {
  @ApiProperty({ enum: CHECK_IN_ANSWERS, enumName: 'CheckInAnswer' })
  @IsIn(CHECK_IN_ANSWERS)
  answer: CheckInAnswer;
}
