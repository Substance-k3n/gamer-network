// A separate database on the dev server, so tests never touch dev data.
export const TEST_DATABASE_URL =
  process.env.TEST_DATABASE_URL ?? 'postgres://gn:password@localhost:5470/gn_test';
