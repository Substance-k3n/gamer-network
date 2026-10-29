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
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AdminOnly, CurrentUser } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import {
  AdminReportDto,
  AdminReportPageDto,
  AdminReportsQuery,
  AdminUserDto,
  AdminUserNumberPageDto,
  AdminUsersQuery,
  BanBody,
  MetricsDto,
  MetricsQuery,
  NoteBody,
  ResolveReportBody,
} from './admin.dto.js';
import {
  AdminGameDto,
  AdminGamePageDto,
  AdminGamesQuery,
  CreateGameBody,
  CreateRankBody,
  CreateUserBody,
  UpdateGameBody,
  UpdateRankBody,
  UpdateUserBody,
} from './admin-catalog.dto.js';
import { AdminCatalogService } from './admin-catalog.service.js';
import { AdminService } from './admin.service.js';

const uuid = (what: string) => new ParseUUIDPipe({ exceptionFactory: () => notFound(what) });

// For apps/admin. Operation ids: adminReports, adminResolveReport, adminUsers,
// adminUser, adminCreateUser, adminUpdateUser, adminDeleteUser, adminBan,
// adminUnban, adminRemoveListing, adminRemovePost, adminRemoveComment,
// adminRemoveGroup, adminGames, adminGame, adminCreateGame, adminUpdateGame,
// adminDeleteGame, adminCreateRank, adminUpdateRank, adminDeleteRank,
// adminMetrics.

@ApiTags('admin')
@ApiBearerAuth()
@AdminOnly()
@Controller('admin')
export class AdminController {
  constructor(
    private readonly admin: AdminService,
    private readonly catalog: AdminCatalogService,
  ) {}

  /** The queue. Open ones oldest first. */
  @Get('reports')
  @ApiOkResponse({ type: AdminReportPageDto })
  reports(@Query() q: AdminReportsQuery): Promise<AdminReportPageDto> {
    return this.admin.reports(q.status ?? 'open', q.limit, q.cursor);
  }

  /** dismiss, warn, remove_listing, remove_post, remove_comment, remove_group or ban. 409 report_closed if already handled. */
  @Post('reports/:id/resolve')
  @HttpCode(200)
  @ApiOkResponse({ type: AdminReportDto })
  resolveReport(
    @CurrentUser() admin: User,
    @Param('id', uuid('That report')) id: string,
    @Body() body: ResolveReportBody,
  ): Promise<AdminReportDto> {
    return this.admin.resolve(admin, id, body.action, body.note);
  }

  /** Search and page through players, newest first. */
  @Get('users')
  @ApiOkResponse({ type: AdminUserNumberPageDto })
  users(@Query() q: AdminUsersQuery): Promise<AdminUserNumberPageDto> {
    return this.admin.users(q);
  }

  /** An account with a verified email; they finish onboarding in the app. 409 email_taken or username_taken. */
  @Post('users')
  @ApiCreatedResponse({ type: AdminUserDto })
  createUser(@CurrentUser() admin: User, @Body() body: CreateUserBody): Promise<AdminUserDto> {
    return this.admin.createUser(admin, body);
  }

  /** Edit details or role. 409 email_taken, username_taken, or own_role (an admin demoting themself). */
  @Patch('users/:id')
  @ApiOkResponse({ type: AdminUserDto })
  updateUser(
    @CurrentUser() admin: User,
    @Param('id', uuid('That user')) id: string,
    @Body() body: UpdateUserBody,
  ): Promise<AdminUserDto> {
    return this.admin.updateUser(admin, id, body);
  }

  /** Deletes the account like DELETE /me: signed out now, erased in 30 days. 409 own_account. */
  @Delete('users/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  async deleteUser(
    @CurrentUser() admin: User,
    @Param('id', uuid('That user')) id: string,
  ): Promise<void> {
    await this.admin.deleteUser(admin, id);
  }

  /** The player drawer. */
  @Get('users/:id')
  @ApiOkResponse({ type: AdminUserDto })
  user(@Param('id', uuid('That user')) id: string): Promise<AdminUserDto> {
    return this.admin.user(id);
  }

  /** Signs them out everywhere and removes their live listing. */
  @Post('users/:id/ban')
  @HttpCode(200)
  @ApiOkResponse({ type: AdminUserDto })
  ban(
    @CurrentUser() admin: User,
    @Param('id', uuid('That user')) id: string,
    @Body() body: BanBody,
  ): Promise<AdminUserDto> {
    return this.admin.ban(admin, id, body.reason);
  }

  /** Lift a ban. */
  @Post('users/:id/unban')
  @HttpCode(200)
  @ApiOkResponse({ type: AdminUserDto })
  unban(
    @CurrentUser() admin: User,
    @Param('id', uuid('That user')) id: string,
    @Body() body: NoteBody,
  ): Promise<AdminUserDto> {
    return this.admin.unban(admin, id, body.note);
  }

