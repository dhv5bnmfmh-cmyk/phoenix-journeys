import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/journey_memory_timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('parses normal and special journey memories with their real titles', () {
    final normal = JourneyMemoryEntry.parse(
      raw: '上海 · 外滩｜江风让我看见两个时代。',
      sequence: 2,
    );
    final special = JourneyMemoryEntry.parse(
      raw: '梦境 · 梦蝶竹林｜醒来以后，我还记得那只蝴蝶。',
      sequence: 1,
    );

    expect(normal.displayTitle, '上海 · 外滩');
    expect(normal.locationLabel, '上海 · 外滩');
    expect(normal.stampSymbol, '滩');
    expect(normal.memory, '江风让我看见两个时代。');

    expect(special.displayTitle, '文学漫游 · 庄周梦蝶');
    expect(special.locationLabel, '梦境 · 梦蝶竹林');
    expect(special.stampSymbol, '蝶');
    expect(special.memory, '醒来以后，我还记得那只蝴蝶。');
  });

  test('keeps an old unstructured memory readable', () {
    final legacy = JourneyMemoryEntry.parse(
      raw: '第一次完成 Phoenix Journey。',
      sequence: 1,
    );

    expect(legacy.displayTitle, '旅程回忆');
    expect(legacy.memory, '第一次完成 Phoenix Journey。');
    expect(legacy.stampSymbol, '记');
  });

  testWidgets('timeline shows each memory under its own journey', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'memories': <String>[
        '梦境 · 梦蝶竹林｜醒来以后，我还记得那只蝴蝶。',
        '上海 · 外滩｜江风让我看见两个时代。',
      ],
    });
    final state = AppState(clock: () => DateTime(2026, 7, 27));
    await state.load();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 520,
            child: JourneyMemoryTimeline(state: state),
          ),
        ),
      ),
    );

    expect(find.text('文学漫游 · 庄周梦蝶'), findsOneWidget);
    expect(find.text('上海 · 外滩'), findsOneWidget);
    expect(find.textContaining('北京之旅'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('journey-memory-card-0')));
    await tester.pumpAndSettle();

    final detail = find.byKey(const ValueKey('journey-memory-detail'));
    expect(detail, findsOneWidget);
    expect(
      find.descendant(
        of: detail,
        matching: find.text('醒来以后，我还记得那只蝴蝶。'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: detail,
        matching: find.textContaining('梦境 · 梦蝶竹林'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.text('永久收藏')),
      findsOneWidget,
    );
  });

  testWidgets('traditional mode converts collection labels consistently', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'traditional': true,
      'memories': <String>['梦境 · 梦蝶竹林｜醒来以后，我还记得那只蝴蝶。'],
    });
    final state = AppState(clock: () => DateTime(2026, 7, 27));
    await state.load();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            child: JourneyMemoryTimeline(state: state),
          ),
        ),
      ),
    );

    expect(find.text('文學漫遊 · 莊周夢蝶'), findsOneWidget);
    expect(find.textContaining('第 1 段'), findsOneWidget);
  });
}
