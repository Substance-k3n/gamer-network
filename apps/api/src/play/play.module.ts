import { Module } from '@nestjs/common';
import { CheckInsDueJob } from './check-ins-due.job.js';
import { CheckInsController, PlayInvitesController } from './play.controller.js';
import { PlayService } from './play.service.js';

@Module({
  controllers: [PlayInvitesController, CheckInsController],
  providers: [PlayService, CheckInsDueJob],
  exports: [CheckInsDueJob],
})
export class PlayModule {}
