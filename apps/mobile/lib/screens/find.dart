import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Resolves a connection-button look against the active skin.
(Color, Color) lookColors(RallyTheme t, Look l) => switch (l) {
      Look.strong => (t.strong, t.onStrong),
      Look.quiet => (t.grey, t.text),
      Look.accent => (t.accent, t.onAccent),
    };

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  String _fmt(Duration d) {
    final s = d.isNegative ? 0 : d.inSeconds;
    return '${pad2(s ~/ 3600)}:${pad2(s % 3600 ~/ 60)}:${pad2(s % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    const filterIds = ['all', 'val', 'fc', 'lol', 'codm', 'mc'];
    final toggles = <(String, bool, VoidCallback)>[
      ('Mic on', s.fMic, () => s.update(() => s.fMic = !s.fMic)),
      ('Tonight', s.fTonight, () => s.update(() => s.fTonight = !s.fTonight)),
      ('Competitive', s.fComp, () => s.update(() => s.fComp = !s.fComp)),
    ];
    // Countdowns tick every second; only this subtree rebuilds.
    return ValueListenableBuilder(
      valueListenable: s.now,
      builder: (context, now, _) {
        final filtered = s.live
            .where((l) =>
                (s.filterGame == 'all' || l.game == s.filterGame) &&
                (!s.fMic || l.mic) &&
                (!s.fTonight || l.when == 'Tonight' || l.when == 'Now') &&
                (!s.fComp || l.mode == 'Ranked'))
            .toList();
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Gap(12, children: [
            ChipScroller(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final id in filterIds)
                  Pill.chip(id == 'all' ? 'All games' : gameById(id).name, s.filterGame == id, () => s.update(() => s.filterGame = id), height: 38, padH: 15, size: 14),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(spacing: 6, runSpacing: 6, children: [
                for (final (label, on, tap) in toggles)
                  Pill(
                    label,
                    onTap: tap,
                    height: 32,
                    padH: 12,
                    radius: 10,
                    bg: on ? t.soft : Colors.transparent,
                    leading: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: on ? t.strong : Colors.transparent, border: Border.all(color: t.text, width: 1.5), borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Label('${pad2(filtered.length)} PLAYERS LOOKING'),
                const Flexible(child: Label('LISTINGS EXPIRE AUTOMATICALLY')),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Gap(14, children: [
                if (filtered.isEmpty) const EmptyNote('No one matches these filters right now. Post a listing and let them find you.'),
                for (final l in filtered) _ListingCard(l, left: _fmt(l.exp.difference(now)), key: ValueKey(l.id)),
              ]),
            ),
          ]),
        );
      },
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard(this.l, {super.key, required this.left});
  final Listing l;
  final String left;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final mine = l.pid == 'me';
    final p = players[l.pid];
    final name = mine ? '${s.name} (you)' : p!.name;
    final init = mine ? s.init : p!.init;
    final av = mine ? Tone.accent : p!.av;
    final city = mine ? s.city : p!.city;
    final look = mine ? const ConnLook('Your listing', Look.quiet) : s.connLook(l.pid);
    final (cbg, cfg) = lookColors(t, look.look);
    void open() => s.openPlayer(l.pid);

    return InkBox(
      padding: const EdgeInsets.all(14),
      child: Gap(10, children: [
        Row(children: [
          GestureDetector(
            onTap: open,
            child: Stack(clipBehavior: Clip.none, children: [
              Avatar(init, av, size: 44, fontSize: 17),
              Positioned(right: -2, bottom: -2, child: Dot(t.accent, size: 12, border: 2)),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(onTap: open, child: Text(name, style: t.body(16, w: w700))),
              Text('$city · ${l.platform}', style: t.body(12, c: t.muted)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(t.up('EXPIRES IN'), style: t.label(8, c: t.muted)),
            const SizedBox(height: 3),
            Text(left, style: t.digits(13)),
          ]),
        ]),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: InkBox.dark(
                radius: 16,
                shadow: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.mode.toUpperCase(), style: t.label(9, c: t.accentText)),
                  const SizedBox(height: 2),
                  Text(gameById(l.game).name, style: t.body(17, w: w700, c: t.onDark)),
                  Text(l.rank, style: t.body(13, c: t.onDark.withValues(alpha: .85))),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 86,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(16)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(t.up('NEED'), style: t.label(9)),
                FittedBox(fit: BoxFit.scaleDown, child: Text(l.want, style: t.body(20, w: w800, ls: -.5))),
              ]),
            ),
          ]),
        ),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final tag in [l.mic ? 'Mic required' : 'Mic optional', l.when, l.platform]) TagPill(tag),
        ]),
        Text('“${l.note}”', style: t.body(15, h: 1.35)),
        Row(children: [
          Pill('Profile', onTap: open, height: 44, padH: 16, size: 14, bg: Colors.transparent),
          const SizedBox(width: 8),
          Expanded(
            child: Pill(look.label, onTap: mine ? null : () => s.connect(l.pid), expand: true, height: 44, size: 15, weight: w700, bg: cbg, fg: cfg, shadow: 3),
          ),
        ]),
      ]),
    );
  }
}

