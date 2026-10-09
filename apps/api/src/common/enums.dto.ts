// Named enums for the spec, so generated clients get one type each
// (e.g. Dart `Platform`) instead of anonymous string unions.
import { platform } from '../db/schema/index.js';

export const PLATFORMS = platform.enumValues;
export type Platform = (typeof PLATFORMS)[number];
