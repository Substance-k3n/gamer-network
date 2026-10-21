import { Module } from '@nestjs/common';
import { ConnectionsModule } from '../connections/connections.module.js';
import { CommentsService } from './comments.service.js';
import {
  CommentsController,
  FeedController,
  MediaController,
  MyPostsController,
  PostsController,
  PublicPostsController,
  RecruitApplicationsController,
  UserPostsController,
} from './feed.controller.js';
import { FeedNotifier } from './feed-notifier.js';
import { FeedReader } from './feed-reader.js';
import { MediaCleanupJob } from './media-cleanup.job.js';
import { MediaService } from './media.service.js';
import { PollsService } from './polls.service.js';
import { PostsService } from './posts.service.js';
import { RecruitService } from './recruit.service.js';

/**
 * Home feed (docs/FEED_AND_GROUPS_API.md): posts, comments, GG and saves
 * (phase 1); photos (phase 2, images only); polls and recruitment (phase 3).
 */
@Module({
  imports: [ConnectionsModule],
  controllers: [
    FeedController,
    PostsController,
    RecruitApplicationsController,
    CommentsController,
    MediaController,
    MyPostsController,
    UserPostsController,
    PublicPostsController,
  ],
  providers: [
    PostsService,
    CommentsService,
    MediaService,
    PollsService,
    RecruitService,
    FeedReader,
    FeedNotifier,
    MediaCleanupJob,
  ],
  exports: [MediaCleanupJob],
})
export class FeedModule {}
