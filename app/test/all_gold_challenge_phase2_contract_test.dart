import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';

void main() {
  test(
    'all non-Datong approved Gold Journeys own a complete Challenge profile',
    () {
      final approved = approvedNarrativeDnaCatalog
          .map((record) => record.journeyId)
          .toSet();
      final expected = approved.difference(const {'datong-yungang-grottoes'});

      expect(nonDatongGoldChallengeProfiles.keys.toSet(), expected);
      expect(nonDatongGoldChallengeProfiles.length, 11);

      for (final profile in nonDatongGoldChallengeProfiles.values) {
        expect(profile.paragraphAnchors.length, 10, reason: profile.journeyId);
        expect(profile.missingAnchors.length, 10, reason: profile.journeyId);
        expect(profile.paragraphGoals.length, 10, reason: profile.journeyId);
        expect(profile.missingGoals.length, 10, reason: profile.journeyId);
        expect(profile.paragraphIntents.length, 10, reason: profile.journeyId);
        expect(profile.missingIntents.length, 10, reason: profile.journeyId);
        expect(profile.grammar.length, 10, reason: profile.journeyId);
        expect(
          profile.storyDistractors.length,
          greaterThanOrEqualTo(6),
          reason: profile.journeyId,
        );

        for (var index = 1; index < 10; index++) {
          expect(
            profile.paragraphAnchors[index],
            greaterThan(profile.paragraphAnchors[index - 1]),
            reason: '${profile.journeyId} paragraph Lv${index + 1}',
          );
          expect(
            profile.missingAnchors[index],
            greaterThan(profile.missingAnchors[index - 1]),
            reason: '${profile.journeyId} missing Lv${index + 1}',
          );
        }

        final distractorTexts = profile.storyDistractors
            .map((item) => item.text)
            .toList();
        expect(
          distractorTexts.toSet().length,
          distractorTexts.length,
          reason: '${profile.journeyId} duplicate Story distractor',
        );
        for (final item in profile.storyDistractors) {
          expect(item.text.trim(), isNotEmpty);
          expect(item.misconception.trim(), isNotEmpty);
        }

        for (var level = 1; level <= 10; level++) {
          final grammar = profile.grammar[level - 1];
          expect(grammar.targetId.trim(), isNotEmpty);
          expect(
            grammar.brokenSentence,
            isNot(grammar.correctedSentence),
            reason: '${profile.journeyId} Lv$level no-op grammar',
          );
          expect(
            grammar.brokenSegment,
            isNot(grammar.correctReplacement),
            reason: '${profile.journeyId} Lv$level no-op replacement',
          );
          expect(
            grammar.distractors.length,
            3,
            reason: '${profile.journeyId} Lv$level',
          );
          final options = <String>[
            grammar.correctReplacement,
            ...grammar.distractors,
          ];
          expect(
            options.toSet().length,
            4,
            reason: '${profile.journeyId} Lv$level duplicate grammar option',
          );
          expect(grammar.whyWrong.trim(), isNotEmpty);
          expect(grammar.revisionRule.trim(), isNotEmpty);
          expect(grammar.memoryTip.trim(), isNotEmpty);
          expect(grammar.misconception.trim(), isNotEmpty);
        }
      }
    },
  );

  test('no two Gold Journeys share the complete grammar progression signature', () {
    final seen = <String, String>{};
    for (final profile in nonDatongGoldChallengeProfiles.values) {
      final signature = profile.grammar.map((item) => item.targetId).join('>');
      final previous = seen[signature];
      expect(
        previous,
        isNull,
        reason:
            '${profile.journeyId} duplicates the full grammar progression of $previous',
      );
      seen[signature] = profile.journeyId;
    }
  });

  test(
    'Journey-specific prompts and misconception sets do not collide exactly',
    () {
      final paragraphPrompts = <String>{};
      final missingPrompts = <String>{};
      final allDistractors = <String>{};

      for (final profile in nonDatongGoldChallengeProfiles.values) {
        expect(
          paragraphPrompts.add(profile.paragraphPrompt),
          isTrue,
          reason: '${profile.journeyId} paragraph prompt collision',
        );
        expect(
          missingPrompts.add(profile.missingPrompt),
          isTrue,
          reason: '${profile.journeyId} missing prompt collision',
        );
        for (final item in profile.storyDistractors) {
          expect(
            allDistractors.add(item.text),
            isTrue,
            reason: '${profile.journeyId} cross-Gold distractor collision',
          );
        }
      }
    },
  );
}
