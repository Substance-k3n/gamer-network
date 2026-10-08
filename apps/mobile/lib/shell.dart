import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'screens/compose.dart';
import 'screens/edit_profile.dart';
import 'screens/find.dart';
import 'screens/groups.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/profile.dart';
import 'state.dart';
import 'theme.dart';
import 'widgets.dart';

const _titles = {Screen.find: ('Find Players', 'WHO’S UP'), Screen.communities: ('Groups', ''), Screen.notifs: ('Alerts', '')};

class RallyShell extends StatelessWidget {
  const RallyShell({super.key});

  Widget _body(Screen s) => switch (s) {
    Screen.landing => const LandingScreen(),
    Screen.login => const LoginScreen(),
    Screen.signup => const SignupScreen(),
    Screen.games => const GamesScreen(),
    Screen.ranks => const RanksScreen(),
    Screen.platforms => const PlatformsScreen(),
    Screen.editProfile => const EditProfileScreen(),
    Screen.home => const HomeScreen(),
    Screen.compose => const ComposeScreen(),
    Screen.find => const FindScreen(),
    Screen.communities => const CommunitiesScreen(),
    Screen.group => const GroupScreen(),
    Screen.createGroup => const CreateGroupScreen(),
    Screen.notifs => const NotifsScreen(),
    Screen.profile => const ProfileScreen(),
    Screen.search => const SearchScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final mq = MediaQuery.of(context);
    final keyboard = mq.viewInsets.bottom > 0;
    final bottom = mq.padding.bottom;
    final title = _titles[s.screen];
    final overlay = t.brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !s.handleBack()) SystemNavigator.pop();
      },
      child: AnnotatedRegion(
        value: overlay.copyWith(statusBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageBackground(
            child: Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      if (title != null) _Header(title.$1, title.$2),
                      Expanded(
                        // Fresh scroll position whenever the page (or viewed player) changes.
                        child: KeyedSubtree(key: ValueKey('${s.screen}-${s.viewing}'), child: _body(s.screen)),
                      ),
                    ],
                  ),
                ),
                if (s.screen == Screen.find && !keyboard)
                  Positioned(
                    right: 18,
                    bottom: 98 + bottom,
                    child: Pill(
                      'Post a listing',
                      onTap: s.openListingSheet,
                      height: 52,
                      padH: 20,
                      size: 15,
                      weight: w700,
                      bg: t.accent,
                      fg: t.onAccent,
                      shadow: 4,
                      leading: Text('+', style: t.body(22, h: 1, c: t.onAccent)),
                    ),
                  ),
                if (mainScreens.contains(s.screen) && !keyboard) Positioned(left: 14, right: 14, bottom: 18 + bottom, child: const _NavBar()),
                if (s.sheet != null) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: s.closeSheet,
                      child: ColoredBox(color: Colors.black.withValues(alpha: t.brightness == Brightness.dark ? .55 : .4)),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8 + bottom,
                    child: _Sheet(key: ValueKey(s.sheet)),
                  ),
                ],
                Positioned(
                  top: mq.padding.top + 6,
                  left: 16,
                  right: 16,
                  // Toasts are informational; let taps reach what's underneath.
                  child: IgnorePointer(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, a) => FadeTransition(
                        opacity: a,
                        child: SlideTransition(
                          position: Tween(begin: const Offset(0, -.4), end: Offset.zero).animate(a),
                          child: child,
                        ),
                      ),
                      child: s.toastMsg == null ? const SizedBox.shrink() : _Toast(s.toastMsg!, key: ValueKey(s.toastMsg)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Toast extends StatelessWidget {
  const _Toast(this.msg, {super.key});
  final String msg;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final r = BorderRadius.circular(18);
    return Frost(
      radius: r,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: t.glass ? t.popover : t.dark, borderRadius: r, boxShadow: t.glow()),
        child: Row(
          children: [
            Dot(t.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: t.body(14, w: w500, c: t.onDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title, this.sub);
  final String title, sub;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Row(
        children: [
          if (s.screen == Screen.notifs) ...[BackBtn(onTap: () => s.go(Screen.home), size: 40), const SizedBox(width: 10)],
          // Title and caption share one flexible slot so the title only
          // truncates when it truly can't fit.
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.body(28, w: w800, ls: -1),
                  ),
                ),
                const SizedBox(width: 10),
                Label(sub),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CircleBtn(shadow: 3, onTap: s.goSearch, child: const SvgIcon(Ic.search)),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    // Viewing someone else's profile isn't the "You" tab.
    final tab = s.screen == Screen.profile && s.viewing != null ? null : s.screen;
    Widget item(Screen target, Ic icon, String label, VoidCallback go) {
      final on = tab == target;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: go,
        child: SizedBox(
          width: 62,
          height: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: on ? t.accent : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                child: SvgIcon(icon, color: on ? t.onAccent : t.onDark),
              ),
              const SizedBox(height: 3),
              Opacity(
                opacity: on ? 1 : .55,
                child: Text(t.up(label), style: t.label(7, c: t.onDark)),
              ),
            ],
          ),
        ),
      );
    }

    final r = BorderRadius.circular(33);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: r, boxShadow: t.floatShadows),
      child: Frost(
        radius: r,
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: t.dark, borderRadius: r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item(Screen.home, Ic.home, 'HOME', () => s.go(Screen.home)),
              item(Screen.find, Ic.target, 'PLAYERS', () => s.go(Screen.find)),
              item(Screen.communities, Ic.groups, 'GROUPS', () => s.go(Screen.communities)),
              item(Screen.profile, Ic.user, 'YOU', s.goProfileTab),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for posting a listing or inviting a connection to play.
class _Sheet extends StatefulWidget {
  const _Sheet({super.key});

  @override
  State<_Sheet> createState() => _SheetState();
}

class _SheetState extends State<_Sheet> with SingleTickerProviderStateMixin {
  late final _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 260))..forward();

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final listing = s.sheet == SheetKind.listing;
    final d = s.draft;
    final ss = s.sess;
    final p = s.viewing != null ? players[s.viewing] : null;

    Widget group(String label, List<String> opts, String Function(String) labelOf, String value, void Function(String) set) => Gap(
      6,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: Label(label)),
        Wrap(spacing: 6, runSpacing: 6, children: [for (final o in opts) Pill.chip(labelOf(o), value == o, () => s.update(() => set(o)), height: 36, padH: 14, size: 14)]),
      ],
    );

    final groups = listing
        ? [
            group('GAME', s.myGames.isNotEmpty ? s.myGames : const ['val'], (id) => gameById(id).name, d.game, (v) => d.game = v),
            group('MODE', const ['Ranked', 'Unrated', 'Casual'], (x) => x, d.mode, (v) => d.mode = v),
            group('LOOKING FOR', const ['Duo', 'Trio', 'Squad', '5-stack'], (x) => x, d.want, (v) => d.want = v),
            group('VOICE', const ['Required', 'Optional'], (x) => x, d.voice, (v) => d.voice = v),
            group('WHEN', const ['Now', 'Tonight', 'Weekend'], (x) => x, d.when, (v) => d.when = v),
            group('EXPIRES AFTER', const ['2h', '6h', '24h'], (x) => x, d.dur, (v) => d.dur = v),
          ]
        : [
            group('GAME', [for (final g in p?.games ?? const <PlayerGame>[]) g.id], (id) => gameById(id).name, ss.game, (v) => ss.game = v),
            group('WHEN', const ['Now', 'In 30 min', 'Tonight 21:00'], (x) => x, ss.when, (v) => ss.when = v),
          ];

    final r = BorderRadius.circular(36);
    return SlideTransition(
      position: Tween(begin: const Offset(0, .25), end: Offset.zero).animate(CurvedAnimation(parent: _a, curve: Curves.easeOutCubic)),
      child: FadeTransition(
        opacity: _a,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - MediaQuery.paddingOf(context).top - 40),
          child: Frost(
            radius: r,
            child: Container(
              decoration: BoxDecoration(color: t.glass ? t.popover : t.surface, border: t.border(), borderRadius: r),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Gap(
                  10,
                  children: [
                    Center(
                      child: Opacity(
                        opacity: .3,
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(color: t.text, borderRadius: BorderRadius.circular(3)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(listing ? 'Looking for players' : 'Play with ${p?.name ?? ''}', style: t.body(24, w: w800, ls: -.8)),
                        ),
                        CloseBtn(onTap: s.closeSheet, size: 36, fontSize: 16, transparent: true),
                      ],
                    ),
                    ...groups,
                    if (listing)
                      Gap(
                        6,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 2), child: Label('NOTE')),
                          BoxField(value: d.note, hint: 'Looking for a ranked duo tonight.', height: 48, radius: 16, padH: 14, size: 15, sunken: true, onChanged: (v) => d.note = v),
                        ],
                      ),
                    const SizedBox(height: 0),
                    BigButton(listing ? 'Post listing · expires in ${d.dur}' : 'Send session invite', onTap: listing ? s.submitListing : s.submitSession, height: 54, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
