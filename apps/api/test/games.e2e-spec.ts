import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import type { GameDto } from '../src/games/games.dto.js';
import { createTestApp } from './app.js';

describe('GET /v1/games', () => {
  let app: INestApplication<App>;
  let body: GameDto[];

  beforeAll(async () => {
    ({ app } = await createTestApp());
    const res = await request(app.getHttpServer()).get('/v1/games').expect(200);
    expect(res.headers['cache-control']).toBe('public, max-age=3600');
    body = res.body;
  });
  afterAll(() => app.close());

  it('returns the whole catalog in the app’s order', () => {
    expect(body).toHaveLength(49);
    expect(body[0]!.id).toBe('val');
  });

  it('gives each game its ladder lowest first, with modes', () => {
    const val = body.find((g) => g.id === 'val')!;
    expect(val.ranks.map((r) => r.tier)).toEqual([0, 1, 2, 3, 4, 5, 6, 7, 8]);
    expect(val.ranks[5]!.name).toBe('Diamond');
    expect(val.platforms).toEqual(['pc', 'playstation', 'xbox']);
    expect(val.modes.map((m) => m.name).sort()).toEqual(['Casual', 'Ranked', 'Unrated']);
  });

  it('marks the launch games', () => {
    expect(
      body
        .filter((g) => g.isLaunch)
        .map((g) => g.id)
        .sort(),
    ).toEqual(['codm', 'efootball', 'pubg']);
  });
});
