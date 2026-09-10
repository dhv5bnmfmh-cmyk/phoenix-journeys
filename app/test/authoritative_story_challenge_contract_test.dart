import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';

const _journeyId = 'beijing-forbidden-city';

String _family(StoryChallengeMode mode) => switch (mode) {
      StoryChallengeMode.sentenceRebuild => 'Semantic Sentence Rebuild',
      StoryChallengeMode.grammarRepair => 'Grammar Repair',
      StoryChallengeMode.storyCompletion => 'Context Completion',
      StoryChallengeMode.storyEvidence => 'Story Evidence / Understanding',
      StoryChallengeMode.knowledgeReasoning =>
        'Beijing / Forbidden City Knowledge & Spatial Reasoning',
      StoryChallengeMode.scenarioDecision => 'Scenario / Route Decision',
    };

String _normalize(String value) => value
    .replaceAll(RegExp(r'沈砚|阿宁|周师傅'), '<PERSON>')
    .replaceAll(
      RegExp(r'紫禁城|午门|乾清门|中轴|外朝|内廷|东侧'),
      '<PLACE>',
    )
    .replaceAll(RegExp(r'[，。！？：；、“”\s]'), '')
    .toLowerCase();

String _comparisonClass(
  StoryChallengeQuestion first,
  StoryChallengeQuestion second,
) {
  final exactA = _normalize(
    '${first.mode.name}|${first.prompt}|${first.answer}|'
    '${first.options.join('|')}',
  );
  final exactB = _normalize(
    '${second.mode.name}|${second.prompt}|${second.answer}|'
    '${second.options.join('|')}',
  );
  if (exactA == exactB ||
      first.signature.semanticSignature == second.signature.semanticSignature) {
    return 'TEMPLATE DUPLICATE';
  }
  if (first.signature.templateSignature == second.signature.templateSignature) {
    return 'TRIVIAL VARIATION';
  }
  if (first.mode == second.mode &&
      _normalize(first.knowledgeTarget) == _normalize(second.knowledgeTarget)) {
    return 'INTENTIONALLY RELATED';
  }
  return 'MEANINGFULLY DIFFERENT';
}

