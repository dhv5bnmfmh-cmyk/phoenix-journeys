const dedicatedAdaptiveJourneyIds = <String>{
  'beijing-summer-palace',
  'beijing-forbidden-city',
  'shanghai-bund',
  'xian-city-wall',
  'hangzhou-west-lake',
  'chengdu-kuanzhai-alley',
};

bool usesDedicatedAdaptiveJourneyRuntime(String journeyId) =>
    dedicatedAdaptiveJourneyIds.contains(journeyId);

bool usesSharedGenericAdaptivePipeline(String journeyId) =>
    !usesDedicatedAdaptiveJourneyRuntime(journeyId);
