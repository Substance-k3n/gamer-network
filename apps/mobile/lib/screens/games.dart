import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// Searchable, platform-filterable catalog of games inside a scrolling card.
/// Fills whatever height its parent gives it.
class GamePicker extends StatefulWidget {
  const GamePicker({super.key, required this.selected, required this.onToggle, required this.onAddCustom});

  final List<String> selected;
  final ValueChanged<String> onToggle;

  /// Called with a typed name; should register it and select it.
  final ValueChanged<String> onAddCustom;

  @override
  State<GamePicker> createState() => _GamePickerState();
}

class _GamePickerState extends State<GamePicker> {
  String _q = '';
  Plat? _plat;

  Future<void> _addOther([String initial = '']) async {
    final name = await showAddGameDialog(context, initial: initial);
    if (name != null && name.trim().isNotEmpty) {
      widget.onAddCustom(name.trim());
      setState(() => _q = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final q = _q.trim();
    final pool = [...customGames.values, ...games];
    final shown = pool.where((g) => g.matches(q) && (_plat == null || g.custom || g.platforms.contains(_plat))).toList();
    final exact = pool.any((g) => g.name.toLowerCase() == q.toLowerCase());

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      BoxField(
        value: _q,
        hint: 'Search ${games.length}+ games',
        height: 48,
        padH: 16,
        onChanged: (v) => setState(() => _q = v),
        leading: SvgIcon(Ic.search, size: 18, color: t.muted),
        trailing: q.isEmpty
            ? null
            : GestureDetector(
                onTap: () => setState(() => _q = ''),
                child: SizedBox(width: 32, height: 32, child: Center(child: SvgIcon(Ic.close, size: 16, color: t.muted))),
              ),
      ),
      const SizedBox(height: 10),
      ChipScroller(children: [
        Pill.chip('All', _plat == null, () => setState(() => _plat = null), height: 32, padH: 12),
        for (final p in Plat.values) Pill.chip(p.label, _plat == p, () => setState(() => _plat = p), height: 32, padH: 12),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Label('${shown.length} GAMES', padLeft: 6),
        const Spacer(),
        Label('${widget.selected.length} SELECTED', color: widget.selected.isEmpty ? t.muted : t.text),
        const SizedBox(width: 6),
      ]),
      const SizedBox(height: 6),
      Expanded(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22), boxShadow: t.shadow(3)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (q.isNotEmpty && !exact) _AddRow('Add “$q” as your own game', onTap: () => _addOther(q)),
              if (shown.isEmpty && q.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                  child: Text('No match in the catalog.', textAlign: TextAlign.center, style: t.body(14, c: t.muted)),
                ),
              for (final g in shown) _GameRow(g, selected: widget.selected.contains(g.id), onTap: () => widget.onToggle(g.id)),
              _AddRow('Can’t find it? Add another game', onTap: _addOther, quiet: true),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _GameRow extends StatelessWidget {
  const _GameRow(this.g, {required this.selected, required this.onTap});
  final Game g;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final where = g.custom ? 'Added by you' : g.platforms.map((p) => p.label).join(' · ');
    return Semantics(
      button: true,
      selected: selected,
      label: g.name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? t.soft : Colors.transparent,
            border: Border(bottom: BorderSide(color: t.rowLine.withValues(alpha: .35), width: 1)),
          ),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: t.dark, borderRadius: BorderRadius.circular(12)),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(g.short, style: t.body(13, w: w800, c: t.onDark))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(15, w: w700)),
                const SizedBox(height: 2),
                Text(where, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(12, c: t.muted)),
              ]),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? t.accent : Colors.transparent,
                border: Border.all(color: selected ? t.accent : t.muted, width: 2),
              ),
              child: selected ? SvgIcon(Ic.check, size: 14, color: t.onAccent) : null,
            ),
          ]),
        ),
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow(this.label, {required this.onTap, this.quiet = false});
  final String label;
  final VoidCallback onTap;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: quiet ? Colors.transparent : t.accent, border: t.border(1.5), borderRadius: BorderRadius.circular(12)),
            child: SvgIcon(Ic.plus, size: 18, color: quiet ? t.text : t.onAccent),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.body(14, w: w700, c: quiet ? t.muted : t.text))),
        ]),
      ),
    );
  }
}

