import 'dart:ui' show FontFeature, lerpDouble;

import 'package:flutter/material.dart';

const w400 = FontWeight.w400;
const w500 = FontWeight.w500;
const w600 = FontWeight.w600;
const w700 = FontWeight.w700;
const w800 = FontWeight.w800;

/// A soft radial glow painted behind the page (Glass background).
class Glow {
  const Glow(this.center, this.radius, this.color);
  final Alignment center;
  final double radius;
  final Color color;

  Glow fade(double f) => Glow(center, radius, color.withValues(alpha: color.a * f));
}

/// Colour accents that change per skin (avatars, tags, statuses).
enum Tone { accent, soft, lav, grey, free, faint }

/// One complete skin of the app. Every widget reads its colours, borders,
/// shadows and fonts from here, so switching skins restyles everything.
///
/// Roles mirror the design's tokens: `surface` is the card fill, `dark` the
/// inverted fill (status/listing panels, primary buttons, nav bar),
/// `strong`/`onStrong` the "selected / connected" fill, `accent` the one
/// highlight colour.
@immutable
class RallyTheme extends ThemeExtension<RallyTheme> {
  const RallyTheme({
    required this.id,
    required this.name,
    required this.tagline,
    required this.brightness,
    required this.bg,
    this.glows = const [],
    required this.blob,
    required this.surface,
    required this.sunken,
    required this.popover,
    required this.bar,
    required this.dark,
    required this.onDark,
    required this.text,
    required this.muted,
    required this.faint,
    required this.accent,
    required this.accentText,
    required this.onAccent,
    required this.soft,
    required this.lav,
    required this.grey,
    required this.strong,
    required this.onStrong,
    required this.chipOn,
    required this.chipOnFg,
    required this.acc,
    required this.avatarAccent,
    required this.tagAccent,
    required this.pollMine,
    required this.line,
    this.lineW,
    required this.onDarkLine,
    this.onDarkLineW,
    required this.dash,
    required this.dashW,
    required this.divider,
    required this.dividerW,
    required this.rowLine,
    required this.rowLineW,
    required this.hard,
    required this.shadows,
    required this.glowShadows,
    required this.floatShadows,
    this.blur = 0,
    required this.bodyFont,
    this.displayFont,
    required this.labelFont,
    required this.labelWeight,
    required this.labelDelta,
    required this.labelSpacing,
    required this.labelUpper,
    required this.digitFont,
    required this.digitWeight,
    this.bigDigitFont,
    this.tabular = false,
  });

  final String id, name, tagline;
  final Brightness brightness;

  // surfaces
  final Color bg, blob, surface, sunken, popover, bar, dark, onDark;
  final List<Glow> glows;

  // text
  final Color text, muted, faint;

  // accents
  final Color accent, accentText, onAccent, soft, lav, grey, strong, onStrong, chipOn, chipOnFg, acc, avatarAccent, tagAccent, pollMine;

  // lines. A null width means "use the width the design asks for" (Inked);
  // otherwise every border collapses to the skin's hairline.
  final Color line, onDarkLine, dash, divider, rowLine;
  final double? lineW, onDarkLineW;
  final double dashW, dividerW, rowLineW;

  // depth
  final bool hard;
  final List<BoxShadow> shadows, glowShadows, floatShadows;
  final double blur;

  // type
  final String bodyFont, labelFont, digitFont;
  final String? displayFont, bigDigitFont;
  final FontWeight labelWeight, digitWeight;
  final double labelDelta, labelSpacing;
  final bool labelUpper, tabular;

  bool get glass => blur > 0;

  /// Some skin fonts lack symbols like ✓ and ↻; Outfit covers them.
  static const _fallback = ['Outfit'];

  // ---- helpers ----

  Color tone(Tone t, {bool avatar = false}) => switch (t) {
        Tone.accent => avatar ? avatarAccent : tagAccent,
        Tone.soft => soft,
        Tone.lav => lav,
        Tone.grey => grey,
        Tone.free => onDark,
        Tone.faint => faint,
      };