class NotifsScreen extends StatelessWidget {
  const NotifsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final reqs = s.requestIds;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      child: Gap(12, children: [
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Row(children: [
            const Label('CONNECTION REQUESTS'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: t.accent, border: t.border(1.5), borderRadius: BorderRadius.circular(6)),
              child: Text('${reqs.length}', style: t.digits(10, c: t.onAccent)),
            ),
          ]),
        ),
        if (reqs.isEmpty) const EmptyNote('You’re all caught up.', pad: 18),
        for (final pid in reqs)
          InkBox(
            key: ValueKey(pid),
            radius: 22,
            padding: const EdgeInsets.all(12),
            child: Gap(10, children: [
              Row(children: [
                Avatar(players[pid]!.init, players[pid]!.av, size: 44, fontSize: 17, onTap: () => s.openPlayer(pid)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text.rich(TextSpan(style: t.body(15), children: [
                      TextSpan(text: players[pid]!.name, style: t.body(15, w: w700)),
                      const TextSpan(text: ' wants to play'),
                    ])),
                    Text('${s.rankLine(pid)} · ${players[pid]!.city}', style: t.body(12, c: t.muted)),
                  ]),
                ),
              ]),
              Row(children: [
                Expanded(child: Pill('Accept', onTap: () => s.accept(pid), expand: true, height: 40, size: 14, weight: w700, bg: t.strong, fg: t.onStrong)),
                const SizedBox(width: 8),
                Expanded(child: Pill('Not now', onTap: () => s.decline(pid), expand: true, height: 40, size: 14, bg: Colors.transparent)),
              ]),
            ]),
          ),
        const SizedBox(height: 0),
        const Label('ACTIVITY', padLeft: 6),
        RowList(children: [
          for (final a in activity)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => s.openPlayer(a.pid),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: t.tone(a.bg), border: t.border(), borderRadius: BorderRadius.circular(10)),
                    child: Text(a.icon, style: t.label(9)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(TextSpan(style: t.body(14, h: 1.3), children: [
                      TextSpan(text: players[a.pid]!.name, style: t.body(14, w: w700, h: 1.3)),
                      TextSpan(text: ' ${a.text}'),
                    ])),
                  ),
                  const SizedBox(width: 12),
                  Text(a.t, style: t.digits(9, c: t.muted)),
                ]),
              ),
            ),
        ]),
      ]),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final ql = s.q.trim().toLowerCase();
    final gamers = players.keys.where((pid) {
      final p = players[pid]!;
      return ql.isEmpty || '${p.name} ${p.handle} ${p.games.map((g) => gameById(g.id).name).join(' ')}'.toLowerCase().contains(ql);
    }).toList();
    final found = games
        .where((g) => ql.isNotEmpty ? g.name.toLowerCase().contains(ql) || g.short.toLowerCase().contains(ql) : const ['val', 'fc'].contains(g.id))
        .take(4)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
      child: Gap(14, children: [
        Row(children: [
          BackBtn(onTap: s.back),
          const SizedBox(width: 8),
          Expanded(child: BoxField(value: s.q, hint: 'Gamers, games, posts…', height: 48, padH: 18, shadow: 3, autofocus: true, onChanged: (v) => s.update(() => s.q = v))),
        ]),
        if (gamers.isNotEmpty) ...[
          const Label('GAMERS', padLeft: 6),
          RowList(children: [
            for (final pid in gamers)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => s.openPlayer(pid),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(children: [
                    Avatar(players[pid]!.init, players[pid]!.av, size: 40, fontSize: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(players[pid]!.name, style: t.body(15, w: w700)),
                        Text('${s.rankLine(pid)} · Ethiopia · ${players[pid]!.status}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted)),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Dot(t.tone(players[pid]!.sc), size: 9, border: 1.5),
                  ]),
                ),
              ),
          ]),
        ],
        if (found.isNotEmpty) ...[
          const Label('GAMES', padLeft: 6),
          LayoutBuilder(builder: (context, c) {
            final w = (c.maxWidth - 10) / 2;
            return Wrap(spacing: 10, runSpacing: 10, children: [
              for (final g in found)
                SizedBox(
                  width: w,
                  child: InkBox.dark(
                    radius: 20,
                    padding: const EdgeInsets.all(12),
                    onTap: () => s.go(Screen.find, () => s.filterGame = g.id),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(g.short, style: t.body(20, w: w800, c: t.onDark)),
                      Text(g.name, style: t.body(12, c: t.onDark.withValues(alpha: .85))),
                      const SizedBox(height: 8),
                      Text('Find players →', style: t.body(12, w: w700, c: t.accentText)),
                    ]),
                  ),
                ),
            ]);
          }),
        ],
        if (gamers.isEmpty && found.isEmpty) EmptyNote('Nothing for “${s.q.trim()}” yet.'),
      ]),
    );
  }
}
