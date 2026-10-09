import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
} from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { BeforeOnboarding, CurrentUser } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import {
  BlockBody,
  BlockListDto,
  DeleteAccountBody,
  ReportBody,
  WaitlistBody,
} from './safety.dto.js';
import { SafetyService } from './safety.service.js';

const userId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That block') });

// Operation ids: safetyBlock, safetyUnblock, safetyBlocked, safetyReport,
// safetyJoinWaitlist, accountDelete.

@ApiTags('safety')
@ApiBearerAuth()
@Controller()
export class SafetyController {
  constructor(private readonly safety: SafetyService) {}

  /** Hides you from each other everywhere and ends the connection. */
  @Post('blocks')
  @HttpCode(204)
  @ApiNoContentResponse()
  block(@CurrentUser() user: User, @Body() body: BlockBody): Promise<void> {
    return this.safety.block(user, body.userId);
  }

  @Delete('blocks/:userId')
  @HttpCode(204)
  @ApiNoContentResponse()
  unblock(@CurrentUser() user: User, @Param('userId', userId) other: string): Promise<void> {
    return this.safety.unblock(user, other);
  }

  /** Settings → Blocked users. */
  @Get('me/blocks')
  @ApiOkResponse({ type: BlockListDto })
  async blocked(@CurrentUser() user: User): Promise<BlockListDto> {
    return { items: await this.safety.blocked(user) };
  }

  /** Goes to the admin reports queue. */
  @Post('reports')
  @HttpCode(204)
  @ApiNoContentResponse()
  report(@CurrentUser() user: User, @Body() body: ReportBody): Promise<void> {
    return this.safety.report(user, body);
  }

  /** "Notify me" for features that aren't built yet (Groups). */
  @Post('waitlist')
  @HttpCode(204)
  @ApiNoContentResponse()
  joinWaitlist(@CurrentUser() user: User, @Body() body: WaitlistBody): Promise<void> {
    return this.safety.joinWaitlist(user, body.topic);
  }
}

@ApiTags('safety')
@ApiBearerAuth()
@BeforeOnboarding()
@Controller('me')
export class AccountController {
  constructor(private readonly safety: SafetyService) {}

  /**
   * Delete your account (Settings). Needs your password if you have one
   * (401 wrong_password). Signs out everywhere; personal data is erased
   * after 30 days.
   */
  @Delete()
  @HttpCode(204)
  @ApiNoContentResponse()
  delete(@CurrentUser() user: User, @Body() body: DeleteAccountBody): Promise<void> {
    return this.safety.deleteAccount(user, body.password);
  }
}
