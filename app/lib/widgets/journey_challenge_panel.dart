import 'package:flutter/material.dart';

import '../data/forbidden_city_journey_runtime.dart';
import '../models/language_proficiency.dart';
import 'forbidden_city_reference_challenge_panel.dart';
import 'journey_challenge_panel_legacy.dart' as legacy;

export 'journey_challenge_panel_legacy.dart' hide JourneyChallengePanel;

class JourneyChallengePanel extends StatelessWidget {
  const JourneyChallengePanel({
    super.key,
    required this.journeyId,
    required this.storyParagraphs,
    required this.discoveryTexts,
    required this.profile,
    required this.seed,
    required this.displayText,
    required this.onResolved,
    required this.onAllCompleted,
    this.autoNarrate = true,
  });

  final String journeyId;
  final List<String> storyParagraphs;
  final List<String> discoveryTexts;
  final ChineseProficiencyProfile? profile;
  final int seed;
  final String Function(String) displayText;
  final legacy.JourneyChallengeResolved onResolved;
  final legacy.JourneyChallengeCompleted onAllCompleted;
  final bool autoNarrate;

  @override
  Widget build(BuildContext context) {
    if (journeyId == forbiddenCityJourneyId) {
      return ForbiddenCityReferenceChallengePanel(
        journeyId: journeyId,
        storyParagraphs: storyParagraphs,
        discoveryTexts: discoveryTexts,
        profile: profile,
        seed: seed,
        displayText: displayText,
        onResolved: onResolved,
        onAllCompleted: onAllCompleted,
      );
    }
    return legacy.JourneyChallengePanel(
      journeyId: journeyId,
      storyParagraphs: storyParagraphs,
      discoveryTexts: discoveryTexts,
      profile: profile,
      seed: seed,
      displayText: displayText,
      onResolved: onResolved,
      onAllCompleted: onAllCompleted,
      autoNarrate: autoNarrate,
    );
  }
}
