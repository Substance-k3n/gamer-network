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
import { CommentsQuery, CreateCommentBody, CreatePostBody, FeedQuery } from './feed.body.js';
import {
  CommentDto,
  CommentPageDto,
  GgDto,
  PostDto,
  PostPageDto,
  PublicPostDto,
} from './feed.dto.js';
import { PostsService } from './posts.service.js';

// docs/FEED_AND_GROUPS_API.md "Endpoints". A post or comment you may not see is a 404.

const postId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That post') });
const commentId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That comment') });

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

// Operation ids: postsCreate, postsGet, postsDelete, postsGg, postsUnGg, postsSave, postsUnsave.

@ApiTags('feed')
@ApiBearerAuth()
@Controller('posts')
export class PostsController {
  constructor(private readonly posts: PostsService) {}

  /** Post to Home. Photos, polls and recruitment come later (422 on those types). 10 an hour: 429 rate_limited. */
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
