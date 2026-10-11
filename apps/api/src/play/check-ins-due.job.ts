import { Injectable } from '@nestjs/common';
import { and, eq, isNull, lte, notExists, sql } from 'drizzle-orm';
import type { Tx } from '../db/db.js';
import { checkIns, notifications } from '../db/schema/index.js';
import type { Job } from '../jobs/jobs.js';
import { NotificationsService } from '../notifications/notifications.service.js';

/** Every minute: ask "Did you play with …?" once each check-in is due. */
@Injectable()
export class CheckInsDueJob implements Job {
  readonly name = 'check-ins-due';
  readonly everyMs = 60 * 1000;

  constructor(private readonly notifier: NotificationsService) {}

  async run(tx: Tx, now: Date): Promise<void> {
    const due = await tx
      .select()
      .from(checkIns)
      .where(
        and(
          isNull(checkIns.answer),
          lte(checkIns.dueAt, now),
          notExists(
            tx
              .select({ one: sql`1` })
              .from(notifications)
              .where(
                and(
                  eq(notifications.checkInId, checkIns.id),
                  eq(notifications.type, 'check_in_due'),
                ),
              ),
          ),
        ),
      )
      .limit(500);
    await this.notifier.notify(
      tx,
      due.map((c) => ({
        userId: c.userId,
        type: 'check_in_due' as const,
        actorId: c.otherUserId,
        checkInId: c.id,
        listingId: c.listingId,
        playInviteId: c.playInviteId,
      })),
    );
  }
}
