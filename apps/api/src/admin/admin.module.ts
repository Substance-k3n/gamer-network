import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module.js';
import { FeedModule } from '../feed/feed.module.js';
import { SafetyModule } from '../safety/safety.module.js';
import { AdminCatalogService } from './admin-catalog.service.js';
import { AdminController } from './admin.controller.js';
import { AdminService } from './admin.service.js';

@Module({
  imports: [AuthModule, FeedModule, SafetyModule],
  controllers: [AdminController],
  providers: [AdminService, AdminCatalogService],
})
export class AdminModule {}
