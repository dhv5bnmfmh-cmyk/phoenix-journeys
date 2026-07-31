import 'package:flutter/material.dart';

import 'screens/coin_journey_screen.dart';
import 'screens/five_more_journeys_screen.dart';
import 'screens/journey_expedition_screen.dart';
import 'screens/shadowing_home_screen.dart';
import 'theme/phoenix_theme.dart';
import 'widgets/startup_gate.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final prototype = uri.queryParameters['prototype'];
    final isPreviewHost = uri.host.startsWith('phoenix-journeys-pr-');
    final showShadowingHome = prototype == 'shadowing';
    final showFiveJourneys = prototype == 'journeys';
    final showFiveMoreJourneys = prototype == 'journeys2';
    final showCoinJourney =
        prototype == 'coin-journey' ||
        (isPreviewHost &&
            prototype == null &&
            !showShadowingHome &&
            !showFiveJourneys &&
            !showFiveMoreJourneys);

    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.light,
      home: showShadowingHome
          ? const ShadowingHomeScreen()
          : showFiveJourneys
          ? const JourneyExpeditionScreen()
          : showFiveMoreJourneys
          ? const FiveMoreJourneysScreen()
          : showCoinJourney
          ? const CoinJourneyPrototypeScreen()
          : const StartupGate(),
    );
  }
}
