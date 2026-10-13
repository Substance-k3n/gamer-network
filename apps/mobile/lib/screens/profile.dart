import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'find.dart' show lookColors;
import 'onboarding.dart' show Wordmark;
import 'safety.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final me = s.me;
    final v = s.viewing == null
        ? (me == null ? null : Profile.me(me))
        : s.viewed;
    if (v == null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: BackBtn(onTap: s.back),
            ),
          ),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    }
    final tabs = v.isMe
        ? const ['Overview', 'Games', 'Connections']
        : const ['Overview', 'Games'];
    final tab = tabs.contains(s.ptab) ? s.ptab : 'Overview';

    return RefreshIndicator(
      onRefresh: () => v.isMe ? s.loadMyProfile() : s.openPlayer(v.username),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          _IdCard(v),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                if (v.isMe) ...[
                  Expanded(
                    child: Pill(
                      'Edit profile',
                      onTap: s.openEditProfile,
                      expand: true,
                      height: 46,
                      size: 15,
                      weight: w700,
                      shadow: 3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Pill(
                      'Find players',
                      onTap: s.openListingSheet,
                      expand: true,
                      height: 46,
                      size: 15,
                      weight: w700,
                      bg: t.accent,
                      fg: t.onAccent,
                      shadow: 3,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final look = s.connLook(v.relationship);
                        final (bg, fg) = lookColors(t, look.look);
                        final tap =
                            v.relationship == Relationship.outgoingRequest ||
                                s.busy
                            ? null
                            : s.connect;
                        return Pill(
                          look.label,
                          onTap: tap,
                          expand: true,
                          height: 46,
                          size: 15,
                          weight: w700,
                          bg: bg,
                          fg: fg,
                          shadow: 3,
                        );
                      },
                    ),
                  ),
                  if (v.relationship == Relationship.connected) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Pill(
                        'Play together',
                        onTap: s.openSessionSheet,
                        expand: true,
                        height: 46,
                        size: 15,
                        weight: w700,
                        bg: t.accent,
                        fg: t.onAccent,
                        shadow: 3,
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  CircleBtn(
                    size: 46,
                    shadow: 3,
                    onTap: () => showPlayerMenu(
                      context,
                      userId: v.id,
                      name: v.displayName,
                    ),
                    child: const SvgIcon(Ic.more, size: 20),
                  ),
                ],
              ],
            ),
          ),
          ChipScroller(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            children: [
              for (final tb in tabs)
                Pill.chip(
                  tb,
                  tab == tb,
                  () => s.update(() => s.ptab = tb),
                  height: 36,
                  padH: 14,
                  size: 14,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Gap(
              12,
              children: [
                if (tab == 'Overview' || tab == 'Games') ...[
                  if (v.games.isEmpty)
                    const EmptyNote('No games on this profile yet.'),
                  for (final g in v.games) _GameRow(_line(s, g)),
                ],
                if (tab == 'Overview') ..._overview(t, v),
                if (tab == 'Overview' && v.isMe) ...[
                  const ThemePicker(),
                  const _Settings(),
                ],
                if (tab == 'Connections') ..._connections(s, t),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GameLine _line(AppState s, UserGameDto g) {
    final game = g.game == null ? null : s.catalog.byId(g.game!.id);
    final name = g.game?.name ?? g.customGameName ?? '';
    return GameLine(
      name: name,
      short: g.game?.shortCode ?? s.catalog.byId(s.catalog.keyOf(g)).short,
      rank:
          g.rank?.name ??
          ((g.rankText?.isNotEmpty ?? false)
              ? g.rankText!
              : (game?.hasRanks ?? false)
              ? 'Unranked'
              : '—'),
      role: g.role?.name ?? (g.game == null ? 'Added by you' : 'Self-reported'),
    );
  }

  List<Widget> _connections(AppState s, RallyTheme t) {
    if (s.connections.isEmpty) {
      return const [
        EmptyNote(
          'No connections yet. Find Players is the fastest way to make one.',
        ),
      ];
    }
    return [
      RowList(
        children: [
          for (final c in s.connections)
            GestureDetector(
              key: ValueKey(c.user.id),
              behavior: HitTestBehavior.opaque,
              onTap: () => s.openPlayer(c.user.username),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Avatar(
                      initialOf(c.user.displayName),
                      toneFor(c.user.id),
                      url: c.user.avatarUrl,
                      size: 40,
                      fontSize: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.user.displayName, style: t.body(15, w: w700)),
                          Text(
                            [
                              s.rankLine(c.user.topGame),
                              statusLook(c.user.status, c.user.statusGame).$1,
                            ].where((x) => x.isNotEmpty).join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.body(12, c: t.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _overview(RallyTheme t, Profile v) => [
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        border: t.border(),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Gap(
        8,
        children: [
          const Label('PLATFORMS'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final x
                  in v.platforms.isEmpty
                      ? const ['—']
                      : [for (final p in v.platforms) platformLabel[p]!])
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: t.strong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    x,
                    style: t.body(13, w: w600, c: t.onStrong),
                  ),
                ),
            ],
          ),
          if (v.tags.isNotEmpty) ...[
            const SizedBox(height: 4),
            const Label('PLAY STYLE'),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final x in v.tags)
                  TagPill(
                    tagLabel[x]!,
                    size: 13,
                    pad: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 4,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    ),
    Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surface,
        border: t.border(),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Label('GAMING IDS'),
          ),
          for (final r in v.gamingIds)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 86,
                    child: Text(
                      r.kind == GamingIdKind.inGame
                          ? (r.game?.shortCode ?? 'In-game')
                          : idKindLabel[r.kind]!,
                      style: t.body(13, w: w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      r.value,
                      style: mono.copyWith(color: t.text),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    t.up(
                      r.visibility == IdVisibility.public
                          ? 'PUBLIC'
                          : v.isMe
                          ? 'CONNECTIONS'
                          : 'CONNECTED',
                    ),
                    style: t.label(8, c: t.muted),
                  ),
                ],
              ),
            ),
          if (!v.isMe && v.relationship != Relationship.connected)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Dashed(
                radius: 14,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  'Their other IDs unlock once you’re connected.',
                  style: t.body(13, c: t.muted),
                ),
              ),
            ),
          if (v.gamingIds.isEmpty &&
              (v.isMe || v.relationship == Relationship.connected))
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
              child: Text('No IDs added.', style: t.body(13, c: t.muted)),
            ),
        ],
      ),
    ),
  ];
}

