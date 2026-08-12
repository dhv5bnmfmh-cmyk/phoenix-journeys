import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phoenix_journeys/app.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows startup progress before app data is ready', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const PhoenixApp(),
      ),
    );

    expect(find.text('正在准备你的旅程…'), findsOneWidget);
  });


  testWidgets('invalid persisted identity shows safe startup retry state',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppState.activeJourneyIdStorageKey: 'removed-widget-journey',
      AppState.activeJourneyNamespaceStorageKey: 'journey/removed/widget',
      AppState.activeJourneyVersionStorageKey:
          AppState.activeJourneyIdentityVersion,
    });
    final state = AppState();
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const PhoenixApp(),
      ),
    );

    expect(state.loadStatus, AppLoadStatus.error);
    expect(find.text('旅程暂时停在登机口'), findsOneWidget);
    expect(find.textContaining('removed-widget-journey'), findsOneWidget);
    expect(find.text('重新尝试'), findsOneWidget);
    expect(find.text('PHOENIX JOURNEYS'), findsNothing);

    await tester.tap(find.text('重新尝试'));
    await tester.pumpAndSettle();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.activeJourneyId, 'removed-widget-journey');
    expect(find.text('旅程暂时停在登机口'), findsOneWidget);
  });

  testWidgets('shows the selected Beijing journey', (tester) async {
    final state = AppState(clock: () => DateTime(2026, 1, 1));
    await state.load();
    await state.activateJourney('beijing-forbidden-city');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const PhoenixApp(),
      ),
    );

    expect(find.text('PHOENIX JOURNEYS'), findsOneWidget);
    expect(find.text('两条路，一张图'), findsOneWidget);
    expect(find.text('开始北京 Journey'), findsOneWidget);
  });

  testWidgets('keeps the home shell while changing tabs', (tester) async {
    final state = AppState();
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const PhoenixApp(),
      ),
    );

    state.setTab(2);
    await tester.pump();

    expect(find.text('跟读训练'), findsWidgets);
    expect(state.selectedTab, 2);

    state.setTab(3);
    await tester.pump();

    expect(find.text('我的旅程'), findsOneWidget);
    expect(state.selectedTab, 3);
  });
}
