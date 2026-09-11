import '../models/journey_challenge.dart';
import 'challenge_option_balancer.dart';
import 'forbidden_city_challenge_level_standard.dart';
import 'journey_challenge_engine_legacy.dart' as legacy;

export 'journey_challenge_engine_legacy.dart'
    hide JourneyChallengeEngine, ChallengeAntiTemplateAuditor;

const _forbiddenCityJourneyId = 'beijing-forbidden-city';

/// Single product-facing Challenge entry point.
///
/// Golden Forbidden City uses the Founder-approved explicitly authored 2×6
/// package. Other existing Journeys retain their current legacy content path
/// until they are deliberately migrated through the same authoritative
/// contract. Final A/B/C/D order remains deterministic and content-preserving.
class JourneyChallengeEngine {
  const JourneyChallengeEngine();

  StoryChallengeSet build({
    required String journeyId,
    required int sessionLevel,
    required List<String> storyParagraphs,
  }) {
    final authored = journeyId == _forbiddenCityJourneyId
        ? buildForbiddenCityGoldenChallenge(
            level: sessionLevel,
            storyParagraphs: storyParagraphs,
          )
        : const legacy.JourneyChallengeEngine().build(
            journeyId: journeyId,
            sessionLevel: sessionLevel,
            storyParagraphs: storyParagraphs,
          );
    return _balanceRenderedMultipleChoiceOrder(authored);
  }
}

StoryChallengeSet _balanceRenderedMultipleChoiceOrder(
  StoryChallengeSet source,
) {
  final directChoiceQuestions = source.questions
      .where((question) => question.options.length == 4)
      .toList(growable: false);
  final directPositions = balancedChallengeAnswerPositions(
    itemCount: directChoiceQuestions.length,
    seed: '${source.journeyId}:${source.sessionLevel}:2x6:'
        '${directChoiceQuestions.map((question) => question.id).join('|')}',
    variationOrdinal: source.sessionLevel,
  );

  var cursor = 0;
  final questions = <StoryChallengeQuestion>[];
  for (final question in source.questions) {
    if (question.options.length != 4) {
      questions.add(question);
      continue;
    }

    final order = _optionIndexOrderForTarget(
      question.options,
      answer: question.answer,
      targetIndex: directPositions[cursor++],
    );
    final options = List<String>.unmodifiable(
      <String>[for (final index in order) question.options[index]],
    );
    final explanations = question.grammarOptionExplanations.isEmpty
        ? question.grammarOptionExplanations
        : List<String>.unmodifiable(
            <String>[
              for (final index in order)
                question.grammarOptionExplanations[index],
            ],
          );
    final rationales = question.distractorRationales.isEmpty
        ? question.distractorRationales
        : List<String>.unmodifiable(
            <String>[
              for (final index in order) question.distractorRationales[index],
            ],
          );
    questions.add(
      _copyQuestion(
        question,
        options: options,
        grammarOptionExplanations: explanations,
        distractorRationales: rationales,
      ),
    );
  }

  if (cursor != directPositions.length) {
    throw StateError(
      'Rendered multiple-choice scheduler did not consume all 2×6 items.',
    );
  }
  return StoryChallengeSet(
    journeyId: source.journeyId,
    sessionLevel: source.sessionLevel,
    questions: List<StoryChallengeQuestion>.unmodifiable(questions),
  );
}

List<int> _optionIndexOrderForTarget(
  List<String> options, {
  required String answer,
  required int targetIndex,
}) {
  if (targetIndex < 0 || targetIndex >= options.length) {
    throw RangeError.index(targetIndex, options, 'targetIndex');
  }
  final correctIndices = <int>[
    for (var index = 0; index < options.length; index += 1)
      if (options[index] == answer) index,
  ];
  if (correctIndices.length != 1) {
    throw StateError(
      'Multiple-choice item must contain exactly one correct option.',
    );
  }
  final correctIndex = correctIndices.single;
  final order = List<int>.generate(options.length, (index) => index)
    ..remove(correctIndex)
    ..insert(targetIndex, correctIndex);
  return order;
}

StoryChallengeQuestion _copyQuestion(
  StoryChallengeQuestion source, {
  required List<String> options,
  required List<String> grammarOptionExplanations,
  required List<String> distractorRationales,
}) =>
    StoryChallengeQuestion(
      id: source.id,
      mode: source.mode,
      sourceSentence: source.sourceSentence,
      prompt: source.prompt,
      answer: source.answer,
      options: options,
      characterTiles: source.characterTiles,
      errorSegments: source.errorSegments,
      errorSegmentIndex: source.errorSegmentIndex,
      grammarFamily: source.grammarFamily,
      grammarWhyWrong: source.grammarWhyWrong,
      grammarRevisionRule: source.grammarRevisionRule,
      grammarOptionExplanations: grammarOptionExplanations,
      completionSegments: source.completionSegments,
      completionBlanks: source.completionBlanks,
      narrationText: source.narrationText,
      learningObjective: source.learningObjective,
      knowledgeTarget: source.knowledgeTarget,
      languageTarget: source.languageTarget,
      reasoningTarget: source.reasoningTarget,
      whyCorrect: source.whyCorrect,
      distractorRationales: distractorRationales,
      difficulty: source.difficulty,
      storyEvidence: source.storyEvidence,
      knowledgeSource: source.knowledgeSource,
      signature: source.signature,
    );

