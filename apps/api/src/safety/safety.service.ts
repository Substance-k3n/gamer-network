import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNull, or } from 'drizzle-orm';
import { AppError, notFound } from '../common/app-error.js';
import { burnPasswordCheck, verifyPassword } from '../auth/crypto.js';
import { SessionsService, type User } from '../auth/sessions.service.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import {
  blocks,
  connectionRequests,
  connections,
  listings,
  playInvites,
  reports,
  users,
  waitlist,
} from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import type { UserCardDto } from '../me/profile.dto.js';
import type { ReportBody } from './safety.dto.js';

const between = (
  from: typeof connectionRequests.fromUserId | typeof playInvites.fromUserId,
  to: typeof connectionRequests.toUserId | typeof playInvites.toUserId,
  x: string,
  y: string,
) => or(and(eq(from, x), eq(to, y)), and(eq(from, y), eq(to, x)));

@Injectable()
export class SafetyService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly profiles: ProfileService,
    private readonly sessions: SessionsService,
  ) {}

  /**
   * docs/DATA_MODEL.md "Blocks": hidden from each other everywhere (the
   * visibility rule does that), the connection goes, and pending requests
   * and invites between them are withdrawn.
   */
  async block(me: User, userId: string): Promise<void> {
    if (userId === me.id) {
      throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', "That's you.", {
        userId: "You can't block yourself",
      });
    }
    const target = await this.db.query.users.findFirst({ where: eq(users.id, userId) });
    if (!target) throw notFound('That player');
    const now = new Date();
    await this.db.transaction(async (tx) => {
      await tx.insert(blocks).values({ blockerId: me.id, blockedId: userId }).onConflictDoNothing();
      await this.cutTies(tx, me.id, userId, now);
    });
  }

  /** Ends everything pending or live between two people. */
  private async cutTies(tx: Tx, x: string, y: string, now: Date) {
    const [a, b] = x < y ? [x, y] : [y, x];
    await tx.delete(connections).where(and(eq(connections.userAId, a), eq(connections.userBId, b)));
    await tx
      .update(connectionRequests)
      .set({ status: 'cancelled', respondedAt: now })
      .where(
        and(
          eq(connectionRequests.status, 'pending'),
          between(connectionRequests.fromUserId, connectionRequests.toUserId, x, y),
        ),
      );
    await tx
      .update(playInvites)
      .set({ status: 'declined', respondedAt: now })
      .where(
        and(
          eq(playInvites.status, 'pending'),
          between(playInvites.fromUserId, playInvites.toUserId, x, y),
        ),
      );
  }

  async unblock(me: User, userId: string): Promise<void> {
    const removed = await this.db
      .delete(blocks)
      .where(and(eq(blocks.blockerId, me.id), eq(blocks.blockedId, userId)))
      .returning({ id: blocks.blockedId });
    if (removed.length === 0) throw notFound('That block');
  }

  async blocked(me: User): Promise<UserCardDto[]> {
    const rows = await this.db
      .select({ user: users })
      .from(blocks)
      .innerJoin(users, eq(users.id, blocks.blockedId))
      .where(and(eq(blocks.blockerId, me.id), isNull(users.deletedAt)))
      .orderBy(desc(blocks.createdAt));
    return this.profiles.cards(rows.map((r) => r.user));
  }

  async report(me: User, body: ReportBody): Promise<void> {
    if (body.userId === me.id) {
      throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', "That's you.", {
        userId: "You can't report yourself",
      });
    }
    const target = await this.db.query.users.findFirst({ where: eq(users.id, body.userId) });
    if (!target) throw notFound('That player');
    if (body.listingId) {
      const listing = await this.db.query.listings.findFirst({
        where: eq(listings.id, body.listingId),
      });
      if (!listing || listing.ownerId !== target.id) {
        throw new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', 'Wrong listing.', {
          listingId: "Not one of this player's listings",
        });
      }
    }
    await this.db.insert(reports).values({
      reporterId: me.id,
      targetUserId: target.id,
      listingId: body.listingId ?? null,
      reason: body.reason,
      details: body.details ?? null,
    });
  }

  async joinWaitlist(me: User, topic: string): Promise<void> {
    await this.db.insert(waitlist).values({ userId: me.id, topic }).onConflictDoNothing();
  }

  /**
   * Play-required account deletion. Signs out everywhere, closes the live
   * listing and withdraws everything pending at once; personal data is
   * scrubbed 30 days later (AccountScrubJob).
   */
  async deleteAccount(me: User, password: string | undefined): Promise<void> {
    if (me.passwordHash) {
      const ok = password ? await verifyPassword(me.passwordHash, password) : false;
      if (!ok) {
        throw new AppError(HttpStatus.UNAUTHORIZED, 'wrong_password', 'That password is wrong.', {
          password: 'Wrong password',
        });
      }
    } else if (password) {
      await burnPasswordCheck(password);
    }
    const now = new Date();
    await this.db.transaction(async (tx) => {
      await tx
        .update(users)
        .set({ deletedAt: now, status: 'not_available', statusUntil: null, updatedAt: now })
        .where(eq(users.id, me.id));
      await tx
        .update(listings)
        .set({ status: 'closed', closedAt: now })
        .where(and(eq(listings.ownerId, me.id), inArray(listings.status, ['open', 'full'])));
      await tx
        .update(connectionRequests)
        .set({ status: 'cancelled', respondedAt: now })
        .where(
          and(
            eq(connectionRequests.status, 'pending'),
            or(eq(connectionRequests.fromUserId, me.id), eq(connectionRequests.toUserId, me.id)),
          ),
        );
      await tx
        .update(playInvites)
        .set({ status: 'declined', respondedAt: now })
        .where(
          and(
            eq(playInvites.status, 'pending'),
            or(eq(playInvites.fromUserId, me.id), eq(playInvites.toUserId, me.id)),
          ),
        );
      await tx
        .delete(connections)
        .where(or(eq(connections.userAId, me.id), eq(connections.userBId, me.id)));
    });
    await this.sessions.revokeAll(me.id);
  }
}
