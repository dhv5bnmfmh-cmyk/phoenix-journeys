import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_batch_two.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/lijiang_old_town_gold_content.dart';
import 'package:phoenix_journeys/data/lijiang_old_town_narrative_dna.dart';
import 'package:phoenix_journeys/data/lijiang_old_town_semantic_fingerprint.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();
  final experience = journeyExpansionBatchTwoExperiences.singleWhere(
    (item) => item.id == lijiangOldTownJourneyId,
  );

  group('Lijiang Gold governance', () {
    test('Fact First ledgers block unsupported history and protect real people', () {
      expect(lijiangSourceLedger.length, greaterThanOrEqualTo(4));
      expect(lijiangClaimLedger, isNotEmpty);
      expect(
        lijiangClaimLedger.where((row) => row['status'] != 'ALLOWED'),
        isEmpty,
      );
      expect(
        lijiangFactFictionLedger.any(
          (row) =>
              row['category'] == 'UNSUPPORTED FACTUAL CLAIM' &&
              row['status']!.startsWith('BLOCKED'),
        ),
        isTrue,
      );
      expect(
        lijiangFactFictionLedger.any(
          (row) =>
              row['category'] == 'REAL PERSON HIGH-PROTECTION' &&
              row['status'] == 'NOT USED',
        ),
        isTrue,
      );
    });

    test('three architectures are materially distinct and A is selected', () {
      expect(lijiangOldTownArchitectures, hasLength(3));
      expect(
        lijiangOldTownArchitectures.where((item) => item.selected),
        hasLength(1),
      );
      expect(lijiangOldTownArchitectures.first.selected, isTrue);
      expect(
        lijiangOldTownArchitectures.map((item) => item.engine).toSet(),
        hasLength(3),
      );
      expect(
        lijiangOldTownArchitectures.map((item) => item.choice).toSet(),
        hasLength(3),
      );
      expect(
        lijiangOldTownArchitectures.skip(1).every(
              (item) => item.rejectedReason.isNotEmpty,
            ),
        isTrue,
      );
    });

    test('selected architecture passes place and relationship causality', () {
      expect(lijiangPlaceCausalMechanism['genericPlaceTest'], startsWith('PASS'));
      expect(lijiangPlaceCausalMechanism['otherCityTest'], startsWith('PASS'));
      expect(lijiangStoryIdentityCard['PrimaryDepth'], lijiangPrimaryDepth);
      expect(lijiangSecondaryDepths.length, inInclusiveRange(1, 3));
      expect(
        lijiangStoryIdentityCard['RelationshipGeometry'],
        contains('共同所有人'),
      );
      expect(lijiangStoryIdentityCard['Choice'], contains('割断捆绳'));
      expect(lijiangStoryIdentityCard['Cost'], contains('损失交易'));
      final ending = lijiangStoryIdentityCard['EndingAction']!;
      expect(ending, contains('一人一头'));
      expect(ending, contains('抬起湿茶'));
      expect(ending, contains('没有解释句'));
    });
  });

  group('Lijiang Lv1-Lv10 Story and learning package', () {
    test('all ten levels preserve one causal spine and canonical length shape', () {
      expect(lijiangOldTownGoldLevels, hasLength(10));
      for (var level = 1; level <= 10; level++) {
        final content = lijiangOldTownGoldLevelContent(level);
        final story = content.storyParagraphs.join();
        final target = phoenixStoryLengthTargetForLevel(level);
        expect(
          content.storyParagraphs.length,
          target.paragraphCount,
          reason: 'Lv$level paragraph count',
        );
        expect(
          story.length,
          inInclusiveRange(
            target.acceptedMinimumCharacters,
            target.acceptedMaximumCharacters,
          ),
          reason: 'Lv$level story length ${story.length}',
        );
        for (final anchor in <String>[
          '和清',
          '和素',
          '茶',
          '债',
          '起火',
          '小桥',
          '割断捆绳',
          '湿茶',
          '扁担',
        ]) {
          expect(story, contains(anchor), reason: 'Lv$level missing $anchor');
        }
        expect(
          story,
          anyOf(contains('提水'), contains('水桶')),
          reason: 'Lv$level must preserve the water-to-action mechanism',
        );
        expect(content.storyAnnotations.length, content.storyParagraphs.length);
        for (final annotation in content.storyAnnotations) {
          expect(annotation.pinyin.trim(), isNotEmpty);
          expect(annotation.vietnamese.trim(), isNotEmpty);
          expect(annotation.english.trim(), isNotEmpty);
        }
      }
    });

    test('Lv1 independently proves protagonist relationship goal choice cost consequence', () {
      final story = lijiangOldTownGoldLevelContent(1).storyParagraphs.join();
      expect(story, contains('商贩和清'));
      expect(story, contains('姐姐和素'));
      expect(story, contains('明早买家离城'));
      expect(story, contains('共同的债'));
      expect(story, contains('驮货正堵着小桥'));
      expect(story, contains('割断捆绳'));
      expect(story, contains('滚进水里'));
      expect(story, contains('湿茶却卖不成了'));
      expect(story, contains('扛起扁担另一头'));
    });

    test('Lv5 is action-led and Lv10 deepens without ending explanation', () {
      final lv5 = lijiangOldTownGoldLevelContent(5).storyParagraphs.join();
      final lv10 = lijiangOldTownGoldLevelContent(10).storyParagraphs.join();
      expect(lv5, contains('她也有一半本钱压在茶包里'));
      expect(lv5, contains('替姐姐决定她那一半本钱也一起受损'));
      expect(lv10, contains('伸手像要拦，又停在半空'));
      expect(lv10, contains('让重量落在两人中间'));
      expect(lv10.endsWith('。'), isTrue);
      expect(lv10, isNot(contains('这说明')));
      expect(lv10, isNot(contains('这象征')));
      expect(lv10, isNot(contains('真正的意义')));
    });

    test('Discovery depth is 2/2/2/2 then 3 and four-language aligned', () {
      const expected = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
      for (var level = 1; level <= 10; level++) {
        final discoveries = lijiangDiscoveriesForLevel(level);
        expect(discoveries.length, expected[level - 1], reason: 'Lv$level');
        for (final item in discoveries) {
          expect(item.text.trim(), isNotEmpty);
          expect(item.pinyin.trim(), isNotEmpty);
          expect(item.vietnamese.trim(), isNotEmpty);
          expect(item.english.trim(), isNotEmpty);
        }
      }
      final lv1 = lijiangDiscoveriesForLevel(1).map((e) => e.text).join();
      final lv5 = lijiangDiscoveriesForLevel(5).map((e) => e.text).join();
      final lv10 = lijiangDiscoveriesForLevel(10).map((e) => e.text).join();
      expect(lv1, contains('世界遗产'));
      expect(lv5, contains('茶马古道'));
      expect(lv10, contains('旅游与商业'));
    });

    test('Vocabulary is active-source-only and respects level target/maximum', () {
      final allContext = <String>[
        for (var level = 1; level <= 10; level++)
          lijiangOldTownGoldLevelContent(level).storyParagraphs.join(),
        for (var level = 1; level <= 10; level++)
          lijiangDiscoveriesForLevel(level).map((entry) => entry.text).join(),
      ].join();
      for (final word in lijiangOldTownWords) {
        expect(allContext, contains(word.word), reason: word.word);
      }

      for (var level = 1; level <= 10; level++) {
        final profile = agent.profileForPhoenixLevel(level);
        final plan = agent.planFor(profile);
        final content = buildBatchOneGoldLevel(experience, profile: profile);
        final activeContext =
            '${content.storyParagraphs.join()}${content.discoveries.map((entry) => entry.text).join()}';
        expect(content.words.length, plan.targetVocabularyCount, reason: 'Lv$level target');
        expect(content.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
        for (final word in content.words) {
          expect(activeContext, contains(word.word), reason: 'Lv$level ${word.word}');
        }
      }
      final lv10 = buildBatchOneGoldLevel(
        experience,
        profile: agent.profileForPhoenixLevel(10),
      );
      expect(lv10.words.map((entry) => entry.word), contains('非物质文化'));
    });
  });

  group('Lijiang active runtime, Challenge, Memory and semantic gates', () {
    test('dedicated runtime resolves exact Gold Lv1 Lv5 Lv10 and legacy seed is inactive', () {
      expect(usesDedicatedAdaptiveJourneyRuntime(lijiangOldTownJourneyId), isTrue);
      expect(isBatchOneGoldJourney(lijiangOldTownJourneyId), isTrue);
      for (final level in <int>[1, 5, 10]) {
        final resolved = buildBatchOneGoldLevel(
          experience,
          profile: agent.profileForPhoenixLevel(level),
        );
        expect(
          resolved.storyParagraphs,
          lijiangOldTownGoldLevelContent(level).storyParagraphs,
        );
      }
      final active = lijiangOldTownGoldLevelContent(5).storyParagraphs.join();
      expect(active, isNot(contains('雨后的傍晚，你走进丽江')));
      expect(experience.storyTitle, lijiangOldTownCanonicalTitle);
    });

    test('Challenge Gold has ten-level pedagogy, unique repair options and no contamination', () {
      final profile = nonDatongGoldChallengeProfileFor(lijiangOldTownJourneyId);
      expect(profile, isNotNull);
      final gold = profile!;
      expect(gold.paragraphGoals, hasLength(10));
      expect(gold.missingGoals, hasLength(10));
      expect(gold.paragraphIntents, hasLength(10));
      expect(gold.missingIntents, hasLength(10));
      expect(gold.grammar, hasLength(10));
      expect(gold.storyDistractors.length, greaterThanOrEqualTo(6));
      for (final grammar in gold.grammar) {
        expect(grammar.correctReplacement, isNot(grammar.brokenSegment));
        expect(
          <String>{grammar.correctReplacement, ...grammar.distractors},
          hasLength(4),
        );
      }
      final challengeText = <String>[
        gold.paragraphPrompt,
        gold.missingPrompt,
        ...gold.paragraphGoals,
        ...gold.missingGoals,
        ...gold.storyDistractors.map((item) => item.text),
      ].join();
      for (final contaminant in <String>['云冈', '龙门', '开平', '西湖', '陈家祠', '拙政园']) {
        expect(challengeText, isNot(contains(contaminant)));
      }
    });

    test('Lv1 Lv5 Lv10 Challenge human anchors have different cognitive jobs', () {
      final profile = nonDatongGoldChallengeProfileFor(lijiangOldTownJourneyId)!;
      expect(profile.paragraphGoals[0], contains('顺序'));
      expect(profile.missingGoals[0], contains('直接关系'));
      expect(profile.grammar[0].errorType, contains('动作顺承'));

      expect(profile.paragraphGoals[4], contains('共同所有权'));
      expect(profile.missingGoals[4], contains('替姐姐决定'));
      expect(profile.grammar[4].errorType, contains('递进'));

      expect(profile.paragraphGoals[9], contains('不可逆选择'));
      expect(profile.missingGoals[9], contains('共同承担'));
      expect(profile.grammar[9].errorType, contains('虽然…却…'));
      expect(profile.grammar[9].whyWrong, contains('共同的债'));
    });

    test('Memory and Completion bind Story memory moment, cost and changed relationship', () {
      final spec = batchOneMemorySpecFor(lijiangOldTownJourneyId);
      expect(spec, isNotNull);
      expect(spec!.storyResult, contains('《桥空出来以后》'));
      expect(spec.culturalPoint, contains('第一只水桶'));
      expect(spec.longTermAnchor, contains('扁担'));
      expect(spec.reviews.map((item) => item.category).toSet(), containsAll(<String>[
        'choice',
        'cost',
        'place',
        'memory',
        'relationship',
      ]));
    });

    test('promoted semantic fingerprint remains collision-free against approved Gold', () {
      final gate = lijiangOldTownSemanticGate();
      expect(gate.isGoldReady, isTrue, reason: gate.status);
      expect(gate.comparisons, hasLength(12));
      expect(gate.comparisons.where((item) => item.isCollision), isEmpty);
      expect(
        approvedGoldSemanticFingerprints[lijiangOldTownJourneyId],
        same(lijiangOldTownGoldSemanticFingerprint),
      );
      expect(
        lijiangOldTownCandidateSemanticFingerprint.mechanisms.keys.toSet(),
        NarrativeSemanticDimension.values.toSet(),
      );
      expect(
        lijiangOldTownCandidateSemanticFingerprint.coreEvidence
            .map((e) => e.dimension)
            .toSet(),
        containsAll(narrativeSemanticCoreDimensions),
      );
    });

    test('Founder-approved merged Lijiang is in both approved Gold registries', () {
      expect(lijiangNarrativeDnaIsUniqueAgainstApproved(), isTrue);
      expect(
        approvedNarrativeDnaCatalog.any(
          (record) => record.journeyId == lijiangOldTownJourneyId,
        ),
        isTrue,
      );
      expect(
        approvedGoldSemanticFingerprints.containsKey(lijiangOldTownJourneyId),
        isTrue,
      );
    });
  });
}
