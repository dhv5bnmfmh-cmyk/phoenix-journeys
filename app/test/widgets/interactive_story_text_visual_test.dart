import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'explicit narration range highlights active text without a triangle',
    (tester) async {
      final state = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const MaterialApp(
            home: Scaffold(
              body: InteractiveStoryText(
                text: '故宫很美',
                entries: <WordEntry>[],
                narrationItemId: 'visual-test',
                highlightStart: 0,
                highlightEnd: 1,
              ),
            ),
          ),
        ),
      );

      final highlight = find.byKey(
        const ValueKey('reading-highlight-visual-test'),
      );
      expect(highlight, findsOneWidget);

      final highlightedText = tester.widget<Text>(
        find.descendant(of: highlight, matching: find.byType(Text)).first,
      );
      expect(highlightedText.style?.color, const Color(0xFFFFE7AA));
    },
  );
}
