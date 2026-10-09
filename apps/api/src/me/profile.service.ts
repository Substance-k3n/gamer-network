import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { uuidv7 } from 'uuidv7';
import { and, asc, countDistinct, eq, inArray, or, type SQL, sql } from 'drizzle-orm';
import { endOfTonight, hoursFrom } from '../common/addis-time.js';
import { AppError } from '../common/app-error.js';
import { uniqueViolation } from '../common/db-errors.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { MEDIA_STORAGE, type MediaStorage } from '../storage/storage.js';
import {
  checkIns,
  connectionRequests,
  connections,
  gameRanks,
  gameRoles,
  games,
  gamingIds,
  userGames,
  userPlatforms,
  users,
  userTags,
} from '../db/schema/index.js';
import {
  AVATAR_MAX_BYTES,
  AVATAR_TYPES,
  type AvatarUploadBody,
  type SetAvatarBody,
  type SetGamesBody,
  type SetGamingIdsBody,
  type SetPlatformsBody,
  type SetStatusBody,
  type SetTagsBody,
  type UpdateMeBody,
} from './me.body.js';
import type { MeDto } from './me.dto.js';
import {
  type AvatarUploadDto,
  daysToMask,
  type GameRefDto,
  type GamingIdDto,
  maskToDays,
  type PlayerStatus,
  type ProfileDto,
  type ProfileStatsDto,
  type Relationship,
  type UserCardDto,
  type UserGameDto,
} from './profile.dto.js';

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

const gameRef = (g: { id: string; name: string; shortCode: string } | null): GameRefDto | null =>
  g && { id: g.id, name: g.name, shortCode: g.shortCode };

/** When a status set now clears itself. not_available never does. */
export function statusUntil(status: PlayerStatus, now: Date): Date | null {
  switch (status) {
    case 'available_tonight':
      return endOfTonight(now);
    case 'playing':
      return hoursFrom(now, 4);
    case 'looking':
      return hoursFrom(now, 12);
    case 'not_available':
      return null;
  }
}

