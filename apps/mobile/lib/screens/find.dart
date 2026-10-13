import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home.dart' show countdown;
import 'safety.dart';

/// Resolves a connection-button look against the active skin.
(Color, Color) lookColors(RallyTheme t, Look l) => switch (l) {
  Look.strong => (t.strong, t.onStrong),
  Look.quiet => (t.grey, t.text),
  Look.accent => (t.accent, t.onAccent),
};

class FindScreen extends StatelessWidget {
  const FindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final toggles = <(String, bool, VoidCallback)>[
      ('Mic on', s.fMic, () => s.setFilter(() => s.fMic = !s.fMic)),
      (
        'Tonight',
        s.fTonight,
        () => s.setFilter(() => s.fTonight = !s.fTonight),
      ),
      ('Competitive', s.fComp, () => s.setFilter(() => s.fComp = !s.fComp)),
    ];
    // Countdowns tick every second; only this subtree rebuilds.
    return RefreshIndicator(
      onRefresh: s.loadFeed,
      child: ValueListenableBuilder(
        valueListenable: s.now,
        builder: (context, now, _) {
          final live = s.listings
              .where((l) => l.expiresAt.isAfter(now))
              .toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              Gap(
                12,
                children: [
                  ChipScroller(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Pill.chip(
                        'All games',
                        s.filterGame == 'all',
                        () => s.setFilter(() => s.filterGame = 'all'),
                        height: 38,
                        padH: 15,
                        size: 14,
                      ),
                      for (final g in s.launchGames)
                        Pill.chip(
                          g.name,
                          s.filterGame == g.id,
                          () => s.setFilter(() => s.filterGame = g.id),
                          height: 38,
                          padH: 15,
                          size: 14,
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
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
                              decoration: BoxDecoration(
                                color: on ? t.strong : Colors.transparent,
                                border: Border.all(color: t.text, width: 1.5),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label('${pad2(live.length)} PLAYERS LOOKING'),
                        const Flexible(
                          child: Label('LISTINGS EXPIRE AUTOMATICALLY'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Gap(
                      14,
                      children: [
                        if (s.feedLoaded && live.isEmpty)
                          const EmptyNote(
                            'No one matches these filters right now. Post a listing and let them find you.',
                          ),
                        for (final l in live)
                          _ListingCard(
                            l,
                            left: countdown(l.expiresAt, now),
                            key: ValueKey(l.id),
                          ),
                        if (s.feedCursor != null)
                          Center(
                            child: Pill(
                              'Load more',
                              onTap: () => s.loadFeed(more: true),
                              height: 42,
                              padH: 18,
                              size: 14,
                              weight: w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard(this.l, {super.key, required this.left});
  final ListingDto l;
  final String left;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final o = l.owner;
    final look = s.listingLook(l);
    final (cbg, cfg) = lookColors(t, look.look);
    void open() => s.openPlayer(o.username);
    final need = l.partySize - 1 - l.filled;

    return InkBox(
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: open,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Avatar(
                      initialOf(o.displayName),
                      toneFor(o.id),
                      url: o.avatarUrl,
                      size: 44,
                      fontSize: 17,
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Dot(t.accent, size: 12, border: 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: open,
                      child: Text(o.displayName, style: t.body(16, w: w700)),
                    ),
                    Text(
                      '${o.city} · ${platformLabel[l.platform]}',
                      style: t.body(12, c: t.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(t.up('EXPIRES IN'), style: t.label(8, c: t.muted)),
                  const SizedBox(height: 3),
                  Text(left, style: t.digits(13)),
                ],
              ),
              Semantics(
                button: true,
                label: 'More for ${o.displayName}',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => showPlayerMenu(
                    context,
                    userId: o.id,
                    name: o.displayName,
                    listing: l,
                  ),
                  child: const SizedBox(
                    width: 34,
                    height: 40,
                    child: Center(child: SvgIcon(Ic.more, size: 20)),
                  ),
                ),
              ),
            ],
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkBox.dark(
                    radius: 16,
                    shadow: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (l.mode?.name ??
                                  (l.style == PlayStyle.competitive
                                      ? 'Competitive'
                                      : 'Casual'))
                              .toUpperCase(),
                          style: t.label(9, c: t.accentText),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.game.name,
                          style: t.body(17, w: w700, c: t.onDark),
                        ),
                        Text(
                          l.rank?.name ?? 'Any rank',
                          style: t.body(13, c: t.onDark.withValues(alpha: .85)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 86,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: t.soft,
                    border: t.border(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.up('NEED'), style: t.label(9)),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l.filled == 0
                              ? partyLabel(l.partySize)
                              : '$need more',
                          style: t.body(20, w: w800, ls: -.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in [
                l.voice == Voice.required_ ? 'Mic required' : 'Mic optional',
                playWhenLabel[l.playWhen]!,
                platformLabel[l.platform]!,
              ])
                TagPill(tag),
            ],
          ),
          if (l.note != null) Text('“${l.note}”', style: t.body(15, h: 1.35)),
          Row(
            children: [
              Pill(
                'Profile',
                onTap: open,
                height: 44,
                padH: 16,
                size: 14,
                bg: Colors.transparent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  look.label,
                  onTap: l.myRequest != null || s.busy
                      ? null
                      : () => s.connectFromListing(l),
                  expand: true,
                  height: 44,
                  size: 15,
                  weight: w700,
                  bg: cbg,
                  fg: cfg,
                  shadow: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotifsScreen extends StatelessWidget {
  const NotifsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final reqs = s.requests;
    return RefreshIndicator(
      onRefresh: s.loadAlerts,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        children: [
          Gap(
            12,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    const Label('CONNECTION REQUESTS'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: t.accent,
                        border: t.border(1.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${reqs.length}',
                        style: t.digits(10, c: t.onAccent),
                      ),
                    ),
                  ],
                ),
              ),
              if (reqs.isEmpty)
                const EmptyNote('You’re all caught up.', pad: 18),
              for (final r in reqs)
                InkBox(
                  key: ValueKey(r.id),
                  radius: 22,
                  padding: const EdgeInsets.all(12),
                  child: Gap(
                    10,
                    children: [
                      Row(
                        children: [
                          Avatar(
                            initialOf(r.from.displayName),
                            toneFor(r.from.id),
                            url: r.from.avatarUrl,
                            size: 44,
                            fontSize: 17,
                            onTap: () => s.openPlayer(r.from.username),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: t.body(15),
                                    children: [
                                      TextSpan(
                                        text: r.from.displayName,
                                        style: t.body(15, w: w700),
                                      ),
                                      TextSpan(
                                        text: r.listing != null
                                            ? ' wants to join your ${r.listing!.game.name} listing'
                                            : ' wants to connect',
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  [
                                    s.rankLine(r.from.topGame),
                                    r.from.city,
                                  ].where((x) => x.isNotEmpty).join(' · '),
                                  style: t.body(12, c: t.muted),
                                ),
                                if (r.message != null)
                                  Text(
                                    '“${r.message}”',
                                    style: t.body(13, h: 1.3),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Pill(
                              'Accept',
                              onTap: () => s.answerRequest(r, true),
                              expand: true,
                              height: 40,
                              size: 14,
                              weight: w700,
                              bg: t.strong,
                              fg: t.onStrong,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Pill(
                              'Not now',
                              onTap: () => s.answerRequest(r, false),
                              expand: true,
                              height: 40,
                              size: 14,
                              bg: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 0),
              const Label('ACTIVITY', padLeft: 6),
              if (s.notifications.isEmpty)
                const EmptyNote(
                  'Requests, accepts and invites show up here.',
                  pad: 18,
                ),
              if (s.notifications.isNotEmpty)
                RowList(
                  children: [
                    for (final n in s.notifications)
                      GestureDetector(
                        key: ValueKey(n.id),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => s.openRoute(n.route),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              n.actor != null
                                  ? Avatar(
                                      initialOf(n.actor!.displayName),
                                      toneFor(n.actor!.id),
                                      url: n.actor!.avatarUrl,
                                      size: 34,
                                      fontSize: 14,
                                    )
                                  : Container(
                                      width: 34,
                                      height: 34,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: t.soft,
                                        border: t.border(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('!', style: t.label(9)),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  n.text,
                                  style: t.body(
                                    14,
                                    h: 1.3,
                                    w: n.readAt == null ? w700 : w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _ago(n.createdAt),
                                style: t.digits(9, c: t.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "now", "5m", "3h", "2d".
String _ago(DateTime at) {
  final d = DateTime.now().difference(at);
  if (d.inMinutes < 1) return 'now';
  if (d.inHours < 1) return '${d.inMinutes}m';
  if (d.inDays < 1) return '${d.inHours}h';
  return '${d.inDays}d';
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final ql = s.q.trim().toLowerCase();
    final games =
        (ql.isEmpty
                ? s.launchGames
                : s.catalog.games.where((g) => g.isLaunch && g.matches(ql)))
            .take(4)
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
      child: Gap(
        14,
        children: [
          Row(
            children: [
              BackBtn(onTap: s.leaveSearch),
              const SizedBox(width: 8),
              Expanded(
                child: BoxField(
                  value: s.q,
                  hint: 'Gamers by name or username',
                  height: 48,
                  padH: 18,
                  shadow: 3,
                  autofocus: true,
                  onChanged: s.setQuery,
                ),
              ),
            ],
          ),
          if (s.found.isNotEmpty) ...[
            const Label('GAMERS', padLeft: 6),
            RowList(
              children: [
                for (final u in s.found)
                  GestureDetector(
                    key: ValueKey(u.id),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => s.openPlayer(u.username),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Avatar(
                            initialOf(u.displayName),
                            toneFor(u.id),
                            url: u.avatarUrl,
                            size: 40,
                            fontSize: 16,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u.displayName, style: t.body(15, w: w700)),
                                Text(
                                  [
                                    '@${u.username}',
                                    s.rankLine(u.topGame),
                                    statusLook(u.status, u.statusGame).$1,
                                  ].where((x) => x.isNotEmpty).join(' · '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.body(12, c: t.muted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Dot(
                            t.tone(statusLook(u.status, u.statusGame).$2),
                            size: 9,
                            border: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (games.isNotEmpty) ...[
            const Label('FIND PLAYERS FOR', padLeft: 6),
            LayoutBuilder(
              builder: (context, c) {
                final w = (c.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final g in games)
                      SizedBox(
                        width: w,
                        child: InkBox.dark(
                          radius: 20,
                          padding: const EdgeInsets.all(12),
                          onTap: () =>
                              s.go(Screen.find, () => s.filterGame = g.id),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g.short,
                                style: t.body(20, w: w800, c: t.onDark),
                              ),
                              Text(
                                g.name,
                                style: t.body(
                                  12,
                                  c: t.onDark.withValues(alpha: .85),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Find players →',
                                style: t.body(12, w: w700, c: t.accentText),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          if (ql.length >= 2 && s.found.isEmpty && games.isEmpty)
            EmptyNote('No gamers called “${s.q.trim()}” yet.'),
          if (ql.length < 2 && games.isEmpty)
            const EmptyNote('Type at least 2 letters of a name or username.'),
        ],
      ),
    );
  }
}
