import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'onboarding.dart' show Wordmark;

const _barH = 58.0;

/// Timeline-style home feed. The top bar slides away while scrolling down and
/// returns on scroll up; past a few posts a pill offers a jump back to the top.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  double _lastY = 0;
  bool _hideBar = false, _showPill = false;

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
    final hide = y < 60 ? false : d > 4 ? true : d < -4 ? false : _hideBar;
    final pill = y > 520;
    if (hide != _hideBar || pill != _showPill) {
      setState(() {
        _hideBar = hide;
        _showPill = pill;
      });
    }
  }

  void _toTop() {
    _scroll.animateTo(0, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
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
    final feed = s.feed;
    final mq = MediaQuery.of(context);
    final bottom = mq.padding.bottom;
    final keyboard = mq.viewInsets.bottom > 0;
    final options = s.feedOptions;
    final current = options.firstWhere((o) => o.$1 == s.feedTab, orElse: () => options.first);

    return ClipRect(
      child: Stack(children: [
        ListView(
          controller: _scroll,
          padding: const EdgeInsets.only(top: _barH, bottom: 120),
          children: [
            for (final p in feed) FeedPost(p, key: ValueKey(p.id)),
            if (feed.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Text(
                  'Nothing here yet. Connect with players from Find Players and their posts show up here.',
                  textAlign: TextAlign.center,
                  style: t.body(15, c: t.muted, h: 1.45),
                ),
              ),
          ],
        ),
        AnimatedSlide(
          offset: Offset(0, _hideBar ? -1 : 0),
          duration: const Duration(milliseconds: 280),
          curve: Curves.ease,
          child: Frost(radius: BorderRadius.zero, child: _TopBar(s)),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (c, a) => FadeTransition(opacity: a, child: ScaleTransition(scale: a, child: c)),
              child: _showPill ? _NewPostsPill(onTap: _toTop, key: const ValueKey('pill')) : const SizedBox.shrink(),
            ),
          ),
        ),
        if (s.filterOpen) ...[
          Positioned.fill(child: GestureDetector(onTap: () => s.update(() => s.filterOpen = false))),
          Positioned(
            left: 18,
            bottom: 162 + bottom,
            width: 220,
            child: Frost(
              radius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: t.popover, border: t.border(), borderRadius: BorderRadius.circular(22), boxShadow: t.shadow()),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Padding(padding: EdgeInsets.fromLTRB(10, 6, 10, 4), child: Label('SHOW IN FEED')),
                  for (final (id, label) in options)
                    Tap(
                      onTap: () => _pickFeed(s, id),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: s.feedTab == id ? t.accent : Colors.transparent, borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Expanded(child: Text(label, style: t.body(14, w: w600, c: s.feedTab == id ? t.onAccent : t.text))),
                          if (s.feedTab == id) Text('✓', style: t.body(14, w: w800, c: t.onAccent)),
                        ]),
                      ),
                    ),
                ]),
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
            child: CircleBtn(
              size: 58,
              bg: t.accent,
              shadow: 4,
              onTap: s.openCompose,
              child: SvgIcon(Ic.plus, size: 26, color: t.onAccent),
            ),
          ),
        ],
      ]),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar(this.s);
  final AppState s;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final reqs = s.requestIds.length;
    return Container(
      height: _barH,
      padding: const EdgeInsets.fromLTRB(16, 4, 14, 10),
      decoration: BoxDecoration(color: t.bar, border: Border(bottom: t.dividerSide)),
      child: Row(children: [
        Avatar(s.init, Tone.accent, size: 38, fontSize: 16, onTap: s.goProfileTab),
        const Spacer(),
        const Wordmark(size: 26),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => s.go(Screen.notifs),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Stack(alignment: Alignment.center, children: [
              const SvgIcon(Ic.bell, size: 23),
              if (reqs > 0)
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 17),
                    height: 17,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: t.accent, border: Border.all(color: t.hard ? t.line : t.bg, width: 1.5), borderRadius: BorderRadius.circular(9)),
                    child: Text('$reqs', style: t.body(10, w: w700, h: 1, c: t.onAccent)),
                  ),
                ),
            ]),
          ),
        ),
      ]),
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
    final faces = s.posts.where((p) => p.pid != 'me').take(3).map((p) => s.who(p.pid)).toList();
    return Tap(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
        decoration: BoxDecoration(color: t.accent, border: t.border(), borderRadius: BorderRadius.circular(99), boxShadow: t.shadow(3)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SvgIcon(Ic.up, size: 16, color: t.onAccent),
          const SizedBox(width: 8),
          // Faces overlap by 6px.
          SizedBox(
            width: faces.isEmpty ? 0 : 26 + 20.0 * (faces.length - 1),
            height: 26,
            child: Stack(children: [
              for (var i = 0; i < faces.length; i++) Positioned(left: 20.0 * i, child: Avatar(faces[i].init, faces[i].av, size: 26, fontSize: 11)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// One timeline entry: avatar gutter, header, body, attachments, actions.
class FeedPost extends StatelessWidget {
  const FeedPost(this.p, {super.key});
  final Post p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final w = s.who(p.pid);
    final tagName = p.tagName;
    final tdef = postTypeByLabel(tagName);
    final big = p.kind == PostKind.discussion || p.kind == PostKind.poll || tagName == 'Question';
    final mine = s.gg.contains(p.id);
    final cOpen = s.openC.contains(p.id);
    final saved = s.saved.contains(p.id);
    final game = gameByLabel(p.game);
    final handle = p.pid == 'me' ? s.handle : players[p.pid]!.handle;

    void findGame() => game != null ? s.go(Screen.find, () => s.filterGame = game.id) : s.openPlayer(p.pid);

    Widget action(Widget Function(Color) icon, String label, VoidCallback onTap, {bool on = false}) {
      final c = on ? t.acc : t.muted;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 34,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              icon(c),
              if (label.isNotEmpty) ...[const SizedBox(width: 6), Text(label, style: t.body(13, w: w500, c: c))],
            ]),
          ),
        ),
      );
    }

    Widget Function(Color) svg(Ic i) => (c) => SvgIcon(i, size: 18, color: c);
    Widget ggBox(Color c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          decoration: BoxDecoration(border: Border.all(color: c, width: 1.8), borderRadius: BorderRadius.circular(5)),
          child: Text('GG', style: t.body(10, w: w700, h: 1.2, c: c)),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 2),
      decoration: BoxDecoration(border: Border(bottom: t.dividerSide)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Avatar(w.init, w.av, size: 42, fontSize: 16, onTap: () => s.openPlayer(p.pid)),
        const SizedBox(width: 11),
        Expanded(
          child: Gap(8, children: [
            Gap(2, children: [
              Row(children: [
                GestureDetector(onTap: () => s.openPlayer(p.pid), child: Text(w.name, style: t.body(15, w: w700))),
                const SizedBox(width: 5),
                Expanded(child: Text('@$handle · ${p.time}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(14, c: t.muted))),
                Text('···', style: t.body(14, w: w700, ls: 1, c: t.muted)),
              ]),
              Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(s.rankLine(p.pid), style: t.body(12, c: t.muted)),
                if (tagName != null)
                  TypeTag(tagName == 'Discussion' ? 'GAME DISCUSSION' : tagName.toUpperCase(), tdef != null ? t.tone(tdef.bg) : t.lav, size: 8, pad: const EdgeInsets.symmetric(horizontal: 7, vertical: 2)),
              ]),
            ]),
            Text(p.text, style: t.body(big ? 19 : 15, w: big ? w700 : w400, h: 1.4)),
            if (p.kind == PostKind.moment) _Clip(p.dur ?? ''),
            if (p.media.isNotEmpty) _MediaGrid(p.media),
            if (p.poll != null) _PollView(p),
            if (p.recruit != null) _RecruitBox(p),
            if (p.top case (final name, final answer))
              Dashed(
                radius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: t.body(14, w: w700)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(answer, style: t.body(14, c: t.muted))),
                ]),
              ),
            // Actions bleed 8px each side so icons line up with the text.
            SizedBox(
              height: 34,
              child: LayoutBuilder(
                builder: (context, c) => OverflowBox(
                  minWidth: c.maxWidth + 16,
                  maxWidth: c.maxWidth + 16,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    action(svg(Ic.comment), '${s.commentCount(p)}', () => s.toggleComments(p.id), on: cOpen),
                    action(ggBox, '${p.gg + (mine ? 1 : 0)}', () => s.toggleGG(p.id), on: mine),
                    action(svg(Ic.play), p.pid == 'me' ? '' : 'Play', findGame),
                    action(svg(Ic.bookmark), '', () => s.toggleSave(p.id), on: saved),
                    action(svg(Ic.share), '', () => s.share(p)),
                  ]),
                ),
              ),
            ),
            if (cOpen) _Comments(p),
          ]),
        ),
      ]),
    );
  }
}

