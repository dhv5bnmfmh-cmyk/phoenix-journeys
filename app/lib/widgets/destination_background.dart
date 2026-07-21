import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../theme/phoenix_theme.dart';

class DestinationBackground extends StatelessWidget {
  const DestinationBackground({
    required this.journeyId,
    required this.pageType,
    required this.child,
    this.localDate,
    this.scrimStrength = .64,
    super.key,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final Widget child;
  final DateTime? localDate;
  final double scrimStrength;

  @override
  Widget build(BuildContext context) {
    final asset = const JourneyBackgroundPolicy().select(
      journeyId: journeyId,
      page: pageType,
      localDate: localDate ?? DateTime.now(),
      catalog: journeyBackgroundCatalog,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (asset != null)
          ExcludeSemantics(
            child: Image.asset(
              asset.assetPath,
              key: ValueKey('journey-background-${asset.id}'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => const _BackgroundFallback(),
            ),
          )
        else
          const _BackgroundFallback(),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhoenixTheme.paper.withValues(alpha: scrimStrength + .12),
                PhoenixTheme.paper.withValues(alpha: scrimStrength),
                PhoenixTheme.paper.withValues(alpha: scrimStrength + .18),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundFallback extends StatelessWidget {
  const _BackgroundFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7EA),
            Color(0xFFF2DFCA),
            PhoenixTheme.paper,
          ],
        ),
      ),
    );
  }
}
