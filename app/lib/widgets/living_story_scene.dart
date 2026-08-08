import 'package:flutter/material.dart';

@immutable
class StorySceneState {
  const StorySceneState({
    required this.id,
    required this.assetPath,
    this.cameraOffset = Offset.zero,
    this.cameraScale = 1,
    this.lightColor = Colors.transparent,
    this.foregroundColor = Colors.transparent,
    this.calm = false,
  });

  final String id;
  final String assetPath;
  final Offset cameraOffset;
  final double cameraScale;
  final Color lightColor;
  final Color foregroundColor;
  final bool calm;
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
    required this.cues,
  });

  final String locationId;
  final String variantId;
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
    if (next == _cueIndex) return false;
    _cueIndex = next;
    notifyListeners();
    return true;
  }
}

/// A reusable, enhancement-only 2.5D layer for the shared Story screen.
class LivingStoryScene extends StatefulWidget {
  const LivingStoryScene({
    required this.variant,
    required this.progressListenable,
    required this.readProgress,
    super.key,
  });

  final StorySceneVariant variant;
  final Listenable progressListenable;
  final double Function() readProgress;

  @override
  State<LivingStoryScene> createState() => _LivingStorySceneState();
}

class _LivingStorySceneState extends State<LivingStoryScene>
    with SingleTickerProviderStateMixin {
  late StorySceneDirector _director;
  late final AnimationController _transition;
  StorySceneState? _previousScene;
  late StorySceneState _displayedScene;
  final Set<String> _requestedAssets = <String>{};
  bool _reduceMotion = false;

  @visibleForTesting
  StorySceneDirector get director => _director;

  @override
  void initState() {
    super.initState();
    _director = StorySceneDirector(widget.variant);
    _transition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      value: 1,
    );
    _director.handleProgress(widget.readProgress());
    _displayedScene = _director.scene;
    _director.addListener(_handleSceneChanged);
    widget.progressListenable.addListener(_handleProgress);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _precacheCurrentAndNext();
  }

  @override
  void didUpdateWidget(covariant LivingStoryScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.progressListenable, widget.progressListenable)) {
      oldWidget.progressListenable.removeListener(_handleProgress);
      widget.progressListenable.addListener(_handleProgress);
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
    }
  }

  void _handleProgress() {
    _director.handleProgress(widget.readProgress());
  }

  void _handleSceneChanged() {
    _previousScene = _displayedScene;
    _displayedScene = _director.scene;
    _transition
      ..duration = _reduceMotion
          ? const Duration(milliseconds: 140)
          : Duration(milliseconds: _director.scene.calm ? 1100 : 850)
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
    _director
      ..removeListener(_handleSceneChanged)
      ..dispose();
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
          animation: _transition,
          builder: (context, _) {
            final t = Curves.easeInOutCubic.transform(_transition.value);
            return Stack(
              fit: StackFit.expand,
              children: [
                if (previous != null && t < 1)
                  Opacity(opacity: 1 - t, child: _imageLayer(previous, 1)),
                Opacity(opacity: t, child: _imageLayer(scene, t)),
                IgnorePointer(
                  child: DecoratedBox(
                    key: ValueKey('living-story-light-${scene.id}'),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [scene.lightColor, Colors.transparent],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: DecoratedBox(
                    key: ValueKey('living-story-depth-${scene.id}'),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, scene.foregroundColor],
                        stops: const [.55, 1],
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

  Widget _imageLayer(StorySceneState scene, double progress) {
    final offset = _reduceMotion ? Offset.zero : scene.cameraOffset * progress;
    final scale =
        _reduceMotion ? 1.02 : 1.02 + (scene.cameraScale - 1) * progress;
    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
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
