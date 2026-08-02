import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/journey_location_binding.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_picker_sheet.dart';
import 'journey_screen.dart';

const _phoenixHomeHeroAsset =
    'assets/images/home/phoenix-home-journey-keyart-portrait-v1.webp';

@visibleForTesting
double compactExploreMapHeight(double viewportHeight) {
  if (viewportHeight < 700) return 160;
  if (viewportHeight < 820) return 174;
  return 188;
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final mapHeight = compactExploreMapHeight(viewportHeight);

    Future<void> openJourneyById(String journeyId) async {
      await state.activateJourney(journeyId);
      if (state.journeyCompleted) {
        await state.restartJourney();
      }
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => JourneyScreen(journeyId: journeyId)),
      );
    }

    Future<void> chooseJourney() async {
      final journeyId = await showJourneyPickerSheet(
        context: context,
        state: state,
      );
      if (journeyId != null) {
        await openJourneyById(journeyId);
      }
    }

    Future<void> chooseArrivedCityDestination() async {
      final journeyId = await showJourneyPickerSheet(
        context: context,
        state: state,
        initialCityId: state.activeJourney.cityId,
        lockToInitialCity: true,
      );
      if (journeyId != null) {
        await openJourneyById(journeyId);
      }
    }

    return Stack(
      children: [
        const Positioned.fill(child: _PhoenixHomeBackground()),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Column(
            children: [
              _TopBar(state: state),
              const SizedBox(height: 7),
              Text(
                state.displayText('欢迎回来，Explorer'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                state.displayText('世界很大，从一门语言开始。'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11.5,
                      height: 1.15,
                      color: Colors.black54,
                    ),
              ),
              const SizedBox(height: 8),
              _FlightMapCard(
                state: state,
                height: mapHeight,
                onArrived: () => unawaited(chooseArrivedCityDestination()),
              ),
              const SizedBox(height: 5),
              _CoinWalletHint(state: state),
              const SizedBox(height: 8),
              _JourneyCard(
                state: state,
                onOpen: () => unawaited(openJourneyById(state.activeJourneyId)),
                onChoose: () => unawaited(chooseJourney()),
              ),
              const SizedBox(height: 8),
              const _DiscoveryCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoinWalletHint extends StatelessWidget {
  const _CoinWalletHint({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home-coin-wallet-hint'),
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .34)),
      ),
      child: Row(
        children: [
          Text(
            state.displayText('旅程钱袋'),
            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900),
          ),
          const Spacer(),
          _CoinCount(
            icon: '●',
            color: const Color(0xFFFFC94A),
            count: state.goldCoins,
          ),
          _CoinCount(
            icon: '●',
            color: const Color(0xFFC9D0D6),
            count: state.silverCoins,
          ),
          _CoinCount(
            icon: '●',
            color: const Color(0xFFC87941),
            count: state.bronzeCoins,
          ),
          _CoinCount(
            icon: '✦',
            color: const Color(0xFF9EA7B0),
            count: state.silverFragments,
          ),
        ],
      ),
    );
  }
}

class _CoinCount extends StatelessWidget {
  const _CoinCount({
    required this.icon,
    required this.color,
    required this.count,
  });

  final String icon;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Text(icon, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(width: 2),
          Text('$count',
              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9F2B28), PhoenixTheme.red],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  color: Color(0x18000000),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PHOENIX JOURNEYS',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .9,
                  ),
                ),
                Text(
                  state.displayText('你的语言旅行护照'),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.05,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: state.toggleScript,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.translate_rounded, size: 14),
            label: Text(
              state.isTraditional ? '繁體' : '简体',
              style: const TextStyle(fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoenixHomeBackground extends StatefulWidget {
  const _PhoenixHomeBackground();

  @override
  State<_PhoenixHomeBackground> createState() => _PhoenixHomeBackgroundState();
}

class _PhoenixHomeBackgroundState extends State<_PhoenixHomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final forceMotion = Uri.base.queryParameters['motion'] == 'on';
    final reduceMotion =
        !forceMotion &&
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    if (reduceMotion) {
      _motion
        ..stop()
        ..value = .18;
    } else if (!_motion.isAnimating) {
      _motion.repeat();
    }
    precacheImage(const AssetImage(_phoenixHomeHeroAsset), context);
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forceMotion = Uri.base.queryParameters['motion'] == 'on';
    final reduceMotion =
        !forceMotion &&
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    return RepaintBoundary(
      key: const ValueKey('phoenix-home-world-language-background'),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _motion,
          builder: (context, _) {
            final phase = reduceMotion ? .18 : _motion.value;
            final camera = math.sin(phase * math.pi * 2);
            final glow = .5 + .5 * math.sin(phase * math.pi * 2 + 1.2);
            return Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(camera * 4, camera * -3),
                  child: Transform.scale(
                    scale: 1.055 + glow * .012,
                    child: Image.asset(
                      _phoenixHomeHeroAsset,
                      key: const ValueKey('phoenix-home-hero-image'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF173D42), Color(0xFF7A4C32)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  key: const ValueKey('phoenix-home-route-glow'),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(.18 + camera * .08, .22),
                      radius: .82,
                      colors: [
                        const Color(0xFFFFE0A0)
                            .withValues(alpha: .035 + glow * .035),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x3AFFF8EA),
                        Color(0x16FFF8EA),
                        Color(0x08FFF8EA),
                        Color(0x1E2C1712),
                      ],
                      stops: [0, .28, .66, 1],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FlightMapCard extends StatefulWidget {
  const _FlightMapCard({
    required this.state,
    required this.height,
    required this.onArrived,
  });

  final AppState state;
  final double height;
  final VoidCallback onArrived;

  @override
  State<_FlightMapCard> createState() => _FlightMapCardState();
}

class _FlightMapCardState extends State<_FlightMapCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late String _animatedJourneyId;

  @override
  void initState() {
    super.initState();
    _animatedJourneyId = widget.state.activeJourneyId;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );
    if (widget.state.journeyCompleted) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _FlightMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final journeyId = widget.state.activeJourneyId;
    if (journeyId != _animatedJourneyId) {
      _animatedJourneyId = journeyId;
      _controller
        ..stop()
        ..value = 0
        ..forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final forceMotion = Uri.base.queryParameters['motion'] == 'on';
    final reduceMotion =
        !forceMotion && (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    if (reduceMotion) {
      _controller
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final destination = state.activeJourneyLocation;
    final status = state.journeyCompleted
        ? '${state.activeJourney.city}已点亮 · 印章已获得'
        : state.hasJourneyInProgress
            ? '${state.activeJourneyStampEarned ? '印章已收藏 · ' : ''}旅程 ${state.beijingJourneyProgressPercent}%'
            : state.activeJourneyStampEarned
                ? '${state.activeJourney.city}印章已收藏 · 可以再次出发'
                : '${state.activeJourney.distanceLabel} · 学习航程';

    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF173D42),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Color(0x31000000),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final journeyProgress = state.journeyCompleted
                  ? 1.0
                  : state.hasJourneyInProgress
                      ? state.beijingJourneyProgress
                      : _controller.value;
              final cameraT = CurvedAnimation(
                parent: _controller,
                curve: const Interval(0, .38, curve: Curves.easeInOutCubic),
              ).value;
              final flightT = state.journeyCompleted
                  ? 1.0
                  : CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(
                        .20,
                        .78,
                        curve: Curves.easeInOutCubic,
                      ),
                    ).value;
              final landingT = state.journeyCompleted
                  ? 1.0
                  : CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(
                        .78,
                        .94,
                        curve: Curves.easeInCubic,
                      ),
                    ).value;
              final destinationFocusT = state.journeyCompleted
                  ? 1.0
                  : CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(
                        .68,
                        1.0,
                        curve: Curves.easeInOutCubic,
                      ),
                    ).value;
              final arrivalT = state.journeyCompleted
                  ? 1.0
                  : CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(
                        .92,
                        1.0,
                        curve: Curves.easeOutCubic,
                      ),
                    ).value;
              final geometry = _FlightGeometry(
                Size(constraints.maxWidth, constraints.maxHeight),
                destination.mapPoint,
              );
              final plane = landingT > 0
                  ? geometry.landingPoint(landingT)
                  : geometry.pointAt(flightT);
              final angle = landingT > 0
                  ? math.pi / 2
                  : geometry.angleAt(flightT);
              final aircraftScale =
                  .88 + Curves.easeOutCubic.transform(flightT) * .12;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 1 + cameraT * 1.7,
                      alignment: const Alignment(.72, -.12),
                      child: Opacity(
                        opacity: (1 - cameraT * 1.15).clamp(0, 1),
                        child: Image.asset(
                          'assets/images/maps/phoenix-world-route-atlas-landscape-v1.webp',
                          key: const ValueKey('phoenix-world-flight-map'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.high,
                          gaplessPlayback: true,
                          errorBuilder: (_, __, ___) =>
                              const _FlightMapFallback(),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: cameraT,
                      child: Transform.scale(
                        key: const ValueKey('phoenix-destination-camera'),
                        scale: 1 + destinationFocusT * .72,
                        alignment: Alignment(
                          destination.mapPoint.x * 2 - 1,
                          destination.mapPoint.y * 2 - 1,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/maps/phoenix-east-asia-route-atlas-landscape-v1.webp',
                              key: const ValueKey('phoenix-home-hd-flight-map'),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              filterQuality: FilterQuality.high,
                              gaplessPlayback: true,
                              errorBuilder: (_, __, ___) =>
                                  const _FlightMapFallback(),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x3A062A31),
                                    Color(0x0C062A31),
                                    Color(0x4004141A),
                                  ],
                                ),
                              ),
                            ),
                            CustomPaint(
                              painter: _PremiumMapPainter(
                                routeProgress: journeyProgress,
                                pulse: _controller.value,
                                destinationPoint: destination.mapPoint,
                              ),
                            ),
                            Positioned(
                              left: plane.dx - 25,
                              top: plane.dy - 28,
                              child: Transform.scale(
                                scale: aircraftScale,
                                child: Transform.rotate(
                                  angle: angle + math.pi / 2,
                                  child: _PremiumAircraft(
                                    lightProgress: _controller.value,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: geometry.hanoi.dx - 16,
                              top: geometry.hanoi.dy - 16,
                              child: _CityMarker(
                                label: state.displayText('河内'),
                                subtitle: 'HAN',
                                active: false,
                                pulse: _controller.value,
                              ),
                            ),
                            Positioned(
                              left: geometry.destination.dx - 16,
                              top: geometry.destination.dy - 16,
                              child: _CityMarker(
                                label: state.displayText(
                                  state.activeJourney.city,
                                ),
                                subtitle: state.activeJourney.cityCode,
                                active: state.activeJourneyStampEarned || landingT > .35,
                                pulse: _controller.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 9,
                    right: 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.displayText('今日航线'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                state.displayText(
                                  '河内  →  ${state.activeJourney.city}',
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFFFD879),
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                state.displayText('AI 旅程'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071D26).withValues(alpha: .70),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD879),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.displayText(
                                arrivalT >= .96
                                    ? '${state.activeJourney.city}已抵达 · 选择景点继续'
                                    : status,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            child: arrivalT >= .96
                                ? TextButton.icon(
                                    key: const ValueKey(
                                      'flight-arrival-destination-picker',
                                    ),
                                    onPressed: widget.onArrived,
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFFFFD879),
                                      minimumSize: const Size(0, 28),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: const Icon(
                                      Icons.location_on_rounded,
                                      size: 13,
                                    ),
                                    label: Text(
                                      state.displayText('选择景点'),
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  )
                                : Text(
                                    '${state.beijingJourneyProgressPercent}%',
                                    key: const ValueKey(
                                      'flight-arrival-progress',
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFFFFD879),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PremiumAircraft extends StatelessWidget {
  const _PremiumAircraft({required this.lightProgress});

  final double lightProgress;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        key: const ValueKey('phoenix-premium-map-aircraft'),
        size: const Size(50, 56),
        painter: _PremiumAircraftPainter(lightProgress),
      ),
    );
  }
}

class _FlightMapFallback extends StatelessWidget {
  const _FlightMapFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      key: ValueKey('phoenix-flight-map-static-fallback'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF174A53), Color(0xFF2A6A67), Color(0xFFB68A57)],
        ),
      ),
    );
  }
}

class _PremiumAircraftPainter extends CustomPainter {
  const _PremiumAircraftPainter(this.lightProgress);

  final double lightProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 50;
    final sy = size.height / 56;
    canvas.scale(sx, sy);

    final silhouette = Path()
      ..moveTo(25, 1.5)
      ..cubicTo(21.5, 3.5, 20.4, 9, 20.2, 16)
      ..lineTo(19.8, 21)
      ..lineTo(3.2, 33.5)
      ..cubicTo(1.6, 34.7, 1.2, 36.7, 2.7, 37.4)
      ..lineTo(19.4, 33.3)
      ..lineTo(20, 44)
      ..lineTo(13.2, 50)
      ..lineTo(13.7, 53)
      ..lineTo(22, 50.4)
      ..cubicTo(22.8, 54.2, 24, 55.5, 25, 55.8)
      ..cubicTo(26, 55.5, 27.2, 54.2, 28, 50.4)
      ..lineTo(36.3, 53)
      ..lineTo(36.8, 50)
      ..lineTo(30, 44)
      ..lineTo(30.6, 33.3)
      ..lineTo(47.3, 37.4)
      ..cubicTo(48.8, 36.7, 48.4, 34.7, 46.8, 33.5)
      ..lineTo(30.2, 21)
      ..lineTo(29.8, 16)
      ..cubicTo(29.6, 9, 28.5, 3.5, 25, 1.5)
      ..close();

    canvas.drawShadow(
      silhouette.shift(const Offset(0, 2)),
      const Color(0xAA04141A),
      5,
      false,
    );

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-1, -.2),
        end: Alignment(1, .3),
        colors: [
          Color(0xFF9A815C),
          Color(0xFFF5E7C9),
          Color(0xFFFFFFFF),
          Color(0xFFE1C99F),
          Color(0xFF8A6C43),
        ],
        stops: [0, .18, .48, .79, 1],
      ).createShader(const Rect.fromLTWH(1, 1, 48, 55));
    canvas.drawPath(silhouette, bodyPaint);

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .75
      ..color = const Color(0xFF5B452D).withValues(alpha: .72);
    canvas.drawPath(silhouette, outlinePaint);

    final cockpit = Path()
      ..moveTo(25, 5)
      ..cubicTo(22.7, 6.7, 22.1, 9.2, 22, 12)
      ..lineTo(25, 10.5)
      ..lineTo(28, 12)
      ..cubicTo(27.9, 9.2, 27.3, 6.7, 25, 5)
      ..close();
    canvas.drawPath(
      cockpit,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF0B2530), Color(0xFF52727A)],
        ).createShader(const Rect.fromLTWH(22, 5, 6, 7)),
    );

    final gold = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE6B84F);
    canvas.drawLine(const Offset(20.3, 22), const Offset(4.8, 34.3), gold);
    canvas.drawLine(const Offset(29.7, 22), const Offset(45.2, 34.3), gold);
    canvas.drawLine(const Offset(20.5, 44.8), const Offset(14.8, 50), gold);
    canvas.drawLine(const Offset(29.5, 44.8), const Offset(35.2, 50), gold);

    final enginePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF8EBD1), Color(0xFF80633D)],
      ).createShader(const Rect.fromLTWH(12, 25, 26, 12));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(13.2, 27, 4.2, 9),
        const Radius.circular(2),
      ),
      enginePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(32.6, 27, 4.2, 9),
        const Radius.circular(2),
      ),
      enginePaint,
    );

    final windowPaint = Paint()
      ..color = const Color(0xFF31474B)
      ..style = PaintingStyle.fill;
    for (var y = 15.0; y < 39; y += 3.1) {
      canvas.drawCircle(Offset(22.4, y), .58, windowPaint);
      canvas.drawCircle(Offset(27.6, y), .58, windowPaint);
    }

    final glintX = 21 + 8 * lightProgress;
    canvas.drawLine(
      Offset(glintX, 13),
      Offset(glintX - 1, 39),
      Paint()
        ..color = Colors.white.withValues(alpha: .24)
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _PremiumAircraftPainter oldDelegate) =>
      oldDelegate.lightProgress != lightProgress;
}