class _Clip extends StatelessWidget {
  const _Clip(this.dur);
  final String dur;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return StripeBox(
      height: 190,
      child: Stack(children: [
        Positioned(top: 10, left: 12, child: Text(t.up('GAME MOMENT · CLIP'), style: t.label(9, c: t.accentText))),
        Positioned(bottom: 10, left: 12, child: Text('clip placeholder', style: mono.copyWith(fontSize: 10, color: t.faint))),
        Positioned(bottom: 10, right: 12, child: Text(dur, style: t.digits(12, c: t.onDark))),
        Center(
          child: Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: t.accent, border: Border.all(color: t.onDark, width: 2)),
            child: const PlayIcon(),
          ),
        ),
      ]),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  const _MediaGrid(this.media);
  final List<MediaItem> media;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final one = media.length == 1;
    return LayoutBuilder(builder: (context, c) {
      final w = one ? c.maxWidth : (c.maxWidth - 6) / 2;
      return Wrap(spacing: 6, runSpacing: 6, children: [
        for (final m in media)
          Container(
            width: w,
            height: one ? 220 : 140,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: t.dark, border: t.border(), borderRadius: BorderRadius.circular(16)),
            child: MediaView(m),
          ),
      ]);
    });
  }
}

class _PollView extends StatelessWidget {
  const _PollView(this.p);
  final Post p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final pl = p.poll!;
    final pv = s.pollVote[p.id];
    final tot = pl.votes.fold(0, (a, b) => a + b) + (pv != null ? 1 : 0);
    return Gap(7, children: [
      for (var i = 0; i < pl.opts.length; i++)
        Builder(builder: (context) {
          final v = pl.votes[i] + (pv == i ? 1 : 0);
          final pct = (v / (tot < 1 ? 1 : tot) * 100).round();
          return Tap(
            onTap: () => s.vote(p.id, i),
            child: Container(
              height: 42,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(14)),
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      widthFactor: pv != null ? pct / 100 : 0,
                      heightFactor: 1,
                      child: ColoredBox(color: pv == i ? t.pollMine : t.soft),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${pl.opts[i]}${pv == i ? '  ✓' : ''}', style: t.body(14, w: w600)),
                    if (pv != null) Text('${pad2(pct)}%', style: t.digits(11)),
                  ]),
                ),
              ]),
            ),
          );
        }),
      Label('$tot VOTES · ${pv != null ? 'YOU VOTED' : 'ENDS IN ${pl.dur.toUpperCase()}'}', padLeft: 4),
    ]);
  }
}

