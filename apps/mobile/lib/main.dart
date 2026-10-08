import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shell.dart';
import 'state.dart';
import 'theme.dart';

const _themeKey = 'theme';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(RallyApp(
    themeId: prefs.getString(_themeKey),
    persistTheme: (id) => prefs.setString(_themeKey, id),
  ));
}

class RallyApp extends StatefulWidget {
  const RallyApp({super.key, this.start = Screen.landing, this.themeId, this.persistTheme});

  /// First screen shown; handy for tests and previews.
  final Screen start;
  final String? themeId;
  final void Function(String id)? persistTheme;

  @override
  State<RallyApp> createState() => _RallyAppState();
}

class _RallyAppState extends State<RallyApp> {
  late final _state = AppState(start: widget.start, themeId: widget.themeId, persistTheme: widget.persistTheme);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
        state: _state,
        child: ValueListenableBuilder(
          valueListenable: _state.theme,
          builder: (context, theme, _) => MaterialApp(
            title: 'rally.',
            debugShowCheckedModeBanner: false,
            theme: materialTheme(theme),
            // Skins blend into each other (colours/shadows lerp; fonts swap mid-way).
            themeAnimationDuration: const Duration(milliseconds: 350),
            themeAnimationCurve: Curves.easeInOut,
            home: const RallyShell(),
          ),
        ),
      );
}
