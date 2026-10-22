import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../groups_data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games.dart' show showGamePickerSheet;
import 'home.dart' show FeedPost, clock;
import 'safety.dart';

// Groups on the API (docs/FEED_AND_GROUPS_API.md §5 "Groups"), in the
// prototype's look.

// ---- shared pieces ----

/// Square badge with a group's short name.
class GroupTile extends StatelessWidget {
  const GroupTile(
    this.short,
    this.tone, {
    super.key,
    this.size = 48,
    this.onDark = false,
  });
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
      decoration: BoxDecoration(
        color: t.tone(tone),
        border: onDark ? t.darkBorder() : t.border(),
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(short, style: t.body(size * .3, w: w800)),
      ),
    );
  }
}

/// A player's face (photo or initial).
class _Face extends StatelessWidget {
  const _Face(this.u, {required this.size, this.fontSize, this.border = 2});
  final UserCardDto u;
  final double size;
  final double? fontSize;
  final double border;

  @override
  Widget build(BuildContext context) => Avatar(
    initialOf(u.displayName),
    toneFor(u.id),
    url: u.avatarUrl,
    size: size,
    fontSize: fontSize,
    border: border,
  );
}

/// Overlapping faces.
class FaceStack extends StatelessWidget {
  const FaceStack(this.who, {super.key, this.size = 24});
  final List<UserCardDto> who;
  final double size;

