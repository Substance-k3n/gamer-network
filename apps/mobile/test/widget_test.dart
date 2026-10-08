import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rally/main.dart';
import 'package:rally/shell.dart';
import 'package:rally/state.dart';
import 'package:rally/theme.dart';
import 'package:rally/widgets.dart';

Future<void> loadFonts() async {
  List<String> f(String file, List<String> weights) => [for (final w in weights) 'assets/fonts/$file-$w.ttf'];
  final fonts = {
    'Outfit': f('Outfit', ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']),
    'Silkscreen': f('Silkscreen', ['Regular']),
    'DSEG7': ['assets/fonts/DSEG7Classic-Bold.ttf'],
    'Doto': f('Doto', ['Black']),
    'Space Grotesk': f('SpaceGrotesk', ['Regular', 'Medium', 'SemiBold', 'Bold']),
    'Space Mono': f('SpaceMono', ['Regular', 'Bold']),
    'Plus Jakarta Sans': f('PlusJakartaSans', ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']),
    'Manrope': f('Manrope', ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']),
  };
  for (final e in fonts.entries) {
    final loader = FontLoader(e.key);
    for (final file in e.value) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }
}

Future<void> pumpApp(WidgetTester t, {Screen start = Screen.landing, Size size = const Size(390, 844), String? theme, void Function(String)? persist}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(RallyApp(key: UniqueKey(), start: start, themeId: theme, persistTheme: persist));
  await t.pump();
}

/// Drains timers (toasts, auto-accept) so the test ends cleanly.
Future<void> settle(WidgetTester t) async {
  await t.pump(const Duration(seconds: 5));
  await t.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 2));
}

Future<void> tapText(WidgetTester t, String text) async {
  // Centre it, so floating bars at the edges don't cover it.
  await Scrollable.ensureVisible(t.element(find.text(text).first), alignment: .5);
  await t.pump(); // lay out the scroll before reading the tap position
  await t.tap(find.text(text).first);
  await t.pump(const Duration(milliseconds: 400));
  await t.pump(const Duration(milliseconds: 400)); // let entry animations finish
}

Finder icon(Ic i) => find.byWidgetPredicate((w) => w is SvgIcon && w.icon == i);

RallyTheme activeTheme(WidgetTester t) => Theme.of(t.element(find.byType(RallyShell))).extension<RallyTheme>()!;

void main() {
  setUpAll(loadFonts);

  for (final size in const [Size(390, 844), Size(360, 740)]) {
    testWidgets('new-user journey at ${size.width.toInt()}w', (t) async {
      await pumpApp(t, size: size);
      expect(find.text('Who are you as a gamer?'), findsOneWidget);
      await tapText(t, 'Next');
      await tapText(t, 'Next');
      await tapText(t, 'Start');
      expect(find.text('Welcome back.'), findsOneWidget); // Start lands on log in
      await tapText(t, 'Create a profile');
      expect(find.text('Who are you\nas a gamer?'), findsOneWidget);
      await t.enterText(find.byType(TextField).at(0), 'kaleb@example.com');
      await t.enterText(find.byType(TextField).at(3), 'hunter2hunter2');
      await t.pump();
      await tapText(t, 'Continue');
      expect(find.text('What do you play?'), findsOneWidget);
      await t.enterText(find.byType(TextField).first, 'mine');
      await t.pump();
      await tapText(t, 'Minecraft');
      await tapText(t, 'Continue with 3 games');
      expect(find.text('Your ranks.'), findsOneWidget);
      await tapText(t, 'Creative');
      await tapText(t, 'Continue');
      await tapText(t, 'Go live');
      expect(find.text('Profile live — welcome, Kaleb'), findsOneWidget);
      expect(find.text('For you'), findsOneWidget); // feed filter button
      await settle(t);
    });
  }

  testWidgets('sign-up validates fields and the password eye toggles', (t) async {
    await pumpApp(t, start: Screen.signup);
    await tapText(t, 'Continue');
    expect(find.text('Enter a valid email'), findsOneWidget);
    await t.enterText(find.byType(TextField).at(0), 'kaleb@example.com');
    await t.enterText(find.byType(TextField).at(3), 'short');
    await t.pump(const Duration(seconds: 3));
    await tapText(t, 'Continue');
    expect(find.text('Password needs at least 8 characters'), findsOneWidget);
    TextField pw() => t.widget<TextField>(find.byType(TextField).at(3));
    expect(pw().obscureText, isTrue);
    await t.tap(icon(Ic.eye));
    await t.pump();
    expect(pw().obscureText, isFalse);
    await settle(t);
  });

  testWidgets('game picker searches, filters and adds a custom game', (t) async {
    await pumpApp(t, start: Screen.games);
    await t.enterText(find.byType(TextField).first, 'mlbb');
    await t.pump();
    expect(find.text('Mobile Legends: Bang Bang'), findsOneWidget);
    expect(find.text('Valorant'), findsNothing);
    await tapText(t, 'Mobile Legends: Bang Bang');
    expect(find.text('Continue with 3 games'), findsOneWidget);
    await t.enterText(find.byType(TextField).first, 'Hollow Knight Silksong');
    await t.pump();
    await tapText(t, 'Add “Hollow Knight Silksong” as your own game');
    await tapText(t, 'Add game');
    expect(find.text('Continue with 4 games'), findsOneWidget);
    await tapText(t, 'Continue with 4 games');
    expect(find.text('Hollow Knight Silksong'), findsOneWidget);
    expect(find.text('Your rank or level (optional)'), findsOneWidget);
    await tapText(t, 'Mythical Glory');
    await settle(t);
  });

  testWidgets('edit profile saves changes and asks before discarding', (t) async {
    await pumpApp(t, start: Screen.profile);
    await tapText(t, 'Edit profile');
    expect(find.text('Edit profile'), findsOneWidget);
    // Discard prompt when leaving with changes.
    await t.enterText(find.byType(TextField).at(0), 'Kal');
    await t.pump();
    await t.tap(find.text('×').first);
    await t.pump(const Duration(milliseconds: 300));
    expect(find.text('Discard changes?'), findsOneWidget);
    await tapText(t, 'Keep editing');
    // Change rank, add a game from the picker sheet, save.
    await tapText(t, 'Diamond');
    await tapText(t, 'Add or change games');
    await t.enterText(find.byType(TextField).last, 'rocket');
    await t.pump();
    await tapText(t, 'Rocket League');
    await tapText(t, 'Done');
    expect(find.text('Rocket League'), findsOneWidget);
    await tapText(t, 'Save');
    expect(find.text('Profile updated'), findsOneWidget);
    expect(find.text('Kal'), findsWidgets);
    expect(find.text('Rocket League'), findsOneWidget); // on the profile's games list
    expect(find.text('Diamond'), findsOneWidget);
    await settle(t);
  });

  testWidgets('find players → connect → play together', (t) async {
    await pumpApp(t, start: Screen.find);
    expect(find.text('05 PLAYERS LOOKING'), findsOneWidget);
    await tapText(t, 'Connect');
    expect(find.text('Requested…'), findsOneWidget);
    await t.pump(const Duration(seconds: 4));
    expect(find.text('Connected ✓'), findsWidgets);
    await tapText(t, 'Dave');
    await tapText(t, 'Play together');
    await tapText(t, 'Send session invite');
    expect(find.text('SESSION INVITE SENT'), findsOneWidget);
    await settle(t);
  });

  testWidgets('compose a poll and vote on the feed', (t) async {
    await pumpApp(t, start: Screen.home);
    await t.tap(icon(Ic.plus));
    await t.pump(const Duration(milliseconds: 400));
    expect(find.text('New post'), findsOneWidget);
    await tapText(t, 'Poll');
    await t.enterText(find.byType(TextField).first, 'Best map?');
    await t.enterText(find.byType(TextField).at(1), 'Ascent');
    await t.enterText(find.byType(TextField).at(2), 'Bind');
    await t.pump();
    await tapText(t, 'Post');
    expect(find.text('Best map?'), findsOneWidget);
    await tapText(t, 'Ascent');
    expect(find.textContaining('YOU VOTED'), findsOneWidget);
    await settle(t);
  });

  testWidgets('feed filter, save, comments and alerts', (t) async {
    await pumpApp(t, start: Screen.home);
    // Filter to LFG posts only.
    await tapText(t, 'For you');
    await tapText(t, 'LFG & recruiting');
    expect(find.textContaining('Recruiting for our CODM team'), findsOneWidget);
    expect(find.textContaining('Finally reached Diamond'), findsNothing);
    await tapText(t, 'LFG & recruiting');
    await tapText(t, 'For you');

    await t.tap(icon(Ic.bookmark).first);
    await t.pump(const Duration(milliseconds: 300));
    expect(find.text('Saved to your bookmarks'), findsOneWidget);

    await t.tap(icon(Ic.comment).first);
    await t.pump(const Duration(milliseconds: 300));
    await t.enterText(find.byType(TextField).last, 'gg wp');
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pump();
    // Field clears on send, so the only match is the posted comment.
    expect(find.text('gg wp'), findsOneWidget);
    expect(find.text('Kaleb (you)'), findsOneWidget);

    await t.tap(icon(Ic.bell));
    await t.pump(const Duration(milliseconds: 400));
    expect(find.text('CONNECTION REQUESTS'), findsOneWidget);
    await tapText(t, 'Accept');
    expect(find.text('Connected with Hana'), findsOneWidget);
    await settle(t);
  });

  testWidgets('search, groups and profile tabs', (t) async {
    await pumpApp(t, start: Screen.search);
    await t.enterText(find.byType(TextField), 'league');
    await t.pump();
    expect(find.text('Yonas'), findsOneWidget);
    await pumpApp(t, start: Screen.profile);
    for (final tab in ['Games', 'Groups', 'Posts', 'Moments', 'Connections']) {
      await tapText(t, tab);
    }
    await settle(t);
  });

  testWidgets('groups: join, members, profiles, approval and leave', (t) async {
    await pumpApp(t, start: Screen.communities);
    expect(find.text('Valorant Ethiopia'), findsOneWidget);
    await tapText(t, 'Ethiopian FC Players');
    expect(find.text('OPEN TO EVERYONE'), findsOneWidget);
    await tapText(t, 'Join');
    expect(find.text('You joined Ethiopian FC Players'), findsOneWidget);
    // Members open profiles; the profile lists the group.
    await tapText(t, 'Members');
    expect(find.text('Kaleb (you)'), findsOneWidget);
    await tapText(t, 'Hana');
    expect(find.text('@hanaplays · Addis Ababa'), findsOneWidget);
    await tapText(t, 'Groups');
    expect(find.text('Ethiopian FC Players'), findsOneWidget);
    // Back to the group, then leave it.
    await tapText(t, 'Ethiopian FC Players');
    await tapText(t, 'Joined ✓');
    await tapText(t, 'Leave');
    expect(find.text('You left Ethiopian FC Players'), findsOneWidget);
    // Approval-only group: request, then auto-approve.
    await pumpApp(t, start: Screen.communities);
    await tapText(t, 'Ask to join');
    expect(find.text('Requested…'), findsOneWidget);
    await t.pump(const Duration(seconds: 4));
    expect(find.text('Joined ✓'), findsWidgets);
    await settle(t);
  });

  testWidgets('create a group, post and add an event', (t) async {
    await pumpApp(t, start: Screen.communities);
    await tapText(t, 'Create group');
    expect(find.text('New group'), findsOneWidget);
    await tapText(t, 'Create');
    expect(find.text('Give your group a name (3+ characters)'), findsOneWidget);
    await t.enterText(find.byType(TextField).first, 'Bole Duo Queue');
    await t.pump(const Duration(seconds: 3));
    await tapText(t, 'Create');
    expect(find.text('Bole Duo Queue is live — invite your squad'), findsOneWidget);
    expect(find.text('YOU’RE ADMIN'), findsOneWidget);
    await tapText(t, 'Feed');
    await t.enterText(find.byType(TextField).first, 'First scrim Friday!');
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pump();
    expect(find.text('First scrim Friday!'), findsOneWidget);
    await tapText(t, 'Events');
    await tapText(t, 'New event');
    await t.enterText(find.byType(TextField).last, 'Scrim night');
    await tapText(t, 'Add event');
    expect(find.text('Scrim night'), findsOneWidget);
    expect(find.text('Going ✓'), findsOneWidget);
    await settle(t);
  });

  testWidgets('theme picker switches and persists the skin', (t) async {
    final saved = <String>[];
    await pumpApp(t, start: Screen.profile, persist: saved.add);
    expect(activeTheme(t).id, 'inked');
    expect(find.text('APP THEME'), findsOneWidget);
    for (final name in ['Dot matrix', 'Glass', 'Soft clay', 'Inked']) {
      await tapText(t, name);
      await t.pump(const Duration(milliseconds: 400)); // theme blend
      expect(activeTheme(t).name, name);
    }
    expect(saved, ['dot', 'glass', 'soft', 'inked']);
    // A saved choice is restored on launch.
    await pumpApp(t, start: Screen.home, theme: 'glass');
    expect(activeTheme(t).id, 'glass');
    await settle(t);
  });

  // Each skin has its own fonts, so text widths differ: render every screen
  // in every skin at a small phone width and fail on any layout overflow.
  for (final th in rallyThemes) {
    testWidgets('every screen lays out in ${th.name}', (t) async {
      for (final s in Screen.values) {
        await pumpApp(t, start: s, theme: th.id, size: const Size(360, 740));
        await t.pump(const Duration(milliseconds: 500));
      }
      await pumpApp(t, start: Screen.profile, theme: th.id, size: const Size(360, 740));
      await tapText(t, 'Edit profile');
      await tapText(t, 'Add or change games');
      expect(find.text('Your games'), findsOneWidget);
      await settle(t);
    });
  }
}
