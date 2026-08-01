import 'package:flutter/material.dart';

/// A high-detail illustrated journey medallion.
///
/// Regular journeys reuse their reviewed 864×1536 scene artwork. Special
/// journeys use their reviewed 900×1600 story plates. The frame supplies the
/// metallic depth visible in the Passport UI.
class JourneySymbolBadge extends StatelessWidget {
  const JourneySymbolBadge({
    super.key,
    required this.journeyId,
    this.size = 50,
    this.isUnlocked = true,
  });

  final String journeyId;
  final double size;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final asset = _assetFor(journeyId);
    final rim = _rimFor(journeyId);

    return Semantics(
      image: true,
      label: '旅程高清插画徽章',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: isUnlocked ? 1 : .50,
        child: Container(
          key: ValueKey('journey-illustration-$journeyId'),
          width: size,
          height: size,
          padding: EdgeInsets.all(size * .055),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFF2BD),
                rim,
                const Color(0xFF7B4A1C),
                const Color(0xFFFFD777),
              ],
              stops: const [0, .34, .70, 1],
            ),
            border: Border.all(
              color: const Color(0xFFFFE5A1),
              width: size * .025,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .32),
                blurRadius: size * .15,
                offset: Offset(0, size * .08),
              ),
              BoxShadow(
                color: rim.withValues(alpha: .32),
                blurRadius: size * .18,
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: _alignmentFor(journeyId),
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    key: const ValueKey('journey-symbol-static-fallback'),
                    color: rim,
                    child: Icon(
                      Icons.explore_rounded,
                      color: const Color(0xFFFFE7A0),
                      size: size * .44,
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x5CFFFFFF),
                        Color(0x00FFFFFF),
                        Color(0x25000000),
                      ],
                      stops: [0, .36, 1],
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xCCFFE7A0),
                      width: size * .024,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _assetFor(String id) {
  if (id == 'literary-roaming') {
    return 'assets/images/special-realms/dream-butterfly-v3.webp';
  }
  if (id == 'myth-tracing') {
    return 'assets/images/special-realms/moon-letter-v2.webp';
  }
  if (id == 'strange-night-talks') {
    return 'assets/images/special-realms/shadowless-inn-v2.webp';
  }
  if (id == 'folk-secret-land') {
    return 'assets/images/special-realms/upstream-lantern-v3.webp';
  }
  if (id.contains('summer-palace')) {
    return 'assets/images/backgrounds/generated/beijing/summer-palace/08-golden-hour-tower.webp';
  }
  if (id.contains('shanghai')) {
    return 'assets/images/backgrounds/generated/shanghai/bund/09-lantern-night.webp';
  }
  if (id.contains('xian')) {
    return 'assets/images/backgrounds/generated/xian/city-wall/07-golden-hour.webp';
  }
  if (id.contains('hangzhou')) {
    return 'assets/images/backgrounds/generated/hangzhou/west-lake/08-blue-hour.webp';
  }
  if (id.contains('chengdu')) {
    return 'assets/images/backgrounds/generated/chengdu/kuanzhai-alley/09-lantern-night.webp';
  }
  if (id.contains('nanjing')) {
    return 'assets/images/backgrounds/generated/nanjing/qinhuai-river/09-lantern-night.webp';
  }
  if (id.contains('guangzhou')) {
    return 'assets/images/backgrounds/generated/guangzhou/chen-clan-ancestral-hall/07-golden-hour.webp';
  }
  if (id.contains('suzhou')) {
    return 'assets/images/backgrounds/generated/suzhou/humble-administrators-garden/suzhou-humble-administrators-garden-v1.webp';
  }
  if (id.contains('luoyang')) {
    return 'assets/images/backgrounds/generated/luoyang/longmen-grottoes/luoyang-longmen-grottoes-v1.webp';
  }
  if (id.contains('quanzhou')) {
    return 'assets/images/backgrounds/generated/quanzhou/kaiyuan-temple/quanzhou-kaiyuan-temple-v1.webp';
  }
  if (id.contains('datong')) {
    return 'assets/images/backgrounds/generated/datong/yungang-grottoes/datong-yungang-grottoes-v1.webp';
  }
  if (id.contains('lijiang')) {
    return 'assets/images/backgrounds/generated/lijiang/old-town/lijiang-old-town-v1.webp';
  }
  if (id.contains('jiangmen')) {
    return 'assets/images/backgrounds/generated/jiangmen/kaiping-diaolou/jiangmen-kaiping-diaolou-v1.webp';
  }
  if (id.contains('dunhuang')) {
    return 'assets/images/backgrounds/generated/dunhuang/mogao-caves/dunhuang-mogao-caves-v1.webp';
  }
  if (id.contains('chengde')) {
    return 'assets/images/backgrounds/generated/chengde/mountain-resort/chengde-mountain-resort-v1.webp';
  }
  if (id.contains('xiamen')) {
    return 'assets/images/backgrounds/generated/xiamen/kulangsu/xiamen-kulangsu-v1.webp';
  }
  if (id.contains('pingyao')) return 'assets/images/backgrounds/generated/pingyao/ancient-city/pingyao-ancient-city-v1.webp';
  if (id.contains('qufu')) return 'assets/images/backgrounds/generated/qufu/confucius-sites/qufu-confucius-v1.webp';
  if (id.contains('leshan')) return 'assets/images/backgrounds/generated/leshan/giant-buddha/leshan-giant-buddha-v1.webp';
  if (id.contains('wuyishan')) return 'assets/images/backgrounds/generated/wuyishan/nine-bend-stream/wuyishan-nine-bend-v1.webp';
  if (id.contains('honghe')) return 'assets/images/backgrounds/generated/honghe/hani-rice-terraces/honghe-hani-terraces-v1.webp';
  return 'assets/images/backgrounds/generated/beijing/forbidden-city/03-golden-gate.webp';
}

Alignment _alignmentFor(String id) {
  if (id == 'literary-roaming') return const Alignment(0, -.18);
  if (id == 'myth-tracing') return const Alignment(.05, -.10);
  if (id == 'strange-night-talks') return const Alignment(0, -.04);
  if (id == 'folk-secret-land') return const Alignment(0, -.12);
  if (id.contains('shanghai')) return const Alignment(.12, -.10);
  if (id.contains('hangzhou')) return const Alignment(.18, -.05);
  if (id.contains('nanjing')) return const Alignment(.10, .05);
  return Alignment.center;
}

Color _rimFor(String id) {
  if (id == 'literary-roaming') return const Color(0xFF4C9FC5);
  if (id == 'myth-tracing') return const Color(0xFFB98A37);
  if (id == 'strange-night-talks') return const Color(0xFFB8573D);
  if (id == 'folk-secret-land') return const Color(0xFFC37729);
  return const Color(0xFFC18B38);
}
