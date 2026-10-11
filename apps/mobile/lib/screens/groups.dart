import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games.dart' show showGamePickerSheet;

// ---- shared pieces ----

/// Square badge with a group's short name.
class GroupTile extends StatelessWidget {
  const GroupTile(this.short, this.tone, {super.key, this.size = 48, this.onDark = false});
  final String short;
  final Tone tone;
  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .12),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: t.tone(tone), border: onDark ? t.darkBorder() : t.border(), borderRadius: BorderRadius.circular(size * .3)),
      child: FittedBox(fit: BoxFit.scaleDown, child: Text(short, style: t.body(size * .3, w: w800))),
    );
  }
}

/// Overlapping member faces.
class FaceStack extends StatelessWidget {
  const FaceStack(this.pids, {super.key, this.size = 24});
  final List<String> pids;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final faces = pids.take(4).toList();
    if (faces.isEmpty) return const SizedBox.shrink();
    final step = size * .7;
    return SizedBox(
      width: size + step * (faces.length - 1),
      height: size,
      child: Stack(children: [
        for (var i = 0; i < faces.length; i++)
          Positioned(
            left: step * i,
            child: Builder(builder: (_) {
              final w = s.who(faces[i]);
              return Avatar(w.init, w.av, size: size, fontSize: size * .42, border: 1.5);
            }),
          ),
      ]),
    );
  }
}

/// Join / Ask to join / Requested / Joined, sized for cards or the group page.
class JoinButton extends StatelessWidget {
  const JoinButton(this.g, {super.key, this.big = false});
  final Group g;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final member = g.members.contains('me');
    final requested = s.groupRequests.contains(g.id);
    final (label, bg, fg) = member
        ? ('Joined ✓', t.strong, t.onStrong)
        : requested
            ? ('Requested…', t.grey, t.text)
            : (g.approval ? 'Ask to join' : 'Join', t.accent, t.onAccent);
    return Pill(
      label,
      onTap: member ? (big ? () => _confirmLeave(context, s, g) : () => s.openGroup(g.id)) : () => s.joinGroup(g),
      expand: big,
      height: big ? 46 : 36,
      padH: big ? 18 : 14,
      size: big ? 15 : 13,
      weight: w700,
      bg: bg,
      fg: fg,
      shadow: big ? 3 : 0,
    );
  }
}

Future<void> _confirmLeave(BuildContext context, AppState s, Group g) async {
  final leave = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return _ThemedDialog(children: [
        Text('Leave ${g.name}?', style: t.body(22, w: w800, ls: -.6)),
        Text('You’ll stop seeing its posts and events. You can join again any time${g.approval ? ' (admins approve requests)' : ''}.', style: t.body(14, c: t.muted, h: 1.35)),
        Row(children: [
          Expanded(child: Pill('Stay', onTap: () => Navigator.pop(context, false), expand: true, height: 46, size: 15, bg: Colors.transparent)),
          const SizedBox(width: 8),
          Expanded(child: Pill('Leave', onTap: () => Navigator.pop(context, true), expand: true, height: 46, size: 15, weight: w700, bg: t.strong, fg: t.onStrong)),
        ]),
      ]);
    },
  );
  if (leave == true) s.leaveGroup(g);
}

class _ThemedDialog extends StatelessWidget {
  const _ThemedDialog({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Frost(
        radius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(color: t.glass ? t.popover : t.surface, border: t.border(), borderRadius: BorderRadius.circular(28), boxShadow: t.shadow()),
          child: Gap(12, children: children),
        ),
      ),
    );
  }
}

