import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';

void main() {
  test('Summer Palace resolves Journey-specific Memory and Completion', () {
    final spec = batchOneMemorySpecFor('beijing-summer-palace');

    expect(spec, isNotNull);
    expect(
      spec!.reviews.map((review) => review.category),
      containsAll(<String>['choice', 'relationship', 'place', 'memory']),
    );
    expect(spec.storyResult, contains('十七孔桥'));
    expect(spec.storyResult, contains('放下相机'));
    expect(spec.storyResult, contains('旧照片'));
    expect(spec.storyResult, contains('《留下痕迹的风景》'));

    final memoryText = <String>[
      spec.storyResult,
      spec.culturalPoint,
      ...spec.reviews.expand((review) => <String>[review.prompt, review.answer]),
      spec.longTermAnchor,
      spec.completionSummary,
    ].join('\n');

    expect(memoryText, contains('1860'));
    expect(memoryText, contains('1886年开始重建'));
    expect(memoryText, contains('周岚'));
    expect(memoryText, contains('许澄'));
    expect(memoryText, contains('下一次'));

    // The Summer Palace closure must not reuse the Forbidden City route engine.
    expect(memoryText, isNot(contains('两条路线')));
    expect(memoryText, isNot(contains('乾清门')));
    expect(memoryText, isNot(contains('中轴')));
  });

  test('Summer Palace Memory preserves the enacted choice and its cost', () {
    final spec = batchOneMemorySpecFor('beijing-summer-palace')!;
    final choice = spec.reviews.singleWhere(
      (review) => review.category == 'choice',
    );
    final relationship = spec.reviews.singleWhere(
      (review) => review.category == 'relationship',
    );
    final place = spec.reviews.singleWhere(
      (review) => review.category == 'place',
    );

    expect(choice.answer, contains('放下相机'));
    expect(choice.answer, contains('错过'));
    expect(choice.storyEventIds, contains('enactedChoice'));
    expect(choice.storyEventIds, contains('lostLight'));

    expect(relationship.answer, contains('不再替许澄调构图'));
    expect(relationship.answer, contains('旧照片'));
    expect(relationship.storyEventIds, contains('trustChange'));
    expect(relationship.storyEventIds, contains('photographEntrusted'));

    expect(place.answer, contains('十七孔桥'));
    expect(place.answer, contains('冬至前后'));
    expect(place.answer, contains('1886年开始重建'));
  });
}
