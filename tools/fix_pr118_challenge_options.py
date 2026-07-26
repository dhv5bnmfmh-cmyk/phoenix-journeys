from __future__ import annotations

import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
PATH = ROOT / 'app/lib/widgets/journey_challenge_panel.dart'


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


def main() -> None:
    text = PATH.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "import 'package:flutter/foundation.dart';\n",
        '',
        'remove unnecessary foundation import',
    )

    grammar_old = """    final options = <_ChallengeOption>[\n      for (var index = 0; index < distractors.length; index++)\n        _ChallengeOption(\n          id: index == 0 ? 'correct' : 'distractor-$index',\n          text: distractors[index],\n          isCorrect: index == 0,\n        ),\n    ];\n    _shuffleOptions(options, seed + 31);\n    return _ChallengeSession(\n      journeyId: journeyId,\n      seed: seed,\n      type: JourneyChallengeType.grammarRepair,\n      difficulty: difficulty,\n      options: options\n          .take(difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6)\n          .toList(),\n"""
    grammar_new = """    final optionCount =\n        difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6;\n    final options = <_ChallengeOption>[\n      for (var index = 0; index < optionCount; index++)\n        _ChallengeOption(\n          id: index == 0 ? 'correct' : 'distractor-$index',\n          text: distractors[index],\n          isCorrect: index == 0,\n        ),\n    ];\n    _shuffleOptions(options, seed + 31);\n    return _ChallengeSession(\n      journeyId: journeyId,\n      seed: seed,\n      type: JourneyChallengeType.grammarRepair,\n      difficulty: difficulty,\n      options: options,\n"""
    text = replace_once(text, grammar_old, grammar_new, 'grammar options')

    missing_old = """    final options = <_ChallengeOption>[\n      for (var index = 0; index < distractors.length; index++)\n        _ChallengeOption(\n          id: index == 0 ? 'correct' : 'distractor-$index',\n          text: distractors[index],\n          isCorrect: index == 0,\n        ),\n    ];\n    _shuffleOptions(options, seed + 47);\n    return _ChallengeSession(\n      journeyId: journeyId,\n      seed: seed,\n      type: JourneyChallengeType.missingSentence,\n      difficulty: difficulty,\n      options: options\n          .take(difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6)\n          .toList(),\n"""
    missing_new = """    final optionCount =\n        difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6;\n    final options = <_ChallengeOption>[\n      for (var index = 0; index < optionCount; index++)\n        _ChallengeOption(\n          id: index == 0 ? 'correct' : 'distractor-$index',\n          text: distractors[index],\n          isCorrect: index == 0,\n        ),\n    ];\n    _shuffleOptions(options, seed + 47);\n    return _ChallengeSession(\n      journeyId: journeyId,\n      seed: seed,\n      type: JourneyChallengeType.missingSentence,\n      difficulty: difficulty,\n      options: options,\n"""
    text = replace_once(text, missing_old, missing_new, 'missing sentence options')

    PATH.write_text(text, encoding='utf-8')
    print('PR118 challenge option safety fixes applied')


if __name__ == '__main__':
    main()
