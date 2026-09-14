import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
import 'package:provider/provider.dart';

Iterable<TextSpan> _textSpans(InlineSpan span) sync* {
  if (span is TextSpan) {
    yield span;
    for (final child in span.children ?? const <InlineSpan>[]) {
      yield* _textSpans(child);
    }
  }
}

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

      expect(
        find.byKey(const ValueKey('reading-highlight-visual-test')),
        findsOneWidget,
      );
    },
  );

  testWidgets('Story follows narration reveal instead of dumping full text at offset zero', (
    tester,
  ) async {
    const story = '紫禁城里的空间并不平等地向所有人展开。';
    final state = AppState();

    Widget buildStory(int revealEnd) => ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            home: Scaffold(
              body: InteractiveStoryText(
                text: story,
                entries: const <WordEntry>[],
                narrationContentId: 'story',
                narrationItemId: 'story-0',
                revealEnd: revealEnd,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );

    await tester.pumpWidget(buildStory(0));
    var richText = tester.widget<RichText>(find.byType(RichText).first);
    expect(richText.text.toPlainText(), isNot(contains('紫禁城里的空间')));

    await tester.pumpWidget(buildStory(story.length));
    await tester.pumpAndSettle();
    richText = tester.widget<RichText>(find.byType(RichText).first);
    expect(richText.text.toPlainText(), contains('紫禁城里的空间'));
    expect(
      _textSpans(richText.text).where(
        (span) => span.text?.isNotEmpty == true && span.style?.color == Colors.transparent,
      ),
      isEmpty,
    );
  });
}