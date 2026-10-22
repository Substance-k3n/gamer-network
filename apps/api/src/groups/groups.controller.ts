import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
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
import { PostPageDto } from '../feed/feed.dto.js';
import { PostsService } from '../feed/posts.service.js';
import { Idempotent } from '../idempotency/idempotency.js';
import { GroupEventsService } from './group-events.service.js';
import {
  CreateGroupBody,
  CreateGroupEventBody,
  GroupMembersQuery,
  GroupsQuery,
  MyGroupsQuery,
  SetGroupRoleBody,
  UpdateGroupBody,
} from './groups.body.js';
import {
  GroupDto,
  GroupEventDto,
  GroupEventPageDto,
  GroupMemberPageDto,
  GroupPageDto,
} from './groups.dto.js';
import { GroupsService } from './groups.service.js';

// docs/FEED_AND_GROUPS_API.md "Groups". A group you may not see is a 404.

const groupId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That group') });
const userId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That member') });
const eventId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That event') });

// Operation ids: groupsList, groupsGet, groupsCreate, groupsUpdate, groupsJoin, groupsLeave,
// groupsMembers, groupsApprove, groupsDecline, groupsSetRole, groupsRemoveMember, groupsPosts,
// groupsEvents, groupsCreateEvent.

@ApiTags('groups')
@ApiBearerAuth()
@Controller('groups')
export class GroupsController {
  constructor(
    private readonly groups: GroupsService,
    private readonly groupEvents: GroupEventsService,
    private readonly feed: PostsService,
  ) {}

  /** Discover (most members first) or Yours (yours and your requests, latest activity first); kind and a 2+ character search. */
  @Get()
  @ApiOkResponse({ type: GroupPageDto })
  list(@CurrentUser() user: User, @Query() query: GroupsQuery): Promise<GroupPageDto> {
    return this.groups.list(user, query);
  }

  /** One group. */
  @Get(':id')
  @ApiOkResponse({ type: GroupDto })
  get(@CurrentUser() user: User, @Param('id', groupId) id: string): Promise<GroupDto> {
    return this.groups.get(user, id);
  }

  /** Start a group; you're its admin. 409 group_name_taken. 3 a day: 429 rate_limited. */
  @Post()
  @Idempotent()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: GroupDto })
  create(@CurrentUser() user: User, @Body() body: CreateGroupBody): Promise<GroupDto> {
    return this.groups.create(user, body);
  }

  /** Admins (403 not_group_admin): change any of the create fields but kind. 409 group_name_taken. */
  @Patch(':id')
  @ApiOkResponse({ type: GroupDto })
  update(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Body() body: UpdateGroupBody,
  ): Promise<GroupDto> {
    return this.groups.update(user, id, body);
  }

  /** Join, or ask to on approval groups (myStatus pending; its admins are told). 409 already_member. 30 a day. */
  @Post(':id/join')
  @HttpCode(200)
  @ApiOkResponse({ type: GroupDto })
  join(@CurrentUser() user: User, @Param('id', groupId) id: string): Promise<GroupDto> {
    return this.groups.join(user, id);
  }

  /** Leave, or cancel your request. 409 last_admin when you're its only admin and others remain. */
  @Delete(':id/membership')
  @HttpCode(204)
  @ApiNoContentResponse()
  leave(@CurrentUser() user: User, @Param('id', groupId) id: string): Promise<void> {
    return this.groups.leave(user, id);
  }

  /** Members, admins first; status=pending lists the requests, for admins only (403 not_group_admin). */
  @Get(':id/members')
  @ApiOkResponse({ type: GroupMemberPageDto })
  members(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Query() query: GroupMembersQuery,
  ): Promise<GroupMemberPageDto> {
    return this.groups.members(user, id, query);
  }

  /** Admins let a request in; tells them. */
  @Post(':id/members/:userId/approve')
  @HttpCode(204)
  @ApiNoContentResponse()
  approve(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Param('userId', userId) member: string,
  ): Promise<void> {
    return this.groups.approve(user, id, member);
  }

  /** Admins turn a request down, without telling them. */
  @Post(':id/members/:userId/decline')
  @HttpCode(204)
  @ApiNoContentResponse()
  decline(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Param('userId', userId) member: string,
  ): Promise<void> {
    return this.groups.decline(user, id, member);
  }

  /** Admins make a member admin, or back. 409 last_admin for the only admin. */
  @Put(':id/members/:userId/role')
  @HttpCode(204)
  @ApiNoContentResponse()
  setRole(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Param('userId', userId) member: string,
    @Body() body: SetGroupRoleBody,
  ): Promise<void> {
    return this.groups.setRole(user, id, member, body.role);
  }

  /** Admins remove a member (or drop a request). */
  @Delete(':id/members/:userId')
  @HttpCode(204)
  @ApiNoContentResponse()
  removeMember(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Param('userId', userId) member: string,
  ): Promise<void> {
    return this.groups.removeMember(user, id, member);
  }

  /** The group's posts, newest first. Members only (403 not_member). Post here with POST /v1/posts and groupId. */
  @Get(':id/posts')
  @ApiOkResponse({ type: PostPageDto })
  posts(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Query() query: PageQuery,
  ): Promise<PostPageDto> {
    return this.feed.ofGroup(user, id, query);
  }

  /** Upcoming events (until an hour after they start), soonest first. Anyone may see them. */
  @Get(':id/events')
  @ApiOkResponse({ type: GroupEventPageDto })
  events(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Query() query: PageQuery,
  ): Promise<GroupEventPageDto> {
    return this.groupEvents.list(user, id, query);
  }

  /** Members add one (403 not_member), starting within the next 60 days. Tells the other members. */
  @Post(':id/events')
  @Idempotent()
  @ApiCreatedResponse({ type: GroupEventDto })
  createEvent(
    @CurrentUser() user: User,
    @Param('id', groupId) id: string,
    @Body() body: CreateGroupEventBody,
  ): Promise<GroupEventDto> {
    return this.groupEvents.create(user, id, body);
  }
}

