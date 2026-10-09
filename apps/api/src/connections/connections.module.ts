import { Module } from '@nestjs/common';
import { ListingsModule } from '../listings/listings.module.js';
import { ConnectionRequestsController, ConnectionsController } from './connections.controller.js';
import { ConnectionsService } from './connections.service.js';

@Module({
  imports: [ListingsModule],
  controllers: [ConnectionRequestsController, ConnectionsController],
  providers: [ConnectionsService],
})
export class ConnectionsModule {}
