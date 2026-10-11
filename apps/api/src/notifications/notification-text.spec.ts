import { type NotificationFacts, notificationText } from './notification-text.js';

const facts = (over: Partial<NotificationFacts>): NotificationFacts => ({
  type: 'connection_request',
  actorName: 'Hana',
  actorUsername: 'hana',
  gameName: 'PUBG Mobile',
  listingId: null,
  checkInId: null,
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
});
