import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gte, inArray, lte, type SQL, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import type { PageQuery } from '../common/cursor.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { games, groupEventGoing, groupEvents, users } from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import { isLive, visibleTo } from '../users/visibility.js';
import { GroupAccess } from './group-access.js';
import { decodeKey, encodeKey } from './group-cursor.js';
import { GroupNotifier } from './group-notifier.js';
import { EVENT_SHOWN_AFTER_START_MS, eventStartError } from './group-rules.js';
import type { CreateGroupEventBody } from './groups.body.js';
import type { GroupEventDto, GroupEventPageDto } from './groups.dto.js';

const invalid = (fields: Record<string, string>) =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'validation_failed',
    'Some fields need fixing.',
    fields,
  );

type EventRow = {
  event: typeof groupEvents.$inferSelect;
  creator: typeof users.$inferSelect;
  game: GroupEventDto['game'];
  at: string;
};

/** docs/FEED_AND_GROUPS_API.md "Groups": events, and who's going. */
@Injectable()
export class GroupEventsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly access: GroupAccess,
    private readonly notifier: GroupNotifier,
    private readonly profiles: ProfileService,
  ) {}

  /** Events `viewerId` may see (their creator isn't hidden from them), with creator and game. */
  private rows(viewerId: string, where?: SQL) {
    return this.db
      .select({
        event: groupEvents,
        creator: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
        at: sql<string>`${groupEvents.startsAt}::text`,
      })
      .from(groupEvents)
      .innerJoin(users, eq(users.id, groupEvents.createdBy))
      .leftJoin(games, eq(games.id, groupEvents.gameId))
      .where(and(visibleTo(this.db, viewerId), where));
  }

  /** Still upcoming: from an hour after the start. */
  private upcoming(now: Date) {
    return gte(groupEvents.startsAt, new Date(now.getTime() - EVENT_SHOWN_AFTER_START_MS));
  }

  /** Upcoming events of a group anyone may see, soonest first. */
  async list(viewer: User, groupId: string, q: PageQuery): Promise<GroupEventPageDto> {
    await this.access.visible(groupId);
    const limit = q.limit ?? 20;
    const after = decodeKey(q.cursor, ['time', 'uuid']);
    const rows = await this.rows(
      viewer.id,
      and(
        eq(groupEvents.groupId, groupId),
        this.upcoming(new Date()),
        after
          ? sql`(${groupEvents.startsAt}, ${groupEvents.id}) > (${after[0]}::timestamptz, ${after[1]}::uuid)`
          : undefined,
      ),
    )
      .orderBy(asc(groupEvents.startsAt), asc(groupEvents.id))
      .limit(limit + 1);
    const items = rows.slice(0, limit);
    const last = items.at(-1);
    return {
      items: await this.build(items, viewer.id),
      nextCursor: rows.length > limit && last ? encodeKey(last.at, last.event.id) : null,
    };
  }

  /** The soonest upcoming event of each group, for Discover's "Next: …". */
  async next(groupIds: string[], viewerId: string): Promise<Map<string, GroupEventDto>> {
    if (groupIds.length === 0) return new Map();
    const rows = await this.db
      .selectDistinctOn([groupEvents.groupId], {
        event: groupEvents,
        creator: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
        at: sql<string>`${groupEvents.startsAt}::text`,
      })
      .from(groupEvents)
      .innerJoin(users, eq(users.id, groupEvents.createdBy))
      .leftJoin(games, eq(games.id, groupEvents.gameId))
      .where(
        and(
          inArray(groupEvents.groupId, groupIds),
          this.upcoming(new Date()),
          visibleTo(this.db, viewerId),
        ),
      )
      .orderBy(groupEvents.groupId, asc(groupEvents.startsAt), asc(groupEvents.id));
    const built = await this.build(rows, viewerId);
    return new Map(built.map((e) => [e.groupId, e]));
  }

  /** The event, or 404 when it, its group or its creator is hidden from you. */
  private async row(viewerId: string, eventId: string): Promise<EventRow> {
    const [row] = await this.rows(viewerId, eq(groupEvents.id, eventId)).limit(1);
    if (!row) throw notFound('That event');
    await this.access.visible(row.event.groupId).catch(() => {
      throw notFound('That event');
    });
    return row;
  }

  async get(viewer: User, eventId: string): Promise<GroupEventDto> {
    return (await this.build([await this.row(viewer.id, eventId)], viewer.id))[0]!;
  }

  /** Any member adds one, within the next 60 days. Tells the other members. */
  async create(viewer: User, groupId: string, body: CreateGroupEventBody): Promise<GroupEventDto> {
    const { group } = await this.access.member(groupId, viewer.id);
    const now = new Date();
    const when = eventStartError(body.startsAt, now);
    if (when) throw invalid({ startsAt: when });
    if (body.gameId) {
      const game = await this.db.query.games.findFirst({ where: eq(games.id, body.gameId) });
      if (!game) throw invalid({ gameId: 'Unknown game' });
    }
    const id = await this.db.transaction(async (tx) => {
      const [event] = await tx
        .insert(groupEvents)
        .values({
          groupId,
          createdBy: viewer.id,
          title: body.title,
          startsAt: body.startsAt,
          gameId: body.gameId ?? null,
        })
        .returning();
      await this.notifier.event(tx, group, event!, now);
      return event!.id;
    });
    return this.get(viewer, id);
  }

  /** Its creator or a group admin (403 not_owner). */
  async delete(viewer: User, eventId: string): Promise<void> {
    const { event } = await this.row(viewer.id, eventId);
    if (event.createdBy !== viewer.id) {
      const me = await this.access.membership(event.groupId, viewer.id);
      if (me?.status !== 'member' || me.role !== 'admin') {
        throw new AppError(
          HttpStatus.FORBIDDEN,
          'not_owner',
          'Only the person who added it or a group admin can delete it.',
        );
      }
    }
    await this.db.delete(groupEvents).where(eq(groupEvents.id, eventId));
  }

  /** I'm in (members only, 403 not_member), or not any more. Repeating either is fine. */
  async going(viewer: User, eventId: string, on: boolean): Promise<GroupEventDto> {
    const row = await this.row(viewer.id, eventId);
    if (on) {
      await this.access.member(row.event.groupId, viewer.id);
      await this.db
        .insert(groupEventGoing)
        .values({ eventId, userId: viewer.id })
        .onConflictDoNothing();
    } else {
      await this.db
        .delete(groupEventGoing)
        .where(and(eq(groupEventGoing.eventId, eventId), eq(groupEventGoing.userId, viewer.id)));
    }
    return (await this.build([row], viewer.id))[0]!;
  }

  private async build(rows: EventRow[], viewerId: string): Promise<GroupEventDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((r) => r.event.id);
    // Up to 3 going per event, earliest first, among people the viewer may see.
    const ranked = this.db
      .select({
        eventId: groupEventGoing.eventId,
        userId: groupEventGoing.userId,
        rank: sql<number>`row_number() over (partition by ${groupEventGoing.eventId} order by ${groupEventGoing.createdAt}, ${groupEventGoing.userId})`.as(
          'rank',
        ),
      })
      .from(groupEventGoing)
      .innerJoin(users, eq(users.id, groupEventGoing.userId))
      .where(and(inArray(groupEventGoing.eventId, ids), visibleTo(this.db, viewerId)))
      .as('ranked');
    const [creators, counts, preview, mine] = await Promise.all([
      this.profiles.cards(rows.map((r) => r.creator)),
      this.db
        .select({ id: groupEventGoing.eventId, n: sql<number>`count(*)::int` })
        .from(groupEventGoing)
        .innerJoin(users, eq(users.id, groupEventGoing.userId))
        .where(and(inArray(groupEventGoing.eventId, ids), isLive()))
        .groupBy(groupEventGoing.eventId),
      this.db
        .select({ eventId: ranked.eventId, user: users })
        .from(ranked)
        .innerJoin(users, eq(users.id, ranked.userId))
        .where(lte(ranked.rank, 3))
        .orderBy(ranked.eventId, ranked.rank),
      this.db
        .select({ id: groupEventGoing.eventId })
        .from(groupEventGoing)
        .where(and(eq(groupEventGoing.userId, viewerId), inArray(groupEventGoing.eventId, ids))),
    ]);
    const cards = await this.profiles.cards(preview.map((p) => p.user));
    const goingOf = new Map<string, typeof cards>();
    preview.forEach((p, i) =>
      goingOf.set(p.eventId, [...(goingOf.get(p.eventId) ?? []), cards[i]!]),
    );
    const count = new Map(counts.map((c) => [c.id, c.n]));
    const going = new Set(mine.map((m) => m.id));
    return rows.map(({ event: e, game }, i) => ({
      id: e.id,
      groupId: e.groupId,
      title: e.title,
      startsAt: e.startsAt,
      game,
      goingCount: count.get(e.id) ?? 0,
      goingPreview: goingOf.get(e.id) ?? [],
      imGoing: going.has(e.id),
      createdBy: creators[i]!,
    }));
  }
}
