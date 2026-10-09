import { Controller, Get, Inject, Param } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { eq } from 'drizzle-orm';
import { Public, CurrentUser } from '../auth/auth.decorators.js';
import { USERNAME } from '../auth/auth.dto.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { users } from '../db/schema/index.js';
import { MeDto, toMe } from './me.dto.js';

export class UsernameAvailability {
  available: boolean;
  /** Why it isn't: "taken" or "invalid". */
  reason?: 'taken' | 'invalid';
}

// Operation ids become client method names: meGet, usernamesCheck.

@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class MeController {
  /** The signed-in user. */
  @Get()
  @ApiOkResponse({ type: MeDto })
  get(@CurrentUser() user: User): MeDto {
    return toMe(user);
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
