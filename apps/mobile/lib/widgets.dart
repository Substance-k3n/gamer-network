import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'data.dart';
import 'theme.dart';

// ---- icons (stroke icons from the design, drawn with currentColor) ----

enum Ic {
  back('<path d="M15 5l-7 7 7 7"/>', 2.4),
  bell('<path d="M6 16v-5a6 6 0 0112 0v5l2 2H4z"/><path d="M10 21h4"/>', 2.1),
  search('<circle cx="11" cy="11" r="6.5"/><path d="M16 16l5 5"/>', 2.4),
  image('<rect x="3" y="5" width="18" height="14" rx="3"/><circle cx="9" cy="10" r="1.6"/><path d="M21 16l-5-5-8 8"/>', 2.2),
  upload('<path d="M12 16V4M7 9l5-5 5 5M4 16v3a1 1 0 001 1h14a1 1 0 001-1v-3"/>', 2.2),
  home('<path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z"/>', 2.2),
  target('<circle cx="12" cy="12" r="6.5"/><path d="M12 2v4M12 18v4M2 12h4M18 12h4"/>', 2.2),
  groups('<circle cx="8.5" cy="9" r="3"/><circle cx="16" cy="9.5" r="2.5"/><path d="M3 19c0-3 2.5-5 5.5-5s5.5 2 5.5 5M15 14.2c3 0 6 1.5 6 4.8"/>', 2.2),
  user('<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-6.5 8-6.5s8 2.5 8 6.5"/>', 2.2),
  comment('<path d="M21 11.5a8.5 8.5 0 01-12.3 7.6L3.5 20.5l1.4-4.6A8.5 8.5 0 1121 11.5z"/>', 2),
  play('<circle cx="12" cy="12" r="6.5"/><path d="M12 2.5v4M12 17.5v4M2.5 12h4M17.5 12h4"/>', 2),
  bookmark('<path d="M6.5 3.5h11v17l-5.5-3.8-5.5 3.8z"/>', 2),
  share('<circle cx="18" cy="5.5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="18.5" r="2.5"/><path d="M8.2 10.8l7.6-4.1M8.2 13.2l7.6 4.1"/>', 2),
  plus('<path d="M12 5v14M5 12h14"/>', 2.6),
  up('<path d="M12 19V5M5 12l7-7 7 7"/>', 2.6),
  filter('<path d="M4 6h16M7 12h10M10 18h4"/>', 2.4),
  eye('<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>', 2),
  eyeOff('<path d="M3 3l18 18"/><path d="M10.6 5.1A10.8 10.8 0 0112 5c6.5 0 10 7 10 7a17.6 17.6 0 01-3.2 4.2M6.6 6.6A17.4 17.4 0 002 12s3.5 7 10 7a10.6 10.6 0 005.4-1.4"/><path d="M9.9 9.9a3 3 0 004.2 4.2"/>', 2),
  close('<path d="M6 6l12 12M18 6L6 18"/>', 2.4),
  check('<path d="M5 12.5l4.5 4.5L19 7.5"/>', 2.8);

  const Ic(this.body, this.stroke);
  final String body;
  final double stroke;
}

class SvgIcon extends StatelessWidget {
  const SvgIcon(this.icon, {super.key, this.size = 20, this.color});
  final Ic icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" '
        'stroke-width="${icon.stroke}" stroke-linecap="round" stroke-linejoin="round">${icon.body}</svg>',
        width: size,
        height: size,
        theme: SvgTheme(currentColor: color ?? context.rt.text),
      );
}

class PlayIcon extends StatelessWidget {
  const PlayIcon({super.key, this.size = 22});
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>',
        width: size,
        height: size,
        theme: SvgTheme(currentColor: context.rt.onAccent),
      );
}

// ---- interaction ----

/// Tap target with a small press-down.
class Tap extends StatefulWidget {
  const Tap({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<Tap> createState() => _TapState();
}

class _TapState extends State<Tap> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap != null && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: const Duration(milliseconds: 90),
          child: widget.child,
        ),
      );
}

/// Frosted backdrop for floating layers on the Glass skin; a no-op elsewhere.
class Frost extends StatelessWidget {
  const Frost({super.key, required this.child, required this.radius});
  final Widget child;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final b = context.rt.blur;
    if (b <= 0) return child;
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: b / 2, sigmaY: b / 2), child: child),
    );
  }
}

