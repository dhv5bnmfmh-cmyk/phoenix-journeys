import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../data/forbidden_city_journey_runtime.dart';
import 'forbidden_city_reference_journey_screen.dart';
import 'journey_screen_legacy.dart' as legacy;

export 'journey_screen_legacy.dart' hide JourneyScreen;

/// Canonical Journey runtime dispatcher.
///
/// Forbidden City Reference Location 001 has exactly one production runtime:
/// [ForbiddenCityReferenceJourneyScreen]. All other journeys continue through
/// the existing shared runtime until they are migrated independently.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key, this.journeyId});

  final String? journeyId;

  @override
  Widget build(BuildContext context) {
    final resolvedId = journeyId ?? dailyJourneyForDate(DateTime.now()).id;
    if (resolvedId == forbiddenCityJourneyId) {
      return const ForbiddenCityReferenceJourneyScreen();
    }
    return legacy.JourneyScreen(journeyId: resolvedId);
  }
}
