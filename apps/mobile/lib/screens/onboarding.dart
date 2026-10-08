import 'package:flutter/material.dart';

import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'games.dart';

const _blobCurve = Cubic(.5, 0, .2, 1);

/// Soft background blob behind onboarding pages.
class Blob extends StatelessWidget {
  const Blob({super.key, required this.w, required this.h, required this.hr, required this.vr});
  final double w, h;
  final List<double> hr, vr;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: _blobCurve,
        width: w,
        height: h,
        decoration: BoxDecoration(color: context.rt.blob, borderRadius: blobRadius(w, h, hr, vr)),
      );
}

/// Page with a blob behind, scrolling content, and a CTA pinned to the bottom.
class OnboardFrame extends StatelessWidget {
  const OnboardFrame({super.key, required this.blob, required this.content, required this.bottom, this.gap = 12});
  final Widget blob;
  final List<Widget> content;
  final List<Widget> bottom;
  final double gap;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          blob,
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Gap(gap, children: content),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Gap(14, children: bottom),
              ),
            ],
          ),
        ],
      );
}

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.onBack, required this.fraction, required this.label});
  final VoidCallback onBack;
  final double fraction;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackBtn(onTap: onBack),
          Progress(fraction),
          SizedBox(width: 52, child: Text(label, textAlign: TextAlign.right, style: context.rt.body(14, w: w700))),
        ],
      );
}

TextStyle _title(RallyTheme t) => t.body(36, w: w800, ls: -1.4, h: 1.02);

/// "rally." wordmark.
/// "rally." wordmark, optionally led by the rabbit logo.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 22, this.logo = true});
  final double size;
  final bool logo;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final text = Text.rich(TextSpan(
      text: 'rally',
      style: t.body(size, w: w800, ls: size > 24 ? -1 : -.8),
      children: [TextSpan(text: '.', style: t.body(size, w: w800, c: t.glass || t.hard ? t.accent : t.acc))],
    ));
    if (!logo) return text;
    return Row(mainAxisSize: MainAxisSize.min, children: [RallyLogo(size: size * 1.35), SizedBox(width: size * .25), text]);
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    final i = s.introIdx;
    final intro = intros[i];
    const fade = Duration(milliseconds: 280);
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 600),
          curve: _blobCurve,
          left: intro.left,
          top: intro.top,
          child: Blob(w: 520, h: 440, hr: intro.hr, vr: intro.vr),
        ),
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Wordmark(),
                        GestureDetector(onTap: () => s.go(Screen.login), child: Text('Log in', style: t.body(14, w: w600, deco: TextDecoration.underline))),
                      ],
                    ),
                    const SizedBox(height: 26),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 50),
                      child: AnimatedSwitcher(
                        duration: fade,
                        child: Text(intro.kicker, key: ValueKey(i), textAlign: TextAlign.center, style: t.body(20, w: w700, h: 1.25)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 380,
                      child: Center(
                        child: SizedBox(
                          width: 342,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 360),
                            transitionBuilder: (child, a) => FadeTransition(
                              opacity: a,
                              child: ScaleTransition(scale: Tween(begin: .94, end: 1.0).animate(a), child: child),
                            ),
                            child: KeyedSubtree(key: ValueKey(i), child: const [_IntroId(), _IntroFind(), _IntroConnect()][i]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: fade,
                      child: Column(
                        key: ValueKey(i),
                        children: [
                          Text(intro.step, textAlign: TextAlign.center, style: t.body(24, w: w800, ls: -.6)),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 290),
                            child: Text(intro.body, textAlign: TextAlign.center, style: t.body(15, c: t.muted, h: 1.45)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
              child: i < 2
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 60,
                          child: GestureDetector(onTap: () => s.update(() => s.introIdx = 2), child: Text('Skip', style: t.body(14, c: t.faint))),
                        ),
                        Progress((i + 1) / 3),
                        SizedBox(
                          width: 60,
                          child: GestureDetector(
                            onTap: () => s.update(() => s.introIdx++),
                            child: Text('Next', textAlign: TextAlign.right, style: t.body(15, w: w700)),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Pill('Start', onTap: () => s.go(Screen.login), height: 46, padH: 34, size: 15, weight: w700, bg: t.dark, fg: t.onDark, shadow: 4, glow: true),
                        const SizedBox(height: 12),
                        GestureDetector(onTap: () => s.update(() => s.introIdx--), child: Text('Back', style: t.body(13, c: t.faint))),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---- intro illustrations (342 × 380 canvas, positions from the design) ----

class _IntroId extends StatelessWidget {
  const _IntroId();

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final faintLine = t.onDark.withValues(alpha: .4);
    Widget gameRow(String g, String r) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(border: Border.all(color: faintLine, width: 1.5), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(g, style: t.body(13, w: w700, c: t.onDark)), Text(r, style: t.body(13, c: t.onDark))],
          ),
        );
    Widget filled(String s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(99)),
          child: Text(s, style: t.body(11, w: w700)),
        );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 34,
          top: 24,
          width: 232,
          child: Tilt(
            -5,
            child: InkBox.dark(
              radius: 26,
              shadow: 6,
              padding: const EdgeInsets.all(16),
              child: Gap(0, children: [
                Row(children: [
                  Avatar('K', Tone.accent, color: t.accent, size: 48, border: 2.5, onDark: true, fontSize: 20),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Kaleb', style: t.body(19, w: w800, c: t.onDark)),
                    Text(t.up('GAMER ID'), style: t.label(8, c: t.accentText)),
                  ]),
                ]),
                const SizedBox(height: 14),
                gameRow('Valorant', 'Gold · Duelist'),
                const SizedBox(height: 6),
                gameRow('EA FC 25', 'Div 3'),
                const SizedBox(height: 10),
                Row(children: [
                  filled('PC'),
                  const SizedBox(width: 5),
                  filled('PS5'),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(border: t.darkBorder(1.5), borderRadius: BorderRadius.circular(99)),
                    child: Text('Competitive', style: t.body(11, w: w600, c: t.onDark)),
                  ),
                ]),
              ]),
            ),
          ),
        ),
        Positioned(
          right: 6,
          top: 250,
          child: Tilt(
            6,
            child: InkBox(
              radius: 99,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Dot(t.accent, border: 1.5),
                const SizedBox(width: 8),
                Text('Looking for players', style: t.body(14, w: w700)),
              ]),
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: 300,
          child: Tilt(
            -3,
            child: InkBox(radius: 14, shadow: 0, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text(t.up('RIOT ID · kaleb#ADD'), style: t.label(9))),
          ),
        ),
      ],
    );
  }
}

