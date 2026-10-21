import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayUnique,
  IsArray,
  IsIn,
  IsInt,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { POST_AUDIENCES, POST_TYPES, type PostAudience, type PostType } from './feed.dto.js';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);
const trimEach = ({ value }: { value: unknown }) =>
  Array.isArray(value) ? value.map((v) => (typeof v === 'string' ? v.trim() : v)) : value;

/** What the upload URL accepts (docs/FEED_AND_GROUPS_API.md "Media uploads"; images only for now). */
export const MEDIA_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;
export type MediaType = (typeof MEDIA_TYPES)[number];
export const MEDIA_MAX_BYTES = 10 * 1024 * 1024;

export class MediaUploadBody {
  @ApiProperty({ enum: MEDIA_TYPES, enumName: 'MediaContentType' })
  @IsIn(MEDIA_TYPES, { message: 'Use a JPEG, PNG or WebP image' })
  contentType: MediaType;

  /** The file's exact size in bytes, at most 10 MB. Resize on the phone first (longest side 1600 px). */
  @IsInt()
  @Min(1)
  @Max(MEDIA_MAX_BYTES, { message: 'Images can be up to 10 MB' })
  size: number;
}

export const POLL_DURATIONS = ['1d', '3d', '1w'] as const;
export type PollDuration = (typeof POLL_DURATIONS)[number];

export class PollBody {
  /** 2–4 options, 1–60 characters each, trimmed, all different. */
  @Transform(trimEach)
  @IsArray()
  @ArrayMinSize(2, { message: 'Add 2 to 4 options' })
  @ArrayMaxSize(4, { message: 'Add 2 to 4 options' })
  @ArrayUnique({ message: 'Each option must be different' })
  @IsString({ each: true })
  @Length(1, 60, { each: true, message: 'Use 1 to 60 characters per option' })
  options: string[];

  /** How long it stays open: 1 day, 3 days or 1 week. */
  @ApiProperty({ enum: POLL_DURATIONS, enumName: 'PollDuration' })
  @IsIn(POLL_DURATIONS)
  duration: PollDuration;
}

export class RecruitBody {
  /** Players wanted, 1–10. */
  @IsInt()
  @Min(1, { message: 'Use 1 to 10 slots' })
  @Max(10, { message: 'Use 1 to 10 slots' })
  slots: number;

  /** Free text, e.g. "Sniper, Support". Up to 80 characters, trimmed. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(80, { message: 'Use up to 80 characters' })
  roles?: string;
}

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

  /** Post in this group instead of Home: members only (403 not_member). Group posts are for everyone in the group, so audience=connections is refused. */
  @IsOptional()
  @IsUUID()
  groupId?: string;

  /** Up to 4 keys from POST /v1/media/upload-url, uploaded by you and not used yet. Required on gameplay. */
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(4, { message: 'Up to 4 photos per post' })
  @ArrayUnique({ message: 'Each photo once' })
  @IsString({ each: true })
  @MaxLength(200, { each: true })
  media?: string[];

  /** Required on poll posts, refused on others. */
  @IsOptional()
  @IsObject()
  @ValidateNested()
  @Type(() => PollBody)
  poll?: PollBody;

  /** Required on recruitment posts, refused on others. */
  @IsOptional()
  @IsObject()
  @ValidateNested()
  @Type(() => RecruitBody)
  recruit?: RecruitBody;
}

export class VoteBody {
  /** The option's position (0–3). */
  @IsInt()
  @Min(0)
  @Max(3)
  position: number;
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
