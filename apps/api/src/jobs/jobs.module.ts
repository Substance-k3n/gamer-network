import { Module } from '@nestjs/common';
import { ListingExpiryJob } from '../listings/listing-expiry.job.js';
import { ListingsModule } from '../listings/listings.module.js';
import { PushDispatcher } from '../notifications/push-dispatcher.js';
import { CheckInsDueJob } from '../play/check-ins-due.job.js';
import { PlayModule } from '../play/play.module.js';
import { AccountScrubJob } from '../safety/account-scrub.job.js';
import { SafetyModule } from '../safety/safety.module.js';
import { type Job, JOBS, JobRunner } from './jobs.js';

/** Every timed job, run by JobRunner. Add new jobs to `inject` and the factory. */
@Module({
  imports: [ListingsModule, PlayModule, SafetyModule],
  providers: [
    {
      provide: JOBS,
      useFactory: (...jobs: Job[]) => jobs,
      inject: [ListingExpiryJob, CheckInsDueJob, AccountScrubJob, PushDispatcher],
    },
    JobRunner,
  ],
  exports: [JobRunner],
})
export class JobsModule {}
