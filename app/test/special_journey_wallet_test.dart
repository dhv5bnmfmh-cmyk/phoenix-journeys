import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('challenge reward is awarded once and survives reload', () async {
    final state = AppState();
    await state.load();

    final first = await state.awardChallengeRewardOnce(
      reward: '金币',
      awardId: 'journey:paragraph:1',
    );
    final duplicate = await state.awardChallengeRewardOnce(
      reward: '金币',
      awardId: 'journey:paragraph:1',
    );

    expect(first, isTrue);
    expect(duplicate, isFalse);
    expect(state.goldCoins, 1);

    final restored = AppState();
    await restored.load();
    expect(restored.goldCoins, 1);
    expect(restored.awardedChallengeIds, contains('journey:paragraph:1'));
  });

  test('special journey deducts coins once and remains permanently unlocked',
      () async {
    final state = AppState();
    await state.load();

    for (var index = 0; index < 3; index++) {
      await state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'gold-$index',
      );
    }
    expect(state.goldCoins, 3);

    final unlocked = await state.unlockSpecialJourney(
      journeyId: 'myth-tracing',
      currency: '金币',
      cost: 3,
    );
    expect(unlocked.status, SpecialJourneyUnlockStatus.unlocked);
    expect(state.goldCoins, 0);
    expect(state.isSpecialJourneyUnlocked('myth-tracing'), isTrue);

    final reopened = await state.unlockSpecialJourney(
      journeyId: 'myth-tracing',
      currency: '金币',
      cost: 3,
    );
    expect(reopened.status, SpecialJourneyUnlockStatus.alreadyUnlocked);
    expect(state.goldCoins, 0);

    final restored = AppState();
    await restored.load();
    expect(restored.isSpecialJourneyUnlocked('myth-tracing'), isTrue);
    expect(restored.goldCoins, 0);
  });

  test('insufficient balance reports exact missing currency amount', () async {
    final state = AppState();
    await state.load();

    await state.awardChallengeRewardOnce(
      reward: '银币',
      awardId: 'silver-1',
    );

    final result = await state.unlockSpecialJourney(
      journeyId: 'strange-night-talks',
      currency: '银币',
      cost: 3,
    );

    expect(result.status, SpecialJourneyUnlockStatus.insufficientFunds);
    expect(result.balance, 1);
    expect(result.missing, 2);
    expect(state.silverCoins, 1);
    expect(state.isSpecialJourneyUnlocked('strange-night-talks'), isFalse);
  });
}
