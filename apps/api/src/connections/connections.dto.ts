import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsIn, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';
import { ListingDto, REQUEST_STATUSES, type RequestStatus } from '../listings/listings.dto.js';
import { UserCardDto } from '../me/profile.dto.js';

export class ConnectionRequestDto {
  id: string;
  from: UserCardDto;
  to: UserCardDto;
  /** Set when sent from a listing card ("wants to play · Div 2 EA FC 25"). */
  listing: ListingDto | null;
  message: string | null;

  @ApiProperty({ enum: REQUEST_STATUSES, enumName: 'RequestStatus' })
  status: RequestStatus;

  createdAt: Date;
}

export class ConnectionRequestListDto {
  /** Pending only, newest first. */
  items: ConnectionRequestDto[];
}

export class ConnectionDto {
  user: UserCardDto;
  connectedAt: Date;
}

export class ConnectionPageDto {
  items: ConnectionDto[];
  nextCursor: string | null;
}

export class AcceptedRequestDto {
  request: ConnectionRequestDto;
  connection: ConnectionDto;
}

export class SendRequestBody {
  @IsUUID()
  toUserId: string;

  /** When sent from a listing card: one of their live listings. */
  @IsOptional()
  @IsUUID()
  listingId?: string;

  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() || null : value,
  )
  @IsString()
  @MaxLength(140, { message: 'Keep it under 140 characters' })
  message?: string | null;
}

export const DIRECTIONS = ['incoming', 'outgoing'] as const;

export class RequestListQuery {
  /** incoming: asking you (Alerts). outgoing: yours, still waiting. */
  @ApiPropertyOptional({ enum: DIRECTIONS, default: 'incoming' })
  @IsOptional()
  @IsIn(DIRECTIONS)
  direction?: (typeof DIRECTIONS)[number];
}
