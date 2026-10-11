import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'find.dart' show lookColors;
import 'groups.dart';
import 'onboarding.dart' show Wordmark;

/// Everything the profile page shows, for either me or another player.
class _View {
  _View({
    required this.isMe,
    required this.name,
    required this.handle,
    required this.init,
    required this.av,
    required this.city,
    required this.status,
    required this.statusTone,
    required this.bio,
    required this.games,
    required this.platforms,
    required this.tags,
    required this.ids,
    required this.idsLocked,
    required this.connCount,
    required this.gameCount,
    required this.playedCount,
    required this.posts,
    required this.moments,
    required this.conns,
  });
  final bool isMe, idsLocked;
  final String name, handle, init, city, status, bio;
  final Tone av, statusTone;
  final List<({String name, String short, String rank, String role})> games;
  final List<String> platforms, tags, conns;
  final List<({String k, String v, String vis})> ids;
  final int connCount, gameCount, playedCount;
  final List<Post> posts, moments;
}

_View _viewFor(AppState s) {
  final pid = s.viewing;
  if (pid == null) {
    return _View(
      isMe: true,
      name: s.name,
      handle: s.handle,
      init: s.init,
      av: Tone.accent,
      city: s.city,
      status: s.status.label,
      statusTone: s.status.color,
      bio: s.bio,
      games: [for (final id in s.myGames) (name: gameById(id).name, short: gameById(id).short, rank: s.ranks[id]?.isNotEmpty == true ? s.ranks[id]! : (gameById(id).ranked ? 'Unranked' : '—'), role: gameById(id).custom ? 'Added by you' : 'Self-reported')],
      platforms: s.platforms.isEmpty ? const ['—'] : s.platforms,
      tags: const ['Competitive', 'FPS', 'Co-op'],
      ids: [
        for (final k in s.ids.keys)
          if (s.ids[k]!.isNotEmpty) (k: k, v: s.ids[k]!, vis: s.idVis[k]! ? 'PUBLIC' : 'CONNECTIONS'),
      ],
      idsLocked: false,
      connCount: s.connectedIds.length,
      gameCount: s.myGames.length,
      playedCount: s.sessions.length,
      posts: s.posts.where((p) => p.pid == 'me').toList(),
      moments: const [],
      conns: s.connectedIds,
    );
  }
  final p = players[pid]!;
  final connected = s.conn[pid] == Conn.connected;
  return _View(
    isMe: false,
    name: p.name,
    handle: p.handle,
    init: p.init,
    av: p.av,
    city: p.city,
    status: p.status,
    statusTone: p.sc,
    bio: p.bio,
    games: [for (final g in p.games) (name: gameById(g.id).name, short: gameById(g.id).short, rank: g.rank, role: g.role)],
    platforms: p.platforms,
    tags: p.tags,
    ids: connected ? [for (final x in p.ids) (k: x.k, v: x.v, vis: 'CONNECTED')] : const [],
    idsLocked: !connected,
    connCount: p.conn,
    gameCount: p.games.length,
    playedCount: p.played,
    posts: s.posts.where((x) => x.pid == pid).toList(),
    moments: s.posts.where((x) => x.pid == pid && x.kind == PostKind.moment).toList(),
    conns: const ['dave', 'meron', 'liya', 'yonas'].where((k) => k != pid).take(3).toList(),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final v = _viewFor(s);
    final pid = s.viewing;
    final session = pid != null ? s.sessions[pid] : null;
    final tab = s.ptab;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _IdCard(v),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                if (v.isMe) ...[
                  Expanded(
                    child: Pill('Edit profile', onTap: s.openEditProfile, expand: true, height: 46, size: 15, weight: w700, shadow: 3),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Pill('Find players', onTap: s.openListingSheet, expand: true, height: 46, size: 15, weight: w700, bg: t.accent, fg: t.onAccent, shadow: 3),
                  ),
                ] else ...[
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final look = s.connLook(pid!);
                        final (bg, fg) = lookColors(t, look.look);
                        return Pill(look.label, onTap: () => s.connect(pid), expand: true, height: 46, size: 15, weight: w700, bg: bg, fg: fg, shadow: 3);
                      },
                    ),
                  ),
                  if (s.conn[pid] == Conn.connected) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Pill('Play together', onTap: s.openSessionSheet, expand: true, height: 46, size: 15, weight: w700, bg: t.accent, fg: t.onAccent, shadow: 3),
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (v.isMe) const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0), child: ThemePicker()),
          if (session != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.up('SESSION INVITE SENT'), style: t.label(9)),
                        const SizedBox(height: 3),
                        Text('${session.game} with ${v.name}', style: t.body(15, w: w700)),
                      ],
                    ),
                  ),
                  Text(session.time, style: t.digits(16)),
                ],
              ),
            ),
          ChipScroller(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            children: [
              for (final tb in const ['Overview', 'Games', 'Groups', 'Posts', 'Moments', 'Connections']) Pill.chip(tb, tab == tb, () => s.update(() => s.ptab = tb), height: 36, padH: 14, size: 14),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Gap(
              12,
              children: [
                if (tab == 'Overview' || tab == 'Games')
                  for (final g in v.games) _GameRow(g),
                if (tab == 'Overview') ...[_GroupStrip(pid ?? 'me'), ..._overview(t, v)],
                if (tab == 'Groups') ..._groupsTab(s, pid, v),
                if (tab == 'Posts') ...[if (v.posts.isEmpty) const EmptyNote('No posts yet. Share a milestone from Home.'), for (final p in v.posts) _MiniPost(p)],
                if (tab == 'Moments') ...[
                  if (v.moments.isEmpty)
                    const EmptyNote('No clips yet. Moments always ship with a caption — they start conversations.')
                  else
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [for (final m in v.moments) _MomentTile(m)],
                    ),
                ],
                if (tab == 'Connections') ...[
                  if (v.conns.isEmpty)
                    const EmptyNote('No connections yet. Find Players is the fastest way to make one.')
                  else
                    RowList(
                      children: [
                        for (final c in v.conns)
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => s.openPlayer(c),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Row(
                                children: [
                                  Avatar(players[c]!.init, players[c]!.av, size: 40, fontSize: 16),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(players[c]!.name, style: t.body(15, w: w700)),
                                        Text(
                                          '${s.rankLine(c)} · ${players[c]!.status}',
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
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _overview(RallyTheme t, _View v) => [
    Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
      child: Gap(
        8,
        children: [
          const Label('PLATFORMS'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final x in v.platforms)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: t.strong, borderRadius: BorderRadius.circular(99)),
                  child: Text(
                    x,
                    style: t.body(13, w: w600, c: t.onStrong),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Label('PLAY STYLE'),
          Wrap(spacing: 6, runSpacing: 6, children: [for (final x in v.tags) TagPill(x, size: 13, pad: const EdgeInsets.symmetric(horizontal: 11, vertical: 4))]),
        ],
      ),
    ),
    Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(14, 12, 14, 4), child: Label('GAMING IDS')),
          for (final r in v.ids)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 86,
                    child: Text(r.k, style: t.body(13, w: w700)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(r.v, style: mono.copyWith(color: t.text)),
                  ),
                  const SizedBox(width: 10),
                  Text(t.up(r.vis), style: t.label(8, c: t.muted)),
                ],
              ),
            ),
          if (v.idsLocked)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Dashed(
                radius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text('Riot ID and Discord unlock once you’re connected.', style: t.body(13, c: t.muted)),
              ),
            ),
          if (!v.idsLocked && v.ids.isEmpty) const SizedBox(height: 10),
        ],
      ),
    ),
  ];
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
                    child: _ThemeCard(th, selected: s.theme.value.id == th.id, onTap: () => s.setTheme(th.id), ring: t.text),
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
  const _ThemeCard(this.th, {required this.selected, required this.onTap, required this.ring});
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
            border: Border.all(color: selected ? ring : Colors.transparent, width: 2.5),
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
                            decoration: BoxDecoration(shape: BoxShape.circle, color: th.accent, border: th.border(1.5)),
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
              const Align(alignment: Alignment.centerLeft, child: Wordmark(size: 15)),
              const Spacer(),
              InkBox(
                radius: 14,
                shadow: 3,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Avatar('K', Tone.accent, size: 24, fontSize: 10, border: 1.5),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kaleb', maxLines: 1, style: t.body(12, w: w800, h: 1.1)),
                          Text(t.up('GOLD · VAL'), maxLines: 1, style: t.label(6, c: t.muted)),
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
                    child: Pill('Connect', height: 22, padH: 8, size: 10, weight: w700, border: 1, bg: t.accent, fg: t.onAccent),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Pill('Duo', height: 22, padH: 8, size: 10, border: 0, bg: t.dark, fg: t.onDark),
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
  final _View v;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final faint = t.onDark.withValues(alpha: .4);
    Widget stat(int n, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: faint, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pad2(n), style: t.digits(18, c: t.onDark)),
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
                v.isMe ? Text(t.up('YOUR GAMER ID'), style: t.label(9, c: t.accentText)) : BackBtn(onTap: s.back, size: 38, onDark: true),
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
                Avatar(v.init, v.av, size: 84, border: 3, onDark: true, fontSize: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.name,
                        style: t.body(28, w: w800, ls: -1, h: 1, c: t.onDark),
                      ),
                      const SizedBox(height: 4),
                      Text('@${v.handle} · ${v.city}', style: t.body(14, c: t.onDark.withValues(alpha: .8))),
                      const SizedBox(height: 9),
                      GestureDetector(
                        onTap: v.isMe ? s.cycleStatus : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                          decoration: BoxDecoration(border: t.darkBorder(1.5), borderRadius: BorderRadius.circular(99)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dot(t.tone(v.statusTone), size: 8),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  v.status,
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
            const SizedBox(height: 12),
            Text(v.bio, style: t.body(14, h: 1.4, c: t.onDark.withValues(alpha: .9))),
            const SizedBox(height: 14),
            Row(children: [stat(v.connCount, 'CONNECTIONS'), const SizedBox(width: 8), stat(v.gameCount, 'GAMES'), const SizedBox(width: 8), stat(v.playedCount, 'PLAYED WITH')]),
          ],
        ),
      ),
    );
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow(this.g);
  final ({String name, String short, String rank, String role}) g;

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
            alignment: Alignment.center,
            decoration: BoxDecoration(color: t.dark, borderRadius: BorderRadius.circular(16)),
            child: Text(
              g.short,
              style: t.body(15, w: w800, c: t.onDark),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(12)),
            child: Text(g.rank, style: t.body(14, w: w800)),
          ),
        ],
      ),
    );
  }
}

