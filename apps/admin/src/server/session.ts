// Server-only: the admin's API token lives in an httpOnly cookie, so
// page scripts never see it. /api/v1/* adds it to calls to the API.
export const SESSION_COOKIE = 'gn_admin';

// Render's private network gives "host:port" with no scheme.
export const apiUrl = () => {
  const url = (process.env.API_URL ?? 'http://localhost:3300').replace(/\/+$/, '');
  return /^https?:\/\//.test(url) ? url : `http://${url}`;
};

export const cookieOptions = {
  httpOnly: true,
  sameSite: 'strict' as const,
  secure: process.env.NODE_ENV === 'production',
  path: '/',
  // The API session outlives this; a 401 sends the admin back to /login.
  maxAge: 30 * 24 * 3600,
};

export const errorBody = (code: string, message: string) => ({ error: { code, message } });