// ---- building blocks ----

/// The card: surface fill, skin border, skin shadow.
class InkBox extends StatelessWidget {
  const InkBox({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.color,
    this.shadow = 4,
    this.border = 2,
    this.onTap,
    this.clip = false,
  })  : dark = false,
        glow = false;

  /// Inverted panel (listing mode box, ID card, Groups hero).
  const InkBox.dark({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.shadow = 4,
    this.onTap,
    this.glow = true,
  })  : color = null,
        border = 0,
        clip = false,
        dark = true;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius, shadow, border;
  final Color? color;
  final VoidCallback? onTap;
  final bool clip, dark, glow;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final box = Container(
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: color ?? (dark ? t.dark : t.surface),
        borderRadius: BorderRadius.circular(radius),
        border: border > 0 ? t.border(border) : null,
        boxShadow: shadow > 0 ? (glow ? t.glow(shadow) : t.shadow(shadow)) : null,
      ),
      child: child,
    );
    return onTap == null ? box : Tap(onTap: onTap, child: box);
  }
}

/// Pill-shaped button / chip.
class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    this.onTap,
    this.bg,
    this.fg,
    this.height = 34,
    this.padH = 13,
    this.size = 13,
    this.weight = w600,
    this.border = 2,
    this.radius = 99,
    this.shadow = 0,
    this.glow = false,
    this.leading,
    this.trailing,
    this.expand = false,
    this.minWidth = 0,
  }) : on = null;

  /// Selectable chip: the skin's "on" colours when selected, card otherwise.
  const Pill.chip(
    this.label,
    bool selected,
    this.onTap, {
    super.key,
    this.height = 34,
    this.padH = 13,
    this.size = 13,
    this.border = 2,
    this.radius = 99,
    this.leading,
    this.minWidth = 0,
  })  : on = selected,
        bg = null,
        fg = null,
        weight = w600,
        shadow = 0,
        glow = false,
        trailing = null,
        expand = false;

  final String label;
  final VoidCallback? onTap;
  final Color? bg, fg;
  final bool? on;
  final double height, padH, size, border, radius, shadow, minWidth;
  final FontWeight weight;
  final bool glow, expand;
  final Widget? leading, trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final fill = on == null ? (bg ?? t.surface) : (on! ? t.chipOn : t.surface);
    final ink = on == null ? (fg ?? t.text) : (on! ? t.chipOnFg : t.text);
    return Tap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        constraints: BoxConstraints(minWidth: minWidth),
        padding: EdgeInsets.symmetric(horizontal: padH),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
          border: border > 0 ? t.border(border) : null,
          boxShadow: shadow > 0 ? (glow ? t.glow(shadow) : t.shadow(shadow)) : null,
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 6)],
            Flexible(child: Text(label, style: t.body(size, w: weight, c: ink), maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (trailing != null) ...[const SizedBox(width: 6), trailing!],
          ],
        ),
      ),
    );
  }
}

/// Full-width primary CTA (dark fill + glow) or accent (accent fill + shadow).
class BigButton extends StatelessWidget {
  const BigButton(this.label, {super.key, required this.onTap, this.accent = false, this.height = 56, this.size = 17});
  final String label;
  final VoidCallback onTap;
  final bool accent;
  final double height, size;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Pill(
      label,
      onTap: onTap,
      expand: true,
      height: height,
      size: size,
      weight: w700,
      bg: accent ? t.accent : t.dark,
      fg: accent ? t.onAccent : t.onDark,
      shadow: 4,
      glow: !accent,
    );
  }
}

class CircleBtn extends StatelessWidget {
  const CircleBtn({super.key, required this.child, this.onTap, this.size = 44, this.shadow = 0, this.bg, this.onDark = false, this.border = true});
  final Widget child;
  final VoidCallback? onTap;
  final double size, shadow;
  final Color? bg;
  final bool onDark, border;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Tap(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg ?? (onDark ? Colors.transparent : t.surface),
          border: !border ? null : (onDark ? t.darkBorder() : t.border()),
          boxShadow: shadow > 0 ? t.shadow(shadow) : null,
        ),
        child: child,
      ),
    );
  }
}

