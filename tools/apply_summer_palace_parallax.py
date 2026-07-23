from __future__ import annotations

import base64
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / 'app'
PAYLOAD = ROOT / 'tools' / 'summer_palace_parallax_payload'
ASSET_DIR = APP / 'assets' / 'images' / 'backgrounds' / 'generated' / 'beijing' / 'summer-palace'
ASSET_DIR.mkdir(parents=True, exist_ok=True)

for filename in (
    'summer-palace-parallax-back.webp',
    'summer-palace-parallax-middle.webp',
    'summer-palace-parallax-front.webp',
):
    parts = sorted(PAYLOAD.glob(f'{filename}.part*'))
    if not parts:
        raise SystemExit(f'Missing payload parts for {filename}')
    encoded = ''.join(part.read_text(encoding='utf-8') for part in parts)
    (ASSET_DIR / filename).write_bytes(base64.b64decode(encoded))

widget = r'''import 'package:flutter/material.dart';

import '../data/journey_background_catalog.dart';
import '../models/journey_background.dart';
import '../services/journey_background_policy.dart';
import '../services/journey_location_binding.dart';
import '../theme/phoenix_theme.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';
const _summerPalaceParallaxRoot =
    'assets/images/backgrounds/generated/beijing/summer-palace';

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
    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);
    if (journeyId == _summerPalaceJourneyId) {
      return _SummerPalaceParallaxBackground(
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }

    final location = requireJourneyLocation(journeyId);
    final asset = const JourneyBackgroundPolicy().select(
      journeyId: journeyId,
      locationPath: location.locationPath,
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
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const _BackgroundFallback(),
            ),
          )
        else
          const _BackgroundFallback(),
        _JourneyBackgroundScrim(strength: visibleScrimStrength),
        child,
      ],
    );
  }
}

class _SummerPalaceParallaxBackground extends StatefulWidget {
  const _SummerPalaceParallaxBackground({
    required this.scrimStrength,
    required this.child,
  });

  final double scrimStrength;
  final Widget child;

  @override
  State<_SummerPalaceParallaxBackground> createState() =>
      _SummerPalaceParallaxBackgroundState();
}

class _SummerPalaceParallaxBackgroundState
    extends State<_SummerPalaceParallaxBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  bool _assetsPrecached = false;

  static const _backPath =
      '$_summerPalaceParallaxRoot/summer-palace-parallax-back.webp';
  static const _middlePath =
      '$_summerPalaceParallaxRoot/summer-palace-parallax-middle.webp';
  static const _frontPath =
      '$_summerPalaceParallaxRoot/summer-palace-parallax-front.webp';

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
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _motion.stop();
      _motion.value = .42;
    } else if (!_motion.isAnimating) {
      _motion.repeat(reverse: true);
    }

    if (!_assetsPrecached) {
      _assetsPrecached = true;
      for (final path in const [_backPath, _middlePath, _frontPath]) {
        precacheImage(AssetImage(path), context);
      }
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return RepaintBoundary(
      key: const ValueKey('summer-palace-parallax-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .42 : _motion.value;
                final t = Curves.easeInOutSine.transform(raw);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ParallaxAssetLayer(
                        key: const ValueKey('summer-palace-parallax-back'),
                        assetPath: _backPath,
                        scale: 1.10 + .025 * t,
                        offset: Offset(-7 + 14 * t, -7 + 5 * t),
                      ),
                      _ParallaxAssetLayer(
                        key: const ValueKey('summer-palace-parallax-middle'),
                        assetPath: _middlePath,
                        scale: 1.085 + .014 * (1 - t),
                        offset: Offset(9 - 18 * t, 4 - 7 * t),
                        opacity: .96,
                      ),
                      _SummerPalaceWaterShimmer(progress: t),
                      _ParallaxAssetLayer(
                        key: const ValueKey('summer-palace-parallax-front'),
                        assetPath: _frontPath,
                        scale: 1.075 + .018 * t,
                        offset: Offset(-13 + 26 * t, 6 - 10 * t),
                      ),
                    ],
                  ),
                );
              },
            ),
            _JourneyBackgroundScrim(strength: widget.scrimStrength),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _ParallaxAssetLayer extends StatelessWidget {
  const _ParallaxAssetLayer({
    required this.assetPath,
    required this.scale,
    required this.offset,
    this.opacity = 1,
    super.key,
  });

  final String assetPath;
  final double scale;
  final Offset offset;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform.translate(
        offset: offset,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => const _BackgroundFallback(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummerPalaceWaterShimmer extends StatelessWidget {
  const _SummerPalaceWaterShimmer({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1.35,
          heightFactor: .54,
          child: Transform.translate(
            offset: Offset(-55 + 110 * progress, 0),
            child: DecoratedBox(
              key: const ValueKey('summer-palace-water-shimmer'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.2, -.8),
                  end: const Alignment(1.2, .8),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: .025),
                    const Color(0xFFFFDDA1).withValues(alpha: .075),
                    Colors.white.withValues(alpha: .02),
                    Colors.transparent,
                  ],
                  stops: const [0, .30, .50, .70, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyBackgroundScrim extends StatelessWidget {
  const _JourneyBackgroundScrim({required this.strength});

  final double strength;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PhoenixTheme.paper.withValues(alpha: strength + .04),
            PhoenixTheme.paper.withValues(alpha: strength),
            PhoenixTheme.paper.withValues(alpha: strength + .07),
          ],
        ),
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
'''

