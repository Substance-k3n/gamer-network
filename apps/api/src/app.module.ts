import { Module } from '@nestjs/common';
import { AppConfigModule } from './app-config/app-config.module.js';
import { AuthModule } from './auth/auth.module.js';
import { DbModule } from './db/db.module.js';
import { GamesModule } from './games/games.module.js';
import { HealthModule } from './health/health.module.js';
import { MailModule } from './mail/mail.module.js';
import { MeModule } from './me/me.module.js';
import { UsersModule } from './users/users.module.js';

@Module({
  imports: [
    DbModule,
    MailModule,
    AuthModule,
    HealthModule,
    AppConfigModule,
    GamesModule,
    MeModule,
    UsersModule,
  ],
})
export class AppModule {}
