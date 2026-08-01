import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/background_motion_preference.dart';
import 'package:phoenix_journeys/widgets/phoenix_ambient_overlay.dart';
import 'package:phoenix_journeys/widgets/phoenix_dynamic_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('renders a journey-specific dynamic environment', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PhoenixDynamicBackground(
          journeyId: 'hangzhou-west-lake',
          child: Scaffold(backgroundColor: Colors.transparent),
        ),
      ),
    );

    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ambient layer never blocks page interaction', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          fit: StackFit.expand,
          children: [
            TextButton(onPressed: () => tapped = true, child: const Text('继续')),
            const PhoenixAmbientOverlay(journeyId: 'xian-city-wall'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('继续'));
    expect(tapped, isTrue);
  });

  testWidgets('reduced motion setting persists and restores', (tester) async {
    final preference = BackgroundMotionPreference.instance;
    await preference.setReduceMotion(true);

    final stored = await SharedPreferences.getInstance();
    expect(preference.reduceMotion, isTrue);
    expect(stored.getBool('visual.reduceBackgroundMotion'), isTrue);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: BackgroundMotionSettingButton()),
      ),
    );
    expect(find.byKey(const ValueKey('background-motion-setting')), findsOneWidget);
  });

  test('journey palettes remain deterministic and differentiated', () {
    final lakeA = PhoenixBackgroundPalette.forJourney('hangzhou-west-lake');
    final lakeB = PhoenixBackgroundPalette.forJourney('hangzhou-west-lake');
    final desert = PhoenixBackgroundPalette.forJourney('dunhuang-mogao-caves');

    expect(lakeA.sky, lakeB.sky);
    expect(lakeA.water, isTrue);
    expect(desert.water, isFalse);
    expect(lakeA.sky, isNot(desert.sky));
  });
}
