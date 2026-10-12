import { BrevoMailer, parseAddress } from './mailer.js';

describe('parseAddress', () => {
  it.each([
    ['gamer-network <you@gmail.com>', { name: 'gamer-network', email: 'you@gmail.com' }],
    ['<you@gmail.com>', { email: 'you@gmail.com' }],
    [' you@gmail.com ', { email: 'you@gmail.com' }],
  ])('%s', (address, expected) => {
    expect(parseAddress(address)).toEqual(expected);
  });
});

describe('BrevoMailer', () => {
  afterEach(() => vi.unstubAllGlobals());

  it('sends a text email through the Brevo API', async () => {
    const fetch = vi.fn().mockResolvedValue(new Response('{}', { status: 201 }));
    vi.stubGlobal('fetch', fetch);
    await new BrevoMailer('key', 'gamer-network <you@gmail.com>').send({
      to: 'abel@example.com',
      subject: '123456 is your code',
      text: 'Hi',
    });
    const [url, init] = fetch.mock.calls[0]!;
    expect(url).toBe('https://api.brevo.com/v3/smtp/email');
    expect(init.headers['api-key']).toBe('key');
    expect(JSON.parse(init.body)).toEqual({
      sender: { name: 'gamer-network', email: 'you@gmail.com' },
      to: [{ email: 'abel@example.com' }],
      subject: '123456 is your code',
      textContent: 'Hi',
    });
  });

  it('fails when Brevo refuses', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue(new Response('bad sender', { status: 400 })));
    await expect(
      new BrevoMailer('key', 'you@gmail.com').send({ to: 'a@b.c', subject: 's', text: 't' }),
    ).rejects.toThrow('Brevo answered 400: bad sender');
  });
});
