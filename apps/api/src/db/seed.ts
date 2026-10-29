import { sql } from 'drizzle-orm';
import { hashPassword } from '../auth/crypto.js';
import { env } from '../env.js';
import { createDb, type Db } from './db.js';
import { gameModes, gameRanks, games, users } from './schema/index.js';
import { seedGames } from './seed/games.js';

const MODES = ['Ranked', 'Unrated', 'Casual'] as const;

/**
 * Idempotent: safe to run on every deploy. Adds the games (with their
 * ladders) that aren't in the database yet and leaves the rest alone:
 * once a game exists, admins own it (edits, ranks, launch, delete).
 */
export async function seedCatalog(db: Db) {
  await db.transaction(async (tx) => {
    const top = Number(
      (
        await tx.execute<{ n: number | null }>(
          sql`select max(${games.sort})::int as n from ${games}`,
        )
      )[0]?.n ?? -1,
    );
    for (const [i, g] of seedGames.entries()) {
      const [added] = await tx
        .insert(games)
        .values({
          id: g.id,
          name: g.name,
          shortCode: g.shortCode,
          platforms: g.platforms,
          hasRanks: g.hasRanks,
          maxParty: g.maxParty,
          isLaunch: g.isLaunch,
          // A fresh database keeps the seed's order; later additions go last.
          sort: top < 0 ? i : top + 1 + i,
        })
        .onConflictDoNothing()
        .returning({ id: games.id });
      if (!added) continue;

      for (const [tier, name] of g.ranks.entries()) {
        await tx.insert(gameRanks).values({ gameId: g.id, tier, name });
      }
      for (const name of MODES) {
        if (name === 'Ranked' && !g.hasRanks) continue;
        await tx
          .insert(gameModes)
          .values({ gameId: g.id, name, isRanked: name === 'Ranked' })
          .onConflictDoNothing();
      }
    }
  });
  return seedGames.length;
}

/**
 * The admin account apps/admin signs in with, from ADMIN_EMAIL and
 * ADMIN_PASSWORD. Idempotent: an existing account with that email becomes
 * an admin, and the password always follows the env var, so changing it
 * and redeploying resets it. Never onboarded, so players never see it.
 */
export async function seedAdmin(db: Db, email: string, password: string) {
  if (password.length < 12) throw new Error('ADMIN_PASSWORD needs at least 12 characters.');
  const now = new Date();
  const passwordHash = await hashPassword(password);
  const [admin] = await db
    .insert(users)
    .values({
      email: email.trim().toLowerCase(),
      username: 'rally.admin',
      displayName: 'Rally admin',
      ageRange: '25_34',
      role: 'admin',
      emailVerifiedAt: now,
      passwordHash,
    })
    .onConflictDoUpdate({
      target: users.email,
      set: {
        role: 'admin',
        passwordHash,
        emailVerifiedAt: sql`coalesce(${users.emailVerifiedAt}, excluded.email_verified_at)`,
        updatedAt: now,
      },
    })
    .returning({ username: users.username });
  return admin!.username;
}

/** Seeds the admin when ADMIN_EMAIL and ADMIN_PASSWORD are set. */
export async function seedAdminFromEnv(db: Db) {
  const { adminEmail, adminPassword } = env;
  if (!adminEmail || !adminPassword) return;
  console.info(`admin ${await seedAdmin(db, adminEmail, adminPassword)} ready`);
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const { client, db } = createDb(env.databaseUrl);
  const count = await seedCatalog(db);
  await seedAdminFromEnv(db);
  await client.end();
  console.info(`seeded ${count} games`);
}
