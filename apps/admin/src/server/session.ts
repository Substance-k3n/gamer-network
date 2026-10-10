// Server-only: the admin's API token lives in an httpOnly cookie, so
// page scripts never see it. /api/v1/* adds it to calls to the API.
export const SESSION_COOKIE = 'gn_admin';

export const apiUrl = () => (process.env.API_URL ?? 'http://localhost:3300').replace(/\/+$/, '');

export const cookieOptions = {
  httpOnly: true,
  sameSite: 'strict' as const,
  secure: process.env.NODE_ENV === 'production',
  path: '/',
  // The API session outlives this; a 401 sends the admin back to /login.
  maxAge: 30 * 24 * 3600,
};

export const errorBody = (code: string, message: string) => ({ error: { code, message } });
