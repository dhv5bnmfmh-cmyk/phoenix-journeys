import '../data/daily_journey_catalog.dart';
import '../data/forbidden_city_journey_runtime.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';
import 'journey_content_quality_auditor.dart';

JourneyContentQualityReport auditForbiddenCityLockedQuality(
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  return auditJourneyContentQuality(
    requireDailyJourneyExperience(forbiddenCityJourneyId),
    content,
    profile: profile,
  );
}
