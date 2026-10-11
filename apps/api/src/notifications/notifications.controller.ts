import { Body, Controller, Get, HttpCode, Inject, Post, Put, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { sql } from 'drizzle-orm';
import { BeforeOnboarding, CurrentSession, CurrentUser } from '../auth/auth.decorators.js';
import type { Session, User } from '../auth/sessions.service.js';
import { AppError } from '../common/app-error.js';
import { PageQuery } from '../common/cursor.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { devices } from '../db/schema/index.js';
import {
  MarkReadBody,
  NotificationPageDto,
  RegisterDeviceBody,
  UnreadCountDto,
} from './notifications.dto.js';
import { NotificationsService } from './notifications.service.js';

// Operation ids: notificationsList, notificationsUnreadCount, notificationsMarkRead,
// devicesRegister.

@ApiTags('notifications')
@ApiBearerAuth()
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  /** Alerts, newest first. */
  @Get()
  @ApiOkResponse({ type: NotificationPageDto })
  list(@CurrentUser() user: User, @Query() q: PageQuery): Promise<NotificationPageDto> {
    return this.notifications.list(user, q.limit, q.cursor);
  }

  /** For the bell badge. */
  @Get('unread-count')
  @ApiOkResponse({ type: UnreadCountDto })
  async unreadCount(@CurrentUser() user: User): Promise<UnreadCountDto> {
    return { count: await this.notifications.unreadCount(user) };
  }

  /** `{ ids }` or `{ all: true }`. */
  @Post('read')
  @HttpCode(204)
  @ApiNoContentResponse()
  async markRead(@CurrentUser() user: User, @Body() body: MarkReadBody): Promise<void> {
    if (!body.all && !body.ids) {
      throw new AppError(422, 'validation_failed', 'Send ids or all: true.', {
        ids: 'Send ids or all: true',
      });
    }
    await this.notifications.markRead(user, body.all ? 'all' : body.ids!);
  }
}

@ApiTags('notifications')
@ApiBearerAuth()
@BeforeOnboarding()
@Controller('me/devices')
export class DevicesController {
  constructor(@Inject(DB) private readonly db: Db) {}

  /**
   * Where to push. Call on every launch and when the FCM token changes.
   * Tied to this sign-in: logging out stops pushes to the device.
   */
  @Put()
  @HttpCode(204)
  @ApiNoContentResponse()
  async register(
    @CurrentUser() user: User,
    @CurrentSession() session: Session,
    @Body() body: RegisterDeviceBody,
  ): Promise<void> {
    const values = {
      userId: user.id,
      sessionId: session.id,
      platform: body.platform,
      appVersion: body.appVersion ?? null,
      lastSeenAt: new Date(),
    };
    // A token moves to whoever signed in on that phone last.
    await this.db
      .insert(devices)
      .values({ ...values, fcmToken: body.fcmToken })
      .onConflictDoUpdate({ target: devices.fcmToken, set: { ...values, lastSeenAt: sql`now()` } });
  }
}
