import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, gt, inArray, isNull, lte, sql } from 'drizzle-orm';
import { AppError, notFound } from '../common/app-error.js';
import type { User } from '../auth/sessions.service.js';
import { orderedPair } from '../connections/connections.service.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  checkIns,
  connections,
  games,
  listings,
  notifications,
  playInvites,
  users,
} from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { visibleTo } from '../users/visibility.js';
import { INVITE_TTL_MS, inviteCheckInDueAt, inviteStartsAt } from './play-times.js';
import type { CheckInAnswer, CheckInDto, PlayInviteDto, SendInviteBody } from './play.dto.js';

export const DAILY_INVITE_LIMIT = 20;
const DAY_MS = 24 * 60 * 60 * 1000;

type InviteRow = typeof playInvites.$inferSelect;

const conflict = (code: string, message: string) =>
  new AppError(HttpStatus.CONFLICT, code, message);

@Injectable()
export class PlayService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
    private readonly notifier: NotificationsService,
  ) {}

  private async build(rows: InviteRow[]): Promise<PlayInviteDto[]> {
    if (rows.length === 0) return [];
    const now = new Date();
    const [people, gameRows] = await Promise.all([
      this.db
        .select()
        .from(users)
        .where(inArray(users.id, [...new Set(rows.flatMap((r) => [r.fromUserId, r.toUserId]))])),
      this.db
        .select({ id: games.id, name: games.name, shortCode: games.shortCode })
        .from(games)
        .where(inArray(games.id, [...new Set(rows.map((r) => r.gameId))])),
    ]);
    const cards = new Map((await this.profiles.cards(people)).map((c) => [c.id, c]));
    const game = new Map(gameRows.map((g) => [g.id, g]));
    return rows.map((r) => ({
      id: r.id,
      from: cards.get(r.fromUserId)!,
      to: cards.get(r.toUserId)!,
      game: game.get(r.gameId)!,
      playWhen: r.playWhen,
      startsAt: r.startsAt,
      expiresAt: r.expiresAt,
      status: r.status === 'pending' && r.expiresAt <= now ? 'expired' : r.status,
      createdAt: r.createdAt,
    }));
  }

  async invite(from: User, body: SendInviteBody): Promise<PlayInviteDto> {
    const to = await this.db.query.users.findFirst({
      where: and(eq(users.id, body.toUserId), visibleTo(this.db, from.id)),
    });
    if (!to || to.id === from.id) throw notFound('That player');
    const [a, b] = orderedPair(from.id, to.id);
    const now = new Date();
    const [connected, game, open, [today]] = await Promise.all([
      this.db.query.connections.findFirst({
        where: and(eq(connections.userAId, a), eq(connections.userBId, b)),
      }),
      this.db.query.games.findFirst({ where: eq(games.id, body.gameId) }),
      this.db.query.playInvites.findFirst({
        where: and(
          eq(playInvites.fromUserId, from.id),
          eq(playInvites.toUserId, to.id),
          eq(playInvites.status, 'pending'),
          gt(playInvites.expiresAt, now),
        ),
      }),
      this.db
        .select({ n: sql<number>`count(*)::int` })
        .from(playInvites)
        .where(
          and(
            eq(playInvites.fromUserId, from.id),
            gt(playInvites.createdAt, new Date(now.getTime() - DAY_MS)),
          ),
        ),
    ]);
    if (!connected) {
      throw new AppError(
        HttpStatus.FORBIDDEN,
        'not_connected',
        'Connect first, then invite them to play.',
      );
    }
    if (!game) {
      throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Unknown game.', {
        gameId: 'Unknown game',
      });
    }
    if (open) throw conflict('invite_pending', 'You already invited them. Waiting for an answer.');
    if (today!.n >= DAILY_INVITE_LIMIT) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'daily_limit',
        `You can send ${DAILY_INVITE_LIMIT} invites a day. Try again tomorrow.`,
      );
    }

    const startsAt = inviteStartsAt(body.playWhen, now);
    const row = await this.db.transaction(async (tx) => {
      const [created] = await tx
        .insert(playInvites)
        .values({
          fromUserId: from.id,
          toUserId: to.id,
          gameId: game.id,
          playWhen: body.playWhen,
          startsAt,
          expiresAt: new Date(startsAt.getTime() + INVITE_TTL_MS),
          createdAt: now,
        })
        .returning();
      await this.notifier.notify(tx, [
        { userId: to.id, type: 'play_invite', actorId: from.id, playInviteId: created!.id },
      ]);
      return created!;
    });
    return (await this.build([row]))[0]!;
  }

  /** Pending, unexpired invites to you (the banner) or from you. */
  async list(viewer: User, direction: 'incoming' | 'outgoing'): Promise<PlayInviteDto[]> {
    const incoming = direction === 'incoming';
    const rows = await this.db
      .select({ invite: playInvites })
      .from(playInvites)
      .innerJoin(users, eq(users.id, incoming ? playInvites.fromUserId : playInvites.toUserId))
      .where(
        and(
          eq(incoming ? playInvites.toUserId : playInvites.fromUserId, viewer.id),
          eq(playInvites.status, 'pending'),
          gt(playInvites.expiresAt, new Date()),
          visibleTo(this.db, viewer.id),
        ),
      )
      .orderBy(desc(playInvites.id))
      .limit(50);
    return this.build(rows.map((r) => r.invite));
  }

  /** Accepting creates both check-ins (docs/DATA_MODEL.md "Accepting a play invite"). */
  async accept(viewer: User, id: string): Promise<PlayInviteDto> {
    const now = new Date();
    const row = await this.db.transaction(async (tx) => {
      const [invite] = await tx
        .select()
        .from(playInvites)
        .where(and(eq(playInvites.id, id), eq(playInvites.toUserId, viewer.id)))
        .for('update');
      if (!invite) throw notFound('That invite');
      if (invite.status !== 'pending') {
        throw conflict('invite_not_pending', 'That invite was already answered.');
      }
      if (invite.expiresAt <= now) {
        await tx.update(playInvites).set({ status: 'expired' }).where(eq(playInvites.id, id));
        return null;
      }
      const [accepted] = await tx
        .update(playInvites)
        .set({ status: 'accepted', respondedAt: now })
        .where(eq(playInvites.id, id))
        .returning();
      await tx
        .insert(checkIns)
        .values(
          [
            [invite.fromUserId, invite.toUserId],
            [invite.toUserId, invite.fromUserId],
          ].map(([userId, otherUserId]) => ({
            userId: userId!,
            otherUserId: otherUserId!,
            playInviteId: invite.id,
            dueAt: inviteCheckInDueAt(now),
          })),
        )
        .onConflictDoNothing();
      await this.notifier.notify(tx, [
        {
          userId: invite.fromUserId,
          type: 'play_invite_accepted',
          actorId: viewer.id,
          playInviteId: invite.id,
        },
      ]);
      return accepted!;
    });
    if (!row) throw conflict('invite_expired', 'That invite has expired. Send them a new one.');
    return (await this.build([row]))[0]!;
  }

  async decline(viewer: User, id: string): Promise<void> {
    const declined = await this.db
      .update(playInvites)
      .set({ status: 'declined', respondedAt: new Date() })
      .where(
        and(
          eq(playInvites.id, id),
          eq(playInvites.toUserId, viewer.id),
          eq(playInvites.status, 'pending'),
        ),
      )
      .returning({ id: playInvites.id });
    if (declined.length === 0) {
      const exists = await this.db.query.playInvites.findFirst({
        where: and(eq(playInvites.id, id), eq(playInvites.toUserId, viewer.id)),
      });
      if (!exists) throw notFound('That invite');
      throw conflict('invite_not_pending', 'That invite was already answered.');
    }
  }

  /** Due, unanswered check-ins about people you can still see, oldest first. */
  async dueCheckIns(viewer: User): Promise<CheckInDto[]> {
    const rows = await this.db
      .select({
        checkIn: checkIns,
        other: users,
        game: { id: games.id, name: games.name, shortCode: games.shortCode },
      })
      .from(checkIns)
      .innerJoin(users, eq(users.id, checkIns.otherUserId))
      .leftJoin(listings, eq(listings.id, checkIns.listingId))
      .leftJoin(playInvites, eq(playInvites.id, checkIns.playInviteId))
      .leftJoin(games, eq(games.id, sql`coalesce(${listings.gameId}, ${playInvites.gameId})`))
      .where(
        and(
          eq(checkIns.userId, viewer.id),
          isNull(checkIns.answer),
          lte(checkIns.dueAt, new Date()),
          visibleTo(this.db, viewer.id),
        ),
      )
      .orderBy(asc(checkIns.dueAt))
      .limit(20);
    const cards = await this.profiles.cards(rows.map((r) => r.other));
    return rows.map((r, i) => ({
      id: r.checkIn.id,
      other: cards[i]!,
      game: r.game,
      listingId: r.checkIn.listingId,
      playInviteId: r.checkIn.playInviteId,
      dueAt: r.checkIn.dueAt,
    }));
  }

  /** One tap. Can be changed later ("not yet" → "played"). Clears its Alert. */
  async answer(viewer: User, id: string, answer: CheckInAnswer): Promise<void> {
    const now = new Date();
    const updated = await this.db
      .update(checkIns)
      .set({ answer, answeredAt: now })
      .where(and(eq(checkIns.id, id), eq(checkIns.userId, viewer.id)))
      .returning({ id: checkIns.id });
    if (updated.length === 0) throw notFound('That check-in');
    await this.db
      .update(notifications)
      .set({ readAt: now })
      .where(
        and(
          eq(notifications.checkInId, id),
          eq(notifications.userId, viewer.id),
          isNull(notifications.readAt),
        ),
      );
  }
}
