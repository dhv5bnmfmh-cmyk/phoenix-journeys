import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/learning_playground_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/prototype_daily_mix.dart';
import 'package:phoenix_journeys/widgets/prototype_interactive_drama.dart';
import 'package:phoenix_journeys/widgets/prototype_role_adventure.dart';
import 'package:provider/provider.dart';

String _identity(String value) => value;

Widget _frame(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(width: 390, height: 900, child: child),
    ),
  );
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  testWidgets('the playground hub opens all three prototype modes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(home: LearningPlaygroundScreen()),
      ),
    );

    expect(find.text('Phoenix 玩法实验室'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('learning-lab-open-0')),
    );
    expect(find.byKey(const ValueKey('role-adventure-route')), findsOneWidget);

    await _tapVisible(tester, find.byKey(const ValueKey('learning-lab-back')));
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('learning-lab-open-1')),
    );
    expect(find.byKey(const ValueKey('daily-mix-layers')), findsOneWidget);

    await _tapVisible(tester, find.byKey(const ValueKey('learning-lab-back')));
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('learning-lab-open-2')),
    );
    expect(find.byKey(const ValueKey('drama-opening')), findsOneWidget);
  });

  testWidgets('role adventure creates a route-specific ending', (tester) async {
    await tester.pumpWidget(
      _frame(const RoleAdventurePrototype(text: _identity)),
    );

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('role-route-lake')),
    );

    final slider = tester.widget<Slider>(
      find.byKey(const ValueKey('role-view-slider')),
    );
    slider.onChanged?.call(.5);
    await tester.pump();
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('role-confirm-view')),
    );

    await tester.enterText(
      find.byKey(const ValueKey('role-dialogue-input')),
      '湖面有倒影，桥和远山看起来连在一起。',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('role-submit-dialogue')),
    );

    expect(find.text('结局：湖光倒影'), findsOneWidget);
  });

  testWidgets('daily mix rotates through three different interactions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const DailyMixPrototype(text: _identity)),
    );

    for (final placement in const [
      ('廊窗', 0),
      ('湖面', 1),
      ('远山', 2),
    ]) {
      await _tapVisible(
        tester,
        find.byKey(ValueKey<String>('daily-layer-card-${placement.$1}')),
      );
      await _tapVisible(
        tester,
        find.byKey(ValueKey<String>('daily-layer-slot-${placement.$2}')),
      );
    }
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('daily-check-layers')),
    );
    expect(find.byKey(const ValueKey('daily-mix-anomaly')), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('daily-anomaly-window')),
    );
    expect(find.byKey(const ValueKey('daily-mix-sentence')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('daily-sentence-input')),
      '长廊的窗户把远山借景到眼前。',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('daily-check-sentence')),
    );
    expect(find.text('今日三练完成'), findsOneWidget);
  });

  testWidgets('interactive drama uses evidence to unlock a verified ending', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(const InteractiveDramaPrototype(text: _identity)),
    );

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('drama-ally-painter')),
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('drama-clue-seal')),
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('drama-clue-watermark')),
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('drama-continue-evidence')),
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('drama-decision-verify')),
    );

    expect(find.text('结局：真相守护者'), findsOneWidget);
  });

  test('the web app exposes the learning playground query route', () {
    final source = File('lib/app.dart').readAsStringSync();

    expect(source, contains("queryParameters['prototype']"));
    expect(source, contains("prototype == 'learning-lab'"));
    expect(source, contains('LearningPlaygroundScreen'));
  });
}
