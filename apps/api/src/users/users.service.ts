import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, ilike, isNotNull, isNull, ne, notExists, or, sql } from 'drizzle-orm';
import { notFound } from '../common/app-error.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { blocks, users } from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import type { ProfileDto, UserCardDto } from '../me/profile.dto.js';

export const SEARCH_LIMIT = 20;

/** `%`, `_` and `\` match literally inside a LIKE pattern. */
const likePrefix = (q: string) => `${q.replace(/[\\%_]/g, (c) => `\\${c}`)}%`;

@Injectable()
export class UsersService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
  ) {}

  /**
   * People `viewer` may see: live (onboarded, not banned or deleted) and
   * no block either way (docs/DATA_MODEL.md "Blocks").
   */
  private visibleTo(viewer: User) {
    return and(
      isNotNull(users.onboardedAt),
      isNull(users.bannedAt),
      isNull(users.deletedAt),
      notExists(
        this.db
          .select({ one: sql`1` })
          .from(blocks)
          .where(
            or(
              and(eq(blocks.blockerId, viewer.id), eq(blocks.blockedId, users.id)),
              and(eq(blocks.blockerId, users.id), eq(blocks.blockedId, viewer.id)),
            ),
          ),
      ),
    );
  }

  async profile(viewer: User, username: string): Promise<ProfileDto> {
    const user = await this.db.query.users.findFirst({
      where: and(eq(users.username, username.trim().toLowerCase()), this.visibleTo(viewer)),
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
          this.visibleTo(viewer),
          ne(users.id, viewer.id),
          or(ilike(users.username, pattern), ilike(users.displayName, pattern)),
        ),
      )
      .orderBy(asc(users.username))
      .limit(SEARCH_LIMIT);
    return this.profiles.cards(found);
  }
}
