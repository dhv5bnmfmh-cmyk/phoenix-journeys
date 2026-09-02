import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
  final standard = File('../docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md')
      .readAsStringSync();

  test('Memory and Completion use one shared narration runtime', () {
    expect(RegExp(r'NarrationController\(\)').allMatches(journey).length, 1);
    expect(RegExp("narrationStage: 'memory'").allMatches(journey).length, 3);
    expect(
      RegExp("narrationStage: 'completion'").allMatches(journey).length,
      3,
    );
    expect(journey, contains('Widget _stageNarrationFrame({'));
    expect(journey, contains('await _narration.stop();'));
    expect(journey, contains('await _narration.play('));
  });

  test('narration is user initiated and cancelled on Journey exits', () {
    expect(journey, isNot(contains('_scheduleStageNarration')));
    expect(journey, contains('Future<void> _stopJourneyNarration()'));
    expect(journey, contains('Future<void> _exitJourney()'));
    expect(
      RegExp(r'onNext: \(\) => unawaited\(_exitJourney\(\)\),')
          .allMatches(journey)
          .length,
      3,
    );
    expect(
      journey,
      contains(
        'Future<void> _restartJourney() async {\n    await _stopJourneyNarration();',
      ),
    );
    expect(journey, contains('_narration.dispose();'));
    expect(journey, contains('await _narration.stop();'));
  });

  test('stage narration binds active Journey level and displayed script', () {
    expect(
      journey,
      contains(r"'${_experience.id}:$_readingLevelLabel:$stage'"),
    );
    expect(
      journey,
      contains('journeyStageNarrationLanguageCode(_appState.isTraditional)'),
    );
    expect(journey, contains('_appState.displayText(review.prompt)'));
    expect(journey, contains('_appState.displayText(item.answer)'));
    expect(journey, contains('memoryController.text.trim()'));
  });

  test('six-stage architecture is unchanged', () {
    final expected = <String>[
      '_storyPage(),',
      '_wordsPage(),',
      '_discoveryPage(),',
      ': _challengePage(),',
      ': _memoryPage(),',
      '_completePage(),',
    ];
    for (final anchor in expected) {
      expect(journey, contains(anchor));
    }
    expect(journey, isNot(contains('Audio Stage')));
  });

  test(
    'canonical authority binds optional Memory and Completion narration',
    () {
      expect(
        standard,
        contains('MEMORY AND COMPLETION MUST SUPPORT USER-INITIATED NARRATION'),
      );
      expect(standard, contains('no forced autoplay'));
      expect(standard, contains('leave-page auto stop'));
    },
  );
}
