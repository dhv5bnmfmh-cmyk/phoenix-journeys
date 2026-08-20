import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/home_shell.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('post-cover mobile Home accepts taps and navigation remains live',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final state = AppState(clock: () => DateTime.utc(2026, 8, 19));
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: HomeShell()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HomeShell), findsOneWidget);
    expect(find.text('Discovery · 今日发现').hitTestable(), findsOneWidget);

    final cityPicker = find.byKey(const ValueKey('choose-city-journey'));
    expect(cityPicker.hitTestable(), findsOneWidget);
    await tester.tap(cityPicker);
    await tester.pump();
    expect(find.byType(BottomSheet), findsWidgets);
    await tester.binding.handlePopRoute();
    await tester.pump();

    final levelGuide = find.byKey(const ValueKey('phoenix-level-guide'));
    expect(levelGuide.hitTestable(), findsOneWidget);
    await tester.tap(levelGuide);
    await tester.pump();
    expect(find.byType(BottomSheet), findsWidgets);
    await tester.binding.handlePopRoute();
    await tester.pump();

    final passportNav = find.text('护照').last;
    expect(passportNav.hitTestable(), findsOneWidget);
    await tester.tap(passportNav);
    await tester.pump();
    expect(state.selectedTab, 1);

    final exploreNav = find.text('探索').last;
    expect(exploreNav.hitTestable(), findsOneWidget);
    await tester.tap(exploreNav);
    await tester.pump();
    expect(state.selectedTab, 0);

    final startLabel = state.displayText('开始${state.activeJourney.city} Journey');
    final startJourney = find.text(startLabel);
    expect(startJourney.hitTestable(), findsOneWidget);
    await tester.tap(startJourney);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(JourneyScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(HomeShell), findsOneWidget);
    expect(state.selectedTab, 0);
  });
}