class _IntroFind extends StatelessWidget {
  const _IntroFind();

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 52,
          top: 14,
          width: 220,
          height: 200,
          child: Tilt(-7, child: Opacity(opacity: .9, child: InkBox(shadow: 0, child: const SizedBox.expand()))),
        ),
        Positioned(
          left: 30,
          top: 40,
          width: 252,
          child: Tilt(
            3,
            child: InkBox(
              shadow: 5,
              padding: const EdgeInsets.all(14),
              child: Gap(9, children: [
                Row(children: [
                  const Avatar('D', Tone.soft, size: 38, fontSize: 16),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Dave', style: t.body(15, w: w700)),
                      Text('Addis Ababa · PC', style: t.body(11, c: t.muted)),
                    ]),
                  ),
                  Text('02:14:09', style: t.digits(11)),
                ]),
                IntrinsicHeight(
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(
                      child: InkBox.dark(
                        shadow: 0,
                        radius: 14,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(t.up('RANKED'), style: t.label(8, c: t.accentText)),
                          Text('Valorant', style: t.body(15, w: w700, c: t.onDark)),
                          Text('Diamond', style: t.body(12, c: t.onDark.withValues(alpha: .85))),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 70,
                      child: InkBox(
                        color: t.soft,
                        shadow: 0,
                        radius: 14,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(t.up('NEED'), style: t.label(8)),
                          Text('Duo', style: t.body(17, w: w800)),
                        ]),
                      ),
                    ),
                  ]),
                ),
                Text('“Looking for a ranked duo tonight.”', style: t.body(13)),
                Pill('Connect', height: 36, bg: t.accent, fg: t.onAccent, size: 14, weight: w700, expand: true),
              ]),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 282,
          child: Tilt(
            -4,
            child: Row(children: [
              Pill('Mic on', bg: t.dark, fg: t.onDark, border: 0, height: 30, padH: 12, size: 12),
              const SizedBox(width: 6),
              const Pill('Tonight', height: 30, padH: 12, size: 12),
            ]),
          ),
        ),
      ],
    );
  }
}

