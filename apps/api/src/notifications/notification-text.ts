import type { notificationType } from '../db/schema/index.js';

const ADDIS_OFFSET_MS = 3 * 3600_000;
const DAY_MS = 24 * 3600_000;
const WEEKDAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** "tonight 21:00", "today 14:00", "tomorrow 18:30" or "Sat 25 Oct 21:00", in Addis time. */
export function eventWhen(startsAt: Date, now: Date): string {
  const local = new Date(startsAt.getTime() + ADDIS_OFFSET_MS);
  const time = local.toISOString().slice(11, 16);
  const day = (d: Date) => Math.floor((d.getTime() + ADDIS_OFFSET_MS) / DAY_MS);
  const days = day(startsAt) - day(now);
  if (days === 0) return `${local.getUTCHours() >= 18 ? 'tonight' : 'today'} ${time}`;
  if (days === 1) return `tomorrow ${time}`;
  const date = `${WEEKDAYS[local.getUTCDay()]} ${local.getUTCDate()} ${MONTHS[local.getUTCMonth()]}`;
  return `${date} ${time}`;
}

export type NotificationType = (typeof notificationType.enumValues)[number];

export interface NotificationFacts {
  type: NotificationType;
  /** Display name and username of who caused it (or who to check in about). */
  actorName: string | null;
  actorUsername: string | null;
  /** The game of the listing or play invite it is about. */
  gameName: string | null;
  listingId: string | null;
  checkInId: string | null;
  postId: string | null;
  commentId: string | null;
  /** post_gg: how many more people GG'd while it was unread. */
  others: number;
  groupId: string | null;
  groupName: string | null;
  /** group_event: the event's title and start. */
  eventTitle: string | null;
  eventStartsAt: Date | null;
}

export interface NotificationText {
  /** Push title. */
  title: string;
  /** Ready to show in Alerts and as the push body. */
  text: string;
  /** In-app path to open on tap. */
  route: string;
}

/** The words and the tap target for each notification type. One place, so Alerts and push agree. */
export function notificationText(n: NotificationFacts, now = new Date()): NotificationText {
  const who = n.actorName ?? 'Someone';
  const group = n.groupName ?? 'a group';
  const groupPage = n.groupId ? `/groups/${n.groupId}` : '/alerts';
  const game = n.gameName ?? 'a game';
  const post = n.postId ? `/posts/${n.postId}` : '/alerts';
  const profile = n.actorUsername ? `/players/${n.actorUsername}` : '/alerts';
  switch (n.type) {
    case 'connection_request':
      return {
        title: 'Connection request',
        text: n.listingId ? `${who} wants to play ${game} with you` : `${who} wants to connect`,
        route: '/alerts',
      };
    case 'connection_accepted':
      return { title: 'Connected', text: `${who} accepted your request`, route: profile };
    case 'play_invite':
      return { title: 'Play invite', text: `${who} invited you to play ${game}`, route: '/alerts' };
    case 'play_invite_accepted':
      return { title: "They're in", text: `${who} is ready to play ${game}`, route: profile };
    case 'check_in_due':
      return {
        title: 'Quick check-in',
        text: `Did you play with ${who}?`,
        route: n.checkInId ? `/check-ins/${n.checkInId}` : '/alerts',
      };
    case 'listing_expiring':
      return {
        title: 'Listing ending soon',
        text: `Your ${game} listing ends in 15 minutes`,
        route: n.listingId ? `/listings/${n.listingId}` : '/alerts',
      };
    case 'report_resolved':
      return {
        title: 'Report reviewed',
        text: 'We reviewed your report. Thanks for keeping it safe.',
        route: '/alerts',
      };
    case 'post_gg': {
      const more = n.others === 0 ? '' : ` and ${n.others} ${n.others === 1 ? 'other' : 'others'}`;
      return { title: 'GG', text: `${who}${more} reacted GG to your post`, route: post };
    }
    case 'post_comment':
      return {
        title: 'New comment',
        text: `${who} commented on your post`,
        route: n.postId ? `${post}?comments=1` : post,
      };
    case 'comment_reply':
      return {
        title: 'New reply',
        text: `${who} replied to your comment`,
        route: n.postId ? `${post}?comments=1` : post,
      };
    case 'mention':
      return {
        title: 'Mention',
        text: `${who} mentioned you in ${n.commentId ? 'a comment' : 'a post'}`,
        route: n.commentId && n.postId ? `${post}?comments=1` : post,
      };
    case 'recruit_application':
      return {
        title: 'New applicant',
        text: `${who} applied to your recruitment post`,
        route: n.postId ? `${post}/applications` : post,
      };
    case 'recruit_accepted':
      return { title: "You're in", text: `${who} accepted your application`, route: profile };
    case 'group_join_request':
      return {
        title: 'Join request',
        text: `${who} wants to join ${group}`,
        route: n.groupId ? `${groupPage}/members?status=pending` : groupPage,
      };
    case 'group_join_approved':
      return { title: 'Request approved', text: `You're in ${group}`, route: groupPage };
    case 'group_event': {
      const when = n.eventStartsAt ? `, ${eventWhen(n.eventStartsAt, now)}` : '';
      return {
        title: 'New event',
        text: `New event in ${group}: ${n.eventTitle ?? 'an event'}${when}`,
        route: groupPage,
      };
    }
  }
}
