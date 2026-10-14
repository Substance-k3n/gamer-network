import { cookies } from 'next/headers';
import { config } from '@/lib/config';
import { cookieOptions, errorBody, SESSION_COOKIE } from '@/lib/session';

// The PWA's door to the API (ADR-0011): same origin, so no CORS, and the
// token stays in an httpOnly cookie. Sign-in answers have their token
// swapped for the cookie; everything else passes through unchanged.

/** Answers that carry a token: `{ token, user, isNew? }`. */
const SIGN_IN = new Set(['auth/login', 'auth/signup', 'auth/google', 'auth/password/reset']);

type Ctx = { params: Promise<{ path: string[] }> };

async function proxy(req: Request, { params }: Ctx) {
  const path = (await params).path.join('/');
  if (path.startsWith('admin/') || path.includes('..')) {
    return Response.json(errorBody('not_found', "That doesn't exist."), { status: 404 });
  }
  const jar = await cookies();
  const token = jar.get(SESSION_COOKIE)?.value;

  const headers: Record<string, string> = { accept: 'application/json' };
  if (token) headers.authorization = `Bearer ${token}`;
  // The API names sessions after the device; sign-in requires it.
  headers['user-agent'] = req.headers.get('user-agent') ?? 'rally-web';
  const idem = req.headers.get('idempotency-key');
  if (idem) headers['idempotency-key'] = idem;
  const hasBody = req.method !== 'GET' && req.method !== 'HEAD';
  const body = hasBody ? await req.text() : undefined;
  if (body) headers['content-type'] = 'application/json';

  let res: Response;
  try {
    res = await fetch(`${config.apiUrl}/v1/${path}${new URL(req.url).search}`, {
      method: req.method,
      headers,
      body: body || undefined,
      cache: 'no-store',
    });
  } catch {
    return Response.json(errorBody('network', 'Can’t reach rally right now. Try again.'), {
      status: 502,
    });
  }

  const signedOut =
    (path === 'auth/logout' && req.method === 'POST') ||
    (path === 'me' && req.method === 'DELETE' && res.ok) ||
    (res.status === 401 && token !== undefined);
  if (signedOut) jar.delete(SESSION_COOKIE);

  if (res.status === 204) return new Response(null, { status: 204 });
  const text = await res.text();

  if (SIGN_IN.has(path) && res.ok) {
    const { token: fresh, ...rest } = JSON.parse(text) as { token: string };
    jar.set(SESSION_COOKIE, fresh, cookieOptions);
    return Response.json(rest, { status: res.status });
  }
  return new Response(text, {
    status: res.status,
    headers: { 'content-type': res.headers.get('content-type') ?? 'application/json' },
  });
}

export { proxy as DELETE, proxy as GET, proxy as PATCH, proxy as POST, proxy as PUT };
