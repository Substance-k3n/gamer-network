import { type NotificationFacts, notificationText } from './notification-text.js';

const facts = (over: Partial<NotificationFacts>): NotificationFacts => ({
  type: 'connection_request',
  actorName: 'Hana',
  actorUsername: 'hana',
  gameName: 'PUBG Mobile',
  listingId: null,
  checkInId: null,
  postId: null,
  commentId: null,
  others: 0,
  ...over,
});

describe('notificationText', () => {
  it('mentions the game when a request came from a listing', () => {
    expect(notificationText(facts({ listingId: 'l1' })).text).toBe(
      'Hana wants to play PUBG Mobile with you',
    );
    expect(notificationText(facts({})).text).toBe('Hana wants to connect');
  });

  it('opens the profile after an accept, and the check-in when one is due', () => {
    expect(notificationText(facts({ type: 'connection_accepted' })).route).toBe('/players/hana');
    expect(notificationText(facts({ type: 'check_in_due', checkInId: 'c1' }))).toMatchObject({
      text: 'Did you play with Hana?',
      route: '/check-ins/c1',
    });
  });

  it('copes with a deleted actor', () => {
    const t = notificationText(
      facts({ type: 'connection_accepted', actorName: null, actorUsername: null }),
    );
    expect(t).toMatchObject({ text: 'Someone accepted your request', route: '/alerts' });
  });

  it("counts the others who GG'd, and opens the post", () => {
    expect(notificationText(facts({ type: 'post_gg', postId: 'p1' }))).toMatchObject({
      text: 'Hana reacted GG to your post',
      route: '/posts/p1',
    });
    expect(notificationText(facts({ type: 'post_gg', postId: 'p1', others: 1 })).text).toBe(
      'Hana and 1 other reacted GG to your post',
    );
    expect(notificationText(facts({ type: 'post_gg', postId: 'p1', others: 4 })).text).toBe(
      'Hana and 4 others reacted GG to your post',
    );
  });

  it('opens the comments for comments, replies and mentions in a comment', () => {
    expect(
      notificationText(facts({ type: 'comment_reply', postId: 'p1', commentId: 'c1' })),
    ).toMatchObject({ text: 'Hana replied to your comment', route: '/posts/p1?comments=1' });
    expect(notificationText(facts({ type: 'mention', postId: 'p1' }))).toMatchObject({
      text: 'Hana mentioned you in a post',
      route: '/posts/p1',
    });
  });
});
