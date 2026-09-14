import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';

void main() {
  test('all 100 choice questions expose option-specific wrong feedback', () {
    var totalQuestions = 0;
    var choiceQuestions = 0;
    var wrongFeedback = 0;
    final prompts = <String>{};
    final normalizedPrompts = <String>{};
    final sameFamilyPairs = <String>{};

    for (var level = 1; level <= 10; level += 1) {
      final set = const JourneyChallengeEngine().build(
        journeyId: forbiddenCityJourneyId,
        sessionLevel: level,
        storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
      );
      expect(set.questions, hasLength(12), reason: 'Lv$level');
      totalQuestions += set.questions.length;

      for (final mode in StoryChallengeMode.values) {
        final family = set.questions.where((q) => q.mode == mode).toList();
        expect(family, hasLength(2), reason: 'Lv$level ${mode.name}');
        sameFamilyPairs.add(
          '${family[0].signature.semanticSignature}|'
          '${family[1].signature.semanticSignature}',
        );
      }

      for (final question in set.questions) {
        expect(question.prompt.trim(), isNotEmpty, reason: question.id);
        expect(prompts.add(question.prompt), isTrue, reason: question.id);
        final normalized = question.prompt
            .replaceAll(RegExp(r'\s+'), '')
            .replaceAll(RegExp(r'[，。？！：“”]'), '');
        expect(normalizedPrompts.add(normalized), isTrue, reason: question.id);
        if (question.options.isEmpty) continue;

        choiceQuestions += 1;
        expect(question.distractorRationales, hasLength(4));
        final wrong = <String>[];
        for (var index = 0; index < question.options.length; index += 1) {
          if (question.options[index] == question.answer) continue;
          final rationale = question.distractorRationales[index];
          wrong.add(rationale);
          wrongFeedback += 1;
          expect(rationale.trim(), isNotEmpty, reason: question.id);
          expect(rationale, contains('“${question.options[index]}”'));
          expect(
            rationale,
            isNot(contains('不满足“${question.reasoningTarget}”或与')),
          );

          final presentation = question.mode == StoryChallengeMode.grammarRepair
              ? grammarRepairFeedbackPresentation(question, index)
              : singleStepFeedbackPresentation(
                  question,
                  selectedAnswer: question.options[index],
                );
          expect(presentation.narrationText((text) => text), contains(rationale));
        }
        expect(wrong.toSet(), hasLength(3), reason: question.id);
      }
    }

    expect(totalQuestions, 120);
    expect(choiceQuestions, 100);
    expect(wrongFeedback, 300);
    expect(sameFamilyPairs, hasLength(60));
  });

  test('Lv2 is a consequential next chapter rather than an Lv1 expansion', () {
    final lv1 = forbiddenCityLockedStories[0];
    final lv2 = forbiddenCityLockedStories[1];
    expect(lv1, isNot(lv2));
    expect(lv2, contains('第二天'));
    expect(lv2, contains('午前要送回东侧'));
    expect(lv2, contains('交接签记'));
    expect(lv2, contains('及时完成交接'));
    expect(lv2, contains('共同为后来的人负责'));
  });
}
