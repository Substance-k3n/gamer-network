import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsArray, IsBoolean, IsIn, IsOptional, IsString, IsUUID, Length } from 'class-validator';
import { notificationType } from '../db/schema/index.js';
import { UserCardDto } from '../me/profile.dto.js';
import type { NotificationType } from './notification-text.js';

export const NOTIFICATION_TYPES = notificationType.enumValues;

export class NotificationDto {
  id: string;

  @ApiProperty({ enum: NOTIFICATION_TYPES, enumName: 'NotificationType' })
  type: NotificationType;

  /** Who caused it; for check_in_due, who you played with. */
  actor: UserCardDto | null;
  listingId: string | null;
  connectionRequestId: string | null;
  playInviteId: string | null;
  checkInId: string | null;
  /** Push title. */
  title: string;
  /** Ready to show, e.g. "Hana wants to play PUBG Mobile with you". */
  text: string;
  /** In-app path to open on tap, same as the push's data.route. */
  route: string;
  readAt: Date | null;
  createdAt: Date;
}

export class NotificationPageDto {
  items: NotificationDto[];
  nextCursor: string | null;
}

export class UnreadCountDto {
  count: number;
}

export class MarkReadBody {
  /** Ids to mark read. Or send all: true. */
  @IsOptional()
  @IsArray()
  @IsUUID('7', { each: true })
  ids?: string[];

  @IsOptional()
  @IsBoolean()
  all?: boolean;
}

export const DEVICE_PLATFORMS = ['android', 'ios', 'web'] as const;

export class RegisterDeviceBody {
  /** From FirebaseMessaging.getToken(). */
  @IsString()
  @Length(10, 4096)
  fcmToken: string;

  @ApiProperty({ enum: DEVICE_PLATFORMS, enumName: 'DevicePlatform' })
  @IsIn(DEVICE_PLATFORMS)
  platform: (typeof DEVICE_PLATFORMS)[number];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(1, 20)
  appVersion?: string;
}