  @override
  Widget build(BuildContext context) {
    final faces = who.take(4).toList();
    if (faces.isEmpty) return const SizedBox.shrink();
    final step = size * .7;
    return SizedBox(
      width: size + step * (faces.length - 1),
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < faces.length; i++)
            Positioned(
              left: step * i,
              child: _Face(
                faces[i],
                size: size,
                fontSize: size * .42,
                border: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}

/// "Tonight 21:00", "Tomorrow 20:00", "Sat 18:00", "25/11 18:00".
String eventWhen(DateTime at, DateTime now) {
  final l = at.toLocal(), n = now.toLocal();
  final day = DateTime(l.year, l.month, l.day);
  final today = DateTime(n.year, n.month, n.day);
  final d = day.difference(today).inDays;
  final time = clock(at);
  if (d == 0) return '${l.hour >= 18 ? 'Tonight' : 'Today'} $time';
  if (d == 1) return 'Tomorrow $time';
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  if (d > 1 && d < 7) return '${days[l.weekday - 1]} $time';
  return '${l.day}/${l.month} $time';
}

/// Join / Ask to join / Requested… / Joined ✓, sized for cards or the page.
class JoinButton extends StatelessWidget {
  const JoinButton(this.g, {super.key, this.big = false});
  final GroupDto g;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final status = g.myStatus;
    final (label, bg, fg) = switch (status) {
      MembershipStatus.member => ('Joined ✓', t.strong, t.onStrong),
      MembershipStatus.pending => ('Requested…', t.grey, t.text),
      _ => (g.approval ? 'Ask to join' : 'Join', t.accent, t.onAccent),
    };
    return Pill(
      label,
      onTap: s.busy
          ? null
          : switch (status) {
              MembershipStatus.member =>
                big
                    ? () => _confirmLeave(context, s, g)
                    : () => s.openGroup(g.id),
              MembershipStatus.pending => () => _confirmCancel(context, s, g),
              _ => () => s.joinGroup(g),
            },
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

Future<void> _confirmLeave(BuildContext context, AppState s, GroupDto g) async {
  if (await confirm(
    context,
    title: 'Leave ${g.name}?',
    body:
        'You’ll stop seeing its posts and events. You can join again any time${g.approval ? ' (admins approve requests)' : ''}.',
    yes: 'Leave',
    no: 'Stay',
  )) {
    await s.leaveGroup(g);
  }
}

Future<void> _confirmCancel(
  BuildContext context,
  AppState s,
  GroupDto g,
) async {
  if (await confirm(
    context,
    title: 'Cancel your request?',
    body: '${g.name}’s admins won’t see it any more. You can ask again later.',
    yes: 'Cancel request',
    no: 'Keep it',
  )) {
    await s.leaveGroup(g);
  }
}

/// ADMIN tag beside a member's name.
class _AdminTag extends StatelessWidget {
  const _AdminTag();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 6),
    child: TypeTag(
      'ADMIN',
      context.rt.soft,
      size: 7,
      pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    ),
  );
}

/// "Valorant · Ethiopia", or "City · Addis Ababa".
String groupLine(GroupDto g) => g.kind == GroupKind.game && g.game != null
    ? '${g.game!.name} · ${g.place}'
    : '${groupKindLabel[g.kind]} · ${g.place}';

/// Group summary card used in the Groups list and on profiles.
class GroupCard extends StatelessWidget {
  const GroupCard(this.g, {super.key});
  final GroupDto g;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final faces = g.membersPreview.toList();
    final next = g.nextEvent;
    final n = g.memberCount.toInt();
    return InkBox(
      onTap: () => s.openGroup(g.id),
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              GroupTile(g.short, toneOfGroup(g.tone), size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.body(16, w: w700),
                    ),
                    Text(
                      groupLine(g),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.body(12, c: t.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              JoinButton(g),
            ],
          ),
          if (g.about.isNotEmpty)
            Text(
              g.about,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.body(13, c: t.muted, h: 1.35),
            ),
          Row(
            children: [
              FaceStack(faces, size: 22),
              if (faces.isNotEmpty) const SizedBox(width: 8),
              Text(
                '${groupCount(n)} ${n == 1 ? 'member' : 'members'}',
                style: t.body(12, w: w600),
              ),
              if (g.myStatus == MembershipStatus.pending) ...[
                const SizedBox(width: 8),
                TypeTag(
                  'REQUESTED',
                  t.grey,
                  size: 7,
                  pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                ),
              ] else if (g.approval) ...[
                const SizedBox(width: 8),
                TypeTag(
                  'APPROVAL',
                  t.soft,
                  size: 7,
                  pad: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                ),
              ],
              const Spacer(),
              if (next != null)
                Flexible(
                  child: Text(
                    'Next: ${eventWhen(next.startsAt, s.now.value)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.body(12, c: t.muted),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _spinner() => const Padding(
  padding: EdgeInsets.all(24),
  child: Center(child: CircularProgressIndicator()),
);

Widget _more(VoidCallback onTap) => Center(
  child: Pill(
    'Load more',
    onTap: onTap,
    height: 42,
    padH: 18,
    size: 14,
    weight: w700,
  ),
);

/// A one-line menu entry in a ThemedDialog; closes the dialog first.
Widget _menuItem(
  BuildContext context,
  String label,
  VoidCallback onTap, {
  bool strong = false,
}) {
  final t = context.rt;
  return Pill(
    label,
    onTap: () {
      Navigator.pop(context);
      onTap();
    },
    expand: true,
    height: 48,
    size: 15,
    weight: w700,
    bg: strong ? t.strong : Colors.transparent,
    fg: strong ? t.onStrong : null,
  );
}

Widget _cancelItem(BuildContext context) => Pill(
  'Cancel',
  onTap: () => Navigator.pop(context),
  expand: true,
  height: 44,
  size: 14,
  bg: Colors.transparent,
  border: 0,
);

// ---- Groups tab ----

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final yoursTab = s.groupsTab == 'Yours';
    final yours = 'Yours (${s.myGroups.length})';
    final filtered = s.groupQuery.trim().length >= 2 || s.groupKind != 'All';

    return RefreshIndicator(
      onRefresh: () => Future.wait([s.loadGroups(), s.loadMyGroups()]),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  Text(
                    t.up('START A GROUP'),
                    style: t.label(9, c: t.accentText),
                  ),
                  Text(
                    'Your squad, your game, your city or campus.',
                    style: t.body(22, w: w800, ls: -.6, h: 1.1, c: t.onDark),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Pill(
                      'Create group',
                      onTap: s.openCreateGroup,
                      height: 42,
                      padH: 16,
                      size: 14,
                      weight: w700,
                      bg: t.accent,
                      fg: t.onAccent,
                      leading: SvgIcon(Ic.plus, size: 16, color: t.onAccent),
                    ),
                  ),
                ],
              ),
            ),
            Segmented(
              options: ['Discover', yours],
              value: yoursTab ? yours : 'Discover',
              onChanged: (v) => s.setGroupsFilter(
                () =>
                    s.groupsTab = v.startsWith('Yours') ? 'Yours' : 'Discover',
              ),
            ),
            BoxField(
              value: s.groupQuery,
              hint: 'Search groups, games, cities',
              height: 46,
              padH: 16,
              onChanged: s.setGroupQuery,
              leading: SvgIcon(Ic.search, size: 18, color: t.muted),
            ),
            ChipScroller(
              children: [
                for (final k in ['All', ...groupKindLabel.values])
                  Pill.chip(
                    k,
                    s.groupKind == k,
                    () => s.setGroupsFilter(() => s.groupKind = k),
                    height: 32,
                    padH: 12,
                  ),
              ],
            ),
            if (!s.groupsLoaded)
              _spinner()
            else ...[
              Label(
                '${s.groups.length}${s.groupsCursor != null ? '+' : ''} ${yoursTab ? 'JOINED' : 'GROUPS'}',
                padLeft: 6,
              ),
              if (s.groups.isEmpty)
                EmptyNote(
                  yoursTab && !filtered
                      ? 'You haven’t joined any groups yet. Discover one, or start your own.'
                      : 'No groups match. Try another search, or create it.',
                ),
              for (final g in s.groups) GroupCard(g, key: ValueKey(g.id)),
              if (s.groupsCursor != null) _more(() => s.loadGroups(more: true)),
            ],
          ],
        ),
      ),
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
    if (g == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Gap(
          12,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BackBtn(onTap: s.closeGroup),
            ),
            _spinner(),
          ],
        ),
      );
    }
    final member = g.myStatus == MembershipStatus.member;
    final admin = s.groupAdmin;

    Widget stat(String n, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: t.onDark.withValues(alpha: .4), width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n, maxLines: 1, style: t.digits(18, c: t.onDark)),
            const SizedBox(height: 4),
            Text(
              t.up(label),
              style: t.label(8, c: t.onDark.withValues(alpha: .75)),
            ),
          ],
        ),
      ),
    );

    return RefreshIndicator(
      onRefresh: () async => s.openGroup(g.id, tab: s.groupTab),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                BackBtn(onTap: s.closeGroup),
                const Spacer(),
                if (admin) ...[
                  TypeTag('YOU’RE ADMIN', t.soft),
                  const SizedBox(width: 8),
                ],
                Semantics(
                  label: 'Share group',
                  child: CircleBtn(
                    onTap: () => s.shareGroup(g),
                    child: const SvgIcon(Ic.share, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  label: 'Group options',
                  child: CircleBtn(
                    onTap: () => _groupMenu(context, s, g),
                    child: const SvgIcon(Ic.more, size: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: InkBox.dark(
              radius: 28,
              padding: const EdgeInsets.all(16),
              child: Gap(
                14,
                children: [
                  Row(
                    children: [
                      GroupTile(
                        g.short,
                        toneOfGroup(g.tone),
                        size: 66,
                        onDark: true,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              g.name,
                              style: t.body(
                                24,
                                w: w800,
                                ls: -.8,
                                h: 1.05,
                                c: t.onDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              groupLine(g),
                              style: t.body(
                                13,
                                c: t.onDark.withValues(alpha: .8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              t.up(
                                g.approval
                                    ? 'ADMINS APPROVE NEW MEMBERS'
                                    : 'OPEN TO EVERYONE',
                              ),
                              style: t.label(8, c: t.accentText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // No comma: the segment fonts lack one.
                      stat('${g.memberCount}', 'MEMBERS'),
                      const SizedBox(width: 8),
                      stat(pad2(s.events?.length ?? 0), 'EVENTS'),
                      const SizedBox(width: 8),
                      stat(pad2(s.groupPosts?.length ?? 0), 'POSTS'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Expanded(child: JoinButton(g, big: true)),
                const SizedBox(width: 8),
                Expanded(
                  child: Pill(
                    'Invite players',
                    onTap: () => s.shareGroup(g),
                    expand: true,
                    height: 46,
                    size: 15,
                    weight: w700,
                    shadow: 3,
                  ),
                ),
              ],
            ),
          ),
          ChipScroller(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            children: [
              for (final tab in ['Feed', 'Members', 'Events', 'About'])
                Pill.chip(
                  tab,
                  s.groupTab == tab,
                  () => s.setGroupTab(tab),
                  height: 36,
                  padH: 14,
                  size: 14,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: switch (s.groupTab) {
              'Members' => _Members(g, admin: admin),
              'Events' => _Events(g, member: member, admin: admin),
              'About' => _About(g, admin: admin),
              _ => _Feed(g, member: member),
            },
          ),
        ],
      ),
    );
  }
}

/// The group's ⋯ menu: link, edit (admins) and report.
Future<void> _groupMenu(BuildContext context, AppState s, GroupDto g) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text(g.name, style: t.body(22, w: w800, ls: -.6)),
          _menuItem(context, 'Copy link', () => s.shareGroup(g)),
          if (s.groupAdmin) _menuItem(context, 'Edit group', s.openEditGroup),
          if (g.createdBy.id != s.me?.id)
            _menuItem(
              context,
              'Report group',
              () => _reportGroup(context, s, g),
            ),
          _cancelItem(context),
        ],
      );
    },
  );
}

/// Reports go against the group's creator (ReportBody.groupId + userId).
Future<void> _reportGroup(BuildContext context, AppState s, GroupDto g) =>
    showReportDialog(
      context,
      userId: g.createdBy.id,
      name: g.name,
      groupId: g.id,
    );

class _Feed extends StatelessWidget {
  const _Feed(this.g, {required this.member});
  final GroupDto g;
  final bool member;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final empty = s.groupDraftPost.trim().isEmpty;
    final posts = s.groupPosts;
    if (!member) {
      return EmptyNote(
        g.approval
            ? 'Ask to join to post and reply in this group.'
            : 'Join to post and reply in this group.',
        pad: 16,
      );
    }
    return Gap(
      12,
      children: [
        InkBox(
          radius: 22,
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          child: Row(
            children: [
              Avatar(
                s.init,
                Tone.accent,
                url: s.me?.avatarUrl,
                size: 34,
                fontSize: 14,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Field(
                  value: s.groupDraftPost,
                  hint: 'Share with ${g.name}…',
                  size: 15,
                  onChanged: (v) => s.update(() => s.groupDraftPost = v),
                  onSubmitted: (_) => s.postInGroup(),
                ),
              ),
              const SizedBox(width: 8),
              Pill(
                'Post',
                onTap: s.busy ? null : s.postInGroup,
                height: 36,
                padH: 14,
                weight: w700,
                border: 0,
                bg: empty ? t.grey : t.accent,
                fg: empty ? t.text : t.onAccent,
              ),
            ],
          ),
        ),
        if (posts == null)
          _spinner()
        else if (posts.isEmpty)
          const EmptyNote('No posts yet. Say hi and set the tone.'),
        for (final p in posts ?? const <PostDto>[])
          InkBox(
            key: ValueKey(p.id),
            radius: 22,
            padding: const EdgeInsets.only(top: 4),
            child: FeedPost(p),
          ),
        if (s.groupPostsCursor != null)
          _more(() => s.loadGroupPosts(more: true)),
      ],
    );
  }
}

class _Members extends StatelessWidget {
  const _Members(this.g, {required this.admin});
  final GroupDto g;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final list = s.members;
    final reqs = s.joinRequests ?? const <GroupMemberDto>[];
    final known = [...?list]
      ..sort(
        (a, b) =>
            (b.role == GroupRole.admin ? 1 : 0) -
            (a.role == GroupRole.admin ? 1 : 0),
      );

    Widget who(GroupMemberDto m, {List<Widget> trailing = const []}) {
      final mine = m.user.id == s.me?.id;
      final rank = s.rankLine(m.user.topGame);
      return GestureDetector(
        key: ValueKey('m-${m.user.id}-${m.status.name}'),
        behavior: HitTestBehavior.opaque,
        onTap: () => s.openPlayer(m.user.username),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _Face(m.user, size: 40, fontSize: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            mine
                                ? '${m.user.displayName} (you)'
                                : m.user.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.body(15, w: w700),
                          ),
                        ),
                        if (m.role == GroupRole.admin &&
                            m.status == MembershipStatus.member)
                          const _AdminTag(),
                      ],
                    ),
                    Text(
                      rank.isEmpty ? '@${m.user.username}' : rank,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.body(12, c: t.muted),
                    ),
                  ],
                ),
              ),
              ...trailing,
            ],
          ),
        ),
      );
    }

    return Gap(
      10,
      children: [
        if (admin && reqs.isNotEmpty) ...[
          Label('REQUESTS (${reqs.length})', padLeft: 6),
          RowList(
            children: [
              for (final m in reqs)
                who(
                  m,
                  trailing: [
                    Pill(
                      'Decline',
                      onTap: s.busy ? null : () => s.approveRequest(m, false),
                      height: 32,
                      padH: 10,
                      bg: Colors.transparent,
                    ),
                    const SizedBox(width: 6),
                    Pill(
                      'Approve',
                      onTap: s.busy ? null : () => s.approveRequest(m, true),
                      height: 32,
                      padH: 12,
                      weight: w700,
                      bg: t.accent,
                      fg: t.onAccent,
                    ),
                  ],
                ),
            ],
          ),
        ],
        Label('${groupCount(g.memberCount.toInt())} MEMBERS', padLeft: 6),
        if (list == null)
          _spinner()
        else
          RowList(
            children: [
              for (final m in known)
                who(
                  m,
                  trailing: [
                    if (admin && m.user.id != s.me?.id)
                      Semantics(
                        label: 'Manage ${m.user.displayName}',
                        child: CircleBtn(
                          size: 34,
                          onTap: () => _memberMenu(context, s, m),
                          child: const SvgIcon(Ic.more, size: 16),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        if (s.membersCursor != null) _more(() => s.loadMembers(more: true)),
      ],
    );
  }
}

/// An admin's options for one member: role and removal.
Future<void> _memberMenu(BuildContext context, AppState s, GroupMemberDto m) {
  final isAdmin = m.role == GroupRole.admin;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text(m.user.displayName, style: t.body(22, w: w800, ls: -.6)),
          _menuItem(
            context,
            isAdmin ? 'Make member' : 'Make admin',
            () => s.setMemberRole(
              m,
              isAdmin ? GroupRole.member : GroupRole.admin,
            ),
          ),
          _menuItem(context, 'Remove from group', () async {
            if (await confirm(
              context,
              title: 'Remove ${m.user.displayName}?',
              body:
                  'They leave ${s.group?.name ?? 'the group'}. They can ask to join again.',
              yes: 'Remove',
            )) {
              await s.removeMember(m);
            }
          }, strong: true),
          _cancelItem(context),
        ],
      );
    },
  );
}

