from __future__ import annotations

import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected exactly one match, found {count}")
    return text.replace(old, new, 1)


def regex_once(text: str, pattern: str, replacement: str, label: str) -> str:
    result, count = re.subn(pattern, replacement, text, count=1, flags=re.S)
    if count != 1:
        raise RuntimeError(f"{label}: expected exactly one regex match, found {count}")
    return result


def patch_journey_screen() -> None:
    path = ROOT / "app/lib/screens/journey_screen.dart"
    text = path.read_text(encoding="utf-8")

    if "../widgets/journey_challenge_panel.dart" not in text:
        text = replace_once(
            text,
            "import '../widgets/interactive_story_text.dart';\n",
            "import '../widgets/interactive_story_text.dart';\n"
            "import '../widgets/journey_challenge_panel.dart';\n",
            "journey challenge import",
        )

    text = replace_once(
        text,
        "  int _challengeAttempts = 0;\n"
        "  int? _selectedChallengeOption;\n"
        "  bool _challengeResolved = false;\n"
        "  String? _challengeReward;\n"
        "  late final int _challengeVariant;\n",
        "  bool _challengeResolved = false;\n"
        "  String? _challengeReward;\n"
        "  late int _challengeSeed;\n",
        "journey challenge fields",
    )

    text = replace_once(
        text,
        "    _challengeVariant =\n"
        "        (DateTime.now().millisecondsSinceEpoch + journeyId.hashCode).abs() % 3;\n",
        "    _challengeSeed =\n"
        "        (DateTime.now().millisecondsSinceEpoch + journeyId.hashCode).abs();\n",
        "journey challenge seed",
    )

    text = replace_once(
        text,
        "    _guideLoading = false;\n"
        "    _writingLoading = false;\n"
        "    if (mounted) setState(() => step = 0);\n",
        "    _guideLoading = false;\n"
        "    _writingLoading = false;\n"
        "    if (mounted) {\n"
        "      setState(() {\n"
        "        _challengeResolved = false;\n"
        "        _challengeReward = null;\n"
        "        _challengeSeed += 1;\n"
        "        step = 0;\n"
        "      });\n"
        "    }\n",
        "journey replay challenge rotation",
    )

    challenge_method = r'''  Widget _challengePage() {
    final state = context.watch<AppState>();
    return _page(
      title: '挑战',
      buttonText: _challengeResolved ? '继续留下回忆' : '完成挑战后继续',
      buttonIcon: _challengeResolved
          ? Icons.arrow_forward_rounded
          : Icons.lock_outline_rounded,
      primaryEnabled: _challengeResolved,
      child: JourneyChallengePanel(
        key: ValueKey('journey-challenge-${_experience.id}-$_challengeSeed'),
        journeyId: _experience.id,
        storyParagraphs: _levelContent.storyParagraphs,
        discoveryTexts: _levelContent.discoveries
            .map((item) => item.text)
            .toList(growable: false),
        profile: _languageProfile,
        seed: _challengeSeed,
        displayText: state.displayText,
        initialReward: _challengeReward,
        onResolved: (reward, awardId) async {
          await state.awardChallengeRewardOnce(
            reward: reward,
            awardId: awardId,
          );
          if (!mounted) return;
          setState(() {
            _challengeResolved = true;
            _challengeReward = reward;
          });
        },
      ),
    );
  }
'''

    text = regex_once(
        text,
        r"  Widget _challengePage\(\) \{.*?\n  \}\n\n(?=  // Kept temporarily for stored-draft compatibility, but no longer part of\n  // the explorer-facing journey flow\.\n  // ignore: unused_element\n  Widget _expressPage\(\))",
        challenge_method + "\n",
        "replace legacy challenge page",
    )

    path.write_text(text, encoding="utf-8")