class _IntroConnect extends StatelessWidget {
  const _IntroConnect();

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 40,
          top: 40,
          child: Row(children: [
            Tilt(-6, child: Avatar('K', Tone.accent, color: t.accent, size: 86, border: 3, fontSize: 34)),
            const SizedBox(width: 70, child: DashedLine(thickness: 3)),
            const Tilt(6, child: Avatar('D', Tone.lav, size: 86, border: 3, fontSize: 34)),
          ]),
        ),
        Positioned(
          left: 106,
          top: 142,
          child: Tilt(
            -3,
            child: InkBox(radius: 99, shadow: 3, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7), child: Text('Connected ✓', style: t.body(14, w: w700))),
          ),
        ),
        Positioned(
          left: 46,
          top: 206,
          width: 250,
          child: Tilt(
            2,
            child: InkBox.dark(
              shadow: 6,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.up('SESSION'), style: t.label(8, c: t.accentText)),
                    const SizedBox(height: 3),
                    Text('Valorant · Ranked duo', style: t.body(16, w: w700, c: t.onDark)),
                  ]),
                ),
                const SizedBox(width: 12),
                Text('21:00', style: t.digits(20, c: t.onDark)),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ---- auth & sign-up ----

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return OnboardFrame(
      gap: 14,
      blob: const Positioned(left: -40, top: -120, child: Blob(w: 480, h: 360, hr: [55, 45, 50, 50], vr: [50, 55, 45, 50])),
      content: [
        Align(alignment: Alignment.centerLeft, child: BackBtn(onTap: () => s.go(Screen.landing))),
        const SizedBox(height: 4),
        const Align(alignment: Alignment.centerLeft, child: RallyLogo(size: 72)),
        Text('Welcome back.', style: t.body(40, w: w800, ls: -1.5, h: 1)),
        Text('Your squad’s been busy.', style: t.body(15, c: t.muted)),
        const SizedBox(height: 0),
        BoxField(value: s.loginUser, hint: 'Email or username', keyboardType: TextInputType.emailAddress, onChanged: (v) => s.loginUser = v),
        PasswordField(value: s.loginPass, onChanged: (v) => s.loginPass = v),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => s.toast('Reset link sent to your email'),
            child: Text('Forgot password?', style: t.body(13, w: w600, deco: TextDecoration.underline)),
          ),
        ),
      ],
      bottom: [
        BigButton('Log in', onTap: s.doLogin),
        Center(
          child: Text.rich(TextSpan(text: 'New here? ', style: t.body(14, c: t.muted), children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: () => s.go(Screen.signup),
                child: Text('Create a profile', style: t.body(14, w: w700, deco: TextDecoration.underline)),
              ),
            ),
          ])),
        ),
      ],
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    Widget labeled(String label, Widget field) => Gap(4, children: [Label(label, padLeft: 18), field]);
    return OnboardFrame(
      blob: const Positioned(left: -120, top: -60, child: Blob(w: 460, h: 340, hr: [46, 54, 60, 40], vr: [55, 45, 55, 45])),
      content: [
        StepHeader(onBack: () => s.go(Screen.login), fraction: .25, label: 'Step 1'),
        const SizedBox(height: 0),
        Text('Who are you\nas a gamer?', style: _title(t)),
        Gap(10, children: [
          labeled('EMAIL', BoxField(value: s.email, hint: 'you@example.com', height: 52, keyboardType: TextInputType.emailAddress, onChanged: (v) => s.email = v)),
          labeled('DISPLAY NAME', BoxField(value: s.name, hint: 'Kaleb', height: 52, onChanged: (v) => s.update(() => s.name = v))),
          labeled('USERNAME', BoxField(value: s.handle, hint: 'kaleb.gg', height: 52, onChanged: (v) => s.handle = v)),
          labeled('PASSWORD', PasswordField(value: s.password, hint: 'At least 8 characters', height: 52, onChanged: (v) => s.password = v)),
          labeled('AGE RANGE', Segmented(options: const ['16–17', '18–24', '25–34', '35+'], value: s.age, onChanged: (v) => s.update(() => s.age = v))),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: t.soft, border: t.border(), borderRadius: BorderRadius.circular(99)),
              child: Text('Ethiopia · Addis Ababa', style: t.body(14, w: w600)),
            ),
            const SizedBox(width: 10),
            Text('Change', style: t.body(14, c: t.muted)),
          ]),
        ]),
      ],
      bottom: [BigButton('Continue', onTap: s.submitSignup)],
    );
  }
}

