import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AdminOnly, CurrentUser } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import {
  AdminReportDto,
  AdminReportPageDto,
  AdminReportsQuery,
  AdminUserDto,
  AdminUserPageDto,
  AdminUsersQuery,
  BanBody,
  MetricsDto,
  MetricsQuery,
  NoteBody,
  ResolveReportBody,
  SetLaunchBody,
} from './admin.dto.js';
import { AdminService } from './admin.service.js';

const uuid = (what: string) => new ParseUUIDPipe({ exceptionFactory: () => notFound(what) });

// For apps/admin. Operation ids: adminReports, adminResolveReport, adminUsers,
// adminUser, adminBan, adminUnban, adminRemoveListing, adminSetLaunch, adminMetrics.

@ApiTags('admin')
@ApiBearerAuth()
@AdminOnly()
@Controller('admin')
export class AdminController {
  constructor(private readonly admin: AdminService) {}

  /** The queue. Open ones oldest first. */
  @Get('reports')
  @ApiOkResponse({ type: AdminReportPageDto })
  reports(@Query() q: AdminReportsQuery): Promise<AdminReportPageDto> {
    return this.admin.reports(q.status ?? 'open', q.limit, q.cursor);
  }

  /** dismiss, warn, remove_listing or ban. 409 report_closed if already handled. */
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

  @Get('users')
  @ApiOkResponse({ type: AdminUserPageDto })
  users(@Query() q: AdminUsersQuery): Promise<AdminUserPageDto> {
    return this.admin.users(q);
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

  /** Puts a game on Find Players, or takes it off. */
  @Patch('games/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  setLaunch(
    @CurrentUser() admin: User,
    @Param('id') id: string,
    @Body() body: SetLaunchBody,
  ): Promise<void> {
    return this.admin.setLaunch(admin, id, body.isLaunch);
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
