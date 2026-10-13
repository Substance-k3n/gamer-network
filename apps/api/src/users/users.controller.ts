import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CurrentUser } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { ProfileDto } from '../me/profile.dto.js';
import { UserSearchQuery, UserSearchResponse } from './users.dto.js';
import { UsersService } from './users.service.js';

// Operation ids: usersGet, usersSearch.

@ApiTags('users')
@ApiBearerAuth()
@Controller('users')
export class UsersController {
  constructor(private readonly users: UsersService) {}

  /** Someone's profile. 404 if they don't exist, aren't live, or either of you blocked the other. */
  @Get(':username')
  @ApiOkResponse({ type: ProfileDto })
  get(@CurrentUser() viewer: User, @Param('username') username: string): Promise<ProfileDto> {
    return this.users.profile(viewer, username);
  }

  /** Find people by username or display name prefix. */
  @Get()
  @ApiOkResponse({ type: UserSearchResponse })
  async search(
    @CurrentUser() viewer: User,
    @Query() { query }: UserSearchQuery,
  ): Promise<UserSearchResponse> {
    return { items: await this.users.search(viewer, query) };
  }
}