/** Builds profiles and owns every write to the profile tables. */
@Injectable()
export class ProfileService {
  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(MEDIA_STORAGE) private readonly storage: MediaStorage,
  ) {}

  avatarUrl(key: string | null) {
    return key && this.storage.publicUrl(key);
  }

  async me(user: User): Promise<MeDto> {
    return {
      ...(await this.profile(user, user.id)),
      email: user.email,
      emailVerified: user.emailVerifiedAt !== null,
      hasPassword: user.passwordHash !== null,
      country: user.country,
      role: user.role,
      onboardedAt: user.onboardedAt,
      createdAt: user.createdAt,
    };
  }

  /** `user`'s profile as `viewerId` may see it. Callers check that `viewerId` may see `user` at all. */
  async profile(user: User, viewerId: string): Promise<ProfileDto> {
    const now = new Date();
    const expired = user.statusUntil !== null && user.statusUntil <= now;
    const rel = await this.relationship(user.id, viewerId);
    const allIds = rel.relationship === 'self' || rel.relationship === 'connected';
    const [userGameRows, platforms, tags, ids, statusGame, stats] = await Promise.all([
      this.games(eq(userGames.userId, user.id)).then((rows) => rows.map(({ userId, ...g }) => g)),
      this.db
        .select({ platform: userPlatforms.platform })
        .from(userPlatforms)
        .where(eq(userPlatforms.userId, user.id))
        .orderBy(asc(userPlatforms.platform)),
      this.db
        .select({ tag: userTags.tag })
        .from(userTags)
        .where(eq(userTags.userId, user.id))
        .orderBy(asc(userTags.tag)),
      this.gamingIds(user.id, allIds),
      user.statusGameId && !expired
        ? this.db.query.games.findFirst({ where: eq(games.id, user.statusGameId) })
        : undefined,
      this.stats(user.id),
    ]);
    return {
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      avatarUrl: this.avatarUrl(user.avatarKey),
      city: user.city,
      status: expired ? 'not_available' : user.status,
      statusGame: gameRef(statusGame ?? null),
      statusUntil: expired ? null : user.statusUntil,
      topGame: userGameRows[0] ?? null,
      bio: user.bio,
      ageRange: user.ageRange,
      availableDays: maskToDays(user.availableDays),
      games: userGameRows,
      platforms: platforms.map((p) => p.platform),
      tags: tags.map((t) => t.tag),
      gamingIds: ids,
      stats,
      ...rel,
    };
  }

  /** Cards for a list, in the order given. */
  async cards(list: User[]): Promise<UserCardDto[]> {
    if (list.length === 0) return [];
    const now = new Date();
    const live = (u: User) => u.statusUntil === null || u.statusUntil > now;
    const statusGameIds = [
      ...new Set(list.flatMap((u) => (u.statusGameId && live(u) ? [u.statusGameId] : []))),
    ];
    const [tops, statusGames] = await Promise.all([
      this.games(
        and(
          inArray(
            userGames.userId,
            list.map((u) => u.id),
          ),
          eq(userGames.position, 0),
        )!,
      ),
      statusGameIds.length
        ? this.db
            .select({ id: games.id, name: games.name, shortCode: games.shortCode })
            .from(games)
            .where(inArray(games.id, statusGameIds))
        : [],
    ]);
    const topByUser = new Map(tops.map(({ userId, ...g }) => [userId, g]));
    const gameById = new Map(statusGames.map((g) => [g.id, g]));
    return list.map((u) => ({
      id: u.id,
      username: u.username,
      displayName: u.displayName,
      avatarUrl: this.avatarUrl(u.avatarKey),
      city: u.city,
      status: live(u) ? u.status : 'not_available',
      statusGame: live(u) && u.statusGameId ? (gameById.get(u.statusGameId) ?? null) : null,
      topGame: topByUser.get(u.id) ?? null,
    }));
  }

  /** How `viewerId` stands with `userId`. */
  private async relationship(
    userId: string,
    viewerId: string,
  ): Promise<{ relationship: Relationship; incomingRequestId: string | null }> {
    if (userId === viewerId) return { relationship: 'self', incomingRequestId: null };
    // connections stores each pair once, lower id first; uuid order matches hex string order.
    const [a, b] = userId < viewerId ? [userId, viewerId] : [viewerId, userId];
    const [connected, pending] = await Promise.all([
      this.db
        .select({ a: connections.userAId })
        .from(connections)
        .where(and(eq(connections.userAId, a), eq(connections.userBId, b)))
        .limit(1),
      this.db
        .select({ id: connectionRequests.id, fromUserId: connectionRequests.fromUserId })
        .from(connectionRequests)
        .where(
          and(
            eq(connectionRequests.status, 'pending'),
            or(
              and(
                eq(connectionRequests.fromUserId, viewerId),
                eq(connectionRequests.toUserId, userId),
              ),
              and(
                eq(connectionRequests.fromUserId, userId),
                eq(connectionRequests.toUserId, viewerId),
              ),
            ),
          ),
        ),
    ]);
    if (connected.length) return { relationship: 'connected', incomingRequestId: null };
    const incoming = pending.find((r) => r.fromUserId === userId);
    if (incoming) return { relationship: 'incoming_request', incomingRequestId: incoming.id };
    if (pending.length) return { relationship: 'outgoing_request', incomingRequestId: null };
    return { relationship: 'none', incomingRequestId: null };
  }

  private async games(where: SQL): Promise<(UserGameDto & { userId: string })[]> {
    const rows = await this.db
      .select({
        id: userGames.id,
        userId: userGames.userId,
        customGameName: userGames.customGameName,
        rankText: userGames.rankText,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
        rank: { id: gameRanks.id, name: gameRanks.name, tier: gameRanks.tier },
        role: { id: gameRoles.id, name: gameRoles.name },
      })
      .from(userGames)
      .leftJoin(games, eq(games.id, userGames.gameId))
      .leftJoin(gameRanks, eq(gameRanks.id, userGames.rankId))
      .leftJoin(gameRoles, eq(gameRoles.id, userGames.roleId))
      .where(where)
      .orderBy(asc(userGames.position));
    return rows.map((r) => ({ ...r, game: gameRef(r.game) }));
  }

  /** docs/DATA_MODEL.md "Gaming ID visibility": connections-only IDs need `all`. */
  private async gamingIds(userId: string, all: boolean): Promise<GamingIdDto[]> {
    const rows = await this.db
      .select({
        id: gamingIds.id,
        kind: gamingIds.kind,
        value: gamingIds.value,
        visibility: gamingIds.visibility,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
      })
      .from(gamingIds)
      .leftJoin(games, eq(games.id, gamingIds.gameId))
      .where(
        and(eq(gamingIds.userId, userId), all ? undefined : eq(gamingIds.visibility, 'public')),
      )
      .orderBy(asc(gamingIds.kind), asc(gamingIds.id));
    return rows.map((r) => ({ ...r, game: gameRef(r.game) }));
  }

  private async stats(userId: string): Promise<ProfileStatsDto> {
    const [[c], [g], [p]] = await Promise.all([
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(connections)
        .where(or(eq(connections.userAId, userId), eq(connections.userBId, userId))),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(userGames)
        .where(eq(userGames.userId, userId)),
      this.db
        .select({ n: countDistinct(checkIns.otherUserId) })
        .from(checkIns)
        .where(and(eq(checkIns.userId, userId), eq(checkIns.answer, 'played'))),
    ]);
    return { connections: c!.n, games: g!.n, playedWith: p!.n };
  }

  private async reload(userId: string): Promise<MeDto> {
    const user = await this.db.query.users.findFirst({ where: eq(users.id, userId) });
    return this.me(user!);
  }

  private touch(userId: string, values: Partial<typeof users.$inferInsert> = {}) {
    return this.db
      .update(users)
      .set({ ...values, updatedAt: new Date() })
      .where(eq(users.id, userId));
  }

  async update(user: User, body: UpdateMeBody): Promise<MeDto> {
    try {
      await this.touch(user.id, {
        displayName: body.displayName,
        username: body.username,
        bio: body.bio,
        ageRange: body.ageRange,
        city: body.city,
      });
    } catch (e) {
      if (uniqueViolation(e) === 'users_username_unique') {
        throw new AppError(HttpStatus.CONFLICT, 'username_taken', 'That username is taken.', {
          username: 'taken',
        });
      }
      throw e;
    }
    return this.reload(user.id);
  }

  /** Catalog rows for the given game ids, keyed by id. */
  private async catalog(gameIds: string[]) {
    if (gameIds.length === 0) return new Map<string, { ranks: Set<string>; roles: Set<string> }>();
    const [found, ranks, roles] = await Promise.all([
      this.db.select({ id: games.id }).from(games).where(inArray(games.id, gameIds)),
      this.db
        .select({ id: gameRanks.id, gameId: gameRanks.gameId })
        .from(gameRanks)
        .where(inArray(gameRanks.gameId, gameIds)),
      this.db
        .select({ id: gameRoles.id, gameId: gameRoles.gameId })
        .from(gameRoles)
        .where(inArray(gameRoles.gameId, gameIds)),
    ]);
    const byId = new Map(
      found.map((g) => [g.id, { ranks: new Set<string>(), roles: new Set<string>() }]),
    );
    for (const r of ranks) byId.get(r.gameId)?.ranks.add(r.id);
    for (const r of roles) byId.get(r.gameId)?.roles.add(r.id);
    return byId;
  }

  async setGames(user: User, { games: list }: SetGamesBody): Promise<MeDto> {
    const catalog = await this.catalog(list.flatMap((g) => (g.gameId ? [g.gameId] : [])));
    const fields: Record<string, string> = {};
    const seen = new Set<string>();
    list.forEach((g, i) => {
      const at = `games.${i}`;
      const key = g.gameId ?? `custom:${g.customGameName!.toLowerCase()}`;
      if (seen.has(key)) fields[at] = 'Already in your list';
      seen.add(key);
      if (g.gameId && g.customGameName) fields[at] = 'Send gameId or customGameName, not both';
      if (g.gameId) {
        const game = catalog.get(g.gameId);
        if (!game) fields[`${at}.gameId`] = 'Unknown game';
        else {
          if (g.rankId && !game.ranks.has(g.rankId))
            fields[`${at}.rankId`] = 'Not a rank of this game';
          if (g.roleId && !game.roles.has(g.roleId))
            fields[`${at}.roleId`] = 'Not a role of this game';
        }
        if (g.rankText) fields[`${at}.rankText`] = 'Pick a rank from the list instead';
      } else {
        if (g.rankId) fields[`${at}.rankId`] = 'Custom games take rankText';
        if (g.roleId) fields[`${at}.roleId`] = 'Custom games have no roles';
      }
    });
    if (Object.keys(fields).length) throw invalid(fields);

    await this.db.transaction(async (tx) => {
      await tx.delete(userGames).where(eq(userGames.userId, user.id));
      if (list.length) {
        await tx.insert(userGames).values(
          list.map((g, position) => ({
            userId: user.id,
            gameId: g.gameId ?? null,
            customGameName: g.gameId ? null : g.customGameName!,
            rankId: g.rankId ?? null,
            rankText: g.rankText ?? null,
            roleId: g.roleId ?? null,
            position,
          })),
        );
      }
      await tx.update(users).set({ updatedAt: new Date() }).where(eq(users.id, user.id));
    });
    return this.reload(user.id);
  }

  async setPlatforms(user: User, { platforms }: SetPlatformsBody): Promise<MeDto> {
    await this.db.transaction(async (tx) => {
      await tx.delete(userPlatforms).where(eq(userPlatforms.userId, user.id));
      if (platforms.length) {
        await tx
          .insert(userPlatforms)
          .values(platforms.map((platform) => ({ userId: user.id, platform })));
      }
    });
    return this.reload(user.id);
  }

  async setTags(user: User, { tags }: SetTagsBody): Promise<MeDto> {
    await this.db.transaction(async (tx) => {
      await tx.delete(userTags).where(eq(userTags.userId, user.id));
      if (tags.length)
        await tx.insert(userTags).values(tags.map((tag) => ({ userId: user.id, tag })));
    });
    return this.reload(user.id);
  }

  async setGamingIds(user: User, { gamingIds: list }: SetGamingIdsBody): Promise<MeDto> {
    const catalog = await this.catalog(list.flatMap((g) => (g.gameId ? [g.gameId] : [])));
    const fields: Record<string, string> = {};
    const seen = new Set<string>();
    list.forEach((g, i) => {
      const at = `gamingIds.${i}`;
      if (g.kind !== 'in_game' && g.gameId) fields[`${at}.gameId`] = 'Only in-game IDs take a game';
      else if (g.gameId && !catalog.has(g.gameId)) fields[`${at}.gameId`] = 'Unknown game';
      const key = `${g.kind}:${g.gameId ?? ''}`;
      if (seen.has(key)) fields[at] = 'You already added this ID';
      seen.add(key);
    });
    if (Object.keys(fields).length) throw invalid(fields);

    await this.db.transaction(async (tx) => {
      await tx.delete(gamingIds).where(eq(gamingIds.userId, user.id));
      if (list.length) {
        await tx.insert(gamingIds).values(
          list.map((g) => ({
            userId: user.id,
            kind: g.kind,
            gameId: g.gameId ?? null,
            value: g.value,
            visibility: g.visibility ?? 'connections',
          })),
        );
      }
    });
    return this.reload(user.id);
  }

  async setStatus(user: User, body: SetStatusBody): Promise<MeDto> {
    const gameId = body.status === 'not_available' ? null : (body.gameId ?? null);
    if (gameId && !(await this.catalog([gameId])).has(gameId)) {
      throw invalid({ gameId: 'Unknown game' });
    }
    await this.touch(user.id, {
      status: body.status,
      statusGameId: gameId,
      statusUntil: statusUntil(body.status, new Date()),
      availableDays: body.availableDays && daysToMask(body.availableDays),
    });
    return this.reload(user.id);
  }

  /** "Go live". Needs at least one game; the rest was required at sign-up. Safe to repeat. */
  async onboard(user: User): Promise<void> {
    if (user.onboardedAt) return;
    const [g] = await this.db
      .select({ n: sql<number>`count(*)::int` })
      .from(userGames)
      .where(eq(userGames.userId, user.id));
    if (g!.n === 0) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'profile_incomplete',
        'Add at least one game before going live.',
        { games: 'Add at least one game' },
      );
    }
    await this.touch(user.id, { onboardedAt: new Date() });
  }

  /** Step 1 of changing the avatar: where to upload it. */
  async avatarUploadUrl(user: User, body: AvatarUploadBody): Promise<AvatarUploadDto> {
    const ext = body.contentType.split('/')[1]!.replace('jpeg', 'jpg');
    const key = `avatars/${user.id}/${uuidv7()}.${ext}`;
    const expiresIn = 5 * 60;
    return {
      uploadUrl: await this.storage.uploadUrl(key, body.contentType, body.size, expiresIn),
      headers: { 'Content-Type': body.contentType },
      key,
      expiresAt: new Date(Date.now() + expiresIn * 1000),
    };
  }

  /** Step 2: use the uploaded file. The previous one is deleted. */
  async setAvatar(user: User, { key }: SetAvatarBody): Promise<MeDto> {
    if (!key.startsWith(`avatars/${user.id}/`) || key.includes('..')) {
      throw invalid({ key: 'Not one of your uploads' });
    }
    const stored = await this.storage.head(key);
    if (!stored) throw invalid({ key: 'Nothing was uploaded there yet' });
    if (
      stored.size > AVATAR_MAX_BYTES ||
      !AVATAR_TYPES.includes(stored.contentType as (typeof AVATAR_TYPES)[number])
    ) {
      await this.storage.delete(key);
      throw invalid({ key: 'Use a JPEG, PNG or WebP image up to 2 MB' });
    }
    await this.touch(user.id, { avatarKey: key });
    await this.dropAvatar(user.avatarKey, key);
    return this.reload(user.id);
  }

  async removeAvatar(user: User): Promise<MeDto> {
    await this.touch(user.id, { avatarKey: null });
    await this.dropAvatar(user.avatarKey);
    return this.reload(user.id);
  }

  /** Best effort: a leftover file costs a few KB, a failed request costs the user. */
  private async dropAvatar(key: string | null, unless?: string) {
    if (!key || key === unless) return;
    await this.storage.delete(key).catch(() => undefined);
  }
}
