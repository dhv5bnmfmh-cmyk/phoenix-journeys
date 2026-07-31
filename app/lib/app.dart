import 'package:flutter/material.dart';

import 'screens/coin_journey_screen.dart';
import 'screens/five_journeys_screen.dart';
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
    final showCoinJourney =
        prototype == 'coin-journey' ||
        (isPreviewHost && prototype == null && !showShadowingHome);

    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.light,
      home: showShadowingHome
          ? const ShadowingHomeScreen()
          : showFiveJourneys
          ? const FiveJourneysScreen()
          : showCoinJourney
          ? const CoinJourneyPrototypeScreen()
          : const StartupGate(),
    );
  }
}
