import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
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
import { CurrentUser, Public, RequireVerifiedEmail } from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import { PageQuery } from '../common/cursor.js';
import { Idempotent } from '../idempotency/idempotency.js';
import { CommentsService } from './comments.service.js';
import {
  CommentsQuery,
  CreateCommentBody,
  CreatePostBody,
  FeedQuery,
  MediaUploadBody,
  VoteBody,
} from './feed.body.js';
import {
  CommentDto,
  CommentPageDto,
  GgDto,
  MediaUploadDto,
  PollDto,
  PostDto,
  PostPageDto,
  PublicPostDto,
  RecruitApplicationPageDto,
  RecruitDecisionDto,
  RecruitDto,
} from './feed.dto.js';
import { MediaService } from './media.service.js';
import { PollsService } from './polls.service.js';
import { PostsService } from './posts.service.js';
import { RecruitService } from './recruit.service.js';

// docs/FEED_AND_GROUPS_API.md "Endpoints". A post or comment you may not see is a 404.

const postId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That post') });
const commentId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That comment') });
const applicationId = new ParseUUIDPipe({
  exceptionFactory: () => notFound('That application'),
});

// Operation ids: feedGet.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('feed')
export class FeedController {
  constructor(private readonly posts: PostsService) {}

  /** Home, newest first. Blocked people's posts and connections-only posts of strangers are left out. */
  @Get()
  @ApiOkResponse({ type: PostPageDto })
  get(@CurrentUser() user: User, @Query() query: FeedQuery): Promise<PostPageDto> {
    return this.posts.feed(user, query);
  }
}

// Operation ids: postsCreate, postsGet, postsDelete, postsGg, postsUnGg, postsSave, postsUnsave,
// postsVote, postsApply, postsApplications.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('posts')
export class PostsController {
  constructor(
    private readonly posts: PostsService,
    private readonly polls: PollsService,
    private readonly recruit: RecruitService,
  ) {}

