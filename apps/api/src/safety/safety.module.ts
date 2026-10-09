import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module.js';
import { AccountScrubJob } from './account-scrub.job.js';
import { AccountController, SafetyController } from './safety.controller.js';
import { SafetyService } from './safety.service.js';

@Module({
  imports: [AuthModule],
  controllers: [SafetyController, AccountController],
  providers: [SafetyService, AccountScrubJob],
  exports: [AccountScrubJob],
})
export class SafetyModule {}
