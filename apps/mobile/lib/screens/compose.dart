import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';

/// New post. Offers only the types the API takes today ([postable]):
/// photos, polls and recruitment wait for its later phases.
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
              for (final pt in postable)
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
