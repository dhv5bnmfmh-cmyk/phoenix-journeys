import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class PhoenixMediaButton extends StatelessWidget {
  const PhoenixMediaButton({
    required this.isPlaying,
    required this.onPressed,
    required this.tooltip,
    this.size = 50,
    super.key,
  });

  final bool isPlaying;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * .44;
    final innerColors = isPlaying
        ? const [Color(0xFFB92A2C), Color(0xFF71161A)]
        : const [Color(0xFFFFFCF3), Color(0xFFF1D79F)];
    final iconColor = isPlaying ? const Color(0xFFFFF5D6) : PhoenixTheme.red;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              curve: Curves.easeOut,
              width: size,
              height: size,
              padding: EdgeInsets.all(size * .065),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPlaying
                      ? const [
                          Color(0xFFFFD879),
                          Color(0xFFC78D2B),
                          PhoenixTheme.red,
                        ]
                      : const [
                          Color(0xFFD24B35),
                          PhoenixTheme.red,
                          Color(0xFF651418),
                        ],
                ),
                border: Border.all(
                  color: const Color(0xFFF6D57D),
                  width: size * .045,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isPlaying ? PhoenixTheme.gold : PhoenixTheme.red)
                        .withValues(alpha: .34),
                    blurRadius: size * .34,
                    offset: Offset(0, size * .14),
                  ),
                  const BoxShadow(
                    color: Color(0x66FFFFFF),
                    blurRadius: 2,
                    offset: Offset(-1, -1),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 170),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-.28, -.34),
                          radius: 1.05,
                          colors: innerColors,
                        ),
                        border: Border.all(
                          color: const Color(0xFFF4D488),
                          width: size * .025,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: size * .13,
                    top: size * .10,
                    child: Container(
                      width: size * .28,
                      height: size * .08,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: isPlaying ? .22 : .68,
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        key: ValueKey<String>(
                          isPlaying ? 'phoenix-pause' : 'phoenix-play',
                        ),
                        color: iconColor,
                        size: iconSize,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -size * .03,
                    bottom: -size * .02,
                    child: Container(
                      width: size * .29,
                      height: size * .29,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFE59C), PhoenixTheme.gold],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFFF0BD),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 3,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: isPlaying
                            ? const Color(0xFF651418)
                            : PhoenixTheme.red,
                        size: size * .18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