class _Events extends StatelessWidget {
  const _Events(this.g, {required this.member, required this.admin});
  final GroupDto g;
  final bool member, admin;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final list = s.events;
    return Gap(
      12,
      children: [
        if (member)
          Dashed(
            radius: 22,
            onTap: () => _newEvent(context, s, g),
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SvgIcon(Ic.plus, size: 18),
                  const SizedBox(width: 8),
                  Text('New event', style: t.body(15, w: w700)),
                ],
              ),
            ),
          ),
        if (list == null)
          _spinner()
        else if (list.isEmpty)
          EmptyNote(
            member
                ? 'No events yet. Plan the first one.'
                : 'No events planned yet.',
          ),
        for (final e in list ?? const <GroupEventDto>[])
          _EventCard(e, member: member, admin: admin),
        if (s.eventsCursor != null) _more(() => s.loadEvents(more: true)),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard(this.e, {required this.member, required this.admin});
  final GroupEventDto e;
  final bool member, admin;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final going = e.imGoing;
    final time = clock(e.startsAt);
    final day = eventWhen(e.startsAt, s.now.value).replaceAll(time, '').trim();
    final game = e.game == null ? '' : ' · ${e.game!.name}';
    final canDelete = admin || e.createdBy.id == s.me?.id;
    return InkBox(
      key: ValueKey(e.id),
      radius: 22,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          InkBox.dark(
            radius: 16,
            shadow: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SizedBox(
              width: 56,
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      t.up(day.toUpperCase()),
                      maxLines: 1,
                      style: t.label(8, c: t.accentText),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    child: Text(time, style: t.digits(16, c: t.onDark)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.body(15, w: w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    FaceStack(e.goingPreview.toList(), size: 20),
                    if (e.goingPreview.isNotEmpty) const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${e.goingCount} going$game',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.body(12, c: t.muted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Pill(
                going ? 'Going ✓' : 'I’m in',
                onTap: member
                    ? () => s.toggleGoing(e)
                    : () => s.toast('Join the group to RSVP'),
                height: 34,
                padH: 12,
                weight: w700,
                bg: going ? t.strong : (member ? t.accent : t.grey),
                fg: going ? t.onStrong : (member ? t.onAccent : t.text),
              ),
              if (canDelete)
                GestureDetector(
                  onTap: () async {
                    if (await confirm(
                      context,
                      title: 'Delete this event?',
                      body: 'It’s gone for everyone in the group.',
                      yes: 'Delete',
                    )) {
                      await s.deleteGroupEvent(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Delete',
                      style: t.body(
                        12,
                        w: w700,
                        c: t.muted,
                        deco: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tonight at 21:00, or tomorrow when that is less than 30 minutes away.
DateTime _defaultStart(DateTime now) {
  final tonight = DateTime(now.year, now.month, now.day, 21);
  return tonight.isAfter(now.add(const Duration(minutes: 30)))
      ? tonight
      : tonight.add(const Duration(days: 1));
}

Future<void> _newEvent(BuildContext context, AppState s, GroupDto g) {
  var title = '';
  final now = DateTime.now();
  var at = _defaultStart(now);
  String? game = g.game?.id;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) => StatefulBuilder(
      builder: (context, setLocal) {
        final t = context.rt;
        Future<void> pickDay() async {
          final d = await showDatePicker(
            context: context,
            initialDate: at,
            firstDate: DateTime(now.year, now.month, now.day),
            // The API takes events within the next 60 days.
            lastDate: now.add(const Duration(days: 59)),
          );
          if (d == null) return;
          setLocal(
            () => at = DateTime(d.year, d.month, d.day, at.hour, at.minute),
          );
        }

        Future<void> pickTime() async {
          final tm = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(at),
          );
          if (tm == null) return;
          setLocal(
            () => at = DateTime(at.year, at.month, at.day, tm.hour, tm.minute),
          );
        }

        return ThemedDialog(
          children: [
            Text('New event', style: t.body(22, w: w800, ls: -.6)),
            BoxField(
              value: title,
              hint: 'What’s happening?',
              height: 50,
              sunken: true,
              autofocus: true,
              maxLength: 80,
              onChanged: (v) => title = v,
            ),
            const Label('WHEN'),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Pick the day',
                    child: Pill(
                      eventWhen(at, now).replaceAll(clock(at), '').trim(),
                      onTap: pickDay,
                      expand: true,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    label: 'Pick the time',
                    child: Pill(
                      clock(at),
                      onTap: pickTime,
                      expand: true,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
            if (g.game != null) ...[
              const Label('GAME'),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Pill.chip(
                    g.game!.name,
                    game == g.game!.id,
                    () => setLocal(() => game = g.game!.id),
                    height: 32,
                    padH: 12,
                  ),
                  Pill.chip(
                    'Any game',
                    game == null,
                    () => setLocal(() => game = null),
                    height: 32,
                    padH: 12,
                  ),
                ],
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: Pill(
                    'Cancel',
                    onTap: () => Navigator.pop(context),
                    expand: true,
                    height: 46,
                    size: 15,
                    bg: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Pill(
                    'Add event',
                    onTap: () async {
                      if (title.trim().isEmpty) {
                        return s.toast('Give the event a name');
                      }
                      if (!at.isAfter(DateTime.now())) {
                        return s.toast('Pick a time that hasn’t passed');
                      }
                      final nav = Navigator.of(context);
                      if (await s.addGroupEvent(title.trim(), at, game)) {
                        nav.pop();
                      }
                    },
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
            ),
          ],
        );
      },
    ),
  );
}

class _About extends StatelessWidget {
  const _About(this.g, {required this.admin});
  final GroupDto g;
  final bool admin;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final admins = [
      for (final m in s.members ?? const <GroupMemberDto>[])
        if (m.role == GroupRole.admin)
          m.user.id == s.me?.id ? 'You' : m.user.displayName,
    ].join(', ');
    Widget detail(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(k, style: t.body(13, w: w700)),
          ),
          Expanded(
            child: Text(v, style: t.body(13, c: t.muted)),
          ),
        ],
      ),
    );
    return Gap(
      12,
      children: [
        if (admin)
          Align(
            alignment: Alignment.centerLeft,
            child: Pill(
              'Edit group',
              onTap: s.openEditGroup,
              height: 40,
              padH: 16,
              weight: w700,
              shadow: 3,
            ),
          ),
        InkBox(
          radius: 22,
          padding: const EdgeInsets.all(16),
          child: Text(
            g.about.isEmpty ? 'No description yet.' : g.about,
            style: t.body(15, h: 1.45),
          ),
        ),
        if (g.rules.isNotEmpty) ...[
          const Label('RULES', padLeft: 6),
          InkBox(
            radius: 22,
            padding: const EdgeInsets.all(14),
            child: Gap(
              10,
              children: [
                for (var i = 0; i < g.rules.length; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          pad2(i + 1),
                          style: t.digits(12, c: t.muted),
                        ),
                      ),
                      Expanded(
                        child: Text(g.rules[i], style: t.body(14, h: 1.35)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
        const Label('DETAILS', padLeft: 6),
        RowList(
          children: [
            detail('Type', groupKindLabel[g.kind]!),
            if (g.game != null) detail('Game', g.game!.name),
            detail('Place', g.place),
            detail(
              'Who can join',
              g.approval ? 'Admins approve requests' : 'Anyone',
            ),
            if (admins.isNotEmpty) detail('Admins', admins),
            detail('Created', monthYear(g.createdAt)),
          ],
        ),
      ],
    );
  }
}

// ---- Create / edit group ----

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final d = s.newGroup;
    if (d == null) return const SizedBox.shrink();
    final editing = d.editId != null;
    void set(VoidCallback fn) => s.update(fn);
    final ready =
        d.name.trim().length >= 3 &&
        (d.kind != GroupKind.game || d.gameId != null);
    final mine = [
      for (final g in s.me?.games ?? const <UserGameDto>[]) g.game?.id,
    ].whereType<String>().toList();
    final gameIds = [
      ...mine,
      if (d.gameId != null && !mine.contains(d.gameId)) d.gameId!,
    ];
    Widget labeled(String label, Widget field) =>
        Gap(6, children: [Label(label, padLeft: 14), field]);
    final placeHint = switch (d.kind) {
      GroupKind.campus => 'Addis Ababa University',
      GroupKind.game => 'Ethiopia',
      _ => 'Addis Ababa',
    };
    final what = d.kind == GroupKind.game && d.gameId != null
        ? s.catalog.byId(d.gameId!).name
        : groupKindLabel[d.kind]!;
    final where = d.place.trim().isEmpty ? placeHint : d.place.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(
            children: [
              CloseBtn(onTap: s.closeGroupForm),
              Expanded(
                child: Text(
                  editing ? 'Edit group' : 'New group',
                  textAlign: TextAlign.center,
                  style: t.body(20, w: w800, ls: -.5),
                ),
              ),
              Pill(
                s.busy ? 'Saving…' : (editing ? 'Save' : 'Create'),
                onTap: s.busy ? null : s.createGroup,
                height: 42,
                padH: 20,
                size: 15,
                weight: w700,
                bg: ready ? t.accent : t.grey,
                fg: ready ? t.onAccent : t.text,
                shadow: 3,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            children: [
              Gap(
                14,
                children: [
                  InkBox(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        GroupTile(
                          s.groupShort(d),
                          toneOfGroup(d.tone),
                          size: 56,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.name.trim().isEmpty
                                    ? 'Your group'
                                    : d.name.trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.body(19, w: w800, ls: -.5),
                              ),
                              Text(
                                '$what · $where',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.body(13, c: t.muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  labeled(
                    'NAME',
                    Gap(
                      6,
                      children: [
                        BoxField(
                          value: d.name,
                          hint: 'e.g. Valorant Addis Duo Queue',
                          height: 50,
                          maxLength: 40,
                          onChanged: (v) => set(() {
                            d.name = v;
                            d.nameError = null;
                          }),
                        ),
                        if (d.nameError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              d.nameError!,
                              style: t.body(13, w: w600, c: t.acc),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!editing)
                    labeled(
                      'TYPE',
                      Segmented(
                        options: [...groupKindLabel.values],
                        value: groupKindLabel[d.kind]!,
                        onChanged: (v) => set(
                          () => d.kind = groupKindLabel.entries
                              .firstWhere((e) => e.value == v)
                              .key,
                        ),
                      ),
                    ),
                  if (!editing && d.kind == GroupKind.game)
                    labeled(
                      'GAME',
                      ChipScroller(
                        children: [
                          for (final id in gameIds)
                            Pill.chip(
                              s.catalog.byId(id).name,
                              d.gameId == id,
                              () => set(() => d.gameId = id),
                            ),
                          Pill(
                            'Other game',
                            onTap: () => showGamePickerSheet(
                              context,
                              title: 'Pick the game',
                              single: true,
                              selected: () => [?d.gameId],
                              onToggle: (id) => set(() => d.gameId = id),
                              // A game group needs a catalog game.
                              onAddCustom: (_) => s.toast(
                                'Pick a game from the list for a game group',
                              ),
                            ),
                            bg: Colors.transparent,
                            leading: const SvgIcon(Ic.search, size: 14),
                          ),
                        ],
                      ),
                    ),
                  labeled(
                    d.kind == GroupKind.campus ? 'CAMPUS' : 'CITY OR COUNTRY',
                    BoxField(
                      value: d.place,
                      hint: placeHint,
                      height: 50,
                      onChanged: (v) => set(() => d.place = v),
                    ),
                  ),
                  labeled(
                    'ABOUT',
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: t.surface,
                        border: t.border(),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Field(
                        value: d.about,
                        hint: 'Who is it for? What do you play, and when?',
                        size: 15,
                        height: 1.4,
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        onChanged: (v) => set(() => d.about = v),
                      ),
                    ),
                  ),
                  labeled('RULES', _RulesEditor(d)),
                  labeled(
                    'WHO CAN JOIN',
                    Segmented(
                      options: const ['Anyone', 'Approval'],
                      value: d.approval ? 'Approval' : 'Anyone',
                      onChanged: (v) => set(() => d.approval = v == 'Approval'),
                    ),
                  ),
                  labeled(
                    'COLOUR',
                    Row(
                      children: [
                        for (final tone in GroupTone.values)
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
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: d.tone == tone
                                          ? t.text
                                          : Colors.transparent,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: t.tone(toneOfGroup(tone)),
                                      border: t.border(1.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!editing)
                    Text(
                      'You’ll be the admin. You can post events and approve members.',
                      style: t.body(13, c: t.muted),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Up to [maxRules] rules of [maxRuleLength] characters.
class _RulesEditor extends StatelessWidget {
  const _RulesEditor(this.d);
  final GroupDraft d;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(
      7,
      children: [
        for (var i = 0; i < d.rules.length; i++)
          Container(
            // Index in the key so removing a row doesn't reuse another
            // row's controller.
            key: ValueKey('rule-$i-${d.rules.length}'),
            height: 44,
            padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
            decoration: BoxDecoration(
              color: t.surface,
              border: t.border(),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(pad2(i + 1), style: t.digits(10)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Field(
                    value: d.rules[i],
                    hint: 'Rule ${i + 1}',
                    size: 15,
                    maxLength: maxRuleLength,
                    onChanged: (v) => d.rules[i] = v,
                  ),
                ),
                CloseBtn(
                  size: 28,
                  fontSize: 14,
                  transparent: true,
                  onTap: () =>
                      s.update(() => d.rules = [...d.rules]..removeAt(i)),
                ),
              ],
            ),
          ),
        if (d.rules.length < maxRules)
          Dashed(
            radius: 14,
            onTap: () => s.update(() => d.rules = [...d.rules, '']),
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text('+ Add rule', style: t.body(14, w: w600)),
              ),
            ),
          ),
      ],
    );
  }
}
