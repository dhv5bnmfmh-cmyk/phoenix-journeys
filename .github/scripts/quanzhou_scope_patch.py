from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one target, found {count}')
    p.write_text(text.replace(old, new, 1))


replace_once(
    'app/lib/data/quanzhou_kaiyuan_gold_content.dart',
    "  [0, 4, 7],\n];",
    "  [2, 4, 7],\n];",
)

replace_once(
    'app/lib/data/daily_journey_catalog.dart',
    "import 'journey_expansion_batch_five.dart';\nimport 'summer_palace_journey.dart';",
    "import 'journey_expansion_batch_five.dart';\nimport 'quanzhou_kaiyuan_gold_content.dart';\nimport 'summer_palace_journey.dart';",
)
replace_once(
    'app/lib/data/daily_journey_catalog.dart',
    "  ...journeyExpansionSources,\n  ...journeyExpansionBatchTwoSources,",
    "  ...journeyExpansionSources,\n  ...quanzhouKaiyuanSources.where(\n    (source) => !journeyExpansionSources.any((existing) => existing.id == source.id),\n  ),\n  ...journeyExpansionBatchTwoSources,",
)
replace_once(
    'app/lib/data/daily_journey_catalog.dart',
    "  ...journeyExpansionRecords,\n  ...journeyExpansionBatchTwoRecords,",
    "  ...journeyExpansionRecords.where(\n    (journey) => journey.id != quanzhouKaiyuanJourneyId,\n  ),\n  quanzhouKaiyuanJourney,\n  ...journeyExpansionBatchTwoRecords,",
)
replace_once(
    'app/lib/data/daily_journey_catalog.dart',
    "  ...extendedJourneyExperiences,\n  ...journeyExpansionExperiences,\n  ...journeyExpansionBatchTwoExperiences,",
    "  ...extendedJourneyExperiences,\n  ...journeyExpansionExperiences.where(\n    (journey) => journey.id != quanzhouKaiyuanJourneyId,\n  ),\n  quanzhouKaiyuanExperience,\n  ...journeyExpansionBatchTwoExperiences,",
)

sem = 'app/lib/data/journey_semantic_fingerprint_catalog.dart'
replace_once(
    sem,
    "import 'luoyang_longmen_one_pass.dart';\nimport 'summer_palace_adaptive_story_levels.dart';",
    "import 'luoyang_longmen_one_pass.dart';\nimport 'quanzhou_kaiyuan_gold_content.dart';\nimport 'summer_palace_adaptive_story_levels.dart';",
)
replace_once(
    sem,
    "  transnationalLetterExchangeReallocatesFamilyBuildingDuty,\n}",
    """  transnationalLetterExchangeReallocatesFamilyBuildingDuty,

  // Reusable families introduced by an enacted ordination threshold and sibling-home renegotiation.
  ordinationDayMakesDeferredChangeImmediate,
  adultVocationChangerSeekingUnchangedFallback,
  adultSiblingsSeparateKinshipFromFrozenHousehold,
  enterNewVocationWithoutOutsourcingHouseholdStasis,
  enduringKinshipVsDemandForUnchangedHomeAccess,
  relinquishAutomaticHouseholdAccess,
  keyTransferredBeforeRitualThreshold,
  householdCanChangeWhileFutureWelcomeRequiresKnock,
  fallbackEntitlementToRequestedBelonging,
  emptyWaistAndRetainedKeyWithoutReturn,
  ordinationPlatformMakesIdentityChangeEnacted,
  householdKeyEmbodiesRelinquishedFallback,
  domesticDoorToOrdinationThreshold,
  ordinationCeremonyMakesTodayNonDeferrable,
  sisterRefusesFrozenWaitingWithoutBlockingVocation,
  ritualThresholdEndsOutsourcedHouseholdStasis,
}""",
)
replace_once(
    sem,
    "const _kaiping = kaipingDiaolouJourneyId;",
    "const _kaiping = kaipingDiaolouJourneyId;\nconst _quanzhou = quanzhouKaiyuanJourneyId;",
)

