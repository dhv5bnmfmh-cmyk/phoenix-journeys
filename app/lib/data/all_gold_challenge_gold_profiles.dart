import 'all_gold_challenge_gold_profiles_base.dart' as base;

export 'all_gold_challenge_gold_profiles_base.dart'
    hide nonDatongGoldChallengeProfileFor, nonDatongGoldChallengeProfiles;

const _lijiangOldTownJourneyId = 'lijiang-old-town';

const _lijiangLv10SharedBurdenRepair = base.GoldChallengeGrammarSpec(
  targetId: 'lv10-concession-shared-burden',
  prefix: '火被控制后，姐弟',
  brokenSegment: '虽然还背着共同的债，所以一起扛起了',
  suffix: '湿茶。',
  correctReplacement: '虽然还背着共同的债，却一起扛起了',
  distractors: <String>[
    '虽然还背着共同的债，所以一起扛起了',
    '因为还背着共同的债，却一起扛起了',
    '虽然还背着共同的债，因此一起扛起了',
  ],
  errorType: '虽然…却…：未解决成本与共同承担',
  whyWrong: '共同的债仍然存在，不是两人一起扛起湿茶的直接原因；这里强调成本没有消失，关系动作却已经改变。',
  revisionRule: '承认A仍存在、B却出现反预期变化时，用“虽然A，却B”。',
  memoryTip: '债没有消失，动作却从争谁做主变成一起承担。',
  misconception: '把未解决的成本误写成关系变化的直接原因',
);

base.GoldChallengeProfile _repairLijiangProfile(
  base.GoldChallengeProfile profile,
) {
  final grammar = <base.GoldChallengeGrammarSpec>[
    ...profile.grammar.take(9),
    _lijiangLv10SharedBurdenRepair,
  ];
  return base.GoldChallengeProfile(
    journeyId: profile.journeyId,
    paragraphPrompt: profile.paragraphPrompt,
    missingPrompt: profile.missingPrompt,
    paragraphAnchors: profile.paragraphAnchors,
    missingAnchors: profile.missingAnchors,
    paragraphGoals: profile.paragraphGoals,
    missingGoals: profile.missingGoals,
    paragraphIntents: profile.paragraphIntents,
    missingIntents: profile.missingIntents,
    grammar: List<base.GoldChallengeGrammarSpec>.unmodifiable(grammar),
    storyDistractors: profile.storyDistractors,
  );
}

final Map<String, base.GoldChallengeProfile> nonDatongGoldChallengeProfiles =
    Map<String, base.GoldChallengeProfile>.unmodifiable(
  <String, base.GoldChallengeProfile>{
    for (final entry in base.nonDatongGoldChallengeProfiles.entries)
      entry.key: entry.key == _lijiangOldTownJourneyId
          ? _repairLijiangProfile(entry.value)
          : entry.value,
  },
);

base.GoldChallengeProfile? nonDatongGoldChallengeProfileFor(String journeyId) =>
    nonDatongGoldChallengeProfiles[journeyId];
