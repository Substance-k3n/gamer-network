import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsString, Length } from 'class-validator';
import { CurrentUser } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { ProfileDto, UserCardDto } from '../me/profile.dto.js';
import { UsersService } from './users.service.js';

export class UserSearchQuery {
  /** At least 2 characters of a username or display name. */
  @Transform(({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value))
  @IsString()
  @Length(2, 30, { message: 'Type at least 2 characters' })
  query: string;
}

export class UserSearchResponse {
  /** Up to 20, by username. */
  items: UserCardDto[];
}

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
