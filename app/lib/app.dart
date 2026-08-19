import 'package:flutter/material.dart';

import 'screens/coin_journey_screen.dart';
import 'theme/phoenix_theme.dart';
import 'widgets/startup_gate.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final prototype = uri.queryParameters['prototype'];
    final isPreviewHost = uri.host.startsWith('phoenix-journeys-pr-');
    final showCoinJourney =
        prototype == 'coin-journey' || (isPreviewHost && prototype == null);

    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: PhoenixTheme.light,
      home: showCoinJourney
          ? const CoinJourneyPrototypeScreen()
          : const StartupGate(),
    );
  }
}
