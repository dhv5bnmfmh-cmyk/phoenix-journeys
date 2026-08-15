export 'extended_journey_catalog_base.dart'
    hide extendedJourneySources, extendedJourneyRecords, extendedJourneyExperiences;

import 'extended_journey_catalog_base.dart' as base;
import 'kaiping_diaolou_gold.dart';

final extendedJourneySources = [
  ...base.extendedJourneySources,
  ...kaipingDiaolouSources,
];

final extendedJourneyRecords = [
  ...base.extendedJourneyRecords,
  kaipingDiaolouJourney,
];

final extendedJourneyExperiences = [
  ...base.extendedJourneyExperiences,
  kaipingDiaolouExperience,
];
