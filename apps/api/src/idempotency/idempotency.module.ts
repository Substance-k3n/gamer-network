import { Module } from '@nestjs/common';
import { IdempotencyKeysJob } from './idempotency-keys.job.js';

@Module({
  providers: [IdempotencyKeysJob],
  exports: [IdempotencyKeysJob],
})
export class IdempotencyModule {}
