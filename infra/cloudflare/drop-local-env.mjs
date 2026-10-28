// Run between `opennextjs-cloudflare build` and `deploy` (docs/DEPLOY.md §4).
// OpenNext copies every .env* file in the app, for every mode, into the
// Worker it uploads; local settings and test logins don't belong there.
// The Workers read their settings from wrangler.jsonc and secrets instead.
import { writeFileSync } from 'node:fs';

writeFileSync(
  '.open-next/cloudflare/next-env.mjs',
  'export const production = {};\nexport const development = {};\nexport const test = {};\n',
);
