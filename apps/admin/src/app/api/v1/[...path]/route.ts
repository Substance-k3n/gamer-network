import { cookies } from 'next/headers';
import { apiUrl, errorBody, SESSION_COOKIE } from '@/server/session';

// Only what the dashboard uses; everything else stays unreachable from here.
const ALLOWED = [/^admin\//, /^games$/, /^me$/];

type Ctx = { params: Promise<{ path: string[] }> };

async function proxy(req: Request, { params }: Ctx) {
  const path = (await params).path.join('/');
  if (!ALLOWED.some((re) => re.test(path))) {
    return Response.json(errorBody('not_found', "That doesn't exist."), { status: 404 });
  }
  const token = (await cookies()).get(SESSION_COOKIE)?.value;
  if (!token) {
    return Response.json(errorBody('unauthenticated', 'Sign in to continue.'), { status: 401 });
  }

  const search = new URL(req.url).search;
  const res = await fetch(`${apiUrl()}/v1/${path}${search}`, {
    method: req.method,
    headers: {
      authorization: `Bearer ${token}`,
      ...(req.method === 'GET' ? {} : { 'content-type': 'application/json' }),
    },
    body: req.method === 'GET' ? undefined : await req.text(),
    cache: 'no-store',
  });
  if (res.status === 204) return new Response(null, { status: 204 });
  return new Response(await res.text(), {
    status: res.status,
    headers: { 'content-type': res.headers.get('content-type') ?? 'application/json' },
  });
}

export { proxy as GET, proxy as PATCH, proxy as POST };