/// Group summary card used in the Groups list and on profiles.
class GroupCard extends StatelessWidget {
  const GroupCard(this.g, {super.key});
  final Group g;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final faces = g.members.where((p) => p != 'me').toList();
    final next = g.events.isEmpty ? null : g.events.first;
    return InkBox(
      onTap: () => s.openGroup(g.id),
      padding: const EdgeInsets.all(14),
      child: Gap(10, children: [
        Row(children: [
          GroupTile(g.short, g.tone, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(16, w: w700)),
              Text(g.line, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted)),
            ]),
          ),
          const SizedBox(width: 8),
          JoinButton(g),
        ]),
        Text(g.about, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.body(13, c: t.muted, h: 1.35)),
        Row(children: [
          FaceStack(faces, size: 22),
          if (faces.isNotEmpty) const SizedBox(width: 8),
          Text('${groupCount(g.count)} members', style: t.body(12, w: w600)),
          if (g.approval) ...[const SizedBox(width: 8), TypeTag('APPROVAL', t.soft, size: 7, pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 2))],
          const Spacer(),
          if (next != null) Flexible(child: Text('Next: ${next.when}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted))),
        ]),
      ]),
    );
  }
}

// ---- Groups tab ----

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final mine = s.groups.where((g) => g.members.contains('me')).toList();
    final pool = s.groupsTab == 'Yours' ? mine : s.groups;
    final q = s.groupQuery.trim().toLowerCase();
    final shown = pool.where((g) {
      final kindOk = s.groupKind == 'All' || g.kind.label == s.groupKind;
      final text = '${g.name} ${g.place} ${g.gameId == null ? '' : gameById(g.gameId!).name}'.toLowerCase();
      return kindOk && (q.isEmpty || text.contains(q));
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      child: Gap(14, children: [
        InkBox.dark(
          radius: 26,
          padding: const EdgeInsets.all(18),
          child: Gap(12, children: [
            Text(t.up('START A GROUP'), style: t.label(9, c: t.accentText)),
            Text('Your squad, your game, your city or campus.', style: t.body(22, w: w800, ls: -.6, h: 1.1, c: t.onDark)),
            Align(
              alignment: Alignment.centerLeft,
              child: Pill('Create group', onTap: s.openCreateGroup, height: 42, padH: 16, size: 14, weight: w700, bg: t.accent, fg: t.onAccent, leading: SvgIcon(Ic.plus, size: 16, color: t.onAccent)),
            ),
          ]),
        ),
        Segmented(options: ['Discover', 'Yours (${mine.length})'], value: s.groupsTab == 'Yours' ? 'Yours (${mine.length})' : 'Discover', onChanged: (v) => s.update(() => s.groupsTab = v.startsWith('Yours') ? 'Yours' : 'Discover')),
        BoxField(
          value: s.groupQuery,
          hint: 'Search groups, games, cities',
          height: 46,
          padH: 16,
          onChanged: (v) => s.update(() => s.groupQuery = v),
          leading: SvgIcon(Ic.search, size: 18, color: t.muted),
        ),
        ChipScroller(children: [
          for (final k in ['All', ...GroupKind.values.map((k) => k.label)]) Pill.chip(k, s.groupKind == k, () => s.update(() => s.groupKind = k), height: 32, padH: 12),
        ]),
        Label('${shown.length} ${s.groupsTab == 'Yours' ? 'JOINED' : 'GROUPS'}', padLeft: 6),
        if (shown.isEmpty)
          EmptyNote(s.groupsTab == 'Yours' && mine.isEmpty ? 'You haven’t joined any groups yet. Discover one, or start your own.' : 'No groups match. Try another search, or create it.'),
        for (final g in shown) GroupCard(g, key: ValueKey(g.id)),
      ]),
    );
  }
}