/// Step layout whose middle region fills the space down to the bottom CTA.
class _FillStep extends StatelessWidget {
  const _FillStep({required this.blob, required this.header, required this.title, this.sub, required this.body, required this.cta});
  final Widget blob, header, body, cta;
  final String title;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    // Give the list room while the keyboard is up.
    final compact = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Stack(clipBehavior: Clip.hardEdge, children: [
      blob,
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0), child: header),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: compact
              ? const SizedBox(width: double.infinity, height: 12)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: Gap(8, children: [
                    Text(title, style: _title(t)),
                    if (sub != null) Text(sub!, style: t.body(14, c: t.muted)),
                  ]),
                ),
        ),
        Expanded(child: body),
        if (!compact) Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 28), child: cta),
      ]),
    ]);
  }
}

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final n = s.myGames.length;
    return _FillStep(
      blob: const Positioned(left: 60, top: -90, child: Blob(w: 460, h: 340, hr: [60, 40, 45, 55], vr: [50, 60, 40, 50])),
      header: StepHeader(onBack: () => s.go(Screen.signup), fraction: .5, label: 'Step 2'),
      title: 'What do you play?',
      sub: 'Pick every game you play. You’ll add ranks next.',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GamePicker(
          selected: s.myGames,
          onToggle: (id) => s.toggleGame(s.myGames, id),
          onAddCustom: (name) {
            final id = addCustomGame(name);
            if (!s.myGames.contains(id)) s.toggleGame(s.myGames, id);
          },
        ),
      ),
      cta: BigButton(n == 0 ? 'Pick at least one game' : 'Continue with $n game${n == 1 ? '' : 's'}', onTap: s.goRanks),
    );
  }
}

class RanksScreen extends StatelessWidget {
  const RanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    return _FillStep(
      blob: const Positioned(left: -80, top: -110, child: Blob(w: 460, h: 340, hr: [40, 60, 55, 45], vr: [45, 55, 45, 55])),
      header: StepHeader(onBack: () => s.go(Screen.games), fraction: .75, label: 'Step 3'),
      title: 'Your ranks.',
      sub: 'Tap your current tier in each game. Skip any you don’t play ranked.',
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
        itemCount: s.myGames.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final id = s.myGames[i];
          return RankCard(key: ValueKey(id), gameId: id, rank: s.ranks[id], onPick: (r) => s.update(() => s.ranks[id] = r));
        },
      ),
      cta: BigButton('Continue', onTap: () => s.go(Screen.platforms)),
    );
  }
}

class PlatformsScreen extends StatelessWidget {
  const PlatformsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.app;
    final t = context.rt;
    return OnboardFrame(
      blob: const Positioned(left: 40, top: -120, child: Blob(w: 460, h: 340, hr: [52, 48, 40, 60], vr: [50, 45, 55, 50])),
      content: [
        StepHeader(onBack: () => s.go(Screen.ranks), fraction: 1, label: 'Step 4'),
        const SizedBox(height: 0),
        Text('Platforms\n& gaming IDs.', style: _title(t)),
        const Label('PLATFORMS'),
        PlatformChips(selected: s.platforms, onToggle: (p) => s.toggleGame(s.platforms, p)),
        const Label('GAMING IDS · YOU CHOOSE WHO SEES THEM'),
        IdRows(ids: s.ids, vis: s.idVis, onChanged: (k, v) => s.ids[k] = v, onToggle: (k) => s.update(() => s.idVis[k] = !s.idVis[k]!)),
      ],
      bottom: [BigButton('Go live', accent: true, onTap: s.finishOnboarding)],
    );
  }
}

const platformNames = ['PC', 'PlayStation', 'Xbox', 'Mobile', 'Switch'];

class PlatformChips extends StatelessWidget {
  const PlatformChips({super.key, required this.selected, required this.onToggle});
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) => Wrap(spacing: 6, runSpacing: 6, children: [
        for (final p in platformNames) Pill.chip(p, selected.contains(p), () => onToggle(p), height: 36, padH: 14, size: 14),
      ]);
}

/// Gaming ID rows with a public/connections visibility toggle each.
class IdRows extends StatelessWidget {
  const IdRows({super.key, required this.ids, required this.vis, required this.onChanged, required this.onToggle});
  final Map<String, String> ids;
  final Map<String, bool> vis;
  final void Function(String key, String value) onChanged;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return RowList(children: [
      for (final k in ids.keys)
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
          child: Row(children: [
            SizedBox(width: 84, child: Text(k, style: t.body(13, w: w700))),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(height: 30, child: Align(alignment: Alignment.centerLeft, child: Field(value: ids[k]!, hint: 'Add ID', size: 14, onChanged: (v) => onChanged(k, v)))),
            ),
            const SizedBox(width: 10),
            _VisToggle(public: vis[k] ?? false, onTap: () => onToggle(k)),
          ]),
        ),
    ]);
  }
}

class _VisToggle extends StatelessWidget {
  const _VisToggle({required this.public, required this.onTap});
  final bool public;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Tap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: public ? t.strong : Colors.transparent, border: t.border(1.5), borderRadius: BorderRadius.circular(99)),
        child: Text(t.up(public ? 'PUBLIC' : 'CONNECTIONS'), style: t.label(9, c: public ? t.onStrong : t.text)),
      ),
    );
  }
}
