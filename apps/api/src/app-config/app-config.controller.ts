import { Controller, Get, Header } from '@nestjs/common';
import { Public } from '../auth/auth.decorators.js';
import { ApiTags } from '@nestjs/swagger';
import { env } from '../env.js';
import { AppConfigResponse } from './app-config.dto.js';

@ApiTags('app')
@Public()
@Controller('app')
export class AppConfigController {
  /** What the app needs before anything else: version gate and launch settings. */
  @Get('config')
  @Header('Cache-Control', 'public, max-age=300')
  get(): AppConfigResponse {
    return {
      minSupportedVersion: env.minAppVersion,
      latestVersion: env.latestAppVersion,
      launchCity: env.launchCity,
      groupsComingSoon: true,
    };
  }
}
