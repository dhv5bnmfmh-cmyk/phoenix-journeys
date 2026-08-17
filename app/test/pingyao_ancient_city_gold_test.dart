import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_batch_four.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/pingyao_ancient_city_gold_content.dart';
import 'package:phoenix_journeys/data/pingyao_ancient_city_narrative_dna.dart';
import 'package:phoenix_journeys/data/pingyao_ancient_city_semantic_fingerprint.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();
  final experience = journeyExpansionBatchFourExperiences.singleWhere(
    (item) => item.id == pingyaoAncientCityJourneyId,
  );

  group('Pingyao Fact First, A/B/C and Story identity', () {
    test('authoritative ledgers protect the historical world and ordinary fiction', () {
      expect(pingyaoSourceLedger, hasLength(3));
      expect(pingyaoClaimLedger.where((row) => !row['status']!.startsWith('ALLOWED')), isEmpty);
      expect(
        pingyaoFactFictionLedger.any(
          (row) => row['category'] == 'REAL PERSON HIGH-PROTECTION' && row['status'] == 'NOT USED',
        ),
        isTrue,
      );
      expect(
        pingyaoFactFictionLedger.any(
          (row) => row['category'] == 'UNSUPPORTED FACTUAL CLAIM' && row['status']!.startsWith('BLOCKED'),
        ),
        isTrue,
      );
    });

    test('three architectures are materially distinct and A is selected', () {
      expect(pingyaoAncientCityArchitectures, hasLength(3));
      expect(pingyaoAncientCityArchitectures.where((item) => item.selected), hasLength(1));
      expect(pingyaoAncientCityArchitectures.first.selected, isTrue);
      expect(pingyaoAncientCityArchitectures.map((item) => item.engine).toSet(), hasLength(3));
      expect(pingyaoAncientCityArchitectures.map((item) => item.choice).toSet(), hasLength(3));
      expect(pingyaoAncientCityArchitectures.skip(1).every((item) => item.rejectedReason.isNotEmpty), isTrue);
    });

    test('place, depth and relationship causality all change decisive action', () {
      expect(pingyaoPlaceCausalMechanism['genericPlaceTest'], startsWith('PASS'));
      expect(pingyaoPlaceCausalMechanism['otherCityTest'], startsWith('PASS'));
      expect(pingyaoStoryIdentityCard['PrimaryDepth'], pingyaoPrimaryDepth);
      expect(pingyaoSecondaryDepths.length, inInclusiveRange(1, 3));
      expect(pingyaoDepthActionGate['result'], startsWith('PASS'));
      expect(pingyaoRelationshipCausalityGate['result'], startsWith('PASS'));
      expect(pingyaoStoryIdentityCard['Choice'], contains('汇票'));
      expect(pingyaoStoryIdentityCard['Cost'], contains('账本'));
      expect(pingyaoStoryIdentityCard['MemoryMoment'], contains('银箱'));
    });
  });

  group('Pingyao Lv1-Lv10 Story, Discovery and vocabulary', () {
    test('ten levels preserve one human causal spine and canonical length', () {
      expect(pingyaoAncientCityGoldLevels, hasLength(10));
      for (var level = 1; level <= 10; level++) {
        final content = pingyaoAncientCityGoldLevelContent(level);
        final story = content.storyParagraphs.join();
        final target = phoenixStoryLengthTargetForLevel(level);
        expect(content.storyParagraphs.length, target.paragraphCount, reason: 'Lv$level paragraphs');
        expect(
          story.length,
          inInclusiveRange(target.acceptedMinimumCharacters, target.acceptedMaximumCharacters),
          reason: 'Lv$level story length ${story.length}',
        );
        for (final anchor in <String>['程砚','程岳','母亲','银两','票号','汇票','账本']) {
          expect(story, contains(anchor), reason: 'Lv$level missing $anchor');
        }
        expect(content.storyAnnotations.length, content.storyParagraphs.length);
        for (final annotation in content.storyAnnotations) {
          expect(annotation.pinyin.trim(), isNotEmpty);
          expect(annotation.vietnamese.trim(), isNotEmpty);
          expect(annotation.english.trim(), isNotEmpty);
        }
      }
    });

    test('Lv1 independently proves human, place, choice, cost and visible consequence', () {
      final story = pingyaoAncientCityGoldLevelContent(1).storyParagraphs.join();
      expect(story, contains('母亲病着'));
      expect(story, contains('北京的一笔货款'));
      expect(story, contains('把银两存进票号'));
      expect(story, contains('换成汇票'));
      expect(story, contains('银箱留在店里'));
      expect(story, contains('抱走自己的账本'));
      expect(story, contains('不再共用一本账'));
      expect(story, isNot(contains('这说明')));
    });

    test('Lv5 is literary and Lv10 deepens without explanatory tail', () {
      final lv5 = pingyaoAncientCityGoldLevelContent(5).storyParagraphs.join();
      final lv10 = pingyaoAncientCityGoldLevelContent(10).storyParagraphs.join();
      expect(lv5, contains('只要继续用身体押着银两'));
      expect(lv5, contains('这笔以后各记各的'));
      expect(lv10, contains('用身体证明亲属责任'));
      expect(lv10, contains('制度可以替一箱银两跨过距离'));
      expect(lv10, endsWith('两本账安静地分开。'));
      expect(lv10, isNot(contains('这说明')));
      expect(lv10, isNot(contains('真正的意义')));
    });

    test('Discovery follows 2/2/2/2/3 and keeps one progressive theme per level', () {
      const expected = <int>[2,2,2,2,3,3,3,3,3,3];
      for (var level = 1; level <= 10; level++) {
        final rows = pingyaoDiscoveriesForLevel(level);
        expect(rows.length, expected[level - 1], reason: 'Lv$level');
        for (final row in rows) {
          expect(row.text.trim(), isNotEmpty);
          expect(row.pinyin.trim(), isNotEmpty);
          expect(row.vietnamese.trim(), isNotEmpty);
          expect(row.english.trim(), isNotEmpty);
        }
      }
      expect(pingyaoDiscoveriesForLevel(1).map((e) => e.text).join(), contains('金融中心'));
      expect(pingyaoDiscoveriesForLevel(5).map((e) => e.text).join(), contains('谁必须离开'));
      expect(pingyaoDiscoveriesForLevel(10).map((e) => e.text).join(), contains('虚构普通人'));
      expect(pingyaoAncientCityAllDiscoveries, hasLength(26));
    });

    test('Vocabulary meets every target and remains active-source-only', () {
      const targets = <int>[4,5,6,7,9,10,11,14,15,16];
      for (var level = 1; level <= 10; level++) {
        final active = pingyaoAncientCityGoldLevelContent(level);
        final context = '${active.storyParagraphs.join()}${active.discoveries.map((entry) => entry.text).join()}';
        expect(active.words.length, targets[level - 1], reason: 'Lv$level target');
        for (final word in active.words) {
          expect(context, contains(word.word), reason: 'Lv$level ${word.word}');
        }
      }
    });
  });

  group('Pingyao latest Challenge Gold', () {
    test('profile has ten-level progression, unique options and teach-before-test', () {
      final profile = nonDatongGoldChallengeProfileFor(pingyaoAncientCityJourneyId);
      expect(profile, isNotNull);
      final gold = profile!;
      expect(gold.paragraphAnchors, hasLength(10));
      expect(gold.missingAnchors, hasLength(10));
      expect(gold.paragraphGoals, hasLength(10));
      expect(gold.missingGoals, hasLength(10));
      expect(gold.paragraphIntents, hasLength(10));
      expect(gold.missingIntents, hasLength(10));
      expect(gold.grammar, hasLength(10));
      expect(gold.storyDistractors.length, greaterThanOrEqualTo(6));
      expect(gold.paragraphAnchors.last - gold.paragraphAnchors.first, greaterThanOrEqualTo(.75));
      expect(gold.missingAnchors.last - gold.missingAnchors.first, greaterThanOrEqualTo(.75));
      final allActive = <String>[
        for (var level = 1; level <= 10; level++) pingyaoAncientCityGoldLevelContent(level).storyParagraphs.join(),
        for (var level = 1; level <= 10; level++) pingyaoDiscoveriesForLevel(level).map((entry) => entry.text).join(),
      ].join();
      for (final grammar in gold.grammar) {
        expect(grammar.correctReplacement, isNot(grammar.brokenSegment));
        expect(<String>{grammar.correctReplacement, ...grammar.distractors}, hasLength(4));
        expect(grammar.misconception.trim().length, greaterThanOrEqualTo(8));
        final token = grammar.correctReplacement.replaceAll(RegExp(r'[，。；：“”？、]'), '');
        final taughtToken = token.length <= 8 ? token : token.substring(0, 8);
        expect(
          allActive.contains(taughtToken) || allActive.contains(grammar.correctedSentence.replaceAll('。', '')),
          isTrue,
          reason: grammar.targetId,
        );
      }
    });

    test('Lv1 Lv5 Lv10 human Challenge anchors perform different cognitive work', () {
      final gold = nonDatongGoldChallengeProfileFor(pingyaoAncientCityJourneyId)!;
      expect(gold.paragraphGoals[0], contains('基本顺序'));
      expect(gold.missingGoals[0], contains('母亲病重'));
      expect(gold.grammar[0].errorType, contains('把'));

      expect(gold.paragraphGoals[4], contains('谁必须离开'));
      expect(gold.missingGoals[4], contains('反对新技术'));
      expect(gold.grammar[4].errorType, contains('不是'));

      expect(gold.paragraphGoals[9], contains('两本账'));
      expect(gold.missingGoals[9], contains('不追哥哥'));
      expect(gold.grammar[9].errorType, contains('证据范围'));
    });

    test('Challenge is Pingyao-owned and avoids noun-swap contamination', () {
      final gold = nonDatongGoldChallengeProfileFor(pingyaoAncientCityJourneyId)!;
      final text = <String>[
        gold.paragraphPrompt,
        gold.missingPrompt,
        ...gold.paragraphGoals,
        ...gold.missingGoals,
        ...gold.grammar.map((item) => item.correctedSentence),
        ...gold.storyDistractors.map((item) => item.text),
      ].join();
      expect(text, contains('汇票'));
      expect(text, contains('账本'));
      for (final contaminant in <String>['梯田','水牛','木刻分水','云冈','龙门','陈家祠','拙政园']) {
        expect(text, isNot(contains(contaminant)));
      }
    });
  });

  group('Pingyao active candidate runtime and Gold lifecycle', () {
    test('dedicated runtime resolves exact Lv1 Lv5 Lv10 with no generic fallback', () {
      expect(usesDedicatedAdaptiveJourneyRuntime(pingyaoAncientCityJourneyId), isTrue);
      expect(canonicalExpandedDiscoveryJourneyIds, contains(pingyaoAncientCityJourneyId));
      expect(isBatchOneGoldJourney(pingyaoAncientCityJourneyId), isTrue);
      for (final level in <int>[1,5,10]) {
        final resolved = buildBatchOneGoldLevel(
          experience,
          profile: agent.profileForPhoenixLevel(level),
        );
        expect(resolved.storyParagraphs, pingyaoAncientCityGoldLevelContent(level).storyParagraphs);
      }
      expect(experience.storyTitle, pingyaoAncientCityCanonicalTitle);
      expect(experience.content.storyParagraphs, pingyaoAncientCityGoldLevelContent(5).storyParagraphs);
      expect(experience.content.storyParagraphs.join(), isNot(contains('晨光越过城墙')));
    });

    test('Memory and Completion are Journey-specific and survive shared runtime', () {
      final memory = batchOneMemorySpecFor(pingyaoAncientCityJourneyId);
      expect(memory, isNotNull);
      expect(memory!.storyResult, contains('平遥'));
      expect(memory.longTermAnchor, contains('汇票'));
      expect(memory.longTermAnchor, contains('银箱'));
      expect(memory.completionSummary, contains('《银子没有上路的那天》'));
    });

    test('candidate Narrative DNA and semantic fingerprint are unique without self-promotion', () {
      expect(pingyaoNarrativeDnaIsUniqueAgainstApproved(), isTrue);
      final semantic = pingyaoAncientCitySemanticGate();
      expect(semantic.isGoldReady, isTrue);
      expect(semantic.comparisons, hasLength(approvedGoldSemanticFingerprints.length));
      expect(semantic.comparisons.where((item) => item.isCollision), isEmpty);
      expect(approvedNarrativeDnaCatalog.map((item) => item.journeyId), isNot(contains(pingyaoAncientCityJourneyId)));
      expect(approvedGoldSemanticFingerprints.map((item) => item.journeyId), isNot(contains(pingyaoAncientCityJourneyId)));
    });
  });
}
