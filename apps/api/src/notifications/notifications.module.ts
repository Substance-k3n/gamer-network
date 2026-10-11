import { Global, Module } from '@nestjs/common';
import { DevicesController, NotificationsController } from './notifications.controller.js';
import { NotificationsService } from './notifications.service.js';
import { PushDispatcher } from './push-dispatcher.js';
import { createPusher, PUSHER } from './pusher.js';

@Global()
@Module({
  controllers: [NotificationsController, DevicesController],
  providers: [NotificationsService, PushDispatcher, { provide: PUSHER, useFactory: createPusher }],
  exports: [NotificationsService, PushDispatcher],
})
export class NotificationsModule {}
