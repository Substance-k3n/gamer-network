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
  'post_gg',
  'post_comment',
  'comment_reply',
  'mention',
  'recruit_application',
  'recruit_accepted',
  'group_join_request',
  'group_join_approved',
  'group_event',
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
  'remove_post',
  'remove_comment',
  'remove_group',
  'create_game',
  'update_game',
  'delete_game',
  'create_rank',
  'update_rank',
  'delete_rank',
  'create_user',
  'update_user',
  'delete_user',
]);
// docs/FEED_AND_GROUPS_API.md "Data model".
export const postType = pgEnum('post_type', [
  'discussion',
  'gameplay',
  'recruitment',
  'poll',
  'milestone',
  'question',
  'looking_for_players',
  'tip_guide',
  'review',
  'event',
  'meme',
]);
export const postAudience = pgEnum('post_audience', ['everyone', 'connections']);
/** deleted: by its author (a group: its last member left). removed: by an admin or a group admin. */
export const contentStatus = pgEnum('content_status', ['live', 'deleted', 'removed']);
/** Only images can be uploaded for now; video waits (ADR-0012). */
export const mediaKind = pgEnum('media_kind', ['image', 'video']);
export const applicationStatus = pgEnum('application_status', ['pending', 'accepted', 'declined']);
export const groupKind = pgEnum('group_kind', ['game', 'city', 'campus', 'squad']);
/** The prototype's badge colours. */
export const groupTone = pgEnum('group_tone', ['accent', 'lav', 'soft', 'grey']);
/** Declared admin first, so ordering by role lists admins first. */
export const groupRole = pgEnum('group_role', ['admin', 'member']);
export const membershipStatus = pgEnum('membership_status', ['member', 'pending']);
