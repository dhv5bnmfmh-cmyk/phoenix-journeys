import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool livingStoryReduceMotion(BuildContext context) {
  final forceMotion = Uri.base.queryParameters['motion'] == 'on';
  return !forceMotion &&
      (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
}

bool get livingStorySceneDebugEnabled {
  final uri = Uri.base;
  final previewHost = uri.host.startsWith('phoenix-journeys-pr-') ||
      uri.host == 'localhost' ||
      uri.host == '127.0.0.1';
  return previewHost && uri.queryParameters['sceneDebug'] == 'on';
}

@immutable
class StorySceneState {
  const StorySceneState({
    required this.id,
    required this.assetPath,
    required this.narrativeTravel,
    required this.cameraScale,
    required this.lightColor,
    required this.foregroundColor,
    this.transitionDuration = const Duration(milliseconds: 2400),
    this.ambientStrength = 1,
    this.depthStrength = 1,
    this.wideReveal = false,
  });

  final String id;
  final String assetPath;
  final Offset narrativeTravel;
  final double cameraScale;
  final Color lightColor;
  final Color foregroundColor;
  final Duration transitionDuration;
  final double ambientStrength;
  final double depthStrength;
  final bool wideReveal;
}

@immutable
class StorySceneCue {
  const StorySceneCue({required this.progress, required this.scene});

  final double progress;
  final StorySceneState scene;
}

@immutable
class StorySceneVariant {
  const StorySceneVariant({
    required this.locationId,
    required this.variantId,
    required this.level,
    required this.cues,
  });

  final String locationId;
  final String variantId;
  final int level;
  final List<StorySceneCue> cues;
}

/// Converts hot narration progress into cold scene-boundary notifications.
/// Ordinary progress ticks do not notify listeners or rebuild scene data.
class StorySceneDirector extends ChangeNotifier {
  StorySceneDirector(this.variant) : _cueIndex = 0;

  final StorySceneVariant variant;
  int _cueIndex;

  int get cueIndex => _cueIndex;
  StorySceneState get scene => variant.cues[_cueIndex].scene;

  bool handleProgress(double progress) {
    final safeProgress = progress.clamp(0.0, 1.0);
    var next = 0;
    for (var index = 1; index < variant.cues.length; index += 1) {
      if (safeProgress < variant.cues[index].progress) break;
      next = index;
    }
    return showCue(next);
  }

  bool showCue(int index) {
    final next = index.clamp(0, variant.cues.length - 1);
    if (next == _cueIndex) return false;
    _cueIndex = next;
    notifyListeners();
    return true;
  }
}

/// One ambient controller plus one narrative transition controller.
/// The layer remains enhancement-only: failed assets render transparently.
class LivingStoryScene extends StatefulWidget {
  const LivingStoryScene({
    required this.variant,
    required this.progressListenable,
    required this.readProgress,
    this.debugCueListenable,
    super.key,
  });

  final StorySceneVariant variant;
  final Listenable progressListenable;
  final double Function() readProgress;
  final ValueListenable<int>? debugCueListenable;

  @override
  State<LivingStoryScene> createState() => LivingStorySceneState();
}

class LivingStorySceneState extends State<LivingStoryScene>
    with TickerProviderStateMixin {
  late StorySceneDirector _director;
  late final AnimationController _ambient;
  late final AnimationController _transition;
  StorySceneState? _previousScene;
  late StorySceneState _displayedScene;
  final Set<String> _requestedAssets = <String>{};
  bool _reduceMotion = false;

  @visibleForTesting
  StorySceneDirector get director => _director;

  @visibleForTesting
  int get activeControllerCount => _reduceMotion ? 0 : 2;

  @override
  void initState() {
    super.initState();
    _director = StorySceneDirector(widget.variant);
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
      value: .08,
    );
    _transition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
      value: 1,
    );
    _director.handleProgress(widget.readProgress());
    _displayedScene = _director.scene;
    _director.addListener(_handleSceneChanged);
    widget.progressListenable.addListener(_handleProgress);
    widget.debugCueListenable?.addListener(_handleDebugCue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = livingStoryReduceMotion(context);
    _syncAmbientMotion();
    _precacheCurrentAndNext();
  }

  @override
  void didUpdateWidget(covariant LivingStoryScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.progressListenable, widget.progressListenable)) {
      oldWidget.progressListenable.removeListener(_handleProgress);
      widget.progressListenable.addListener(_handleProgress);
    }
    if (!identical(oldWidget.debugCueListenable, widget.debugCueListenable)) {
      oldWidget.debugCueListenable?.removeListener(_handleDebugCue);
      widget.debugCueListenable?.addListener(_handleDebugCue);
    }
    if (!identical(oldWidget.variant, widget.variant)) {
      _director
        ..removeListener(_handleSceneChanged)
        ..dispose();
      _director = StorySceneDirector(widget.variant)
        ..handleProgress(widget.readProgress())
        ..addListener(_handleSceneChanged);
      _displayedScene = _director.scene;
      _previousScene = null;
      _requestedAssets.clear();
      _precacheCurrentAndNext();
      _handleDebugCue();
    }
  }

  void _syncAmbientMotion() {
    if (_reduceMotion) {
      _ambient
        ..stop()
        ..value = .32;
    } else if (!_ambient.isAnimating) {
      _ambient.repeat();
    }
  }

  void _handleProgress() {
    if (widget.debugCueListenable != null) return;
    _director.handleProgress(widget.readProgress());
  }

  void _handleDebugCue() {
    final debugCue = widget.debugCueListenable?.value;
    if (debugCue != null) _director.showCue(debugCue);
  }

  void _handleSceneChanged() {
    _previousScene = _displayedScene;
    _displayedScene = _director.scene;
    _transition
      ..duration = _reduceMotion
          ? const Duration(milliseconds: 160)
          : _director.scene.transitionDuration
      ..forward(from: 0);
    _precacheCurrentAndNext();
    setState(() {});
  }

  StorySceneState? _sceneAt(int index) {
    if (index < 0 || index >= widget.variant.cues.length) return null;
    return widget.variant.cues[index].scene;
  }

  void _precacheCurrentAndNext() {
    for (final index in <int>[_director.cueIndex, _director.cueIndex + 1]) {
      final scene = _sceneAt(index);
      if (scene == null || !_requestedAssets.add(scene.assetPath)) continue;
      precacheImage(AssetImage(scene.assetPath), context).catchError((_) {});
    }
  }

  @override
  void dispose() {
    widget.progressListenable.removeListener(_handleProgress);
    widget.debugCueListenable?.removeListener(_handleDebugCue);
    _director
      ..removeListener(_handleSceneChanged)
      ..dispose();
    _ambient.dispose();
    _transition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scene = _director.scene;
    final previous = _previousScene;
    return RepaintBoundary(
      key: const ValueKey('living-story-scene'),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[_ambient, _transition]),
          builder: (context, _) {
            final transition = Curves.easeInOutCubic.transform(
              _transition.value,
            );
            final ambient = _reduceMotion ? .32 : _ambient.value;
            return ExcludeSemantics(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (previous != null && transition < 1)
                    Opacity(
                      opacity: 1 - transition,
                      child: _imageLayer(
                        previous,
                        ambient,
                        transition,
                        outgoing: true,
                      ),
                    ),
                  Opacity(
                    opacity: previous == null ? 1 : transition,
                    child: _imageLayer(scene, ambient, transition),
                  ),
                  _LivingStoryAtmosphere(
                    key: ValueKey('living-story-atmosphere-${scene.id}'),
                    scene: scene,
                    progress: ambient,
                    reduceMotion: _reduceMotion,
                  ),
                  _LivingStoryDepth(
                    key: ValueKey('living-story-depth-${scene.id}'),
                    scene: scene,
                    progress: ambient,
                    reduceMotion: _reduceMotion,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _imageLayer(
    StorySceneState scene,
    double ambient,
    double transition, {
    bool outgoing = false,
  }) {
    final wave = math.sin(ambient * math.pi * 2);
    final strength = _reduceMotion ? 0.0 : scene.ambientStrength;
    final ambientOffset =
        Offset(6 * wave, 4 * math.cos(ambient * math.pi * 2)) * strength;
    final travel = _reduceMotion
        ? Offset.zero
        : scene.narrativeTravel *
            (outgoing ? transition * .35 : (1 - transition));
    final settleScale = _reduceMotion ? 1.02 : scene.cameraScale;
    final entryScale =
        scene.wideReveal ? settleScale + .035 : settleScale - .02;
    final scale = outgoing
        ? settleScale + transition * .012
        : entryScale + (settleScale - entryScale) * transition;
    return Transform.translate(
      key: ValueKey('living-story-camera-${scene.id}'),
      offset: ambientOffset + travel,
      child: Transform.scale(
        scale: scale + wave * .008 * strength,
        child: Image.asset(
          scene.assetPath,
          key: ValueKey('living-story-asset-${scene.id}'),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _LivingStoryAtmosphere extends StatelessWidget {
  const _LivingStoryAtmosphere({
    required this.scene,
    required this.progress,
    required this.reduceMotion,
    super.key,
  });

  final StorySceneState scene;
  final double progress;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final strength = reduceMotion ? 0.0 : scene.ambientStrength;
    final lightTravel = (-70 + 140 * progress) * strength;
    final shadowTravel = (90 - 180 * progress) * strength;
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(lightTravel, -10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-.7 + progress * 1.1, -.72),
                  radius: 1.05,
                  colors: [scene.lightColor, Colors.transparent],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(shadowTravel, 6),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.2, -.8),
                  end: Alignment(1.2, .55),
                  colors: [
                    Colors.transparent,
                    Color(0x17131A24),
                    Color(0x30131A24),
                    Colors.transparent,
                  ],
                  stops: [0, .32, .58, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LivingStoryDepth extends StatelessWidget {
  const _LivingStoryDepth({
    required this.scene,
    required this.progress,
    required this.reduceMotion,
    super.key,
  });

  final StorySceneState scene;
  final double progress;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final strength = reduceMotion ? 0.0 : scene.ambientStrength;
    final wave = math.sin(progress * math.pi * 2);
    return IgnorePointer(
      child: Transform.translate(
        offset: Offset(wave * 8 * strength, -wave * 3 * strength),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                scene.foregroundColor.withValues(
                  alpha: scene.foregroundColor.a * .45,
                ),
                scene.foregroundColor,
              ],
              stops: [0, .58 - .08 * scene.depthStrength, 1],
            ),
          ),
        ),
      ),
    );
  }
}

/// Founder-only PR-preview control. It never appears without sceneDebug=on.
class StorySceneDebugControls extends StatelessWidget {
  const StorySceneDebugControls({
    required this.cue,
    required this.cueCount,
    super.key,
  });

  final ValueNotifier<int> cue;
  final int cueCount;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: cue,
      builder: (context, value, _) => Container(
        key: const ValueKey('living-story-debug-controls'),
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: const Color(0xD9181010),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: const Color(0x66FFD879)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _debugButton(
              icon: Icons.chevron_left,
              onPressed: value > 0 ? () => cue.value = value - 1 : null,
            ),
            Text(
              '${value + 1}/$cueCount',
              style: const TextStyle(
                color: Color(0xFFFFD879),
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
            _debugButton(
              icon: Icons.chevron_right,
              onPressed:
                  value + 1 < cueCount ? () => cue.value = value + 1 : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _debugButton(
      {required IconData icon, required VoidCallback? onPressed}) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      iconSize: 17,
      color: const Color(0xFFFFD879),
      disabledColor: Colors.white24,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
