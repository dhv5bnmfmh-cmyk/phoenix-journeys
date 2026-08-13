import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void _expectNoQaLanguageInVisibleChallenge() {
  for (final term in <String>[
    'Story',
    'Choice',
    'Cost',
    'Place Substitution Test',
    '不能换成普通公园',
    '因果测试',
    '文化因果 Gate',
    '工程验证',
    'PASS',
    'FAIL',
  ]) {
    expect(find.textContaining(term), findsNothing, reason: term);
  }
}

void main() {
  const agent = PhoenixLanguageLevelAgent();

  testWidgets(
    'Summer Palace three Challenge modes stay active and culturally grounded',
    (tester) async {
      final journey = requireDailyJourneyExperience('beijing-summer-palace');
      final profile = agent.profileForPhoenixLevel(7);
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final rewards = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 430,
              height: 900,
              child: JourneyChallengePanel(
                journeyId: journey.id,
                storyParagraphs: content.storyParagraphs,
                discoveryTexts:
                    content.discoveries.map((entry) => entry.text).toList(),
                profile: profile,
                seed: 175,
                displayText: (value) => value,
                onResolved: (reward, _) async => rewards.add(reward),
                onAllCompleted: () async {},
                autoNarrate: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('challenge-mode-paragraphRebuild')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-mode-grammarRepair')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-mode-missingSentence')),
        findsOneWidget,
      );

      expect(find.textContaining('十七孔桥'), findsWidgets);
      expect(find.textContaining('冬至前后'), findsWidgets);
      expect(find.textContaining('昆明湖的倒影'), findsNothing);
      _expectNoQaLanguageInVisibleChallenge();

      for (final key in <String>[
        'challenge-option-correct-0',
        'challenge-option-correct-1',
        'challenge-option-correct-2',
      ]) {
        if (find.byKey(ValueKey(key)).evaluate().isNotEmpty) {
          await _tap(tester, key);
        }
      }
      await _tap(tester, 'challenge-submit');
      await _tap(tester, 'challenge-dialog-action');

      expect(find.textContaining('十七孔桥'), findsWidgets);
      expect(find.textContaining('昆明湖的倒影'), findsNothing);
      _expectNoQaLanguageInVisibleChallenge();

      await _tap(tester, 'challenge-grammar-segment-1');
      await _tap(tester, 'challenge-option-correct');
      await _tap(tester, 'challenge-submit');
      await _tap(tester, 'challenge-dialog-action');

      expect(find.text('补回故事中消失的一句'), findsOneWidget);
      await _tap(tester, 'challenge-option-correct');
      await _tap(tester, 'challenge-submit');
      _expectNoQaLanguageInVisibleChallenge();
      expect(rewards, hasLength(3));
    },
  );
}