def patch_passport() -> None:
    path = ROOT / "app/lib/screens/city_passport_screen.dart"
    text = path.read_text(encoding="utf-8")

    if "../widgets/special_journey_passport.dart" not in text:
        text = replace_once(
            text,
            "import '../widgets/journey_share_button.dart';\n",
            "import '../widgets/journey_share_button.dart';\n"
            "import '../widgets/special_journey_passport.dart';\n",
            "special journey import",
        )

    text = replace_once(
        text,
        "          _SpecialJourneyPassport(state: state),\n",
        "          SpecialJourneyPassport(state: state),\n",
        "special journey widget call",
    )

    text = regex_once(
        text,
        r"\nclass _SpecialJourneyPassport extends StatelessWidget \{.*?\n\}\n\n(?=class _PassportHeader extends StatelessWidget)",
        "\n",
        "remove old special journey placeholder",
    )

    path.write_text(text, encoding="utf-8")


def patch_app_state() -> None:
    path = ROOT / "app/lib/state/app_state.dart"
    text = path.read_text(encoding="utf-8")

    if "enum SpecialJourneyUnlockStatus" not in text:
        text = replace_once(
            text,
            "enum AppLoadStatus { loading, ready, error }\n\n",
            "enum AppLoadStatus { loading, ready, error }\n\n"
            "enum SpecialJourneyUnlockStatus {\n"
            "  unlocked,\n"
            "  alreadyUnlocked,\n"
            "  insufficientFunds,\n"
            "  busy,\n"
            "}\n\n"
            "class SpecialJourneyUnlockResult {\n"
            "  const SpecialJourneyUnlockResult({\n"
            "    required this.status,\n"
            "    required this.currency,\n"
            "    required this.cost,\n"
            "    required this.balance,\n"
            "  });\n\n"
            "  final SpecialJourneyUnlockStatus status;\n"
            "  final String currency;\n"
            "  final int cost;\n"
            "  final int balance;\n\n"
            "  int get missing => math.max(0, cost - balance).toInt();\n"
            "}\n\n",
            "special journey result types",
        )

    text = replace_once(
        text,
        "  int goldCoins = 0;\n"
        "  int silverCoins = 0;\n"
        "  int bronzeCoins = 0;\n"
        "  int silverFragments = 0;\n",
        "  int goldCoins = 0;\n"
        "  int silverCoins = 0;\n"
        "  int bronzeCoins = 0;\n"
        "  int silverFragments = 0;\n"
        "  final Set<String> awardedChallengeIds = <String>{};\n"
        "  final Set<String> unlockedSpecialJourneyIds = <String>{};\n"
        "  final Set<String> _specialJourneyUnlocksInFlight = <String>{};\n",
        "wallet persistent sets",
    )

    text = replace_once(
        text,
        "      goldCoins = prefs.getInt('wallet.gold') ?? 0;\n"
        "      silverCoins = prefs.getInt('wallet.silver') ?? 0;\n"
        "      bronzeCoins = prefs.getInt('wallet.bronze') ?? 0;\n"
        "      silverFragments = prefs.getInt('wallet.fragment') ?? 0;\n",
        "      goldCoins = prefs.getInt('wallet.gold') ?? 0;\n"
        "      silverCoins = prefs.getInt('wallet.silver') ?? 0;\n"
        "      bronzeCoins = prefs.getInt('wallet.bronze') ?? 0;\n"
        "      silverFragments = prefs.getInt('wallet.fragment') ?? 0;\n"
        "      awardedChallengeIds\n"
        "        ..clear()\n"
        "        ..addAll(prefs.getStringList('challenge.awardedIds') ?? <String>[]);\n"
        "      unlockedSpecialJourneyIds\n"
        "        ..clear()\n"
        "        ..addAll(\n"
        "          prefs.getStringList('specialJourney.unlockedIds') ?? <String>[],\n"
        "        );\n",
        "load wallet persistent sets",
    )

    replacement = r'''  bool isSpecialJourneyUnlocked(String journeyId) {
    return unlockedSpecialJourneyIds.contains(journeyId);
  }

  int walletBalance(String currency) {
    return switch (currency) {
      '金币' => goldCoins,
      '银币' => silverCoins,
      '铜币' => bronzeCoins,
      _ => silverFragments,
    };
  }

  Future<bool> awardChallengeRewardOnce({
    required String reward,
    required String awardId,
  }) async {
    if (!awardedChallengeIds.add(awardId)) return false;
    _addCurrency(reward, 1);
    notifyListeners();
    await _persistWallet();
    return true;
  }

  Future<void> awardChallengeReward(String reward) async {
    await awardChallengeRewardOnce(
      reward: reward,
      awardId:
          'legacy:${_clock().microsecondsSinceEpoch}:${awardedChallengeIds.length}',
    );
  }

  Future<SpecialJourneyUnlockResult> unlockSpecialJourney({
    required String journeyId,
    required String currency,
    required int cost,
  }) async {
    final initialBalance = walletBalance(currency);
    if (isSpecialJourneyUnlocked(journeyId)) {
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.alreadyUnlocked,
        currency: currency,
        cost: cost,
        balance: initialBalance,
      );
    }
    if (!_specialJourneyUnlocksInFlight.add(journeyId)) {
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.busy,
        currency: currency,
        cost: cost,
        balance: initialBalance,
      );
    }

    try {
      if (isSpecialJourneyUnlocked(journeyId)) {
        return SpecialJourneyUnlockResult(
          status: SpecialJourneyUnlockStatus.alreadyUnlocked,
          currency: currency,
          cost: cost,
          balance: walletBalance(currency),
        );
      }
      final currentBalance = walletBalance(currency);
      if (cost < 0 || currentBalance < cost) {
        return SpecialJourneyUnlockResult(
          status: SpecialJourneyUnlockStatus.insufficientFunds,
          currency: currency,
          cost: cost,
          balance: currentBalance,
        );
      }

      _addCurrency(currency, -cost);
      unlockedSpecialJourneyIds.add(journeyId);
      notifyListeners();
      await _persistWallet();
      return SpecialJourneyUnlockResult(
        status: SpecialJourneyUnlockStatus.unlocked,
        currency: currency,
        cost: cost,
        balance: walletBalance(currency),
      );
    } finally {
      _specialJourneyUnlocksInFlight.remove(journeyId);
    }
  }

  void _addCurrency(String currency, int amount) {
    if (currency == '金币') {
      goldCoins = math.max(0, goldCoins + amount).toInt();
    } else if (currency == '银币') {
      silverCoins = math.max(0, silverCoins + amount).toInt();
    } else if (currency == '铜币') {
      bronzeCoins = math.max(0, bronzeCoins + amount).toInt();
    } else {
      silverFragments = math.max(0, silverFragments + amount).toInt();
    }
  }

  Future<void> _persistWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final awarded = awardedChallengeIds.toList()..sort();
    final unlocked = unlockedSpecialJourneyIds.toList()..sort();
    await Future.wait([
      prefs.setInt('wallet.gold', goldCoins),
      prefs.setInt('wallet.silver', silverCoins),
      prefs.setInt('wallet.bronze', bronzeCoins),
      prefs.setInt('wallet.fragment', silverFragments),
      prefs.setStringList('challenge.awardedIds', awarded),
      prefs.setStringList('specialJourney.unlockedIds', unlocked),
    ]);
  }

'''

    text = regex_once(
        text,
        r"  Future<void> awardChallengeReward\(String reward\) async \{.*?\n  \}\n\n(?=  Future<void> toggleSavedWord)",
        replacement,
        "replace challenge wallet methods",
    )

    path.write_text(text, encoding="utf-8")


def main() -> None:
    patch_journey_screen()
    patch_passport()
    patch_app_state()
    print("PR118 challenge integration patch applied")


if __name__ == "__main__":
    main()
