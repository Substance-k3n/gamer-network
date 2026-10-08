import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final c = s.cp;
    void setC(VoidCallback fn) => s.update(fn);
    final typeUpper = c.type.toUpperCase();
    final typeTone = postTypeByLabel(c.type)?.bg;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      child: Gap(12, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CloseBtn(onTap: () => s.go(Screen.home)),
          Text('New post', style: t.body(20, w: w800, ls: -.5)),
          Pill('Post', onTap: s.submitPost, height: 42, padH: 20, size: 15, weight: w700, bg: c.ready ? t.accent : t.grey, fg: c.ready ? t.onAccent : t.text, shadow: 3),
        ]),
        const Label('POST TYPE'),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final pt in postTypes)
            Pill.chip(
              pt.label,
              c.type == pt.label,
              () => setC(() => c.type = pt.label),
              padH: 12,
              leading: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: t.tone(pt.bg), border: Border.all(color: c.type == pt.label ? t.chipOnFg : t.text, width: 1.5)),
              ),
            ),
        ]),
        InkBox(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Gap(10, children: [
            Row(children: [
              Avatar(s.init, Tone.accent, size: 38, fontSize: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: t.body(15, w: w700)),
                  Text('$typeUpper · ${c.aud == 'Everyone' ? 'EVERYONE' : 'CONNECTIONS'}', style: t.label(9, c: t.muted)),
                ]),
              ),
              TypeTag(typeUpper, typeTone == null ? null : t.tone(typeTone)),
            ]),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 110),
              child: Field(
                value: c.text,
                hint: postTypeByLabel(c.type)?.placeholder ?? '',
                size: 17,
                height: 1.4,
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                // Rebuild so the Post button lights up once there's text.
                onChanged: (v) => setC(() => c.text = v),
              ),
            ),
            if (c.type == 'Poll') _PollEditor(c),
            if (c.type == 'Recruitment') _RecruitEditor(c),
            if (c.files.isNotEmpty)
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < c.files.length; i++)
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(color: t.dark, border: t.border(), borderRadius: BorderRadius.circular(14)),
                      child: Stack(children: [
                        Positioned.fill(child: MediaView(c.files[i])),
                        if (c.files[i].isVideo) Positioned(left: 6, bottom: 6, child: Text(t.up('VIDEO'), style: t.label(8, c: t.accentText))),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CloseBtn(size: 24, fontSize: 12, onTap: () => setC(() => c.files = [...c.files]..removeAt(i))),
                        ),
                      ]),
                    ),
                ],
              )
            else
              Dashed(
                radius: 16,
                padding: const EdgeInsets.all(16),
                onTap: s.pickMedia,
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: t.dark, borderRadius: BorderRadius.circular(12)),
                    child: SvgIcon(Ic.upload, color: t.onDark),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Add photos or a clip', style: t.body(14, w: w700)),
                    Text('Up to 4 files · images or video', style: t.body(12, c: t.muted)),
                  ]),
                ]),
              ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: t.line, width: t.lineW ?? 1.5))),
              child: Row(children: [
                Pill('Media', onTap: s.pickMedia, padH: 12, border: 1.5, bg: Colors.transparent, leading: const SvgIcon(Ic.image, size: 15)),
                const SizedBox(width: 8),
                Pill('Poll', onTap: () => setC(() => c.type = 'Poll'), padH: 12, border: 1.5, bg: Colors.transparent),
                const Spacer(),
                Text('${pad2(c.files.length)}/04', style: t.digits(10, c: t.muted)),
              ]),
            ),
          ]),
        ),
        const Label('GAME'),
        ChipScroller(children: [
          for (final id in s.myGames) Pill.chip(gameById(id).name, c.game == id, () => setC(() => c.game = id)),
          Pill.chip('Any game', c.game == 'any', () => setC(() => c.game = 'any')),
        ]),
        const Label('WHO CAN SEE THIS'),
        Segmented(options: const ['Everyone', 'Connections'], value: c.aud, height: 38, onChanged: (v) => setC(() => c.aud = v)),
      ]),
    );
  }
}

class _PollEditor extends StatelessWidget {
  const _PollEditor(this.c);
  final ComposeDraft c;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(7, children: [
      for (var i = 0; i < c.poll.length; i++)
        Container(
          // Index in the key so removing a row doesn't reuse another row's controller.
          key: ValueKey('opt-$i-${c.poll.length}'),
          height: 44,
          padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
          decoration: BoxDecoration(color: t.sunken, border: t.border(), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            SizedBox(width: 22, child: Text(pad2(i + 1), style: t.digits(10))),
            const SizedBox(width: 6),
            Expanded(
              child: Field(
                value: c.poll[i],
                hint: 'Option ${i + 1}',
                size: 15,
                onChanged: (v) => s.update(() => c.poll[i] = v),
              ),
            ),
            if (c.poll.length > 2) CloseBtn(size: 28, fontSize: 14, transparent: true, onTap: () => s.update(() => c.poll = [...c.poll]..removeAt(i))),
          ]),
        ),
      if (c.poll.length < 5)
        Dashed(
          radius: 14,
          onTap: () => s.update(() => c.poll = [...c.poll, '']),
          child: SizedBox(height: 40, child: Center(child: Text('+ Add option', style: t.body(14, w: w600)))),
        ),
      Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
        const Padding(padding: EdgeInsets.only(right: 4), child: Label('POLL ENDS IN')),
        for (final d in const ['1 hour', '1 day', '3 days'])
          Pill.chip(d, c.pollDur == d, () => s.update(() => c.pollDur = d), height: 30, padH: 11, size: 12, border: 1.5),
      ]),
    ]);
  }
}

class _RecruitEditor extends StatelessWidget {
  const _RecruitEditor(this.c);
  final ComposeDraft c;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(16)),
      child: Gap(8, children: [
        Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Padding(padding: const EdgeInsets.only(right: 4), child: Label('SLOTS OPEN', color: t.text)),
          for (final x in const ['1', '2', '3', '4+'])
            Pill.chip(x, c.slots == x, () => s.update(() => c.slots = x), height: 30, padH: 10, minWidth: 34, border: 1.5),
        ]),
        BoxField(value: c.roles, hint: 'Roles needed — e.g. Sniper, Support', height: 40, radius: 12, padH: 12, size: 14, border: 1.5, onChanged: (v) => c.roles = v),
      ]),
    );
  }
}
