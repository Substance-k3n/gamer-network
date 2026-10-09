import { Controller, Get } from '@nestjs/common';
import { ApiProperty, ApiTags } from '@nestjs/swagger';

export class HealthResponse {
  @ApiProperty({ enum: ['ok'] })
  status: 'ok';
}

@ApiTags('health')
@Controller('health')
export class HealthController {
  /** Liveness check for uptime monitors and the deploy. */
  @Get()
  check(): HealthResponse {
    return { status: 'ok' };
  }
}
