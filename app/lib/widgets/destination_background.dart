import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

class DestinationBackground extends StatelessWidget {
  const DestinationBackground({
    required this.journeyId,
    required this.pageType,
    required this.child,
    this.localDate,
    this.scrimStrength = .24,
    super.key,
  });

  final String journeyId;
  final JourneyBackgroundPage pageType;
  final Widget child;
  final DateTime? localDate;
  final double scrimStrength;

  @override
  Widget build(BuildContext context) {
    final location = requireJourneyLocation(journeyId);
    final asset = const JourneyBackgroundPolicy().select(
      journeyId: journeyId,
      locationPath: location.locationPath,
      page: pageType,
      localDate: localDate ?? DateTime.now(),
      catalog: journeyBackgroundCatalog,
    );
    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);
    final livingBackground = journeyId == 'beijing-summer-palace';

    return Stack(
      fit: StackFit.expand,
      children: [
        if (asset != null)
          ExcludeSemantics(
            child: _LivingDestinationImage(
              asset: asset,
              enabled: livingBackground,
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
                PhoenixTheme.paper.withValues(
                  alpha: visibleScrimStrength + .04,
                ),
                PhoenixTheme.paper.withValues(alpha: visibleScrimStrength),
                PhoenixTheme.paper.withValues(
                  alpha: visibleScrimStrength + .07,
                ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _LivingDestinationImage extends StatefulWidget {
  const _LivingDestinationImage({required this.asset, required this.enabled});

  final JourneyBackgroundAsset asset;
  final bool enabled;

  @override
  State<_LivingDestinationImage> createState() =>
      _LivingDestinationImageState();
}

class _LivingDestinationImageState extends State<_LivingDestinationImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _LivingDestinationImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) _syncMotion();
  }

  void _syncMotion() {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.enabled && !reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      widget.asset.assetPath,
      key: ValueKey('journey-background-${widget.asset.id}'),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => const _BackgroundFallback(),
    );
    if (!widget.enabled) return image;

    return RepaintBoundary(
      key: const ValueKey('summer-palace-living-background'),
      child: AnimatedBuilder(
        animation: _controller,
        child: image,
        builder: (context, child) {
          final motion = Curves.easeInOutSine.transform(_controller.value);
          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.scale(
                scale: 1.035 + (.025 * motion),
                alignment: Alignment(-.16 + (.28 * motion), -.08),
                child: child,
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: .08 + (.07 * motion),
                  child: Transform.translate(
                    offset: Offset(120 - (240 * motion), 0),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Color(0x66FFF2C2),
                            Colors.transparent,
                          ],
                          stops: [.18, .5, .82],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
          colors: [Color(0xFFFFF7EA), Color(0xFFF2DFCA), PhoenixTheme.paper],
        ),
      ),
    );
  }
}
