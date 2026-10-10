import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser, RequireVerifiedEmail } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import {
  AnswerCheckInBody,
  CheckInListDto,
  InviteListQuery,
  PlayInviteDto,
  PlayInviteListDto,
  SendInviteBody,
} from './play.dto.js';
import { PlayService } from './play.service.js';
import { Idempotent } from '../idempotency/idempotency.js';

const inviteId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That invite') });
const checkInId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That check-in') });

// Operation ids: playInvitesSend, playInvitesList, playInvitesAccept,
// playInvitesDecline, checkInsDue, checkInsAnswer.

@ApiTags('play')
@ApiBearerAuth()
@Controller('play-invites')
export class PlayInvitesController {
  constructor(private readonly play: PlayService) {}

  /**
   * "Play together" with a connection. 403 not_connected, 409 invite_pending,
   * 429 daily_limit (20 a day).
   */
  @Post()
  @Idempotent()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: PlayInviteDto })
  send(@CurrentUser() user: User, @Body() body: SendInviteBody): Promise<PlayInviteDto> {
    return this.play.invite(user, body);
  }

  /** Pending invites to you (the banner) or from you. */
  @Get()
  @ApiOkResponse({ type: PlayInviteListDto })
  async list(
    @CurrentUser() user: User,
    @Query() { direction = 'incoming' }: InviteListQuery,
  ): Promise<PlayInviteListDto> {
    return { items: await this.play.list(user, direction) };
  }

  /** Schedules the check-ins. 409 invite_expired after startsAt + 15 min. */
  @Post(':id/accept')
  @HttpCode(200)
  @ApiOkResponse({ type: PlayInviteDto })
  accept(@CurrentUser() user: User, @Param('id', inviteId) id: string): Promise<PlayInviteDto> {
    return this.play.accept(user, id);
  }

  @Post(':id/decline')
  @HttpCode(204)
  @ApiNoContentResponse()
  decline(@CurrentUser() user: User, @Param('id', inviteId) id: string): Promise<void> {
    return this.play.decline(user, id);
  }
}

@ApiTags('play')
@ApiBearerAuth()
@Controller()
export class CheckInsController {
  constructor(private readonly play: PlayService) {}

  /** "Did you play with …?" cards for Home. */
  @Get('me/check-ins')
  @ApiOkResponse({ type: CheckInListDto })
  async due(@CurrentUser() user: User): Promise<CheckInListDto> {
    return { items: await this.play.dueCheckIns(user) };
  }

  /** One tap. The product's main number (docs/PRD.md). */
  @Post('check-ins/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  answer(
    @CurrentUser() user: User,
    @Param('id', checkInId) id: string,
    @Body() body: AnswerCheckInBody,
  ): Promise<void> {
    return this.play.answer(user, id, body.answer);
  }
}
