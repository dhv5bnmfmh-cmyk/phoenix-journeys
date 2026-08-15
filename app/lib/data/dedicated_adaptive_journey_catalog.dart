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
  'quanzhou-kaiyuan-temple',
};

bool usesDedicatedAdaptiveJourneyRuntime(String journeyId) =>
    dedicatedAdaptiveJourneyIds.contains(journeyId);

bool usesSharedGenericAdaptivePipeline(String journeyId) =>
    !usesDedicatedAdaptiveJourneyRuntime(journeyId);