  Border border([double w = 2]) => Border.all(color: line, width: lineW ?? w);
  Border darkBorder([double w = 2]) => Border.all(color: onDarkLine, width: onDarkLineW ?? w);
  BorderSide get dividerSide => BorderSide(color: divider, width: dividerW);
  BorderSide get rowSide => BorderSide(color: rowLine, width: rowLineW);

  /// Card shadow. Inked uses a hard offset whose depth varies per element.
  List<BoxShadow> shadow([double y = 4]) => hard ? [BoxShadow(color: line, offset: Offset(0, y))] : shadows;

  /// Highlighted shadow for primary actions (peach under-shadow on Inked).
  List<BoxShadow> glow([double y = 4]) => hard ? [BoxShadow(color: accent, offset: Offset(0, y))] : glowShadows;

  TextStyle body(double size, {FontWeight w = w400, Color? c, double? ls, double? h, TextDecoration? deco}) {
    final display = w == w800 && displayFont != null;
    return TextStyle(
      fontFamily: display ? displayFont : bodyFont,
      fontWeight: display ? FontWeight.w900 : w,
      fontFamilyFallback: _fallback,
      fontSize: size,
      color: c ?? text,
      letterSpacing: ls,
      height: h,
      decoration: deco,
      decorationColor: c ?? text,
    );
  }

  /// Small caps-style section labels.
  TextStyle label(double size, {Color? c}) {
    final s = size + labelDelta;
    return TextStyle(fontFamily: labelFont, fontFamilyFallback: _fallback, fontWeight: labelWeight, fontSize: s, letterSpacing: s * labelSpacing, color: c ?? text, height: 1.2);
  }

  String up(String s) => labelUpper ? s.toUpperCase() : s;

