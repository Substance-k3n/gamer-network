'use client';

import type { components } from './api.gen';

type S = components['schemas'];
export type AdminUser = S['AdminUserDto'];
export type AdminReport = S['AdminReportDto'];
export type Metrics = S['MetricsDto'];
export type Game = S['GameDto'];
export type ResolveAction = S['ResolveAction'];
export type AccountState = S['AccountState'];
export type ReportReason = S['ReportReason'];
export type Page<T> = { items: T[]; nextCursor: string | null };

/** The API's error shape (docs/API.md "Errors"): branch on `code`, show `message`. */
export class ApiError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
  ) {
    super(message);
  }
}

/**
 * Calls the API through this app's /api/v1 proxy, which adds the
 * admin's token from the cookie. A lost or non-admin session goes back
 * to /login.
 */
export async function api<T>(path: string, init?: { method?: string; body?: unknown }): Promise<T> {
  const res = await fetch(`/api/v1/${path}`, {
    method: init?.method ?? 'GET',
    headers: init?.body === undefined ? undefined : { 'content-type': 'application/json' },
    body: init?.body === undefined ? undefined : JSON.stringify(init.body),
  });
  if (res.status === 204) return undefined as T;
  const body = await res.json().catch(() => null);
  if (res.ok) return body as T;

  const code: string = body?.error?.code ?? 'error';
  if (res.status === 401 || code === 'admin_only' || code === 'banned') {
    window.location.href = '/login';
  }
  throw new ApiError(res.status, code, body?.error?.message ?? 'Something went wrong. Try again.');
}

export const query = (params: Record<string, string | number | undefined | null>) => {
  const q = new URLSearchParams();
  for (const [k, v] of Object.entries(params))
    if (v !== undefined && v !== null && v !== '') q.set(k, String(v));
  const s = q.toString();
  return s ? `?${s}` : '';
};
