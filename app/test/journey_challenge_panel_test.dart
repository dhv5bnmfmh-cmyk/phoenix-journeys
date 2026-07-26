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
  required int seed,
  ChineseProficiencyProfile? profile,
  required JourneyChallengeResolved onResolved,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 430,
          height: 900,
          child: JourneyChallengePanel(
            journeyId: 'beijing-summer-palace',
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
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
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

  test('seed rotates through all three challenge types', () {
    expect(challengeTypeForSeed(0), JourneyChallengeType.paragraphRebuild);
    expect(challengeTypeForSeed(1), JourneyChallengeType.grammarRepair);
    expect(challengeTypeForSeed(2), JourneyChallengeType.missingSentence);
    expect(challengeTypeForSeed(3), JourneyChallengeType.paragraphRebuild);
  });

  testWidgets('paragraph rebuild awards gold on the first correct attempt',
      (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      seed: 0,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    expect(
      find.byKey(const ValueKey('challenge-type-paragraphRebuild')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-option-distractor-0')),
        findsOneWidget);

    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-option-correct-1');
    await _tapKey(tester, 'challenge-option-correct-2');
    await _tapKey(tester, 'challenge-submit');

    expect(rewards, ['金币']);
    expect(find.byKey(const ValueKey('challenge-reward-gold')), findsOneWidget);
  });

  testWidgets('second correct submission awards silver', (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      seed: 0,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    await _tapKey(tester, 'challenge-option-correct-1');
    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-option-correct-2');
    await _tapKey(tester, 'challenge-submit');

    await _tapKey(tester, 'challenge-option-correct-0');
    await _tapKey(tester, 'challenge-option-correct-1');
    await _tapKey(tester, 'challenge-option-correct-2');
    await _tapKey(tester, 'challenge-submit');

    expect(rewards, ['银币']);
    expect(find.byKey(const ValueKey('challenge-reward-silver')), findsOneWidget);
  });

  testWidgets('three failed submissions reveal answer and award silver fragment',
      (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      seed: 0,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    for (var attempt = 0; attempt < 3; attempt++) {
      await _tapKey(tester, 'challenge-option-correct-1');
      await _tapKey(tester, 'challenge-option-correct-0');
      await _tapKey(tester, 'challenge-option-correct-2');
      await _tapKey(tester, 'challenge-submit');
    }

    expect(rewards, ['碎银']);
    expect(
      find.byKey(const ValueKey('challenge-reward-fragment')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-explanation')), findsOneWidget);
    expect(find.textContaining('自动展示正确答案'), findsOneWidget);
  });

  testWidgets('grammar repair shows every required explanation field',
      (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      seed: 1,
      profile: _profile(PhoenixReadingBand.intermediate),
      onResolved: (reward, _) async => rewards.add(reward),
    );

    expect(
      find.byKey(const ValueKey('challenge-type-grammarRepair')),
      findsOneWidget,
    );
    await _tapKey(tester, 'challenge-grammar-segment-1');
    await _tapKey(tester, 'challenge-option-correct');
    await _tapKey(tester, 'challenge-submit');

    expect(rewards, ['金币']);
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
  });

  testWidgets('missing sentence challenge uses six choices and resolves',
      (tester) async {
    final rewards = <String>[];
    await _pumpChallenge(
      tester,
      seed: 2,
      onResolved: (reward, _) async => rewards.add(reward),
    );

    expect(
      find.byKey(const ValueKey('challenge-type-missingSentence')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-option-correct')), findsOneWidget);
    expect(find.byKey(const ValueKey('challenge-option-distractor-4')),
        findsOneWidget);

    await _tapKey(tester, 'challenge-option-correct');
    await _tapKey(tester, 'challenge-submit');
    expect(rewards, ['金币']);
  });

  testWidgets('resolved challenge cannot send the same reward twice',
      (tester) async {
    var rewardCalls = 0;
    await _pumpChallenge(
      tester,
      seed: 2,
      onResolved: (_, __) async {
        rewardCalls += 1;
        await Future<void>.delayed(const Duration(milliseconds: 20));
      },
    );

    await _tapKey(tester, 'challenge-option-correct');
    final submit = find.byKey(const ValueKey('challenge-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(rewardCalls, 1);
  });
}