class _FlightGeometry {
  _FlightGeometry(this.size, JourneyMapPoint destinationPoint)
      : hanoi = Offset(size.width * .30, size.height * .76),
        control = Offset(
          size.width * ((.30 + destinationPoint.x) / 2),
          size.height * .22,
        ),
        destination = Offset(
          size.width * destinationPoint.x,
          size.height * destinationPoint.y,
        ),
        approach = Offset(
          size.width * destinationPoint.x,
          math.max(42, size.height * destinationPoint.y - 52),
        );

  final Size size;
  final Offset hanoi;
  final Offset control;
  final Offset destination;
  final Offset approach;

  Offset pointAt(double t) {
    final oneMinus = 1 - t;
    return Offset(
      oneMinus * oneMinus * hanoi.dx +
          2 * oneMinus * t * control.dx +
          t * t * approach.dx,
      oneMinus * oneMinus * hanoi.dy +
          2 * oneMinus * t * control.dy +
          t * t * approach.dy,
    );
  }

  Offset landingPoint(double t) => Offset.lerp(approach, destination, t)!;

  double angleAt(double t) {
    final dx = 2 * (1 - t) * (control.dx - hanoi.dx) +
        2 * t * (approach.dx - control.dx);
    final dy = 2 * (1 - t) * (control.dy - hanoi.dy) +
        2 * t * (approach.dy - control.dy);
    return math.atan2(dy, dx);
  }
}