  /// Counters, clocks and timers.
  TextStyle digits(double size, {Color? c}) {
    final big = size >= 16 && bigDigitFont != null;
    return TextStyle(
      fontFamily: big ? bigDigitFont : digitFont,
      fontWeight: big ? FontWeight.w900 : digitWeight,
      fontFamilyFallback: _fallback,
      fontSize: size,
      color: c ?? text,
      height: 1.1,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }

  @override
  RallyTheme copyWith() => this;

  @override
  RallyTheme lerp(covariant RallyTheme? o, double t) {
    if (o == null) return this;
    final b = t < .5 ? this : o; // non-numeric properties flip at the midpoint
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    double d(double x, double y) => lerpDouble(x, y, t)!;
    double? dn(double? x, double? y) => x == null || y == null ? (t < .5 ? x : y) : d(x, y);
    List<BoxShadow> sh(List<BoxShadow> x, List<BoxShadow> y) => BoxShadow.lerpList(x, y, t) ?? y;
    List<BoxShadow> asList(RallyTheme r, List<BoxShadow> soft, Color hardColor) => r.hard ? [BoxShadow(color: hardColor, offset: const Offset(0, 4))] : soft;
    return RallyTheme(
      id: b.id,
      name: b.name,
      tagline: b.tagline,
      brightness: b.brightness,
      bg: c(bg, o.bg),
      glows: [for (final g in glows) g.fade(1 - t), for (final g in o.glows) g.fade(t)],
      blob: c(blob, o.blob),
      surface: c(surface, o.surface),
      sunken: c(sunken, o.sunken),
      popover: c(popover, o.popover),
      bar: c(bar, o.bar),
      dark: c(dark, o.dark),
      onDark: c(onDark, o.onDark),
      text: c(text, o.text),
      muted: c(muted, o.muted),
      faint: c(faint, o.faint),
      accent: c(accent, o.accent),
      accentText: c(accentText, o.accentText),
      onAccent: c(onAccent, o.onAccent),
      soft: c(soft, o.soft),
      lav: c(lav, o.lav),
      grey: c(grey, o.grey),
      strong: c(strong, o.strong),
      onStrong: c(onStrong, o.onStrong),
      chipOn: c(chipOn, o.chipOn),
      chipOnFg: c(chipOnFg, o.chipOnFg),
      acc: c(acc, o.acc),
      avatarAccent: c(avatarAccent, o.avatarAccent),
      tagAccent: c(tagAccent, o.tagAccent),
      pollMine: c(pollMine, o.pollMine),
      line: c(line, o.line),
      lineW: dn(lineW, o.lineW),
      onDarkLine: c(onDarkLine, o.onDarkLine),
      onDarkLineW: dn(onDarkLineW, o.onDarkLineW),
      dash: c(dash, o.dash),
      dashW: d(dashW, o.dashW),
      divider: c(divider, o.divider),
      dividerW: d(dividerW, o.dividerW),
      rowLine: c(rowLine, o.rowLine),
      rowLineW: d(rowLineW, o.rowLineW),
      hard: b.hard,
      shadows: sh(asList(this, shadows, line), asList(o, o.shadows, o.line)),
      glowShadows: sh(asList(this, glowShadows, accent), asList(o, o.glowShadows, o.accent)),
      floatShadows: sh(floatShadows, o.floatShadows),
      blur: d(blur, o.blur),
      bodyFont: b.bodyFont,
      displayFont: b.displayFont,
      labelFont: b.labelFont,
      labelWeight: b.labelWeight,
      labelDelta: b.labelDelta,
      labelSpacing: b.labelSpacing,
      labelUpper: b.labelUpper,
      digitFont: b.digitFont,
      digitWeight: b.digitWeight,
      bigDigitFont: b.bigDigitFont,
      tabular: b.tabular,
    );
  }
}

// ---- the four skins (A–D in the design) ----

const _ink = Color(0xFF1E1C2B);
const _cream = Color(0xFFF7F5F1);
const _peach = Color(0xFFF4B183);

const inkedTheme = RallyTheme(
  id: 'inked',
  name: 'Inked',
  tagline: 'Hard shadows, segment digits',
  brightness: Brightness.light,
  bg: Color(0xFFE9E6E0),
  blob: Color(0xFFD6D2CA),
  surface: _cream,
  sunken: Color(0xFFE9E6E0),
  popover: _cream,
  bar: Color(0xFFE9E6E0),
  dark: _ink,
  onDark: _cream,
  text: _ink,
  muted: Color(0xFF5E5B66),
  faint: Color(0xFF8A8790),
  accent: _peach,
  accentText: _peach,
  onAccent: _ink,
  soft: Color(0xFFFBE3CF),
  lav: Color(0xFFC9CBEA),
  grey: Color(0xFFDCD8D0),
  strong: _ink,
  onStrong: _cream,
  chipOn: _ink,
  chipOnFg: _cream,
  acc: Color(0xFFC2703A),
  avatarAccent: _peach,
  tagAccent: _peach,
  pollMine: _peach,
  line: _ink,
  onDarkLine: _cream,
  dash: _ink,
  dashW: 2,
  divider: _ink,
  dividerW: 1.5,
  rowLine: _ink,
  rowLineW: 1.5,
  hard: true,
  shadows: [],
  glowShadows: [],
  floatShadows: [BoxShadow(color: Color(0x401E1C2B), offset: Offset(0, 4))],
  bodyFont: 'Outfit',
  labelFont: 'Silkscreen',
  labelWeight: w400,
  labelDelta: 0,
  labelSpacing: 0,
  labelUpper: false,
  digitFont: 'DSEG7',
  digitWeight: w400,
);

const softTheme = RallyTheme(
  id: 'soft',
  name: 'Soft clay',
  tagline: 'Pillowy, mint on stone',
  brightness: Brightness.light,
  bg: Color(0xFFEDEDEA),
  blob: Color(0xFFE1E1DD),
  surface: Color(0xFFF8F8F6),
  sunken: Color(0xFFEDEDEA),
  popover: Color(0xFFF8F8F6),
  bar: Color(0xFFEDEDEA),
  dark: Color(0xFF6A6A66),
  onDark: Color(0xFFF8F8F6),
  text: Color(0xFF2F2F2E),
  muted: Color(0xFF6B6B67),
  faint: Color(0xFF9A9A96),
  accent: Color(0xFFA6EBCB),
  accentText: Color(0xFFCFF7E3),
  onAccent: Color(0xFF2F2F2E),
  soft: Color(0xFFDDF6EA),
  lav: Color(0xFFF1E9B9),
  grey: Color(0xFFDCDCD8),
  strong: Color(0xFF4A4A48),
  onStrong: Color(0xFFF8F8F6),
  chipOn: Color(0xFFA6EBCB),
  chipOnFg: Color(0xFF2F2F2E),
  acc: Color(0xFF2E9E6E),
  avatarAccent: Color(0xFFA6EBCB),
  tagAccent: Color(0xFFA6EBCB),
  pollMine: Color(0xFFA6EBCB),
  line: Color(0xF2FFFFFF),
  lineW: 1,
  onDarkLine: Color(0xFFF8F8F6),
  dash: Color(0xFFCFCFCA),
  dashW: 2,
  divider: Color(0xFFDFDFDA),
  dividerW: 1,
  rowLine: Color(0xFFE4E4E0),
  rowLineW: 1,
  hard: false,
  shadows: [
    BoxShadow(color: Color(0x1A3C3C37), offset: Offset(0, 10), blurRadius: 22),
    BoxShadow(color: Color(0x123C3C37), offset: Offset(0, 2), blurRadius: 4),
  ],
  glowShadows: [
    BoxShadow(color: Color(0x736ED7AA), offset: Offset(0, 8), blurRadius: 20),
    BoxShadow(color: Color(0x1F3C785F), offset: Offset(0, 2), blurRadius: 4),
  ],
  floatShadows: [BoxShadow(color: Color(0x383C3C37), offset: Offset(0, 12), blurRadius: 26)],
  bodyFont: 'Manrope',
  labelFont: 'Manrope',
  labelWeight: w700,
  labelDelta: 0,
  labelSpacing: .06,
  labelUpper: false,
  digitFont: 'Manrope',
  digitWeight: w700,
  tabular: true,
);

const dotTheme = RallyTheme(
  id: 'dot',
  name: 'Dot matrix',
  tagline: 'Matte black, signal red',
  brightness: Brightness.dark,
  bg: Color(0xFF101010),
  blob: Color(0xFF1A1A1A),
  surface: Color(0xFF1B1B1B),
  sunken: Color(0xFF141414),
  popover: Color(0xFF1B1B1B),
  bar: Color(0xFF101010),
  dark: Color(0xFF232323),
  onDark: Color(0xFFEDEDED),
  text: Color(0xFFEDEDED),
  muted: Color(0xFF8C8C8C),
  faint: Color(0xFF6E6E6E),
  accent: Color(0xFFFF4D2A),
  accentText: Color(0xFFFF4D2A),
  onAccent: Color(0xFF0E0E0E),
  soft: Color(0xFF3A1C14),
  lav: Color(0xFF2C2C2C),
  grey: Color(0xFF2A2A2A),
  strong: Color(0xFFEDEDED),
  onStrong: Color(0xFF1B1B1B),
  chipOn: Color(0xFFFF4D2A),
  chipOnFg: Color(0xFF0E0E0E),
  acc: Color(0xFFFF4D2A),
  avatarAccent: Color(0xFF3A1C14),
  tagAccent: Color(0xFF3A1C14),
  pollMine: Color(0xFF5A2414),
  line: Color(0xFF2E2E2E),
  lineW: 1,
  onDarkLine: Color(0xFF5A5A5A),
  onDarkLineW: 1.5,
  dash: Color(0xFF444444),
  dashW: 1.5,
  divider: Color(0xFF262626),
  dividerW: 1,
  rowLine: Color(0xFF2E2E2E),
  rowLineW: 1,
  hard: false,
  shadows: [BoxShadow(color: Color(0x8C000000), offset: Offset(0, 14), blurRadius: 30)],
  glowShadows: [
    BoxShadow(color: Color(0xFFFF4D2A), spreadRadius: 1),
    BoxShadow(color: Color(0x38FF4D2A), offset: Offset(0, 10), blurRadius: 26),
  ],
  floatShadows: [BoxShadow(color: Color(0x99000000), offset: Offset(0, 14), blurRadius: 30)],
  bodyFont: 'Space Grotesk',
  displayFont: 'Doto',
  labelFont: 'Space Mono',
  labelWeight: w400,
  labelDelta: 1,
  labelSpacing: .04,
  labelUpper: true,
  digitFont: 'Space Mono',
  digitWeight: w700,
  bigDigitFont: 'Doto',
);

const _dk = Color(0xFF0E1128);

const glassTheme = RallyTheme(
  id: 'glass',
  name: 'Glass',
  tagline: 'Frosted panels, aurora glow',
  brightness: Brightness.dark,
  bg: _dk,
  glows: [
    Glow(Alignment(-.76, -.8), .9, Color(0x997C5CFF)),
    Glow(Alignment(.9, -.16), .63, Color(0x6B38D6BE)),
    Glow(Alignment(-.64, .76), .93, Color(0x61FF6E96)),
  ],
  blob: Color(0x12FFFFFF),
  surface: Color(0x1AFFFFFF),
  sunken: Color(0x590E1128),
  popover: Color(0xB81E2240),
  bar: Color(0x730E1128),
  dark: Color(0x29FFFFFF),
  onDark: Colors.white,
  text: Colors.white,
  muted: Color(0xB3FFFFFF),
  faint: Color(0x85FFFFFF),
  accent: Color(0xFF8FF0DC),
  accentText: Color(0xFF8FF0DC),
  onAccent: _dk,
  soft: Color(0x338FF0DC),
  lav: Color(0x4DB9A6FF),
  grey: Color(0x29FFFFFF),
  strong: Colors.white,
  onStrong: _dk,
  chipOn: Colors.white,
  chipOnFg: _dk,
  acc: Color(0xFF8FF0DC),
  avatarAccent: Color(0x4DB9A6FF),
  tagAccent: Color(0x338FF0DC),
  pollMine: Color(0x618FF0DC),
  line: Color(0x3DFFFFFF),
  lineW: 1,
  onDarkLine: Color(0x99FFFFFF),
  onDarkLineW: 1.5,
  dash: Color(0x52FFFFFF),
  dashW: 1.5,
  divider: Color(0x24FFFFFF),
  dividerW: 1,
  rowLine: Color(0x3DFFFFFF),
  rowLineW: 1,
  hard: false,
  shadows: [BoxShadow(color: Color(0x4D05081E), offset: Offset(0, 10), blurRadius: 30)],
  glowShadows: [BoxShadow(color: Color(0x598FF0DC), offset: Offset(0, 8), blurRadius: 28)],
  floatShadows: [BoxShadow(color: Color(0x6605081E), offset: Offset(0, 14), blurRadius: 34)],
  blur: 22,
  bodyFont: 'Plus Jakarta Sans',
  labelFont: 'Plus Jakarta Sans',
  labelWeight: w700,
  labelDelta: 1,
  labelSpacing: .08,
  labelUpper: true,
  digitFont: 'Plus Jakarta Sans',
  digitWeight: w700,
  tabular: true,
);

const rallyThemes = [inkedTheme, softTheme, dotTheme, glassTheme];

RallyTheme themeById(String? id) => rallyThemes.firstWhere((t) => t.id == id, orElse: () => inkedTheme);

ThemeData materialTheme(RallyTheme t) => ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      fontFamily: t.bodyFont,
      scaffoldBackgroundColor: t.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: t.accent, brightness: t.brightness, primary: t.text, surface: t.bg),
      textSelectionTheme: TextSelectionThemeData(cursorColor: t.text, selectionColor: t.accent.withValues(alpha: .4), selectionHandleColor: t.accent),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [t],
    );

extension RallyThemeContext on BuildContext {
  RallyTheme get rt => Theme.of(this).extension<RallyTheme>()!;
}

/// CSS-style elliptical radius "h1 h2 h3 h4 / v1 v2 v3 v4" in percent of the box.
BorderRadius blobRadius(double w, double h, List<double> hr, List<double> vr) => BorderRadius.only(
      topLeft: Radius.elliptical(w * hr[0] / 100, h * vr[0] / 100),
      topRight: Radius.elliptical(w * hr[1] / 100, h * vr[1] / 100),
      bottomRight: Radius.elliptical(w * hr[2] / 100, h * vr[2] / 100),
      bottomLeft: Radius.elliptical(w * hr[3] / 100, h * vr[3] / 100),
    );

String pad2(int n) => n.toString().padLeft(2, '0');

const mono = TextStyle(fontFamily: 'monospace', fontFamilyFallback: ['Menlo', 'Courier'], fontSize: 13);
