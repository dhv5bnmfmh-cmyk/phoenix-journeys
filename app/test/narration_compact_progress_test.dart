import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/narration_player_card.dart';

void main() {
  test('compact narration progress explains the idle reading load', () {
    expect(
      compactNarrationProgressLabel(
        currentItemIndex: null,
        itemCount: 0,
        currentOffset: 0,
        totalCharacters: 500,
        finished: false,
      ),
      '总计 500 字',
    );
  });

  test('compact narration progress exposes paragraph percent and remainder', () {
    expect(
      compactNarrationProgressLabel(
        currentItemIndex: 1,
        itemCount: 2,
        currentOffset: 325,
        totalCharacters: 650,
        finished: false,
      ),
      '第 2 / 2 段 · 50% · 剩余 325 字',
    );
  });

  test('compact narration progress reports completion cleanly', () {
    expect(
      compactNarrationProgressLabel(
        currentItemIndex: 1,
        itemCount: 2,
        currentOffset: 900,
        totalCharacters: 900,
        finished: true,
      ),
      '朗读完成 · 100%',
    );
  });

  test('compact progress updates text without changing widget identity', () {
    final source = File('lib/widgets/narration_player_card.dart').readAsStringSync();
    expect(
      source,
      contains("key: const ValueKey('narration-compact-label')"),
    );
    expect(source, isNot(contains('narration-compact-label-\$compactProgress')));

    final labels = <String>[
      for (final offset in <int>[100, 101, 102])
        compactNarrationProgressLabel(
          currentItemIndex: 1,
          itemCount: 2,
          currentOffset: offset,
          totalCharacters: 300,
          finished: false,
        ),
    ];
    expect(labels.toSet(), hasLength(3));
    expect(labels.first, contains('33%'));
    expect(labels.last, contains('剩余 198 字'));
  });
}