/// The existing Semantic Anti-Template gate, extended to the active 2×6
/// Challenge contract. This remains the single active Challenge auditor.
class ChallengeAntiTemplateAuditor {
  const ChallengeAntiTemplateAuditor();

  ChallengeAuditReport audit(StoryChallengeSet set) {
    final failures = <String>[];
    if (set.journeyId == _forbiddenCityJourneyId) {
      if (set.questions.length != 12) failures.add('question-count');
      for (final mode in _goldenModes) {
        if (set.questions.where((q) => q.mode == mode).length != 2) {
          failures.add('${mode.name}-count');
        }
      }
    }

    final ids = <String>{};
    final prompts = <String>{};
    final semantic = <String>{};
    for (final question in set.questions) {
      if (!ids.add(question.id)) failures.add('duplicate-id:${question.id}');
      final normalizedPrompt = _normalize(question.prompt);
      if (!prompts.add(normalizedPrompt)) {
        failures.add('normalized-prompt-duplicate:${question.id}');
      }
      if (question.signature.semanticSignature.isNotEmpty &&
          !semantic.add(question.signature.semanticSignature)) {
        failures.add('semantic-duplicate:${question.id}');
      }
      if (_missingAuthoringRecord(question)) {
        failures.add('authoring-record:${question.id}');
      }
      _auditQuestion(question, failures);
    }

    return ChallengeAuditReport(failures: List<String>.unmodifiable(failures));
  }

  ChallengeAuditReport auditMatrix(List<StoryChallengeSet> levels) {
    final failures = <String>[];
    if (levels.length != 10) failures.add('level-count');
    final semantic = <String, String>{};
    final exact = <String, String>{};
    for (final set in levels) {
      failures.addAll(
        audit(set).failures.map((failure) => 'Lv${set.sessionLevel}:$failure'),
      );
      for (final question in set.questions) {
        final exactKey = _normalize(
          '${question.mode.name}|${question.prompt}|${question.answer}|'
          '${question.options.join('|')}',
        );
        final exactPrior = exact[exactKey];
        if (exactPrior != null) {
          failures.add('cross-level-exact:$exactPrior:${question.id}');
        } else {
          exact[exactKey] = question.id;
        }
        final signature = question.signature.semanticSignature;
        if (signature.isNotEmpty) {
          final prior = semantic[signature];
          if (prior != null) {
            failures.add('cross-level-semantic:$prior:${question.id}');
          } else {
            semantic[signature] = question.id;
          }
        }
      }
    }

    final ordered = [...levels]
      ..sort((a, b) => a.sessionLevel.compareTo(b.sessionLevel));
    for (var levelIndex = 1; levelIndex < ordered.length; levelIndex += 1) {
      final previous = ordered[levelIndex - 1];
      final current = ordered[levelIndex];
      for (final mode in _goldenModes) {
        final previousItems = previous.questions.where((q) => q.mode == mode);
        final currentItems = current.questions.where((q) => q.mode == mode);
        for (final prior in previousItems) {
          for (final next in currentItems) {
            if (_trivialAdjacentVariation(prior, next)) {
              failures.add('adjacent-template:${prior.id}:${next.id}');
            }
          }
        }
      }
    }
    return ChallengeAuditReport(failures: List<String>.unmodifiable(failures));
  }

  void _auditQuestion(
    StoryChallengeQuestion question,
    List<String> failures,
  ) {
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      if (question.characterTiles.length < 3 ||
          question.characterTiles.join().length != question.answer.length) {
        failures.add('rebuild-structure:${question.id}');
      }
      if (question.characterTiles.any(_singleHanFragment)) {
        failures.add('character-atomization:${question.id}');
      }
      final available = List<String>.of(question.characterTiles);
      var cursor = 0;
      while (available.isNotEmpty && cursor < question.answer.length) {
        final index = available.indexWhere(
          (tile) => question.answer.startsWith(tile, cursor),
        );
        if (index < 0) {
          failures.add('rebuild-unique-order:${question.id}');
          break;
        }
        cursor += available.removeAt(index).length;
      }
      if (cursor != question.answer.length) {
        failures.add('rebuild-answer-coverage:${question.id}');
      }
      return;
    }

    if (question.options.length != 4 ||
        question.options.toSet().length != 4 ||
        question.options.where((option) => option == question.answer).length !=
            1) {
      failures.add('mcq-answer-contract:${question.id}');
    }