class _CityMarker extends StatelessWidget {
  const _CityMarker({
    required this.label,
    required this.subtitle,
    required this.active,
    required this.pulse,
  });

  final String label;
  final String subtitle;
  final bool active;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final scale = 1 + math.sin(pulse * math.pi * 2) * .035;
    final color = active ? const Color(0xFFFFD879) : Colors.white;

    return Transform.scale(
      scale: scale,
      child: Column(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFF08252D).withValues(alpha: .88),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: .85),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: active ? .28 : .13),
                  blurRadius: active ? 10 : 6,
                  spreadRadius: active ? 1.5 : .5,
                ),
              ],
            ),
            child: Icon(
              active ? Icons.star_rounded : Icons.location_on_rounded,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF071D26).withValues(alpha: .84),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              '$label $subtitle',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.state,
    required this.onOpen,
    required this.onChoose,
  });

  final AppState state;
  final VoidCallback onOpen;
  final VoidCallback onChoose;

  String get _buttonText {
    if (state.journeyCompleted) return '再次探索${state.activeJourney.city}';
    if (state.hasJourneyInProgress) {
      return '继续${state.activeJourney.city} Journey';
    }
    return '开始${state.activeJourney.city} Journey';
  }

  IconData get _buttonIcon {
    if (state.journeyCompleted) return Icons.replay_rounded;
    if (state.hasJourneyInProgress) return Icons.play_arrow_rounded;
    return Icons.flight_takeoff;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                icon: Icons.place_outlined,
                text: state.displayText('中国 · ${state.activeJourney.city}'),
              ),
              const Spacer(),
              TextButton.icon(
                key: const ValueKey('choose-city-journey'),
                onPressed: onChoose,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.swap_horiz_rounded, size: 14),
                label: Text(
                  state.displayText('选择城市'),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            state.displayText(state.activeJourney.headline),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            state.displayText(state.activeJourney.description),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, height: 1.15),
          ),
          if (state.hasJourneyInProgress || state.journeyCompleted) ...[
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.displayText(
                      state.journeyCompleted
                          ? '旅程完成 · ${state.activeJourney.place}印章已收入护照'
                          : '上次停在「${state.beijingJourneyStepLabel}」',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${state.beijingJourneyProgressPercent}%',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: state.beijingJourneyProgress,
                minHeight: 4,
                color: PhoenixTheme.red,
                backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              ),
            ),
          ] else if (state.activeJourneyStampEarned) ...[
            const SizedBox(height: 6),
            Text(
              state.displayText('${state.activeJourney.city}印章已收藏，可以随时再次体验。'),
              maxLines: 1,
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _FeatureChip(
                  icon: Icons.headphones,
                  text: state.displayText('自动朗读'),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _FeatureChip(
                  icon: Icons.touch_app,
                  text: state.displayText('点词释义'),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _FeatureChip(
                  icon: Icons.edit_note,
                  text: state.displayText('写作任务'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: PhoenixTheme.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: Icon(_buttonIcon, size: 18),
              label: Text(
                state.displayText(_buttonText),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: onOpen,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8C788)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF7B1E1E),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.displayText('Discovery · 今日发现'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  state.displayText(state.activeJourney.discoveryTeaser),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, height: 1.05),
                ),
                const SizedBox(height: 2),
                Text(
                  state.displayText('朗读后用探索者语言理解，再继续表达。'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 9.5,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.volume_up_outlined, size: 18),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E5D2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 3),
          Text(text, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: PhoenixTheme.red),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumMapPainter extends CustomPainter {
  const _PremiumMapPainter({
    required this.routeProgress,
    required this.pulse,
    required this.destinationPoint,
  });

  final double routeProgress;
  final double pulse;
  final JourneyMapPoint destinationPoint;

  @override
  void paint(Canvas canvas, Size size) {
    _drawRoute(canvas, size);
  }

  void _drawRoute(Canvas canvas, Size size) {
    final geometry = _FlightGeometry(size, destinationPoint);
    final route = Path()
      ..moveTo(geometry.hanoi.dx, geometry.hanoi.dy)
      ..quadraticBezierTo(
        geometry.control.dx,
        geometry.control.dy,
        geometry.approach.dx,
        geometry.approach.dy,
      )
      ..lineTo(geometry.destination.dx, geometry.destination.dy);

    final glow = Paint()
      ..color = const Color(0xFFFFD879).withValues(alpha: .20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, glow);

    final dashed = Paint()
      ..color = Colors.white.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    _drawDashedPath(canvas, route, dashed);

    final metrics = route.computeMetrics().toList(growable: false);
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final visible = metric.extractPath(
      0,
      metric.length * routeProgress.clamp(0.0, 1.0),
    );
    final active = Paint()
      ..color = const Color(0xFFFFD879)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(visible, active);

    final halo = Paint()
      ..color = const Color(
        0xFFFFD879,
      ).withValues(alpha: .10 + (math.sin(pulse * math.pi * 2).abs() * .10))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(visible, halo);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumMapPainter oldDelegate) {
    return oldDelegate.routeProgress != routeProgress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.destinationPoint != destinationPoint;
  }
}
