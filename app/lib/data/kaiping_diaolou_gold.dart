export 'kaiping_diaolou_gold_content.dart'
    hide
        kaipingDiaolouGeoNodeId,
        kaipingDiaolouSources,
        kaipingDiaolouJourney,
        kaipingDiaolouExperience;
export 'kaiping_diaolou_registration.dart' show kaipingActiveGeoDisplayName;

import 'kaiping_diaolou_registration.dart' as registration;

const kaipingDiaolouGeoNodeId = registration.kaipingActiveGeoNodeId;
const kaipingDiaolouSources = registration.kaipingActiveSources;
final kaipingDiaolouJourney = registration.kaipingActiveJourney;
final kaipingDiaolouExperience = registration.kaipingActiveExperience;
