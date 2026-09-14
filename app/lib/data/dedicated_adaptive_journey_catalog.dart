const dedicatedAdaptiveJourneyIds = <String>{
  'beijing-summer-palace',
  'beijing-forbidden-city',
  'shanghai-bund',
  'xian-city-wall',
  'hangzhou-west-lake',
  'chengdu-kuanzhai-alley',
  'nanjing-qinhuai-river',
  'guangzhou-chen-clan-academy',
  'suzhou-humble-administrators-garden',
  'luoyang-longmen-grottoes',
  'jiangmen-kaiping-diaolou',
  'datong-yungang-grottoes',
  'lijiang-old-town',
  'honghe-hani-rice-terraces',
  'pingyao-ancient-city',
};

/// Journeys whose dedicated Story/Culture packages have adopted the canonical
/// Discovery depth formalized by the current Narrative and Discovery Standard:
/// Lv1-Lv4 = 2 entries, Lv5-Lv10 = 3 entries.
///
/// This set is about active content-shape governance. It is deliberately not an
/// Approved Gold registry and must never be used as a promotion signal.
const canonicalExpandedDiscoveryJourneyIds = <String>{
  'beijing-summer-palace',
  'beijing-forbidden-city',
  'xian-city-wall',
  'suzhou-humble-administrators-garden',
  'luoyang-longmen-grottoes',
  'jiangmen-kaiping-diaolou',
  'datong-yungang-grottoes',
  'lijiang-old-town',
  'honghe-hani-rice-terraces',
  'pingyao-ancient-city',
};

int? canonicalDiscoveryDepthForJourney(String journeyId, int phoenixLevel) =>
    canonicalExpandedDiscoveryJourneyIds.contains(journeyId)
        ? (phoenixLevel <= 4 ? 2 : 3)
        : null;

bool usesDedicatedAdaptiveJourneyRuntime(String journeyId) =>
    dedicatedAdaptiveJourneyIds.contains(journeyId);

bool usesSharedGenericAdaptivePipeline(String journeyId) =>
    !usesDedicatedAdaptiveJourneyRuntime(journeyId);
