import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/coin_journey_screen.dart';
import 'state/app_state.dart';
import 'theme/phoenix_theme.dart';
import 'widgets/phoenix_ambient_overlay.dart';
import 'widgets/phoenix_dynamic_background.dart';
import 'widgets/phoenix_motion_toggle_button.dart';
import 'widgets/startup_gate.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

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
      theme: PhoenixTheme.light,
      builder: (context, child) {
        final state = context.watch<AppState>();
        return PhoenixDynamicBackground(
          journeyId: state.activeJourneyId,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child ?? const SizedBox.shrink(),
              PhoenixAmbientOverlay(journeyId: state.activeJourneyId),
              const Positioned(
                top: 8,
                left: 8,
                child: SafeArea(
                  child: PhoenixMotionToggleButton(),
                ),
              ),
            ],
          ),
        );
      },
      home: showCoinJourney
          ? const CoinJourneyPrototypeScreen()
          : const StartupGate(),
    );
  }
}
