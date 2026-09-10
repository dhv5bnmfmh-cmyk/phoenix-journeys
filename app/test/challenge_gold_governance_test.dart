import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _repoText(String path) {
  for (final candidate in <File>[File('../$path'), File(path)]) {
    if (candidate.existsSync()) return candidate.readAsStringSync();
  }
  throw StateError('Cannot locate repository file: $path');
}

void main() {
  test('authoritative entry point owns the full Challenge Gold contract', () {
    final standard = _repoText('docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md');
    final authority = _repoText('docs/AUTHORITATIVE_STORY_DEVELOPMENT_CONTRACT.md');
    for (final required in <String>[
      'TAUGHT CONTENT → CLEAR LEARNING INTENT',
      'TEACH BEFORE TEST',
      'One primary learning intent',
      'Family differentiation',
      'One defensible best answer',
      'Gold distractors',
      'Diagnosable misunderstanding',
      'Closed learning loop',
      'Provenance',
      'Fairness',
      'Cognitive progression',
      'Lv1, Lv5, and Lv10',
      'CHALLENGE LEARNING INTENT',
      'DISTRACTOR MISCONCEPTION LOGIC',
      'HUMAN CHALLENGE REVIEW',
      'EXISTING GOLD IS NOT GRANDFATHERED AGAINST NEW CANONICAL CHALLENGE QUALITY',
      'PHOENIX ALL-GOLD CHALLENGE MATRIX',
      'PASS BY LEGACY APPROVAL',
      'AUDIT FIRST',
      'STANDARDIZE THE QUALITY PROCESS. DO NOT STANDARDIZE THE CONTENT SHAPE.',
      'LV1 HUMAN CHALLENGE REVIEW',
      'LV5 HUMAN CHALLENGE REVIEW',
      'LV10 HUMAN CHALLENGE REVIEW',
      'NO LEGACY CONTAMINATION',
      'NO CROSS-JOURNEY CONTAMINATION',
      'LANGUAGE LEARNING VALUE',
      'Semantic Sentence Rebuild / 语义块复原 × 2',
      'Grammar Repair / 语病修复 × 2',
      'Context Completion / 情境补全 × 2',
      'Story Evidence / Understanding / 故事证据与理解 × 2',
      'Knowledge & Spatial Reasoning / 知识与空间推理 × 2',
      'Scenario / Route Decision / 情境与路线决策 × 2',
    ]) {
      expect(authority, contains(required), reason: required);
    }
    expect(standard, contains('This document MUST NOT duplicate or redefine it'));
  });

  test('Acceptance, design, quality and AI layers bind to the same authority', () {
    final acceptance = _repoText('docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md');
    final design = _repoText('docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md');
    final quality = _repoText('docs/journey-content-quality-gate.md');
    final behavior = _repoText('ai/AI_BEHAVIOR.md');
    final creation = _repoText('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
    for (final gate in <String>[
      'Challenge Learning Intent',
      'Family Differentiation',
      'One Defensible Answer',
      'Distractor Misconception Logic',
      'Teach Before Test',
      'Challenge Provenance',
      'Human Challenge Review',
    ]) {
      expect(acceptance, contains(gate), reason: gate);
    }
    expect(design, contains('Primary Learning Intent'));
    expect(design, contains('Distractor Misconception'));
    expect(quality, contains('AUTHORITATIVE STORY DEVELOPMENT CONTRACT'));
    expect(behavior, contains('Challenge MUST NOT be generated as end-of-pipeline filler'));
    expect(creation, contains('CHALLENGE DESIGN → CHALLENGE GOLD AUDIT'));
    expect(creation, contains('Challenge Gold global convergence precondition'));
    expect(creation, contains('existing Gold Challenge is not grandfathered'));
    expect(design, contains('All-Gold Challenge audit matrix'));
    expect(design, contains('Cross-Gold anti-template record'));
    expect(quality, contains('Existing-Gold Challenge convergence gate'));
    expect(behavior, contains('Challenge Gold global audit behavior'));
    expect(acceptance, contains('Cross-Gold Anti-Template'));

    final sixAcceptance = _repoText(
      'docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md',
    );
    expect(sixAcceptance, contains('every current Gold Journey'));
    expect(sixAcceptance, contains('Stage 3 all-Gold convergence evidence'));
  });
}
