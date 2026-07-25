part of 'summer_palace_journey_arsenal.dart';

class _PhoenixCharacter extends StatelessWidget {
  const _PhoenixCharacter({
    required this.progress,
    required this.size,
    this.charged = false,
  });

  final double progress;
  final double size;
  final bool charged;

  @override
  Widget build(BuildContext context) {
    final wing = math.sin(progress * math.pi * 2) * .12;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * .75,
            height: size * .75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  PhoenixTheme.gold.withValues(alpha: charged ? .38 : .18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: size * .06,
            child: Transform.rotate(
              angle: -.45 - wing,
              child: Icon(
                Icons.local_fire_department_rounded,
                size: size * .48,
                color: const Color(0xFFF7B64A),
              ),
            ),
          ),
          Positioned(
            right: size * .06,
            child: Transform.rotate(
              angle: .45 + wing,
              child: Icon(
                Icons.local_fire_department_rounded,
                size: size * .48,
                color: const Color(0xFFE34B45),
              ),
            ),
          ),
          Container(
            width: size * .31,
            height: size * .43,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(99, 130)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFE39A), Color(0xFFE04343)],
              ),
            ),
          ),
          Positioned(
            top: size * .18,
            child: Container(
              width: size * .25,
              height: size * .25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFD36A),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: size * .14,
                    top: size * .07,
                    child: Container(
                      width: size * .035,
                      height: size * .035,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -size * .06,
                    top: size * .09,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: size * .19,
                      color: const Color(0xFFFF9D28),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size * .02,
            child: Icon(
              Icons.whatshot_rounded,
              size: size * .32,
              color: const Color(0xFFE83645),
            ),
          ),
          if (charged)
            ...List.generate(5, (index) {
              final angle = progress * math.pi * 2 + index * math.pi * .4;
              return Transform.translate(
                offset: Offset(
                  math.cos(angle) * size * .39,
                  math.sin(angle) * size * .39,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: size * .12,
                  color: PhoenixTheme.gold,
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _BeastCharacter extends StatelessWidget {
  const _BeastCharacter({
    required this.progress,
    required this.armor,
    required this.size,
    this.hit = false,
    this.countering = false,
  });

  final double progress;
  final int armor;
  final double size;
  final bool hit;
  final bool countering;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: progress * math.pi * .12,
            child: Icon(
              Icons.blur_on_rounded,
              size: size,
              color: (countering ? PhoenixTheme.red : const Color(0xFF704B82))
                  .withValues(alpha: .8),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: size * .58,
            height: size * .55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * .18),
              gradient: LinearGradient(
                colors: hit
                    ? const [Color(0xFFFFC263), Color(0xFF5E2638)]
                    : const [Color(0xFF815B91), Color(0xFF231426)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (countering ? PhoenixTheme.red : Colors.deepPurple)
                      .withValues(alpha: .32),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: size * .11,
                  top: size * .16,
                  child: _BeastEye(size: size, angry: countering),
                ),
                Positioned(
                  right: size * .11,
                  top: size * .16,
                  child: _BeastEye(size: size, angry: countering),
                ),
                Positioned(
                  left: size * .17,
                  right: size * .17,
                  bottom: size * .12,
                  child: Container(
                    height: size * .055,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < armor; index++)
            Transform.translate(
              offset: Offset(index == 0 ? -size * .38 : size * .38, 0),
              child: Transform.rotate(
                angle: progress * math.pi * 2 * (index == 0 ? 1 : -1),
                child: Icon(
                  Icons.diamond_outlined,
                  size: size * .22,
                  color: PhoenixTheme.gold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BeastEye extends StatelessWidget {
  const _BeastEye({required this.size, required this.angry});

  final double size;
  final bool angry;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angry ? -.18 : 0,
      child: Container(
        width: size * .12,
        height: size * .075,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: angry ? Colors.white : PhoenixTheme.gold,
        ),
        alignment: Alignment.center,
        child: Container(
          width: size * .035,
          height: size * .035,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _ArenaLinesPainter extends CustomPainter {
  const _ArenaLinesPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PhoenixTheme.gold.withValues(alpha: .08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 4; index++) {
      final y = size.height * (.22 + index * .19);
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += 14) {
        final wave = math.sin(x / 28 + progress * math.pi * 2 + index) * 3;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaLinesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
