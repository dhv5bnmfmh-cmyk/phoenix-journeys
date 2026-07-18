import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

bool _containsYellowHighlight(InlineSpan span) {
  if (span.style?.backgroundColor == const Color(0xFFFFD05A)) return true;
  if (span is TextSpan) {
    return span.children?.any(_containsYellowHighlight) ?? false;
  }
  return false;
}

void main() {
  testWidgets(
    'explicit narration range paints a visible yellow word highlight',
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

      final text = tester.widget<Text>(
        find.byKey(const ValueKey('interactive-highlight-visual-test')),
      );
      expect(text.textSpan, isNotNull);
      expect(_containsYellowHighlight(text.textSpan!), isTrue);
    },
  );
}
