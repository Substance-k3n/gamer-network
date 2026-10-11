import { INestApplication } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createDb } from '../src/db/db.js';
import { users } from '../src/db/schema/index.js';
import { createTestApp, MemoryMailer, uniq } from './app.js';
import { TEST_DATABASE_URL } from './test-db.js';

// ADR-0007 and docs/DATA_MODEL.md "Passwords and accounts".

let app: INestApplication<App>;
let mailer: MemoryMailer;
const conn = createDb(TEST_DATABASE_URL);

beforeAll(async () => ({ app, mailer } = await createTestApp()));
afterAll(async () => {
  await app.close();
  await conn.client.end();
});

const http = () => request(app.getHttpServer());

function newPlayer() {
  const id = uniq();
  return {
    email: `p_${id}@example.com`,
    password: 'correct horse battery',
    displayName: 'Kaleb',
    username: `kaleb_${id}`,
    ageRange: '18_24',
  };
}

async function signup(p = newPlayer()) {
  const res = await http().post('/v1/auth/signup').send(p).expect(201);
  return { ...p, token: res.body.token as string, body: res.body };
}

const me = (token: string) => http().get('/v1/me').set('Authorization', `Bearer ${token}`);

describe('sign up', () => {
  it('creates the account, signs in and emails a verification code', async () => {
    const p = await signup();
    expect(p.body.isNew).toBe(true);
    expect(p.body.user).toMatchObject({
      email: p.email,
      username: p.username,
      emailVerified: false,
      hasPassword: true,
      onboardedAt: null,
    });
    expect(mailer.lastCode(p.email)).toMatch(/^\d{6}$/);
    await me(p.token).expect(200);
  });

  it('stores emails and usernames lowercase', async () => {
    const p = newPlayer();
    const res = await http()
      .post('/v1/auth/signup')
      .send({ ...p, email: p.email.toUpperCase(), username: p.username.toUpperCase() })
      .expect(201);
    expect(res.body.user.email).toBe(p.email);
    expect(res.body.user.username).toBe(p.username);
  });

  it('refuses a taken email or username', async () => {
    const p = await signup();
    const again = await http()
      .post('/v1/auth/signup')
      .send({ ...newPlayer(), email: p.email })
      .expect(409);
    expect(again.body.error.code).toBe('email_taken');
    const taken = await http()
      .post('/v1/auth/signup')
      .send({ ...newPlayer(), username: p.username })
      .expect(409);
    expect(taken.body.error.code).toBe('username_taken');
  });

  it('explains each bad field', async () => {
    const res = await http()
      .post('/v1/auth/signup')
      .send({ email: 'nope', password: 'short', displayName: '', username: 'a b', ageRange: '12' })
      .expect(422);
    expect(Object.keys(res.body.error.fields).sort()).toEqual([
      'ageRange',
      'displayName',
      'email',
      'password',
      'username',
    ]);
  });
});

describe('log in', () => {
  it('signs in with the right password', async () => {
    const p = await signup();
    const res = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: p.password })
      .expect(200);
    expect(res.body.isNew).toBe(false);
    await me(res.body.token).expect(200);
  });

  it('gives the same answer for a wrong password and an unknown email', async () => {
    const p = await signup();
    const wrong = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: 'wrong password' })
      .expect(401);
    const unknown = await http()
      .post('/v1/auth/login')
      .send({ email: `nobody_${uniq()}@example.com`, password: 'whatever1' })
      .expect(401);
    expect(wrong.body).toEqual(unknown.body);
    expect(wrong.body.error.code).toBe('wrong_credentials');
  });

  it('locks the email after 10 wrong passwords', async () => {
    const p = await signup();
    for (let i = 0; i < 10; i++) {
      await http()
        .post('/v1/auth/login')
        .send({ email: p.email, password: 'wrong password' })
        .expect(401);
    }
    const locked = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: p.password })
      .expect(429);
    expect(locked.body.error.code).toBe('rate_limited');
  });

  it('refuses banned accounts', async () => {
    const p = await signup();
    await conn.db.update(users).set({ bannedAt: new Date() }).where(eq(users.email, p.email));
    const res = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: p.password })
      .expect(403);
    expect(res.body.error.code).toBe('banned');
    await me(p.token).expect(403);
  });
});

describe('sessions', () => {
  it('needs a valid bearer token', async () => {
    const none = await http().get('/v1/me').expect(401);
    expect(none.body.error.code).toBe('unauthenticated');
    await me('not-a-real-token').expect(401);
  });

  it('logs out only this device', async () => {
    const p = await signup();
    const other = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: p.password });
    await http().post('/v1/auth/logout').set('Authorization', `Bearer ${p.token}`).expect(204);
    await me(p.token).expect(401);
    await me(other.body.token).expect(200);
  });
});

