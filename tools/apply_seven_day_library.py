from pathlib import Path
import re

CATALOG = Path('app/lib/data/daily_journey_catalog.dart')
RULE = Path('worker/daily_journey_engine_rule.test.mjs')
TEST = Path('app/test/seven_day_journey_catalog_test.dart')

catalog = CATALOG.read_text(encoding='utf-8')

if "import 'extended_journey_catalog.dart';" not in catalog:
    catalog = catalog.replace(
        "import 'beijing_story_catalog.dart';\nimport 'journey_data.dart';\n",
        "import 'beijing_story_catalog.dart';\n"
        "import 'daily_journey_experience.dart';\n"
        "import 'extended_journey_catalog.dart';\n"
        "import 'journey_data.dart';\n",
        1,
    )

catalog, count = re.subn(
    r"\nclass DailyJourneyExperience \{.*?\n\}\n\nconst shanghaiStorySources",
    "\nconst shanghaiStorySources",
    catalog,
    count=1,
    flags=re.S,
)
if count not in (0, 1):
    raise RuntimeError('unexpected DailyJourneyExperience class count')
if 'class DailyJourneyExperience' in catalog:
    raise RuntimeError('DailyJourneyExperience class was not extracted')

if '...extendedJourneySources' not in catalog:
    catalog = catalog.replace(
        "  ...xianStorySources,\n];",
        "  ...xianStorySources,\n  ...extendedJourneySources,\n];",
        1,
    )
if '...extendedJourneyRecords' not in catalog:
    catalog = catalog.replace(
        "  xianCityWallJourney,\n];",
        "  xianCityWallJourney,\n  ...extendedJourneyRecords,\n];",
        1,
    )
if '...extendedJourneyExperiences' not in catalog:
    marker = "  ),\n];\n\nDailyJourneyExperience requireDailyJourneyExperience"
    replacement = (
        "  ),\n"
        "  ...extendedJourneyExperiences,\n"
        "];\n\n"
        "DailyJourneyExperience requireDailyJourneyExperience"
    )
    if marker not in catalog:
        raise RuntimeError('dailyJourneyExperiences closing marker not found')
    catalog = catalog.replace(marker, replacement, 1)

CATALOG.write_text(catalog, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const extended = readFileSync('app/lib/data/extended_journey_catalog.dart', 'utf8');
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');

test('daily catalog contains a reviewed seven-day city cycle', () => {
  assert.match(catalog, /beijingForbiddenCityJourney/);
  assert.match(catalog, /shanghai-bund/);
  assert.match(catalog, /xian-city-wall/);
  assert.match(catalog, /extendedJourneyExperiences/);
  assert.match(extended, /hangzhou-west-lake/);
  assert.match(extended, /chengdu-kuanzhai-alley/);
  assert.match(extended, /nanjing-qinhuai-river/);
  assert.match(extended, /guangzhou-chen-clan-academy/);
  assert.match(catalog, /dailyJourneyForDate/);
  assert.match(catalog, /dailyJourneyExperiences\.length/);
});

test('new journeys include authoritative sources and complete study stages', () => {
  assert.match(extended, /StorySourceKind\.unesco/);
  assert.ok((extended.match(/StorySourceKind\.government/g) ?? []).length >= 3);
  assert.ok((extended.match(/storyAnnotations:/g) ?? []).length >= 4);
  assert.ok((extended.match(/words:/g) ?? []).length >= 4);
  assert.ok((extended.match(/discoveries:/g) ?? []).length >= 4);
  assert.ok((extended.match(/wonderQuestion:/g) ?? []).length >= 4);
  assert.ok((extended.match(/expressQuestion:/g) ?? []).length >= 4);
});

test('daily progress, Agent feedback and stamps are namespaced by journey id', () => {
  assert.match(state, /journey\.\$\{journeyId \?\? activeJourneyId\}/);
  assert.match(state, /earnedJourneyStampIds/);
  assert.match(state, /saveGuideFeedback/);
  assert.match(state, /saveWritingFeedback/);
  assert.match(state, /activateJourney/);
});

test('one stable Journey screen renders every city', () => {
  assert.match(journey, /final String\? journeyId/);
  assert.match(journey, /DailyJourneyExperience _experience/);
  assert.match(journey, /_experience\.storyAnnotations/);
  assert.match(journey, /_experience\.words/);
  assert.match(journey, /_experience\.discoveries/);
  assert.match(journey, /AnimatedCityJourneyStamp/);
});

test('Explore opens every selected city journey', () => {
  assert.match(explore, /openJourneyById\(String journeyId\)/);
  assert.match(explore, /state\.activateJourney\(journeyId\)/);
  assert.match(explore, /JourneyScreen\(journeyId: journeyId\)/);
  assert.match(explore, /dailyJourneyExperiences\.map/);
  assert.doesNotMatch(journey, /单屏模式/);
});
""", encoding='utf-8')

TEST.write_text("""import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  test('seven reviewed journeys rotate without repeating during one week', () {
    expect(dailyJourneyExperiences, hasLength(7));
    expect(dailyJourneyExperiences.map((item) => item.id).toSet(), hasLength(7));

    final week = List.generate(
      7,
      (index) => dailyJourneyForDate(DateTime(2026, 1, 1 + index)).id,
    );
    expect(week.toSet(), hasLength(7));
  });

  test('every journey has complete story and learning content', () {
    for (final journey in dailyJourneyExperiences) {
      expect(journey.content.storyParagraphs.length, 4, reason: journey.id);
      expect(
        journey.storyAnnotations.length,
        journey.content.storyParagraphs.length,
        reason: journey.id,
      );
      expect(journey.words.length, greaterThanOrEqualTo(9), reason: journey.id);
      expect(
        journey.discoveries.length,
        greaterThanOrEqualTo(4),
        reason: journey.id,
      );
      expect(journey.wonderQuestion.trim(), isNotEmpty, reason: journey.id);
      expect(journey.expressQuestion.trim(), isNotEmpty, reason: journey.id);
    }
  });

  test('all published records use verified source ids', () {
    final sourceIds = dailyStorySources.map((item) => item.id).toSet();
    for (final record in dailyJourneyRecords) {
      expect(record.sourceIds, isNotEmpty, reason: record.id);
      expect(sourceIds.containsAll(record.sourceIds), isTrue, reason: record.id);
    }
  });
}
""", encoding='utf-8')
