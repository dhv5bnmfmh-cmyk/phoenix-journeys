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
    expect(find.text('第一次走进紫禁城'), findsOneWidget);
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

    expect(find.text('我的旅程'), findsOneWidget);
    expect(state.selectedTab, 2);
  });
}
