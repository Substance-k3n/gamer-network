import { Controller, Get, Header } from '@nestjs/common';
import { Public } from '../auth/auth.decorators.js';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { GameDto } from './games.dto.js';
import { GamesService } from './games.service.js';

@ApiTags('games')
@Public()
@Controller('games')
export class GamesController {
  constructor(private readonly games: GamesService) {}

  /** The full game catalog with ranks, roles and modes. Cache it; it rarely changes. */
  @Get()
  @Header('Cache-Control', 'public, max-age=3600')
  @ApiOkResponse({ type: GameDto, isArray: true })
  list(): Promise<GameDto[]> {
    return this.games.catalog();
  }
}
