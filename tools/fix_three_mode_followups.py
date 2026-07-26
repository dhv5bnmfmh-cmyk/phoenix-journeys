from __future__ import annotations

import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


def main() -> None:
    challenge_path = ROOT / 'app/lib/widgets/journey_challenge_panel.dart'
    challenge = challenge_path.read_text(encoding='utf-8')
    challenge = replace_once(
        challenge,
        "import 'package:flutter/foundation.dart';\n",
        '',
        'remove unnecessary foundation import',
    )
    challenge_path.write_text(challenge, encoding='utf-8')

    passport_path = ROOT / 'app/lib/widgets/special_journey_passport.dart'
    passport = passport_path.read_text(encoding='utf-8')
    old_switch = """    switch (result.status) {
      case SpecialJourneyUnlockStatus.unlocked:
      case SpecialJourneyUnlockStatus.alreadyUnlocked:
        await _openFullJourney(context, journey.id);
      case SpecialJourneyUnlockStatus.insufficientFunds:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.displayText(
                '${journey.currency}不足，还需要 ${result.missing} 枚。',
              ),
            ),
          ),
        );
      case SpecialJourneyUnlockStatus.busy:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.displayText('正在处理，请稍候再试。'))),
        );
    }
"""
    new_switch = """    switch (result.status) {
      case SpecialJourneyUnlockStatus.unlocked:
      case SpecialJourneyUnlockStatus.alreadyUnlocked:
        await _openFullJourney(context, journey.id);
        return;
      case SpecialJourneyUnlockStatus.insufficientFunds:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.displayText(
                '${journey.currency}不足，还需要 ${result.missing} 枚。',
              ),
            ),
          ),
        );
        return;
      case SpecialJourneyUnlockStatus.busy:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.displayText('正在处理，请稍候再试。'))),
        );
        return;
    }
"""
    passport = replace_once(
        passport,
        old_switch,
        new_switch,
        'stop special journey unlock switch fallthrough',
    )
    passport_path.write_text(passport, encoding='utf-8')

    print('three-mode follow-up fixes applied')


if __name__ == '__main__':
    main()
