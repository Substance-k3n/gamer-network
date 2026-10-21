import { ApiProperty } from '@nestjs/swagger';
import { groupKind, groupRole, membershipStatus } from '../db/schema/index.js';
import { GROUP_TONES, type GroupTone } from '../feed/feed.dto.js';
import { GameRefDto, UserCardDto } from '../me/profile.dto.js';

export const GROUP_KINDS = groupKind.enumValues;
export type GroupKind = (typeof GROUP_KINDS)[number];
export const GROUP_ROLES = groupRole.enumValues;
export type GroupRole = (typeof GROUP_ROLES)[number];
export const MEMBERSHIP_STATUSES = membershipStatus.enumValues;
export type MembershipStatus = (typeof MEMBERSHIP_STATUSES)[number];

/** An event in a group: "5-stack customs, tonight 21:00". */
export class GroupEventDto {
  id: string;
  groupId: string;
  /** 1–80 characters. */
  title: string;
  startsAt: Date;
  game: GameRefDto | null;
  /** People going, leaving out anyone no longer live. */
  goingCount: number;
  /** Up to 3 of them, for the avatars. */
  goingPreview: UserCardDto[];
  imGoing: boolean;
  /** Its creator or a group admin can delete it. */
  createdBy: UserCardDto;
}

export class GroupEventPageDto {
  items: GroupEventDto[];
  nextCursor: string | null;
}

/** A group as the viewer sees it, on the Groups tab, its page and profiles. */
export class GroupDto {
  id: string;
  name: string;
  /** The badge, e.g. "VAL": 2–5 uppercase letters or digits. */
  short: string;

  @ApiProperty({ enum: GROUP_KINDS, enumName: 'GroupKind' })
  kind: GroupKind;

  /** Set on game groups; may be set on others. */
  game: GameRefDto | null;
  /** City, campus or country. */
  place: string;
  about: string;
  /** Up to 10, up to 140 characters each. */
  rules: string[];

  @ApiProperty({ enum: GROUP_TONES, enumName: 'GroupTone' })
  tone: GroupTone;

  /** New members wait for an admin. */
  approval: boolean;
  memberCount: number;
  /** Up to 3 members, your connections first. */
  membersPreview: UserCardDto[];
  /** The soonest upcoming event, or null. */
  nextEvent: GroupEventDto | null;

  /** Null when you aren't a member (or are still pending). */
  @ApiProperty({ enum: GROUP_ROLES, enumName: 'GroupRole', nullable: true })
  myRole: GroupRole | null;

  /** pending: you asked to join and wait for an admin. Null: not in it. */
  @ApiProperty({ enum: MEMBERSHIP_STATUSES, enumName: 'MembershipStatus', nullable: true })
  myStatus: MembershipStatus | null;

  /** "since Mar 2025". */
  createdAt: Date;
}

export class GroupPageDto {
  items: GroupDto[];
  nextCursor: string | null;
}

/** One person in a group's members list (or its requests, for admins). */
export class GroupMemberDto {
  user: UserCardDto;

  @ApiProperty({ enum: GROUP_ROLES, enumName: 'GroupRole' })
  role: GroupRole;

  @ApiProperty({ enum: MEMBERSHIP_STATUSES, enumName: 'MembershipStatus' })
  status: MembershipStatus;

  /** Null while pending. */
  joinedAt: Date | null;
}

export class GroupMemberPageDto {
  items: GroupMemberDto[];
  nextCursor: string | null;
}
