// The catalog a fresh database starts with: chess only (ADR-0015).
// The seed only adds what's missing; once a game exists, admins own it.

export interface SeedGame {
  id: string;
  name: string;
  shortCode: string;
  platforms: ('chess_com' | 'lichess')[];
  hasRanks: boolean;
  /** Low → high. */
  ranks: string[];
  /** Time controls; none of them is a "Ranked" mode (rated or casual is the listing's style). */
  modes: string[];
  maxParty: number;
  isLaunch: boolean;
}

export const seedGames: SeedGame[] = [
  {
    id: 'chess',
    name: 'Chess',
    shortCode: 'CHESS',
    platforms: ['chess_com', 'lichess'],
    hasRanks: true,
    // Rating bands: they read the same whichever site the rating is from.
    ranks: ['Beginner (under 1000)', '1000–1399', '1400–1799', '1800–2199', '2200+'],
    modes: ['Bullet', 'Blitz', 'Rapid', 'Classical'],
    maxParty: 2,
    isLaunch: true,
  },
];