// ---- Group page ----

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final g = s.group;
    if (g == null) return const Padding(padding: EdgeInsets.all(16), child: EmptyNote('This group no longer exists.'));
    final member = g.members.contains('me');
    final admin = g.admins.contains('me');

    Widget stat(String n, String label) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: t.onDark.withValues(alpha: .4), width: 1.5), borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(n, maxLines: 1, style: t.digits(18, c: t.onDark)),
              const SizedBox(height: 4),
              Text(t.up(label), style: t.label(8, c: t.onDark.withValues(alpha: .75))),
            ]),
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Row(children: [
            BackBtn(onTap: s.closeGroup),
            const Spacer(),
            if (admin) ...[TypeTag('YOU’RE ADMIN', t.soft), const SizedBox(width: 8)],
            CircleBtn(onTap: () => s.toast('Invite link copied'), child: const SvgIcon(Ic.share, size: 18)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: InkBox.dark(
            radius: 28,
            padding: const EdgeInsets.all(16),
            child: Gap(14, children: [
              Row(children: [
                GroupTile(g.short, g.tone, size: 66, onDark: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(g.name, style: t.body(24, w: w800, ls: -.8, h: 1.05, c: t.onDark)),
                    const SizedBox(height: 4),
                    Text(g.line, style: t.body(13, c: t.onDark.withValues(alpha: .8))),
                    const SizedBox(height: 6),
                    Text(t.up(g.approval ? 'ADMINS APPROVE NEW MEMBERS' : 'OPEN TO EVERYONE'), style: t.label(8, c: t.accentText)),
                  ]),
                ),
              ]),
              Row(children: [
                stat('${g.count}', 'MEMBERS'), // no comma: segment fonts lack one
                const SizedBox(width: 8),
                stat(pad2(g.events.length), 'EVENTS'),
                const SizedBox(width: 8),
                stat(pad2(g.posts.length), 'POSTS'),
              ]),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(children: [
            Expanded(child: JoinButton(g, big: true)),
            const SizedBox(width: 8),
            Expanded(child: Pill('Invite players', onTap: () => s.toast('Invite link copied'), expand: true, height: 46, size: 15, weight: w700, shadow: 3)),
          ]),
        ),
        ChipScroller(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          children: [
            for (final tab in ['Feed', 'Members', 'Events', 'About']) Pill.chip(tab, s.groupTab == tab, () => s.update(() => s.groupTab = tab), height: 36, padH: 14, size: 14),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: switch (s.groupTab) {
            'Members' => _Members(g),
            'Events' => _Events(g, member: member, admin: admin),
            'About' => _About(g),
            _ => _Feed(g, member: member),
          },
        ),
      ],
    );
  }
}

class _Feed extends StatelessWidget {
  const _Feed(this.g, {required this.member});
  final Group g;
  final bool member;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(12, children: [
      if (member)
        InkBox(
          radius: 22,
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: Row(children: [
            Avatar(s.init, Tone.accent, size: 34, fontSize: 14),
            const SizedBox(width: 10),
            Expanded(child: Field(value: s.groupDraftPost, hint: 'Share with ${g.name}…', size: 15, onChanged: (v) => s.update(() => s.groupDraftPost = v), onSubmitted: (_) => s.postInGroup(g))),
            const SizedBox(width: 8),
            Pill('Post', onTap: () => s.postInGroup(g), height: 36, padH: 14, weight: w700, border: 0, bg: s.groupDraftPost.trim().isEmpty ? t.grey : t.accent, fg: s.groupDraftPost.trim().isEmpty ? t.text : t.onAccent),
          ]),
        )
      else
        EmptyNote(g.approval ? 'Ask to join to post and reply in this group.' : 'Join to post and reply in this group.', pad: 16),
      if (g.posts.isEmpty) const EmptyNote('No posts yet. Say hi and set the tone.'),
      for (var i = 0; i < g.posts.length; i++) _GroupPostCard(g, g.posts[i], 'gp:${g.id}:${g.posts.length - i}'),
    ]);
  }
}

