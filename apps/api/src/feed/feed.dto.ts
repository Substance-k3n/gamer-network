import { ApiProperty } from '@nestjs/swagger';
import { contentStatus, postAudience, postType } from '../db/schema/index.js';
import { GameRefDto, UserCardDto } from '../me/profile.dto.js';

export const POST_TYPES = postType.enumValues;
export type PostType = (typeof POST_TYPES)[number];
export const POST_AUDIENCES = postAudience.enumValues;
export type PostAudience = (typeof POST_AUDIENCES)[number];
export const POST_KINDS = ['text', 'moment', 'discussion', 'poll', 'recruit'] as const;
export type PostKind = (typeof POST_KINDS)[number];
export type ContentStatus = (typeof contentStatus.enumValues)[number];

/** How the card is drawn; `type` is only its label. */
export function kindOf(type: PostType): PostKind {
  switch (type) {
    case 'discussion':
      return 'discussion';
    case 'poll':
      return 'poll';
    case 'recruitment':
      return 'recruit';
    case 'gameplay':
      return 'moment';
    default:
      return 'text';
  }
}

export class CommentDto {
  id: string;
  postId: string;
  /** The top-level comment this replies to, or null. */
  parentId: string | null;
  author: UserCardDto;
  text: string;
  ggCount: number;
  myGG: boolean;
  mine: boolean;
  /** Replies under it; 0 on replies. */
  replies: number;
  createdAt: Date;
}

export class CommentPageDto {
  items: CommentDto[];
  nextCursor: string | null;
}

/** A post on Home or a profile's Moments. */
export class PostDto {
  id: string;

  @ApiProperty({ enum: POST_TYPES, enumName: 'PostType' })
  type: PostType;

  /** Draw by this: follows from type. */
  @ApiProperty({ enum: POST_KINDS, enumName: 'PostKind' })
  kind: PostKind;

  /** topGame gives "Diamond Valorant" for the header. */
  author: UserCardDto;
  /** Null: "Any game". */
  game: GameRefDto | null;
  text: string;

  @ApiProperty({ enum: POST_AUDIENCES, enumName: 'PostAudience' })
  audience: PostAudience;

  /** Discussions: the most-GG'd answer. Null on other kinds. */
  topComment: CommentDto | null;
  ggCount: number;
  /** Comments and replies you can see the count of ("answers" on discussions). */
  commentCount: number;
  myGG: boolean;
  saved: boolean;
  mine: boolean;
  /** Link for Telegram/WhatsApp. */
  shareUrl: string;
  createdAt: Date;
}

export class PostPageDto {
  items: PostDto[];
  nextCursor: string | null;
}

export class GgDto {
  ggCount: number;
  myGG: boolean;
}

export class PublicPostAuthorDto {
  displayName: string;
  username: string;
  avatarUrl: string | null;
}

/** For the share page: no ids beyond the post's own. */
export class PublicPostDto {
  id: string;

  @ApiProperty({ enum: POST_TYPES, enumName: 'PostType' })
  type: PostType;

  /** The first 300 characters. */
  text: string;
  author: PublicPostAuthorDto;
  game: GameRefDto | null;
  createdAt: Date;
}
