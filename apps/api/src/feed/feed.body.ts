import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { POST_AUDIENCES, POST_TYPES, type PostAudience, type PostType } from './feed.dto.js';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

export class CreatePostBody {
  @ApiProperty({ enum: POST_TYPES, enumName: 'PostType' })
  @IsIn(POST_TYPES)
  type: PostType;

  /** 1–2000 characters, trimmed. */
  @Transform(trim)
  @IsString()
  @Length(1, 2000, { message: 'Use 1 to 2000 characters' })
  text: string;

  /** One of GET /v1/games. Null or left out: "Any game". */
  @IsOptional()
  @IsString()
  gameId?: string | null;

  @ApiPropertyOptional({ enum: POST_AUDIENCES, enumName: 'PostAudience', default: 'everyone' })
  @IsOptional()
  @IsIn(POST_AUDIENCES)
  audience?: PostAudience;
}

export const FEED_FILTERS = ['for_you', 'connections', 'lfg', 'game'] as const;
export type FeedFilter = (typeof FEED_FILTERS)[number];

export class FeedQuery {
  /** for_you: every post you may see. connections: yours and your connections'. lfg: recruitment and looking_for_players. game: needs `game`. */
  @ApiPropertyOptional({ enum: FEED_FILTERS, enumName: 'FeedFilter', default: 'for_you' })
  @IsOptional()
  @IsIn(FEED_FILTERS)
  filter?: FeedFilter;

  /** Game id, for filter=game. */
  @IsOptional()
  @IsString()
  game?: string;

  /** 1–30, default 20. */
  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 30 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(30)
  limit?: number;

  /** `nextCursor` from the previous page. */
  @IsOptional()
  @IsString()
  cursor?: string;
}

export class CreateCommentBody {
  /** 1–500 characters, trimmed. */
  @Transform(trim)
  @IsString()
  @Length(1, 500, { message: 'Use 1 to 500 characters' })
  text: string;

  /** The comment you're replying to. A reply to a reply goes under the same top-level comment. */
  @IsOptional()
  @IsUUID('7')
  parentId?: string;
}

export const COMMENT_SORTS = ['oldest', 'top'] as const;
export type CommentSort = (typeof COMMENT_SORTS)[number];

export class CommentsQuery {
  /** oldest (default), or top: most GG first, for discussions. */
  @ApiPropertyOptional({ enum: COMMENT_SORTS, enumName: 'CommentSort', default: 'oldest' })
  @IsOptional()
  @IsIn(COMMENT_SORTS)
  sort?: CommentSort;

  /** 1–50, default 20. */
  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;

  /** `nextCursor` from the previous page. */
  @IsOptional()
  @IsString()
  @MaxLength(200)
  cursor?: string;
}