/// Settings on your own profile: account and safety.
class _Settings extends StatelessWidget {
  const _Settings();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    Widget row(String label, VoidCallback onTap, {String? trailing}) =>
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(label, style: t.body(15, w: w600)),
                ),
                Text(trailing ?? '→', style: t.body(14, c: t.muted)),
              ],
            ),
          ),
        );
    return Gap(
      8,
      children: [
        const Label('SETTINGS', padLeft: 6),
        RowList(
          children: [
            if (!(s.me?.emailVerified ?? true))
              row(
                'Confirm your email',
                () => s.go(Screen.verify, () => s.code = ''),
                trailing: 'Not confirmed',
              ),
            row('Blocked users', () => s.go(Screen.blocked)),
            row('Log out', s.logout, trailing: s.me?.email),
            row('Delete account', () => confirmDeleteAccount(context)),
          ],
        ),
      ],
    );
  }
}

/// 2×2 grid of skins. Each card renders a live miniature in its own theme.
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(
      8,
      children: [
        const Label('APP THEME', padLeft: 6),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final th in rallyThemes)
                  SizedBox(
                    width: w,
                    child: _ThemeCard(
                      th,
                      selected: s.theme.value.id == th.id,
                      onTap: () => s.setTheme(th.id),
                      ring: t.text,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard(
    this.th, {
    required this.selected,
    required this.onTap,
    required this.ring,
  });
  final RallyTheme th;
  final bool selected;
  final VoidCallback onTap;
  final Color ring;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Semantics(
      button: true,
      selected: selected,
      label: '${th.name} theme',
      child: Tap(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? ring : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                // Re-theme the subtree so the miniature uses the real widgets.
                child: Theme(
                  data: materialTheme(th),
                  child: Stack(
                    children: [
                      const _Miniature(),
                      if (selected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: th.accent,
                              border: th.border(1.5),
                            ),
                            child: Text(
                              '✓',
                              style: th.body(12, w: w700, h: 1, c: th.onAccent),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(th.name, style: t.body(14, w: w700)),
                    Text(
                      th.tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.body(11, c: t.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Miniature extends StatelessWidget {
  const _Miniature();

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return PageBackground(
      child: SizedBox(
        height: 134,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Wordmark(size: 15),
              ),
              const Spacer(),
              InkBox(
                radius: 14,
                shadow: 3,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Avatar(
                      'K',
                      Tone.accent,
                      size: 24,
                      fontSize: 10,
                      border: 1.5,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kaleb',
                            maxLines: 1,
                            style: t.body(12, w: w800, h: 1.1),
                          ),
                          Text(
                            t.up('GOLD · VAL'),
                            maxLines: 1,
                            style: t.label(6, c: t.muted),
                          ),
                        ],
                      ),
                    ),
                    Text('21:00', style: t.digits(11)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Pill(
                      'Connect',
                      height: 22,
                      padH: 8,
                      size: 10,
                      weight: w700,
                      border: 1,
                      bg: t.accent,
                      fg: t.onAccent,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Pill(
                      'Duo',
                      height: 22,
                      padH: 8,
                      size: 10,
                      border: 0,
                      bg: t.dark,
                      fg: t.onDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  const _IdCard(this.v);
  final Profile v;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final faint = t.onDark.withValues(alpha: .4);
    final (status, statusTone) = statusLook(v.status, v.statusGame);
    Widget stat(num n, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: faint, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pad2(n.toInt()), style: t.digits(18, c: t.onDark)),
            const SizedBox(height: 4),
            Text(
              t.up(label),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: t.label(8, c: t.onDark.withValues(alpha: .75)),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkBox.dark(
        radius: 30,
        shadow: 0,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                v.isMe
                    ? Text(
                        t.up('YOUR GAMER ID'),
                        style: t.label(9, c: t.accentText),
                      )
                    : BackBtn(onTap: s.back, size: 38, onDark: true),
                CircleBtn(
                  size: 38,
                  onDark: true,
                  onTap: s.goSearch,
                  child: SvgIcon(Ic.search, size: 18, color: t.onDark),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Avatar(
                      initialOf(v.displayName),
                      v.isMe ? Tone.accent : toneFor(v.id),
                      url: v.avatarUrl,
                      size: 84,
                      border: 3,
                      onDark: true,
                      fontSize: 34,
                      onTap: v.isMe ? s.changeAvatar : null,
                    ),
                    if (v.isMe)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Semantics(
                          button: true,
                          label: 'Change photo',
                          child: CircleBtn(
                            size: 30,
                            onTap: s.changeAvatar,
                            child: const SvgIcon(Ic.image, size: 14),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.displayName,
                        style: t.body(28, w: w800, ls: -1, h: 1, c: t.onDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${v.username} · ${v.city}',
                        style: t.body(14, c: t.onDark.withValues(alpha: .8)),
                      ),
                      const SizedBox(height: 9),
                      GestureDetector(
                        onTap: v.isMe ? s.cycleStatus : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: t.darkBorder(1.5),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dot(t.tone(statusTone), size: 8),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  status,
                                  style: t.body(13, w: w600, c: t.onDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (v.bio != null && v.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                v.bio!,
                style: t.body(14, h: 1.4, c: t.onDark.withValues(alpha: .9)),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                stat(v.stats.connections, 'CONNECTIONS'),
                const SizedBox(width: 8),
                stat(v.stats.games, 'GAMES'),
                const SizedBox(width: 8),
                stat(v.stats.playedWith, 'PLAYED WITH'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow(this.g);
  final GameLine g;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return InkBox(
      radius: 22,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.dark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                g.short,
                style: t.body(15, w: w800, c: t.onDark),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.name, style: t.body(16, w: w700)),
                Text(g.role, style: t.body(13, c: t.muted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: t.soft,
                border: t.border(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                g.rank,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.body(14, w: w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
