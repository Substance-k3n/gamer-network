import type { AccountState, AdminReport, AdminUser, ReportReason } from './api';

export type Screen = 'overview' | 'reports' | 'users' | 'games';
export type Severity = 'HIGH' | 'MED' | 'LOW';

export const RANGES = { '7D': 7, '30D': 30, '90D': 90 } as const;
export type Range = keyof typeof RANGES;

export const REASON: Record<ReportReason, string> = {
  harassment: 'Harassment',
  hate: 'Hate',
  sexual_content: 'Sexual content',
  underage: 'Underage',
  spam: 'Spam',
  impersonation: 'Impersonation',
  cheating_or_scam: 'Cheating or scam',
  other: 'Other',
};

/** The API has no severity; it follows from the reason (people's safety first). */
const SEVERITY: Record<ReportReason, Severity> = {
  harassment: 'HIGH',
  hate: 'HIGH',
  sexual_content: 'HIGH',
  underage: 'HIGH',
  impersonation: 'MED',
  cheating_or_scam: 'MED',
  spam: 'LOW',
  other: 'LOW',
};
export const severity = (r: AdminReport): Severity => SEVERITY[r.reason];
export const SEV_ORDER: Record<Severity, number> = { HIGH: 0, MED: 1, LOW: 2 };

export const STATE_LABEL: Record<AccountState, string> = {
  active: 'Active',
  banned: 'Banned',
  deleted: 'Deleted',
};

export const PLATFORM: Record<string, string> = {
  pc: 'PC',
  playstation: 'PlayStation',
  xbox: 'Xbox',
  mobile: 'Mobile',
  switch: 'Switch',
};

const DAY = 86_400_000;

/** "Oct 02". */
export const shortDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', { month: 'short', day: '2-digit' });

/** "now", "5m", "3h", "2d". */
export function age(iso: string, now = Date.now()) {
  const ms = Math.max(0, now - new Date(iso).getTime());
  if (ms < 60_000) return 'now';
  if (ms < 3_600_000) return `${Math.floor(ms / 60_000)}m`;
  if (ms < DAY) return `${Math.floor(ms / 3_600_000)}h`;
  return `${Math.floor(ms / DAY)}d`;
}

/** "just now", "3h ago". */
export function ago(iso: string) {
  const a = age(iso);
  return a === 'now' ? 'just now' : `${a} ago`;
}

export const lastSeen = (u: AdminUser) => (u.lastSeenAt ? ago(u.lastSeenAt) : 'never');
