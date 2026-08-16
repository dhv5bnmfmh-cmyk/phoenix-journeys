import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _repoText(String path) {
  for (final candidate in <File>[File('../$path'), File(path)]) {
    if (candidate.existsSync()) return candidate.readAsStringSync();
  }
  throw StateError('Cannot locate repository file: $path');
}

void main() {
  test('Six-Stage Standard owns the full Challenge Gold contract', () {
    final standard = _repoText('docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md');
    for (final required in <String>[
      'TAUGHT CONTENT → CLEAR LEARNING INTENT',
      'TEACH BEFORE TEST',
      'One primary learning intent',
      'Mode differentiation',
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
    ]) {
      expect(standard, contains(required), reason: required);
    }
    expect(standard, contains('paragraphRebuild'));
    expect(standard, contains('grammarRepair'));
    expect(standard, contains('missingSentence'));
  });

  test('Acceptance, design, quality and AI layers bind to the same authority', () {
    final acceptance = _repoText('docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md');
    final design = _repoText('docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md');
    final quality = _repoText('docs/journey-content-quality-gate.md');
    final behavior = _repoText('ai/AI_BEHAVIOR.md');
    final creation = _repoText('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
    for (final gate in <String>[
      'Challenge Learning Intent',
      'Mode Differentiation',
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
    expect(quality, contains('Six-Stage Journey Standard §3'));
    expect(behavior, contains('Challenge MUST NOT be generated as end-of-pipeline filler'));
    expect(creation, contains('Challenge Design → Challenge Gold Audit'));
  });
}