(APP / 'lib' / 'widgets' / 'destination_background.dart').write_text(
    widget,
    encoding='utf-8',
)

test = r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/widgets/destination_background.dart';

void main() {
  testWidgets('Summer Palace uses three-layer reduced-motion-safe parallax',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: DestinationBackground(
            journeyId: 'beijing-summer-palace',
            pageType: JourneyBackgroundPage.story,
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('summer-palace-parallax-background')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-parallax-back')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-parallax-middle')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-parallax-front')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('summer-palace-water-shimmer')),
      findsOneWidget,
    );
  });
}
'''
(APP / 'test' / 'summer_palace_parallax_background_test.dart').write_text(
    test,
    encoding='utf-8',
)

worker = r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';

const widget = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);
const root =
  'app/assets/images/backgrounds/generated/beijing/summer-palace';

test('Summer Palace dynamic background keeps three optimized local layers', () => {
  for (const file of [
    'summer-palace-parallax-back.webp',
    'summer-palace-parallax-middle.webp',
    'summer-palace-parallax-front.webp',
  ]) {
    assert.equal(existsSync(`${root}/${file}`), true, `${file} must exist`);
  }
  assert.match(widget, /summer-palace-parallax-background/);
  assert.match(widget, /AnimationController/);
  assert.match(widget, /repeat\(reverse: true\)/);
  assert.match(widget, /disableAnimations/);
  assert.match(widget, /summer-palace-water-shimmer/);
  assert.match(widget, /RepaintBoundary/);
});
'''
(ROOT / 'worker' / 'summer_palace_parallax_background_rule.test.mjs').write_text(
    worker,
    encoding='utf-8',
)

docs = ROOT / 'docs' / 'development-workflow.md'
text = docs.read_text(encoding='utf-8')
rule = (
    '\n## 永久目的地动态背景准则\n\n'
    '- 动态背景优先使用本地分层素材和缓慢视差，不得依赖在线播放视频。\n'
    '- 动画必须尊重系统“减少动态效果”设置，并保持静态构图可用。\n'
    '- 每层必须预缓存、使用 RepaintBoundary，并控制移动幅度，避免影响文字阅读或手机帧率。\n'
    '- 动态背景不得改变旅程身份、页面进度、朗读、生词或盖章流程。\n'
)
if '## 永久目的地动态背景准则' not in text:
    docs.write_text(text.rstrip() + '\n' + rule, encoding='utf-8')
