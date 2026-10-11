import type { NextFunction, Request, Response } from 'express';
import { env } from '../env.js';

/** "1.4.0" → [1, 4, 0]; anything unparsable counts as 0. */
export function parseVersion(v: string): number[] {
  return v.split('.').map((p) => Number.parseInt(p, 10) || 0);
}

export function isOlder(version: string, than: string): boolean {
  const a = parseVersion(version);
  const b = parseVersion(than);
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const d = (a[i] ?? 0) - (b[i] ?? 0);
    if (d !== 0) return d < 0;
  }
  return false;
}

/**
 * Apps send X-App-Version. Below MIN_APP_VERSION every call except
 * /v1/app/config answers 426, so the app shows "Update to keep playing".
 * Requests without the header (the web site, curl) pass.
 */
export function appVersionGate(req: Request, res: Response, next: NextFunction) {
  const version = req.header('x-app-version');
  if (version && !req.path.endsWith('/app/config') && isOlder(version, env.minAppVersion)) {
    res.status(426).json({
      error: { code: 'update_required', message: 'Update the app to keep playing.' },
    });
    return;
  }
  next();
}