class BackBtn extends StatelessWidget {
  const BackBtn({super.key, required this.onTap, this.size = 44, this.onDark = false});
  final VoidCallback onTap;
  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) => CircleBtn(
        onTap: onTap,
        size: size,
        onDark: onDark,
        child: SvgIcon(Ic.back, size: size < 42 ? 18 : 20, color: onDark ? context.rt.onDark : context.rt.text),
      );
}

class CloseBtn extends StatelessWidget {
  const CloseBtn({super.key, required this.onTap, this.size = 44, this.transparent = false, this.fontSize = 20});
  final VoidCallback onTap;
  final double size, fontSize;
  final bool transparent;

  @override
  Widget build(BuildContext context) => CircleBtn(
        onTap: onTap,
        size: size,
        bg: transparent ? Colors.transparent : null,
        child: Text('×', style: context.rt.body(fontSize, w: w700, h: 1)),
      );
}

class Avatar extends StatelessWidget {
  const Avatar(this.init, this.tone, {super.key, this.size = 40, this.fontSize, this.border = 2, this.onDark = false, this.onTap, this.color});
  final String init;
  final Tone tone;
  final Color? color;
  final double size, border;
  final double? fontSize;
  final bool onDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final a = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? t.tone(tone, avatar: true),
        border: onDark ? t.darkBorder(border) : t.border(border),
      ),
      child: Text(init, style: t.body(fontSize ?? size * 0.4, w: w800, h: 1, c: color == t.accent ? t.onAccent : t.text)),
    );
    return onTap == null ? a : GestureDetector(onTap: onTap, child: a);
  }
}

/// Section caption (Silkscreen / mono / small caps depending on the skin).
class Label extends StatelessWidget {
  const Label(this.text, {super.key, this.color, this.size = 9, this.padLeft = 0});
  final String text;
  final Color? color;
  final double size, padLeft;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Padding(
      padding: EdgeInsets.only(left: padLeft),
      child: Text(t.up(text), style: t.label(size, c: color ?? t.muted)),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot(this.color, {super.key, this.size = 10, this.border = 0});
  final Color color;
  final double size, border;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: border > 0 ? context.rt.border(border) : null),
      );
}

/// Thin rounded progress track.
class Progress extends StatelessWidget {
  const Progress(this.fraction, {super.key, this.width = 120});
  final double fraction, width;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(color: t.blob, borderRadius: BorderRadius.circular(2)),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.centerLeft,
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
        widthFactor: fraction,
        heightFactor: 1,
        child: ColoredBox(color: t.glass ? t.text : t.dark),
      ),
    );
  }
}

/// Pill-track segmented control (age range, audience).
class Segmented extends StatelessWidget {
  const Segmented({super.key, required this.options, required this.value, required this.onChanged, this.height = 40});
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(99)),
      child: Row(
        children: [
          for (final o in options)
            Expanded(
              child: Pill(o, onTap: () => onChanged(o), border: 0, height: height, size: 14, expand: true, bg: o == value ? t.chipOn : Colors.transparent, fg: o == value ? t.chipOnFg : t.text),
            ),
        ],
      ),
    );
  }
}

/// Text input whose value lives in app state. Re-syncs when state changes
/// underneath it (e.g. "Reply" pre-filling a comment).
class Field extends StatefulWidget {
  const Field({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = '',
    this.size = 16,
    this.height,
    this.obscure = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.onSubmitted,
    this.keyboardType,
  });
  final String value, hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final double size;
  final double? height;
  final bool obscure, autofocus;
  final int? maxLines, minLines;
  final TextInputType? keyboardType;

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  late final _c = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(Field old) {
    super.didUpdateWidget(old);
    if (widget.value != _c.text) {
      _c.value = TextEditingValue(text: widget.value, selection: TextSelection.collapsed(offset: widget.value.length));
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final style = t.body(widget.size, h: widget.height);
    return TextField(
      controller: _c,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscure,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType: widget.keyboardType,
      keyboardAppearance: t.brightness,
      style: style,
      cursorColor: t.text,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: style.copyWith(color: t.faint),
        border: InputBorder.none,
        isCollapsed: true,
      ),
    );
  }
}

