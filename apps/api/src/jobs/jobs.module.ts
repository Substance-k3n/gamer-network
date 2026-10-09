import { Module } from '@nestjs/common';
import { ListingExpiryJob } from '../listings/listing-expiry.job.js';
import { ListingsModule } from '../listings/listings.module.js';
import { PushDispatcher } from '../notifications/push-dispatcher.js';
import { type Job, JOBS, JobRunner } from './jobs.js';

/** Every timed job, run by JobRunner. Add new jobs to `inject` and the factory. */
@Module({
  imports: [ListingsModule],
  providers: [
    {
      provide: JOBS,
      useFactory: (...jobs: Job[]) => jobs,
      inject: [ListingExpiryJob, PushDispatcher],
    },
    JobRunner,
  ],
  exports: [JobRunner],
})
export class JobsModule {}
