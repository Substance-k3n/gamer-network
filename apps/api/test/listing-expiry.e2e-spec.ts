import { INestApplication } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { connectionRequests, listings, notifications, users } from '../src/db/schema/index.js';
import { JobRunner, lockKey } from '../src/jobs/jobs.js';
import { createTestApp, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// docs/DATA_MODEL.md "Listing times": the every-minute expiry job.

let app: INestApplication<App>;
let jobs: JobRunner;
const conn = createDb(TEST_DATABASE_URL);
const MIN = 60_000;

beforeAll(async () => {
  ({ app } = await createTestApp());
  jobs = app.get(JobRunner);
});
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

/** A live, verified player with an open 2 h pubg listing that started now. */
async function postedListing() {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `x_${id}@example.com`,
      password: 'correct horse battery',
      displayName: 'Yared',
      username: `yared_${id}`,
      ageRange: '18_24',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  const userId = res.body.user.id as string;
  await http()
    .put('/v1/me/games')
    .set(auth)
    .send({ games: [{ gameId: 'pubg' }] })
    .expect(200);
  await http().post('/v1/me/onboard').set(auth).expect(204);
  await conn.db.update(users).set({ emailVerifiedAt: new Date() }).where(eq(users.id, userId));
  const listing = await http()
    .post('/v1/listings')
    .set(auth)
    .send({
      gameId: 'pubg',
      platform: 'mobile',
      partySize: 2,
      voice: 'optional',
      style: 'casual',
      playWhen: 'now',
      durationHours: 2,
    })
    .expect(201);
  return {
    userId,
    listingId: listing.body.id as string,
    expiresAt: new Date(listing.body.expiresAt),
  };
}

const status = async (id: string) =>
  (await conn.db.query.listings.findFirst({ where: eq(listings.id, id) }))!.status;
const warnings = (listingId: string) =>
  conn.db
    .select()
    .from(notifications)
    .where(and(eq(notifications.listingId, listingId), eq(notifications.type, 'listing_expiring')));

describe('listing expiry job', () => {
  it('leaves listings with time left alone', async () => {
    const l = await postedListing();
    await jobs.runOnce('listing-expiry', new Date(l.expiresAt.getTime() - 30 * MIN));
    expect(await status(l.listingId)).toBe('open');
    expect(await warnings(l.listingId)).toHaveLength(0);
  });

  it('warns the owner once, 15 minutes before the end', async () => {
    const l = await postedListing();
    const at = new Date(l.expiresAt.getTime() - 14 * MIN);
    await jobs.runOnce('listing-expiry', at);
    await jobs.runOnce('listing-expiry', new Date(at.getTime() + MIN));
    const sent = await warnings(l.listingId);
    expect(sent).toHaveLength(1);
    expect(sent[0]!.userId).toBe(l.userId);
    expect(await status(l.listingId)).toBe('open');
  });

  it('expires the listing and its pending requests when time runs out', async () => {
    const l = await postedListing();
    const other = await postedListing();
    const [req] = await conn.db
      .insert(connectionRequests)
      .values({ fromUserId: other.userId, toUserId: l.userId, listingId: l.listingId })
      .returning();
    await jobs.runOnce('listing-expiry', l.expiresAt);
    expect(await status(l.listingId)).toBe('expired');
    const after = await conn.db.query.connectionRequests.findFirst({
      where: eq(connectionRequests.id, req!.id),
    });
    expect(after).toMatchObject({ status: 'expired' });
    expect(after!.respondedAt).not.toBeNull();
  });

  it('never reopens or touches closed listings', async () => {
    const l = await postedListing();
    await conn.db.update(listings).set({ status: 'closed' }).where(eq(listings.id, l.listingId));
    await jobs.runOnce('listing-expiry', new Date(l.expiresAt.getTime() + MIN));
    expect(await status(l.listingId)).toBe('closed');
  });

  it("skips a run while another instance holds the job's lock", async () => {
    const blocker = createDb(TEST_DATABASE_URL);
    let release!: () => void;
    const held = new Promise<void>((r) => (release = r));
    let locked!: () => void;
    const isLocked = new Promise<void>((r) => (locked = r));
    const holder = blocker.db.transaction(async (tx) => {
      await tx.execute(`select pg_advisory_xact_lock(${lockKey('listing-expiry')})`);
      locked();
      await held;
    });
    await isLocked;
    expect(await jobs.runOnce('listing-expiry')).toBe(false);
    release();
    await holder;
    await blocker.client.end();
    expect(await jobs.runOnce('listing-expiry')).toBe(true);
  });
});
