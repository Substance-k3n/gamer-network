import { Inject, Injectable, Logger, type OnApplicationBootstrap } from '@nestjs/common';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { env } from '../env.js';
import type { Job } from '../jobs/jobs.js';
import { NotificationsService, PUSH_CHANNEL } from './notifications.service.js';

/**
 * Pushes new notifications within a moment of their transaction committing
 * (LISTEN on PUSH_CHANNEL), and every minute sweeps up anything missed
 * while the API was down. Off when JOBS_ENABLED=false; tests call dispatch.
 */
@Injectable()
export class PushDispatcher implements OnApplicationBootstrap, Job {
  readonly name = 'push-sweep';
  readonly everyMs = 60 * 1000;
  private readonly log = new Logger(PushDispatcher.name);
  private running = false;
  private again = false;

  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly notifications: NotificationsService,
  ) {}

  async onApplicationBootstrap() {
    if (!env.jobsEnabled) return;
    await this.db.$client.listen(PUSH_CHANNEL, () => this.kick());
    this.kick();
  }

  /** Coalesces bursts: one dispatch at a time, plus one more if kicked meanwhile. */
  private kick() {
    if (this.running) {
      this.again = true;
      return;
    }
    this.running = true;
    this.notifications
      .dispatchAll()
      .catch((e: unknown) => this.log.error('push dispatch failed', e))
      .finally(() => {
        this.running = false;
        if (this.again) {
          this.again = false;
          this.kick();
        }
      });
  }

  // The sweep needs no lock of its own: dispatch claims rows with SKIP LOCKED.
  async run(): Promise<void> {
    await this.notifications.dispatchAll();
  }
}
