import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';

void main() {
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

  test('each Gold grammar item has its own diagnostic misconception', () {
    final defects = <String>[];
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      for (var level = 1; level <= profile.grammar.length; level++) {
        final item = profile.grammar[level - 1];
        final value = item.misconception.trim();
        if (value.length < 8) {
          defects.add('${profile.journeyId} Lv$level: $value');
        }
      }
    }
    expect(
      defects,
      isEmpty,
      reason: 'Weak diagnostic misconception text:\n${defects.join('\n')}',
    );
  });
}