    if (question.mode == StoryChallengeMode.grammarRepair) {
      if (question.errorSegments.length != 4 ||
          question.errorSegmentIndex == null ||
          question.errorSegments.join() != question.prompt ||
          question.errorSegments.any(
            (segment) => !_isMeaningfulGrammarUnit(segment),
          ) ||
          _hasGrammarFragmentationLeak(
            question.errorSegments,
            question.errorSegmentIndex!,
          )) {
        failures.add('grammar-step1:${question.id}');
      }
      if (question.options.any((option) => !_looksLikeCompleteSentence(option))) {
        failures.add('grammar-step2-fragment:${question.id}');
      }
      if (question.grammarWhyWrong?.trim().isEmpty ?? true) {
        failures.add('grammar-why:${question.id}');
      }
      if (question.grammarRevisionRule?.trim().isEmpty ?? true) {
        failures.add('grammar-rule:${question.id}');
      }
      if (question.grammarOptionExplanations.length != 4) {
        failures.add('grammar-explanations:${question.id}');
      }
    }

    if (question.mode == StoryChallengeMode.storyCompletion &&
        (!question.prompt.contains('____') ||
            question.sourceSentence.trim().isEmpty)) {
      failures.add('context-completion:${question.id}');
    }
    if (question.mode == StoryChallengeMode.storyEvidence &&
        question.storyEvidence.trim().isEmpty) {
      failures.add('story-evidence:${question.id}');
    }
    if (question.mode == StoryChallengeMode.knowledgeReasoning &&
        question.knowledgeSource.trim().isEmpty) {
      failures.add('knowledge-source:${question.id}');
    }
    if (question.mode == StoryChallengeMode.scenarioDecision &&
        question.reasoningTarget.trim().isEmpty) {
      failures.add('scenario-reasoning:${question.id}');
    }
  }
}

const _goldenModes = <StoryChallengeMode>[
  StoryChallengeMode.sentenceRebuild,
  StoryChallengeMode.grammarRepair,
  StoryChallengeMode.storyCompletion,
  StoryChallengeMode.storyEvidence,
  StoryChallengeMode.knowledgeReasoning,
  StoryChallengeMode.scenarioDecision,
];

bool _missingAuthoringRecord(StoryChallengeQuestion question) =>
    question.learningObjective.trim().isEmpty ||
    question.knowledgeTarget.trim().isEmpty ||
    question.languageTarget.trim().isEmpty ||
    question.reasoningTarget.trim().isEmpty ||
    question.whyCorrect.trim().isEmpty ||
    question.difficulty.trim().isEmpty ||
    question.knowledgeSource.trim().isEmpty ||
    question.signature.templateSignature.trim().isEmpty ||
    question.signature.semanticSignature.trim().isEmpty;

bool _singleHanFragment(String value) {
  final han = RegExp(r'[\u3400-\u9fff]').allMatches(value).length;
  return han == 1 && !const <String>{'却', '再'}.contains(value);
}

bool _looksLikeCompleteSentence(String value) {
  final text = value.trim();
  return text.length >= 8 && RegExp(r'[。？！]$').hasMatch(text);
}

bool _isMeaningfulGrammarUnit(String value) {
  final text = value.trim();
  if (text.isEmpty || RegExp(r'^[。，“”！？：；、…]+$').hasMatch(text)) {
    return false;
  }
  final core = text.replaceAll(RegExp(r'[。，“”！？：；、…]+$'), '');
  if (core.isEmpty) return false;
  const meaninglessTails = <String>{
    '的', '了', '在', '写', '往', '着', '过',
    '但是', '所以', '而且', '完整', '了起来', '了下来',
  };
  if (RegExp(r'[。！？，；：]$').hasMatch(text) &&
      meaninglessTails.contains(core)) {
    return false;
  }
  return !RegExp(r'^[的了在写往着过把被]+$').hasMatch(core);
}

bool _hasGrammarFragmentationLeak(List<String> segments, int errorIndex) {
  final error = segments[errorIndex].trim();
  if (!_isMeaningfulGrammarUnit(error)) return true;
  final core = error.replaceAll(RegExp(r'[。，“”！？：；、…]+$'), '');
  final danglingTail = RegExp(
    r'^(的|了|着|过|起来|下来|上去|完整|但是|所以|而且)$',
  ).hasMatch(core) && RegExp(r'[。！？，；：]$').hasMatch(error);
  return danglingTail &&
      segments
          .asMap()
          .entries
          .where((entry) => entry.key != errorIndex)
          .every((entry) => _isMeaningfulGrammarUnit(entry.value));
}

bool _trivialAdjacentVariation(
  StoryChallengeQuestion previous,
  StoryChallengeQuestion current,
) {
  if (previous.signature.templateSignature !=
      current.signature.templateSignature) {
    return false;
  }
  final previousLogic = _normalize(
    '${previous.reasoningTarget}|${previous.whyCorrect}',
  );
  final currentLogic = _normalize(
    '${current.reasoningTarget}|${current.whyCorrect}',
  );
  return previousLogic == currentLogic;
}

String _normalize(String value) => value
    .replaceAll(RegExp(r'沈砚|阿宁|周师傅'), '<PERSON>')
    .replaceAll(
      RegExp(r'紫禁城|午门|乾清门|中轴|外朝|内廷|东侧'),
      '<PLACE>',
    )
    .replaceAll(RegExp(r'[，。！？：；、“”\s]'), '')
    .toLowerCase();