class _GroupPostCard extends StatelessWidget {
  const _GroupPostCard(this.g, this.p, this.k);
  final Group g;
  final GroupPost p;
  final String k;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final w = s.who(p.pid);
    final mine = s.gg.contains(k);
    return InkBox(
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Gap(9, children: [
        Row(children: [
          Avatar(w.init, w.av, size: 36, fontSize: 14, onTap: () => s.openPlayer(p.pid)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(child: GestureDetector(onTap: () => s.openPlayer(p.pid), child: Text(p.pid == 'me' ? '${w.name} (you)' : w.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(14, w: w700)))),
                if (g.admins.contains(p.pid)) ...[const SizedBox(width: 6), TypeTag('ADMIN', t.soft, size: 7, pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 1))],
              ]),
              Text(p.time, style: t.body(12, c: t.muted)),
            ]),
          ),
        ]),
        Text(p.text, style: t.body(15, h: 1.4)),
        Align(
          alignment: Alignment.centerLeft,
          child: Pill('GG', onTap: () => s.toggleGG(k), height: 32, padH: 12, weight: w700, bg: mine ? t.accent : Colors.transparent, fg: mine ? t.onAccent : t.text, trailing: Text('${p.gg + (mine ? 1 : 0)}', style: t.digits(10, c: mine ? t.onAccent : t.text))),
        ),
      ]),
    );
  }
}

class _Members extends StatelessWidget {
  const _Members(this.g);
  final Group g;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final known = [...g.members]..sort((a, b) => (g.admins.contains(b) ? 1 : 0) - (g.admins.contains(a) ? 1 : 0));
    return Gap(10, children: [
      Label('${groupCount(g.count)} MEMBERS', padLeft: 6),
      RowList(children: [
        for (final pid in known)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => s.openPlayer(pid),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Builder(builder: (_) {
                  final w = s.who(pid);
                  return Avatar(w.init, w.av, size: 40, fontSize: 16);
                }),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Flexible(child: Text(pid == 'me' ? '${s.name} (you)' : s.who(pid).name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(15, w: w700))),
                      if (g.admins.contains(pid)) ...[const SizedBox(width: 6), TypeTag('ADMIN', t.soft, size: 7, pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 1))],
                    ]),
                    Text(s.rankLine(pid), maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted)),
                  ]),
                ),
                if (pid != 'me' && s.conn[pid] == Conn.connected) Text(t.up('CONNECTED'), style: t.label(8, c: t.muted)),
              ]),
            ),
          ),
      ]),
      if (g.extra > 0) Padding(padding: const EdgeInsets.only(top: 2), child: Text('+ ${groupCount(g.extra)} more members', textAlign: TextAlign.center, style: t.body(13, c: t.muted))),
    ]);
  }
}

class _Events extends StatelessWidget {
  const _Events(this.g, {required this.member, required this.admin});
  final Group g;
  final bool member, admin;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(12, children: [
      if (admin)
        Dashed(
          radius: 22,
          onTap: () => _newEvent(context, s, g),
          child: SizedBox(
            height: 52,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const SvgIcon(Ic.plus, size: 18), const SizedBox(width: 8), Text('New event', style: t.body(15, w: w700))]),
          ),
        ),
      if (g.events.isEmpty) EmptyNote(admin ? 'No events yet. Plan the first one.' : 'No events planned yet.'),
      for (final e in g.events)
        Builder(builder: (context) {
          final going = e.going.contains('me');
          final time = RegExp(r'\d{1,2}:\d{2}').firstMatch(e.when)?.group(0) ?? '--:--';
          final day = e.when.replaceAll(time, '').trim();
          return InkBox(
            key: ValueKey(e.id),
            radius: 22,
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              InkBox.dark(
                radius: 16,
                shadow: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SizedBox(
                  width: 56,
                  child: Column(children: [
                    Text(t.up(day.isEmpty ? 'SOON' : day.toUpperCase()), maxLines: 1, style: t.label(8, c: t.accentText)),
                    const SizedBox(height: 4),
                    FittedBox(child: Text(time, style: t.digits(16, c: t.onDark))),
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.body(15, w: w700)),
                  const SizedBox(height: 4),
                  Row(children: [
                    FaceStack(e.going.toList(), size: 20),
                    if (e.going.isNotEmpty) const SizedBox(width: 6),
                    Flexible(
                      child: Text('${e.going.length} going${e.gameId != null ? ' · ${gameById(e.gameId!).name}' : ''}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted)),
                    ),
                  ]),
                ]),
              ),
              const SizedBox(width: 8),
              Pill(
                going ? 'Going ✓' : 'I’m in',
                onTap: member ? () => s.toggleGoing(e) : () => s.toast('Join the group to RSVP'),
                height: 34,
                padH: 12,
                weight: w700,
                bg: going ? t.strong : (member ? t.accent : t.grey),
                fg: going ? t.onStrong : (member ? t.onAccent : t.text),
              ),
            ]),
          );
        }),
    ]);
  }
}

