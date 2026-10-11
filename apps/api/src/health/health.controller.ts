import { Controller, Get, Inject, ServiceUnavailableException } from '@nestjs/common';
import { Public } from '../auth/auth.decorators.js';
import { ApiProperty, ApiServiceUnavailableResponse, ApiTags } from '@nestjs/swagger';
import { sql } from 'drizzle-orm';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';

export class HealthResponse {
  @ApiProperty({ enum: ['ok'] })
  status: 'ok';

  @ApiProperty({ enum: ['ok'] })
  database: 'ok';
}

@ApiTags('health')
@Public()
@Controller('health')
export class HealthController {
  constructor(@Inject(DB) private readonly db: Db) {}

  /** Liveness and database check for uptime monitors and the deploy. */
  @Get()
  @ApiServiceUnavailableResponse({ description: 'The database is unreachable' })
  async check(): Promise<HealthResponse> {
    try {
      await this.db.execute(sql`select 1`);
    } catch {
      throw new ServiceUnavailableException({ status: 'error', database: 'down' });
    }
    return { status: 'ok', database: 'ok' };
  }
}