describe('verify email', () => {
  it('refuses a wrong code and accepts the right one', async () => {
    const p = await signup();
    const auth = { Authorization: `Bearer ${p.token}` };
    const code = mailer.lastCode(p.email);
    const wrong = code === '000000' ? '111111' : '000000';
    const bad = await http()
      .post('/v1/auth/verify-email')
      .set(auth)
      .send({ code: wrong })
      .expect(422);
    expect(bad.body.error.code).toBe('invalid_code');
    const ok = await http().post('/v1/auth/verify-email').set(auth).send({ code }).expect(200);
    expect(ok.body.emailVerified).toBe(true);
  });

  it('stops a code working after 5 wrong guesses', async () => {
    const p = await signup();
    const auth = { Authorization: `Bearer ${p.token}` };
    const code = mailer.lastCode(p.email);
    const wrong = code === '000000' ? '111111' : '000000';
    for (let i = 0; i < 5; i++) {
      await http().post('/v1/auth/verify-email').set(auth).send({ code: wrong }).expect(422);
    }
    await http().post('/v1/auth/verify-email').set(auth).send({ code }).expect(422);
  });

  it('sends at most 5 codes an hour', async () => {
    const p = await signup(); // 1st code
    const auth = { Authorization: `Bearer ${p.token}` };
    for (let i = 0; i < 4; i++)
      await http().post('/v1/auth/verify-email/resend').set(auth).expect(204);
    const res = await http().post('/v1/auth/verify-email/resend').set(auth).expect(429);
    expect(res.body.error.code).toBe('rate_limited');
  });
});

describe('forgot and reset password', () => {
  it("doesn't reveal whether an email has an account", async () => {
    const before = mailer.sent.length;
    await http()
      .post('/v1/auth/password/forgot')
      .send({ email: `nobody_${uniq()}@example.com` })
      .expect(204);
    expect(mailer.sent.length).toBe(before);
  });

  it('resets with the code, verifies the email and signs out other devices', async () => {
    const p = await signup();
    await http().post('/v1/auth/password/forgot').send({ email: p.email }).expect(204);
    const res = await http()
      .post('/v1/auth/password/reset')
      .send({ email: p.email, code: mailer.lastCode(p.email), newPassword: 'a brand new one' })
      .expect(200);
    expect(res.body.user.emailVerified).toBe(true);
    await me(p.token).expect(401);
    await me(res.body.token).expect(200);
    await http().post('/v1/auth/login').send({ email: p.email, password: p.password }).expect(401);
    await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: 'a brand new one' })
      .expect(200);
  });

  it("won't take a verify-email code as a reset code", async () => {
    const p = await signup();
    await http()
      .post('/v1/auth/password/reset')
      .send({ email: p.email, code: mailer.lastCode(p.email), newPassword: 'a brand new one' })
      .expect(422);
  });
});

describe('change password', () => {
  it('needs the current password and keeps only this device signed in', async () => {
    const p = await signup();
    const other = await http()
      .post('/v1/auth/login')
      .send({ email: p.email, password: p.password });
    const auth = { Authorization: `Bearer ${p.token}` };
    await http()
      .post('/v1/auth/password')
      .set(auth)
      .send({ currentPassword: 'not it at all', newPassword: 'another good one' })
      .expect(422);
    await http()
      .post('/v1/auth/password')
      .set(auth)
      .send({ currentPassword: p.password, newPassword: 'another good one' })
      .expect(204);
    await me(p.token).expect(200);
    await me(other.body.token).expect(401);
  });
});

describe('Google', () => {
  it('asks a new user for a username and age range, then creates a verified account', async () => {
    const id = uniq();
    const idToken = `google:sub_${id}:g_${id}@gmail.com`;
    const ask = await http().post('/v1/auth/google').send({ idToken }).expect(422);
    expect(ask.body.error.code).toBe('signup_details_required');
    expect(Object.keys(ask.body.error.fields).sort()).toEqual(['ageRange', 'username']);

    const created = await http()
      .post('/v1/auth/google')
      .send({ idToken, username: `g_${id}`, ageRange: '25_34' })
      .expect(200);
    expect(created.body.isNew).toBe(true);
    expect(created.body.user).toMatchObject({
      emailVerified: true,
      hasPassword: false,
      displayName: 'Google Name',
    });

    const again = await http().post('/v1/auth/google').send({ idToken }).expect(200);
    expect(again.body.isNew).toBe(false);
    expect(again.body.user.id).toBe(created.body.user.id);
  });

  it('links to a verified password account and keeps its password', async () => {
    const p = await signup();
    await http()
      .post('/v1/auth/verify-email')
      .set('Authorization', `Bearer ${p.token}`)
      .send({ code: mailer.lastCode(p.email) })
      .expect(200);
    const res = await http()
      .post('/v1/auth/google')
      .send({ idToken: `google:sub_${uniq()}:${p.email}` })
      .expect(200);
    expect(res.body.user.hasPassword).toBe(true);
    await me(p.token).expect(200);
  });

  it('takes over an unverified account: password cleared, its sessions ended', async () => {
    const p = await signup(); // someone signed up with an email they may not own
    const res = await http()
      .post('/v1/auth/google')
      .send({ idToken: `google:sub_${uniq()}:${p.email}` })
      .expect(200);
    expect(res.body.user).toMatchObject({ emailVerified: true, hasPassword: false });
    await me(p.token).expect(401);
    await http().post('/v1/auth/login').send({ email: p.email, password: p.password }).expect(401);
  });

  it('refuses tokens Google did not sign', async () => {
    const res = await http()
      .post('/v1/auth/google')
      .send({ idToken: 'forged-token-1234' })
      .expect(401);
    expect(res.body.error.code).toBe('google_token_invalid');
  });
});

describe('GET /v1/usernames/:name', () => {
  it('says taken, invalid or available', async () => {
    const p = await signup();
    expect(
      (await http().get(`/v1/usernames/${p.username.toUpperCase()}`).expect(200)).body,
    ).toEqual({
      available: false,
      reason: 'taken',
    });
    expect((await http().get('/v1/usernames/a b').expect(200)).body.reason).toBe('invalid');
    expect((await http().get(`/v1/usernames/free_${uniq()}`).expect(200)).body).toEqual({
      available: true,
    });
  });
});