Future<void> _newEvent(BuildContext context, AppState s, Group g) {
  var title = '';
  var when = 'Tonight 21:00';
  String? game = g.gameId;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) => StatefulBuilder(builder: (context, setLocal) {
      final t = context.rt;
      return _ThemedDialog(children: [
        Text('New event', style: t.body(22, w: w800, ls: -.6)),
        BoxField(value: title, hint: 'What’s happening?', height: 50, sunken: true, autofocus: true, onChanged: (v) => title = v),
        const Label('WHEN'),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final w in const ['Tonight 21:00', 'Tomorrow 20:00', 'Sat 18:00', 'Sun 16:00']) Pill.chip(w, when == w, () => setLocal(() => when = w), height: 32, padH: 12),
        ]),
        if (g.gameId != null) ...[
          const Label('GAME'),
          Wrap(spacing: 6, runSpacing: 6, children: [
            Pill.chip(gameById(g.gameId!).name, game == g.gameId, () => setLocal(() => game = g.gameId), height: 32, padH: 12),
            Pill.chip('Any game', game == null, () => setLocal(() => game = null), height: 32, padH: 12),
          ]),
        ],
        Row(children: [
          Expanded(child: Pill('Cancel', onTap: () => Navigator.pop(context), expand: true, height: 46, size: 15, bg: Colors.transparent)),
          const SizedBox(width: 8),
          Expanded(
            child: Pill('Add event', onTap: () {
              if (title.trim().isEmpty) return s.toast('Give the event a name');
              Navigator.pop(context);
              s.addGroupEvent(g, title.trim(), when, game);
            }, expand: true, height: 46, size: 15, weight: w700, bg: t.accent, fg: t.onAccent, shadow: 3),
          ),
        ]),
      ]);
    }),
  );
}

class _About extends StatelessWidget {
  const _About(this.g);
  final Group g;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final admins = g.admins.map((p) => p == 'me' ? 'You' : s.who(p).name).join(', ');
    Widget detail(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 104, child: Text(k, style: t.body(13, w: w700))),
            Expanded(child: Text(v, style: t.body(13, c: t.muted))),
          ]),
        );
    return Gap(12, children: [
      InkBox(radius: 22, padding: const EdgeInsets.all(16), child: Text(g.about, style: t.body(15, h: 1.45))),
      if (g.rules.isNotEmpty) ...[
        const Label('RULES', padLeft: 6),
        InkBox(
          radius: 22,
          padding: const EdgeInsets.all(14),
          child: Gap(10, children: [
            for (var i = 0; i < g.rules.length; i++)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 28, child: Text(pad2(i + 1), style: t.digits(12, c: t.muted))),
                Expanded(child: Text(g.rules[i], style: t.body(14, h: 1.35))),
              ]),
          ]),
        ),
      ],
      const Label('DETAILS', padLeft: 6),
      RowList(children: [
        detail('Type', g.kind.label),
        if (g.gameId != null) detail('Game', gameById(g.gameId!).name),
        detail('Place', g.place),
        detail('Who can join', g.approval ? 'Admins approve requests' : 'Anyone'),
        detail('Admins', admins),
        detail('Created', g.since),
      ]),
    ]);
  }
}

