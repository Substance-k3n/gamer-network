import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsDate,
  IsIn,
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';
import { PageQuery } from '../common/cursor.js';
import { GROUP_TONES, type GroupTone } from '../feed/feed.dto.js';
import {
  GROUP_KINDS,
  GROUP_ROLES,
  type GroupKind,
  type GroupRole,
  MEMBERSHIP_STATUSES,
  type MembershipStatus,
} from './groups.dto.js';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);
const trimEach = ({ value }: { value: unknown }) =>
  Array.isArray(value) ? value.map((v) => (typeof v === 'string' ? v.trim() : v)) : value;
const upper = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toUpperCase() : value;

export class CreateGroupBody {
  /** 3–40 characters, trimmed. Unique, ignoring case (409 group_name_taken). */
  @Transform(trim)
  @IsString()
  @Length(3, 40, { message: 'Use 3 to 40 characters' })
  name: string;

  /** The badge: 2–5 letters or digits, stored uppercase. Left out: made from the name. */
  @IsOptional()
  @Transform(upper)
  @IsString()
  @Matches(/^[A-Z0-9]{2,5}$/, { message: 'Use 2 to 5 letters or digits' })
  short?: string;

  @ApiProperty({ enum: GROUP_KINDS, enumName: 'GroupKind' })
  @IsIn(GROUP_KINDS)
  kind: GroupKind;

  /** One of GET /v1/games. Required on game groups. */
  @IsOptional()
  @IsString()
  gameId?: string | null;

  /** City, campus or country: 1–60 characters, trimmed. */
  @Transform(trim)
  @IsString()
  @Length(1, 60, { message: 'Use 1 to 60 characters' })
  place: string;

  /** Up to 500 characters, trimmed. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500, { message: 'Use up to 500 characters' })
  about?: string;

  /** Up to 10 rules, 1–140 characters each, trimmed. */
  @IsOptional()
  @Transform(trimEach)
  @IsArray()
  @ArrayMaxSize(10, { message: 'Up to 10 rules' })
  @IsString({ each: true })
  @Length(1, 140, { each: true, message: 'Use 1 to 140 characters per rule' })
  rules?: string[];

  @ApiPropertyOptional({ enum: GROUP_TONES, enumName: 'GroupTone', default: 'accent' })
  @IsOptional()
  @IsIn(GROUP_TONES)
  tone?: GroupTone;

  /** New members wait for an admin. Default false. */
  @IsOptional()
  @IsBoolean()
  approval?: boolean;
}

/** Any of the create fields but kind, which is fixed. */
export class UpdateGroupBody extends PartialType(OmitType(CreateGroupBody, ['kind'] as const)) {}

export const GROUP_TABS = ['discover', 'mine'] as const;
export type GroupTab = (typeof GROUP_TABS)[number];

export class GroupsQuery extends PageQuery {
  /** discover (default): live groups, most members first. mine: yours and your requests, most recent activity first. */
  @ApiPropertyOptional({ enum: GROUP_TABS, enumName: 'GroupTab', default: 'discover' })
  @IsOptional()
  @IsIn(GROUP_TABS)
  tab?: GroupTab;

  @ApiPropertyOptional({ enum: GROUP_KINDS, enumName: 'GroupKind' })
  @IsOptional()
  @IsIn(GROUP_KINDS)
  kind?: GroupKind;

  /** 2+ characters: matches the name, the game and the place. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(2, 40, { message: 'Type at least 2 characters' })
  query?: string;
}

export class MyGroupsQuery extends PageQuery {
  @ApiPropertyOptional({ enum: GROUP_KINDS, enumName: 'GroupKind' })
  @IsOptional()
  @IsIn(GROUP_KINDS)
  kind?: GroupKind;
}

export class GroupMembersQuery extends PageQuery {
  /** member (default), or pending: the join requests, for admins only. */
  @ApiPropertyOptional({
    enum: MEMBERSHIP_STATUSES,
    enumName: 'MembershipStatus',
    default: 'member',
  })
  @IsOptional()
  @IsIn(MEMBERSHIP_STATUSES)
  status?: MembershipStatus;
}

export class SetGroupRoleBody {
  @ApiProperty({ enum: GROUP_ROLES, enumName: 'GroupRole' })
  @IsIn(GROUP_ROLES)
  role: GroupRole;
}

export class CreateGroupEventBody {
  /** 1–80 characters, trimmed. */
  @Transform(trim)
  @IsString()
  @Length(1, 80, { message: 'Use 1 to 80 characters' })
  title: string;

  /** Within the next 60 days. */
  @Type(() => Date)
  @IsDate()
  startsAt: Date;

  /** One of GET /v1/games, or left out. */
  @IsOptional()
  @IsString()
  gameId?: string | null;
}
