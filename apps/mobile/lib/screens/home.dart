import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'onboarding.dart' show Wordmark;
import 'safety.dart';

const _barH = 58.0;

/// "02:14:09" until [to].
String countdown(DateTime to, DateTime now) {
  final d = to.difference(now);
  final s = d.isNegative ? 0 : d.inSeconds;
  return '${pad2(s ~/ 3600)}:${pad2(s % 3600 ~/ 60)}:${pad2(s % 60)}';
}

/// "21:00" in local time.
String clock(DateTime t) {
  final l = t.toLocal();
  return '${pad2(l.hour)}:${pad2(l.minute)}';
}

/// Timeline-style Home feed. What needs you now (invites, "did you play?",
/// your listing) is pinned above the posts. The top bar slides away while
/// scrolling down and returns on scroll up; past a few posts a pill offers
/// a jump back to the top.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  double _lastY = 0;
  bool _hideBar = false, _showPill = false, _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final y = _scroll.offset;
    final d = y - _lastY;
    _lastY = y;
    final hide = y < 60
        ? false
        : d > 4
        ? true
        : d < -4
        ? false
        : _hideBar;
    final pill = y > 520;
    if (hide != _hideBar || pill != _showPill) {
      setState(() {
        _hideBar = hide;
        _showPill = pill;
      });
    }
    final s = context.app;
    if (!_loadingMore &&
        s.postsCursor != null &&
        _scroll.position.extentAfter < 600) {
      _loadingMore = true;
      s.loadPosts(more: true).whenComplete(() => _loadingMore = false);
    }
  }

  void _toTop() {
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
    setState(() {
      _hideBar = false;
      _showPill = false;
    });
  }

  void _pickFeed(AppState s, String id) {
    s.setFeedTab(id);
    if (_scroll.hasClients) _scroll.jumpTo(0);
    setState(() => _hideBar = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final me = s.me;
    final mq = MediaQuery.of(context);
    final bottom = mq.padding.bottom;
    final keyboard = mq.viewInsets.bottom > 0;
    final options = s.feedOptions;
    final current = options.firstWhere(
      (o) => o.$1 == s.feedTab,
      orElse: () => options.first,
    );
    final pinned = [
      if (me != null && !me.emailVerified) const _VerifyNudge(),
      for (final i in s.invites) _InviteCard(i, key: ValueKey(i.id)),
      for (final i in s.sentInvites) _SentInvite(i, key: ValueKey(i.id)),
      for (final c in s.checkIns) _CheckInCard(c, key: ValueKey(c.id)),
      if (s.myListing != null) _MyListing(s.myListing!),
    ];

    return ClipRect(
      child: Stack(
        children: [
          RefreshIndicator(
            edgeOffset: _barH,
            onRefresh: () => Future.wait([s.refreshHome(), s.loadPosts()]),
            child: ListView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: _barH, bottom: 120),
              children: [
                if (pinned.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      border: Border(bottom: t.dividerSide),
                    ),
                    child: Gap(14, children: pinned),
                  ),
                for (final p in s.posts) FeedPost(p, key: ValueKey(p.id)),
                if (!s.postsLoaded)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (s.posts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 40,
                    ),
                    child: Text(
                      s.feedTab == 'connections'
                          ? 'Nothing here yet. Connect with players from Find Players and their posts show up here.'
                          : 'No posts yet. Tap + and start the conversation.',
                      textAlign: TextAlign.center,
                      style: t.body(15, c: t.muted, h: 1.45),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedSlide(
            offset: Offset(0, _hideBar ? -1 : 0),
            duration: const Duration(milliseconds: 280),
            curve: Curves.ease,
            child: const Frost(radius: BorderRadius.zero, child: _TopBar()),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (c, a) => FadeTransition(
                  opacity: a,
                  child: ScaleTransition(scale: a, child: c),
                ),
                child: _showPill
                    ? _NewPostsPill(onTap: _toTop, key: const ValueKey('pill'))
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          if (s.filterOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => s.update(() => s.filterOpen = false),
              ),
            ),
            Positioned(
              left: 18,
              bottom: 162 + bottom,
              width: 220,
              child: Frost(
                radius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: t.popover,
                    border: t.border(),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: t.shadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 6, 10, 4),
                        child: Label('SHOW IN FEED'),
                      ),
                      for (final (id, label) in options)
                        Tap(
                          onTap: () => _pickFeed(s, id),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: s.feedTab == id
                                  ? t.accent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.body(
                                      14,
                                      w: w600,
                                      c: s.feedTab == id ? t.onAccent : t.text,
                                    ),
                                  ),
                                ),
                                if (s.feedTab == id)
                                  Text(
                                    '✓',
                                    style: t.body(14, w: w800, c: t.onAccent),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (!keyboard) ...[
            Positioned(
              left: 18,
              bottom: 102 + bottom,
              child: Frost(
                radius: BorderRadius.circular(99),
                child: Pill(
                  current.$2,
                  onTap: () => s.update(() => s.filterOpen = !s.filterOpen),
                  height: 50,
                  padH: 16,
                  size: 14,
                  weight: w700,
                  bg: t.popover,
                  shadow: 4,
                  leading: const SvgIcon(Ic.filter, size: 18),
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 98 + bottom,
              child: Semantics(
                button: true,
                label: 'New post',
                child: CircleBtn(
                  size: 58,
                  bg: t.accent,
                  shadow: 4,
                  onTap: s.openCompose,
                  child: SvgIcon(Ic.plus, size: 26, color: t.onAccent),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final badge = s.unread;
    return Container(
      height: _barH,
      padding: const EdgeInsets.fromLTRB(16, 4, 14, 10),
      decoration: BoxDecoration(
        color: t.bar,
        border: Border(bottom: t.dividerSide),
      ),
      child: Row(
        children: [
          Avatar(
            s.init,
            Tone.accent,
            url: s.me?.avatarUrl,
            size: 38,
            fontSize: 16,
            onTap: s.goProfileTab,
          ),
          const Spacer(),
          const Wordmark(size: 26),
          const Spacer(),
          Semantics(
            button: true,
            label: 'Alerts',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => s.go(Screen.notifs),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SvgIcon(Ic.bell, size: 23),
                    if (badge > 0)
                      Positioned(
                        top: 3,
                        right: 3,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 17),
                          height: 17,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: t.accent,
                            border: Border.all(
                              color: t.hard ? t.line : t.bg,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            badge > 99 ? '99+' : '$badge',
                            style: t.body(10, w: w700, h: 1, c: t.onAccent),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewPostsPill extends StatelessWidget {
  const _NewPostsPill({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final seen = <String>{};
    final faces = [
      for (final p in s.posts)
        if (!p.mine && seen.add(p.author.id)) p.author,
    ].take(3).toList();
    return Tap(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
        decoration: BoxDecoration(
          color: t.accent,
          border: t.border(),
          borderRadius: BorderRadius.circular(99),
          boxShadow: t.shadow(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(Ic.up, size: 16, color: t.onAccent),
            const SizedBox(width: 8),
            // Faces overlap by 6px.
            SizedBox(
              width: faces.isEmpty ? 0 : 26 + 20.0 * (faces.length - 1),
              height: 26,
              child: Stack(
                children: [
                  for (var i = 0; i < faces.length; i++)
                    Positioned(
                      left: 20.0 * i,
                      child: Avatar(
                        initialOf(faces[i].displayName),
                        toneFor(faces[i].id),
                        url: faces[i].avatarUrl,
                        size: 26,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One timeline entry: avatar gutter, header, body, actions, comments.
class FeedPost extends StatelessWidget {
  const FeedPost(this.p, {super.key});
  final PostDto p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final a = p.author;
    final info = postTypeInfo(p.type);
    final big =
        p.kind == PostKind.discussion ||
        p.kind == PostKind.poll ||
        p.type == PostType.question;
    final cOpen = s.openC.contains(p.id);
    final top = p.topComment;

    Widget action(
      Widget Function(Color) icon,
      String label,
      VoidCallback onTap, {
      bool on = false,
      required String semantics,
    }) {
      final c = on ? t.acc : t.muted;
      return Semantics(
        button: true,
        label: semantics,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 34,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon(c),
                  if (label.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: t.body(13, w: w500, c: c),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget Function(Color) svg(Ic i) =>
        (c) => SvgIcon(i, size: 18, color: c);
    Widget ggBox(Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: c, width: 1.8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'GG',
        style: t.body(10, w: w700, h: 1.2, c: c),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
      decoration: BoxDecoration(border: Border(bottom: t.dividerSide)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            initialOf(a.displayName),
            toneFor(a.id),
            url: a.avatarUrl,
            size: 42,
            fontSize: 16,
            onTap: () => s.openPlayer(a.username),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Gap(
              8,
              children: [
                Gap(
                  2,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => s.openPlayer(a.username),
                            child: Text(
                              a.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.body(15, w: w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: s.now,
                            builder: (context, now, _) => Text(
                              '@${a.username} · ${ago(p.createdAt, now)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.body(14, c: t.muted),
                            ),
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: 'Post options',
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => showPostMenu(context, p),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                '···',
                                style: t.body(14, w: w700, ls: 1, c: t.muted),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (s.rankLine(a.topGame).isNotEmpty)
                          Text(
                            s.rankLine(a.topGame),
                            style: t.body(12, c: t.muted),
                          ),
                        TypeTag(
                          p.type == PostType.discussion
                              ? 'GAME DISCUSSION'
                              : info.label.toUpperCase(),
                          t.tone(info.bg),
                          size: 8,
                          pad: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                        ),
                        if (p.game != null)
                          GameBadge(
                            p.game!.shortCode,
                            pad: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          ),
                        if (p.audience == PostAudience.connections)
                          Text(
                            t.up('CONNECTIONS'),
                            style: t.label(8, c: t.muted),
                          ),
                      ],
                    ),
                  ],
                ),
                Text(
                  p.text,
                  style: t.body(big ? 19 : 15, w: big ? w700 : w400, h: 1.4),
                ),
                if (p.media.isNotEmpty)
                  PhotoGrid(p.media.toList())
                else if (p.kind == PostKind.moment)
                  const _Clip(),
                if (p.poll != null) _PollView(p),
                if (p.recruit != null) _RecruitBox(p),
                if (top != null)
                  Dashed(
                    radius: 16,
                    onTap: () => s.toggleComments(p.id),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          top.author.displayName,
                          style: t.body(14, w: w700),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            top.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: t.body(14, c: t.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Actions bleed 8px each side so icons line up with the text.
                SizedBox(
                  height: 34,
                  child: LayoutBuilder(
                    builder: (context, c) => OverflowBox(
                      minWidth: c.maxWidth + 16,
                      maxWidth: c.maxWidth + 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          action(
                            svg(Ic.comment),
                            '${p.commentCount}',
                            () => s.toggleComments(p.id),
                            on: cOpen,
                            semantics: p.kind == PostKind.discussion
                                ? 'Answers'
                                : 'Comments',
                          ),
                          action(
                            ggBox,
                            '${p.ggCount}',
                            () => s.toggleGG(p),
                            on: p.myGG,
                            semantics: 'GG',
                          ),
                          action(
                            svg(Ic.play),
                            p.mine ? '' : 'Play',
                            () => s.playFrom(p),
                            semantics: 'Play',
                          ),
                          action(
                            svg(Ic.bookmark),
                            '',
                            () => s.toggleSave(p),
                            on: p.saved,
                            semantics: p.saved ? 'Saved' : 'Save',
                          ),
                          action(
                            svg(Ic.share),
                            '',
                            () => s.sharePost(p),
                            semantics: 'Share',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (cOpen) _Comments(p),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The ⋯ menu on a post: delete your own, report or block anyone else's.
Future<void> showPostMenu(BuildContext context, PostDto p) {
  final s = context.app;
  final a = p.author;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      Widget item(String label, VoidCallback onTap, {bool strong = false}) =>
          Pill(
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
      return ThemedDialog(
        children: [
          Text(
            p.mine ? 'Your post' : 'Post by ${a.displayName}',
            style: t.body(22, w: w800, ls: -.6),
          ),
          item('Copy link', () => s.sharePost(p)),
          if (p.mine)
            item('Delete post', () async {
              if (await confirm(
                context,
                title: 'Delete this post?',
                body: 'It’s gone for everyone, with its comments.',
                yes: 'Delete',
              )) {
                await s.deletePost(p);
              }
            }, strong: true)
          else ...[
            item(
              'Report post',
              () => showReportDialog(
                context,
                userId: a.id,
                name: a.displayName,
                postId: p.id,
              ),
            ),
            item(
              'Block ${a.displayName}',
              () => confirmBlock(context, userId: a.id, name: a.displayName),
              strong: true,
            ),
          ],
          Pill(
            'Cancel',
            onTap: () => Navigator.pop(context),
            expand: true,
            height: 44,
            size: 14,
            bg: Colors.transparent,
            border: 0,
          ),
        ],
      );
    },
  );
}

class _Clip extends StatelessWidget {
  const _Clip();

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return StripeBox(
      height: 190,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 12,
            child: Text(
              t.up('GAME MOMENT · CLIP'),
              style: t.label(9, c: t.accentText),
            ),
          ),
          Center(
            child: Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.accent,
                border: Border.all(color: t.onDark, width: 2),
              ),
              child: const PlayIcon(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A post's photos: one 220 tall, 2–4 in a 2-column grid of 140,
/// cover-cropped (D23). Tap opens them full screen.
class PhotoGrid extends StatelessWidget {
  const PhotoGrid(this.media, {super.key});
  final List<MediaDto> media;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final one = media.length == 1;
    return LayoutBuilder(
      builder: (context, c) {
        final w = one ? c.maxWidth : (c.maxWidth - 6) / 2;
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < media.length; i++)
              Semantics(
                button: true,
                label: 'Photo ${i + 1} of ${media.length}',
                child: GestureDetector(
                  onTap: () => showPhotos(context, media, i),
                  child: Container(
                    width: w,
                    height: one ? 220 : 140,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: t.dark,
                      border: t.border(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: NetPhoto(media[i].url),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A photo from the API, cover-cropped; a dark box until (or if) it loads.
class NetPhoto extends StatelessWidget {
  const NetPhoto(this.url, {super.key, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final dark = ColoredBox(color: context.rt.dark);
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      loadingBuilder: (_, child, progress) => progress == null ? child : dark,
      errorBuilder: (_, _, _) => dark,
    );
  }
}

/// Full-screen photos, swipe between them, pinch to zoom.
Future<void> showPhotos(BuildContext context, List<MediaDto> media, int at) =>
    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      useSafeArea: false,
      builder: (context) {
        final t = context.rt;
        return Stack(
          children: [
            PageView(
              controller: PageController(initialPage: at),
              children: [
                for (final m in media)
                  InteractiveViewer(
                    child: NetPhoto(m.url, fit: BoxFit.contain),
                  ),
              ],
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 10,
              right: 14,
              child: Semantics(
                label: 'Close photos',
                child: CloseBtn(onTap: () => Navigator.pop(context)),
              ),
            ),
            if (media.length > 1)
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 18,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    t.up('${media.length} PHOTOS · SWIPE'),
                    style: t.label(9, c: Colors.white70),
                  ),
                ),
              ),
          ],
        );
      },
    );

/// "ENDS IN 2D 4H" style time left on a poll.
String endsIn(DateTime end, DateTime now) {
  final d = end.difference(now);
  if (d.isNegative) return 'SOON';
  if (d.inDays > 0) return '${d.inDays}D ${d.inHours % 24}H';
  if (d.inHours > 0) return '${d.inHours}H ${d.inMinutes % 60}M';
  return '${d.inMinutes < 1 ? 1 : d.inMinutes}M';
}

/// A poll: bars stay hidden until I vote (or it closes).
class _PollView extends StatelessWidget {
  const _PollView(this.p);
  final PostDto p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final pl = p.poll!;
    final mine = pl.myVote?.toInt();
    final shown = mine != null || pl.closed;
    final tot = pl.totalVotes.toInt();
    final caption = pl.closed
        ? 'CLOSED'
        : mine != null
        ? 'YOU VOTED'
        : 'ENDS IN ${endsIn(pl.endsAt, s.now.value)}';
    return Gap(
      7,
      children: [
        for (final o in pl.options)
          Builder(
            builder: (context) {
              final pos = o.position.toInt();
              final pct = (o.votes / (tot < 1 ? 1 : tot) * 100).round();
              return Semantics(
                button: !shown,
                label: 'Vote ${o.label}',
                child: Tap(
                  onTap: shown ? null : () => s.vote(p, pos),
                  child: Container(
                    height: 42,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: t.surface,
                      border: t.border(),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                              widthFactor: shown ? pct / 100 : 0,
                              heightFactor: 1,
                              child: ColoredBox(
                                color: mine == pos ? t.pollMine : t.soft,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${o.label}${mine == pos ? '  ✓' : ''}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.body(14, w: w600),
                                ),
                              ),
                              if (shown)
                                Text('${pad2(pct)}%', style: t.digits(11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        Label('$tot VOTES · $caption', padLeft: 4),
      ],
    );
  }
}

/// Recruitment: slots, roles and Apply; mine opens its applications.
class _RecruitBox extends StatelessWidget {
  const _RecruitBox(this.p);
  final PostDto p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final r = p.recruit!;
    final applied = r.myApplication != null;
    final done = applied || p.mine;
    final label = p.mine
        ? 'Yours · ${r.applications} applied'
        : switch (r.myApplication) {
            ApplicationStatus.accepted => 'Accepted ✓',
            null => 'Apply',
            _ => 'Applied ✓',
          };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.soft,
        border: t.border(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(pad2(r.slots.toInt()), style: t.digits(22)),
              const SizedBox(height: 3),
              Text(t.up('SLOTS'), style: t.label(8)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.up('ROLES NEEDED'), style: t.label(9)),
                const SizedBox(height: 2),
                Text(
                  r.roles.isEmpty ? 'Any role' : r.roles,
                  style: t.body(14, w: w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Pill(
              label,
              onTap: applied || s.busy ? null : () => s.apply(p),
              height: 36,
              padH: 14,
              weight: w700,
              bg: done ? t.strong : t.accent,
              fg: done ? t.onStrong : t.onAccent,
            ),
          ),
        ],
      ),
    );
  }
}

/// The applications to my recruitment post, inside the app's bottom sheet.
class ApplicationsSheet extends StatelessWidget {
  const ApplicationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final list = s.apps;
    return Gap(
      10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text('Applications', style: t.body(24, w: w800, ls: -.8)),
            ),
            CloseBtn(
              onTap: s.closeSheet,
              size: 36,
              fontSize: 16,
              transparent: true,
            ),
          ],
        ),
        if (list == null)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (list.isEmpty)
          const EmptyNote('No applications yet. They show up here.')
        else
          RowList(
            children: [
              for (final a in list)
                Padding(
                  key: ValueKey(a.id),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Avatar(
                        initialOf(a.user.displayName),
                        toneFor(a.user.id),
                        url: a.user.avatarUrl,
                        size: 38,
                        fontSize: 15,
                        onTap: () => s.openPlayer(a.user.username),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.user.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.body(15, w: w700),
                            ),
                            Text(
                              s.rankLine(a.user.topGame).isEmpty
                                  ? '@${a.user.username}'
                                  : s.rankLine(a.user.topGame),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.body(12, c: t.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (a.status != ApplicationStatus.pending)
                        GestureDetector(
                          // The author may change the answer (D24).
                          onTap: () => s.decide(
                            a,
                            a.status != ApplicationStatus.accepted,
                          ),
                          child: TypeTag(
                            a.status == ApplicationStatus.accepted
                                ? 'ACCEPTED'
                                : 'DECLINED',
                            a.status == ApplicationStatus.accepted
                                ? t.accent
                                : t.grey,
                          ),
                        )
                      else ...[
                        Pill(
                          'Decline',
                          onTap: s.busy ? null : () => s.decide(a, false),
                          height: 32,
                          padH: 10,
                          bg: Colors.transparent,
                        ),
                        const SizedBox(width: 6),
                        Pill(
                          'Accept',
                          onTap: s.busy ? null : () => s.decide(a, true),
                          height: 32,
                          padH: 12,
                          weight: w700,
                          bg: t.accent,
                          fg: t.onAccent,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        if (s.appsCursor != null)
          Center(
            child: Pill(
              'Load more',
              onTap: () => s.loadApplications(more: true),
              height: 40,
              padH: 16,
              weight: w700,
            ),
          ),
      ],
    );
  }
}

class _Comments extends StatelessWidget {
  const _Comments(this.p);
  final PostDto p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final list = s.comments[p.id];
    final disc = p.kind == PostKind.discussion;
    final replying = s.replyTo[p.id];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashedLine(),
          const SizedBox(height: 10),
          Gap(
            10,
            children: [
              if (list == null)
                const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              for (final c in list ?? const <CommentDto>[]) ...[
                _CommentRow(p, c, key: ValueKey(c.id)),
                if (c.replies > 0 && s.replies[c.id] == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 39),
                    child: GestureDetector(
                      onTap: () => s.loadReplies(c),
                      child: Text(
                        'View ${c.replies} ${c.replies == 1 ? 'reply' : 'replies'}',
                        style: t.body(12, w: w700, c: t.muted),
                      ),
                    ),
                  ),
                for (final r in s.replies[c.id] ?? const <CommentDto>[])
                  Padding(
                    padding: const EdgeInsets.only(left: 39),
                    child: _CommentRow(p, r, key: ValueKey(r.id)),
                  ),
              ],
              if (replying != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Replying to ${replying.author.displayName}',
                        style: t.body(12, c: t.muted),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => s.update(() {
                        s.replyTo.remove(p.id);
                        s.cDraft[p.id] = '';
                      }),
                      child: Text(
                        'Cancel',
                        style: t.body(
                          12,
                          w: w700,
                          deco: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 4, 4, 4),
                decoration: BoxDecoration(
                  color: t.surface,
                  border: t.border(),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  children: [
                    Avatar(
                      s.init,
                      Tone.accent,
                      url: s.me?.avatarUrl,
                      size: 28,
                      fontSize: 12,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Field(
                        // Rebuilt with Reply's "@name " prefill.
                        key: ValueKey('c-${p.id}-${replying?.id}'),
                        value: s.cDraft[p.id] ?? '',
                        hint: disc ? 'Add your answer…' : 'Write a comment…',
                        size: 14,
                        onChanged: (v) => s.cDraft[p.id] = v,
                        onSubmitted: (_) => s.sendComment(p.id),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Pill(
                      'Send',
                      onTap: s.busy ? null : () => s.sendComment(p.id),
                      height: 30,
                      border: 0,
                      bg: t.dark,
                      fg: t.onDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow(this.p, this.c, {super.key});
  final PostDto p;
  final CommentDto c;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final a = c.author;
    final name = c.mine ? '${a.displayName} (you)' : a.displayName;
    final canDelete = c.mine || p.mine;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(
          initialOf(a.displayName),
          toneFor(a.id),
          url: a.avatarUrl,
          size: 30,
          fontSize: 12,
          onTap: () => s.openPlayer(a.username),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Gap(
            4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: t.sunken,
                  border: t.border(1.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => s.openPlayer(a.username),
                            child: Text(name, style: t.body(13, w: w700)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ValueListenableBuilder(
                          valueListenable: s.now,
                          builder: (context, now, _) => Text(
                            ago(c.createdAt, now),
                            style: t.digits(8, c: t.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(c.text, style: t.body(14, h: 1.35)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Wrap(
                  spacing: 12,
                  children: [
                    GestureDetector(
                      onTap: () => s.toggleCommentGG(c),
                      child: Text(
                        'GG ${c.ggCount}',
                        style: t.body(12, w: w700, c: c.myGG ? t.acc : t.text),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => s.replyToComment(p.id, c),
                      child: Text('Reply', style: t.body(12, w: w700)),
                    ),
                    if (canDelete)
                      GestureDetector(
                        onTap: () async {
                          if (await confirm(
                            context,
                            title: 'Delete this comment?',
                            body: c.parentId == null && c.replies > 0
                                ? 'Its replies go with it.'
                                : 'It’s gone for everyone.',
                            yes: 'Delete',
                          )) {
                            await s.deleteComment(c);
                          }
                        },
                        child: Text(
                          'Delete',
                          style: t.body(12, w: w700, c: t.muted),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => showReportDialog(
                          context,
                          userId: a.id,
                          name: a.displayName,
                          commentId: c.id,
                        ),
                        child: Text(
                          'Report',
                          style: t.body(12, w: w700, c: t.muted),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerifyNudge extends StatelessWidget {
  const _VerifyNudge();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Dashed(
      radius: 22,
      onTap: () => s.go(Screen.verify, () => s.code = ''),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm your email', style: t.body(15, w: w700)),
                Text(
                  'Needed to post a listing or connect. The code is in your inbox.',
                  style: t.body(13, c: t.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Enter code',
            style: t.body(13, w: w700, deco: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard(this.i, {super.key});
  final PlayInviteDto i;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox.dark(
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              Avatar(
                initialOf(i.from.displayName),
                toneFor(i.from.id),
                url: i.from.avatarUrl,
                size: 40,
                fontSize: 16,
                onDark: true,
                onTap: () => s.openPlayer(i.from.username),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.up('PLAY INVITE'),
                      style: t.label(8, c: t.accentText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${i.from.displayName} · ${i.game.name}',
                      style: t.body(16, w: w700, c: t.onDark),
                    ),
                    Text(
                      'Starts ${clock(i.startsAt)}',
                      style: t.body(12, c: t.onDark.withValues(alpha: .8)),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: s.now,
                builder: (context, now, _) => Text(
                  countdown(i.expiresAt, now),
                  style: t.digits(13, c: t.onDark),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Pill(
                  'I’m in',
                  onTap: () => s.answerInvite(i, true),
                  expand: true,
                  height: 42,
                  size: 14,
                  weight: w700,
                  bg: t.accent,
                  fg: t.onAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  'Not now',
                  onTap: () => s.answerInvite(i, false),
                  expand: true,
                  height: 42,
                  size: 14,
                  bg: Colors.transparent,
                  fg: t.onDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// An invite I sent, waiting for an answer until it expires.
class _SentInvite extends StatelessWidget {
  const _SentInvite(this.i, {super.key});
  final PlayInviteDto i;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox(
      radius: 22,
      padding: const EdgeInsets.all(12),
      onTap: () => s.openPlayer(i.to.username),
      child: Row(
        children: [
          Avatar(
            initialOf(i.to.displayName),
            toneFor(i.to.id),
            url: i.to.avatarUrl,
            size: 36,
            fontSize: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.up('INVITE SENT'), style: t.label(8, c: t.muted)),
                Text(
                  'Waiting for ${i.to.displayName} · ${i.game.name} at ${clock(i.startsAt)}',
                  maxLines: 2,
                  style: t.body(14, w: w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder(
            valueListenable: s.now,
            builder: (context, now, _) =>
                Text(countdown(i.expiresAt, now), style: t.digits(12)),
          ),
        ],
      ),
    );
  }
}

/// "Did you play with Dave?" — the product's main number, one tap.
class _CheckInCard extends StatelessWidget {
  const _CheckInCard(this.c, {super.key});
  final CheckInDto c;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox(
      radius: 24,
      color: t.soft,
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              Avatar(
                initialOf(c.other.displayName),
                toneFor(c.other.id),
                url: c.other.avatarUrl,
                size: 40,
                fontSize: 16,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Did you play with ${c.other.displayName}?',
                      style: t.body(17, w: w800, ls: -.3),
                    ),
                    if (c.game != null)
                      Text(c.game!.name, style: t.body(12, c: t.muted)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Pill(
                  'Yes, we played',
                  onTap: () => s.answerCheckIn(c, CheckInAnswer.played),
                  expand: true,
                  height: 42,
                  size: 14,
                  weight: w700,
                  bg: t.strong,
                  fg: t.onStrong,
                ),
              ),
              const SizedBox(width: 6),
              Pill(
                'Not yet',
                onTap: () => s.answerCheckIn(c, CheckInAnswer.notYet),
                height: 42,
                padH: 12,
                size: 14,
                bg: Colors.transparent,
              ),
              const SizedBox(width: 6),
              Pill(
                'No',
                onTap: () => s.answerCheckIn(c, CheckInAnswer.no),
                height: 42,
                padH: 12,
                size: 14,
                bg: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Your status and play days (on your profile).
class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final me = s.me!;
    final (label, tone) = statusLook(me.status, me.statusGame);
    return InkBox(
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              const Label('YOUR STATUS'),
              const Spacer(),
              Dot(t.tone(tone), size: 9, border: 1.5),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.body(14, w: w700),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (st, text) in const [
                (PlayerStatus.looking, 'Looking'),
                (PlayerStatus.playing, 'Playing'),
                (PlayerStatus.availableTonight, 'Tonight'),
                (PlayerStatus.notAvailable, 'Away'),
              ])
                Pill.chip(
                  text,
                  me.status == st,
                  () => s.setStatus(st),
                  height: 34,
                  padH: 12,
                  size: 13,
                ),
            ],
          ),
          const Label('DAYS I PLAY'),
          Row(
            children: [
              for (final d in Day.values) ...[
                Expanded(
                  child: Pill.chip(
                    dayLabel[d]!,
                    me.availableDays.contains(d),
                    () => s.toggleDay(d),
                    height: 34,
                    padH: 0,
                    size: 12,
                  ),
                ),
                if (d != Day.sun) const SizedBox(width: 4),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MyListing extends StatelessWidget {
  const _MyListing(this.l);
  final ListingDto l;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox(
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Gap(
        10,
        children: [
          Row(
            children: [
              const Label('YOUR LIVE LISTING'),
              const Spacer(),
              Text(t.up('EXPIRES IN '), style: t.label(8, c: t.muted)),
              ValueListenableBuilder(
                valueListenable: s.now,
                builder: (context, now, _) =>
                    Text(countdown(l.expiresAt, now), style: t.digits(13)),
              ),
            ],
          ),
          InkBox.dark(
            radius: 16,
            shadow: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
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
                        '${partyLabel(l.partySize)} · ${playWhenLabel[l.playWhen]} · ${platformLabel[l.platform]}',
                        style: t.body(12, c: t.onDark.withValues(alpha: .85)),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      t.up('FILLED'),
                      style: t.label(8, c: t.onDark.withValues(alpha: .7)),
                    ),
                    Text(
                      '${l.filled}/${l.partySize - 1}',
                      style: t.digits(16, c: t.onDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Pill(
                  'Share link',
                  onTap: () => s.shareListing(l),
                  expand: true,
                  height: 42,
                  size: 14,
                  weight: w700,
                  leading: const SvgIcon(Ic.share, size: 16),
                ),
              ),
              const SizedBox(width: 8),
              Pill(
                'Edit',
                onTap: s.busy ? null : s.openEditListing,
                height: 42,
                padH: 16,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  'Close listing',
                  onTap: s.busy ? null : s.closeMyListing,
                  expand: true,
                  height: 42,
                  size: 14,
                  bg: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