// ---- Create group ----

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final d = s.newGroup;
    if (d == null) return const SizedBox.shrink();
    void set(VoidCallback fn) => s.update(fn);
    final ready = d.name.trim().length >= 3 && (d.kind != GroupKind.game || d.gameId != null);
    final gameIds = [...s.myGames, if (d.gameId != null && !s.myGames.contains(d.gameId)) d.gameId!];
    final short = d.kind == GroupKind.game && d.gameId != null
        ? gameById(d.gameId!).short
        : (d.name.trim().isEmpty ? '?' : d.name.trim().split(RegExp(r'\s+')).take(3).map((w) => w[0]).join().toUpperCase());
    Widget labeled(String label, Widget field) => Gap(6, children: [Label(label, padLeft: 14), field]);
    final placeHint = switch (d.kind) {
      GroupKind.campus => 'Addis Ababa University',
      GroupKind.game => 'Ethiopia',
      _ => 'Addis Ababa',
    };

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: Row(children: [
          CloseBtn(onTap: () => s.go(Screen.communities, () => s.newGroup = null)),
          Expanded(child: Text('New group', textAlign: TextAlign.center, style: t.body(20, w: w800, ls: -.5))),
          Pill('Create', onTap: s.createGroup, height: 42, padH: 20, size: 15, weight: w700, bg: ready ? t.accent : t.grey, fg: ready ? t.onAccent : t.text, shadow: 3),
        ]),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          children: [
            Gap(14, children: [
              InkBox(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  GroupTile(short, d.tone, size: 56),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(d.name.trim().isEmpty ? 'Your group' : d.name.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(19, w: w800, ls: -.5)),
                      Text(
                        '${d.kind == GroupKind.game && d.gameId != null ? gameById(d.gameId!).name : d.kind.label} · ${d.place.trim().isEmpty ? placeHint : d.place.trim()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.body(13, c: t.muted),
                      ),
                    ]),
                  ),
                ]),
              ),
              labeled('NAME', BoxField(value: d.name, hint: 'e.g. Valorant Addis Duo Queue', height: 50, onChanged: (v) => set(() => d.name = v))),
              labeled(
                'TYPE',
                Segmented(options: [for (final k in GroupKind.values) k.label], value: d.kind.label, onChanged: (v) => set(() => d.kind = GroupKind.values.firstWhere((k) => k.label == v))),
              ),
              if (d.kind == GroupKind.game)
                labeled(
                  'GAME',
                  ChipScroller(children: [
                    for (final id in gameIds) Pill.chip(gameById(id).name, d.gameId == id, () => set(() => d.gameId = id)),
                    Pill(
                      'Other game',
                      onTap: () => showGamePickerSheet(
                        context,
                        title: 'Pick the game',
                        single: true,
                        selected: () => [?d.gameId],
                        onToggle: (id) => set(() => d.gameId = id),
                        onAddCustom: (name) => set(() => d.gameId = addCustomGame(name)),
                      ),
                      bg: Colors.transparent,
                      leading: const SvgIcon(Ic.search, size: 14),
                    ),
                  ]),
                ),
              labeled(d.kind == GroupKind.campus ? 'CAMPUS' : 'CITY OR COUNTRY', BoxField(value: d.place, hint: placeHint, height: 50, onChanged: (v) => set(() => d.place = v))),
              labeled(
                'ABOUT',
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
                  child: Field(value: d.about, hint: 'Who is it for? What do you play, and when?', size: 15, height: 1.4, minLines: 3, maxLines: 5, keyboardType: TextInputType.multiline, onChanged: (v) => set(() => d.about = v)),
                ),
              ),
              labeled('WHO CAN JOIN', Segmented(options: const ['Anyone', 'Approval'], value: d.approval ? 'Approval' : 'Anyone', onChanged: (v) => set(() => d.approval = v == 'Approval'))),
              labeled(
                'COLOUR',
                Row(children: [
                  for (final tone in const [Tone.accent, Tone.lav, Tone.soft, Tone.grey])
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Semantics(
                        button: true,
                        selected: d.tone == tone,
                        label: '${tone.name} colour',
                        child: GestureDetector(
                          onTap: () => set(() => d.tone = tone),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: d.tone == tone ? t.text : Colors.transparent, width: 2.5)),
                            child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: t.tone(tone), border: t.border(1.5))),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
              Text('You’ll be the admin. You can post events and approve members.', style: t.body(13, c: t.muted)),
            ]),
          ],
        ),
      ),
    ]);
  }
}
