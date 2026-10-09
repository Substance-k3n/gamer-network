import { Global, Module } from '@nestjs/common';
import { MeController, UsernamesController } from './me.controller.js';
import { ProfileService } from './profile.service.js';

/** Global so sign-in can answer with the same Me as GET /v1/me. */
@Global()
@Module({
  controllers: [MeController, UsernamesController],
  providers: [ProfileService],
  exports: [ProfileService],
})
export class MeModule {}
