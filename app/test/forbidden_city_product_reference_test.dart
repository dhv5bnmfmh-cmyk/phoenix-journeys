import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';
import 'package:phoenix_journeys/services/forbidden_city_challenge_level_standard.dart';

void main() {
  const engine = JourneyChallengeEngine();
  const auditor = ChallengeAntiTemplateAuditor();

  ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
        track: ChineseExamTrack.hsk,
        levelCode: '$level',
        levelLabel: '$level',
        band: level <= 2
            ? PhoenixReadingBand.beginner
            : level <= 4
                ? PhoenixReadingBand.elementary
                : level <= 6
                    ? PhoenixReadingBand.intermediate
                    : level <= 8
                        ? PhoenixReadingBand.upperIntermediate
                        : PhoenixReadingBand.advanced,
        phoenixLevel: level,
      );

  StoryChallengeSet challenge(int level) {
    final prepared = JourneyPreparationCoordinator.instance.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile(level),
      scriptMode: 'simplified',
    );
    return engine.build(
      journeyId: 'beijing-forbidden-city',
      sessionLevel: level,
      storyParagraphs: prepared.challengeSourceMaterial,
    );
  }

  test('Challenge keeps the authoritative 2 x 6 = 12', () {
    for (var level = 1; level <= 10; level++) {
      final set = challenge(level);
      expect(set.questions, hasLength(12), reason: 'Lv$level');
      for (final mode in StoryChallengeMode.values) {
        expect(set.questions.where((q) => q.mode == mode), hasLength(2),
            reason: 'Lv$level ${mode.name}');
      }
    }
  });

  test('Semantic Rebuild uses meaningful chunks', () {
    for (final level in <int>[1, 5, 10]) {
      final questions = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.sentenceRebuild);
      for (final q in questions) {
        expect(q.characterTiles, hasLength(greaterThanOrEqualTo(2)));
        expect(q.characterTiles.join().length, q.answer.length);
        expect(
          q.characterTiles.any((tile) =>
              RegExp(r'[\\u3400-\\u9fff]').allMatches(tile).length == 1 &&
              !const <String>{'却', '再'}.contains(tile)),
          isFalse,
          reason: q.id,
        );
      }
    }
  });

  test('Grammar Repair 20/20 has meaningful Step 1 and complete Step 2', () {
    var total = 0;
    for (var level = 1; level <= 10; level++) {
      final questions = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.grammarRepair);
      expect(questions, hasLength(2));
      for (final q in questions) {
        total += 1;
        expect(q.errorSegments, hasLength(4));
        expect(q.errorSegmentIndex, inInclusiveRange(0, 3));
        expect(q.errorSegments.join(), q.prompt, reason: q.id);
        expect(
          q.errorSegments.every(isMeaningfulGrammarSegment),
          isTrue,
          reason: '${q.id}: meaningful grammatical units',
        );
        expect(
          hasTrivialGrammarFragmentationLeak(
            q.errorSegments,
            q.errorSegmentIndex!,
          ),
          isFalse,
          reason: '${q.id}: fragmentation-style answer leak',
        );
        expect(q.options, hasLength(4));
        expect(q.options.toSet(), hasLength(4));
        expect(q.options.where((value) => value == q.answer), hasLength(1));
        expect(q.grammarWhyWrong, isNotEmpty);
        expect(q.grammarRevisionRule, isNotEmpty);
        expect(q.grammarOptionExplanations, hasLength(4));
      }
    }
    expect(total, 20);
  });

  test('Grammar gate rejects punctuation and giveaway tail fragments', () {
    for (final fragment in <String>[
      '。',
      '，',
      '的。',
      '了。',
      '在。',
      '写。',
      '往。',
      '但是。',
      '完整。',
      '了起来。',
    ]) {
      expect(
        isMeaningfulGrammarSegment(fragment),
        isFalse,
        reason: fragment,
      );
    }
    expect(
      hasTrivialGrammarFragmentationLeak(
        const <String>['阿宁带沈砚', '回看刚才', '经过位置', '的。'],
        3,
      ),
      isTrue,
    );
  });

  test('Choice questions have one answer and authored rationales', () {
    for (var level = 1; level <= 10; level++) {
      for (final q in challenge(level).questions.where((q) =>
          q.mode != StoryChallengeMode.sentenceRebuild &&
          q.mode != StoryChallengeMode.grammarRepair)) {
        expect(q.options, hasLength(4), reason: q.id);
        expect(q.options.toSet(), hasLength(4), reason: q.id);
        expect(q.options.where((value) => value == q.answer), hasLength(1),
            reason: q.id);
        expect(q.distractorRationales, hasLength(4), reason: q.id);
        expect(q.whyCorrect, isNotEmpty, reason: q.id);
      }
    }
  });

  test('Anti-template and level locks remain enforced', () {
    final sets = <StoryChallengeSet>[
      for (var level = 1; level <= 10; level++) challenge(level),
    ];
    final report = auditor.auditMatrix(sets);
    expect(report.passed, isTrue, reason: report.failures.join('\\n'));
    for (var level = 1; level <= 10; level++) {
      expect(sets[level - 1].sessionLevel, level);
      expect(
        sets[level - 1]
            .questions
            .every((q) => q.signature.sessionLevel == level),
        isTrue,
      );
    }
  });
}