/// A Field inside a bordered box (pill by default).
class BoxField extends StatelessWidget {
  const BoxField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = '',
    this.height = 54,
    this.radius = 99,
    this.padH = 20,
    this.size = 16,
    this.border = 2,
    this.sunken = false,
    this.shadow = 0,
    this.obscure = false,
    this.autofocus = false,
    this.keyboardType,
    this.leading,
    this.trailing,
  });
  final String value, hint;
  final ValueChanged<String> onChanged;
  final double height, radius, padH, size, border, shadow;
  final bool sunken, obscure, autofocus;
  final TextInputType? keyboardType;
  final Widget? leading, trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padH),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: sunken ? t.sunken : t.surface,
        borderRadius: BorderRadius.circular(radius),
        border: t.border(border),
        boxShadow: shadow > 0 ? t.shadow(shadow) : null,
      ),
      child: Row(children: [
        if (leading != null) ...[leading!, const SizedBox(width: 10)],
        Expanded(child: Field(value: value, onChanged: onChanged, hint: hint, size: size, obscure: obscure, autofocus: autofocus, keyboardType: keyboardType)),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ]),
    );
  }
}

/// Password box with a show/hide eye.
class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.value, required this.onChanged, this.hint = 'Password', this.height = 54});
  final String value, hint;
  final ValueChanged<String> onChanged;
  final double height;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return BoxField(
      value: widget.value,
      hint: widget.hint,
      height: widget.height,
      obscure: !_show,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      trailing: Semantics(
        button: true,
        label: _show ? 'Hide password' : 'Show password',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _show = !_show),
          child: SizedBox(width: 36, height: 36, child: Center(child: SvgIcon(_show ? Ic.eyeOff : Ic.eye, size: 20, color: t.muted))),
        ),
      ),
    );
  }
}

/// Outlined tag pill.
class TagPill extends StatelessWidget {
  const TagPill(this.text, {super.key, this.size = 12, this.pad = const EdgeInsets.symmetric(horizontal: 10, vertical: 3)});
  final String text;
  final double size;
  final EdgeInsets pad;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      padding: pad,
      decoration: BoxDecoration(border: t.border(1.5), borderRadius: BorderRadius.circular(99)),
      child: Text(text, style: t.body(size, w: w600)),
    );
  }
}

/// Filled pill with a label-font game name.
class GameBadge extends StatelessWidget {
  const GameBadge(this.text, {super.key, this.pad = const EdgeInsets.symmetric(horizontal: 9, vertical: 4)});
  final String text;
  final EdgeInsets pad;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      padding: pad,
      decoration: BoxDecoration(color: t.dark, borderRadius: BorderRadius.circular(99)),
      child: Text(t.up(text), style: t.label(9, c: t.onDark)),
    );
  }
}

/// Small bordered label-font tag (post types).
class TypeTag extends StatelessWidget {
  const TypeTag(this.text, this.bg, {super.key, this.size = 9, this.pad = const EdgeInsets.symmetric(horizontal: 8, vertical: 3)});
  final String text;
  final Color? bg;
  final double size;
  final EdgeInsets pad;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      padding: pad,
      decoration: BoxDecoration(color: bg, border: t.border(1.5), borderRadius: BorderRadius.circular(99)),
      child: Text(t.up(text), style: t.label(size)),
    );
  }
}

/// Dashed rounded outline.
class Dashed extends StatelessWidget {
  const Dashed({super.key, required this.child, this.radius = 22, this.padding = EdgeInsets.zero, this.color, this.onTap});
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final w = CustomPaint(
      painter: _DashPainter(radius, t.dash, t.dashW),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
        child: child,
      ),
    );
    return onTap == null ? w : Tap(onTap: onTap, child: w);
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.radius, this.color, this.width);
  final double radius, width;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rr = RRect.fromRectAndRadius((Offset.zero & size).deflate(width / 2), Radius.circular(radius));
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    for (final m in (Path()..addRRect(rr)).computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, math.min(d + 6, m.length)), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.radius != radius || old.color != color || old.width != width;
}

