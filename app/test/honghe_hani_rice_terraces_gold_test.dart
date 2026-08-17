import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/all_gold_challenge_gold_profiles.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/honghe_hani_rice_terraces_gold_content.dart';
import 'package:phoenix_journeys/data/honghe_hani_rice_terraces_narrative_dna.dart';
import 'package:phoenix_journeys/data/honghe_hani_rice_terraces_semantic_fingerprint.dart';
import 'package:phoenix_journeys/data/journey_expansion_batch_four.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();
  final experience = journeyExpansionBatchFourExperiences.singleWhere(
    (item) => item.id == hongheHaniRiceTerracesJourneyId,
  );

  group('Honghe Fact First, Story Identity and Story Lock', () {
    test('authoritative ledgers separate verified world from fictional people', () {
      expect(hongheSourceLedger.length, greaterThanOrEqualTo(4));
      expect(hongheClaimLedger, isNotEmpty);
      expect(hongheClaimLedger.where((row) => row['status'] != 'ALLOWED'), isEmpty);
      expect(
        hongheFactFictionLedger.any(
          (row) =>
              row['category'] == 'REAL PERSON HIGH-PROTECTION' &&
              row['status'] == 'NOT USED',
        ),
        isTrue,
      );
      expect(
        hongheFactFictionLedger.any(
          (row) =>
              row['category'] == 'UNSUPPORTED FACTUAL CLAIM' &&
              row['status']!.startsWith('BLOCKED'),
        ),
        isTrue,
      );
    });

    test('three architectures are materially distinct and A is selected', () {
      expect(hongheHaniRiceTerracesArchitectures, hasLength(3));
      expect(
        hongheHaniRiceTerracesArchitectures.where((item) => item.selected),
        hasLength(1),
      );
      expect(hongheHaniRiceTerracesArchitectures.first.selected, isTrue);
      expect(
        hongheHaniRiceTerracesArchitectures.map((item) => item.engine).toSet(),
        hasLength(3),
      );
      expect(
        hongheHaniRiceTerracesArchitectures.map((item) => item.choice).toSet(),
        hasLength(3),
      );
      expect(
        hongheHaniRiceTerracesArchitectures.skip(1).every(
              (item) => item.rejectedReason.isNotEmpty,
            ),
        isTrue,
      );
    });

    test('Place, Primary Depth and relationship causality change the action', () {
      expect(honghePlaceCausalMechanism['genericPlaceTest'], startsWith('PASS'));
      expect(honghePlaceCausalMechanism['otherCityTest'], startsWith('PASS'));
      expect(hongheStoryIdentityCard['PrimaryDepth'], honghePrimaryDepth);
      expect(hongheSecondaryDepths.length, inInclusiveRange(1, 3));
      expect(hongheDepthActionGate['result'], startsWith('PASS'));
      expect(hongheRelationshipCausalityGate['result'], startsWith('PASS'));
      expect(hongheStoryIdentityCard['Choice'], contains('议定尺寸'));
      expect(hongheStoryIdentityCard['Cost'], contains('水牛'));
      expect(hongheStoryIdentityCard['Cost'], contains('没犁完'));
      expect(hongheStoryIdentityCard['MemoryMoment'], contains('两道水'));
      expect(hongheStoryIdentityCard['MemoryMoment'], contains('牛铃'));
    });
  });

  group('Honghe Lv1-Lv10 Story, Discovery and vocabulary', () {
    test('ten levels preserve one human causal spine and canonical length', () {
      expect(hongheHaniRiceTerracesGoldLevels, hasLength(10));
      for (var level = 1; level <= 10; level++) {
        final content = hongheHaniRiceTerracesGoldLevelContent(level);
        final story = content.storyParagraphs.join();
        final target = phoenixStoryLengthTargetForLevel(level);
        expect(content.storyParagraphs.length, target.paragraphCount, reason: 'Lv$level paragraphs');
        expect(
          story.length,
          inInclusiveRange(
            target.acceptedMinimumCharacters,
            target.acceptedMaximumCharacters,
          ),
          reason: 'Lv$level story length ${story.length}',
        );
        for (final anchor in <String>[
          '罗秋',
          '马岚',
          '赶沟人',
          '分水口',
          '凹槽',
          '议定',
          '水牛',
          '梯田',
        ]) {
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

    test('Lv1 independently proves human spine, place cause, choice, cost and consequence', () {
      final story = hongheHaniRiceTerracesGoldLevelContent(1).storyParagraphs.join();
      expect(story, contains('第一次以赶沟人身份巡沟'));
      expect(story, contains('中午后用马家的牛'));
      expect(story, contains('凹槽被重新削宽'));
      expect(story, contains('只求罗秋把宽槽留到中午'));
      expect(story, contains('按照村里议定的尺寸重新凿好凹槽'));
      expect(story, contains('水继续往下方梯田走'));
      expect(story, contains('牵着牛离开'));
      expect(story, contains('最后一块田还没犁'));
      expect(story, isNot(contains('这说明')));
    });

    test('Lv5 is literary and Lv10 deepens without explanatory ending', () {
      final lv5 = hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs.join();
      final lv10 = hongheHaniRiceTerracesGoldLevelContent(10).storyParagraphs.join();
      expect(lv5, contains('下午还等不等我家的牛'));
      expect(lv5, contains('尺寸是大家一起议定的'));
      expect(lv5, contains('马岚没再说话，牵着牛离开'));
      expect(lv10, contains('木头上的宽窄会落到具体的人情上'));
      expect(lv10, contains('牛铃响了一声，水面同时换了方向'));
      expect(lv10, endsWith('她没回头。'));
      expect(lv10, isNot(contains('这说明')));
      expect(lv10, isNot(contains('这象征')));
      expect(lv10, isNot(contains('真正的意义')));
    });

    test('Discovery follows 2/2/2/2 then 3 with one progressive theme per level', () {
      const expected = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
      for (var level = 1; level <= 10; level++) {
        final rows = hongheDiscoveriesForLevel(level);
        expect(rows.length, expected[level - 1], reason: 'Lv$level');
        for (final row in rows) {
          expect(row.text.trim(), isNotEmpty);
          expect(row.pinyin.trim(), isNotEmpty);
          expect(row.vietnamese.trim(), isNotEmpty);
          expect(row.english.trim(), isNotEmpty);
        }
      }
      expect(hongheDiscoveriesForLevel(1).map((e) => e.text).join(), contains('森林、村寨、沟渠和梯田'));
      expect(hongheDiscoveriesForLevel(5).map((e) => e.text).join(), contains('木刻分水'));
      expect(hongheDiscoveriesForLevel(5).map((e) => e.text).join(), contains('赶沟人'));
      expect(hongheDiscoveriesForLevel(10).map((e) => e.text).join(), contains('四素同构'));
      expect(hongheHaniRiceTerracesGoldJourney.discoveries, hasLength(26));
    });

    test('Vocabulary meets every target and remains active-source-only', () {
      final allContext = <String>[
        for (var level = 1; level <= 10; level++)
          hongheHaniRiceTerracesGoldLevelContent(level).storyParagraphs.join(),
        for (var level = 1; level <= 10; level++)
          hongheDiscoveriesForLevel(level).map((entry) => entry.text).join(),
      ].join();
      for (final word in hongheHaniRiceTerracesWords) {
        expect(allContext, contains(word.word), reason: word.word);
      }

      for (var level = 1; level <= 10; level++) {
        final profile = agent.profileForPhoenixLevel(level);
        final plan = agent.planFor(profile);
        final active = buildBatchOneGoldLevel(experience, profile: profile);
        final context = '${active.storyParagraphs.join()}${active.discoveries.map((entry) => entry.text).join()}';
        expect(active.words.length, plan.targetVocabularyCount, reason: 'Lv$level target');
        expect(active.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
        for (final word in active.words) {
          expect(context, contains(word.word), reason: 'Lv$level ${word.word}');
        }
      }
    });
  });

  group('Honghe Challenge Gold candidate', () {
    test('profile has ten-level pedagogy, differentiated intents and unique options', () {
      final profile = nonDatongGoldChallengeProfileFor(hongheHaniRiceTerracesJourneyId);
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
      for (final grammar in gold.grammar) {
        expect(grammar.correctReplacement, isNot(grammar.brokenSegment));
        expect(<String>{grammar.correctReplacement, ...grammar.distractors}, hasLength(4));
        expect(grammar.misconception.trim().length, greaterThanOrEqualTo(8));
      }
    });

    test('Teach Before Test keeps grammar and Story misconceptions inside active learning', () {
      final profile = nonDatongGoldChallengeProfileFor(hongheHaniRiceTerracesJourneyId)!;
      final allActive = <String>[
        for (var level = 1; level <= 10; level++)
          hongheHaniRiceTerracesGoldLevelContent(level).storyParagraphs.join(),
        for (var level = 1; level <= 10; level++)
          hongheDiscoveriesForLevel(level).map((entry) => entry.text).join(),
      ].join();
      for (final grammar in profile.grammar) {
        final meaningful = grammar.correctReplacement
            .replaceAll(RegExp(r'[，。；：“”？、]'), '')
            .trim();
        expect(meaningful, isNotEmpty);
        final taughtToken = meaningful.length <= 8 ? meaningful : meaningful.substring(0, 8);
        expect(
          allActive.contains(taughtToken) ||
              allActive.contains(grammar.correctedSentence.replaceAll('。', '')),
          isTrue,
          reason: grammar.targetId,
        );
      }
      for (final item in profile.storyDistractors) {
        expect(item.text, contains('罗秋'));
        expect(item.misconception.trim().length, greaterThanOrEqualTo(8));
      }
    });

    test('Lv1 Lv5 Lv10 human Challenge anchors do different cognitive work', () {
      final profile = nonDatongGoldChallengeProfileFor(hongheHaniRiceTerracesJourneyId)!;
      expect(profile.paragraphGoals[0], contains('基本顺序'));
      expect(profile.missingGoals[0], contains('直接关系'));
      expect(profile.grammar[0].errorType, contains('以……身份'));

      expect(profile.paragraphGoals[4], contains('关系代价'));
      expect(profile.missingGoals[4], contains('真实成本'));
      expect(profile.grammar[4].errorType, contains('宾语位置'));

      expect(profile.paragraphGoals[9], contains('未和解'));
      expect(profile.missingGoals[9], contains('私人关系'));
      expect(profile.grammar[9].errorType, contains('虚假因果'));
      expect(profile.grammar[9].whyWrong, contains('并置'));
    });

    test('Challenge text is Honghe-owned and contains no cross-Journey contamination', () {
      final gold = nonDatongGoldChallengeProfileFor(hongheHaniRiceTerracesJourneyId)!;
      final challengeText = <String>[
        gold.paragraphPrompt,
        gold.missingPrompt,
        ...gold.paragraphGoals,
        ...gold.missingGoals,
        ...gold.grammar.map((item) => item.correctedSentence),
        ...gold.storyDistractors.map((item) => item.text),
      ].join();
      for (final contaminant in <String>['云冈', '龙门', '开平', '西湖', '陈家祠', '拙政园', '丽江']) {
        expect(challengeText, isNot(contains(contaminant)));
      }
      expect(challengeText, contains('分水'));
      expect(challengeText, contains('水牛'));
    });
  });

  group('Honghe active candidate runtime, Memory and anti-template lifecycle', () {
    test('dedicated runtime resolves exact Lv1 Lv5 Lv10 with no legacy tourism seed', () {
      expect(usesDedicatedAdaptiveJourneyRuntime(hongheHaniRiceTerracesJourneyId), isTrue);
      expect(canonicalExpandedDiscoveryJourneyIds, contains(hongheHaniRiceTerracesJourneyId));
      expect(isBatchOneGoldJourney(hongheHaniRiceTerracesJourneyId), isTrue);
      for (final level in <int>[1, 5, 10]) {
        final resolved = buildBatchOneGoldLevel(
          experience,
          profile: agent.profileForPhoenixLevel(level),
        );
        expect(resolved.storyParagraphs, hongheHaniRiceTerracesGoldLevelContent(level).storyParagraphs);
      }
      final active = hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs.join();
      expect(active, isNot(contains('日出越过哀牢山')));
      expect(experience.storyTitle, hongheHaniRiceTerracesCanonicalTitle);
      expect(experience.content.geoNodeId, 'cn-yunnan-honghe-yuanyang-hani-terraces');
    });

    test('Memory and Completion preserve Story moment, cost, place and unresolved relation', () {
      final spec = batchOneMemorySpecFor(hongheHaniRiceTerracesJourneyId);
      expect(spec, isNotNull);
      expect(spec!.storyResult, contains('《两道水重新分开以后》'));
      expect(spec.culturalPoint, contains('木刻分水'));
      expect(spec.culturalPoint, contains('牛铃'));
      expect(spec.longTermAnchor, contains('两道水'));
      expect(spec.longTermAnchor, contains('没犁完'));
      expect(spec.reviews.map((item) => item.category).toSet(), containsAll(<String>[
        'choice',
        'cost',
        'place',
        'memory',
        'relationship',
      ]));
    });

    test('candidate semantic fingerprint passes Rule A/B against all approved Gold', () {
      final gate = hongheHaniRiceTerracesSemanticGate();
      expect(gate.isGoldReady, isTrue, reason: gate.status);
      expect(gate.comparisons, hasLength(approvedGoldSemanticFingerprints.length));
      expect(gate.comparisons.where((item) => item.isCollision), isEmpty);
      expect(
        hongheHaniRiceTerracesCandidateSemanticFingerprint.mechanisms.keys.toSet(),
        NarrativeSemanticDimension.values.toSet(),
      );
      expect(
        hongheHaniRiceTerracesCandidateSemanticFingerprint.coreEvidence
            .map((item) => item.dimension)
            .toSet(),
        containsAll(narrativeSemanticCoreDimensions),
      );
    });

    test('candidate Narrative DNA is unique but lifecycle remains pre-approval', () {
      expect(hongheNarrativeDnaIsUniqueAgainstApproved(), isTrue);
      expect(
        approvedNarrativeDnaCatalog.any(
          (record) => record.journeyId == hongheHaniRiceTerracesJourneyId,
        ),
        isFalse,
      );
      expect(
        approvedGoldSemanticFingerprints.containsKey(hongheHaniRiceTerracesJourneyId),
        isFalse,
      );
      expect(
        nonDatongGoldChallengeProfiles.containsKey(hongheHaniRiceTerracesJourneyId),
        isTrue,
      );
    });
  });
}