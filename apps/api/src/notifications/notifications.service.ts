import { Injectable } from '@nestjs/common';
import type { Db, Tx } from '../db/db.js';
import { notifications } from '../db/schema/index.js';

export type NewNotification = typeof notifications.$inferInsert;

/**
 * The one place notifications are created, so push (phase 6) hooks in
 * here. Pass the caller's transaction so a rolled-back action never
 * notifies anyone.
 */
@Injectable()
export class NotificationsService {
  async notify(db: Db | Tx, rows: NewNotification[]): Promise<void> {
    if (rows.length === 0) return;
    await db.insert(notifications).values(rows);
  }
}
