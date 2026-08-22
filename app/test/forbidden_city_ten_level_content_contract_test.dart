import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';

void main() {
  test('Forbidden City has ten genuinely distinct six-stage content levels',
      () {
    expect(forbiddenCityLockedStories.length, 10);
    expect(forbiddenCityMemoryMoments.length, 10);
    expect(forbiddenCityCompletionMoments.length, 10);
    expect(forbiddenCityParagraphRebuild.length, 10);
    expect(forbiddenCityGrammarRepair.length, 10);
    expect(forbiddenCityMissingSentence.length, 10);

    final story = <String>{};
    final vocabulary = <String>{};
    final discovery = <String>{};
    final challenge = <String>{};
    final memory = <String>{};
    final completion = <String>{};

    for (var level = 1; level <= 10; level += 1) {
      final content = forbiddenCityLevelContent(level);
      final memoryMoment = forbiddenCityMemoryForLevel(level);
      final completionMoment = forbiddenCityCompletionForLevel(level);
      final rebuild = forbiddenCityParagraphRebuild[level - 1];
      final grammar = forbiddenCityGrammarRepair[level - 1];
      final transfer = forbiddenCityMissingSentence[level - 1];

      expect(content.storyParagraphs, isNotEmpty, reason: 'Lv$level Story');
      expect(content.words, isNotEmpty, reason: 'Lv$level Vocabulary');
      expect(content.discoveries, isNotEmpty, reason: 'Lv$level Discovery');

      final joinedStory = content.storyParagraphs.join('\n');
      for (final word in content.words) {
        expect(
          joinedStory.contains(word.word),
          isTrue,
          reason:
              'Lv$level Vocabulary must trace to same-level Story: ${word.word}',
        );
        final source = word.studyExamples.first.chinese.replaceFirst(
          'Story 原句：',
          '',
        );
        expect(
          source.contains(word.word) && joinedStory.contains(source),
          isTrue,
          reason:
              'Lv$level teaching source must be an exact same-level Story sentence: ${word.word}',
        );
      }

      story.add(joinedStory);
      final vocabularyWords = content.words.map((word) => word.word).toList()
        ..sort();
      vocabulary.add(vocabularyWords.join('|'));
      discovery.add(content.discoveries.map((item) => item.text).join('|'));
      challenge.add(
        <String>[
          rebuild.segments.join('|'),
          grammar.correct,
          grammar.evidenceQuestion,
          transfer.transferQuestion,
          transfer.transferAnswer,
        ].join('||'),
      );
      memory.add(
        <String>[
          memoryMoment.recall,
          memoryMoment.characterShift,
          memoryMoment.anchor,
          memoryMoment.takeaway,
        ].join('||'),
      );
      completion.add(
        <String>[
          completionMoment.storyClosure,
          completionMoment.discovery,
          completionMoment.learning,
          completionMoment.memory,
          completionMoment.relationship,
          completionMoment.emotionalClosure,
          completionMoment.unlockResult,
        ].join('||'),
      );
    }

    expect(story.length, 10, reason: 'Story must differ at every level');
    expect(
      vocabulary.length,
      10,
      reason: 'Vocabulary must differ at every level',
    );
    expect(
      discovery.length,
      10,
      reason: 'Discovery must differ at every level',
    );
    expect(
      challenge.length,
      10,
      reason: 'Challenge must differ at every level',
    );
    expect(memory.length, 10, reason: 'Memory must differ at every level');
    expect(
      completion.length,
      10,
      reason: 'Completion must differ at every level',
    );
  });

  test('Forbidden City vocabulary provenance is derived from Story', () {
    expect(validateForbiddenCityWordTrace(), isEmpty);
    expect(
      forbiddenCityWordRecords
          .firstWhere((record) => record.entry.word == '判断')
          .firstAppearsAt,
      3,
    );
    expect(
      forbiddenCityWordRecords
          .firstWhere((record) => record.entry.word == '证据')
          .firstAppearsAt,
      5,
    );
  });

  test(
    'Forbidden City keeps the locked Phoenix story mechanism at all levels',
    () {
      for (var level = 1; level <= 10; level += 1) {
        final story = forbiddenCityLockedStories[level - 1];
        expect(story.contains('沈砚'), isTrue, reason: 'Lv$level protagonist');
        expect(
          story.contains('阿宁'),
          isTrue,
          reason: 'Lv$level second protagonist',
        );
        expect(
          story.contains('中轴') || story.contains('午门'),
          isTrue,
          reason: 'Lv$level Forbidden City spatial mechanism',
        );
        expect(
          story.contains('路线') || story.contains('线'),
          isTrue,
          reason: 'Lv$level route conflict',
        );
      }
    },
  );
}
