import { eq } from 'drizzle-orm';
import { env } from '../env.js';
import { createDb } from './db.js';
import { users } from './schema/index.js';

// `pnpm --filter @app/api admin:grant <email>`: makes an existing account an
// admin (apps/admin signs in with it). `--revoke` turns it back into a player.
const [email, flag] = process.argv.slice(2);
if (!email) {
  console.error('usage: admin:grant <email> [--revoke]');
  process.exit(1);
}
const { db, client } = createDb(env.databaseUrl);
const role = flag === '--revoke' ? 'player' : 'admin';
const updated = await db
  .update(users)
  .set({ role, updatedAt: new Date() })
  .where(eq(users.email, email.trim().toLowerCase()))
  .returning({ username: users.username });
await client.end();
if (updated.length === 0) {
  console.error(`No account with email ${email}. Sign up first.`);
  process.exit(1);
}
console.log(`${updated[0]!.username} is now ${role === 'admin' ? 'an admin' : 'a player'}.`);
