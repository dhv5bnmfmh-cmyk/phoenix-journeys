import '../models/journey_challenge.dart';
import '../data/journey_story_identity.dart';
import 'forbidden_city_challenge_level_standard.dart';
import 'forbidden_city_story_two_challenge.dart';

typedef AuthoredJourneyChallengeBuilder = StoryChallengeSet Function({
  required int level,
  required List<String> storyParagraphs,
});

final Map<String, AuthoredJourneyChallengeBuilder>
    authoredJourneyChallengeBuilders =
    <String, AuthoredJourneyChallengeBuilder>{
  forbiddenCityGoldenJourneyId: ({required level, required storyParagraphs}) =>
      buildForbiddenCityGoldenChallenge(
        level: level,
        storyParagraphs: storyParagraphs,
      ),
  forbiddenCityStoryTwoJourneyId: ({required level, required storyParagraphs}) =>
      buildForbiddenCityStoryTwoChallenge(
        level: level,
        storyParagraphs: storyParagraphs,
      ),
};

Set<String> get authoredChallengeJourneyIds =>
    Set<String>.unmodifiable(authoredJourneyChallengeBuilders.keys);

StoryChallengeSet? buildRegisteredAuthoredChallenge({
  required String journeyId,
  required int sessionLevel,
  required List<String> storyParagraphs,
}) {
  final builder = authoredJourneyChallengeBuilders[journeyId];
  return builder?.call(
    level: sessionLevel,
    storyParagraphs: storyParagraphs,
  );
}