Future<void> _pumpQuestion(
  WidgetTester tester,
  StoryChallengeQuestion question,
  int level,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 390,
          height: 760,
          child: HskStoryChallenge(
            challenge: StoryChallengeSet(
              journeyId: _journeyId,
              sessionLevel: level,
              questions: <StoryChallengeQuestion>[question],
            ),
            displayText: (value) => value,
            onCompleted: () async {},
            onNarrate: (_, __) async {},
            onFeedbackAudio: (_, __) async {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _submitCorrect(
  WidgetTester tester,
  StoryChallengeQuestion question,
) async {
  switch (question.mode) {
    case StoryChallengeMode.sentenceRebuild:
      final available = List<String>.of(question.characterTiles);
      var cursor = 0;
      while (available.isNotEmpty && cursor < question.answer.length) {
        final match = available.indexWhere(
          (tile) => question.answer.startsWith(tile, cursor),
        );
        expect(match, greaterThanOrEqualTo(0), reason: question.id);
        final tile = available.removeAt(match);
        await tester.tap(find.widgetWithText(ActionChip, tile).first);
        await tester.pump();
        cursor += tile.length;
      }
      expect(cursor, question.answer.length, reason: question.id);
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
    case StoryChallengeMode.grammarRepair:
      final error = question.errorSegmentIndex!;
      await tester.tap(find.byKey(ValueKey('grammar-location-$error')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
      expect(
        find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
        findsNothing,
        reason: '${question.id} Step 1 must not expose feedback speaker',
      );
      final answerIndex = question.options.indexOf(question.answer);
      await tester.tap(find.byKey(ValueKey('grammar-repair-$answerIndex')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
    case StoryChallengeMode.storyCompletion:
    case StoryChallengeMode.storyEvidence:
    case StoryChallengeMode.knowledgeReasoning:
    case StoryChallengeMode.scenarioDecision:
      final answerIndex = question.options.indexOf(question.answer);
      expect(answerIndex, greaterThanOrEqualTo(0), reason: question.id);
      await tester.tap(find.byKey(ValueKey('challenge-option-$answerIndex')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
  }
}

void main() {
  testWidgets(
    'Authoritative Golden Challenge renders Lv1-Lv10 120 questions without template or lifecycle defects',
    (tester) async {
      const engine = JourneyChallengeEngine();
      const auditor = ChallengeAntiTemplateAuditor();
      final levels = <StoryChallengeSet>[];
      final matrix = <Map<String, Object?>>[];
      final comparisons = <Map<String, Object?>>[];

      for (var level = 1; level <= 10; level += 1) {
        final set = engine.build(
          journeyId: _journeyId,
          sessionLevel: level,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
        );
        levels.add(set);
        expect(set.questions, hasLength(12), reason: 'Lv$level');
        for (final mode in StoryChallengeMode.values) {
          expect(
            set.questions.where((q) => q.mode == mode),
            hasLength(2),
            reason: 'Lv$level ${mode.name}',
          );
        }

        for (var questionIndex = 0;
            questionIndex < set.questions.length;
            questionIndex += 1) {
          final question = set.questions[questionIndex];
          await _pumpQuestion(tester, question, level);

          expect(find.text('完成挑战后继续'), findsNothing);
          expect(find.text('确认位置'), findsNothing);
          expect(find.text('继续修改'), findsNothing);
          expect(find.byKey(const ValueKey('challenge-back')), findsOneWidget);
          expect(
            find.byKey(const ValueKey('challenge-submit')),
            findsOneWidget,
          );
          expect(
            find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
            findsNothing,
            reason: '${question.id} pre-submit feedback speaker',
          );

          if (question.mode == StoryChallengeMode.sentenceRebuild) {
            expect(
              question.characterTiles.any((tile) {
                final han = RegExp(r'[\u3400-\u9fff]').allMatches(tile).length;
                return han == 1 && !const <String>{'却', '再'}.contains(tile);
              }),
              isFalse,
              reason: '${question.id} character atomization',
            );
          }
          if (question.mode == StoryChallengeMode.grammarRepair) {
            const punctuation = <String>{'。', '，', '！', '？', '：', '；'};
            expect(
              question.errorSegments.any(
                (segment) => punctuation.contains(segment.trim()),
              ),
              isFalse,
              reason: '${question.id} standalone punctuation',
            );
            expect(
              question.options.every(
                (option) => RegExp(r'[。？！]$').hasMatch(option.trim()),
              ),
              isTrue,
              reason: '${question.id} complete repair candidates',
            );
          }

          await _submitCorrect(tester, question);
          expect(
            find.byKey(const ValueKey('challenge-inline-feedback')),
            findsOneWidget,
            reason: question.id,
          );
          expect(find.text('回答正确'), findsOneWidget, reason: question.id);
          expect(
            find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
            findsOneWidget,
            reason: '${question.id} post-submit feedback speaker',
          );
          expect(
            find.byKey(const ValueKey('challenge-next')),
            findsOneWidget,
          );

          matrix.add(<String, Object?>{
            'level': level,
            'question_index': questionIndex + 1,
            'family': _family(question.mode),
            'prompt': question.prompt,
            'body': question.sourceSentence,
            'options': question.options,
            'correct_answer': question.answer,
            'learning_objective': question.learningObjective,
            'knowledge_target': question.knowledgeTarget,
            'language_target': question.languageTarget,
            'reasoning': question.reasoningTarget,
            'why_correct': question.whyCorrect,
            'distractor_rationales': question.distractorRationales,
            'knowledge_source': question.knowledgeSource,
            'story_source': question.storyEvidence,
            'difficulty': question.difficulty,
            'template_signature': question.signature.templateSignature,
            'semantic_signature': question.signature.semanticSignature,
            'feedback': '回答正确 / 正确答案 / why-correct',
            'audio_pre_submit_state': 'feedback speaker absent',
            'audio_post_submit_state': 'feedback speaker available',
            'result': 'PASS',
          });
        }

        for (var first = 0; first < set.questions.length; first += 1) {
          for (var second = first + 1;
              second < set.questions.length;
              second += 1) {
            final a = set.questions[first];
            final b = set.questions[second];
            comparisons.add(<String, Object?>{
              'scope': 'within-level',
              'level': level,
              'a': a.id,
              'b': b.id,
              'classification': _comparisonClass(a, b),
            });
          }
        }
      }

      for (var levelIndex = 1; levelIndex < levels.length; levelIndex += 1) {
        final previous = levels[levelIndex - 1];
        final current = levels[levelIndex];
        for (final mode in StoryChallengeMode.values) {
          final aItems = previous.questions.where((q) => q.mode == mode).toList();
          final bItems = current.questions.where((q) => q.mode == mode).toList();
          for (final a in aItems) {
            for (final b in bItems) {
              comparisons.add(<String, Object?>{
                'scope': 'adjacent-level',
                'from_level': previous.sessionLevel,
                'to_level': current.sessionLevel,
                'family': _family(mode),
                'a': a.id,
                'b': b.id,
                'classification': _comparisonClass(a, b),
              });
            }
          }
        }
      }

      final audit = auditor.auditMatrix(levels);
      final templateDuplicates = comparisons
          .where((row) => row['classification'] == 'TEMPLATE DUPLICATE')
          .length;
      final trivialVariations = comparisons
          .where((row) => row['classification'] == 'TRIVIAL VARIATION')
          .length;
      final invalid = audit.failures.length;

      final output = Directory('build/authoritative-story')
        ..createSync(recursive: true);
      File('${output.path}/challenge-rendered-matrix.json').writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(<String, Object?>{
          'journey_id': _journeyId,
          'story': '两条路，一张图',
          'levels': 10,
          'total_rendered_questions': matrix.length,
          'architecture': <String, int>{
            'Semantic Sentence Rebuild': 2,
            'Grammar Repair': 2,
            'Context Completion': 2,
            'Story Evidence / Understanding': 2,
            'Knowledge / Spatial Reasoning': 2,
            'Scenario / Route Decision': 2,
          },
          'questions': matrix,
        }),
      );
      File('${output.path}/challenge-semantic-uniqueness-report.json')
          .writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(<String, Object?>{
          'template_duplicate': templateDuplicates,
          'trivial_variation': trivialVariations,
          'invalid': invalid,
          'audit_failures': audit.failures,
          'comparisons': comparisons,
        }),
      );

      expect(matrix, hasLength(120));
      expect(templateDuplicates, 0);
      expect(trivialVariations, 0);
      expect(invalid, 0, reason: audit.failures.join('\n'));
    },
  );
}