class _RecruitBox extends StatelessWidget {
  const _RecruitBox(this.p);
  final Post p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final r = p.recruit!;
    final applied = s.applied.contains(p.id);
    final yours = p.pid == 'me';
    final done = applied || yours;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Column(children: [
          Text(r.slots, style: t.digits(22)),
          const SizedBox(height: 3),
          Text(t.up('SLOTS'), style: t.label(8)),
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.up('ROLES NEEDED'), style: t.label(9)),
            const SizedBox(height: 2),
            Text(r.roles.isEmpty ? 'Any role' : r.roles, style: t.body(14, w: w700)),
          ]),
        ),
        const SizedBox(width: 12),
        Pill(
          yours ? 'Yours' : applied ? 'Applied ✓' : 'Apply',
          onTap: () => s.apply(p),
          height: 36,
          padH: 14,
          weight: w700,
          bg: done ? t.strong : t.accent,
          fg: done ? t.onStrong : t.onAccent,
        ),
      ]),
    );
  }
}

class _Comments extends StatelessWidget {
  const _Comments(this.p);
  final Post p;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final list = s.comments[p.id] ?? const <Comment>[];
    final disc = p.kind == PostKind.discussion;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const DashedLine(),
        const SizedBox(height: 10),
        Gap(10, children: [
          for (var i = 0; i < list.length; i++) _CommentRow(p, list[i], '${p.id}:$i'),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 4, 4, 4),
            decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(99)),
            child: Row(children: [
              Avatar(s.init, Tone.accent, size: 28, fontSize: 12),
              const SizedBox(width: 8),
              Expanded(
                child: Field(
                  value: s.cDraft[p.id] ?? '',
                  hint: disc ? 'Add your answer…' : 'Write a comment…',
                  size: 14,
                  onChanged: (v) => s.cDraft[p.id] = v,
                  onSubmitted: (_) => s.sendComment(p.id),
                ),
              ),
              const SizedBox(width: 8),
              Pill('Send', onTap: () => s.sendComment(p.id), height: 30, border: 0, bg: t.dark, fg: t.onDark),
            ]),
          ),
        ]),
      ]),
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow(this.p, this.c, this.k);
  final Post p;
  final Comment c;
  final String k;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final w = s.who(c.pid);
    final g = s.cGG.contains(k);
    final canInvite = c.pid != 'me' && s.conn[c.pid] == Conn.connected;
    final name = c.pid == 'me' ? '${w.name} (you)' : w.name;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Avatar(w.init, w.av, size: 30, fontSize: 12, onTap: () => s.openPlayer(c.pid)),
      const SizedBox(width: 9),
      Expanded(
        child: Gap(4, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: t.sunken,
              border: t.border(1.5),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(child: GestureDetector(onTap: () => s.openPlayer(c.pid), child: Text(name, style: t.body(13, w: w700)))),
                const SizedBox(width: 8),
                Text(c.t, style: t.digits(8, c: t.muted)),
              ]),
              const SizedBox(height: 2),
              Text(c.text, style: t.body(14, h: 1.35)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Wrap(spacing: 12, children: [
              GestureDetector(onTap: () => s.toggleCommentGG(k), child: Text('GG ${c.gg + (g ? 1 : 0)}', style: t.body(12, w: w700, c: g ? t.acc : t.text))),
              GestureDetector(onTap: () => s.update(() => s.cDraft[p.id] = '@${w.name} '), child: Text('Reply', style: t.body(12, w: w700))),
              if (canInvite)
                GestureDetector(onTap: () => s.openPlayer(c.pid), child: Text('Play with $name', style: t.body(12, w: w700, deco: TextDecoration.underline))),
            ]),
          ),
        ]),
      ),
    ]);
  }
}
