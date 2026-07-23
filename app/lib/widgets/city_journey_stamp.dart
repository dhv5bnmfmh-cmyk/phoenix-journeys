import 'dart:async';

import 'package:flutter/material.dart';

import '../agents/phoenix_stamp_agent.dart';
import '../data/daily_journey_catalog.dart';
import '../theme/phoenix_theme.dart';

class CityJourneyStamp extends StatelessWidget {
  const CityJourneyStamp({
    super.key,
    required this.journey,
    required this.isUnlocked,
    this.size = 104,
    this.transparentInk = false,
  });

  final DailyJourneyExperience journey;
  final bool isUnlocked;
  final double size;
  final bool transparentInk;

  @override
  Widget build(BuildContext context) {
    final foreground = transparentInk
        ? PhoenixTheme.red.withValues(alpha: .62)
        : isUnlocked
        ? PhoenixTheme.red
        : Colors.black38;
    final border = transparentInk
        ? PhoenixTheme.red.withValues(alpha: .54)
        : isUnlocked
        ? PhoenixTheme.red.withValues(alpha: .78)
        : Colors.black26;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .08),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: transparentInk
            ? Colors.transparent
            : isUnlocked
            ? const Color(0xFFFFF1DF)
            : Colors.black.withValues(alpha: .035),
        border: Border.all(color: border, width: size * .025),
        boxShadow: isUnlocked && !transparentInk
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
  late final PhoenixStampAgent _agent;

  @override
  void initState() {
    super.initState();
    _agent = PhoenixStampAgent(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_agent.play());
    });
  }

  @override
  void dispose() {
    _agent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasHeight = widget.size * 1.72;

    return Semantics(
      label: '${widget.journey.city}${widget.journey.place}印章正在从上方盖下',
      child: SizedBox(
        key: const ValueKey('animated-city-journey-stamp'),
        width: widget.size * 1.35,
        height: canvasHeight,
        child: AnimatedBuilder(
          animation: _agent.controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: widget.size * .28,
                  child: Opacity(
                    opacity: _agent.impactShadow.value,
                    child: Container(
                      width: widget.size * .78,
                      height: widget.size * .17,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: widget.size * .10,
                  child: Opacity(
                    key: const ValueKey('city-stamp-imprint'),
                    opacity: _agent.imprintOpacity.value,
                    child: Transform.scale(
                      scale: _agent.imprintScale.value,
                      child: CityJourneyStamp(
                        key: const ValueKey('city-stamp-imprint-mark'),
                        journey: widget.journey,
                        isUnlocked: true,
                        size: widget.size,
                        transparentInk: true,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _agent.pressOffset.value,
                  child: Opacity(
                    key: const ValueKey('city-stamp-tool'),
                    opacity: _agent.toolOpacity.value,
                    child: Transform.rotate(
                      angle: _agent.pressRotation.value,
                      child: Transform.scale(
                        scale: _agent.pressScale.value,
                        child: _CityStampTool(size: widget.size),
                      ),
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

class _CityStampTool extends StatelessWidget {
  const _CityStampTool({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size * .32,
            height: size * .50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD49B58), Color(0xFF8A4E24)],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(size * .17),
                bottom: Radius.circular(size * .07),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 7),
                  color: Color(0x28000000),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: size * .09,
                height: size * .30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
          Container(
            width: size * .70,
            height: size * .16,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D1C20), Color(0xFF641114)],
              ),
              borderRadius: BorderRadius.circular(size * .05),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 6),
                  color: Color(0x30000000),
                ),
              ],
            ),
          ),
          Container(
            width: size * .76,
            height: size * .12,
            decoration: BoxDecoration(
              color: const Color(0xFF4E0B0E),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(size * .06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
