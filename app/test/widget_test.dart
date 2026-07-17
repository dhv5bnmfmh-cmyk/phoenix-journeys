import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phoenix_journeys/app.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  testWidgets('shows the first Beijing journey', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const PhoenixApp(),
      ),
    );

    expect(find.text('PHOENIX JOURNEYS'), findsOneWidget);
    expect(find.text('第一次走进紫禁城'), findsOneWidget);
    expect(find.text('开始北京 Journey'), findsOneWidget);
  });
}