  /** Take a listing down. */
  @Post('listings/:id/remove')
  @HttpCode(204)
  @ApiNoContentResponse()
  async removeListing(
    @CurrentUser() admin: User,
    @Param('id', uuid('That listing')) id: string,
    @Body() body: NoteBody,
  ): Promise<void> {
    await this.admin.removeListing(admin, id, body.note);
  }

  /** Take a post down. */
  @Post('posts/:id/remove')
  @HttpCode(204)
  @ApiNoContentResponse()
  async removePost(
    @CurrentUser() admin: User,
    @Param('id', uuid('That post')) id: string,
    @Body() body: NoteBody,
  ): Promise<void> {
    await this.admin.removePost(admin, id, body.note);
  }

  /** Take a comment down, with its replies. */
  @Post('comments/:id/remove')
  @HttpCode(204)
  @ApiNoContentResponse()
  async removeComment(
    @CurrentUser() admin: User,
    @Param('id', uuid('That comment')) id: string,
    @Body() body: NoteBody,
  ): Promise<void> {
    await this.admin.removeComment(admin, id, body.note);
  }

  /** Take a group down: it, its posts and events vanish for everyone. */
  @Post('groups/:id/remove')
  @HttpCode(204)
  @ApiNoContentResponse()
  async removeGroup(
    @CurrentUser() admin: User,
    @Param('id', uuid('That group')) id: string,
    @Body() body: NoteBody,
  ): Promise<void> {
    await this.admin.removeGroup(admin, id, body.note);
  }

  /** The catalog with player counts, by page. Deleted games with state=deleted. */
  @Get('games')
  @ApiOkResponse({ type: AdminGamePageDto })
  games(@Query() q: AdminGamesQuery): Promise<AdminGamePageDto> {
    return this.catalog.games(q);
  }

  /** One game with its ranks and counts, deleted or not. */
  @Get('games/:id')
  @ApiOkResponse({ type: AdminGameDto })
  game(@Param('id') id: string): Promise<AdminGameDto> {
    return this.catalog.game(id);
  }

  /** Adds a game to the catalog. 409 game_exists if the id is used (deleted games too). */
  @Post('games')
  @ApiCreatedResponse({ type: AdminGameDto })
  createGame(@CurrentUser() admin: User, @Body() body: CreateGameBody): Promise<AdminGameDto> {
    return this.catalog.createGame(admin, body);
  }

  /** Edit a game; `isLaunch` alone puts it on Find Players or takes it off. */
  @Patch('games/:id')
  @ApiOkResponse({ type: AdminGameDto })
  updateGame(
    @CurrentUser() admin: User,
    @Param('id') id: string,
    @Body() body: UpdateGameBody,
  ): Promise<AdminGameDto> {
    return this.catalog.updateGame(admin, id, body);
  }

  /** Takes it out of the catalog and off every profile; its live listings close. */
  @Delete('games/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  async deleteGame(@CurrentUser() admin: User, @Param('id') id: string): Promise<void> {
    await this.catalog.deleteGame(admin, id);
  }

  /** Adds a rank; without `tier` it goes on top. */
  @Post('games/:id/ranks')
  @ApiCreatedResponse({ type: AdminGameDto })
  createRank(
    @CurrentUser() admin: User,
    @Param('id') id: string,
    @Body() body: CreateRankBody,
  ): Promise<AdminGameDto> {
    return this.catalog.createRank(admin, id, body);
  }

  /** Rename a rank, or move it: a taken tier swaps the two. */
  @Patch('games/:id/ranks/:rankId')
  @ApiOkResponse({ type: AdminGameDto })
  updateRank(
    @CurrentUser() admin: User,
    @Param('id') id: string,
    @Param('rankId', uuid('That rank')) rankId: string,
    @Body() body: UpdateRankBody,
  ): Promise<AdminGameDto> {
    return this.catalog.updateRank(admin, id, rankId, body);
  }

  /** Players and listings with it keep the game without a rank. */
  @Delete('games/:id/ranks/:rankId')
  @ApiOkResponse({ type: AdminGameDto })
  deleteRank(
    @CurrentUser() admin: User,
    @Param('id') id: string,
    @Param('rankId', uuid('That rank')) rankId: string,
  ): Promise<AdminGameDto> {
    return this.catalog.deleteRank(admin, id, rankId);
  }

  /** The MVP's numbers. Defaults to the last 30 days. */
  @Get('metrics')
  @ApiOkResponse({ type: MetricsDto })
  metrics(@Query() q: MetricsQuery): Promise<MetricsDto> {
    const to = q.to ?? new Date();
    const from = q.from ?? new Date(to.getTime() - 30 * 24 * 3600_000);
    return this.admin.metrics(from, to);
  }
}
