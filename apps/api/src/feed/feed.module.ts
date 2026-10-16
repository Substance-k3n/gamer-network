import { Module } from '@nestjs/common';
import { CommentsService } from './comments.service.js';
import {
  CommentsController,
  FeedController,
  MyPostsController,
  PostsController,
  PublicPostsController,
  UserPostsController,
} from './feed.controller.js';
import { FeedNotifier } from './feed-notifier.js';
import { FeedReader } from './feed-reader.js';
import { PostsService } from './posts.service.js';

/** Home feed: posts, comments, GG and saves (docs/FEED_AND_GROUPS_API.md, phase 1). */
@Module({
  controllers: [
    FeedController,
    PostsController,
    CommentsController,
    MyPostsController,
    UserPostsController,
    PublicPostsController,
  ],
  providers: [PostsService, CommentsService, FeedReader, FeedNotifier],
})
export class FeedModule {}
