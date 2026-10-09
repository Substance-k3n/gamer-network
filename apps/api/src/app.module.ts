import { Module } from '@nestjs/common';
import { AppConfigModule } from './app-config/app-config.module.js';
import { DbModule } from './db/db.module.js';
import { GamesModule } from './games/games.module.js';
import { HealthModule } from './health/health.module.js';

@Module({
  imports: [DbModule, HealthModule, AppConfigModule, GamesModule],
})
export class AppModule {}
