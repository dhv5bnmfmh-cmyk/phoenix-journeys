from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BACKGROUND = ROOT / 'app/lib/widgets/destination_background.dart'
RULE = ROOT / 'worker/forbidden_city_dynamic_background_rule.test.mjs'


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


text = BACKGROUND.read_text(encoding='utf-8')

text = replace_once(
    text,
    "const _summerPalaceJourneyId = 'beijing-summer-palace';\n\nbool _summerPalaceReduceMotion(BuildContext context) {",
    "const _summerPalaceJourneyId = 'beijing-summer-palace';\nconst _forbiddenCityJourneyId = 'beijing-forbidden-city';\n\nbool _destinationReduceMotion(BuildContext context) {",
    'journey ids and motion helper',
)
text = text.replace('_summerPalaceReduceMotion(context)', '_destinationReduceMotion(context)')

summer_branch = """    if (journeyId == _summerPalaceJourneyId) {
      return _SummerPalaceDynamicBackground(
        assetPath: asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }
"""
forbidden_branch = summer_branch + """
    if (journeyId == _forbiddenCityJourneyId) {
      return _ForbiddenCityDynamicBackground(
        assetPath: asset?.assetPath,
        scrimStrength: visibleScrimStrength,
        child: child,
      );
    }
"""
text = replace_once(text, summer_branch, forbidden_branch, 'forbidden city route')

marker = 'class _SummerPalaceDynamicBackground extends StatefulWidget {'
if text.count(marker) != 1:
    raise SystemExit('summer palace class marker missing')

forbidden_classes = r'''class _ForbiddenCityDynamicBackground extends StatefulWidget {
  const _ForbiddenCityDynamicBackground({
    required this.assetPath,
    required this.scrimStrength,
    required this.child,
  });

  final String? assetPath;
  final double scrimStrength;
  final Widget child;

  @override
  State<_ForbiddenCityDynamicBackground> createState() =>
      _ForbiddenCityDynamicBackgroundState();
}

class _ForbiddenCityDynamicBackgroundState
    extends State<_ForbiddenCityDynamicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;
  String? _preloadedAssetPath;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotionPreference();
    _preloadAsset();
  }

  @override
  void didUpdateWidget(covariant _ForbiddenCityDynamicBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _preloadedAssetPath = null;
      _preloadAsset();
    }
  }

  void _syncMotionPreference() {
    final reduceMotion = _destinationReduceMotion(context);
    if (reduceMotion) {
      _motion.stop();
      _motion.value = .46;
    } else if (!_motion.isAnimating) {
      _motion.value = .1;
      _motion.repeat(reverse: true);
    }
  }

  void _preloadAsset() {
    final path = widget.assetPath;
    if (path == null || path == _preloadedAssetPath) return;
    _preloadedAssetPath = path;
    precacheImage(AssetImage(path), context);
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _destinationReduceMotion(context);
    return RepaintBoundary(
      key: const ValueKey('forbidden-city-dynamic-background'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _motion,
              builder: (context, _) {
                final raw = reduceMotion ? .46 : _motion.value;
                final progress = Curves.easeInOutSine.transform(raw);
                return ExcludeSemantics(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _ForbiddenCityCameraLayer(
                        assetPath: widget.assetPath,
                        progress: progress,
                      ),
                      _ForbiddenCityDawnLight(progress: progress),
                      _ForbiddenCityCloudShadow(progress: progress),
                      _ForbiddenCityGateDepth(progress: progress),
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

class _ForbiddenCityCameraLayer extends StatelessWidget {
  const _ForbiddenCityCameraLayer({
    required this.assetPath,
    required this.progress,
  });

  final String? assetPath;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final path = assetPath;
    if (path == null) return const _BackgroundFallback();

    return RepaintBoundary(
      key: const ValueKey('forbidden-city-camera-layer'),
      child: Transform.translate(
        key: const ValueKey('forbidden-city-camera-transform'),
        offset: Offset(-10 + 20 * progress, -18 + 22 * progress),
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 1.045 + .07 * progress,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => const _BackgroundFallback(),
          ),
        ),
      ),
    );
  }
}

class _ForbiddenCityDawnLight extends StatelessWidget {
  const _ForbiddenCityDawnLight({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 1.55,
          heightFactor: .72,
          child: Transform.translate(
            offset: Offset(-86 + 150 * progress, -18 + 12 * progress),
            child: DecoratedBox(
              key: const ValueKey('forbidden-city-dawn-light'),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.78 + 1.1 * progress, -.55),
                  radius: 1.05,
                  colors: [
                    const Color(0xFFFFF4D2).withValues(alpha: .24),
                    const Color(0xFFFFC36E).withValues(alpha: .13),
                    Colors.transparent,
                  ],
                  stops: const [0, .4, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForbiddenCityCloudShadow extends StatelessWidget {
  const _ForbiddenCityCloudShadow({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 1.8,
        heightFactor: .62,
        child: Transform.translate(
          offset: Offset(130 - 260 * progress, 8 + 12 * progress),
          child: DecoratedBox(
            key: const ValueKey('forbidden-city-cloud-shadow'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.2, -.65),
                end: const Alignment(1.2, .7),
                colors: [
                  Colors.transparent,
                  const Color(0xFF293342).withValues(alpha: .035),
                  const Color(0xFF17202D).withValues(alpha: .11),
                  Colors.white.withValues(alpha: .035),
                  Colors.transparent,
                ],
                stops: const [0, .24, .48, .72, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForbiddenCityGateDepth extends StatelessWidget {
  const _ForbiddenCityGateDepth({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: .48,
          child: Transform.translate(
            offset: Offset(0, 6 - 12 * progress),
            child: Opacity(
              opacity: .82 + .12 * progress,
              child: DecoratedBox(
                key: const ValueKey('forbidden-city-gate-depth'),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF6E201C).withValues(alpha: .04),
                      const Color(0xFF24120F).withValues(alpha: .15),
                    ],
                    stops: const [0, .58, 1],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

'''
text = text.replace(marker, forbidden_classes + marker, 1)
BACKGROUND.write_text(text, encoding='utf-8')

RULE.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);

test('Forbidden City uses its own slow cinematic motion layers', () => {
  assert.match(background, /_forbiddenCityJourneyId = 'beijing-forbidden-city'/);
  assert.match(background, /class _ForbiddenCityDynamicBackground/);
  assert.match(background, /Duration\(seconds: 16\)/);
  assert.match(background, /_motion\.repeat\(reverse: true\)/);
  assert.match(background, /forbidden-city-camera-transform/);
  assert.match(background, /forbidden-city-dawn-light/);
  assert.match(background, /forbidden-city-cloud-shadow/);
  assert.match(background, /forbidden-city-gate-depth/);
});

test('Forbidden City motion remains lightweight and has no water effect', () => {
  const start = background.indexOf('class _ForbiddenCityDynamicBackground');
  const end = background.indexOf('class _SummerPalaceDynamicBackground');
  const forbidden = background.slice(start, end);
  assert.doesNotMatch(forbidden, /Water|Ripple|Shimmer|CustomPaint/);
  assert.doesNotMatch(forbidden, /VideoPlayer|\.mp4|animated.*webp/i);
  assert.match(forbidden, /RepaintBoundary/);
  assert.match(background, /queryParameters\['motion'\] == 'on'/);
});
""",
    encoding='utf-8',
)
