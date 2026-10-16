// End to end on a device against a local API, with the fixture players
// (dave.exe, hanaplays, yonasjg) and e2e_helper.mjs. See README.md here.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:api_client/api_client.dart';
import 'package:rally/api.dart';
import 'package:rally/main.dart';
import 'package:rally/widgets.dart';

const helper = String.fromEnvironment(
  'E2E_HELPER',
  defaultValue: 'http://localhost:3399',
);
final _helper = Dio(BaseOptions(baseUrl: helper));

/// Against a deployed API there is no helper: the player is made and
/// verified beforehand (their email here, password123, not onboarded), and
/// the steps that need an emailed code or a due check-in are skipped.
const remoteEmail = String.fromEnvironment('E2E_EMAIL');
const remote = remoteEmail != '';

/// Every toast the app showed, for failure messages.
final toasts = <String>[];

Future<String> codeFor(String email) async => (await _helper.get<String>(
  '/code',
  queryParameters: {'email': email},
)).data!;
Future<void> makeCheckInsDue(String email) =>
    _helper.post<String>('/due', queryParameters: {'email': email});

/// Pumps until [f] finds something (network calls are real here).
Future<void> waitFor(
  WidgetTester t,
  Finder f, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await t.pump(const Duration(milliseconds: 200));
    if (f.evaluate().isNotEmpty) return;
  }
  final shown = find
      .byType(Text)
      .evaluate()
      .map(
        (e) =>
            (e.widget as Text).data ??
            (e.widget as Text).textSpan?.toPlainText(),
      )
      .whereType<String>()
      .toSet();
  throw TestFailure(
    'Timed out waiting for $f\nOn screen: ${shown.join(' | ')}\nToasts: ${toasts.join(' | ')}',
  );
}

Future<void> see(WidgetTester t, String text) =>
    waitFor(t, find.textContaining(text));

/// Scrolls [f] into view (building it if a list hasn't yet) and taps it.
Future<void> tapOn(WidgetTester t, Finder f) async {
  if (f.evaluate().isEmpty) {
    final scrollables = find.byType(Scrollable);
    for (
      var i = 0;
      i < scrollables.evaluate().length && f.evaluate().isEmpty;
      i++
    ) {
      try {
        await t.scrollUntilVisible(
          f,
          250,
          scrollable: scrollables.at(i),
          maxScrolls: 30,
        );
      } catch (_) {}
    }
  }
  await waitFor(t, f);
  await Scrollable.ensureVisible(t.element(f.first), alignment: .5);
  await t.pump(const Duration(milliseconds: 300));
  await t.tap(f.first, warnIfMissed: false);
  await t.pump(const Duration(milliseconds: 500));
}

Future<void> tapText(WidgetTester t, String text) => tapOn(t, find.text(text));

/// Types into the text field showing [hint].
Future<void> fill(WidgetTester t, String hint, String value) async {
  final f = find.widgetWithText(TextField, hint);
  await waitFor(t, f);
  await Scrollable.ensureVisible(t.element(f.first), alignment: .5);
  await t.enterText(f.first, value);
  await t.pump(const Duration(milliseconds: 300));
}

/// Lets the keyboard close and the layout settle before the next tap.
Future<void> hideKeyboard(WidgetTester t) async {
  FocusManager.instance.primaryFocus?.unfocus();
  for (var i = 0; i < 5; i++) {
    await t.pump(const Duration(milliseconds: 200));
  }
}

Finder icon(Ic i) => find.byWidgetPredicate((w) => w is SvgIcon && w.icon == i);

Future<void> nav(WidgetTester t, String tab) => tapText(t, tab);

Future<void> logout(WidgetTester t) async {
  await nav(t, 'YOU');
  await tapText(t, 'Log out');
  await tapText(t, 'Log in');
}

