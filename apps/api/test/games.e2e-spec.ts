import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { seedGames } from '../src/db/seed/games.js';
import type { GameDto } from '../src/games/games.dto.js';
import { createTestApp } from './app.js';

describe('GET /v1/games', () => {
  let app: INestApplication<App>;
  let body: GameDto[];

  beforeAll(async () => {
    ({ app } = await createTestApp());
    const res = await request(app.getHttpServer()).get('/v1/games').expect(200);
    expect(res.headers['cache-control']).toBe('public, max-age=3600');
    // Admin tests add games of their own (ids starting with "t"): only the seed's count here.
    const seeded = new Set(seedGames.map((g) => g.id));
    body = (res.body as GameDto[]).filter((g) => seeded.has(g.id));
  });
  afterAll(() => app.close());

  it('is Chess alone (ADR-0015)', () => {
    expect(body.map((g) => g.id)).toEqual(['chess']);
    expect(body[0]).toMatchObject({
      name: 'Chess',
      platforms: ['chess_com', 'lichess'],
      maxParty: 2,
      isLaunch: true,
      hasRanks: true,
    });
  });

  it('gives Chess its rating bands lowest first and its time controls', () => {
    const chess = body[0]!;
    expect(chess.ranks.map((r) => r.tier)).toEqual([0, 1, 2, 3, 4]);
    expect(chess.ranks[0]!.name).toBe('Beginner (under 1000)');
    expect(chess.ranks[4]!.name).toBe('2200+');
    expect(chess.modes.map((m) => m.name).sort()).toEqual([
      'Blitz',
      'Bullet',
      'Classical',
      'Rapid',
    ]);
  });
});
