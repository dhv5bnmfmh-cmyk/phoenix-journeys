import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_temple_of_heaven_story.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';

void main() {
  const engine = JourneyChallengeEngine();
  const auditor = ChallengeAntiTemplateAuditor();

  ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
        track: ChineseExamTrack.hsk,
        levelCode: '$level',
        levelLabel: '$level',
        band: level <= 2
            ? PhoenixReadingBand.beginner
            : level <= 4
                ? PhoenixReadingBand.elementary
                : level <= 6
                    ? PhoenixReadingBand.intermediate
                    : level <= 8
                        ? PhoenixReadingBand.upperIntermediate
                        : PhoenixReadingBand.advanced,
        phoenixLevel: level,
      );

  test('Temple registry resolves the authored Journey without fallback', () {
    final journey = requireDailyJourneyExperience(templeOfHeavenJourneyId);

    expect(journey.storyTitle, templeOfHeavenCanonicalTitle);
    expect(journey.place, '天坛');
    expect(journey.content.id, templeOfHeavenJourneyId);
    expect(journey.content.sections, isNotEmpty);
  });

  test('Temple registry binds to a place GeoNode with coordinates', () {
    final journey = requireDailyJourneyExperience(templeOfHeavenJourneyId);
    final node = worldGeoCatalog.singleWhere(
      (item) => item.id == 'cn-beijing-dongcheng-temple-of-heaven',
    );

    expect(journey.geoNodeId, node.id);
    expect(node.isPlace, isTrue);
    expect(node.latitude, isNotNull);
    expect(node.longitude, isNotNull);
  });

  test('Temple Lv1-Lv10 keep one context and authored 2x6 dispatch', () {
    final storyFingerprints = <String>{};
    final challengeFingerprints = <String>{};
    final levels = <StoryChallengeSet>[];

    for (var level = 1; level <= 10; level += 1) {
      final prepared = JourneyPreparationCoordinator.instance.prepareNow(
        journeyId: templeOfHeavenJourneyId,
        profile: profile(level),
        scriptMode: 'simplified',
      );
      final challenge = engine.build(
        journeyId: templeOfHeavenJourneyId,
        sessionLevel: level,
        storyParagraphs: prepared.challengeSourceMaterial,
      );
      levels.add(challenge);

      expect(prepared.key.phoenixLevel, level, reason: 'Lv$level key');
      expect(
        prepared.levelContent.storyParagraphs,
        templeStoryParagraphsByLevel[level - 1],
        reason: 'Lv$level Story',
      );
      expect(prepared.levelContent.storyAnnotations.length,
          prepared.levelContent.storyParagraphs.length,
          reason: 'Lv$level annotations');
      expect(prepared.levelContent.words, isNotEmpty,
          reason: 'Lv$level Vocabulary');
      expect(prepared.levelContent.discoveries,
          hasLength(level <= 4 ? 2 : 3),
          reason: 'Lv$level Discovery');
      expect(challenge.journeyId, templeOfHeavenJourneyId);
      expect(challenge.sessionLevel, level);
      expect(challenge.questions, hasLength(12), reason: 'Lv$level count');
      expect(auditor.audit(challenge).passed, isTrue,
          reason: 'Lv$level anti-template');
      for (final mode in StoryChallengeMode.values) {
        expect(challenge.questions.where((item) => item.mode == mode),
            hasLength(2),
            reason: 'Lv$level ${mode.name}');
      }

      storyFingerprints.add(prepared.levelContent.storyParagraphs.join());
      challengeFingerprints
          .add(challenge.questions.map((item) => item.id).join('|'));
    }

    expect(storyFingerprints, hasLength(10));
    expect(challengeFingerprints, hasLength(10));
    expect(auditor.auditMatrix(levels).passed, isTrue);
  });

  test('Temple feedback and cross-Story fingerprints remain unique', () {
    final templeFingerprints = <String>{};
    final forbiddenFingerprints = <String>{};

    for (var level = 1; level <= 10; level += 1) {
      final prepared = JourneyPreparationCoordinator.instance.prepareNow(
        journeyId: templeOfHeavenJourneyId,
        profile: profile(level),
        scriptMode: 'simplified',
      );
      final temple = engine.build(
        journeyId: templeOfHeavenJourneyId,
        sessionLevel: level,
        storyParagraphs: prepared.challengeSourceMaterial,
      );
      final forbidden = engine.build(
        journeyId: forbiddenCityJourneyId,
        sessionLevel: level,
        storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
      );

      for (final item in temple.questions) {
        templeFingerprints.add(_crossStoryFingerprint(item));
        if (item.options.isNotEmpty) {
          expect(item.distractorRationales, hasLength(4), reason: item.id);
          expect(item.distractorRationales.toSet(), hasLength(4),
              reason: item.id);
          const genericFeedback = <String>{
            '与证据不一致',
            '不正确',
            '回答错误',
            '再想想',
          };
          expect(
            item.distractorRationales.every(
              (rationale) =>
                  rationale.trim().isNotEmpty &&
                  !genericFeedback.contains(rationale.trim()),
            ),
            isTrue,
            reason: item.id,
          );
        }
      }
      forbiddenFingerprints.addAll(
        forbidden.questions.map(_crossStoryFingerprint),
      );
    }

    expect(templeFingerprints, hasLength(120));
    expect(templeFingerprints.intersection(forbiddenFingerprints), isEmpty);
  });

  test('Grammar repair preserves Step 1 and Step 2 authoring evidence', () {
    for (var level = 1; level <= 10; level += 1) {
      final prepared = JourneyPreparationCoordinator.instance.prepareNow(
        journeyId: templeOfHeavenJourneyId,
        profile: profile(level),
        scriptMode: 'simplified',
      );
      final grammar = engine
          .build(
            journeyId: templeOfHeavenJourneyId,
            sessionLevel: level,
            storyParagraphs: prepared.challengeSourceMaterial,
          )
          .questions
          .where((item) => item.mode == StoryChallengeMode.grammarRepair);

      for (final item in grammar) {
        expect(item.errorSegments, hasLength(4), reason: item.id);
        expect(item.errorSegmentIndex, inInclusiveRange(0, 3),
            reason: item.id);
        expect(item.errorSegments.join(), item.prompt, reason: item.id);
        expect(item.options, hasLength(4), reason: item.id);
        expect(item.options.where((option) => option == item.answer),
            hasLength(1),
            reason: item.id);
        expect(item.grammarWhyWrong, isNotEmpty, reason: item.id);
        expect(item.grammarRevisionRule, isNotEmpty, reason: item.id);
        expect(item.grammarOptionExplanations, hasLength(4), reason: item.id);
      }
    }
  });

  test('Temple Memory Anchor is unique and reaches the final Story level', () {
    expect(templeOfHeavenMemoryAnchor, isNotEmpty);
    expect(templeOfHeavenMemoryAnchor, contains('删掉'));
    expect(templeOfHeavenMemoryAnchor, contains('圜丘'));
    expect(templeOfHeavenMemoryAnchor, contains('祈谷'));
    expect(templeOfHeavenMemoryAnchor, contains('冬至祭天'));
    expect(
      templeStoryParagraphsByLevel.last.join(),
      contains('最漂亮的镜头'),
    );
    expect(
      forbiddenCityLockedStories.join(),
      isNot(contains(templeOfHeavenMemoryAnchor)),
    );
  });

  test('Forbidden City authored dispatch remains unchanged', () {
    for (var level = 1; level <= 10; level += 1) {
      final set = engine.build(
        journeyId: forbiddenCityJourneyId,
        sessionLevel: level,
        storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
      );
      expect(set.journeyId, forbiddenCityJourneyId);
      expect(set.sessionLevel, level);
      expect(set.questions, hasLength(12));
      for (final mode in StoryChallengeMode.values) {
        expect(set.questions.where((item) => item.mode == mode), hasLength(2));
      }
    }
  });
}

String _crossStoryFingerprint(StoryChallengeQuestion item) => <String>[
      item.mode.name,
      item.prompt,
      item.answer,
      item.options.join('|'),
      item.reasoningTarget,
      item.whyCorrect,
    ]
        .join('|')
        .replaceAll(
          RegExp(r'沈砚|阿宁|周师傅|林桥|何予|小满'),
          '<PERSON>',
        )
        .replaceAll(
          RegExp(r'紫禁城|午门|乾清门|中轴|外朝|内廷|东侧|天坛|祈年殿|圜丘|皇穹宇'),
          '<PLACE>',
        )
        .replaceAll(RegExp(r'[，。！？：；、“”\s]'), '')
        .toLowerCase();
