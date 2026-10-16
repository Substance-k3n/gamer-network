'use client';

import type { components } from '@/lib/api.gen';

type S = components['schemas'];
export type Me = S['MeDto'];
export type Profile = S['ProfileDto'];
export type UserCard = S['UserCardDto'];
export type UserGame = S['UserGameDto'];
export type GameDto = S['GameDto'];
export type GameRef = S['GameRefDto'];
export type Listing = S['ListingDto'];
export type CheckIn = S['CheckInDto'];
export type PlayInvite = S['PlayInviteDto'];
export type Notification = S['NotificationDto'];
export type ConnectionRequest = S['ConnectionRequestDto'];
export type Connection = S['ConnectionDto'];
export type AppConfig = S['AppConfigResponse'];
export type Platform = S['Platform'];
export type PlayTag = S['PlayTag'];
export type AgeRange = S['AgeRange'];
export type Day = S['Day'];
export type PlayerStatus = S['PlayerStatus'];
export type Relationship = S['Relationship'];
export type GamingIdKind = S['GamingIdKind'];
export type ReportReason = S['ReportReason'];
export type PlayWhen = S['PlayWhen'];
export type InviteWhen = S['InviteWhen'];
export type Post = S['PostDto'];
export type PostType = S['PostType'];
export type PostAudience = S['PostAudience'];
export type FeedFilter = S['FeedFilter'];
export type Comment = S['CommentDto'];
export type Gg = S['GgDto'];
export type Page<T> = { items: T[]; nextCursor: string | null };

/** The API's error shape (docs/API.md "Errors"): branch on `code`, show `message`. */
export class ApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
    readonly fields: Record<string, string> = {},
  ) {
    super(message);
  }

  /** For a form: the first field's problem on validation_failed, else the message. */
  get detail() {
    const first = Object.values(this.fields)[0];
    return this.code === 'validation_failed' && first ? first : this.message;
  }
}

/** Called on any 401 for a signed-in call, so the app can go to log in. */
let onSignedOut: (() => void) | null = null;
export const setSignedOutHandler = (f: () => void) => (onSignedOut = f);

/**
 * Calls the API through this site's /api/v1 proxy, which adds the session
 * from its cookie (ADR-0011). Creates send an Idempotency-Key.
 */
export async function api<T>(
  path: string,
  init?: { method?: string; body?: unknown; key?: string; expect401?: boolean },
): Promise<T> {
  let res: Response;
  try {
    res = await fetch(`/api/v1/${path}`, {
      method: init?.method ?? 'GET',
      headers: {
        ...(init?.body === undefined ? {} : { 'content-type': 'application/json' }),
        ...(init?.key ? { 'idempotency-key': init.key } : {}),
      },
      body: init?.body === undefined ? undefined : JSON.stringify(init.body),
      cache: 'no-store',
    });
  } catch {
    throw new ApiError(
      0,
      'network',
      'Can’t reach rally right now. Check your connection and try again.',
    );
  }
  if (res.status === 204) return undefined as T;
  const body = await res.json().catch(() => null);
  if (res.ok) return body as T;
  const err = body?.error;
  // A 401 means the session ended, except where one is expected (the launch check).
  if (res.status === 401 && err?.code === 'unauthenticated' && !init?.expect401) onSignedOut?.();
  throw new ApiError(
    res.status,
    err?.code ?? 'error',
    err?.message ?? 'Something went wrong. Try again.',
    err?.fields ?? {},
  );
}

export const query = (params: Record<string, string | number | boolean | undefined | null>) => {
  const q = new URLSearchParams();
  for (const [k, v] of Object.entries(params))
    if (v !== undefined && v !== null && v !== '' && v !== false) q.set(k, String(v));
  const s = q.toString();
  return s ? `?${s}` : '';
};

/** A random v4 UUID for Idempotency-Key. */
export const uuid = () => crypto.randomUUID();
