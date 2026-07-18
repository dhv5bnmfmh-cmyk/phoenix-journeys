import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('preserves the complete story while identifying vocabulary', () {
    const paragraph = '今天，它被称为故宫，也被世界认识为紫禁城。';

    final segments = segmentStoryText(paragraph, words);
    final vocabulary = segments
        .where((segment) => segment.isVocabulary)
        .map((segment) => segment.entry!.word)
        .toList(growable: false);

    expect(segments.map((segment) => segment.text).join(), paragraph);
    expect(vocabulary, ['故宫', '紫禁城']);
  });

  test('uses the longest matching word first', () {
    const entries = [
      WordEntry(
        word: '紫禁城',
        pinyin: 'Zǐjìnchéng',
        simpleChinese: '北京故宫的历史名称。',
        translation: 'Tử Cấm Thành.',
        symbol: '🏯',
      ),
      WordEntry(
        word: '城',
        pinyin: 'chéng',
        simpleChinese: '城市或城墙。',
        translation: 'Thành.',
        symbol: '🏙️',
      ),
    ];

    final segments = segmentStoryText('走进紫禁城。', entries);
    final vocabulary = segments
        .where((segment) => segment.isVocabulary)
        .map((segment) => segment.entry!.word)
        .toList(growable: false);

    expect(vocabulary, ['紫禁城']);
  });

  test('matches narration by stable item ID', () {
    const snapshot = NarrationHighlightSnapshot(
      contentId: 'story',
      itemId: 'story-2',
      itemText: '这里曾经是皇帝生活的地方。',
      itemIndex: 2,
      start: 2,
      end: 4,
      word: '曾经',
    );

    expect(
      narrationSnapshotMatches(
        snapshot: snapshot,
        contentId: 'story',
        itemId: 'story-2',
        sourceText: '这里曾经是皇帝生活的地方。',
        displayedText: '這裡曾經是皇帝生活的地方。',
        displayText: (value) => value,
      ),
      isTrue,
    );
    expect(
      narrationSnapshotMatches(
        snapshot: snapshot,
        contentId: 'story',
        itemId: 'story-1',
        sourceText: snapshot.itemText,
        displayedText: snapshot.itemText,
        displayText: (value) => value,
      ),
      isFalse,
    );
  });
}
