import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'shell.dart';
import 'state.dart';
import 'theme.dart';

const _themeKey = 'theme';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    RallyApp(
      api: Api(appVersion: await _appVersion(), store: SecureTokenStore()),
      themeId: prefs.getString(_themeKey),
      persistTheme: (id) => prefs.setString(_themeKey, id),
    ),
  );
}

/// The version sent as `X-App-Version`. The plugin can fail right after an
/// install; the app still has to start.
Future<String> _appVersion() async {
  try {
    return (await PackageInfo.fromPlatform()).version;
  } catch (_) {
    return '1.0.0';
  }
}

class RallyApp extends StatefulWidget {
  const RallyApp({
    super.key,
    required this.api,
    this.themeId,
    this.persistTheme,
    this.boot = true,
  });

  final Api api;
  final String? themeId;
  final void Function(String id)? persistTheme;

  /// Tests can drive [AppState] themselves instead of the launch sequence.
  final bool boot;

  @override
  State<RallyApp> createState() => RallyAppState();
}

class RallyAppState extends State<RallyApp> {
  late final state = AppState(
    api: widget.api,
    themeId: widget.themeId,
    persistTheme: widget.persistTheme,
  );

  @override
  void initState() {
    super.initState();
    if (widget.boot) state.boot();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: ValueListenableBuilder(
      valueListenable: state.theme,
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
