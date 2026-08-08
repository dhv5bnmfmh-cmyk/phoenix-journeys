# Forbidden City Living Story baseline

Starting main: `b63a8ba60edbb569200698b27a4fc05da9ef1e4e`.

- Shared Story component: `JourneyScreen._defaultStoryPage`.
- Shared narration runtime: `NarrationController` and cached `NarrationItem` lists.
- Shared cinematic reveal: `InteractiveStoryText`.
- Shared progress model: `JourneyScreen.step` backed by `AppState`.
- Forbidden City level snapshots: `forbidden_city_content_cache.dart`.
- Background architecture: `DestinationBackground`; stable Forbidden City,
  Summer Palace, and Shanghai implementations each own one destination motion
  controller.
- Narration progress rebuilds the compact Story text region and narration card,
  but cached level content and narration items retain identity.
- Background assets are selected by `JourneyBackgroundPolicy`, decoded through
  Flutter's image cache, and preloaded once by destination widgets.

The prototype preserves all content/runtime surfaces and changes only the
Forbidden City Story background path.
