import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';

void main() {
  test('Forbidden City uses the shared Phoenix Story presentation path', () {
    final source = File('lib/screens/journey_screen.dart').readAsStringSync();

    expect(source, isNot(contains('Widget _forbiddenCityStoryPage')));
    expect(source, isNot(contains('_storySegmentIndex')));
    expect(
      source,
      contains('Widget _storyPage() => _defaultStoryPage();'),
    );
    expect(
      source,
      contains('List<NarrationItem> get _storyPlaybackItems => _storyNarrationItems;'),
    );
    expect(source, isNot(contains('forbidden-city-story-segment-progress')));
    expect(source, isNot(contains('forbidden-city-story-segment-scroll')));
  });

  test('global Story cinematic reveal bypass stays removed', () {
    final source = File('lib/widgets/interactive_story_text.dart').readAsStringSync();
    final targetStart = source.indexOf('double _targetRevealCursor(int? revealEnd)');
    expect(targetStart, greaterThanOrEqualTo(0));
    final targetEnd = source.indexOf('double get _currentRevealCursor', targetStart);
    final targetBody = source.substring(targetStart, targetEnd);

    expect(targetBody, isNot(contains("narrationContentId == 'story'")));
    expect(targetBody, contains('revealEnd ?? widget.text.length'));
  });

  test('shared reveal cursor keeps one coherent two-paragraph narration model', () {
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 100,
        snapshotItemIndex: 0,
        snapshotEnd: 37,
        controllerItemIndex: 0,
        controllerItemStartOffset: 0,
        currentOffset: 37,
      ),
      37,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 1,
        itemLength: 120,
        snapshotItemIndex: 0,
        snapshotEnd: 37,
        controllerItemIndex: 0,
        controllerItemStartOffset: 0,
        currentOffset: 37,
      ),
      0,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 100,
        snapshotItemIndex: 1,
        snapshotEnd: 15,
        controllerItemIndex: 1,
        controllerItemStartOffset: 100,
        currentOffset: 115,
      ),
      100,
    );
  });

  test('Forbidden City approved paragraph shapes stay unchanged', () {
    expect(forbiddenCityStoryParagraphsByLevel[0], hasLength(1));
    expect(forbiddenCityStoryParagraphsByLevel[4], hasLength(2));
    expect(forbiddenCityStoryParagraphsByLevel[9], hasLength(2));
  });

  test('no Forbidden City-only Story animation layer survives', () {
    final source = File('lib/screens/journey_screen.dart').readAsStringSync();
    expect(source, isNot(contains("key: ValueKey('forbidden-city-story-segment-")));
    expect(source, isNot(contains("buttonText: isFinalSegment ? '进入单词' : '下一段'")));
    expect(source, contains("revealEnd: _narrationRevealEnd("));
    expect(source, contains("key: const ValueKey('story-auto-visibility-scroll')"));
  });
}
