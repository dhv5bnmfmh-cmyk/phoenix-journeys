import 'package:flutter/material.dart';

import '../widgets/living_story_scene.dart';
import 'forbidden_city_journey_runtime.dart';

const _base = 'assets/images/backgrounds/generated/beijing/forbidden-city';

/// Location assets are reusable by many story variants. Per-level cue metadata
/// is cached below and remains separate from the shared Story runtime.
abstract final class ForbiddenCityWorldPack {
  static const entrance = '$_base/07-clear-morning.webp';
  static const outerCourt = '$_base/03-golden-gate.webp';
  static const supremeHarmony = '$_base/08-sunlit-corridor.webp';
  static const heavenlyPurityGate = '$_base/09-misty-courtyard.webp';
  static const innerCourt = '$_base/05-after-rain.webp';
  static const threshold = '$_base/02-moonlit-palace.webp';
  static const eveningMap = '$_base/10-sunset-panorama.webp';
}

const _meridianGate = StorySceneState(
  id: 'meridian-gate',
  assetPath: ForbiddenCityWorldPack.entrance,
  narrativeTravel: Offset(0, 18),
  cameraScale: 1.065,
  lightColor: Color(0x5AFFF0C7),
  foregroundColor: Color(0x461A0D0A),
  transitionDuration: Duration(milliseconds: 2600),
  depthStrength: .8,
);

const _outerCourt = StorySceneState(
  id: 'outer-court-axis',
  assetPath: ForbiddenCityWorldPack.outerCourt,
  narrativeTravel: Offset(0, 20),
  cameraScale: 1.07,
  lightColor: Color(0x52FFE7AD),
  foregroundColor: Color(0x501F0E0A),
  transitionDuration: Duration(milliseconds: 3000),
  depthStrength: .72,
);

const _supremeHarmony = StorySceneState(
  id: 'supreme-harmony',
  assetPath: ForbiddenCityWorldPack.supremeHarmony,
  narrativeTravel: Offset(-12, 4),
  cameraScale: 1.035,
  lightColor: Color(0x46FFE4A5),
  foregroundColor: Color(0x481C0E09),
  transitionDuration: Duration(milliseconds: 3200),
  ambientStrength: .55,
  depthStrength: .55,
  wideReveal: true,
);

const _heavenlyPurityGate = StorySceneState(
  id: 'heavenly-purity-gate',
  assetPath: ForbiddenCityWorldPack.heavenlyPurityGate,
  narrativeTravel: Offset(10, 16),
  cameraScale: 1.065,
  lightColor: Color(0x37E6D6B5),
  foregroundColor: Color(0x62170C0B),
  transitionDuration: Duration(milliseconds: 2700),
  depthStrength: 1.12,
);

const _innerCourt = StorySceneState(
  id: 'inner-court',
  assetPath: ForbiddenCityWorldPack.innerCourt,
  narrativeTravel: Offset(-14, 10),
  cameraScale: 1.06,
  lightColor: Color(0x30D9D3BF),
  foregroundColor: Color(0x72130C0B),
  transitionDuration: Duration(milliseconds: 2500),
  ambientStrength: .7,
  depthStrength: 1.35,
);

const _openThreshold = StorySceneState(
  id: 'open-threshold',
  assetPath: ForbiddenCityWorldPack.threshold,
  narrativeTravel: Offset(0, 18),
  cameraScale: 1.055,
  lightColor: Color(0x4BDDD4BE),
  foregroundColor: Color(0x7A10090A),
  transitionDuration: Duration(milliseconds: 2800),
  ambientStrength: .5,
  depthStrength: 1.5,
);

const _thresholdApproach = StorySceneState(
  id: 'threshold-approach',
  assetPath: ForbiddenCityWorldPack.threshold,
  narrativeTravel: Offset(0, 14),
  cameraScale: 1.07,
  lightColor: Color(0x3DDDD4BE),
  foregroundColor: Color(0x8210090A),
  transitionDuration: Duration(milliseconds: 2600),
  ambientStrength: .32,
  depthStrength: 1.55,
);

