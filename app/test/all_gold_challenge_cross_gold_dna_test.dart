import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';

void main() {
  test('no two Gold Journeys share a four-level grammar-target run', () {
    final seen = <String, String>{};
    final collisions = <String>[];
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (var start = 0; start <= profile.grammar.length - 4; start++) {
        final signature = profile.grammar
            .skip(start)
            .take(4)
            .map((item) => item.targetId)
            .join('>');
        final current = '${profile.journeyId} Lv${start + 1}-Lv${start + 4}';
        final previous = seen[signature];
        if (previous != null) {
          collisions.add('$current duplicates $previous: $signature');
        } else {
          seen[signature] = current;
        }
      }
    }
    expect(
      collisions,
      isEmpty,
      reason: 'Cross-Gold grammar collisions:\n${collisions.join('\n')}',
    );
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
    final defects = <String>[];
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (var index = 0; index < profile.storyDistractors.length; index++) {
        final value = profile.storyDistractors[index].misconception.trim();
        if (genericFillers.contains(value) || value.length < 8) {
          defects.add(
            '${profile.journeyId} story distractor ${index + 1}: "$value" (${value.length})',
          );
        }
      }
      for (var level = 1; level <= profile.grammar.length; level++) {
        final value = profile.grammar[level - 1].misconception.trim();
        if (genericFillers.contains(value) || value.length < 8) {
          defects.add(
            '${profile.journeyId} Lv$level grammar: "$value" (${value.length})',
          );
        }
      }
    }
    expect(
      defects,
      isEmpty,
      reason: 'Weak misconception rationales:\n${defects.join('\n')}',
    );
  });

  test('recycled legacy grammar-error skeletons do not repeat across Gold profiles', () {
    final sentences = <String, String>{
      for (final profile in nonDatongGoldChallengeProfiles.values)
        for (var index = 0; index < profile.grammar.length; index++)
          '${profile.journeyId}:Lv${index + 1}':
              profile.grammar[index].brokenSentence,
    };

    final patterns = <String, RegExp>{
      'stacked causal result': RegExp(r'因此.*所以|所以.*因此'),
      'because/result stack': RegExp(r'因为.*所以.*(因此|所以)'),
      'concession rewritten as result': RegExp(r'尽管.*所以'),
      'paired conjunction stack': RegExp(r'既.*(而且|并且).*又'),
      'even-if plus but stack': RegExp(r'即使.*但是'),
      'only-if rewritten with jiu': RegExp(r'只有.*就'),
      'reason frame polluted by result marker': RegExp(r'之所以.*是所以'),
      'preference frame polluted by result marker': RegExp(r'与其.*所以.*不如'),
      'correction mistaken for binary choice': RegExp(r'不是.*就是'),
      'result/direction hybrid': RegExp(r'变成到|成为到'),
    };

    final defects = <String>[];
    for (final entry in patterns.entries) {
      final hits = <String>[
        for (final item in sentences.entries)
          if (entry.value.hasMatch(item.value)) '${item.key}: ${item.value}',
      ];
      if (hits.length > 1) {
        defects.add('${entry.key}:\n${hits.join('\n')}');
      }
    }

    expect(
      defects,
      isEmpty,
      reason:
          'De-skinned grammar template collisions:\n${defects.join('\n\n')}',
    );
  });
}
