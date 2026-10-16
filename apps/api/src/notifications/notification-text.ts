import type { notificationType } from '../db/schema/index.js';

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
export function notificationText(n: NotificationFacts): NotificationText {
  const who = n.actorName ?? 'Someone';
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
  }
}
