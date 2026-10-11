import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import {
  and,
  countDistinct,
  desc,
  eq,
  exists,
  gt,
  gte,
  inArray,
  lt,
  lte,
  ne,
  or,
  type SQL,
  sql,
} from 'drizzle-orm';
import { endOfTonight } from '../common/addis-time.js';
import { AppError, notFound } from '../common/app-error.js';
import { decodeCursor, page } from '../common/cursor.js';
import { uniqueViolation } from '../common/db-errors.js';
import type { User } from '../auth/sessions.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  connectionRequests,
  gameModes,
  gameRanks,
  games,
  listings,
  userGames,
  users,
} from '../db/schema/index.js';
import { env } from '../env.js';
import { ProfileService } from '../me/profile.service.js';
import { isLive, visibleTo } from '../users/visibility.js';
import { listingTimes } from './listing-times.js';
import type { CreateListingBody, ListingFeedQuery } from './listings.body.js';
import type {
  Duration,
  ListingDto,
  ListingPageDto,
  ListingStatus,
  PublicListingDto,
} from './listings.dto.js';

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

const LIVE = ['open', 'full'] as const;

/** open/full turn into expired the moment expiresAt passes, whether or not the job has run. */
const effectiveStatus = (status: ListingStatus, expiresAt: Date, now: Date): ListingStatus =>
  (status === 'open' || status === 'full') && expiresAt <= now ? 'expired' : status;

