import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../theme/phoenix_theme.dart';

class CityJourneyStamp extends StatelessWidget {
  const CityJourneyStamp({
    super.key,
    required this.journey,
    required this.isUnlocked,
    this.size = 104,
  });

  final DailyJourneyExperience journey;
  final bool isUnlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    final foreground = isUnlocked ? PhoenixTheme.red : Colors.black38;
    final border = isUnlocked
        ? PhoenixTheme.red.withValues(alpha: .78)
        : Colors.black26;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .08),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? const Color(0xFFFFF1DF)
            : Colors.black.withValues(alpha: .035),
        border: Border.all(color: border, width: size * .025),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: PhoenixTheme.red.withValues(alpha: .17),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: border, width: size * .012),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size * .12,
              child: Text(
                journey.city,
                style: TextStyle(
                  color: foreground,
                  fontSize: size * .105,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Text(
              isUnlocked ? journey.stampSymbol : '锁',
              style: TextStyle(
                color: foreground,
                fontSize: size * .34,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
            Positioned(
              bottom: size * .11,
              child: Text(
                isUnlocked ? '${journey.cityCode} · 已点亮' : '${journey.cityCode} · 未解锁',
                style: TextStyle(
                  color: foreground,
                  fontSize: size * .074,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCityJourneyStamp extends StatefulWidget {
  const AnimatedCityJourneyStamp({
    super.key,
    required this.journey,
    this.size = 132,
  });

  final DailyJourneyExperience journey;
  final double size;

  @override
  State<AnimatedCityJourneyStamp> createState() =>
      _AnimatedCityJourneyStampState();
}

class _AnimatedCityJourneyStampState extends State<AnimatedCityJourneyStamp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: CityJourneyStamp(
        journey: widget.journey,
        isUnlocked: true,
        size: widget.size,
      ),
    );
  }
}
