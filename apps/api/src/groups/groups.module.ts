import { Module } from '@nestjs/common';
import { FeedModule } from '../feed/feed.module.js';
import { GroupAccess } from './group-access.js';
import { GroupEventsService } from './group-events.service.js';
import { GroupNotifier } from './group-notifier.js';
import {
  GroupEventsController,
  GroupsController,
  MyGroupsController,
  UserGroupsController,
} from './groups.controller.js';
import { GroupsService } from './groups.service.js';

/**
 * Groups (docs/FEED_AND_GROUPS_API.md phases 4 and 5): the groups, joining
 * with approval, members and roles, events with going, and profile groups.
 * Group posts are feed posts with a group_id (src/feed).
 */
@Module({
  imports: [FeedModule],
  controllers: [GroupsController, GroupEventsController, MyGroupsController, UserGroupsController],
  providers: [GroupsService, GroupEventsService, GroupAccess, GroupNotifier],
})
export class GroupsModule {}