fingerprint = r'''

final quanzhouKaiyuanGoldSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _quanzhou,
  surfaceIdentity: 'Xu An / Xu Ning / Kaiyuan ordination threshold / returned household key / knock-before-opening',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism: NarrativeMechanismFamily.ordinationDayMakesDeferredChangeImmediate,
    NarrativeSemanticDimension.protagonistRolePattern: NarrativeMechanismFamily.adultVocationChangerSeekingUnchangedFallback,
    NarrativeSemanticDimension.relationshipGeometry: NarrativeMechanismFamily.adultSiblingsSeparateKinshipFromFrozenHousehold,
    NarrativeSemanticDimension.goalMechanism: NarrativeMechanismFamily.enterNewVocationWithoutOutsourcingHouseholdStasis,
    NarrativeSemanticDimension.conflictMechanism: NarrativeMechanismFamily.enduringKinshipVsDemandForUnchangedHomeAccess,
    NarrativeSemanticDimension.choiceMechanism: NarrativeMechanismFamily.relinquishAutomaticHouseholdAccess,
    NarrativeSemanticDimension.climaxMechanism: NarrativeMechanismFamily.keyTransferredBeforeRitualThreshold,
    NarrativeSemanticDimension.consequenceMechanism: NarrativeMechanismFamily.householdCanChangeWhileFutureWelcomeRequiresKnock,
    NarrativeSemanticDimension.transformationMechanism: NarrativeMechanismFamily.fallbackEntitlementToRequestedBelonging,
    NarrativeSemanticDimension.endingMechanism: NarrativeMechanismFamily.emptyWaistAndRetainedKeyWithoutReturn,
    NarrativeSemanticDimension.culturalAnchorFunction: NarrativeMechanismFamily.ordinationPlatformMakesIdentityChangeEnacted,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction: NarrativeMechanismFamily.householdKeyEmbodiesRelinquishedFallback,
    NarrativeSemanticDimension.movementSpatialMechanism: NarrativeMechanismFamily.domesticDoorToOrdinationThreshold,
    NarrativeSemanticDimension.temporalPressureMechanism: NarrativeMechanismFamily.ordinationCeremonyMakesTodayNonDeferrable,
    NarrativeSemanticDimension.supportingCharacterFunction: NarrativeMechanismFamily.sisterRefusesFrozenWaitingWithoutBlockingVocation,
    NarrativeSemanticDimension.dramaticEngineFamily: NarrativeMechanismFamily.ritualThresholdEndsOutsourcedHouseholdStasis,
  }),
  coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.openingMechanism, NarrativeMechanismFamily.ordinationDayMakesDeferredChangeImmediate, ['民国初年，泉州开元寺仍有开坛传戒的仪式。'], 'A verified ordination day makes the life change immediate instead of a deferred intention.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.relationshipGeometry, NarrativeMechanismFamily.adultSiblingsSeparateKinshipFromFrozenHousehold, ['许宁说，她不会不认这个弟弟，但不能永远替他守着一间空房。'], 'The sister explicitly separates enduring kinship from an obligation to freeze household space.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.conflictMechanism, NarrativeMechanismFamily.enduringKinshipVsDemandForUnchangedHomeAccess, ['你要我认你这个弟弟，还是要我替你把以前的日子也一起锁住？'], 'The human conflict is continued sibling belonging versus demanding that another household remain unchanged.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.choiceMechanism, NarrativeMechanismFamily.relinquishAutomaticHouseholdAccess, ['房间别替我留了。我以后回来，先敲门。'], 'Xu An enacts the choice by ending the requirement for a preserved room and automatic entry.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.climaxMechanism, NarrativeMechanismFamily.keyTransferredBeforeRitualThreshold, ['把钥匙放进姐姐手里'], 'The relinquishment becomes irreversible as a physical transfer before he proceeds toward ordination.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.consequenceMechanism, NarrativeMechanismFamily.householdCanChangeWhileFutureWelcomeRequiresKnock, ['你敲，我就开。'], 'The sister preserves welcome while changing the future access rule; belonging remains without restoring the frozen room.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.transformationMechanism, NarrativeMechanismFamily.fallbackEntitlementToRequestedBelonging, ['没有再问那间房会给谁，也没有要求姐姐保证下一次回来时桌椅、床铺仍在原处。'], 'His future behavior stops demanding material proof that the household must remain unchanged for him.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.endingMechanism, NarrativeMechanismFamily.emptyWaistAndRetainedKeyWithoutReturn, ['手在腰边摸了一下，只摸到空处。许宁站在原地，掌心里的钥匙没有再递回去。'], 'The ending keeps the cost tactile and unreversed rather than explaining a moral.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.culturalAnchorFunction, NarrativeMechanismFamily.ordinationPlatformMakesIdentityChangeEnacted, ['受戒的仪式没有替他解决姐弟之间的问题，却把“以后再说”压成了今天必须完成的动作。'], 'The verified ritual threshold causes action without being used as a moral lesson or touristic backdrop.'),
    _activeEvidence(_quanzhou, NarrativeSemanticDimension.dramaticEngineFamily, NarrativeMechanismFamily.ritualThresholdEndsOutsourcedHouseholdStasis, ['受戒的仪式没有替他解决姐弟之间的问题，却把“以后再说”压成了今天必须完成的动作。', '把钥匙放进姐姐手里'], 'An enacted religious threshold forces a sibling to stop outsourcing the cost of keeping his former household life unchanged.'),
  ]),
);
'''
replace_once(
    sem,
    "\nfinal _summerPalaceBaselineFingerprint =",
    fingerprint + "\nfinal _summerPalaceBaselineFingerprint =",
)
replace_once(
    sem,
    "  _kaiping: kaipingGoldCandidateSemanticFingerprint,\n});",
    "  _kaiping: kaipingGoldCandidateSemanticFingerprint,\n  _quanzhou: quanzhouKaiyuanGoldSemanticFingerprint,\n});",
)
replace_once(
    sem,
    "  if (journeyId == _kaiping) {\n    return List<String>.generate(10, (index) => kaipingDiaolouGoldLevelContent(index + 1).storyParagraphs.join('\\n')).join('\\n');\n  }\n  return baseline.activeCanonicalGoldStoryText(journeyId);",
    "  if (journeyId == _kaiping) {\n    return List<String>.generate(10, (index) => kaipingDiaolouGoldLevelContent(index + 1).storyParagraphs.join('\\n')).join('\\n');\n  }\n  if (journeyId == _quanzhou) {\n    return List<String>.generate(10, (index) => quanzhouKaiyuanGoldLevelContent(index + 1).storyParagraphs.join('\\n')).join('\\n');\n  }\n  return baseline.activeCanonicalGoldStoryText(journeyId);",
)

