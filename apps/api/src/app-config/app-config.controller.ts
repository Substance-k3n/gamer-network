import { Controller, Get, Header } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { env } from '../env.js';

export class AppConfigResponse {
  /** Apps below this version must update (they get 426 everywhere else). */
  minSupportedVersion: string;

  /** Newest released version, for a gentle "Update available". */
  latestVersion: string;

  /** The one city the beta runs in. */
  launchCity: string;

  /** Show the Groups tab as "coming soon" with a waitlist. */
  groupsComingSoon: boolean;
}

@ApiTags('app')
@Controller('app')
export class AppConfigController {
  /** What the app needs before anything else: version gate and launch settings. */
  @Get('config')
  @Header('Cache-Control', 'public, max-age=300')
  config(): AppConfigResponse {
    return {
      minSupportedVersion: env.minAppVersion,
      latestVersion: env.latestAppVersion,
      launchCity: env.launchCity,
      groupsComingSoon: true,
    };
  }
}
