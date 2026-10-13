import 'package:flutter/material.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Groups are "coming soon" in the MVP (docs/PRD.md): a waitlist tells us
/// which groups to launch first.
class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      child: Gap(
        14,
        children: [
          InkBox.dark(
            radius: 26,
            padding: const EdgeInsets.all(18),
            child: Gap(
              12,
              children: [
                Text(t.up('COMING SOON'), style: t.label(9, c: t.accentText)),
                Text(
                  'Your squad, your game, your city or campus.',
                  style: t.body(22, w: w800, ls: -.6, h: 1.1, c: t.onDark),
                ),
                Text(
                  'Groups for scrims, LAN days and campus tournaments are on the way. Tap below and we’ll tell you the day they open.',
                  style: t.body(14, h: 1.4, c: t.onDark.withValues(alpha: .85)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: s.notify
                      ? Pill(
                          'You’re on the list ✓',
                          height: 42,
                          padH: 16,
                          size: 14,
                          weight: w700,
                          bg: t.strong,
                          fg: t.onStrong,
                        )
                      : Pill(
                          'Notify me',
                          onTap: s.busy ? null : s.joinWaitlist,
                          height: 42,
                          padH: 16,
                          size: 14,
                          weight: w700,
                          bg: t.accent,
                          fg: t.onAccent,
                          leading: SvgIcon(
                            Ic.bell,
                            size: 16,
                            color: t.onAccent,
                          ),
                        ),
                ),
              ],
            ),
          ),
          const EmptyNote(
            'Until then, Find Players is the fastest way to build your squad.',
          ),
          Center(
            child: Pill(
              'Find players',
              onTap: () => s.go(Screen.find),
              height: 42,
              padH: 18,
              size: 14,
              weight: w700,
              shadow: 3,
            ),
          ),
        ],
      ),
    );
  }
}
