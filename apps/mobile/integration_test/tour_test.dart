import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rally/api.dart';
import 'package:rally/main.dart';
import 'package:rally/widgets.dart';

import 'app_e2e_test.dart' show see, tapText, tapOn, icon, login, nav, fill;

void main() {
  final b = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot tour', (t) async {
    await t.pumpWidget(
      RallyApp(
        api: Api(appVersion: '1.0.0', store: MemoryTokenStore()),
      ),
    );
    await b.convertFlutterSurfaceToImage();
    Future<void> shot(String n) async {
      await t.pump(const Duration(milliseconds: 1500));
      await b.takeScreenshot(n);
    }

    await see(t, 'Who are you as a gamer?');
    await tapText(t, 'Log in');
    await login(t, 'hana@rally.test');
    await see(t, 'YOUR STATUS');
    await shot('01-home');
    await nav(t, 'PLAYERS');
    await see(t, 'PLAYERS LOOKING');
    await shot('02-find');
    await tapText(t, 'Post a listing');
    await see(t, 'EXPIRES AFTER');
    await shot('03-listing-sheet');
    await tapText(t, '×');
    await tapOn(t, icon(Ic.search));
    await fill(t, 'Gamers by name or username', 'da');
    await see(t, 'Dave');
    await shot('04-search');
    await tapText(t, 'Dave');
    await see(t, '@dave.exe');
    await shot('05-dave-profile');
    await tapOn(t, icon(Ic.back));
    await tapOn(t, icon(Ic.back));
    await nav(t, 'YOU');
    await see(t, 'YOUR GAMER ID');
    await shot('06-my-profile');
    await tapText(t, 'Edit profile');
    await see(t, 'GAMES & RANKS');
    await shot('07-edit-profile');
    await tapText(t, '×');
    await nav(t, 'GROUPS');
    await shot('08-groups');
    await nav(t, 'HOME');
    await tapOn(t, icon(Ic.bell));
    await see(t, 'ACTIVITY');
    await shot('09-alerts');
  });
}
