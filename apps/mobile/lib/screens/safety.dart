import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

// Block and Report on every profile and listing (ADR-0005, Play policy),
// Blocked users and Delete account in Settings.

/// The ⋯ menu on a profile or listing card.
Future<void> showPlayerMenu(
  BuildContext context, {
  required String userId,
  required String name,
  ListingDto? listing,
  bool connected = false,
}) {
  final s = context.app;
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
          Text(name, style: t.body(22, w: w800, ls: -.6)),
          if (listing != null)
            item('Copy share link', () => s.shareListing(listing)),
          if (connected)
            item(
              'Remove connection',
              () =>
                  confirmRemoveConnection(context, userId: userId, name: name),
            ),
          item(
            'Report',
            () => showReportDialog(
              context,
              userId: userId,
              name: name,
              listingId: listing?.id,
            ),
          ),
          item(
            'Block $name',
            () => confirmBlock(context, userId: userId, name: name),
            strong: true,
          ),
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

Future<void> confirmBlock(
  BuildContext context, {
  required String userId,
  required String name,
}) async {
  final s = context.app;
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text('Block $name?', style: t.body(22, w: w800, ls: -.6)),
          Text(
            'You won’t see each other anywhere on rally. Any connection between you ends, and they aren’t told.',
            style: t.body(14, c: t.muted, h: 1.35),
          ),
          Row(
            children: [
              Expanded(
                child: Pill(
                  'Cancel',
                  onTap: () => Navigator.pop(context, false),
                  expand: true,
                  height: 46,
                  size: 15,
                  bg: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  'Block',
                  onTap: () => Navigator.pop(context, true),
                  expand: true,
                  height: 46,
                  size: 15,
                  weight: w700,
                  bg: t.strong,
                  fg: t.onStrong,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  if (ok == true) await s.block(userId, name);
}

Future<void> showReportDialog(
  BuildContext context, {
  required String userId,
  required String name,
  String? listingId,
}) async {
  final s = context.app;
  ReportReason? reason;
  var details = '';
  final send = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final t = context.rt;
        return ThemedDialog(
          children: [
            Text('Report $name', style: t.body(22, w: w800, ls: -.6)),
            Text(
              'Only our team sees reports. What’s wrong?',
              style: t.body(14, c: t.muted, h: 1.35),
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final r in reasonLabel.keys)
                  Pill.chip(
                    reasonLabel[r]!,
                    reason == r,
                    () => setState(() => reason = r),
                    height: 36,
                    padH: 14,
                    size: 14,
                  ),
              ],
            ),
            BoxField(
              value: details,
              hint: 'Anything else? (optional)',
              height: 48,
              radius: 16,
              padH: 14,
              size: 15,
              sunken: true,
              onChanged: (v) => details = v,
            ),
            Row(
              children: [
                Expanded(
                  child: Pill(
                    'Cancel',
                    onTap: () => Navigator.pop(context, false),
                    expand: true,
                    height: 46,
                    size: 15,
                    bg: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Pill(
                    'Send report',
                    onTap: reason == null
                        ? null
                        : () => Navigator.pop(context, true),
                    expand: true,
                    height: 46,
                    size: 15,
                    weight: w700,
                    bg: reason == null ? t.grey : t.accent,
                    fg: reason == null ? t.text : t.onAccent,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
  if (send == true && reason != null) {
    await s.report(userId, reason!, listingId: listingId, details: details);
  }
}

Future<void> confirmDeleteAccount(BuildContext context) async {
  final s = context.app;
  var pw = '';
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text('Delete your account?', style: t.body(22, w: w800, ls: -.6)),
          Text(
            'Your listing closes, your connections end and your profile disappears now. Everything is erased after 30 days.',
            style: t.body(14, c: t.muted, h: 1.35),
          ),
          if (s.me?.hasPassword ?? false)
            PasswordField(
              value: pw,
              hint: 'Your password',
              height: 50,
              onChanged: (v) => pw = v,
            ),
          Row(
            children: [
              Expanded(
                child: Pill(
                  'Keep it',
                  onTap: () => Navigator.pop(context, false),
                  expand: true,
                  height: 46,
                  size: 15,
                  bg: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  'Delete',
                  onTap: () => Navigator.pop(context, true),
                  expand: true,
                  height: 46,
                  size: 15,
                  weight: w700,
                  bg: t.strong,
                  fg: t.onStrong,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  if (ok == true) await s.deleteAccount(pw);
}

/// Settings → Blocked users.
class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 40),
      child: Gap(
        14,
        children: [
          Row(
            children: [
              BackBtn(onTap: s.goProfileTab),
              const SizedBox(width: 12),
              Text('Blocked users', style: t.body(24, w: w800, ls: -.8)),
            ],
          ),
          if (s.blocked.isEmpty) const EmptyNote('No one is blocked.'),
          if (s.blocked.isNotEmpty)
            RowList(
              children: [
                for (final u in s.blocked)
                  Padding(
                    key: ValueKey(u.id),
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
                                '@${u.username}',
                                style: t.body(12, c: t.muted),
                              ),
                            ],
                          ),
                        ),
                        Pill(
                          'Unblock',
                          onTap: () => s.unblock(u),
                          height: 36,
                          padH: 14,
                          size: 13,
                          weight: w700,
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

/// A yes/no question in the active skin. True when they said yes.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String body,
  required String yes,
  String no = 'Cancel',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text(title, style: t.body(22, w: w800, ls: -.6)),
          Text(body, style: t.body(14, c: t.muted, h: 1.35)),
          Row(
            children: [
              Expanded(
                child: Pill(
                  no,
                  onTap: () => Navigator.pop(context, false),
                  expand: true,
                  height: 46,
                  size: 15,
                  bg: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Pill(
                  yes,
                  onTap: () => Navigator.pop(context, true),
                  expand: true,
                  height: 46,
                  size: 15,
                  weight: w700,
                  bg: t.strong,
                  fg: t.onStrong,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  return ok == true;
}

Future<void> confirmWithdraw(
  BuildContext context, {
  required String name,
  required VoidCallback onYes,
}) async {
  if (await confirm(
    context,
    title: 'Withdraw your request?',
    body: '$name won’t see it any more. You can ask again later.',
    yes: 'Withdraw',
    no: 'Keep it',
  )) {
    onYes();
  }
}

Future<void> confirmRemoveConnection(
  BuildContext context, {
  required String userId,
  required String name,
}) async {
  final s = context.app;
  if (await confirm(
    context,
    title: 'Remove $name?',
    body: 'You stop being connected: your private gaming IDs lock again, both ways. They aren’t told.',
    yes: 'Remove',
  )) {
    await s.removeConnection(userId, name);
  }
}

/// Settings → Change password.
Future<void> showChangePassword(BuildContext context) async {
  final s = context.app;
  var current = '', next = '';
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      final t = context.rt;
      return ThemedDialog(
        children: [
          Text('Change password', style: t.body(22, w: w800, ls: -.6)),
          Text(
            'Other phones signed in to your account stay signed in.',
            style: t.body(14, c: t.muted, h: 1.35),
          ),
          PasswordField(
            value: current,
            hint: 'Current password',
            height: 50,
            onChanged: (v) => current = v,
          ),
          PasswordField(
            value: next,
            hint: 'New password, 8+ characters',
            height: 50,
            onChanged: (v) => next = v,
          ),
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
                  'Change',
                  onTap: () async {
                    if (await s.changePassword(current, next) &&
                        context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  expand: true,
                  height: 46,
                  size: 15,
                  weight: w700,
                  bg: t.accent,
                  fg: t.onAccent,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