class DashedLine extends StatelessWidget {
  const DashedLine({super.key, this.thickness, this.dash = 6, this.gap = 4});
  final double? thickness;
  final double dash, gap;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final w = thickness ?? t.dashW;
    return SizedBox(
      height: w,
      width: double.infinity,
      child: CustomPaint(painter: _LinePainter(w, dash, gap, t.dash)),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.t, this.dash, this.gap, this.color);
  final double t, dash, gap;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = t;
    for (double x = 0; x < size.width; x += dash + gap) {
      canvas.drawLine(Offset(x, t / 2), Offset(math.min(x + dash, size.width), t / 2), p);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.color != color || old.t != t;
}

/// Dark clip placeholder with diagonal stripes.
class StripeBox extends StatelessWidget {
  const StripeBox({super.key, required this.child, this.height, this.radius = 18});
  final Widget child;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: t.dark, border: t.border(), borderRadius: BorderRadius.circular(radius)),
      child: CustomPaint(painter: _StripePainter(t.onDark.withValues(alpha: .06)), child: child),
    );
  }
}

class _StripePainter extends CustomPainter {
  _StripePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 10;
    final span = size.width + size.height;
    for (double d = -size.height; d < span; d += 20 * math.sqrt2) {
      canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), p);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.color != color;
}

/// Picked media thumbnail; videos show a play badge (no inline player).
class MediaView extends StatelessWidget {
  const MediaView(this.item, {super.key});
  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    final bytes = item.bytes;
    if (bytes != null) return Image.memory(bytes, fit: BoxFit.cover, width: double.infinity, height: double.infinity, gaplessPlayback: true);
    return ColoredBox(
      color: t.dark,
      child: Center(child: CircleAvatar(radius: 20, backgroundColor: t.accent, child: const PlayIcon(size: 18))),
    );
  }
}

/// Rotate by degrees around the center (CSS transform: rotate()).
class Tilt extends StatelessWidget {
  const Tilt(this.deg, {super.key, required this.child});
  final double deg;
  final Widget child;

  @override
  Widget build(BuildContext context) => Transform.rotate(angle: deg * math.pi / 180, child: child);
}

/// Empty-state message in a dashed box.
class EmptyNote extends StatelessWidget {
  const EmptyNote(this.text, {super.key, this.pad = 22});
  final String text;
  final double pad;

  @override
  Widget build(BuildContext context) => Dashed(
        padding: EdgeInsets.all(pad),
        child: SizedBox(width: double.infinity, child: Text(text, textAlign: TextAlign.center, style: context.rt.body(14, c: context.rt.muted))),
      );
}

/// A list of rows inside one card, separated by the skin's row rule.
class RowList extends StatelessWidget {
  const RowList({super.key, required this.children, this.header});
  final List<Widget> children;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: t.surface, border: t.border(), borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: t.rowLineW, thickness: t.rowLineW, color: t.rowLine),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Column with uniform spacing (CSS flex gap).
class Gap extends StatelessWidget {
  const Gap(this.gap, {super.key, required this.children, this.cross = CrossAxisAlignment.stretch});
  final double gap;
  final List<Widget> children;
  final CrossAxisAlignment cross;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: cross,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(height: gap), children[i]],
        ],
      );
}

/// Horizontally scrolling chip row.
class ChipScroller extends StatelessWidget {
  const ChipScroller({super.key, required this.children, this.padding = EdgeInsets.zero, this.gap = 6});
  final List<Widget> children;
  final EdgeInsets padding;
  final double gap;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(children: [
          for (var i = 0; i < children.length; i++) ...[if (i > 0) SizedBox(width: gap), children[i]],
        ]),
      );
}

/// Page fill: solid skin background plus any radial glows (Glass).
class PageBackground extends StatelessWidget {
  const PageBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    return ColoredBox(
      color: t.bg,
      child: Stack(children: [
        for (final g in t.glows)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(center: g.center, radius: g.radius, colors: [g.color, g.color.withValues(alpha: 0)]),
              ),
            ),
          ),
        child,
      ]),
    );
  }
}

/// The rally rabbit, tinted for the active skin: body in the accent colour,
/// outlines and face in the colour drawn on top of it.
class RallyLogo extends StatelessWidget {
  const RallyLogo({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.rt;
    Widget layer(String name, Color c) => Image.asset('assets/logo/$name.png', width: size, height: size, color: c, colorBlendMode: BlendMode.srcIn, filterQuality: FilterQuality.medium);
    return Semantics(
      label: 'rally',
      image: true,
      child: SizedBox(width: size, height: size, child: Stack(children: [layer('fill', t.accent), layer('line', t.onAccent)])),
    );
  }
}