/// Asks for the name of a game that isn't in the catalog.
Future<String?> showAddGameDialog(BuildContext context, {String initial = ''}) {
  var name = initial;
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
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
            child: Gap(12, children: [
              Text('Add another game', style: t.body(22, w: w800, ls: -.6)),
              Text('It’ll show on your profile. You can type your rank or level for it.', style: t.body(14, c: t.muted, h: 1.35)),
              BoxField(value: name, hint: 'Game name', height: 50, sunken: true, autofocus: true, onChanged: (v) => name = v),
              Row(children: [
                Expanded(child: Pill('Cancel', onTap: () => Navigator.pop(context), expand: true, height: 46, size: 15, bg: Colors.transparent)),
                const SizedBox(width: 8),
                Expanded(
                  child: Pill('Add game', onTap: () => Navigator.pop(context, name), expand: true, height: 46, size: 15, weight: w700, bg: t.accent, fg: t.onAccent, shadow: 3),
                ),
              ]),
            ]),
          ),
        ),
      );
    },
  );
}

/// One game's rank selector: tier chips, or a text box for custom games.
/// Opens scrolled so the current pick is in view.
class RankCard extends StatefulWidget {
  const RankCard({super.key, required this.gameId, required this.rank, required this.onPick, this.onRemove});
  final String gameId;
  final String? rank;
  final ValueChanged<String> onPick;
  final VoidCallback? onRemove;

  @override
  State<RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  final _picked = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final c = _picked.currentContext;
      if (c != null && mounted) Scrollable.ensureVisible(c, alignment: .5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final RankCard(:gameId, :rank, :onPick, :onRemove) = widget;
    final g = gameById(gameId);
    final picked = rank != null && rank.isNotEmpty;
    return InkBox(
      radius: 22,
      padding: const EdgeInsets.fromLTRB(14, 12, 0, 12),
      child: Gap(10, children: [
        Padding(
          padding: EdgeInsets.only(right: onRemove == null ? 14 : 8),
          child: Row(children: [
            Expanded(child: Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(16, w: w700))),
            const SizedBox(width: 8),
            Text(t.up(picked ? rank.toUpperCase() : 'PICK A ${g.rankWord.toUpperCase()}'), style: t.label(9, c: picked ? t.text : t.muted)),
            if (onRemove != null) ...[
              const SizedBox(width: 6),
              Semantics(
                button: true,
                label: 'Remove ${g.name}',
                child: GestureDetector(
                  onTap: onRemove,
                  child: SizedBox(width: 32, height: 32, child: Center(child: SvgIcon(Ic.close, size: 16, color: t.muted))),
                ),
              ),
            ],
          ]),
        ),
        if (g.ranks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: BoxField(value: rank ?? '', hint: 'Your rank or level (optional)', height: 42, size: 14, padH: 14, sunken: true, border: 1.5, onChanged: onPick),
          )
        else
          ChipScroller(
            padding: const EdgeInsets.only(right: 14),
            children: [for (final r in g.ranks) Pill.chip(r, rank == r, () => onPick(r), key: rank == r ? _picked : null)],
          ),
      ]),
    );
  }
}

/// Bottom sheet holding a [GamePicker]. With [single], picking a game closes it.
Future<void> showGamePickerSheet(
  BuildContext context, {
  required String title,
  required List<String> Function() selected,
  required ValueChanged<String> onToggle,
  required ValueChanged<String> onAddCustom,
  bool single = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (context) {
      context.app; // rebuild as selections change
      final t = context.rt;
      const r = BorderRadius.vertical(top: Radius.circular(32));
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: FractionallySizedBox(
          heightFactor: .88,
          child: Frost(
            radius: r,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(color: t.glass ? t.popover : t.bg, border: t.border(), borderRadius: r),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(child: Opacity(opacity: .3, child: Container(width: 44, height: 5, decoration: BoxDecoration(color: t.text, borderRadius: BorderRadius.circular(3))))),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text(title, style: t.body(24, w: w800, ls: -.8))),
                  Pill('Done', onTap: () => Navigator.pop(context), height: 40, padH: 18, size: 15, weight: w700, bg: t.accent, fg: t.onAccent, shadow: 3),
                ]),
                const SizedBox(height: 12),
                Expanded(
                  child: GamePicker(
                    selected: selected(),
                    onToggle: (id) {
                      onToggle(id);
                      if (single) Navigator.pop(context);
                    },
                    onAddCustom: (name) {
                      onAddCustom(name);
                      if (single) Navigator.pop(context);
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    },
  );
}
