import { Injectable } from '@nestjs/common';
import { and, eq, gt, inArray, lte, notExists, sql } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { connectionRequests, listings, notifications } from '../db/schema/index.js';
import type { Job } from '../jobs/jobs.js';
import { NotificationsService } from '../notifications/notifications.service.js';

export const EXPIRING_WARNING_MS = 15 * 60 * 1000;

/**
 * docs/DATA_MODEL.md "Listing times": every minute, live listings whose
 * time ran out become expired and their pending requests expire with
 * them; owners get listing_expiring 15 minutes before the end, once.
 */
@Injectable()
export class ListingExpiryJob implements Job {
  readonly name = 'listing-expiry';
  readonly everyMs = 60 * 1000;

  constructor(private readonly notifier: NotificationsService) {}

  async run(tx: Tx, now: Date): Promise<void> {
    const expired = await tx
      .update(listings)
      .set({ status: 'expired' })
      .where(and(inArray(listings.status, ['open', 'full']), lte(listings.expiresAt, now)))
      .returning({ id: listings.id });
    if (expired.length) {
      await tx
        .update(connectionRequests)
        .set({ status: 'expired', respondedAt: now })
        .where(
          and(
            eq(connectionRequests.status, 'pending'),
            inArray(
              connectionRequests.listingId,
              expired.map((l) => l.id),
            ),
          ),
        );
    }

    const expiring = await tx
      .select({ id: listings.id, ownerId: listings.ownerId })
      .from(listings)
      .where(
        and(
          inArray(listings.status, ['open', 'full']),
          gt(listings.expiresAt, now),
          lte(listings.expiresAt, new Date(now.getTime() + EXPIRING_WARNING_MS)),
          notExists(
            tx
              .select({ one: sql`1` })
              .from(notifications)
              .where(
                and(
                  eq(notifications.listingId, listings.id),
                  eq(notifications.type, 'listing_expiring'),
                ),
              ),
          ),
        ),
      );
    await this.notifier.notify(
      tx,
      expiring.map((l) => ({ userId: l.ownerId, type: 'listing_expiring', listingId: l.id })),
    );
  }
}
