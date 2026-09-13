import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

Iterable<TextSpan> _textSpans(InlineSpan span) sync* {
  if (span is! TextSpan) return;
  yield span;
  for (final child in span.children ?? const <InlineSpan>[]) {
    yield* _textSpans(child);
  }
}

void main() {
  const words = <WordEntry>[
    WordEntry(
      word: '紫禁城',
      pinyin: 'Zǐjìnchéng',
      simpleChinese: '北京的宫城',
      translation: 'Tử Cấm Thành',
      symbol: '🏯',
    ),
    WordEntry(
      word: '路线',
      pinyin: 'lùxiàn',
      simpleChinese: '行走的路径',
      translation: 'tuyến đường',
      symbol: '🧭',
    ),
  ];

  testWidgets(
    'Story and Discovery keep yellow vocabulary interactive without dotted decoration',
    (tester) async {
      final state = AppState();
      addTearDown(state.dispose);

      for (final contentId in <String>['story', 'discovery']) {
        final itemId = '$contentId-no-yellow-dots';
        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: state,
            child: MaterialApp(
              home: Scaffold(
                body: InteractiveStoryText(
                  text: '紫禁城路线之后继续前行。',
                  entries: words,
                  narrationContentId: contentId,
                  narrationItemId: itemId,
                  highlightStart: 5,
                  highlightEnd: 6,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.22,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        final surface = tester.widget<AnimatedContainer>(
          find.byKey(ValueKey('narration-follow-surface-$itemId')),
        );
        expect(surface.decoration, isNull, reason: '$contentId outer frame');

        final richText = tester.widget<Text>(
          find.byKey(ValueKey('interactive-highlight-$itemId')),
        );
        final vocabularySpans = _textSpans(richText.textSpan!)
            .where((span) => span.recognizer != null)
            .toList(growable: false);

        expect(
          vocabularySpans.length,
          greaterThanOrEqualTo(5),
          reason: '$contentId must keep both vocabulary words interactive',
        );
        for (final span in vocabularySpans) {
          expect(
            span.style?.color,
            const Color(0xFFFFD879),
            reason: '$contentId vocabulary stays yellow',
          );
          expect(
            span.style?.decoration,
            TextDecoration.none,
            reason: '$contentId yellow vocabulary must have no dots/underline',
          );
        }

        final marker = find.byKey(ValueKey('reading-highlight-$itemId'));
        expect(marker, findsOneWidget, reason: '$contentId active highlight');
        final activeText = tester.widget<Text>(
          find.descendant(of: marker, matching: find.byType(Text)),
        );
        expect(activeText.style?.color, const Color(0xFFFFE7AA));
        expect(activeText.style?.decoration, TextDecoration.none);
      }
    },
  );
}
