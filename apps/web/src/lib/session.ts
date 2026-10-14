// Server-only: the player's API token lives in an httpOnly cookie, so page
// scripts never see it (ADR-0011). /api/v1/* adds it to calls to the API.
export const SESSION_COOKIE = 'gn_session';

export const cookieOptions = {
  httpOnly: true,
  sameSite: 'lax' as const,
  secure: process.env.NODE_ENV === 'production',
  path: '/',
  // API sessions last 90 days, extended by use; a 401 clears this early.
  maxAge: 90 * 24 * 3600,
};

export const errorBody = (code: string, message: string) => ({ error: { code, message } });
