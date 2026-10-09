import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, ilike, ne, or } from 'drizzle-orm';
import { notFound } from '../common/app-error.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { users } from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import type { ProfileDto, UserCardDto } from '../me/profile.dto.js';
import { visibleTo } from './visibility.js';

export const SEARCH_LIMIT = 20;

/** `%`, `_` and `\` match literally inside a LIKE pattern. */
const likePrefix = (q: string) => `${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

@Injectable()
export class UsersService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
  ) {}

  async profile(viewer: User, username: string): Promise<ProfileDto> {
    const user = await this.db.query.users.findFirst({
      where: and(eq(users.username, username.trim().toLowerCase()), visibleTo(this.db, viewer.id)),
    });
    if (!user) throw notFound('That player');
    return this.profiles.profile(user, viewer.id);
  }

  /** Username or display name prefix, case-insensitive. Never yourself. */
  async search(viewer: User, query: string): Promise<UserCardDto[]> {
    const pattern = likePrefix(query.trim());
    const found = await this.db
      .select()
      .from(users)
      .where(
        and(
          visibleTo(this.db, viewer.id),
          ne(users.id, viewer.id),
          or(ilike(users.username, pattern), ilike(users.displayName, pattern)),
        ),
      )
      .orderBy(asc(users.username))
      .limit(SEARCH_LIMIT);
    return this.profiles.cards(found);
  }
}
