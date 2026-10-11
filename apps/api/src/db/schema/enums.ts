import { pgEnum } from 'drizzle-orm/pg-core';

// Values and meaning: docs/DATA_MODEL.md "Enums".
export const ageRange = pgEnum('age_range', ['16_17', '18_24', '25_34', '35_plus']);
export const userRole = pgEnum('user_role', ['player', 'admin']);
export const playerStatus = pgEnum('player_status', [
  'looking',
  'playing',
  'available_tonight',
  'not_available',
]);
export const platform = pgEnum('platform', ['pc', 'playstation', 'xbox', 'mobile', 'switch']);
export const playTag = pgEnum('play_tag', [
  'competitive',
  'casual',
  'fps',
  'rpg',
  'strategy',
  'co_op',
  'ranked',
  'achievement_hunter',
  'story',
]);
export const gamingIdKind = pgEnum('gaming_id_kind', [
  'riot',
  'steam',
  'discord',
  'playstation',
  'xbox',
  'epic',
  'ea',
  'activision',
  'in_game',
]);
export const idVisibility = pgEnum('id_visibility', ['public', 'connections']);
export const voice = pgEnum('voice', ['required', 'optional']);
export const playStyle = pgEnum('play_style', ['competitive', 'casual']);
export const playWhen = pgEnum('play_when', ['now', 'tonight', 'weekend']);
export const listingStatus = pgEnum('listing_status', [
  'open',
  'full',
  'closed',
  'expired',
  'removed',
]);
export const requestStatus = pgEnum('request_status', [
  'pending',
  'accepted',
  'declined',
  'cancelled',
  'expired',
]);
export const inviteStatus = pgEnum('invite_status', ['pending', 'accepted', 'declined', 'expired']);
export const inviteWhen = pgEnum('invite_when', ['now', 'in_30_min', 'tonight']);
export const checkInAnswer = pgEnum('check_in_answer', ['played', 'not_yet', 'no']);
export const emailCodePurpose = pgEnum('email_code_purpose', ['verify_email', 'reset_password']);
export const notificationType = pgEnum('notification_type', [
  'connection_request',
  'connection_accepted',
  'play_invite',
  'play_invite_accepted',
  'check_in_due',
  'listing_expiring',
  'report_resolved',
]);
export const reportReason = pgEnum('report_reason', [
  'harassment',
  'hate',
  'sexual_content',
  'underage',
  'spam',
  'impersonation',
  'cheating_or_scam',
  'other',
]);
export const reportStatus = pgEnum('report_status', ['open', 'actioned', 'dismissed']);
export const adminActionKind = pgEnum('admin_action_kind', [
  'ban',
  'unban',
  'remove_listing',
  'dismiss_report',
  'warn',
  'set_launch',
]);
