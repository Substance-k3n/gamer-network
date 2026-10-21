import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rally/groups_data.dart';
import 'package:rally/main.dart';
import 'package:rally/screens/home.dart'
    show ApplicationsSheet, endsIn, pollFooter, slotsLine;
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

  /// Opens a group page and lets its four calls finish.
  Future<AppState> openGroup(WidgetTester t, FakeApi api, String id) async {
    final s = await pumpApp(t, api, token: 't-1');
    s.openGroup(id);
    await settle(t);
    return s;
  }

  testWidgets('groups: Discover lists the API’s groups, join and ask', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await settle(t);
    expect(api.queries, contains(startsWith('GET /v1/groups?')));
    expect(find.text('Yours (2)'), findsOneWidget); // incl. a pending request
    expect(find.text('CODM Addis'), findsOneWidget);
    await tapText(t, 'Join'); // Ethiopian FC Players
    expect(api.bodiesOf('POST /v1/groups/g-fc/join'), hasLength(1));
    expect(find.text('You joined Ethiopian FC Players'), findsOneWidget);
    expect(find.text('Joined ✓'), findsNWidgets(2));
    await tapText(t, 'Ask to join'); // AAU Gamers
    expect(find.text('Request sent to AAU Gamers admins'), findsOneWidget);
    expect(find.text('Requested…'), findsOneWidget);
    // Taking the request back: DELETE /membership.
    await tapText(t, 'Requested…');
    expect(
      find.text(
        'AAU Gamers’s admins won’t see it any more. You can ask again later.',
      ),
      findsOneWidget,
    );
    await tapText(t, 'Cancel request');
    expect(
      api.sent.any(
        (r) => r.method == 'DELETE' && r.path == '/v1/groups/g-aau/membership',
      ),
      isTrue,
    );
    expect(find.text('Request to AAU Gamers cancelled'), findsOneWidget);
    expect(find.text('Ask to join'), findsOneWidget);
    expect(s.groups.firstWhere((g) => g.id == 'g-aau').myStatus, isNull);
    await done(t);
  });

  testWidgets('groups: kind chips and search (2+ characters, debounced)', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await settle(t);
    await tapText(t, 'Campus');
    expect(api.queries.last, contains('kind=campus'));
    expect(find.text('AAU Gamers'), findsOneWidget);
    expect(find.text('CODM Addis'), findsNothing);
    await tapText(t, 'All');
    api.queries.clear();
    await t.enterText(
      find.widgetWithText(TextField, 'Search groups, games, cities'),
      'e',
    );
    await t.pump(const Duration(milliseconds: 500));
    expect(api.queries.where((q) => q.contains('/v1/groups?')), isEmpty);
    await t.enterText(
      find.widgetWithText(TextField, 'Search groups, games, cities'),
      'ethio',
    );
    await t.pump(const Duration(milliseconds: 100));
    expect(api.queries.where((q) => q.contains('/v1/groups?')), isEmpty);
    await t.pump(const Duration(milliseconds: 400));
    await settle(t);
    expect(api.queries.last, contains('query=ethio'));
    expect(find.text('Ethiopian FC Players'), findsOneWidget);
    expect(find.text('CODM Addis'), findsNothing);
    await tapText(t, 'Yours (2)');
    expect(api.queries.last, contains('tab=mine'));
    await done(t);
  });

  testWidgets('groups: create one with rules, it opens on About', (t) async {
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
    await tapText(t, '+ Add rule');
    await t.enterText(find.widgetWithText(TextField, 'Rule 1'), 'No smurfs');
    await tapText(t, 'Approval');
    await tapText(t, 'Create');
    final body = api.bodiesOf('POST /v1/groups').single! as Map;
    expect(body['name'], 'Addis CODM Duo');
    expect(body['kind'], 'game');
    expect(body['gameId'], 'codm');
    expect(body['rules'], ['No smurfs']);
    expect(body['approval'], true);
    final h = api.headers.lastWhere((h) => h.$1 == 'POST /v1/groups');
    expect(h.$2['Idempotency-Key'] ?? h.$2['idempotency-key'], isNotNull);
    expect(
      find.text('Addis CODM Duo is live — invite your squad'),
      findsOneWidget,
    );
    expect(s.groupTab, 'About');
    expect(find.text('No smurfs'), findsOneWidget);
    expect(find.text('YOU’RE ADMIN'), findsOneWidget);
    expect(s.myGroups.first.name, 'Addis CODM Duo');
    await done(t);
  });

  testWidgets('groups: a taken name shows on the name field', (t) async {
    final api = FakeApi()
      ..fail(
        'POST /v1/groups',
        409,
        'group_name_taken',
        'A group called CODM Addis already exists.',
      );
    final s = await pumpApp(t, api, token: 't-1');
    s.openCreateGroup();
    await settle(t);
    await t.enterText(
      find.widgetWithText(TextField, 'e.g. Valorant Addis Duo Queue'),
      'CODM Addis',
    );
    await t.pump();
    await tapText(t, 'Create');
    expect(s.screen, Screen.createGroup);
    expect(s.newGroup!.nameError, 'A group called CODM Addis already exists.');
    // Typing again clears it.
    await t.enterText(
      find.widgetWithText(TextField, 'CODM Addis'),
      'CODM Addis 2',
    );
    await t.pump();
    expect(s.newGroup!.nameError, isNull);
    await done(t);
  });

  testWidgets('group page: feed posts with groupId; admins delete any post', (
    t,
  ) async {
    final api = FakeApi();
    final s = await openGroup(t, api, 'g-codm');
    expect(api.queries, contains(startsWith('GET /v1/groups/g-codm/posts')));
    expect(find.text('Scrims tonight, who is in?'), findsOneWidget);
    await t.enterText(
      find.widgetWithText(TextField, 'Share with CODM Addis…'),
      'Lobby code in 5',
    );
    await tapText(t, 'Post');
    expect(api.bodiesOf('POST /v1/posts').single, {
      'type': 'discussion',
      'text': 'Lobby code in 5',
      'groupId': 'g-codm',
      'audience': 'everyone',
    });
    expect(s.groupPosts!.first.text, 'Lobby code in 5');
    // Dave's post: as a group admin I can remove it.
    s.update(
      () => s.groupPosts = s.groupPosts!.where((p) => p.id == 'gp-1').toList(),
    );
    await settle(t);
    await t.tap(labelled('Post options'));
    await settle(t);
    await tapText(t, 'Delete post');
    await tapText(t, 'Delete');
    expect(
      api.sent.any((r) => r.method == 'DELETE' && r.path == '/v1/posts/gp-1'),
      isTrue,
    );
    expect(find.text('Scrims tonight, who is in?'), findsNothing);
    await done(t);
  });

  testWidgets('group page: requests, make admin, remove, open a member', (
    t,
  ) async {
    final api = FakeApi();
    final s = await openGroup(t, api, 'g-codm');
    await tapText(t, 'Members');
    expect(find.text('REQUESTS (1)'), findsOneWidget);
    await tapText(t, 'Approve');
    expect(
      api.sent.any((r) => r.path == '/v1/groups/g-codm/members/u-hana/approve'),
      isTrue,
    );
    expect(find.text('Hana is in'), findsOneWidget);
    expect(find.text('REQUESTS (1)'), findsNothing);
    await t.tap(labelled('Manage Dave'));
    await settle(t);
    await tapText(t, 'Make admin');
    expect(api.bodiesOf('PUT /v1/groups/g-codm/members/u-dave/role').single, {
      'role': 'admin',
    });
    expect(find.text('Dave is an admin now'), findsOneWidget);
    final dave = s.members!.firstWhere((m) => m.user.id == 'u-dave');
    s.setMemberRole(dave, GroupRole.member);
    await settle(t);
    expect(find.text('Dave is a member now'), findsOneWidget);
    await t.tap(labelled('Manage Dave'));
    await settle(t);
    await tapText(t, 'Remove from group');
    expect(
      find.text('They leave CODM Addis. They can ask to join again.'),
      findsOneWidget,
    );
    await tapText(t, 'Remove');
    expect(
      api.sent.any(
        (r) =>
            r.method == 'DELETE' &&
            r.path == '/v1/groups/g-codm/members/u-dave',
      ),
      isTrue,
    );
    expect(find.text('Dave removed from the group'), findsOneWidget);
    // Members are real players: tapping one opens their profile.
    await tapText(t, 'Kaleb (you)');
    expect(s.screen, Screen.profile);
    await done(t);
  });

  testWidgets('group page: going, a new event, deleting one', (t) async {
    final api = FakeApi();
    final s = await openGroup(t, api, 'g-codm');
    await tapText(t, 'Events');
    expect(find.text('Scrims vs Hawassa'), findsOneWidget);
    await tapText(t, 'I’m in');
    expect(
      api.sent.any(
        (r) => r.method == 'PUT' && r.path == '/v1/group-events/ev-1/going',
      ),
      isTrue,
    );
    expect(find.text('Going ✓'), findsOneWidget);
    expect(find.textContaining('2 going'), findsOneWidget);
    await tapText(t, 'New event');
    await t.enterText(
      find.widgetWithText(TextField, 'What’s happening?'),
      'Ranked night',
    );
    await tapText(t, 'Add event');
    final body = api.bodiesOf('POST /v1/groups/g-codm/events').single! as Map;
    expect(body['title'], 'Ranked night');
    expect(body['gameId'], 'codm');
    final at = DateTime.parse(body['startsAt'] as String);
    expect(at.isAfter(DateTime.now()), isTrue);
    expect(at.difference(DateTime.now()).inDays, lessThan(60));
    expect(find.text('Ranked night'), findsOneWidget);
    expect(s.events, hasLength(2));
    await tapText(t, 'Delete');
    await tapText(t, 'Delete', last: true);
    expect(
      api.sent.where(
        (r) => r.method == 'DELETE' && r.path.startsWith('/v1/group-events/'),
      ),
      hasLength(1),
    );
    expect(find.text('Event deleted'), findsOneWidget);
    await done(t);
  });

  testWidgets('group page: the last admin can’t leave', (t) async {
    final api = FakeApi()
      ..fail(
        'DELETE /v1/groups/g-codm/membership',
        409,
        'last_admin',
        'Make someone else admin before you leave.',
      );
    await openGroup(t, api, 'g-codm');
    await tapText(t, 'Joined ✓');
    await tapText(t, 'Leave');
    expect(
      find.text('Make someone else admin before you leave.'),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('group page: edit (admins), share, About details', (t) async {
    final api = FakeApi();
    final copied = <String>[];
    t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (c) async {
        if (c.method == 'Clipboard.setData') {
          copied.add((c.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => t.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final s = await openGroup(t, api, 'g-codm');
    await t.tap(labelled('Share group'));
    await settle(t);
    expect(copied.last, 'https://example.com/app/groups/g-codm');
    expect(
      find.text('Link copied — paste it in Telegram or WhatsApp'),
      findsOneWidget,
    );
    await tapText(t, 'About');
    expect(find.text('Mar 2025'), findsOneWidget);
    expect(find.text('You'), findsOneWidget); // admins
    await tapText(t, 'Edit group');
    expect(find.text('Edit group'), findsOneWidget);
    await t.enterText(find.widgetWithText(TextField, 'Addis Ababa'), 'Adama');
    await tapText(t, 'Save');
    final body = api.bodiesOf('PATCH /v1/groups/g-codm').single! as Map;
    expect(body['place'], 'Adama');
    expect(body.containsKey('kind'), isFalse);
    expect(find.text('Group updated'), findsOneWidget);
    expect(s.screen, Screen.group);
    await done(t);
  });

  testWidgets('report a group from its menu', (t) async {
    final api = FakeApi();
    await openGroup(t, api, 'g-fc');
    expect(find.text('Join to post and reply in this group.'), findsOneWidget);
    await t.tap(labelled('Group options'));
    await settle(t);
    await tapText(t, 'Report group');
    expect(find.text('Report group'), findsOneWidget); // the dialog title
    await tapText(t, 'Spam');
    await tapText(t, 'Send report');
    expect(api.bodiesOf('POST /v1/reports').single, {
      'userId': 'u-dave', // the group's createdBy
      'reason': 'spam',
      'groupId': 'g-fc',
    });
    await done(t);
  });

  testWidgets('the creator is not offered Report group', (t) async {
    final api = FakeApi();
    await openGroup(t, api, 'g-mine');
    await t.tap(labelled('Group options'));
    await settle(t);
    expect(find.text('Copy link'), findsOneWidget);
    expect(find.text('Report group'), findsNothing);
    await done(t);
  });

  testWidgets('a short group name shows inline, not as a toast', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await settle(t);
    await tapText(t, 'Create group');
    await t.enterText(
      find.widgetWithText(TextField, 'e.g. Valorant Addis Duo Queue'),
      'ab',
    );
    await t.pump();
    await tapText(t, 'Create');
    expect(find.text('Give your group a name (3+ characters)'), findsOneWidget);
    expect(api.bodiesOf('POST /v1/groups'), isEmpty);
    await done(t);
  });

  testWidgets('group alerts open the group (join requests on Members)', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.notifs);
    await settle(t);
    s.openRoute('/groups/g-codm/members?status=pending');
    await settle(t);
    expect(s.screen, Screen.group);
    expect(s.groupTab, 'Members');
    expect(find.text('REQUESTS (1)'), findsOneWidget);
    s.openRoute('/groups/g-fc');
    await settle(t);
    expect(s.groupTab, 'Feed');
    expect(find.text('Ethiopian FC Players'), findsOneWidget);
    await done(t);
  });

  testWidgets('Home feed: a post renders, GG toggles its count', (t) async {
    final api = FakeApi();
    await pumpApp(t, api, token: 't-1');
    expect(find.text(feedText), findsOneWidget);
    expect(api.queries, contains(startsWith('GET /v1/feed?filter=for_you')));
    expect(find.text('4'), findsOneWidget);
    await t.tap(labelled('GG').first);
    await settle(t);
    expect(
      api.sent.where((r) => r.method == 'PUT' && r.path == '/v1/posts/p-1/gg'),
      hasLength(1),
    );
    expect(find.text('5'), findsOneWidget);
    await t.tap(labelled('GG').first);
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
    await t.tap(labelled('Post options').first);
    await settle(t);
    await tapText(t, 'Report post');
    expect(find.text('Report post'), findsOneWidget); // the dialog title
    expect(find.text('Report Dave'), findsNothing);
    await done(t);
  });

  /// Scrolls the Home feed until [f] is built and visible.
  Future<void> scrollFeedTo(WidgetTester t, Finder f) async {
    await t.scrollUntilVisible(
      f,
      300,
      scrollable: find
          .byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await t.pump();
  }

  List<PickedPhoto> photos(int n) => [
    for (var i = 0; i < n; i++)
      PickedPhoto(
        Uint8List.fromList([1, 2, 3]),
        MediaContentType.imageSlashJpeg,
      ),
  ];

  /// "METHOD /path" of the calls a photo post makes, in order.
  List<String> uploadCalls(FakeApi api) => [
    for (final r in api.sent)
      if (r.path == '/v1/media/upload-url' ||
          r.path.startsWith('/upload/') ||
          r.path == '/v1/posts')
        '${r.method} ${r.path}',
  ];

  testWidgets('photo post: upload each photo, then create with the keys', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    expect(find.text('Add photos'), findsOneWidget);
    expect(find.text('Up to 4 photos'), findsOneWidget);
    s.addPhotos(photos(5));
    await settle(t);
    expect(s.cp.photos, hasLength(4));
    expect(find.text('Up to 4 photos per post'), findsOneWidget);
    expect(find.text('04/04'), findsOneWidget);
    s.removePhoto(3);
    s.removePhoto(2);
    await settle(t);
    expect(find.text('02/04'), findsOneWidget);
    await tapText(t, 'Gameplay');
    await t.enterText(
      find.widgetWithText(TextField, 'Add a caption for your screenshots…'),
      'Ace on Standoff',
    );
    await t.pump();
    await tapText(t, 'Post');
    expect(uploadCalls(api), [
      'POST /v1/media/upload-url',
      'PUT /upload/1',
      'POST /v1/media/upload-url',
      'PUT /upload/2',
      'POST /v1/posts',
    ]);
    expect(api.bodiesOf('POST /v1/media/upload-url').first, {
      'contentType': 'image/jpeg',
      'size': 3,
    });
    final body = api.bodiesOf('POST /v1/posts').single! as Map;
    expect(body['type'], 'gameplay');
    expect(body['media'], ['media/me-1/k1.jpg', 'media/me-1/k2.jpg']);
    expect(find.text('Gameplay posted'), findsOneWidget);
    expect(s.posts.first.media, hasLength(2));
    await done(t);
  });

  testWidgets('photo post: a failed upload keeps the draft', (t) async {
    final api = FakeApi()
      ..fail(
        'POST /v1/media/upload-url',
        429,
        'rate_limited',
        'You can upload 30 photos an hour.',
      );
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    // Gameplay needs a photo first.
    await tapText(t, 'Gameplay');
    expect(
      find.text('A gameplay post needs at least one photo.'),
      findsOneWidget,
    );
    await t.enterText(find.byType(TextField).first, 'Ace');
    await t.pump();
    await tapText(t, 'Post');
    expect(
      find.text('Add at least one photo to a gameplay post'),
      findsOneWidget,
    );
    s.addPhotos(photos(1));
    await settle(t);
    await tapText(t, 'Post');
    expect(find.text('You can upload 30 photos an hour.'), findsOneWidget);
    expect(api.bodiesOf('POST /v1/posts'), isEmpty);
    expect(s.screen, Screen.compose);
    expect(s.cp.photos, hasLength(1));
    expect(s.cp.text, 'Ace');
    await done(t);
  });

  testWidgets('compose a poll and a recruitment post', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    await tapText(t, 'Poll'); // the type chip
    await t.enterText(
      find.widgetWithText(TextField, 'Ask the community something…'),
      'Best map?',
    );
    await t.enterText(find.widgetWithText(TextField, 'Option 1'), 'Crash');
    await t.pump();
    await tapText(t, 'Post'); // one option isn't enough
    expect(find.text('Add at least two options'), findsOneWidget);
    await t.enterText(find.widgetWithText(TextField, 'Option 2'), 'Nuketown');
    await tapText(t, '+ Add option');
    await t.enterText(find.widgetWithText(TextField, 'Option 3'), 'Raid');
    await tapText(t, '1 week');
    await tapText(t, 'Post');
    expect((api.bodiesOf('POST /v1/posts').single! as Map)['poll'], {
      'options': ['Crash', 'Nuketown', 'Raid'],
      'duration': '1w',
    });
    expect(find.text('Poll posted'), findsOneWidget);

    s.openCompose();
    await settle(t);
    await tapText(t, 'Recruitment');
    await t.enterText(
      find.widgetWithText(
        TextField,
        'Tell players about your team and what you’re looking for…',
      ),
      'Squad for scrims',
    );
    await tapText(t, '4+');
    await tapText(t, '6');
    await t.enterText(
      find.widgetWithText(TextField, 'Roles needed — e.g. Sniper, Support'),
      'Sniper',
    );
    await t.pump();
    await tapText(t, 'Post');
    expect((api.bodiesOf('POST /v1/posts').last! as Map)['recruit'], {
      'slots': 6,
      'roles': 'Sniper',
    });
    expect(find.text('Recruitment posted'), findsOneWidget);
    await done(t);
  });

  testWidgets('recruitment roles stop at 80 characters', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    await tapText(t, 'Recruitment');
    await t.enterText(
      find.widgetWithText(TextField, 'Roles needed — e.g. Sniper, Support'),
      'x' * 100,
    );
    await t.pump();
    expect(s.cp.roles, hasLength(80));
    await done(t);
  });

  test('poll footer copy and plurals (D29)', () {
    final now = DateTime.utc(2026, 10, 20, 12);
    PollDto poll(int votes, {int? mine, bool closed = false, Duration? left}) =>
        PollDto(
          (b) => b
            ..totalVotes = votes
            ..myVote = mine
            ..closed = closed
            ..endsAt = now.add(left ?? const Duration(days: 2, hours: 5)),
        );
    expect(pollFooter(poll(1, mine: 0), now), '1 VOTE · YOU VOTED');
    expect(pollFooter(poll(2), now), '2 VOTES · ENDS IN 2 DAYS');
    expect(pollFooter(poll(0, closed: true), now), '0 VOTES · CLOSED');
    expect(pollFooter(poll(3, mine: 1, closed: true), now), '3 VOTES · CLOSED');
    expect(
      endsIn(now.add(const Duration(hours: 5, minutes: 40)), now),
      '5 HOURS',
    );
    expect(
      endsIn(now.add(const Duration(hours: 1, minutes: 2)), now),
      '1 HOUR',
    );
    expect(endsIn(now.add(const Duration(days: 1, hours: 3)), now), '1 DAY');
    expect(endsIn(now.add(const Duration(minutes: 30)), now), '30 MIN');
  });

  testWidgets('a closed poll shows results to everyone', (t) async {
    final api = FakeApi();
    final feed = api.routes['GET /v1/feed']! as Map;
    (feed['items'] as List)[1] = post(
      'p-poll',
      hana,
      type: 'poll',
      kind: 'poll',
      text: pollText,
      poll: pollOf(['Firing Range', 'Standoff'], votes: [3, 1], closed: true),
    );
    await pumpApp(t, api, token: 't-1');
    await Scrollable.ensureVisible(t.element(find.text(pollText)));
    await t.pump();
    expect(find.text('4 VOTES · CLOSED'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget); // not voted, still shown
    await t.tap(labelled('Vote Standoff'));
    await settle(t);
    expect(api.bodiesOf('POST /v1/posts/p-poll/vote'), isEmpty);
    await done(t);
  });

  testWidgets('vote on a poll: bars show after my vote', (t) async {
    final api = FakeApi();
    await pumpApp(t, api, token: 't-1');
    await Scrollable.ensureVisible(t.element(find.text(pollText)));
    await t.pump();
    expect(find.textContaining('4 VOTES · ENDS IN'), findsOneWidget);
    expect(find.text('75%'), findsNothing); // hidden until I vote
    await t.tap(labelled('Vote Standoff'));
    await settle(t);
    expect(api.bodiesOf('POST /v1/posts/p-poll/vote').single, {'position': 1});
    expect(find.text('5 VOTES · YOU VOTED'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('Standoff  ✓'), findsOneWidget);
    // One final vote: another tap sends nothing.
    await t.tap(labelled('Vote Firing Range'));
    await settle(t);
    expect(api.bodiesOf('POST /v1/posts/p-poll/vote'), hasLength(1));
    await done(t);
  });

  testWidgets('a closed poll says so and refreshes the card', (t) async {
    final api = FakeApi()
      ..fail(
        'POST /v1/posts/p-poll/vote',
        409,
        'poll_closed',
        'This poll has closed.',
      );
    await pumpApp(t, api, token: 't-1');
    await Scrollable.ensureVisible(t.element(find.text(pollText)));
    await t.pump();
    await t.tap(labelled('Vote Standoff'));
    await settle(t);
    expect(find.text('This poll has closed.'), findsOneWidget);
    expect(api.queries, contains('GET /v1/posts/p-poll?'));
    expect(find.text('4 VOTES · CLOSED'), findsOneWidget);
    await done(t);
  });

  testWidgets('apply to a recruitment post', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    await scrollFeedTo(t, find.text('Apply'));
    await tapText(t, 'Apply');
    expect(api.bodiesOf('POST /v1/posts/p-rec/apply'), hasLength(1));
    final h = api.headers.lastWhere(
      (h) => h.$1 == 'POST /v1/posts/p-rec/apply',
    );
    expect(h.$2['Idempotency-Key'] ?? h.$2['idempotency-key'], isNotNull);
    expect(find.text('Applied ✓'), findsOneWidget);
    expect(find.text('Applied — Dave gets a notification'), findsOneWidget);
    expect(
      s.posts.firstWhere((p) => p.id == 'p-rec').recruit!.myApplication,
      ApplicationStatus.pending,
    );
    await done(t);
  });

  testWidgets('a full recruitment post says so and refreshes', (t) async {
    final api = FakeApi()
      ..fail(
        'POST /v1/posts/p-rec/apply',
        409,
        'recruitment_full',
        'This squad is full.',
      );
    api.routes['GET /v1/posts/p-rec'] = post(
      'p-rec',
      dave,
      type: 'recruitment',
      kind: 'recruit',
      text: recruitText,
      recruit: recruitOf(slots: 1, applications: 3),
    );
    await pumpApp(t, api, token: 't-1');
    await scrollFeedTo(t, find.text('Apply'));
    await tapText(t, 'Apply');
    expect(find.text('This squad is full.'), findsOneWidget);
    expect(api.queries, contains('GET /v1/posts/p-rec?'));
    expect(find.text('01'), findsOneWidget); // slots from the refresh
    await done(t);
  });

  testWidgets('a recruit_application alert opens my applications', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.notifs);
    await settle(t);
    s.openRoute('/posts/p-myrec/applications');
    await settle(t);
    expect(s.screen, Screen.home);
    expect(s.sheet, SheetKind.applications);
    expect(
      api.queries,
      contains(startsWith('GET /v1/posts/p-myrec/applications?')),
    );
    final sheet = find.byType(ApplicationsSheet);
    Finder inSheet(String text) =>
        find.descendant(of: sheet, matching: find.text(text));
    expect(inSheet('Hana'), findsOneWidget);
    expect(inSheet('Dave'), findsOneWidget);
    expect(inSheet('2 SLOTS · SNIPER, IGL'), findsOneWidget);
    await t.tap(inSheet('Accept').first);
    await settle(t);
    expect(
      api.sent.any((r) => r.path == '/v1/recruit-applications/ra-1/accept'),
      isTrue,
    );
    expect(inSheet('ACCEPTED'), findsOneWidget);
    expect(find.text('Accepted — Hana can see your gamer ID'), findsOneWidget);
    await t.tap(inSheet('Decline').first);
    await settle(t);
    expect(
      api.sent.any((r) => r.path == '/v1/recruit-applications/ra-2/decline'),
      isTrue,
    );
    expect(inSheet('DECLINED'), findsOneWidget);
    expect(find.text('Declined'), findsOneWidget);
    s.closeSheet();
    await settle(t);
    // The post is on top of Home, marked as mine.
    expect(find.text('Yours · 2 applied'), findsOneWidget);
    await done(t);
  });

  testWidgets('a recruit_accepted alert opens their profile', (t) async {
    final s = await pumpApp(t, FakeApi(), token: 't-1');
    s.openRoute('/players/dave.exe');
    await settle(t);
    expect(find.text('@dave.exe · Addis Ababa'), findsOneWidget);
    await done(t);
  });

  testWidgets('photos open full screen', (t) async {
    await pumpApp(t, FakeApi(), token: 't-1');
    await scrollFeedTo(t, labelled('Photo 2 of 2'));
    await t.tap(labelled('Photo 2 of 2'));
    await settle(t);
    expect(find.text('02/02'), findsOneWidget);
    expect(labelled('Next photo'), findsNothing); // the last one
    await t.tap(labelled('Previous photo'));
    await settle(t);
    expect(find.text('01/02'), findsOneWidget);
    await t.tap(labelled('Next photo'));
    await settle(t);
    expect(find.text('02/02'), findsOneWidget);
    // Swiping works too.
    await t.fling(find.byType(PageView), const Offset(300, 0), 1000);
    await settle(t);
    expect(find.text('01/02'), findsOneWidget);
    await t.tap(labelled('Close photos'));
    await settle(t);
    expect(find.text('01/02'), findsNothing);
    await done(t);
  });

  testWidgets('D35: a failed photo upload says so; the draft stays', (t) async {
    final api = FakeApi()..fail('PUT /upload/1', 503, 'error', 'Unavailable');
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    s.addPhotos(photos(1));
    await t.enterText(find.byType(TextField).first, 'Clutch');
    await t.pump();
    await tapText(t, 'Post');
    expect(
      find.text("A photo didn't upload. Check your connection and try again."),
      findsOneWidget,
    );
    expect(api.bodiesOf('POST /v1/posts'), isEmpty);
    expect(s.cp.photos, hasLength(1));
    await done(t);
  });

  test('D35: slot line plurals', () {
    RecruitDto r(int n, String roles) => RecruitDto(
      (b) => b
        ..slots = n
        ..roles = roles
        ..applications = 0,
    );
    expect(slotsLine(r(1, 'Sniper, IGL')), '1 SLOT · SNIPER, IGL');
    expect(slotsLine(r(3, '')), '3 SLOTS · ANY ROLE');
  });

  testWidgets('D35: accepted shows on my card; an empty applications sheet', (
    t,
  ) async {
    final api = FakeApi();
    final feed = api.routes['GET /v1/feed']! as Map;
    (feed['items'] as List)[2] = post(
      'p-rec',
      dave,
      type: 'recruitment',
      kind: 'recruit',
      text: recruitText,
      recruit: recruitOf(myApplication: 'accepted'),
    );
    api.routes['GET /v1/posts/p-myrec/applications'] = {
      'items': <Object>[],
      'nextCursor': null,
    };
    final s = await pumpApp(t, api, token: 't-1');
    await scrollFeedTo(t, find.text('Accepted ✓'));
    expect(find.text('Accepted ✓'), findsOneWidget);
    s.openRoute('/posts/p-myrec/applications');
    await settle(t);
    expect(
      find.text('No applications yet. They show up here.'),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('Saved tab lists my bookmarks; unsave removes the card', (
    t,
  ) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.goProfileTab();
    await settle(t);
    await tapText(t, 'Saved');
    expect(api.queries, contains(startsWith('GET /v1/me/saved')));
    expect(find.text('Saved: smoke lineups for every map.'), findsOneWidget);
    await t.tap(labelled('Saved'));
    await settle(t);
    expect(
      api.sent.any(
        (r) => r.method == 'DELETE' && r.path == '/v1/posts/p-saved/save',
      ),
      isTrue,
    );
    expect(find.text('Saved: smoke lineups for every map.'), findsNothing);
    expect(
      find.text(
        'Nothing saved yet. Tap the bookmark on a post to keep it here.',
      ),
      findsOneWidget,
    );
    await done(t);
  });

  testWidgets('compose: type, game and audience go out with a key', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.openCompose();
    await settle(t);
    expect(find.text('New post'), findsOneWidget);
    // All 11 types again (round 2).
    expect(find.text('Gameplay'), findsOneWidget);
    expect(find.text('Recruitment'), findsOneWidget);
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

  testWidgets('profile: Posts lists mine, Groups shows my groups', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.goProfileTab();
    await settle(t);
    expect(find.text('YOUR STATUS'), findsOneWidget); // moved from Home
    expect(find.text('GROUPS · 2'), findsOneWidget);
    await tapText(t, 'Posts');
    expect(find.text('Finally hit Legendary in ranked.'), findsOneWidget);
    expect(find.text('GG 12 · 3 comments'), findsOneWidget);
    await tapText(t, 'Groups');
    expect(api.queries, contains(startsWith('GET /v1/me/groups')));
    expect(find.text('CODM Addis'), findsOneWidget);
    expect(find.text('Hawassa Squad'), findsOneWidget);
    expect(find.text('REQUESTED'), findsOneWidget);
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
    s.openPlayer('hanaplays');
    await settle(t);
    await tapText(t, 'Groups');
    expect(find.text('Ethiopian FC Players'), findsOneWidget);
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
            if (screen == Screen.group) s.groupId = 'g-codm';
            if (screen == Screen.createGroup) s.newGroup = GroupDraft();
          });
        }
        await settle(t);
      }
      // The group page's and my profile's tabs.
      for (final id in ['g-codm', 'g-fc']) {
        s.openGroup(id);
        for (final tab in ['Feed', 'Members', 'Events', 'About']) {
          s.setGroupTab(tab);
          await settle(t);
        }
      }
      s.openGroup('g-codm');
      await settle(t);
      s.openEditGroup();
      await settle(t);
      s.goProfileTab();
      for (final tab in ['Groups', 'Posts', 'Moments', 'Saved', 'Overview']) {
        s.update(() => s.ptab = tab);
        await settle(t);
      }
      // Poll, recruitment and photo cards on Home, and the applications sheet.
      s.go(Screen.home);
      await settle(t);
      s.openRoute('/posts/p-myrec/applications');
      await settle(t);
      s.openListingSheet();
      await settle(t);
      expect(find.text('EXPIRES AFTER'), findsOneWidget);
      await done(t);
    });
  }
}
