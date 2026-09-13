import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
  final standard = File('../docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md')
      .readAsStringSync();

  test('Memory and Completion use one shared narration runtime', () {
    expect(RegExp(r'NarrationController\(\)').allMatches(journey).length, 1);
    expect(RegExp("narrationStage: 'memory'").allMatches(journey).length, 3);
    expect(
      RegExp("narrationStage: 'completion'").allMatches(journey).length,
      2,
    );
    expect(journey, contains('Widget _stageNarrationFrame({'));
    expect(journey, contains('await _narration.stop();'));
    expect(journey, contains('await _narration.play('));
  });

  test('narration is user initiated and cancelled on Journey exits', () {
    expect(journey, isNot(contains('_scheduleStageNarration')));
    expect(journey, contains('Future<void> _stopJourneyNarration()'));
    expect(journey, contains('Future<void> _exitJourney()'));
    expect(journey, contains("? () => unawaited(_exitJourney())"));
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
    expect(
      RegExp(r'displayText: _appState\.displayText')
          .allMatches(journey)
          .length,
      greaterThanOrEqualTo(2),
    );
    expect(journey, contains('resolvedDisplayText(discovery)'));
    expect(journey, contains('resolvedDisplayText(learning)'));
    expect(journey, contains('resolvedDisplayText(anchor)'));
    expect(journey, contains('memoryController.text.trim()'));
  });

  group('Forbidden City Final Memory displayed-script SSOT', () {
    void verifyMode(ScriptMode mode) {
      final state = AppState()..scriptMode = mode;
      var changedTraditionalBodies = 0;

      for (var level = 1; level <= 10; level += 1) {
        final completion = forbiddenCityCompletionForLevel(level);
        final memory = forbiddenCityMemoryForLevel(level);
        final sections = forbiddenCityFinalMemorySections(
          discovery: completion.discovery,
          learning: completion.learning,
          anchor: memory.anchor,
          displayText: state.displayText,
        );
        final narration = forbiddenCityFinalMemoryNarrationLines(sections);

        expect(sections, hasLength(3), reason: 'Lv$level section count');
        expect(
          sections[0].value,
          state.displayText(completion.discovery),
          reason: 'Lv$level discovery display script',
        );
        expect(
          sections[1].value,
          state.displayText(completion.learning),
          reason: 'Lv$level learning display script',
        );
        expect(
          sections[2].value,
          state.displayText(memory.anchor),
          reason: 'Lv$level anchor display script',
        );
        expect(
          narration,
          <String>[
            sections[0].key,
            sections[0].value,
            sections[1].key,
            sections[1].value,
            sections[2].key,
            sections[2].value,
            forbiddenCityFinalMemoryPrompt,
          ],
          reason: 'Lv$level UI/audio shared section values',
        );

        if (mode == ScriptMode.traditional) {
          final rawBodies = <String>[
            completion.discovery,
            completion.learning,
            memory.anchor,
          ];
          for (var i = 0; i < rawBodies.length; i += 1) {
            if (sections[i].value != rawBodies[i]) {
              changedTraditionalBodies += 1;
            }
          }
        }
      }

      if (mode == ScriptMode.traditional) {
        expect(changedTraditionalBodies, greaterThan(0));
      }
    }

    test('Simplified Final Memory UI and narration share displayed content', () {
      verifyMode(ScriptMode.simplified);
      debugPrint('FINAL MEMORY DISPLAY SCRIPT: PASS');
      debugPrint('FINAL MEMORY UI/AUDIO SSOT: PASS');
    });

    test('Traditional Final Memory UI and narration share converted content', () {
      verifyMode(ScriptMode.traditional);
      debugPrint('FINAL MEMORY DISPLAY SCRIPT: PASS');
      debugPrint('FINAL MEMORY UI/AUDIO SSOT: PASS');
    });
  });

  test('Forbidden City Memory and Completion bind the locked session level', () {
    expect(
      RegExp(r'forbiddenCityMemoryForLevel\(').allMatches(journey).length,
      2,
    );
    expect(
      RegExp(r'forbiddenCityCompletionForLevel\(').allMatches(journey).length,
      2,
    );
    expect(
      RegExp(r'_sessionLanguageProfile\.phoenixLevel \?\? 1')
          .allMatches(journey)
          .length,
      greaterThanOrEqualTo(2),
    );
    for (final field in <String>[
      'completion.discovery',
      'completion.learning',
      'memory.anchor',
    ]) {
      expect(journey, contains(field), reason: field);
    }
  });

  test('Forbidden City presents one five-stage finale without a second page', () {
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
    expect(journey, contains("'回忆 · 完成'"));
    expect(journey, contains("title: '回忆 · 完成'"));
    expect(journey, isNot(contains('Widget _forbiddenCityCompletePage()')));
    expect(journey, contains('if (_isForbiddenCity) return _forbiddenCityMemoryPage();'));
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
