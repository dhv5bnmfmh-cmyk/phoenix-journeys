import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

String _identity(String value) => value;

ChineseProficiencyProfile _profile(PhoenixReadingBand band) {
  return ChineseProficiencyProfile(
    track: ChineseExamTrack.hsk,
    levelCode: band.name,
    levelLabel: band.label,
    band: band,
  );
}

Future<void> _pumpChallenge(
  WidgetTester tester, {
  int seed = 0,
  String journeyId = 'beijing-summer-palace',
  ChineseProficiencyProfile? profile,
  required JourneyChallengeResolved onResolved,
  JourneyChallengeCompleted? onAllCompleted,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Container(
          width: 430,
          height: 900,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF274C5C), Color(0xFF67462F)],
            ),
          ),
          child: JourneyChallengePanel(
            journeyId: journeyId,
            storyParagraphs: const [
              '清晨，探索者来到颐和园。',
              '他沿着长廊慢慢向前走。',
              '窗外的景色不断发生变化。',
              '远山进入廊窗形成的画面。',
              '最后，他把这次发现记了下来。',
            ],
            discoveryTexts: const [
              '长廊让游人在行走中不断看到新的景色。',
              '借景把远处的山纳入眼前的构图。',
            ],
            profile: profile,
            seed: seed,
            displayText: _identity,
            onResolved: onResolved,
            onAllCompleted: onAllCompleted ?? () async {},
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _challengeView() {
  return find.byKey(const ValueKey('challenge-scroll-area'));
}

Future<Finder> _ensureKeyVisible(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  if (finder.evaluate().isEmpty) {
    await tester.dragUntilVisible(
      finder,
      _challengeView(),
      const Offset(0, -220),
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  return finder;
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = await _ensureKeyVisible(tester, key);
  await tester.tap(finder);
  await tester.pumpAndSettle();
  if (key == 'challenge-next-mode') {
    await tester.fling(_challengeView(), const Offset(0, 1000), 1800);
    await tester.pumpAndSettle();
  }
}

Future<void> _completeParagraph(WidgetTester tester) async {
  await _tapKey(tester, 'challenge-option-correct-0');
  await _tapKey(tester, 'challenge-option-correct-1');
  await _tapKey(tester, 'challenge-submit');
}

Future<void> _completeGrammar(WidgetTester tester) async {
  await _tapKey(tester, 'challenge-grammar-segment-1');
  await _tapKey(tester, 'challenge-option-correct');
  await _tapKey(tester, 'challenge-submit');
}

Future<void> _completeMissingSentence(WidgetTester tester) async {
  await _tapKey(tester, 'challenge-option-correct');
  await _tapKey(tester, 'challenge-submit');
}

void main() {
  test('difficulty follows HSK or TOCFL profile and defaults to beginner', () {
    expect(
      challengeDifficultyForProfile(null),
      JourneyChallengeDifficulty.beginner,
    );
    expect(
      challengeDifficultyForProfile(_profile(PhoenixReadingBand.elementary)),
      JourneyChallengeDifficulty.beginner,
    );
    expect(
      challengeDifficultyForProfile(_profile(PhoenixReadingBand.intermediate)),
      JourneyChallengeDifficulty.standard,
    );
    expect(
      challengeDifficultyForProfile(_profile(PhoenixReadingBand.mastery)),
      JourneyChallengeDifficulty.advanced,
    );
  });

  test('challenge order is fixed instead of random', () {
    expect(fixedJourneyChallengeTypes, const [
      JourneyChallengeType.paragraphRebuild,
      JourneyChallengeType.grammarRepair,
      JourneyChallengeType.missingSentence,
    ]);
  });

  testWidgets(
    'all three modes are always visible and start with four choices',
    (tester) async {
      await _pumpChallenge(tester, onResolved: (_, __) async {});

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
      expect(
        find.byKey(const ValueKey('challenge-option-correct-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-option-correct-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-option-distractor-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-option-distractor-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('challenge-option-distractor-2')),
        findsNothing,
      );
    },
  );

  testWidgets('question and hint are separate surfaces', (tester) async {
    await _pumpChallenge(tester, onResolved: (_, __) async {});

    expect(
      find.byKey(const ValueKey('challenge-question-card')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-hint-card')), findsNothing);

    await _tapKey(tester, 'challenge-option-correct-1');
    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-submit');

    expect(
      find.byKey(const ValueKey('challenge-question-card')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-hint-card')), findsOneWidget);
  });

  testWidgets('three modes run in sequence and complete the whole challenge', (
    tester,
  ) async {
    final rewards = <String>[];
    var completed = 0;
    await _pumpChallenge(
      tester,
      onResolved: (reward, _) async => rewards.add(reward),
      onAllCompleted: () async => completed += 1,
    );

    await _completeParagraph(tester);
    expect(rewards, ['金币']);
    expect(completed, 0);

    await _tapKey(tester, 'challenge-next-mode');
    expect(find.text('修好这句不自然的话'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-option-distractor-3')),
      findsOneWidget,
    );
    await _completeGrammar(tester);
    expect(rewards, ['金币', '金币']);
    expect(completed, 0);

    await _tapKey(tester, 'challenge-next-mode');
    expect(find.text('补回故事中消失的一句'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-option-distractor-3')),
      findsOneWidget,
    );
    await _completeMissingSentence(tester);

    expect(rewards, ['金币', '金币', '金币']);
    expect(completed, 1);
    final completeButton = await _ensureKeyVisible(
      tester,
      'challenge-all-complete',
    );
    expect(completeButton, findsOneWidget);
  });

  testWidgets('second correct submission awards silver', (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    await _tapKey(tester, 'challenge-option-correct-1');
    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-submit');
    await _completeParagraph(tester);

    expect(rewards, ['银币']);
    expect(
      find.byKey(const ValueKey('challenge-reward-silver')),
      findsOneWidget,
    );
  });

  testWidgets('third failure reveals answer and awards silver fragment', (
    tester,
  ) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    for (var attempt = 0; attempt < 3; attempt++) {
      await _tapKey(tester, 'challenge-option-correct-1');
      await _tapKey(tester, 'challenge-option-correct-0');
      await _tapKey(tester, 'challenge-submit');
    }

    expect(rewards, ['碎银']);
    expect(
      find.byKey(const ValueKey('challenge-reward-fragment')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-explanation')), findsOneWidget);
    expect(find.textContaining('三次机会已经结束'), findsOneWidget);
    final nextMode = await _ensureKeyVisible(tester, 'challenge-next-mode');
    expect(nextMode, findsOneWidget);
  });

  testWidgets('grammar repair shows every explanation field', (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      journeyId: 'strange-night-talks',
      profile: _profile(PhoenixReadingBand.intermediate),
      onResolved: (reward, _) async => rewards.add(reward),
    );

    await _completeParagraph(tester);
    await _tapKey(tester, 'challenge-next-mode');
    await _completeGrammar(tester);
    await _ensureKeyVisible(tester, 'challenge-explanation');

    expect(rewards, ['金币', '金币']);
    for (final label in [
      '病句类型',
      '错误位置',
      '原句',
      '修改后',
      '为什么错误',
      '修改原则',
      '记忆方法',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.textContaining('夜客不但留下了铜钱'), findsWidgets);
  });

  testWidgets('rapid taps cannot award one mode twice', (tester) async {
    var rewardCalls = 0;
    await _pumpChallenge(
      tester,
      onResolved: (_, __) async {
        rewardCalls += 1;
        await Future<void>.delayed(const Duration(milliseconds: 20));
      },
    );

    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-option-correct-1');
    final submit = find.byKey(const ValueKey('challenge-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(rewardCalls, 1);
  });
}
