import { config } from './config';
import type { components } from './api.gen';

export type PublicListing = components['schemas']['PublicListingDto'];

/**
 * GET /v1/public/listings/{id}. Null when it doesn't exist or isn't
 * public (removed, owner banned or deleted). Not cached: the status and
 * the free slots change by the minute.
 */
export async function getPublicListing(id: string): Promise<PublicListing | null> {
  if (!/^[0-9a-f-]{36}$/i.test(id)) return null;
  const res = await fetch(`${config.apiUrl}/v1/public/listings/${id}`, {
    cache: 'no-store',
    headers: { accept: 'application/json' },
  });
  if (res.status === 404) return null;
  if (!res.ok) throw new Error(`public listing ${id}: ${res.status}`);
  return res.json() as Promise<PublicListing>;
}
