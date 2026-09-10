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

String _classify(StoryChallengeQuestion a, StoryChallengeQuestion b) {
  final exactA = _normalize(
    '${a.mode.name}|${a.prompt}|${a.answer}|${a.options.join('|')}',
  );
  final exactB = _normalize(
    '${b.mode.name}|${b.prompt}|${b.answer}|${b.options.join('|')}',
  );
  if (exactA == exactB ||
      a.signature.semanticSignature == b.signature.semanticSignature) {
    return 'TEMPLATE DUPLICATE';
  }
  if (a.signature.templateSignature == b.signature.templateSignature) {
    return 'TRIVIAL VARIATION';
  }
  if (a.mode == b.mode &&
      _normalize(a.knowledgeTarget) == _normalize(b.knowledgeTarget)) {
    return 'INTENTIONALLY RELATED';
  }
  return 'MEANINGFULLY DIFFERENT';
}

Future<void> _pump(
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
            key: ValueKey('rendered-${question.id}'),
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

Future<void> _tapSubmit(WidgetTester tester) async {
  expect(find.text('提交'), findsOneWidget);
  await tester.tap(find.text('提交'));
  await tester.pump();
}

Future<void> _answerCorrectly(
  WidgetTester tester,
  StoryChallengeQuestion question,
) async {
  switch (question.mode) {
    case StoryChallengeMode.sentenceRebuild:
      final available = List<String>.of(question.characterTiles);
      var cursor = 0;
      while (available.isNotEmpty && cursor < question.answer.length) {
        final index = available.indexWhere(
          (tile) => question.answer.startsWith(tile, cursor),
        );
        expect(index, greaterThanOrEqualTo(0), reason: question.id);
        final tile = available.removeAt(index);
        await tester.tap(find.widgetWithText(ActionChip, tile).first);
        await tester.pump();
        cursor += tile.length;
      }
      expect(cursor, question.answer.length, reason: question.id);
      await _tapSubmit(tester);
    case StoryChallengeMode.grammarRepair:
      final error = question.errorSegmentIndex!;
      await tester.tap(find.byKey(ValueKey('grammar-location-$error')));
      await tester.pump();
      await _tapSubmit(tester);
      expect(
        find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
        findsNothing,
        reason: '${question.id}: Step 1 is not final feedback',
      );
      final correct = question.options.indexOf(question.answer);
      await tester.tap(find.byKey(ValueKey('grammar-repair-$correct')));
      await tester.pump();
      await _tapSubmit(tester);
    case StoryChallengeMode.storyCompletion:
    case StoryChallengeMode.storyEvidence:
    case StoryChallengeMode.knowledgeReasoning:
    case StoryChallengeMode.scenarioDecision:
      final correct = question.options.indexOf(question.answer);
      expect(correct, greaterThanOrEqualTo(0), reason: question.id);
      await tester.tap(find.byKey(ValueKey('challenge-option-$correct')));
      await tester.pump();
      await _tapSubmit(tester);
  }
}

void main() {
  test('Journey Challenge has no page-level pre-completion CTA', () {
    final source = File('lib/screens/journey_screen.dart').readAsStringSync();
    expect(source, isNot(contains('完成挑战后继续')));
    expect(source, contains('showActions: _challengeResolved'));
  });

  testWidgets(
    'Golden Challenge renders all 120 authored 2x6 questions',
    (tester) async {
      const engine = JourneyChallengeEngine();
      const auditor = ChallengeAntiTemplateAuditor();
      final sets = <StoryChallengeSet>[];
      final rows = <Map<String, Object?>>[];
      final comparisons = <Map<String, Object?>>[];

      for (var level = 1; level <= 10; level += 1) {
        final set = engine.build(
          journeyId: _journeyId,
          sessionLevel: level,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
        );
        sets.add(set);
        expect(set.questions, hasLength(12), reason: 'Lv$level count');
        for (final mode in StoryChallengeMode.values) {
          expect(
            set.questions.where((q) => q.mode == mode),
            hasLength(2),
            reason: 'Lv$level ${mode.name}',
          );
        }

        for (var index = 0; index < set.questions.length; index += 1) {
          final question = set.questions[index];
          await _pump(tester, question, level);

          expect(find.text('上一步'), findsOneWidget);
          expect(find.text('提交'), findsOneWidget);
          expect(find.text('完成挑战后继续'), findsNothing);
          expect(find.text('确认位置'), findsNothing);
          expect(find.text('继续修改'), findsNothing);
          expect(
            find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
            findsNothing,
            reason: '${question.id}: pre-submit feedback speaker',
          );

          if (question.mode == StoryChallengeMode.sentenceRebuild) {
            expect(
              question.characterTiles.any((tile) {
                final han = RegExp(r'[\u3400-\u9fff]').allMatches(tile).length;
                return han == 1 && !const <String>{'却', '再'}.contains(tile);
              }),
              isFalse,
              reason: '${question.id}: character atomization',
            );
          }
          if (question.mode == StoryChallengeMode.grammarRepair) {
            const punctuation = <String>{'。', '，', '！', '？', '：', '；'};
            expect(
              question.errorSegments.any(
                (segment) => punctuation.contains(segment.trim()),
              ),
              isFalse,
              reason: '${question.id}: punctuation option',
            );
            expect(
              question.options.every(
                (option) => RegExp(r'[。？！]$').hasMatch(option.trim()),
              ),
              isTrue,
              reason: '${question.id}: complete repair candidates',
            );
          }

          await _answerCorrectly(tester, question);
          expect(find.text('回答正确'), findsOneWidget, reason: question.id);
          expect(find.text('下一题'), findsOneWidget, reason: question.id);
          expect(
            find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
            findsOneWidget,
            reason: '${question.id}: post-submit feedback speaker',
          );

          rows.add(<String, Object?>{
            'level': level,
            'question_index': index + 1,
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

        for (var a = 0; a < set.questions.length; a += 1) {
          for (var b = a + 1; b < set.questions.length; b += 1) {
            comparisons.add(<String, Object?>{
              'scope': 'within-level',
              'level': level,
              'a': set.questions[a].id,
              'b': set.questions[b].id,
              'classification': _classify(set.questions[a], set.questions[b]),
            });
          }
        }
      }

      for (var i = 1; i < sets.length; i += 1) {
        for (final mode in StoryChallengeMode.values) {
          final previous = sets[i - 1].questions.where((q) => q.mode == mode);
          final current = sets[i].questions.where((q) => q.mode == mode);
          for (final a in previous) {
            for (final b in current) {
              comparisons.add(<String, Object?>{
                'scope': 'adjacent-level',
                'from_level': i,
                'to_level': i + 1,
                'family': _family(mode),
                'a': a.id,
                'b': b.id,
                'classification': _classify(a, b),
              });
            }
          }
        }
      }

      final audit = auditor.auditMatrix(sets);
      final templateDuplicates = comparisons
          .where((item) => item['classification'] == 'TEMPLATE DUPLICATE')
          .length;
      final trivialVariations = comparisons
          .where((item) => item['classification'] == 'TRIVIAL VARIATION')
          .length;
      final output = Directory('build/authoritative-story')
        ..createSync(recursive: true);

      File('${output.path}/challenge-rendered-matrix.json').writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(<String, Object?>{
          'journey_id': _journeyId,
          'story': '两条路，一张图',
          'levels': 10,
          'total_rendered_questions': rows.length,
          'questions': rows,
        }),
      );
      File('${output.path}/challenge-semantic-uniqueness-report.json')
          .writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(<String, Object?>{
          'template_duplicate': templateDuplicates,
          'trivial_variation': trivialVariations,
          'invalid': audit.failures.length,
          'audit_failures': audit.failures,
          'comparisons': comparisons,
        }),
      );

      expect(rows, hasLength(120));
      expect(templateDuplicates, 0);
      expect(trivialVariations, 0);
      expect(audit.failures, isEmpty, reason: audit.failures.join('\n'));
    },
  );
}
