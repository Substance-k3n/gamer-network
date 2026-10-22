import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// New post: any of the 11 types, up to 4 photos (images only for now),
/// a poll or a recruitment box.
class ComposeScreen extends StatelessWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final c = s.cp;
    void setC(VoidCallback fn) => s.update(fn);
    final info = postTypeInfo(c.type);
    final typeUpper = info.label.toUpperCase();
    final everyone = c.audience == PostAudience.everyone;
    final lit = c.ready && !s.busy;
    final games = [
      for (final g in s.me?.games ?? const <UserGameDto>[])
        if (g.game != null) g.game!,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      child: Gap(
        12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CloseBtn(onTap: () => s.go(Screen.home)),
              Text('New post', style: t.body(20, w: w800, ls: -.5)),
              Pill(
                s.busy ? 'Posting…' : 'Post',
                onTap: s.busy ? null : s.submitPost,
                height: 42,
                padH: 20,
                size: 15,
                weight: w700,
                bg: lit ? t.accent : t.grey,
                fg: lit ? t.onAccent : t.text,
                shadow: 3,
              ),
            ],
          ),
          const Label('POST TYPE'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final pt in postTypes)
                Pill.chip(
                  pt.label,
                  c.type == pt.type,
                  () => setC(() => c.type = pt.type),
                  padH: 12,
                  leading: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.tone(pt.bg),
                      border: Border.all(
                        color: c.type == pt.type ? t.chipOnFg : t.text,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          InkBox(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Gap(
              10,
              children: [
                Row(
                  children: [
                    Avatar(
                      s.init,
                      Tone.accent,
                      size: 38,
                      fontSize: 16,
                      url: s.me?.avatarUrl,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.myName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.body(15, w: w700),
                          ),
                          Text(
                            '$typeUpper · ${everyone ? 'EVERYONE' : 'CONNECTIONS'}',
                            style: t.label(9, c: t.muted),
                          ),
                        ],
                      ),
                    ),
                    TypeTag(typeUpper, t.tone(info.bg)),
                  ],
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 110),
                  child: Field(
                    value: c.text,
                    hint: info.placeholder,
                    size: 17,
                    height: 1.4,
                    maxLines: null,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    // Rebuild so the Post button lights up once there's text.
                    onChanged: (v) => setC(() => c.text = v),
                  ),
                ),
                if (c.type == PostType.poll) _PollEditor(c),
                if (c.type == PostType.recruitment) _RecruitEditor(c),
                if (c.photos.isNotEmpty)
                  GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var i = 0; i < c.photos.length; i++)
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: t.dark,
                            border: t.border(),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.memory(
                                  c.photos[i].bytes,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  errorBuilder: (_, _, _) =>
                                      ColoredBox(color: t.dark),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Semantics(
                                  label: 'Remove photo',
                                  child: CloseBtn(
                                    size: 24,
                                    fontSize: 12,
                                    onTap: () => s.removePhoto(i),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                else
                  Dashed(
                    radius: 16,
                    padding: const EdgeInsets.all(16),
                    onTap: s.pickPhotos,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: t.dark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgIcon(Ic.upload, color: t.onDark),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add photos', style: t.body(14, w: w700)),
                            Text(
                              'Up to $maxPhotos photos',
                              style: t.body(12, c: t.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (c.type == PostType.gameplay && c.photos.isEmpty)
                  Text(
                    'A gameplay post needs at least one photo.',
                    style: t.body(12, c: t.muted),
                  ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: t.line, width: t.lineW ?? 1.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Pill(
                        'Media',
                        onTap: s.pickPhotos,
                        padH: 12,
                        border: 1.5,
                        bg: Colors.transparent,
                        leading: const SvgIcon(Ic.image, size: 15),
                      ),
                      const SizedBox(width: 8),
                      Pill(
                        'Poll',
                        onTap: () => setC(() => c.type = PostType.poll),
                        padH: 12,
                        border: 1.5,
                        bg: Colors.transparent,
                      ),
                      const Spacer(),
                      Text(
                        '${pad2(c.photos.length)}/${pad2(maxPhotos)}',
                        style: t.digits(10, c: t.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Label('GAME'),
          ChipScroller(
            children: [
              for (final g in games)
                Pill.chip(
                  g.name,
                  c.gameId == g.id,
                  () => setC(() {
                    c.gameId = g.id;
                    c.gameSet = true;
                  }),
                ),
              Pill.chip(
                'Any game',
                c.gameId == null,
                () => setC(() {
                  c.gameId = null;
                  c.gameSet = true;
                }),
              ),
            ],
          ),
          const Label('WHO CAN SEE THIS'),
          Segmented(
            options: const ['Everyone', 'Connections'],
            value: everyone ? 'Everyone' : 'Connections',
            height: 38,
            onChanged: (v) => setC(
              () => c.audience = v == 'Everyone'
                  ? PostAudience.everyone
                  : PostAudience.connections,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2–4 options and how long the poll runs.
class _PollEditor extends StatelessWidget {
  const _PollEditor(this.c);
  final ComposeDraft c;

  static const _durations = {
    PollDuration.n1d: '1 day',
    PollDuration.n3d: '3 days',
    PollDuration.n1w: '1 week',
  };

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return Gap(
      7,
      children: [
        for (var i = 0; i < c.poll.length; i++)
          Container(
            // Index in the key so removing a row doesn't reuse another
            // row's controller.
            key: ValueKey('opt-$i-${c.poll.length}'),
            height: 44,
            padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
            decoration: BoxDecoration(
              color: t.sunken,
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
                    value: c.poll[i],
                    hint: 'Option ${i + 1}',
                    size: 15,
                    onChanged: (v) => s.update(() => c.poll[i] = v),
                  ),
                ),
                if (c.poll.length > 2)
                  CloseBtn(
                    size: 28,
                    fontSize: 14,
                    transparent: true,
                    onTap: () =>
                        s.update(() => c.poll = [...c.poll]..removeAt(i)),
                  ),
              ],
            ),
          ),
        if (c.poll.length < 4)
          Dashed(
            radius: 14,
            onTap: () => s.update(() => c.poll = [...c.poll, '']),
            child: SizedBox(
              height: 40,
              child: Center(
                child: Text('+ Add option', style: t.body(14, w: w600)),
              ),
            ),
          ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Label('POLL ENDS IN'),
            ),
            for (final d in _durations.entries)
              Pill.chip(
                d.value,
                c.pollDur == d.key,
                () => s.update(() => c.pollDur = d.key),
                height: 30,
                padH: 11,
                size: 12,
                border: 1.5,
              ),
          ],
        ),
      ],
    );
  }
}

/// Open slots (1, 2, 3, or 4+ then a number up to 10) and roles wanted.
class _RecruitEditor extends StatelessWidget {
  const _RecruitEditor(this.c);
  final ComposeDraft c;

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final many = c.slots >= 4;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: t.soft,
        border: t.border(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Gap(
        8,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Label('SLOTS OPEN', color: t.text),
              ),
              for (final n in const [1, 2, 3])
                Pill.chip(
                  '$n',
                  c.slots == n,
                  () => s.update(() => c.slots = n),
                  height: 30,
                  padH: 10,
                  minWidth: 34,
                  border: 1.5,
                ),
              Pill.chip(
                '4+',
                many,
                () => s.update(() => c.slots = many ? c.slots : 4),
                height: 30,
                padH: 10,
                minWidth: 34,
                border: 1.5,
              ),
            ],
          ),
          if (many)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var n = 4; n <= 10; n++)
                  Pill.chip(
                    '$n',
                    c.slots == n,
                    () => s.update(() => c.slots = n),
                    height: 30,
                    padH: 10,
                    minWidth: 34,
                    border: 1.5,
                  ),
              ],
            ),
          BoxField(
            value: c.roles,
            hint: 'Roles needed — e.g. Sniper, Support',
            height: 40,
            radius: 12,
            padH: 12,
            size: 14,
            border: 1.5,
            maxLength: maxRoles,
            onChanged: (v) => c.roles = v,
          ),
        ],
      ),
    );
  }
}
