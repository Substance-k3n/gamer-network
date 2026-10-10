import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
} from '@nestjs/common';
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
import { PageQuery } from '../common/cursor.js';
import {
  AcceptedRequestDto,
  ConnectionPageDto,
  ConnectionRequestDto,
  ConnectionRequestListDto,
  RequestListQuery,
  SendRequestBody,
} from './connections.dto.js';
import { ConnectionsService } from './connections.service.js';
import { Idempotent } from '../idempotency/idempotency.js';

const requestId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That request') });
const userId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That connection') });

// Operation ids: connectionRequestsSend, connectionRequestsList,
// connectionRequestsAccept, connectionRequestsDecline, connectionRequestsCancel,
// connectionsList, connectionsRemove.

@ApiTags('connections')
@ApiBearerAuth()
@Controller('connection-requests')
export class ConnectionRequestsController {
  constructor(private readonly connections: ConnectionsService) {}

  /**
   * "Connect" on a listing card (pass listingId) or a profile. 409 already_connected,
   * request_pending, request_waiting_for_you (fields.requestId: accept that instead),
   * listing_not_open; 429 request_cooldown, daily_limit.
   */
  @Post()
  @Idempotent()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: ConnectionRequestDto })
  send(@CurrentUser() user: User, @Body() body: SendRequestBody): Promise<ConnectionRequestDto> {
    return this.connections.send(user, body);
  }

  /** Pending requests to you (Alerts) or from you. */
  @Get()
  @ApiOkResponse({ type: ConnectionRequestListDto })
  async list(
    @CurrentUser() user: User,
    @Query() { direction = 'incoming' }: RequestListQuery,
  ): Promise<ConnectionRequestListDto> {
    return { items: await this.connections.list(user, direction) };
  }

  /** Connects you; takes a slot on their listing and schedules check-ins if it came from one. */
  @Post(':id/accept')
  @HttpCode(200)
  @ApiOkResponse({ type: AcceptedRequestDto })
  accept(
    @CurrentUser() user: User,
    @Param('id', requestId) id: string,
  ): Promise<AcceptedRequestDto> {
    return this.connections.accept(user, id);
  }

  /** "Not now". */
  @Post(':id/decline')
  @HttpCode(204)
  @ApiNoContentResponse()
  decline(@CurrentUser() user: User, @Param('id', requestId) id: string): Promise<void> {
    return this.connections.decline(user, id);
  }

  /** Withdraw your own pending request. */
  @Delete(':id')
  @HttpCode(204)
  @ApiNoContentResponse()
  cancel(@CurrentUser() user: User, @Param('id', requestId) id: string): Promise<void> {
    return this.connections.cancel(user, id);
  }
}

@ApiTags('connections')
@ApiBearerAuth()
@Controller()
export class ConnectionsController {
  constructor(private readonly connections: ConnectionsService) {}

  /** Your connections, newest first. */
  @Get('me/connections')
  @ApiOkResponse({ type: ConnectionPageDto })
  list(@CurrentUser() user: User, @Query() q: PageQuery): Promise<ConnectionPageDto> {
    return this.connections.mine(user, q.limit, q.cursor);
  }

  @Delete('connections/:userId')
  @HttpCode(204)
  @ApiNoContentResponse()
  remove(@CurrentUser() user: User, @Param('userId', userId) other: string): Promise<void> {
    return this.connections.remove(user, other);
  }
}