class _MiniPost extends StatelessWidget {
  const _MiniPost(this.p);
  final Post p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final mine = s.gg.contains(p.id);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
      child: Gap(
        8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GameBadge(p.game, pad: const EdgeInsets.symmetric(horizontal: 8, vertical: 3)),
              Text(p.time, style: t.body(12, c: t.muted)),
            ],
          ),
          Text(p.text, style: t.body(15, h: 1.35)),
          Text('GG ${pad2(p.gg + (mine ? 1 : 0))} · ${s.commentLabel(p)}', style: t.body(12, w: w700)),
        ],
      ),
    );
  }
}

class _MomentTile extends StatelessWidget {
  const _MomentTile(this.m);
  final Post m;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return StripeBox(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.up(m.game), style: t.label(8, c: t.accentText)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: t.body(12, h: 1.25, c: t.onDark),
                ),
                const SizedBox(height: 6),
                Text(m.dur ?? '', style: t.digits(10, c: t.onDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _groupsTab(AppState s, String? pid, _View v) {
  final groups = s.groupsOf(pid ?? 'me');
  if (groups.isNotEmpty) return [for (final g in groups) GroupCard(g, key: ValueKey(g.id))];
  return [
    EmptyNote(v.isMe ? 'You haven’t joined any groups yet.' : '${v.name} isn’t in any groups yet.'),
    if (v.isMe) Center(child: Pill('Find groups', onTap: () => s.go(Screen.communities), height: 42, padH: 18, size: 14, weight: w700, shadow: 3)),
  ];
}

/// Horizontal row of the groups a player belongs to.
class _GroupStrip extends StatelessWidget {
  const _GroupStrip(this.pid);
  final String pid;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final groups = s.groupsOf(pid);
    if (groups.isEmpty) return const SizedBox.shrink();
    return InkBox(
      radius: 22,
      padding: const EdgeInsets.fromLTRB(14, 12, 0, 12),
      child: Gap(10, children: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(children: [
            Label('GROUPS · ${groups.length}'),
            const Spacer(),
            GestureDetector(onTap: () => s.update(() => s.ptab = 'Groups'), child: Text('See all', style: t.body(12, w: w700, deco: TextDecoration.underline))),
          ]),
        ),
        ChipScroller(
          padding: const EdgeInsets.only(right: 14),
          gap: 8,
          children: [
            for (final g in groups)
              Tap(
                onTap: () => s.openGroup(g.id),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 12, 5),
                  decoration: BoxDecoration(color: t.sunken, border: t.border(1.5), borderRadius: BorderRadius.circular(99)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    GroupTile(g.short, g.tone, size: 30),
                    const SizedBox(width: 8),
                    Text(g.name, style: t.body(13, w: w700)),
                  ]),
                ),
              ),
          ],
        ),
      ]),
    );
  }
}
