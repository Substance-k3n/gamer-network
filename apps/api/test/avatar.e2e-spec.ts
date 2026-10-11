import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types.js';
import { createTestApp, uniq } from './app.js';

// docs/API.md "Images": presigned upload straight to storage, then PUT the key.
// Runs against the real S3-compatible server from infra/docker/dev.

let app: INestApplication<App>;

beforeAll(async () => ({ app } = await createTestApp()));
afterAll(() => app.close());

const http = () => request(app.getHttpServer());

// The smallest valid PNG: 1×1, transparent.
const PNG = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
  'base64',
);

async function signup() {
  const id = uniq();
  const res = await http()
    .post('/v1/auth/signup')
    .send({
      email: `av_${id}@example.com`,
      password: 'correct horse battery',
      displayName: 'Abel',
      username: `abel_${id}`,
      ageRange: '25_34',
    })
    .expect(201);
  const auth = { Authorization: `Bearer ${res.body.token}` };
  return {
    uploadUrl: (body: object) => http().post('/v1/me/avatar/upload-url').set(auth).send(body),
    setAvatar: (key: string) => http().put('/v1/me/avatar').set(auth).send({ key }),
    removeAvatar: () => http().delete('/v1/me/avatar').set(auth),
  };
}

/** Uploads `body` the way the app does. The HTTP client sets Content-Length from the body. */
async function upload(
  target: { uploadUrl: string; headers: Record<string, string> },
  body: Buffer,
  contentType = target.headers['Content-Type']!,
) {
  return fetch(target.uploadUrl, {
    method: 'PUT',
    headers: { 'Content-Type': contentType },
    body: new Uint8Array(body),
  });
}

describe('avatar', () => {
  it('uploads, becomes the public avatarUrl, and replaces the old one', async () => {
    const p = await signup();
    const first = (await p.uploadUrl({ contentType: 'image/png', size: PNG.length }).expect(200))
      .body;
    expect(first.key).toMatch(/^avatars\/[0-9a-f-]+\/[0-9a-f-]+\.png$/);
    expect((await upload(first, PNG)).ok).toBe(true);

    const me = (await p.setAvatar(first.key).expect(200)).body;
    expect(me.avatarUrl).toMatch(new RegExp(`/${first.key}$`));
    const served = await fetch(me.avatarUrl);
    expect(served.status).toBe(200);
    expect(Buffer.from(await served.arrayBuffer())).toEqual(PNG);

    const second = (await p.uploadUrl({ contentType: 'image/png', size: PNG.length })).body;
    await upload(second, PNG);
    await p.setAvatar(second.key).expect(200);
    expect((await fetch(me.avatarUrl)).status).not.toBe(200);
  });

  it('refuses an upload that differs from what was signed', async () => {
    const p = await signup();
    const small = (await p.uploadUrl({ contentType: 'image/png', size: 10 })).body;
    expect((await upload(small, PNG)).ok).toBe(false);
    const png = (await p.uploadUrl({ contentType: 'image/png', size: PNG.length })).body;
    expect((await upload(png, PNG, 'image/jpeg')).ok).toBe(false);
  });

  it("refuses keys that aren't yours or weren't uploaded", async () => {
    const a = await signup();
    const b = await signup();
    const target = (await a.uploadUrl({ contentType: 'image/png', size: PNG.length })).body;
    await upload(target, PNG);
    expect((await b.setAvatar(target.key).expect(422)).body.error.fields.key).toBe(
      'Not one of your uploads',
    );
    const unused = (await a.uploadUrl({ contentType: 'image/png', size: PNG.length })).body;
    expect((await a.setAvatar(unused.key).expect(422)).body.error.fields.key).toBe(
      'Nothing was uploaded there yet',
    );
  });

  it('accepts only small JPEG, PNG and WebP images', async () => {
    const p = await signup();
    await p.uploadUrl({ contentType: 'image/gif', size: 100 }).expect(422);
    await p.uploadUrl({ contentType: 'image/png', size: 3 * 1024 * 1024 }).expect(422);
  });

  it('can be removed', async () => {
    const p = await signup();
    const target = (await p.uploadUrl({ contentType: 'image/png', size: PNG.length })).body;
    await upload(target, PNG);
    const url = (await p.setAvatar(target.key)).body.avatarUrl;
    expect((await p.removeAvatar().expect(200)).body.avatarUrl).toBeNull();
    expect((await fetch(url)).status).not.toBe(200);
  });
});
