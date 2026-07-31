import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/special_journey_catalog.dart';
import 'package:phoenix_journeys/data/special_journey_story_enrichment_story_system.dart';

void main() {
  test('Story System classifies every published special journey', () {
    expect(
      storySystemSpecialJourneyIds,
      specialJourneyExperiences.map((journey) => journey.id).toSet(),
    );
    expect(storySystemSpecialJourneyIds, hasLength(9));

    for (final journeyId in storySystemSpecialJourneyIds) {
      expect(
        specialJourneyStoryEnrichmentForStorySystem(journeyId),
        isNotEmpty,
        reason: '$journeyId needs type-specific short-text enrichment',
      );
    }
  });

  test('all special Journey levels stay out of ordinary city filler', () {
    const ordinaryFiller = <String>[
      '你先停下来，看看四周的颜色、声音和人。',
      '脚步慢下来以后，原来没有注意的细节开始出现。',
      '近处的门窗、台阶和道路告诉你，人们怎样进入和离开这里。',
      '建筑材料留下磨损和修补的痕迹',
    ];

    for (final journey in specialJourneyExperiences) {
      for (final profile in PhoenixLanguageLevelAgent.phoenixProfiles) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final story = content.storyParagraphs.join();

        for (final filler in ordinaryFiller) {
          expect(
            story,
            isNot(contains(filler)),
            reason: '${journey.id} ${profile.displayLabel} used ordinary filler',
          );
        }
        expect(
          content.storyAnnotations,
          hasLength(content.storyParagraphs.length),
          reason: '${journey.id} ${profile.displayLabel} annotation alignment',
        );
        for (final annotation in content.storyAnnotations) {
          expect(annotation.pinyin.trim(), isNotEmpty);
          expect(annotation.vietnamese.trim(), isNotEmpty);
          expect(annotation.english.trim(), isNotEmpty);
        }
      }
    }
  });

  test('the five repaired special journeys use dedicated Lv.10 enrichment', () {
    const repairedIds = <String>{
      'changan-last-bus',
      'tide-letter',
      'arcade-lost-property',
      'tea-horse-echo',
      'ice-city-star-map',
    };
    final mastery = PhoenixLanguageLevelAgent.phoenixProfiles.last;

    for (final journey in specialJourneyExperiences.where(
      (item) => repairedIds.contains(item.id),
    )) {
      final dedicated = specialJourneyStoryEnrichmentForStorySystem(journey.id);
      final story = resolveAdaptiveJourneyLevel(
        journey,
        profile: mastery,
      ).storyParagraphs.join();

      expect(dedicated, isNotEmpty);
      expect(
        story,
        contains(dedicated.first.chinese),
        reason: '${journey.id} did not use its dedicated Story System text',
      );
    }
  });
}
