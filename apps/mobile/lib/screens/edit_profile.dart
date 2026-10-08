import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games.dart';
import 'onboarding.dart' show IdRows, PlatformChips;

/// Edit your own profile: details, games and ranks, platforms and IDs.
/// Works on [AppState.edit] (a draft) until Save.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final d = s.edit;
    if (d == null) return const SizedBox.shrink();
    final dirty = d.differs(s);
    void set(VoidCallback fn) => s.update(fn);
    Widget labeled(String label, Widget field) => Gap(6, children: [Label(label, padLeft: 14), field]);

    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(children: [
            CloseBtn(onTap: s.closeEditProfile),
            Expanded(child: Text('Edit profile', textAlign: TextAlign.center, style: t.body(20, w: w800, ls: -.5))),
            Pill('Save', onTap: s.saveProfile, height: 42, padH: 20, size: 15, weight: w700, bg: dirty ? t.accent : t.grey, fg: dirty ? t.onAccent : t.text, shadow: 3),
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
                    Avatar(d.name.isEmpty ? '?' : d.name[0].toUpperCase(), Tone.accent, size: 60, fontSize: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(d.name.isEmpty ? 'Your name' : d.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(20, w: w800, ls: -.5)),
                        Text('@${d.handle} · ${d.city}', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body(13, c: t.muted)),
                      ]),
                    ),
                  ]),
                ),
                labeled('DISPLAY NAME', BoxField(value: d.name, hint: 'Kaleb', height: 50, onChanged: (v) => set(() => d.name = v))),
                labeled(
                  'USERNAME',
                  BoxField(value: d.handle, hint: 'kaleb.gg', height: 50, onChanged: (v) => set(() => d.handle = v), leading: Text('@', style: t.body(16, c: t.muted))),
                ),
                labeled(
                  'BIO',
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
                    child: Field(value: d.bio, hint: 'What do you play, and who are you looking for?', size: 15, height: 1.4, minLines: 3, maxLines: 5, keyboardType: TextInputType.multiline, onChanged: (v) => set(() => d.bio = v)),
                  ),
                ),
                labeled('CITY', BoxField(value: d.city, hint: 'Addis Ababa', height: 50, onChanged: (v) => set(() => d.city = v))),
                const SizedBox(height: 4),
                Row(children: [
                  const Label('GAMES & RANKS', padLeft: 6),
                  const Spacer(),
                  Label('${d.games.length} GAMES'),
                  const SizedBox(width: 6),
                ]),
                for (final id in d.games)
                  RankCard(
                    key: ValueKey(id),
                    gameId: id,
                    rank: d.ranks[id],
                    onPick: (r) => set(() => d.ranks[id] = r),
                    onRemove: () => set(() {
                      d.games.remove(id);
                      d.ranks.remove(id);
                    }),
                  ),
                Dashed(
                  radius: 22,
                  onTap: () => _openPicker(context, s, d),
                  child: SizedBox(
                    height: 52,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const SvgIcon(Ic.plus, size: 18),
                      const SizedBox(width: 8),
                      Text('Add or change games', style: t.body(15, w: w700)),
                    ]),
                  ),
                ),
                const SizedBox(height: 4),
                const Label('PLATFORMS', padLeft: 6),
                PlatformChips(selected: d.platforms, onToggle: (p) => s.toggleGame(d.platforms, p)),
                const SizedBox(height: 4),
                const Label('GAMING IDS · YOU CHOOSE WHO SEES THEM', padLeft: 6),
                IdRows(ids: d.ids, vis: d.idVis, onChanged: (k, v) => set(() => d.ids[k] = v), onToggle: (k) => set(() => d.idVis[k] = !(d.idVis[k] ?? false))),
              ]),
            ],
          ),
        ),
      ]),
      if (s.confirmDiscard) ...[
        Positioned.fill(child: GestureDetector(onTap: () => s.update(() => s.confirmDiscard = false), child: ColoredBox(color: Colors.black.withValues(alpha: .4)))),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12 + MediaQuery.paddingOf(context).bottom,
          child: Frost(
            radius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(color: t.glass ? t.popover : t.surface, border: t.border(), borderRadius: BorderRadius.circular(28), boxShadow: t.shadow()),
              child: Gap(12, children: [
                Text('Discard changes?', style: t.body(22, w: w800, ls: -.6)),
                Text('Your edits to this profile won’t be saved.', style: t.body(14, c: t.muted)),
                Row(children: [
                  Expanded(child: Pill('Keep editing', onTap: () => s.update(() => s.confirmDiscard = false), expand: true, height: 46, size: 15, bg: Colors.transparent)),
                  const SizedBox(width: 8),
                  Expanded(child: Pill('Discard', onTap: () => s.closeEditProfile(force: true), expand: true, height: 46, size: 15, weight: w700, bg: t.strong, fg: t.onStrong)),
                ]),
              ]),
            ),
          ),
        ),
      ],
    ]);
  }

  void _openPicker(BuildContext context, AppState s, ProfileDraft d) => showGamePickerSheet(
        context,
        title: 'Your games',
        selected: () => d.games,
        onToggle: (id) => s.update(() {
          if (d.games.remove(id)) {
            d.ranks.remove(id);
          } else {
            d.games.add(id);
          }
        }),
        onAddCustom: (name) {
          final id = addCustomGame(name);
          if (!d.games.contains(id)) s.update(() => d.games.add(id));
        },
      );
}
