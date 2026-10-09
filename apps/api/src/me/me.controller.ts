import { Body, Controller, Get, HttpCode, Inject, Param, Patch, Post, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { eq } from 'drizzle-orm';
import { Public, CurrentUser } from '../auth/auth.decorators.js';
import { USERNAME } from '../auth/auth.dto.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { users } from '../db/schema/index.js';
import {
  SetGamesBody,
  SetGamingIdsBody,
  SetPlatformsBody,
  SetStatusBody,
  SetTagsBody,
  UpdateMeBody,
} from './me.body.js';
import { MeDto } from './me.dto.js';
import { ProfileService } from './profile.service.js';

export class UsernameAvailability {
  available: boolean;
  /** Why it isn't: "taken" or "invalid". */
  reason?: 'taken' | 'invalid';
}

// Operation ids become client method names: meGet, meUpdate, meSetGames …
// Every write answers with the whole Me, so the app replaces its copy.

@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class MeController {
  constructor(private readonly profiles: ProfileService) {}

  /** The signed-in user. */
  @Get()
  @ApiOkResponse({ type: MeDto })
  get(@CurrentUser() user: User): Promise<MeDto> {
    return this.profiles.me(user);
  }

  /** Onboarding step 1 and Edit profile. Only the fields sent change. */
  @Patch()
  @ApiOkResponse({ type: MeDto })
  update(@CurrentUser() user: User, @Body() body: UpdateMeBody): Promise<MeDto> {
    return this.profiles.update(user, body);
  }

  /** Replaces the games list. Onboarding steps 2 and 3. */
  @Put('games')
  @ApiOkResponse({ type: MeDto })
  setGames(@CurrentUser() user: User, @Body() body: SetGamesBody): Promise<MeDto> {
    return this.profiles.setGames(user, body);
  }

  @Put('platforms')
  @ApiOkResponse({ type: MeDto })
  setPlatforms(@CurrentUser() user: User, @Body() body: SetPlatformsBody): Promise<MeDto> {
    return this.profiles.setPlatforms(user, body);
  }

  @Put('tags')
  @ApiOkResponse({ type: MeDto })
  setTags(@CurrentUser() user: User, @Body() body: SetTagsBody): Promise<MeDto> {
    return this.profiles.setTags(user, body);
  }

  /** Replaces the gaming IDs list. New IDs show to connections only unless marked public. */
  @Put('gaming-ids')
  @ApiOkResponse({ type: MeDto })
  setGamingIds(@CurrentUser() user: User, @Body() body: SetGamingIdsBody): Promise<MeDto> {
    return this.profiles.setGamingIds(user, body);
  }

  /** The status card: what you're up to and which days you usually play. */
  @Put('status')
  @ApiOkResponse({ type: MeDto })
  setStatus(@CurrentUser() user: User, @Body() body: SetStatusBody): Promise<MeDto> {
    return this.profiles.setStatus(user, body);
  }

  /** "Go live": finishes onboarding. 422 profile_incomplete without a game. */
  @Post('onboard')
  @HttpCode(204)
  @ApiNoContentResponse()
  async onboard(@CurrentUser() user: User): Promise<void> {
    await this.profiles.onboard(user);
  }
}

@ApiTags('me')
@Public()
@Controller('usernames')
export class UsernamesController {
  constructor(@Inject(DB) private readonly db: Db) {}

  /** For the sign-up form while typing (debounce it). Case-insensitive. */
  @Get(':name')
  @ApiOkResponse({ type: UsernameAvailability })
  async check(@Param('name') name: string): Promise<UsernameAvailability> {
    const normalized = name.trim().toLowerCase();
    if (!USERNAME.test(normalized)) return { available: false, reason: 'invalid' };
    const taken = await this.db.query.users.findFirst({
      columns: { id: true },
      where: eq(users.username, normalized),
    });
    return taken ? { available: false, reason: 'taken' } : { available: true };
  }
}
