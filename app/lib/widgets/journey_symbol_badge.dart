import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A high-detail illustrated journey medallion.
///
/// Regular journeys reuse their reviewed 864×1536 scene artwork. Special
/// journeys use the dedicated 512×512 illustrated symbols first introduced in
/// PR #131. The frame supplies the metallic depth visible in the Passport UI.
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

  bool get _isSvg => _assetFor(journeyId).endsWith('.svg');

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
                if (_isSvg)
                  SvgPicture.asset(asset, fit: BoxFit.cover)
                else
                  Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    alignment: _alignmentFor(journeyId),
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
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
    return 'assets/images/special-realms/literary-roaming-symbol.svg';
  }
  if (id == 'myth-tracing') {
    return 'assets/images/special-realms/myth-tracing-symbol.svg';
  }
  if (id == 'strange-night-talks') {
    return 'assets/images/special-realms/strange-night-talks-symbol.svg';
  }
  if (id == 'folk-secret-land') {
    return 'assets/images/special-realms/folk-secret-land-symbol.svg';
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
  return 'assets/images/backgrounds/generated/beijing/forbidden-city/03-golden-gate.webp';
}

Alignment _alignmentFor(String id) {
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
