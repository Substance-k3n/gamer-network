// Named enums for the spec, so generated clients get one type each
// (e.g. Dart `Platform`) instead of anonymous string unions.
import { platform } from '../db/schema/index.js';

/** Every value that can come back, including the squad-game ones in history. */
export const PLATFORMS = platform.enumValues;
export type Platform = (typeof PLATFORMS)[number];

/** What a profile, a listing or a game can be set to now: where chess is played (ADR-0015). */
export const PLAY_PLATFORMS = ['chess_com', 'lichess'] as const satisfies readonly Platform[];