const _thresholdStillness = StorySceneState(
  id: 'threshold-stillness',
  assetPath: ForbiddenCityWorldPack.threshold,
  narrativeTravel: Offset.zero,
  cameraScale: 1.07,
  lightColor: Color(0x24D7D0C1),
  foregroundColor: Color(0x8610090A),
  transitionDuration: Duration(milliseconds: 1900),
  ambientStrength: .04,
  depthStrength: 1.55,
);

const _eveningMap = StorySceneState(
  id: 'evening-map',
  assetPath: ForbiddenCityWorldPack.eveningMap,
  narrativeTravel: Offset(0, -10),
  cameraScale: 1.04,
  lightColor: Color(0x4AC27B64),
  foregroundColor: Color(0x7A100A14),
  transitionDuration: Duration(milliseconds: 3500),
  ambientStrength: .38,
  depthStrength: .75,
  wideReveal: true,
);

const _scenes = <StorySceneState>[
  _meridianGate,
  _outerCourt,
  _supremeHarmony,
  _heavenlyPurityGate,
  _innerCourt,
  _openThreshold,
  _thresholdApproach,
  _thresholdStillness,
  _eveningMap,
];

const _fallbackProgress = <double>[0, .1, .2, .32, .4, .55, .67, .76, .88];

const _anchors = <List<String>>[
  <String>[],
  <String>['沿中轴进入外朝', '外朝沿中轴展开', '到了外朝', '进入外朝'],
  <String>['太和殿前', '太和殿'],
  <String>['乾清门'],
  <String>['转入内廷', '进入内廷', '内廷'],
  <String>[
    '一道本来不该进的门忽然开了',
    '一道通往更深宫院的门暂时打开',
    '一道平日不该进入的宫门暂时打开',
    '一道通往更深宫院的门意外敞开',
    '一道通往更深宫院的门暂时敞开',
    '一道平日不属于沈砚行动范围的门暂时打开',
    '一道通往更深宫院的门临时敞开',
  ],
  <String>['走到门槛前', '他向前走到门槛', '他走到门槛'],
  <String>[
    '却停下了',
    '最终没有跨过去',
    '于是沈砚没有跨过门槛',
    '于是他没有跨过去',
    '沈砚没有跨过去',
    '沈砚停下，没有跨过门槛',
    '他没有跨过门槛',
  ],
  <String>['傍晚', '第二张地图', '第二张图'],
];

int _firstAnchorOffset(String story, List<String> anchors) {
  var best = -1;
  for (final anchor in anchors) {
    final offset = story.indexOf(anchor);
    if (offset >= 0 && (best < 0 || offset < best)) best = offset;
  }
  return best;
}

StorySceneVariant _timelineForLevel(int level) {
  final story = forbiddenCityLockedStories[level - 1];
  var previous = 0.0;
  final cues = <StorySceneCue>[];
  for (var index = 0; index < _scenes.length; index += 1) {
    final offset = index == 0 ? 0 : _firstAnchorOffset(story, _anchors[index]);
    final anchored =
        offset < 0 ? _fallbackProgress[index] : offset / story.length;
    final progress =
        index == 0 ? 0.0 : mathMax(previous + .018, anchored).clamp(0.0, .96);
    cues.add(StorySceneCue(progress: progress, scene: _scenes[index]));
    previous = progress;
  }
  return StorySceneVariant(
    locationId: forbiddenCityJourneyId,
    variantId: 'canonical-001',
    level: level,
    cues: List<StorySceneCue>.unmodifiable(cues),
  );
}

double mathMax(double a, double b) => a > b ? a : b;

/// Constructed once at library initialization, never in narration hot paths.
final List<StorySceneVariant> forbiddenCityStoryVariantsByLevel =
    List<StorySceneVariant>.unmodifiable(
  List<StorySceneVariant>.generate(10, (index) => _timelineForLevel(index + 1)),
);

StorySceneVariant forbiddenCityStoryVariantForLevel(int level) =>
    forbiddenCityStoryVariantsByLevel[level.clamp(1, 10).toInt() - 1];

/// Compatibility alias for architecture checks and existing callers.
final StorySceneVariant forbiddenCityCanonicalStoryVariant =
    forbiddenCityStoryVariantsByLevel[4];
