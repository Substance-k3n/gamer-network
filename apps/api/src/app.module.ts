import { Module } from '@nestjs/common';
import { AppConfigModule } from './app-config/app-config.module.js';
import { AuthModule } from './auth/auth.module.js';
import { ConnectionsModule } from './connections/connections.module.js';
import { DbModule } from './db/db.module.js';
import { GamesModule } from './games/games.module.js';
import { HealthModule } from './health/health.module.js';
import { MailModule } from './mail/mail.module.js';
import { JobsModule } from './jobs/jobs.module.js';
import { ListingsModule } from './listings/listings.module.js';
import { NotificationsModule } from './notifications/notifications.module.js';
import { PlayModule } from './play/play.module.js';
import { MeModule } from './me/me.module.js';
import { StorageModule } from './storage/storage.module.js';
import { UsersModule } from './users/users.module.js';

@Module({
  imports: [
    DbModule,
    MailModule,
    StorageModule,
    NotificationsModule,
    AuthModule,
    HealthModule,
    AppConfigModule,
    GamesModule,
    MeModule,
    UsersModule,
    ListingsModule,
    ConnectionsModule,
    PlayModule,
    JobsModule,
  ],
})
export class AppModule {}
