import 'package:flutter/material.dart';

import '../widgets/living_story_scene.dart';

const _base = 'assets/images/backgrounds/generated/beijing/forbidden-city';

/// Location assets are reusable by many story variants. Choreography lives in
/// [forbiddenCityCanonicalStoryVariant], not in the shared Story renderer.
abstract final class ForbiddenCityWorldPack {
  static const entrance = '$_base/07-clear-morning.webp';
  static const outerCourt = '$_base/03-golden-gate.webp';
  static const supremeHarmony = '$_base/08-sunlit-corridor.webp';
  static const heavenlyPurityGate = '$_base/09-misty-courtyard.webp';
  static const innerCourt = '$_base/05-after-rain.webp';
  static const threshold = '$_base/02-moonlit-palace.webp';
  static const eveningMap = '$_base/10-sunset-panorama.webp';
}

const forbiddenCityCanonicalStoryVariant = StorySceneVariant(
  locationId: 'beijing-forbidden-city',
  variantId: 'canonical-001',
  cues: <StorySceneCue>[
    StorySceneCue(
      progress: 0,
      scene: StorySceneState(
        id: 'meridian-gate',
        assetPath: ForbiddenCityWorldPack.entrance,
        cameraOffset: Offset(0, -4),
        cameraScale: 1.035,
        lightColor: Color(0x38FFE0A3),
        foregroundColor: Color(0x341A0D0A),
      ),
    ),
    StorySceneCue(
      progress: .12,
      scene: StorySceneState(
        id: 'outer-court-axis',
        assetPath: ForbiddenCityWorldPack.outerCourt,
        cameraOffset: Offset(-3, -6),
        cameraScale: 1.045,
        lightColor: Color(0x32FFE6B2),
        foregroundColor: Color(0x3B1F0E0A),
      ),
    ),
    StorySceneCue(
      progress: .28,
      scene: StorySceneState(
        id: 'supreme-harmony',
        assetPath: ForbiddenCityWorldPack.supremeHarmony,
        cameraOffset: Offset(2, -2),
        cameraScale: 1.02,
        lightColor: Color(0x29FFDDA0),
        foregroundColor: Color(0x3D1C0E09),
        calm: true,
      ),
    ),
    StorySceneCue(
      progress: .44,
      scene: StorySceneState(
        id: 'heavenly-purity-gate',
        assetPath: ForbiddenCityWorldPack.heavenlyPurityGate,
        cameraOffset: Offset(3, -3),
        cameraScale: 1.03,
        lightColor: Color(0x1ED6C6AA),
        foregroundColor: Color(0x4A170C0B),
      ),
    ),
    StorySceneCue(
      progress: .58,
      scene: StorySceneState(
        id: 'inner-court',
        assetPath: ForbiddenCityWorldPack.innerCourt,
        cameraOffset: Offset(-2, -3),
        cameraScale: 1.035,
        lightColor: Color(0x1CCEC7B0),
        foregroundColor: Color(0x55130C0B),
      ),
    ),
    StorySceneCue(
      progress: .73,
      scene: StorySceneState(
        id: 'open-threshold',
        assetPath: ForbiddenCityWorldPack.threshold,
        cameraScale: 1.01,
        lightColor: Color(0x12C9C2B2),
        foregroundColor: Color(0x6410090A),
        calm: true,
      ),
    ),
    StorySceneCue(
      progress: .9,
      scene: StorySceneState(
        id: 'evening-map',
        assetPath: ForbiddenCityWorldPack.eveningMap,
        cameraOffset: Offset(0, 2),
        cameraScale: 1.015,
        lightColor: Color(0x28D68B72),
        foregroundColor: Color(0x66100A14),
        calm: true,
      ),
    ),
  ],
);
