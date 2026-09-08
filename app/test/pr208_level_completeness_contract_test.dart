import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';

String _challengeIdentity(StoryChallengeSet set, StoryChallengeMode mode) => set
    .questions
    .where((question) => question.mode == mode)
    .map(
      (question) =>
          '${question.prompt}|${question.answer}|${question.sourceSentence}',
    )
    .toList(growable: false)
    .join('\n');

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

int _maxStreak(List<int> values) {
  var best = 0;
  var current = 0;
  int? previous;
  for (final value in values) {
    current = value == previous ? current + 1 : 1;
    previous = value;
    if (current > best) best = current;
  }
  return best;
}

void _expectChallengeContracts(StoryChallengeSet set, String storyId) {
  expect(set.questions, hasLength(12));
  for (final mode in StoryChallengeMode.values) {
    expect(set.questions.where((question) => question.mode == mode), hasLength(4));
  }

  final rebuild = set.questions
      .where((question) => question.mode == StoryChallengeMode.sentenceRebuild)
      .toList(growable: false);
  for (final question in rebuild) {
    expect(_hanCount(question.answer), inInclusiveRange(1, 10));
    expect(question.characterTiles.join().length, question.answer.length);
    expect(question.characterTiles, isNotEmpty);
    expect(
      RegExp(
        r'北京|紫禁城|故宫|午门|乾清门|景运门|中轴|宫门|外朝|内廷|交接|核对|记录|待核|证据|方位|空间|路线',
      ).hasMatch('${question.prompt}${question.answer}'),
      isTrue,
    );
    for (final protected in const ['紫禁城', '故宫博物院', '乾清门', '景运门', '午门']) {
      if (!question.answer.contains(protected)) continue;
      expect(
        question.characterTiles.any((tile) => tile.contains(protected)),
        isTrue,
        reason: '$storyId ${question.id} must keep $protected coherent',
      );
    }
  }

  final grammar = set.questions
      .where((question) => question.mode == StoryChallengeMode.grammarRepair)
      .toList(growable: false);
  expect(
    grammar.map((question) => question.grammarFamily).toSet(),
    hasLength(4),
  );
  for (final question in grammar) {
    expect(question.prompt, endsWith('。'));
    expect(question.errorSegments, hasLength(4));
    expect(question.errorSegments.join(), question.prompt);
    expect(question.options, hasLength(4));
    expect(question.options.toSet(), hasLength(4));
    expect(question.options.where((option) => option == question.answer), hasLength(1));
    expect(question.grammarWhyWrong?.trim(), isNotEmpty);
    expect(question.grammarRevisionRule?.trim(), isNotEmpty);
    expect(question.grammarOptionExplanations, hasLength(4));
    expect(
      question.grammarOptionExplanations.every((item) => item.trim().isNotEmpty),
      isTrue,
    );
  }

  final completion = set.questions
      .where((question) => question.mode == StoryChallengeMode.storyCompletion)
      .toList(growable: false);
  for (final question in completion) {
    expect(question.completionBlanks, hasLength(set.sessionLevel));
    for (final blank in question.completionBlanks) {
      expect(blank.options, hasLength(4));
      expect(blank.options.toSet(), hasLength(4));
      expect(blank.options.where((option) => option == blank.answer), hasLength(1));
    }
  }

  final positions = <int>[];
  for (final question in set.questions) {
    if (question.options.length == 4) {
      positions.add(question.options.indexOf(question.answer));
    }
    for (final blank in question.completionBlanks) {
      if (blank.options.length == 4) {
        positions.add(blank.options.indexOf(blank.answer));
      }
    }
  }
  expect(positions.every((position) => position >= 0 && position < 4), isTrue);
  expect(_maxStreak(positions), lessThanOrEqualTo(2));
  final counts = List<int>.filled(4, 0);
  for (final position in positions) {
    counts[position] += 1;
  }
  expect(counts.reduce((a, b) => a > b ? a : b) - counts.reduce((a, b) => a < b ? a : b), lessThanOrEqualTo(1));
}

void main() {
  test('Second Story keeps Founder prose while Vocabulary and Discovery scale Lv1-Lv10', () {
    final vocabularyIdentities = <String>{};
    final discoveryIdentities = <String>{};
    List<String>? founderStory;

    for (var level = 1; level <= 10; level += 1) {
      final content = forbiddenCitySecondStoryLevelContent(phoenixLevel: level);
      founderStory ??= content.storyParagraphs;
      expect(content.storyParagraphs, founderStory);
      expect(content.words, isNotEmpty);
      expect(content.discoveries, isNotEmpty);
      for (final word in content.words) {
        expect(
          content.storyParagraphs.any((paragraph) => paragraph.contains(word.word)),
          isTrue,
          reason: 'Lv$level ${word.word} must occur in Founder Story',
        );
        expect(word.pinyin, isNotEmpty);
        expect(word.simpleChinese, isNotEmpty);
        expect(word.englishDefinition, isNotEmpty);
      }
      vocabularyIdentities.add(content.words.map((word) => word.word).join('|'));
      discoveryIdentities.add(
        content.discoveries.map((item) => item.text).join('|'),
      );
    }

    expect(vocabularyIdentities, hasLength(10));
    expect(discoveryIdentities, hasLength(10));

    final defaultContent = forbiddenCitySecondStoryLevelContent();
    final defaultWords = {for (final word in defaultContent.words) word.word: word.pinyin};
    expect(defaultWords['中轴'], 'zhōngzhóu');
    expect(defaultWords['景运门'], 'jǐngyùnmén');
    expect(defaultWords['核对'], 'héduì');
    expect(defaultWords['交接'], 'jiāojiē');
  });

  test('Both Forbidden City Stories have complete level-specific Challenge contracts', () {
    final primaryRebuild = <String>[];
    final primaryGrammar = <String>[];
    final secondRebuild = <String>[];
    final secondGrammar = <String>[];

    for (var level = 1; level <= 10; level += 1) {
      final primary = const JourneyChallengeEngine().build(
        journeyId: forbiddenCityJourneyId,
        sessionLevel: level,
        storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
      );
      _expectChallengeContracts(primary, forbiddenCityPrimaryStoryId);
      final primaryText = primary.questions
          .map((question) => '${question.prompt}${question.answer}')
          .join('\n');
      expect(RegExp(r'林乔|许澄|交接前的标记').hasMatch(primaryText), isFalse);
      primaryRebuild.add(
        _challengeIdentity(primary, StoryChallengeMode.sentenceRebuild),
      );
      primaryGrammar.add(
        _challengeIdentity(primary, StoryChallengeMode.grammarRepair),
      );

      final second = const JourneyChallengeEngine().build(
        journeyId: forbiddenCitySecondStoryId,
        sessionLevel: level,
        storyParagraphs: forbiddenCitySecondStoryChallengeSourceMaterial,
      );
      _expectChallengeContracts(second, forbiddenCitySecondStoryId);
      final secondText = second.questions
          .map((question) => '${question.prompt}${question.answer}')
          .join('\n');
      expect(RegExp(r'沈砚|阿宁|两条路，一张图').hasMatch(secondText), isFalse);
      secondRebuild.add(
        _challengeIdentity(second, StoryChallengeMode.sentenceRebuild),
      );
      secondGrammar.add(
        _challengeIdentity(second, StoryChallengeMode.grammarRepair),
      );
    }

    expect(primaryRebuild.toSet(), hasLength(10));
    expect(primaryGrammar.toSet(), hasLength(10));
    expect(secondRebuild.toSet(), hasLength(10));
    expect(secondGrammar.toSet(), hasLength(10));
  });
}
