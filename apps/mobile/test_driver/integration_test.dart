import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

// `flutter drive` entry for integration tests; screenshots land in
// build/screenshots.
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final f = File('build/screenshots/$name.png');
    await f.parent.create(recursive: true);
    await f.writeAsBytes(bytes);
    return true;
  },
);
