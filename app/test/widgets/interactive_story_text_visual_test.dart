import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

bool _containsActiveHighlight(InlineSpan span) {
  if (span.style?.backgroundColor == const Color(0xFF8F1D18) &&
      span.style?.color == Colors.white &&
      span.style?.fontWeight == FontWeight.w900 &&
      span.style?.decoration == TextDecoration.none) {
    return true;
  }
  if (span is TextSpan) {
    return span.children?.any(_containsActiveHighlight) ?? false;
  }
  return false;
}

void main() {
  testWidgets(
    'explicit narration range paints a high-contrast active word',
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
      expect(_containsActiveHighlight(text.textSpan!), isTrue);
    },
  );
}
