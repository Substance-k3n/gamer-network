import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'onboarding.dart' show Wordmark;

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

/// Home in the MVP (docs/API.md screen map): no feed. What needs you now
/// (invites, "did you play?"), your status, your listing, who's looking.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final me = s.me;
    return Column(
      children: [
        const _TopBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: s.refreshHome,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              children: [
                Gap(
                  14,
                  children: [
                    if (me != null && !me.emailVerified) const _VerifyNudge(),
                    for (final i in s.invites)
                      _InviteCard(i, key: ValueKey(i.id)),
                    for (final i in s.sentInvites)
                      _SentInvite(i, key: ValueKey(i.id)),
                    for (final c in s.checkIns)
                      _CheckInCard(c, key: ValueKey(c.id)),
                    if (me != null) const _StatusCard(),
                    s.myListing != null
                        ? _MyListing(s.myListing!)
                        : const _PostPrompt(),
                    const _LookingNow(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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

/// "Did you play with Dave?" — the product's main number, one tap.
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

class _StatusCard extends StatelessWidget {
  const _StatusCard();

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

class _PostPrompt extends StatelessWidget {
  const _PostPrompt();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox.dark(
      radius: 26,
      padding: const EdgeInsets.all(18),
      child: Gap(
        12,
        children: [
          Text(
            t.up('LOOKING FOR PLAYERS?'),
            style: t.label(9, c: t.accentText),
          ),
          Text(
            'Post what you want to play. It’s gone when you’re done.',
            style: t.body(22, w: w800, ls: -.6, h: 1.1, c: t.onDark),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Pill(
              'Post a listing',
              onTap: s.openListingSheet,
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
    );
  }
}

class _LookingNow extends StatelessWidget {
  const _LookingNow();

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return InkBox(
      radius: 24,
      onTap: () => s.go(Screen.find),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Text(pad2(s.lookingNow), style: t.digits(28)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'players looking right now in ${s.me?.city ?? 'your city'}',
              style: t.body(15, w: w600, h: 1.25),
            ),
          ),
          Text(
            'Find →',
            style: t.body(14, w: w700, deco: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
