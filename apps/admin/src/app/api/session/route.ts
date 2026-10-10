import { cookies } from 'next/headers';
import { apiUrl, cookieOptions, errorBody, SESSION_COOKIE } from '@/server/session';

/** Sign in: POST /v1/auth/login, and only admins get the cookie. */
export async function POST(req: Request) {
  const { email, password } = (await req.json().catch(() => ({}))) as Record<string, unknown>;
  const res = await fetch(`${apiUrl()}/v1/auth/login`, {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'user-agent': 'gamer-network-admin' },
    body: JSON.stringify({ email, password }),
  });
  const body = await res.json();
  if (!res.ok) return Response.json(body, { status: res.status });

  if (body.user?.role !== 'admin') {
    // Don't leave a session behind for someone who can't use it here.
    await fetch(`${apiUrl()}/v1/auth/logout`, {
      method: 'POST',
      headers: { authorization: `Bearer ${body.token}` },
    });
    return Response.json(errorBody('admin_only', 'This account is not an admin.'), {
      status: 403,
    });
  }

  (await cookies()).set(SESSION_COOKIE, body.token, cookieOptions);
  return Response.json({ displayName: body.user.displayName });
}

/** Sign out: revoke the API session and drop the cookie. */
export async function DELETE() {
  const jar = await cookies();
  const token = jar.get(SESSION_COOKIE)?.value;
  if (token) {
    await fetch(`${apiUrl()}/v1/auth/logout`, {
      method: 'POST',
      headers: { authorization: `Bearer ${token}` },
    }).catch(() => undefined);
  }
  jar.delete(SESSION_COOKIE);
  return new Response(null, { status: 204 });
}