  /** Post to Home, with up to 4 photo keys (gameplay needs one), a poll or recruitment slots. 10 an hour: 429 rate_limited. */
  @Post()
  @Idempotent()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: PostDto })
  create(@CurrentUser() user: User, @Body() body: CreatePostBody): Promise<PostDto> {
    return this.posts.create(user, body);
  }

  /** One post. */
  @Get(':id')
  @ApiOkResponse({ type: PostDto })
  get(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<PostDto> {
    return this.posts.get(user, id);
  }

  /** Author only (403 not_owner). */
  @Delete(':id')
  @HttpCode(204)
  @ApiNoContentResponse()
  delete(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<void> {
    return this.posts.delete(user, id);
  }

  /** GG it. Repeating it is fine. */
  @Put(':id/gg')
  @ApiOkResponse({ type: GgDto })
  gg(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<GgDto> {
    return this.posts.gg(user, id, true);
  }

  /** Take your GG back. */
  @Delete(':id/gg')
  @ApiOkResponse({ type: GgDto })
  unGg(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<GgDto> {
    return this.posts.gg(user, id, false);
  }

  /** Bookmark it. */
  @Put(':id/save')
  @HttpCode(204)
  @ApiNoContentResponse()
  save(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<void> {
    return this.posts.save(user, id, true);
  }

  /** Remove the bookmark. */
  @Delete(':id/save')
  @HttpCode(204)
  @ApiNoContentResponse()
  unsave(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<void> {
    return this.posts.save(user, id, false);
  }

  /** Vote on a poll, once and final; your own is fine. 409 already_voted or poll_closed. */
  @Post(':id/vote')
  @HttpCode(200)
  @ApiOkResponse({ type: PollDto })
  vote(
    @CurrentUser() user: User,
    @Param('id', postId) id: string,
    @Body() body: VoteBody,
  ): Promise<PollDto> {
    return this.polls.vote(user, id, body.position);
  }

  /** Apply to a recruitment post; tells its author. 409 already_applied or recruitment_full, 403 own_post. 20 a day. */
  @Post(':id/apply')
  @HttpCode(200)
  @Idempotent()
  @ApiOkResponse({ type: RecruitDto })
  apply(@CurrentUser() user: User, @Param('id', postId) id: string): Promise<RecruitDto> {
    return this.recruit.apply(user, id);
  }

  /** Who applied, first come first. The post's author only (403 not_owner). */
  @Get(':id/applications')
  @ApiOkResponse({ type: RecruitApplicationPageDto })
  applications(
    @CurrentUser() user: User,
    @Param('id', postId) id: string,
    @Query() query: PageQuery,
  ): Promise<RecruitApplicationPageDto> {
    return this.recruit.applications(user, id, query);
  }
}

// Operation ids: recruitApplicationsAccept, recruitApplicationsDecline.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('recruit-applications')
export class RecruitApplicationsController {
  constructor(private readonly recruit: RecruitService) {}

  /** The post's author takes them (403 not_owner): tells them and sends a connection request if you aren't connected. 409 recruitment_full. */
  @Post(':id/accept')
  @HttpCode(200)
  @ApiOkResponse({ type: RecruitDecisionDto })
  accept(
    @CurrentUser() user: User,
    @Param('id', applicationId) id: string,
  ): Promise<RecruitDecisionDto> {
    return this.recruit.decide(user, id, 'accepted');
  }

  /** The post's author says no (403 not_owner). Tells no one. */
  @Post(':id/decline')
  @HttpCode(200)
  @ApiOkResponse({ type: RecruitDecisionDto })
  decline(
    @CurrentUser() user: User,
    @Param('id', applicationId) id: string,
  ): Promise<RecruitDecisionDto> {
    return this.recruit.decide(user, id, 'declined');
  }
}

// Operation ids: mediaUploadUrl.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('media')
export class MediaController {
  constructor(private readonly media: MediaService) {}

  /** Where to upload one photo for a post (JPEG, PNG or WebP, ≤ 10 MB). Then send its key in POST /v1/posts. 30 an hour. */
  @Post('upload-url')
  @HttpCode(200)
  @ApiOkResponse({ type: MediaUploadDto })
  uploadUrl(@CurrentUser() user: User, @Body() body: MediaUploadBody): Promise<MediaUploadDto> {
    return this.media.uploadUrl(user, body);
  }
}

// Operation ids: commentsList, commentsCreate, commentsReplies, commentsDelete,
// commentsGg, commentsUnGg.

@ApiTags('feed')
@ApiBearerAuth()
@Controller()
export class CommentsController {
  constructor(private readonly comments: CommentsService) {}

  /** Top-level comments, oldest first; sort=top for discussions. */
  @Get('posts/:id/comments')
  @ApiOkResponse({ type: CommentPageDto })
  list(
    @CurrentUser() user: User,
    @Param('id', postId) id: string,
    @Query() query: CommentsQuery,
  ): Promise<CommentPageDto> {
    return this.comments.list(user, id, query);
  }

  /** Comment, or reply with parentId. Tells the post's author, the one you answered and anyone you @mention. 60 an hour. */
  @Post('posts/:id/comments')
  @Idempotent()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: CommentDto })
  create(
    @CurrentUser() user: User,
    @Param('id', postId) id: string,
    @Body() body: CreateCommentBody,
  ): Promise<CommentDto> {
    return this.comments.create(user, id, body);
  }

  /** Replies under a top-level comment, oldest first. */
  @Get('comments/:id/replies')
  @ApiOkResponse({ type: CommentPageDto })
  replies(
    @CurrentUser() user: User,
    @Param('id', commentId) id: string,
    @Query() query: CommentsQuery,
  ): Promise<CommentPageDto> {
    return this.comments.replies(user, id, query);
  }

  /** Its author or the post's author (403 not_owner). */
  @Delete('comments/:id')
  @HttpCode(204)
  @ApiNoContentResponse()
  delete(@CurrentUser() user: User, @Param('id', commentId) id: string): Promise<void> {
    return this.comments.delete(user, id);
  }

  /** GG a comment. */
  @Put('comments/:id/gg')
  @ApiOkResponse({ type: GgDto })
  gg(@CurrentUser() user: User, @Param('id', commentId) id: string): Promise<GgDto> {
    return this.comments.gg(user, id, true);
  }

  /** Take your GG back. */
  @Delete('comments/:id/gg')
  @ApiOkResponse({ type: GgDto })
  unGg(@CurrentUser() user: User, @Param('id', commentId) id: string): Promise<GgDto> {
    return this.comments.gg(user, id, false);
  }
}

// Operation ids: myPostsList, myPostsSaved.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('me')
export class MyPostsController {
  constructor(private readonly posts: PostsService) {}

  /** Your posts, newest first, connections-only ones included. */
  @Get('posts')
  @ApiOkResponse({ type: PostPageDto })
  list(@CurrentUser() user: User, @Query() query: PageQuery): Promise<PostPageDto> {
    return this.posts.mine(user, query);
  }

  /** Saved posts, most recently saved first. */
  @Get('saved')
  @ApiOkResponse({ type: PostPageDto })
  saved(@CurrentUser() user: User, @Query() query: PageQuery): Promise<PostPageDto> {
    return this.posts.saved(user, query);
  }
}

// Operation ids: userPostsList.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('users')
export class UserPostsController {
  constructor(private readonly posts: PostsService) {}

  /** Moments: their posts you may see, newest first. */
  @Get(':username/posts')
  @ApiOkResponse({ type: PostPageDto })
  list(
    @CurrentUser() user: User,
    @Param('username') username: string,
    @Query() query: PageQuery,
  ): Promise<PostPageDto> {
    return this.posts.byUser(user, username, query);
  }
}

// Operation ids: publicPostsGet.

@ApiTags('feed')
@Public()
@Controller('public/posts')
export class PublicPostsController {
  constructor(private readonly posts: PostsService) {}

  /** For the share page /p/<id>: no sign-in. Only live posts for everyone. */
  @Get(':id')
  @ApiOkResponse({ type: PublicPostDto })
  get(@Param('id', postId) id: string): Promise<PublicPostDto> {
    return this.posts.publicPost(id);
  }
}