dna = 'app/lib/data/journey_narrative_dna_catalog.dart'
dna_record = r'''

const quanzhouKaiyuanGoldNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'quanzhou-kaiyuan-temple',
  narrativeIdentity: 'ordination-threshold-forces-relinquishment-of-unchanged-household-fallback',
  protagonistIdentity: 'Xu-An-fictional-early-Republican-adult-entering-monastic-ordination',
  protagonistAgeIdentity: 'fictional-adult-younger-brother',
  protagonistArchetype: 'adult-changing-vocation-while-clinging-to-automatic-home-fallback',
  openingSituation: 'ordination-day-at-Kaiyuan-makes-deferred-household-question-immediate',
  storyGoal: 'proceed-with-ordination-without-requiring-sister-to-freeze-his-former-home-life',
  locationMechanism: 'verified-Kaiyuan-ordination-platform-and-Republican-ordination-practice-make-vocation-change-enacted-here',
  movementPattern: 'household-key-in-brothers-hand-to-sisters-hand-to-ordination-platform',
  conflictType: 'continuing-sibling-belonging-vs-demand-for-unchanged-household-access',
  choiceType: 'hand-over-key-and-stop-requiring-empty-room-to-be-kept-unchanged',
  climaxType: 'key-transferred-to-sister-before-walking-toward-ordination',
  consequenceType: 'sister-may-reconfigure-home-and-future-return-requires-a-knock',
  emotionalArc: 'certainty-with-hidden-fallback-to-defensiveness-to-recognition-of-sisters-cost-to-relinquishment-to-restrained-belonging',
  historicalLearningMechanism: 'verified-ordination-practice-causes-Story-threshold-while-Song-Yuan-maritime-and-material-history-remain-in-Discovery',
  resolutionType: 'kinship-continues-without-automatic-unchanged-access',
  endingMechanism: 'Xu-An-touches-empty-key-place-while-sister-keeps-key',
  memoryAnchorType: 'empty-key-place-and-key-kept-in-sisters-palm',
  achievementType: 'requested-belonging-after-life-change',
  rewardSymbolism: 'knock-before-opening-marks-continued-kinship-without-frozen-home',
  temporalPattern: 'single-Republican-ordination-day',
  supportingStructure: 'adult-sister-refuses-frozen-waiting-without-blocking-brothers-vocation',
  centralMetaphor: 'belonging-can-remain-while-the-door-no-longer-opens-automatically',
  narrativeVoice: 'third-person-close-to-Xu-An-with-restrained-sibling-action',
  storyRhythm: 'ordination-arrival-fallback-request-sister-boundary-key-transfer-cost-sister-welcome-walk-empty-waist',
);
'''
replace_once(
    dna,
    "\nfinal approvedNarrativeDnaCatalog =",
    dna_record + "\nfinal approvedNarrativeDnaCatalog =",
)
replace_once(
    dna,
    "  kaipingGoldNarrativeDna,\n]);",
    "  kaipingGoldNarrativeDna,\n  quanzhouKaiyuanGoldNarrativeDna,\n]);",
)

replace_once(
    'app/test/journey_semantic_anti_template_gate_test.dart',
    "  'jiangmen-kaiping-diaolou',\n};",
    "  'jiangmen-kaiping-diaolou',\n  'quanzhou-kaiyuan-temple',\n};",
)

audit = 'docs/PHOENIX_GOLD_SEMANTIC_AUDIT.md'
replace_once(audit, '**Catalog scope:** eleven approved Gold Journeys', '**Catalog scope:** twelve approved Gold Journeys')
replace_once(audit, '**Pair count:** 55 unique pairs', '**Pair count:** 66 unique pairs')
replace_once(
    audit,
    'current catalog to eleven Gold Stories and 55 comparisons. The executable catalog\nand pair audit are authoritative for the current result.',
    'current catalog to eleven Gold Stories and 55 comparisons. Founder-authorized Quanzhou\nGold remediation now extends the registry to twelve Gold Stories and 66 comparisons.\nThe executable catalog and pair audit are authoritative for the current result.',
)