@Injectable()
export class ListingsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
  ) {}

  /** Listings with their game, mode, rank and owner. Filter with `where`. */
  private select(where: SQL | undefined) {
    return this.db
      .select({
        listing: listings,
        owner: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
        mode: { id: gameModes.id, name: gameModes.name },
        rank: { id: gameRanks.id, name: gameRanks.name, tier: gameRanks.tier },
      })
      .from(listings)
      .innerJoin(users, eq(users.id, listings.ownerId))
      .innerJoin(games, eq(games.id, listings.gameId))
      .leftJoin(gameModes, eq(gameModes.id, listings.modeId))
      .leftJoin(gameRanks, eq(gameRanks.id, listings.rankId))
      .where(where);
  }

  private async build(
    rows: Awaited<ReturnType<ListingsService['select']>>,
    viewerId: string,
  ): Promise<ListingDto[]> {
    if (rows.length === 0) return [];
    const now = new Date();
    const ids = rows.map((r) => r.listing.id);
    const [owners, requests] = await Promise.all([
      this.profiles.cards(rows.map((r) => r.owner)),
      this.db
        .select({
          id: connectionRequests.id,
          status: connectionRequests.status,
          listingId: connectionRequests.listingId,
        })
        .from(connectionRequests)
        .where(
          and(
            eq(connectionRequests.fromUserId, viewerId),
            inArray(connectionRequests.listingId, ids),
          ),
        )
        .orderBy(desc(connectionRequests.id)),
    ]);
    const myRequest = new Map<
      string,
      { id: string; status: (typeof requests)[number]['status'] }
    >();
    for (const r of requests) {
      if (!myRequest.has(r.listingId!)) myRequest.set(r.listingId!, { id: r.id, status: r.status });
    }
    return rows.map(({ listing: l, game, mode, rank }, i) => ({
      id: l.id,
      owner: owners[i]!,
      game,
      mode,
      rank,
      platform: l.platform,
      partySize: l.partySize,
      filled: l.filled,
      voice: l.voice,
      style: l.style,
      playWhen: l.playWhen,
      durationHours: l.durationHours as Duration,
      startsAt: l.startsAt,
      expiresAt: l.expiresAt,
      note: l.note,
      status: effectiveStatus(l.status, l.expiresAt, now),
      createdAt: l.createdAt,
      myRequest: myRequest.get(l.id) ?? null,
      shareUrl: `${env.publicWebUrl}/l/${l.id}`,
    }));
  }

  private async one(where: SQL | undefined, viewerId: string): Promise<ListingDto | null> {
    const rows = await this.select(where).limit(1);
    return (await this.build(rows, viewerId))[0] ?? null;
  }

  /** Listings by id as `viewerId` sees them, for things that point at a listing (requests). */
  async byIds(ids: string[], viewerId: string): Promise<Map<string, ListingDto>> {
    if (ids.length === 0) return new Map();
    const built = await this.build(await this.select(inArray(listings.id, ids)), viewerId);
    return new Map(built.map((l) => [l.id, l]));
  }

  async create(owner: User, body: CreateListingBody): Promise<ListingDto> {
    const game = await this.db.query.games.findFirst({ where: eq(games.id, body.gameId) });
    if (!game) throw invalid({ gameId: 'Unknown game' });
    if (!game.isLaunch) throw invalid({ gameId: "This game isn't on Find Players yet" });

    const fields: Record<string, string> = {};
    if (!game.platforms.includes(body.platform))
      fields.platform = `${game.name} isn't on that platform`;
    if (body.partySize > game.maxParty)
      fields.partySize = `${game.name} parties go up to ${game.maxParty}`;
    const [mode, rank, mine] = await Promise.all([
      body.modeId
        ? this.db.query.gameModes.findFirst({
            where: and(eq(gameModes.id, body.modeId), eq(gameModes.gameId, game.id)),
          })
        : undefined,
      body.rankId
        ? this.db.query.gameRanks.findFirst({
            where: and(eq(gameRanks.id, body.rankId), eq(gameRanks.gameId, game.id)),
          })
        : undefined,
      this.db.query.userGames.findFirst({
        where: and(eq(userGames.userId, owner.id), eq(userGames.gameId, game.id)),
      }),
    ]);
    if (body.modeId && !mode) fields.modeId = 'Not a mode of this game';
    if (body.rankId && !rank) fields.rankId = 'Not a rank of this game';
    if (Object.keys(fields).length) throw invalid(fields);

    const now = new Date();
    const times = listingTimes(body.playWhen, body.durationHours, now);
    // A live listing whose time ran out no longer blocks a new one, even if the job hasn't caught it.
    await this.db
      .update(listings)
      .set({ status: 'expired' })
      .where(
        and(
          eq(listings.ownerId, owner.id),
          inArray(listings.status, LIVE),
          lte(listings.expiresAt, now),
        ),
      );
    let id: string;
    try {
      [{ id }] = (await this.db
        .insert(listings)
        .values({
          ownerId: owner.id,
          gameId: game.id,
          modeId: body.modeId ?? null,
          rankId: body.rankId ?? mine?.rankId ?? null,
          platform: body.platform,
          partySize: body.partySize,
          voice: body.voice,
          style: body.style,
          playWhen: body.playWhen,
          durationHours: body.durationHours,
          startsAt: times.startsAt,
          expiresAt: times.expiresAt,
          note: body.note ?? null,
          city: owner.city,
          createdAt: now,
        })
        .returning({ id: listings.id })) as [{ id: string }];
    } catch (e) {
      if (uniqueViolation(e) === 'listings_one_live_per_owner') {
        throw new AppError(
          HttpStatus.CONFLICT,
          'listing_already_open',
          'You already have a live listing. Close it to post a new one.',
        );
      }
      throw e;
    }
    return (await this.one(eq(listings.id, id), owner.id))!;
  }

  /** Find Players: open listings in your city, newest first. */
  async feed(viewer: User, q: ListingFeedQuery): Promise<ListingPageDto> {
    const now = new Date();
    const limit = q.limit ?? 20;
    const after = decodeCursor(q.cursor);
    const where: (SQL | undefined)[] = [
      eq(listings.status, 'open'),
      gt(listings.expiresAt, now),
      eq(listings.city, viewer.city),
      ne(listings.ownerId, viewer.id),
      visibleTo(this.db, viewer.id),
      after ? lt(listings.id, after) : undefined,
      q.game ? eq(listings.gameId, q.game) : undefined,
      q.platform ? eq(listings.platform, q.platform) : undefined,
      q.mode ? eq(listings.modeId, q.mode) : undefined,
      q.voice ? eq(listings.voice, q.voice) : undefined,
      q.style ? eq(listings.style, q.style) : undefined,
      q.partySize ? eq(listings.partySize, q.partySize) : undefined,
      q.when === 'now' ? lte(listings.startsAt, now) : undefined,
      q.when === 'tonight' ? lt(listings.startsAt, endOfTonight(now)) : undefined,
    ];
    if (q.minRank) {
      const min = await this.db.query.gameRanks.findFirst({ where: eq(gameRanks.id, q.minRank) });
      if (!min) throw invalid({ minRank: 'Unknown rank' });
      where.push(eq(listings.gameId, min.gameId), gte(gameRanks.tier, min.tier));
    }
    const rows = await this.select(and(...where))
      .orderBy(desc(listings.id))
      .limit(limit + 1);
    const { items, nextCursor } = page(
      rows.map((r) => ({ ...r, id: r.listing.id })),
      limit,
    );
    return { items: await this.build(items, viewer.id), nextCursor };
  }

  /** Any status, so a shared link can say "expired". Yours, or someone you may see. */
  async get(viewer: User, id: string): Promise<ListingDto> {
    const listing = await this.one(
      and(
        eq(listings.id, id),
        or(
          eq(listings.ownerId, viewer.id),
          and(ne(listings.status, 'removed'), visibleTo(this.db, viewer.id)),
        ),
      ),
      viewer.id,
    );
    if (!listing) throw notFound('That listing');
    return listing;
  }

  async close(viewer: User, id: string): Promise<ListingDto> {
    const listing = await this.get(viewer, id);
    if (listing.owner.id !== viewer.id) {
      throw new AppError(
        HttpStatus.FORBIDDEN,
        'not_owner',
        'Only the person who posted it can close it.',
      );
    }
    if (listing.status !== 'open' && listing.status !== 'full') {
      throw new AppError(
        HttpStatus.CONFLICT,
        'listing_not_live',
        'That listing has already ended.',
      );
    }
    await this.db
      .update(listings)
      .set({ status: 'closed', closedAt: new Date() })
      .where(and(eq(listings.id, id), inArray(listings.status, LIVE)));
    return this.get(viewer, id);
  }

  /** Your open or full listing, if it hasn't run out. */
  mine(viewer: User): Promise<ListingDto | null> {
    return this.one(
      and(
        eq(listings.ownerId, viewer.id),
        inArray(listings.status, LIVE),
        gt(listings.expiresAt, new Date()),
      ),
      viewer.id,
    );
  }

  /** docs/DATA_MODEL.md "Looking now" counter. */
  async lookingNow(viewer: User): Promise<number> {
    const now = new Date();
    const [row] = await this.db
      .select({ n: countDistinct(users.id) })
      .from(users)
      .where(
        and(
          isLive(),
          eq(users.city, viewer.city),
          or(
            and(eq(users.status, 'looking'), gt(users.statusUntil, now)),
            exists(
              this.db
                .select({ one: sql`1` })
                .from(listings)
                .where(
                  and(
                    eq(listings.ownerId, users.id),
                    eq(listings.status, 'open'),
                    gt(listings.expiresAt, now),
                  ),
                ),
            ),
          ),
        ),
      );
    return row!.n;
  }

  /** For share pages, no sign-in. Hidden once the owner is banned or deleted, or an admin removed it. */
  async publicListing(id: string): Promise<PublicListingDto> {
    const [row] = await this.select(
      and(eq(listings.id, id), ne(listings.status, 'removed'), isLive()),
    ).limit(1);
    if (!row) throw notFound('That listing');
    const { listing: l, owner } = row;
    return {
      id: l.id,
      ownerDisplayName: owner.displayName,
      ownerAvatarUrl: this.profiles.avatarUrl(owner.avatarKey),
      game: row.game,
      mode: row.mode,
      rank: row.rank,
      platform: l.platform,
      partySize: l.partySize,
      filled: l.filled,
      voice: l.voice,
      playWhen: l.playWhen,
      startsAt: l.startsAt,
      expiresAt: l.expiresAt,
      note: l.note,
      status: effectiveStatus(l.status, l.expiresAt, new Date()),
    };
  }
}
