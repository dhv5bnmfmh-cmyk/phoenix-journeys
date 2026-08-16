import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';

void main() {
  test('no two Gold Journeys share a four-level grammar-target run', () {
    final seen = <String, String>{};
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (var start = 0; start <= profile.grammar.length - 4; start++) {
        final signature = profile.grammar
            .skip(start)
            .take(4)
            .map((item) => item.targetId)
            .join('>');
        final previous = seen[signature];
        expect(
          previous,
          isNull,
          reason:
              '${profile.journeyId} Lv${start + 1}-Lv${start + 4} duplicates $previous: $signature',
        );
        seen[signature] = '${profile.journeyId} Lv${start + 1}-Lv${start + 4}';
      }
    }
  });

  test('level-aware Story windows materially move from Lv1 to Lv10', () {
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      expect(
        profile.paragraphAnchors.last - profile.paragraphAnchors.first,
        greaterThanOrEqualTo(0.75),
        reason: '${profile.journeyId} paragraph progression is too shallow',
      );
      expect(
        profile.missingAnchors.last - profile.missingAnchors.first,
        greaterThanOrEqualTo(0.75),
        reason: '${profile.journeyId} missing progression is too shallow',
      );
      expect(
        profile.paragraphGoals.first,
        isNot(profile.paragraphGoals.last),
        reason: '${profile.journeyId} paragraph goal does not deepen',
      );
      expect(
        profile.missingGoals.first,
        isNot(profile.missingGoals.last),
        reason: '${profile.journeyId} missing goal does not deepen',
      );
    }
  });

  test('grammar answers contain no known accidental concatenation artifacts', () {
    const forbiddenFragments = <String>[
      '影响影响',
      '才许澄才能',
      '完整整一整圈',
      '先把门口的竹椅先',
      '快地从门槛',
    ];
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (var level = 1; level <= 10; level++) {
        final sentence = profile.grammar[level - 1].correctedSentence;
        for (final fragment in forbiddenFragments) {
          expect(
            sentence.contains(fragment),
            isFalse,
            reason: '${profile.journeyId} Lv$level contains $fragment: $sentence',
          );
        }
      }
    }
  });

  test('misconception rationale is Journey-owned rather than generic filler', () {
    const genericFillers = <String>{
      '随机错误',
      '错误答案',
      '其他',
      '不正确',
    };
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (final item in profile.storyDistractors) {
        expect(genericFillers.contains(item.misconception.trim()), isFalse);
        expect(item.misconception.trim().length, greaterThanOrEqualTo(8));
      }
      for (final grammar in profile.grammar) {
        expect(genericFillers.contains(grammar.misconception.trim()), isFalse);
        expect(grammar.misconception.trim().length, greaterThanOrEqualTo(8));
      }
    }
  });
}
