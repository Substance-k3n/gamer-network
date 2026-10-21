import { ApiProperty } from '@nestjs/swagger';
import {
  applicationStatus,
  contentStatus,
  groupTone,
  mediaKind,
  postAudience,
  postType,
} from '../db/schema/index.js';
import { GameRefDto, UserCardDto } from '../me/profile.dto.js';

export const POST_TYPES = postType.enumValues;
export type PostType = (typeof POST_TYPES)[number];
export const POST_AUDIENCES = postAudience.enumValues;
export type PostAudience = (typeof POST_AUDIENCES)[number];
export const POST_KINDS = ['text', 'moment', 'discussion', 'poll', 'recruit'] as const;
export type PostKind = (typeof POST_KINDS)[number];
export type ContentStatus = (typeof contentStatus.enumValues)[number];
export const MEDIA_KINDS = mediaKind.enumValues;
export type MediaKind = (typeof MEDIA_KINDS)[number];
export const APPLICATION_STATUSES = applicationStatus.enumValues;
export type ApplicationStatus = (typeof APPLICATION_STATUSES)[number];
export const GROUP_TONES = groupTone.enumValues;
export type GroupTone = (typeof GROUP_TONES)[number];

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

/** A photo (or, later, a video) on a post. */
export class MediaDto {
  id: string;

  /** Only image for now; video comes later. */
  @ApiProperty({ enum: MEDIA_KINDS, enumName: 'MediaKind' })
  kind: MediaKind;

  /** Signed when the bucket is private: use as given (ADR-0009). */
  url: string;
  /** A video's still frame; null for images. */
  posterUrl: string | null;
  /** Null when not known: size the image from the file. */
  width: number | null;
  height: number | null;
  /** Videos only. */
  durationMs: number | null;
}

export class PollOptionDto {
  /** 0–3, in the order the author wrote them. */
  position: number;
  label: string;
  votes: number;
}

export class PollDto {
  options: PollOptionDto[];
  totalVotes: number;
  /** The position you voted for, or null. */
  myVote: number | null;
  endsAt: Date;
  /** Past endsAt: no more votes. */
  closed: boolean;
}

export class RecruitDto {
  /** 1–10 players wanted. */
  slots: number;
  /** "Sniper, Support"; empty when not given. */
  roles: string;
  /** How many applied; the author sees the list. */
  applications: number;

  /** Your application, or null. */
  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus', nullable: true })
  myApplication: ApplicationStatus | null;
}

/** The group a post is in, for its header. */
export class PostGroupDto {
  id: string;
  name: string;
  /** The badge, e.g. "VAL". */
  short: string;

  @ApiProperty({ enum: GROUP_TONES, enumName: 'GroupTone' })
  tone: GroupTone;
}

/** A post on Home, a profile's Moments or in a group. */
export class PostDto {
  id: string;

  @ApiProperty({ enum: POST_TYPES, enumName: 'PostType' })
  type: PostType;

  /** Draw by this: follows from type. */
  @ApiProperty({ enum: POST_KINDS, enumName: 'PostKind' })
  kind: PostKind;

  /** topGame gives "Diamond Valorant" for the header. */
  author: UserCardDto;
  /** Null on Home posts. */
  group: PostGroupDto | null;
  /** Null: "Any game". */
  game: GameRefDto | null;
  text: string;

  @ApiProperty({ enum: POST_AUDIENCES, enumName: 'PostAudience' })
  audience: PostAudience;

  /** In position order, 0–4. */
  media: MediaDto[];
  /** Poll posts only. */
  poll: PollDto | null;
  /** Recruitment posts only. */
  recruit: RecruitDto | null;
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
  /** The first image only, for the preview; empty when it has none. */
  media: MediaDto[];
  createdAt: Date;
}

/** One application on a recruitment post, as its author sees it. */
export class RecruitApplicationDto {
  id: string;
  user: UserCardDto;

  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus' })
  status: ApplicationStatus;

  createdAt: Date;
}

export class RecruitApplicationPageDto {
  items: RecruitApplicationDto[];
  nextCursor: string | null;
}

export class RecruitDecisionDto {
  id: string;

  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus' })
  status: ApplicationStatus;
}

export class MediaUploadDto {
  /**
   * PUT the file here before `expiresAt`, with `headers`. The body must be
   * exactly the `size` you asked for (the URL is signed for it); let the
   * HTTP client set Content-Length.
   */
  uploadUrl: string;
  /** Send these with the upload (Content-Type). */
  headers: Record<string, string>;
  /** Put it in POST /v1/posts `media` once the upload succeeds, before `expiresAt`. */
  key: string;
  expiresAt: Date;
}
