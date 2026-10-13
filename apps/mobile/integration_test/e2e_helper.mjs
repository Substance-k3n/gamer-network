// Host-side helper for integration_test/app_e2e_test.dart, dev only.
//
// The local API prints emailed codes to its console instead of sending
// them (no RESEND_API_KEY), and check-ins only fall due the next day. This
// serves both to the test on the emulator (through `adb reverse`):
//
//   GET  /code?email=…   the newest code the API printed for that email
//   POST /due?email=…    makes that person's open check-ins due now
//
// Usage (see integration_test/README.md):
//   node integration_test/e2e_helper.mjs /tmp/gn-api.log
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { createServer } from 'node:http';
import { fileURLToPath } from 'node:url';

const log = process.argv[2];
if (!log) {
  console.error('usage: node e2e_helper.mjs <api log file>');
  process.exit(1);
}
const compose = fileURLToPath(new URL('../../../infra/docker/dev/compose.yml', import.meta.url));
const port = Number(process.env.PORT ?? 3399);

const lastCode = (email) => {
  const text = readFileSync(log, 'utf8');
  const re = new RegExp(`to ${email.replace(/[.+]/g, '\\$&')} · (\\d{6})`, 'g');
  return [...text.matchAll(re)].at(-1)?.[1];
};

const sql = (query) =>
  execFileSync('docker', ['compose', '-f', compose, 'exec', '-T', 'postgres', 'psql', '-U', 'gn', '-d', 'gn', '-tAc', query], { encoding: 'utf8' }).trim();

createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const email = (url.searchParams.get('email') ?? '').toLowerCase();
  if (!/^[^\s'@]+@[^\s'@]+$/.test(email)) {
    res.writeHead(400).end('email?');
    return;
  }
  if (req.method === 'GET' && url.pathname === '/code') {
    const code = lastCode(email);
    res.writeHead(code ? 200 : 404, { 'content-type': 'text/plain' }).end(code ?? '');
    return;
  }
  if (req.method === 'POST' && url.pathname === '/due') {
    const n = sql(
      `with u as (update check_ins set due_at = now() - interval '1 minute' where answer is null and user_id = (select id from users where email = '${email}') returning 1) select count(*) from u`,
    );
    res.writeHead(200, { 'content-type': 'text/plain' }).end(n);
    return;
  }
  res.writeHead(404).end();
}).listen(port, () => console.log(`e2e helper on :${port}, reading ${log}`));
