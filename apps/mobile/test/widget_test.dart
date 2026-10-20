import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rally/groups_data.dart';
import 'package:rally/main.dart';
import 'package:rally/shell.dart';
import 'package:rally/state.dart';
import 'package:rally/theme.dart';
import 'package:rally/widgets.dart';

import 'fake_api.dart';

Future<void> loadFonts() async {
  List<String> f(String file, List<String> weights) => [
    for (final w in weights) 'assets/fonts/$file-$w.ttf',
  ];
  final fonts = {
    'Outfit': f('Outfit', [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]),
    'Silkscreen': f('Silkscreen', ['Regular']),
    'DSEG7': ['assets/fonts/DSEG7Classic-Bold.ttf'],
    'Doto': f('Doto', ['Black']),
    'Space Grotesk': f('SpaceGrotesk', [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
    ]),
    'Space Mono': f('SpaceMono', ['Regular', 'Bold']),
    'Plus Jakarta Sans': f('PlusJakartaSans', [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]),
    'Manrope': f('Manrope', [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]),
  };
  for (final e in fonts.entries) {
    final loader = FontLoader(e.key);
    for (final file in e.value) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }
}

/// Starts the app on [server]; with [token] it opens signed in.
Future<AppState> pumpApp(
  WidgetTester t,
  FakeApi server, {
  String? token,
  Size size = const Size(390, 844),
  String? theme,
  void Function(String)? persist,
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(
    RallyApp(
      key: UniqueKey(),
      api: fakeApi(server, token: token),
      themeId: theme,
      persistTheme: persist,
    ),
  );
  await settle(t);
  return t.state<RallyAppState>(find.byType(RallyApp)).state;
}

/// Unmounts the app so its timers stop, and lets toasts drain.
Future<void> done(WidgetTester t) async {
  await t.pumpWidget(const SizedBox());
  await t.pump(const Duration(seconds: 3));
}

/// Taps [text]; with [last], the topmost match (a sheet's chip over a card).
Future<void> tapText(WidgetTester t, String text, {bool last = false}) async {
  final f = last ? find.text(text).last : find.text(text).first;
  // Centre it, so floating bars at the edges don't cover it.
  await Scrollable.ensureVisible(t.element(f), alignment: .5);
  await t.pump(); // lay out the scroll before reading the tap position
  await t.tap(f);
  await settle(t); // let entry animations and calls finish
}

/// Lets calls to the fake API and animations finish. Not pumpAndSettle:
/// countdowns tick every second, so the app never settles.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 8; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

/// The fixture post in the Home feed (fake_api.dart).
const feedText = 'Best co-op game you played this month?';

/// A widget with this semantics label (the feed's icon actions).
Finder labelled(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

Finder icon(Ic i) => find.byWidgetPredicate((w) => w is SvgIcon && w.icon == i);

RallyTheme activeTheme(WidgetTester t) =>
    Theme.of(t.element(find.byType(RallyShell))).extension<RallyTheme>()!;

void main() {
  setUpAll(loadFonts);

  testWidgets('signed out: the intro leads to log in', (t) async {
    await pumpApp(t, FakeApi());
    expect(find.text('Who are you as a gamer?'), findsOneWidget);
    await tapText(t, 'Next');
    await tapText(t, 'Next');
    await tapText(t, 'Start');
    expect(find.text('Welcome back.'), findsOneWidget);
    await done(t);
  });

  testWidgets('a sleeping server: the splash says so, then the app opens', (
    t,
  ) async {
    final api = FakeApi();
    final config = api.routes['GET /v1/app/config'];
    api.routes['GET /v1/app/config'] = (RequestOptions o) =>
        Future.delayed(const Duration(seconds: 6), () => config);
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(RallyApp(api: fakeApi(api)));
    await t.pump(const Duration(seconds: 4));
    expect(find.textContaining('Waking up rally'), findsOneWidget);
    await t.pump(const Duration(seconds: 3));
    await settle(t);
    expect(find.textContaining('Waking up rally'), findsNothing);
    expect(find.text('Who are you as a gamer?'), findsOneWidget);
    await done(t);
  });

  testWidgets('no connection at launch: Try again keeps the session', (
    t,
  ) async {
    final api = FakeApi();
    final config = api.routes['GET /v1/app/config'];
    api.unreachable('GET /v1/app/config');
    await pumpApp(t, api, token: 't-1');
    expect(find.text('Can’t reach rally right now.'), findsOneWidget);
    api.routes['GET /v1/app/config'] = config;
    await tapText(t, 'Try again');
    expect(find.text(feedText), findsOneWidget);
    await done(t);
  });

  testWidgets('log in shows the API’s error, then lands on Home', (t) async {
    final api = FakeApi()
      ..fail(
        'POST /v1/auth/login',
        401,
        'wrong_credentials',
        'Wrong email or password.',
      );
    await pumpApp(t, api);
    await tapText(t, 'Log in');
    await t.enterText(find.byType(TextField).at(0), 'kaleb@example.com');
    await t.enterText(find.byType(TextField).at(1), 'nope-nope');
    await tapText(t, 'Log in');
    await settle(t);
    expect(find.text('Wrong email or password.'), findsOneWidget);

    api.routes['POST /v1/auth/login'] = {
      'token': 't-1',
      'user': me(),
      'isNew': false,
    };
    await tapText(t, 'Log in');
    await settle(t);
    expect(api.bodiesOf('POST /v1/auth/login').last, {
      'email': 'kaleb@example.com',
      'password': 'nope-nope',
    });
    expect(find.text('Did you play with Dave?'), findsOneWidget);
    expect(find.text(feedText), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // unread badge
    expect(api.sent.last.path, isNotEmpty);
    await done(t);
  });

  testWidgets('log in with a username', (t) async {
    final api = FakeApi();
    api.routes['POST /v1/auth/login'] = {
      'token': 't-1',
      'user': me(),
      'isNew': false,
    };
    await pumpApp(t, api);
    await tapText(t, 'Log in');
    await t.enterText(find.byType(TextField).at(0), '@kaleb.gg');
    await t.enterText(find.byType(TextField).at(1), 'secret-pass');
    await tapText(t, 'Log in');
    await settle(t);
    expect(api.bodiesOf('POST /v1/auth/login').last, {
      'username': 'kaleb.gg',
      'password': 'secret-pass',
    });
    expect(find.text(feedText), findsOneWidget);
    await done(t);
  });

  testWidgets('Home: the check-in is one tap, invites can be answered', (
    t,
  ) async {
    final api = FakeApi();
    api.routes['POST /v1/play-invites/pi-1/decline'] = null;
    await pumpApp(t, api, token: 't-1');
    expect(find.textContaining('Hana · eFootball'), findsOneWidget);
    await tapText(t, 'Yes, we played');
    expect(api.bodiesOf('POST /v1/check-ins/ci-1').single, {
      'answer': 'played',
    });
    expect(find.text('Did you play with Dave?'), findsNothing);
    await tapText(t, 'Not now');
    expect(api.bodiesOf('POST /v1/play-invites/pi-1/decline'), hasLength(1));
    expect(find.textContaining('Hana · eFootball'), findsNothing);
    await done(t);
  });

  testWidgets('post a listing sends the game’s options', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.find);
    await settle(t);
    expect(find.text('02 PLAYERS LOOKING'), findsOneWidget);
    await tapText(t, 'Post a listing');
    await tapText(t, 'Squad', last: true);
    await tapText(
      t,
      'Casual',
      last: true,
    ); // the STYLE chip (MODE has a Casual too)
    await tapText(t, '24h');
    await t.enterText(
      find.widgetWithText(TextField, 'Looking for a ranked duo tonight.'),
      'Need two for ranked',
    );
    await tapText(t, 'Post listing · expires in 24h');
    final sent = api.sent.lastWhere(
      (r) => r.path == '/v1/listings' && r.method == 'POST',
    );
    expect(sent.body, {
      'gameId': 'codm',
      'modeId': 'm-ranked-codm',
      'platform': 'mobile',
      'partySize': 4,
      'voice': 'required',
      'style': 'casual',
      'playWhen': 'tonight',
      'durationHours': 24,
      'note': 'Need two for ranked',
    });
    expect(
      find.text('Listing live — status set to Looking for players'),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('connect from a listing, with its id', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.find);
    await settle(t);
    await tapText(t, 'Connect');
    expect(api.bodiesOf('POST /v1/connection-requests').single, {
      'toUserId': 'u-dave',
      'listingId': 'l-1',
    });
    expect(find.text('Request sent to Dave'), findsOneWidget);
    await done(t);
  });

  testWidgets('Alerts: accept a request; activity routes to the player', (
    t,
  ) async {
    final api = FakeApi();
    api.routes['POST /v1/connection-requests/cr-1/accept'] = {
      'request':
          (api.routes['GET /v1/connection-requests']! as Map)['items'][0],
      'connection': {
        'user': hana,
        'connectedAt': DateTime.now().toUtc().toIso8601String(),
      },
    };
    await pumpApp(t, api, token: 't-1');
    await t.tap(icon(Ic.bell));
    await settle(t);
    expect(find.text('CONNECTION REQUESTS'), findsOneWidget);
    expect(api.bodiesOf('POST /v1/notifications/read').single, {'all': true});
    await tapText(t, 'Accept');
    expect(find.text('Connected with Hana'), findsOneWidget);
    await tapText(t, 'Dave accepted your request');
    await settle(t);
    expect(find.text('@dave.exe · Addis Ababa'), findsOneWidget);
    await done(t);
  });

  testWidgets('search → a connection’s profile → play together', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.find);
    await settle(t);
    await t.tap(icon(Ic.search));
    await t.pump();
    await t.enterText(find.byType(TextField), 'da');
    await t.pump(const Duration(milliseconds: 400));
    await settle(t);
    await tapText(t, 'Dave');
    await settle(t);
    expect(find.text('Connected ✓'), findsOneWidget);
    expect(find.text('dave.exe#1'), findsOneWidget);
    await tapText(t, 'Play together');
    await tapText(t, 'Now', last: true);
    await tapText(t, 'Send session invite');
    expect(api.bodiesOf('POST /v1/play-invites').single, {
      'toUserId': 'u-dave',
      'gameId': 'codm',
      'playWhen': 'now',
    });
    await done(t);
  });

  testWidgets(
    'onboarding saves games with ranks, platforms and IDs, then goes live',
    (t) async {
      final api = FakeApi(onboarded: false);
      api.routes['GET /v1/me'] = me(onboarded: false);
      final s = await pumpApp(t, api, token: 't-1');
      expect(find.text('What do you play?'), findsOneWidget);
      s.onboard.games.clear();
      await t.enterText(find.byType(TextField).first, 'mlbb');
      await t.pump();
      await tapText(t, 'Mobile Legends: Bang Bang');
      await t.enterText(find.byType(TextField).first, 'cod');
      await t.pump();
      await tapText(t, 'CoD Mobile');
      await tapText(t, 'Continue with 2 games');
      expect(find.text('Your ranks.'), findsOneWidget);
      await tapText(t, 'Legendary');
      await tapText(t, 'Continue');
      await tapText(t, 'PC');
      await t.enterText(
        find.widgetWithText(TextField, 'Add ID').at(1),
        'kaleb.gg',
      ); // Discord
      api.routes['GET /v1/me'] = me();
      await tapText(t, 'Go live');
      await settle(t);
      expect(api.bodiesOf('PUT /v1/me/games').last, {
        'games': [
          {'gameId': 'mlbb'},
          {'gameId': 'codm', 'rankId': 'r-legendary'},
        ],
      });
      expect(
        (api.bodiesOf('PUT /v1/me/platforms').last! as Map)['platforms'],
        containsAll(['mobile', 'pc']),
      );
      // The fixture's Discord ID was public; the new value keeps that.
      expect(api.bodiesOf('PUT /v1/me/gaming-ids').last, {
        'gamingIds': [
          {'kind': 'discord', 'visibility': 'public', 'value': 'kaleb.gg'},
        ],
      });
      expect(api.bodiesOf('POST /v1/me/onboard'), hasLength(1));
      expect(find.text('Profile live — welcome, Kaleb'), findsOneWidget);
      await done(t);
    },
  );

  testWidgets('Home shows the invite I sent, waiting for an answer', (t) async {
    await pumpApp(t, FakeApi(), token: 't-1');
    expect(find.text('INVITE SENT'), findsOneWidget);
    expect(
      find.textContaining('Waiting for Dave · CoD Mobile'),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('game filters send platform, mode, party and my rank', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.find);
    await settle(t);
    await tapText(t, 'CoD Mobile');
    await tapText(t, 'My rank and up');
    await tapText(t, 'Ranked'); // the chip; the cards below say RANKED
    await tapText(t, 'Squad'); // the chip, above the cards' NEED boxes
    final q = api.queries.lastWhere((x) => x.startsWith('GET /v1/listings?'));
    expect(q, contains('game=codm'));
    expect(q, contains('minRank=r-master'));
    expect(q, contains('mode=m-ranked-codm'));
    expect(q, contains('partySize=4'));
    // A different game starts its filters over.
    await tapText(t, 'eFootball');
    final q2 = api.queries.lastWhere((x) => x.startsWith('GET /v1/listings?'));
    expect(q2, contains('game=efootball'));
    expect(q2, isNot(contains('minRank')));
    await done(t);
  });

  testWidgets('withdraw a request from a listing', (t) async {
    final api = FakeApi();
    final feed = api.routes['GET /v1/listings']! as Map;
    (feed['items'] as List)[0] = listing(
      'l-1',
      dave,
      myRequest: {'id': 'cr-mine', 'status': 'pending'},
    );
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.find);
    await settle(t);
    await tapText(t, 'Requested…');
    await tapText(t, 'Withdraw');
    expect(
      api.sent.any(
        (r) =>
            r.method == 'DELETE' && r.path == '/v1/connection-requests/cr-mine',
      ),
      isTrue,
    );
    expect(find.text('Request to Dave withdrawn'), findsOneWidget);
    await done(t);
  });

  testWidgets('edit my live listing without reposting it', (t) async {
    final api = FakeApi();
    final mine = listing('l-mine', card('me-1', 'kaleb.gg', 'Kaleb'));
    api.routes['GET /v1/me/listing'] = {'listing': mine};
    api.routes['PATCH /v1/listings/l-mine'] = {
      ...mine,
      'voice': 'optional',
      'playWhen': 'now',
      'note': 'Chill games only',
    };
    await pumpApp(t, api, token: 't-1');
    expect(find.text('YOUR LIVE LISTING'), findsOneWidget);
    await tapText(t, 'Edit');
    expect(find.text('Edit your listing'), findsOneWidget);
    expect(find.text('EXPIRES AFTER'), findsNothing);
    await tapText(t, 'Mic optional');
    await tapText(t, 'Now');
    await t.enterText(find.byType(TextField).last, 'Chill games only');
    await tapText(t, 'Save changes');
    expect(api.bodiesOf('PATCH /v1/listings/l-mine').single, {
      'voice': 'optional',
      'style': 'competitive',
      'playWhen': 'now',
      'note': 'Chill games only',
    });
    expect(find.text('Listing updated'), findsOneWidget);
    expect(
      api.sent.where((r) => r.method == 'POST' && r.path == '/v1/listings'),
      isEmpty,
    );
    await done(t);
  });

  testWidgets('withdraw a request from their profile', (t) async {
    final api = FakeApi();
    api.routes['GET /v1/users/hanaplays'] = profile(
      'u-hana',
      'hanaplays',
      'Hana',
      relationship: 'outgoing_request',
      outgoingRequestId: 'cr-mine',
    );
    final s = await pumpApp(t, api, token: 't-1');
    s.openPlayer('hanaplays');
    await settle(t);
    await tapText(t, 'Requested…');
    await tapText(t, 'Withdraw');
    expect(api.sent.where((r) => r.method == 'DELETE').map((r) => r.path), [
      '/v1/connection-requests/cr-mine',
    ]);
    expect(api.sent.any((r) => r.path == '/v1/connection-requests'), isFalse);
    await done(t);
  });

  testWidgets('remove a connection from their profile menu', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openPlayer('dave.exe');
    await settle(t);
    await t.tap(icon(Ic.more));
    await settle(t);
    await tapText(t, 'Remove connection');
    await tapText(t, 'Remove');
    expect(
      api.sent.any(
        (r) => r.method == 'DELETE' && r.path == '/v1/connections/u-dave',
      ),
      isTrue,
    );
    expect(find.text('You’re no longer connected with Dave'), findsOneWidget);
    await done(t);
  });

  testWidgets('an alert about a listing opens that listing', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openRoute('/listings/l-1');
    await settle(t);
    expect(find.text('Listing'), findsOneWidget);
    expect(find.text('“Ranked grind, mics on.”'), findsOneWidget);
    s.handleBack();
    await settle(t);
    expect(find.text(feedText), findsOneWidget);
    await done(t);
  });

  testWidgets(
    'settings: change password, and Edit profile saves age and checks the username',
    (t) async {
      final api = FakeApi();
      final s = await pumpApp(t, api, token: 't-1');
      s.goProfileTab();
      await settle(t);
      await tapText(t, 'Change password');
      await t.enterText(
        find.widgetWithText(TextField, 'Current password'),
        'old-password',
      );
      await t.enterText(
        find.widgetWithText(TextField, 'New password, 8+ characters'),
        'new-password',
      );
      await tapText(t, 'Change');
      expect(api.bodiesOf('POST /v1/auth/password').single, {
        'currentPassword': 'old-password',
        'newPassword': 'new-password',
      });
      expect(find.text('Password changed'), findsOneWidget);

      s.openEditProfile();
      await settle(t);
      await t.enterText(
        find.widgetWithText(TextField, 'kaleb.gg').first,
        'taken.name',
      );
      await t.pump(const Duration(milliseconds: 500));
      await settle(t);
      expect(find.text('@taken.name is taken'), findsOneWidget);
      await t.enterText(
        find.widgetWithText(TextField, 'kaleb.gg').first,
        'kaleb.gg',
      );
      await t.pump(const Duration(milliseconds: 500));
      await settle(t);
      expect(find.text('@taken.name is taken'), findsNothing);
      await tapText(t, '25–34');
      await tapText(t, 'Save');
      expect((api.bodiesOf('PATCH /v1/me').last! as Map)['ageRange'], '25_34');
      await done(t);
    },
  );

  testWidgets('a report from a profile', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openPlayer('hanaplays');
    await settle(t);
    await t.tap(icon(Ic.more));
    await settle(t);
    await tapText(t, 'Report');
    await tapText(t, 'Spam');
    await tapText(t, 'Send report');
    expect(api.bodiesOf('POST /v1/reports').single, {
      'userId': 'u-hana',
      'reason': 'spam',
    });
    await done(t);
  });

  testWidgets('groups: join an open group, ask to join one with approval', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await settle(t);
    expect(find.text('Yours (1)'), findsOneWidget);
    await tapText(t, 'Join'); // Ethiopian FC Players
    expect(find.text('You joined Ethiopian FC Players'), findsOneWidget);
    expect(find.text('Yours (2)'), findsOneWidget);
    await tapText(t, 'Ask to join'); // AAU Gamers
    expect(find.text('Requested…'), findsOneWidget);
    await t.pump(const Duration(seconds: 4));
    await settle(t);
    expect(find.text('Yours (3)'), findsOneWidget);
    expect(
      find.text('You’re in — AAU Gamers approved your request'),
      findsOneWidget,
    );
    // Nothing about groups goes to the server.
    expect(api.sent.where((r) => r.path.contains('group')), isEmpty);
    await done(t);
  });

  testWidgets('groups: create one, it opens on About and is in Yours', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await settle(t);
    await tapText(t, 'Create group');
    expect(find.text('New group'), findsOneWidget);
    await t.enterText(
      find.widgetWithText(TextField, 'e.g. Valorant Addis Duo Queue'),
      'Addis CODM Duo',
    );
    await t.pump();
    await tapText(t, 'Approval');
    await tapText(t, 'Create');
    expect(
      find.text('Addis CODM Duo is live — invite your squad'),
      findsOneWidget,
    );
    expect(find.text('Admins approve requests'), findsOneWidget); // About tab
    expect(find.text('YOU’RE ADMIN'), findsOneWidget);
    expect(s.myGroups.map((g) => g.name), contains('Addis CODM Duo'));
    await tapText(t, 'Feed');
    await t.enterText(
      find.widgetWithText(TextField, 'Share with Addis CODM Duo…'),
      'Scrims Friday',
    );
    await tapText(t, 'Post');
    expect(find.text('Scrims Friday'), findsOneWidget);
    await done(t);
  });

  testWidgets('Home feed: a post renders, GG toggles its count', (t) async {
    final api = FakeApi();
    await pumpApp(t, api, token: 't-1');
    expect(find.text(feedText), findsOneWidget);
    expect(api.queries, contains(startsWith('GET /v1/feed?filter=for_you')));
    expect(find.text('4'), findsOneWidget);
    await t.tap(labelled('GG'));
    await settle(t);
    expect(
      api.sent.where((r) => r.method == 'PUT' && r.path == '/v1/posts/p-1/gg'),
      hasLength(1),
    );
    expect(find.text('5'), findsOneWidget);
    await t.tap(labelled('GG'));
    await settle(t);
    expect(
      api.sent.where(
        (r) => r.method == 'DELETE' && r.path == '/v1/posts/p-1/gg',
      ),
      hasLength(1),
    );
    expect(find.text('4'), findsOneWidget);
    await done(t);
  });

  testWidgets('Home feed: open comments and send one', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    await t.tap(labelled('Answers'));
    await settle(t);
    expect(find.text('It Takes Two, easily.'), findsOneWidget);
    await t.enterText(
      find.widgetWithText(TextField, 'Add your answer…'),
      'Portal 2',
    );
    // The keyboard's send (the + button floats over Send at this size).
    await t.testTextInput.receiveAction(TextInputAction.done);
    await settle(t);
    expect(api.bodiesOf('POST /v1/posts/p-1/comments').single, {
      'text': 'Portal 2',
    });
    expect(find.text('Portal 2'), findsOneWidget);
    expect(s.posts.first.commentCount, 2);
    await done(t);
  });

  testWidgets('an alert with ?comments=1 opens the post with its comments', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.notifs);
    await settle(t);
    api.queries.clear();
    s.openRoute('/posts/p-1?comments=1');
    await settle(t);
    expect(s.screen, Screen.home);
    expect(api.queries, contains('GET /v1/posts/p-1?'));
    expect(api.queries, contains(startsWith('GET /v1/posts/p-1/comments?')));
    expect(api.queries.where((q) => q.contains('comments=1')), isEmpty);
    expect(s.openC, {'p-1'});
    expect(find.text('It Takes Two, easily.'), findsOneWidget);
    await done(t);
  });

  testWidgets('an alert for a post that is gone lands on Home', (t) async {
    final api = FakeApi()
      ..fail('GET /v1/posts/p-gone', 404, 'not_found', 'Post not found.');
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.notifs);
    await settle(t);
    s.openRoute('/posts/p-gone?comments=1');
    await settle(t);
    expect(s.screen, Screen.home);
    expect(find.text('Post not found.'), findsOneWidget);
    await done(t);
  });

  testWidgets('deleting a comment says so; reporting a post is titled', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    await t.tap(labelled('Answers'));
    await settle(t);
    // Not awaited: the fake API answers while the test pumps.
    s.deleteComment(s.comments['p-1']!.first);
    await settle(t);
    expect(
      api.sent.where(
        (r) => r.method == 'DELETE' && r.path == '/v1/comments/c-1',
      ),
      hasLength(1),
    );
    expect(find.text('Comment deleted'), findsOneWidget);
    await t.tap(labelled('Post options'));
    await settle(t);
    await tapText(t, 'Report post');
    expect(find.text('Report post'), findsOneWidget); // the dialog title
    expect(find.text('Report Dave'), findsNothing);
    await done(t);
  });

  testWidgets('compose: type, game and audience go out with a key', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    expect(find.text('New post'), findsOneWidget);
    // Only the types the API takes today.
    expect(find.text('Poll'), findsNothing);
    expect(find.text('Gameplay'), findsNothing);
    await tapText(t, 'Milestone');
    await tapText(t, 'Connections');
    await tapText(t, 'Post'); // empty text: nothing sent
    expect(api.bodiesOf('POST /v1/posts'), isEmpty);
    expect(find.text('Write something first'), findsOneWidget);
    await t.enterText(
      find.widgetWithText(TextField, 'Finally hit Diamond? Share it…'),
      'Hit Legendary!',
    );
    await t.pump();
    final key = s.cp.key;
    await tapText(t, 'Post');
    expect(api.bodiesOf('POST /v1/posts').single, {
      'type': 'milestone',
      'text': 'Hit Legendary!',
      'gameId': 'codm',
      'audience': 'connections',
    });
    final headers = api.headers.lastWhere((h) => h.$1 == 'POST /v1/posts').$2;
    expect(headers['Idempotency-Key'] ?? headers['idempotency-key'], key);
    expect(s.screen, Screen.home);
    expect(find.text('Milestone posted'), findsOneWidget);
    expect(find.text('Hit Legendary!'), findsOneWidget);
    await done(t);
  });

  testWidgets('compose: Any game sends no game', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    await tapText(t, 'Any game');
    await t.enterText(find.byType(TextField), 'Who is up tonight?');
    await t.pump();
    await tapText(t, 'Post');
    final body = api.bodiesOf('POST /v1/posts').single! as Map;
    expect(body['type'], 'discussion');
    expect(body['audience'], 'everyone');
    expect(body.containsKey('gameId') ? body['gameId'] : null, isNull);
    await done(t);
  });

  testWidgets('compose: Any game survives closing and reopening', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    expect(s.cp.gameId, 'codm'); // a fresh draft starts on my first game
    await tapText(t, 'Any game');
    s.handleBack(); // close the composer
    await settle(t);
    s.openCompose();
    await settle(t);
    expect(s.cp.gameId, isNull);
    await t.enterText(find.byType(TextField), 'Anyone up?');
    await t.pump();
    await tapText(t, 'Post');
    final body = api.bodiesOf('POST /v1/posts').single! as Map;
    expect(body['gameId'], isNull);
    // After posting, the next draft starts on my first game again.
    s.openCompose();
    await settle(t);
    expect(s.cp.gameId, 'codm');
    await done(t);
  });

  testWidgets('profile: Posts lists mine, Groups shows my sample groups', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.goProfileTab();
    await settle(t);
    expect(find.text('YOUR STATUS'), findsOneWidget); // moved from Home
    expect(find.text('GROUPS · 1'), findsOneWidget);
    await tapText(t, 'Posts');
    expect(find.text('Finally hit Legendary in ranked.'), findsOneWidget);
    expect(find.text('GG 12 · 3 comments'), findsOneWidget);
    await tapText(t, 'Groups');
    expect(find.text('Valorant Ethiopia'), findsOneWidget);
    await tapText(t, 'Moments');
    expect(find.textContaining('No clips yet.'), findsOneWidget);
    await tapText(t, 'Posts');
    await tapText(t, 'Finally hit Legendary in ranked.');
    expect(s.screen, Screen.home);
    await done(t);
  });

  testWidgets('someone else’s profile: invite banner, no groups', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openPlayer('dave.exe');
    await settle(t);
    expect(find.text('SESSION INVITE SENT'), findsOneWidget);
    expect(find.text('CoD Mobile with Dave'), findsOneWidget);
    expect(find.text('Connections'), findsNothing);
    await tapText(t, 'Groups');
    expect(find.text('Dave isn’t in any groups yet.'), findsOneWidget);
    await tapText(t, 'Posts');
    expect(api.queries, contains(startsWith('GET /v1/users/dave.exe/posts')));
    expect(
      find.text('No posts yet. Share a milestone from Home.'),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('theme picker switches and persists the skin', (t) async {
    final saved = <String>[];
    await pumpApp(t, FakeApi(), token: 't-1', persist: saved.add);
    final s = t.state<RallyAppState>(find.byType(RallyApp)).state;
    s.goProfileTab();
    await settle(t);
    expect(activeTheme(t).id, 'inked');
    for (final name in ['Dot matrix', 'Glass', 'Soft clay', 'Inked']) {
      await tapText(t, name);
      await t.pump(const Duration(milliseconds: 400)); // theme blend
      expect(activeTheme(t).name, name);
    }
    expect(saved, ['dot', 'glass', 'soft', 'inked']);
    await done(t);
  });

  // Each skin has its own fonts, so text widths differ: render every screen
  // in every skin at a small phone width and fail on any layout overflow.
  for (final th in rallyThemes) {
    testWidgets('every screen lays out in ${th.name}', (t) async {
      final api = FakeApi();
      final s = await pumpApp(
        t,
        api,
        token: 't-1',
        theme: th.id,
        size: const Size(360, 740),
      );
      for (final screen in Screen.values) {
        if (screen == Screen.profile) {
          s.openPlayer('dave.exe');
        } else {
          s.go(screen, () {
            if (screen == Screen.editProfile) {
              s.edit = ProfileDraft.from(s.me!, s.catalog);
            }
            if (screen == Screen.ranks) s.onboard.games = ['codm', 'mc'];
            if (screen == Screen.group) s.groupId = 'g-val';
            if (screen == Screen.createGroup) s.newGroup = GroupDraft();
          });
        }
        await settle(t);
      }
      // The group page's and my profile's tabs.
      s.openGroup('g-val');
      for (final tab in ['Feed', 'Members', 'Events', 'About']) {
        s.update(() => s.groupTab = tab);
        await settle(t);
      }
      s.goProfileTab();
      for (final tab in ['Groups', 'Posts', 'Moments', 'Overview']) {
        s.update(() => s.ptab = tab);
        await settle(t);
      }
      s.openListingSheet();
      await settle(t);
      expect(find.text('EXPIRES AFTER'), findsOneWidget);
      await done(t);
    });
  }
}