// Operation ids: groupEventsDelete, groupEventsGoing, groupEventsNotGoing.

@ApiTags('groups')
@ApiBearerAuth()
@Controller('group-events')
export class GroupEventsController {
  constructor(private readonly events: GroupEventsService) {}

  /** Its creator or a group admin (403 not_owner). */
  @Delete(':id')
  @HttpCode(204)
  @ApiNoContentResponse()
  delete(@CurrentUser() user: User, @Param('id', eventId) id: string): Promise<void> {
    return this.events.delete(user, id);
  }

  /** I'm in. Members only (403 not_member). Repeating it is fine. */
  @Put(':id/going')
  @ApiOkResponse({ type: GroupEventDto })
  going(@CurrentUser() user: User, @Param('id', eventId) id: string): Promise<GroupEventDto> {
    return this.events.going(user, id, true);
  }

  /** Not going any more. */
  @Delete(':id/going')
  @ApiOkResponse({ type: GroupEventDto })
  notGoing(@CurrentUser() user: User, @Param('id', eventId) id: string): Promise<GroupEventDto> {
    return this.events.going(user, id, false);
  }
}

// Operation ids: myGroupsList.

@ApiTags('groups')
@ApiBearerAuth()
@Controller('me')
export class MyGroupsController {
  constructor(private readonly groups: GroupsService) {}

  /** Your groups and your pending requests (myStatus pending), latest activity first: the profile's Groups. */
  @Get('groups')
  @ApiOkResponse({ type: GroupPageDto })
  list(@CurrentUser() user: User, @Query() query: MyGroupsQuery): Promise<GroupPageDto> {
    return this.groups.mine(user, query);
  }
}

// Operation ids: userGroupsList.

@ApiTags('groups')
@ApiBearerAuth()
@Controller('users')
export class UserGroupsController {
  constructor(private readonly groups: GroupsService) {}

  /** The groups they're a member of, latest joined first (profile). */
  @Get(':username/groups')
  @ApiOkResponse({ type: GroupPageDto })
  list(
    @CurrentUser() user: User,
    @Param('username') username: string,
    @Query() query: PageQuery,
  ): Promise<GroupPageDto> {
    return this.groups.ofUser(user, username, query);
  }
}
