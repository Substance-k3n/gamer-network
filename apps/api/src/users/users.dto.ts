import { Transform } from 'class-transformer';
import { IsString, Length } from 'class-validator';
import { UserCardDto } from '../me/profile.dto.js';

export class UserSearchQuery {
  /** At least 2 characters of a username or display name. */
  @Transform(({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value))
  @IsString()
  @Length(2, 30, { message: 'Type at least 2 characters' })
  query: string;
}

export class UserSearchResponse {
  /** Up to 20, by username. */
  items: UserCardDto[];
}
