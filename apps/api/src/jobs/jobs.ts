import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnApplicationShutdown,
} from '@nestjs/common';
import { sql } from 'drizzle-orm';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { env } from '../env.js';

/** Work that runs on a timer. `run` gets a transaction that holds the job's lock. */
export interface Job {
  /** Unique; also picks the Postgres advisory lock. */
  readonly name: string;
  readonly everyMs: number;
  run(tx: Tx, now: Date): Promise<void>;
}

export const JOBS = Symbol('JOBS');

/** Stable 32-bit key per job name for pg_try_advisory_xact_lock. */
export const lockKey = (name: string) =>
  [...name].reduce((h, c) => (Math.imul(h, 31) + c.charCodeAt(0)) | 0, 7);

/**
 * Runs every job on its timer once the app is up (unless JOBS_ENABLED=false,
 * as in tests, which call `runOnce`). Each run takes a transaction-scoped
 * advisory lock, so two API instances never run the same job at once.
 */
@Injectable()
export class JobRunner implements OnApplicationBootstrap, OnApplicationShutdown {
  private readonly log = new Logger(JobRunner.name);
  private readonly timers: NodeJS.Timeout[] = [];

  constructor(
    @Inject(DB) private readonly db: Db,
    @Inject(JOBS) private readonly jobs: Job[],
  ) {}

  onApplicationBootstrap() {
    if (!env.jobsEnabled) return;
    for (const job of this.jobs) {
      this.timers.push(
        setInterval(() => {
          this.runOnce(job.name).catch((e: unknown) => this.log.error(`${job.name} failed`, e));
        }, job.everyMs),
      );
    }
  }

  onApplicationShutdown() {
    for (const t of this.timers) clearInterval(t);
  }

  /** Runs `name` now. False when another instance holds its lock. */
  async runOnce(name: string, now = new Date()): Promise<boolean> {
    const job = this.jobs.find((j) => j.name === name);
    if (!job) throw new Error(`no job ${name}`);
    return this.db.transaction(async (tx) => {
      const [row] = await tx.execute<{ locked: boolean }>(
        sql`select pg_try_advisory_xact_lock(${lockKey(job.name)}) as locked`,
      );
      if (!row?.locked) return false;
      await job.run(tx, now);
      return true;
    });
  }
}
