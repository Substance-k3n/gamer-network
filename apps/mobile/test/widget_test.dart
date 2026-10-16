import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
    expect(find.text('YOUR STATUS'), findsOneWidget);
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
    expect(find.text('YOUR STATUS'), findsOneWidget);
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
    expect(find.text('YOUR STATUS'), findsOneWidget);
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
    expect(find.text('YOUR STATUS'), findsOneWidget);
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

  testWidgets('groups remembers the waitlist after a restart', (t) async {
    final api = FakeApi();
    api.routes['GET /v1/me'] = me(waitlist: ['groups']);
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await t.pump();
    expect(find.text('You’re on the list ✓'), findsOneWidget);
    expect(find.text('Notify me'), findsNothing);
    await done(t);
  });

  testWidgets('groups waitlist and a report from a profile', (t) async {
    final api = FakeApi();
    final s = await pumpApp(t, api, token: 't-1');
    s.go(Screen.communities);
    await t.pump();
    await tapText(t, 'Notify me');
    expect(api.bodiesOf('POST /v1/waitlist').single, {'topic': 'groups'});
    expect(find.text('You’re on the list ✓'), findsOneWidget);
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

  testWidgets('theme picker switches and persists the skin', (t) async {
    final saved = <String>[];
    await pumpApp(t, FakeApi(), token: 't-1', persist: saved.add);
    await t.tap(find.byType(Avatar).first); // top bar → You
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
          });
        }
        await settle(t);
      }
      s.goProfileTab();
      await settle(t);
      s.openListingSheet();
      await settle(t);
      expect(find.text('EXPIRES AFTER'), findsOneWidget);
      await done(t);
    });
  }
}
