import { isOlder } from './app-version.js';

describe('isOlder', () => {
  it.each([
    ['1.1.9', '1.2.0', true],
    ['1.2.0', '1.2.0', false],
    ['1.10.0', '1.9.0', false],
    ['1.2', '1.2.1', true],
    ['2.0.0-beta', '1.9.9', false],
  ])('%s older than %s → %s', (a, b, expected) => {
    expect(isOlder(a, b)).toBe(expected);
  });
});
