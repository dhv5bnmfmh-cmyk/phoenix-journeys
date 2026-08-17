from pathlib import Path
import re

batch = Path('app/lib/data/journey_expansion_batch_four.dart')
text = batch.read_text()
text = text.replace(
    "import 'journey_data.dart';\n",
    "import 'journey_data.dart';\nimport 'honghe_hani_rice_terraces_gold_content.dart';\n",
    1,
)
text, count = re.subn(
    r"\nconst _hongheP = <String>\[.*?\n\];\n\nfinal pingyaoJourney",
    "\n\nfinal pingyaoJourney",
    text,
    count=1,
    flags=re.S,
)
if count != 1:
    raise SystemExit(f'expected one inactive Honghe seed block, got {count}')
old_record = "final hongheJourney = _record('honghe-hani-rice-terraces','红河 · 哈尼梯田：让森林的水流进稻田','cn-yunnan-honghe-yuanyang-hani-terraces',_hongheP,const ['unesco-honghe','yunnan-honghe'],const ['红河','元阳','哈尼梯田','农耕','世界遗产']);"
new_record = "final hongheJourney = _record('honghe-hani-rice-terraces',hongheHaniRiceTerracesCanonicalTitle,'cn-yunnan-honghe-yuanyang-hani-terraces',hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs,const ['unesco-honghe','yunnan-honghe'],const ['红河','元阳','哈尼梯田','赶沟人','木刻分水','世界遗产']);"
if old_record not in text:
    raise SystemExit('Honghe active record binding not found')
text = text.replace(old_record, new_record, 1)
old_exp = "DailyJourneyExperience(id:hongheJourney.id,city:'红河',cityCode:'HHE',place:'哈尼梯田',appBarTitle:'红河 · 哈尼梯田',storyTitle:'山地农耕故事',headline:'让森林的水流进稻田',description:'理解森林、村寨、梯田与水系如何组成活态农耕生态。',discoveryTeaser:'山顶森林为什么决定山下梯田的收成？',distanceLabel:'680 km',stampSymbol:'田',content:hongheJourney,storyAnnotations:_hongheA,words:_hongheW,discoveries:_hongheD,wonderQuestion:'如果只能保护森林、沟渠、村寨或梯田中的一项，你会怎样解释它们不能分开？',expressQuestion:'请用两到三句话描写日出、云海与层层水田的颜色变化。'),"
new_exp = "DailyJourneyExperience(id:hongheJourney.id,city:'红河',cityCode:'HHE',place:'哈尼梯田',appBarTitle:'红河 · 哈尼梯田',storyTitle:hongheHaniRiceTerracesCanonicalTitle,headline:hongheHaniRiceTerracesHeadline,description:hongheHaniRiceTerracesDescription,discoveryTeaser:hongheHaniRiceTerracesDiscoveryTeaser,distanceLabel:'680 km',stampSymbol:'田',content:hongheJourney,storyAnnotations:hongheHaniRiceTerracesGoldLevelContent(5).storyAnnotations,words:hongheHaniRiceTerracesGoldLevelContent(5).words,discoveries:hongheHaniRiceTerracesGoldLevelContent(5).discoveries,wonderQuestion:hongheHaniRiceTerracesGoldLevelContent(5).wonderQuestion,expressQuestion:hongheHaniRiceTerracesGoldLevelContent(5).expressQuestion),"
if old_exp not in text:
    raise SystemExit('Honghe active DailyJourneyExperience binding not found')
text = text.replace(old_exp, new_exp, 1)
batch.write_text(text)

semantic = Path('app/lib/data/journey_semantic_fingerprint_catalog.dart')
text = semantic.read_text()
needle = "  placeInfrastructureForcesLivelihoodSacrificeUnderHazard,\n}"
replacement = """  placeInfrastructureForcesLivelihoodSacrificeUnderHazard,

  // Reusable families introduced by living communal water-allocation duty.
  springIrrigationDutyBeginsWithPrivateLaborDependency,
  electedWaterKeeperDependentOnReciprocalNeighborLabor,
  neighboringFarmersBoundByPrivateLaborExchange,
  restoreAgreedWaterSharesAndFinishOwnField,
  communalWaterAllocationVsPrivateLaborReciprocity,
  restoreAgreedFlowDespitePrivateLaborLoss,
  carvedDividerResetsBranchFlows,
  downstreamFlowRestoredWhileOwnPloughingIsLost,
  privateReciprocityToAcceptedPublicRoleCost,
  ownFieldWorkContinuesWithoutRelationalRepair,
  carvedWaterDividerEmbodiesCollectiveAgreement,
  alteredGrooveEmbodiesPrivateAdvantage,
  branchingWaterRedistributionDownTerraceSlope,
  sameDaySpringIrrigationAndPloughingWindow,
  friendWithdrawsLaborAfterAllocationRestoration,
  communalWaterRuleForcesPrivateReciprocityCost,
}"""
if needle not in text:
    raise SystemExit('semantic family insertion point not found')
text = text.replace(needle, replacement, 1)
semantic.write_text(text)
