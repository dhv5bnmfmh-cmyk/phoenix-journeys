import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_progress_header.dart';
import 'package:phoenix_journeys/widgets/word_mark.dart';

void main() {
  testWidgets('journey progress stays locked until completion', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyProgressHeader(
            currentStep: 2,
            furthestStep: 2,
            isCompleted: false,
            labels: const ['故事', '生词', '发现', '思考'],
            onStepSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('journey-progress-strip')), findsOneWidget);
    expect(find.text('3/4'), findsOneWidget);
    expect(find.text('发现'), findsOneWidget);
    expect(find.text('下一步 思考'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('journey-progress-strip')));
    await tester.pumpAndSettle();

    expect(find.text('请按顺序完成课程；全部完成后可自由选择页面。'), findsOneWidget);
    expect(find.text('选择学习步骤 · 课程已完成'), findsNothing);
  });

  testWidgets('completed journey opens free step navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyProgressHeader(
            currentStep: 3,
            furthestStep: 3,
            isCompleted: true,
            labels: const ['故事', '生词', '发现', '思考'],
            onStepSelected: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('journey-progress-strip')));
    await tester.pumpAndSettle();

    expect(find.text('选择学习步骤 · 课程已完成'), findsOneWidget);
    expect(find.text('故事'), findsOneWidget);
  });

  testWidgets('word mark uses the word itself instead of an unrelated image',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WordMark(word: '护城河'),
        ),
      ),
    );

    expect(find.text('护'), findsOneWidget);
    expect(find.text('🌊'), findsNothing);
  });
}