/// Logs in with an email or a username.
Future<void> login(WidgetTester t, String email) async {
  await see(t, 'Welcome back.');
  await fill(t, 'Email or username', email);
  await t.enterText(find.byType(TextField).at(1), 'password123');
  await tapText(t, 'Log in');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'a new player: sign up, go live, post, connect, play, check in, stay safe',
    (t) async {
      final stamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
      final email = remote ? remoteEmail : 'e2e.$stamp@rally.test';
      final handle = remote ? 'gn_mobile' : 'e2e_$stamp';
      const name = 'Tester';

      await t.pumpWidget(
        RallyApp(
          api: Api(appVersion: '1.0.0', store: MemoryTokenStore()),
        ),
      );
      final app = t.state<RallyAppState>(find.byType(RallyApp)).state;
      app.addListener(() {
        final m = app.toastMsg;
        if (m != null && (toasts.isEmpty || toasts.last != m)) toasts.add(m);
      });
      await see(t, 'Who are you as a gamer?');

      // ---- sign up and confirm the email ----
      await tapText(t, 'Log in');
      if (remote) {
        await login(t, email);
      } else {
        await tapText(t, 'Create a profile');
        await fill(t, 'you@example.com', email);
        await fill(t, 'Kaleb', name);
        await fill(t, 'kaleb.gg', handle);
        await fill(t, 'At least 8 characters', 'password123');
        await tapText(t, 'Continue');
        await see(t, 'Check your');
        await fill(t, '123456', '000000');
        await tapText(t, 'Confirm email');
        await see(t, 'That code didn');
        await fill(t, '123456', await codeFor(email));
        await tapText(t, 'Confirm email');
      }
      await see(t, 'What do you play?');

      // ---- onboarding: games, ranks, platforms and IDs ----
      await fill(t, 'Search 49+ games', 'codm');
      await tapText(t, 'CoD Mobile');
      await fill(t, 'Search 49+ games', 'efoot');
      await tapText(t, 'eFootball');
      await tapText(t, 'Continue with 2 games');
      await see(t, 'Your ranks.');
      await tapText(t, 'Master');
      await tapText(t, 'Continue');
      await see(t, 'Platforms');
      await tapText(t, 'Mobile');
      await tapText(t, 'Competitive');
      await t.enterText(
        find.widgetWithText(TextField, 'Add ID').at(1),
        '$handle#disc',
      ); // Discord
      await tapText(t, 'Go live');
      await see(t, 'Profile live — welcome, $name');
      await see(t, 'YOUR STATUS');

      // ---- post a listing ----
      await tapText(t, 'Post a listing');
      await see(t, 'Looking for players');
      await tapText(t, 'Squad');
      await tapOn(t, find.textContaining('Post listing ·'));
      await see(t, 'Listing live');
      await see(t, 'YOUR LIVE LISTING');

      // ---- fix the listing without reposting it (PATCH /listings/{id}) ----
      final posted = (await app.api.listings.myListingGet()).data!.listing!;
      await tapText(t, 'Edit');
      await see(t, 'Edit your listing');
      await tapText(t, 'Mic optional');
      await fill(
        t,
        'Looking for a ranked duo tonight.',
        'Chill squad, no rage',
      );
      await hideKeyboard(t);
      await tapText(t, 'Save changes');
      await see(t, 'Listing updated');
      final edited = (await app.api.listings.myListingGet()).data!.listing!;
      expect(edited.id, posted.id);
      expect(edited.voice, Voice.optional);
      expect(edited.note, 'Chill squad, no rage');
      expect(edited.shareUrl, posted.shareUrl);

      // ---- find players: connect from a listing ----
      await nav(t, 'PLAYERS');
      await see(t, 'PLAYERS LOOKING');
      await see(t, 'Yonas');
      final yonasCard = find
          .ancestor(of: find.text('Yonas'), matching: find.byType(InkBox))
          .first;
      await tapOn(
        t,
        find.descendant(of: yonasCard, matching: find.text('Connect')),
      );
      await see(t, 'Request sent to');
      await see(t, 'Requested…');

      // ---- search, a profile, connect and report ----
      await tapOn(t, icon(Ic.search));
      await fill(t, 'Gamers by name or username', 'dav');
      await tapText(t, 'Dave');
      await see(t, '@dave.exe');
      await tapText(t, 'Connect');
      await see(t, 'Request sent to Dave');
      await see(t, 'Requested…');

      // ---- withdraw from the profile (outgoingRequestId), then ask again ----
      await tapText(t, 'Requested…');
      await tapText(t, 'Withdraw');
      await see(t, 'Request to Dave withdrawn');
      final out = (await app.api.connections.connectionRequestsList(
        direction: 'outgoing',
      )).data!.items;
      expect(out.where((r) => r.to.username == 'dave.exe'), isEmpty);
      await tapText(t, 'Connect');
      await see(t, 'Request sent to Dave');
      await see(t, 'Requested…');
      await tapOn(t, icon(Ic.more));
      await tapText(t, 'Report');
      await tapText(t, 'Spam');
      await tapText(t, 'Send report');
      await see(t, 'Thanks. Our team will look at it.');

      // ---- groups waitlist ----
      await nav(t, 'GROUPS');
      await tapText(t, 'Notify me');
      await see(t, 'You’re on the list ✓');
      expect((await app.api.me.meGet()).data!.waitlist, contains('groups'));

      // ---- edit profile ----
      await nav(t, 'YOU');
      await tapText(t, 'Edit profile');
      await fill(
        t,
        'What do you play, and who are you looking for?',
        'Ranked CODM most nights.',
      );
      await tapText(t, 'Save');
      await see(t, 'Profile updated');
      await see(t, 'Ranked CODM most nights.');

      // ---- Dave accepts and invites them to play ----
      await logout(t);
      await login(t, 'dave.exe'); // a username works as well as an email
      await see(t, 'YOUR STATUS');
      await tapOn(t, icon(Ic.bell));
      await see(t, 'CONNECTION REQUESTS');
      await see(t, name);
      await tapText(t, 'Accept');
      await see(t, 'Connected with $name');
      await tapOn(t, icon(Ic.search));
      await fill(t, 'Gamers by name or username', handle);
      await tapText(t, name);
      await see(t, 'Connected ✓');
      await see(
        t,
        '$handle#disc',
      ); // their connections-only Discord is visible now
      await tapText(t, 'Play together');
      await tapText(t, 'Now');
      await tapText(t, 'Send session invite');
      await see(t, 'Invite sent');

      // ---- the invite on Home, then the check-in ----
      await logout(t);
      await login(t, email);
      await see(t, 'PLAY INVITE');
      // Groups still remembers the waitlist after signing back in.
      await nav(t, 'GROUPS');
      await see(t, 'You’re on the list ✓');
      await nav(t, 'HOME');
      await see(t, 'PLAY INVITE');
      await tapText(t, 'I’m in');
      await see(t, 'You’re on');
      if (!remote) {
        await makeCheckInsDue(email);
        await tapText(t, 'PLAYERS');
        await nav(t, 'HOME');
        await see(t, 'Did you play with Dave?');
        await tapText(t, 'Yes, we played');
        await see(t, 'GG — glad you played');
      }

      // ---- close the listing ----
      await tapText(t, 'Close listing');
      await see(t, 'Listing closed');

      // ---- block and unblock ----
      await nav(t, 'PLAYERS');
      await tapOn(t, icon(Ic.search));
      await fill(t, 'Gamers by name or username', 'hana');
      await tapText(t, 'Hana');
      await see(t, '@hanaplays');
      await tapOn(t, icon(Ic.more));
      await tapText(t, 'Block Hana');
      await tapText(t, 'Block');
      await see(t, 'Hana is blocked');
      await tapOn(
        t,
        find.byType(BackBtn),
      ); // blocking leaves her profile for Search
      await nav(t, 'YOU');
      await tapText(t, 'Blocked users');
      await see(t, '@hanaplays');
      await tapText(t, 'Unblock');
      await see(t, 'Hana unblocked');

      // ---- forgot password ----
      await tapOn(t, find.byType(BackBtn));
      var password = 'password123';
      if (!remote) {
        await tapText(t, 'Log out');
        await tapText(t, 'Log in');
        await tapText(t, 'Forgot password?');
        await fill(t, 'Email', email);
        await tapText(t, 'Email me a code');
        await see(t, 'New password.');
        await fill(t, '6-digit code', await codeFor(email));
        await fill(t, 'New password, 8+ characters', 'password456');
        await tapText(t, 'Set password and log in');
        await see(t, 'Password changed');
        await see(t, 'YOUR STATUS');
        password = 'password456';
      }

      // ---- delete the account ----
      await nav(t, 'YOU');
      await tapText(t, 'Delete account');
      await fill(t, 'Your password', password);
      await tapText(t, 'Delete');
      await see(t, 'Account deleted');
    },
  );
}
