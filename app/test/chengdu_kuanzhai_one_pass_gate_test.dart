import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Chengdu Story obeys Lv1-Lv10 length and paragraph policy', () {
    expect(chengduKuanzhaiOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = chengduKuanzhaiOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      // ignore: avoid_print
      print('CHENGDU_STORY_METRIC Lv$level characters=$characters paragraphs=${content.storyParagraphs.length}');
      expect(characters, inInclusiveRange(target.acceptedMinimumCharacters, target.acceptedMaximumCharacters), reason: 'Lv$level accepted Story range');
      expect(content.storyParagraphs.length, target.paragraphCount, reason: 'Lv$level paragraph count');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve canonical shared-space handoff engine', () {
    final chairYieldPatterns = <RegExp>[
      RegExp(r'(?:把|将)?竹椅(?:挪开|移开|挪到|移到)'),
      RegExp(r'(?:挪开|移开|挪到|移到)竹椅'),
      RegExp(r'(?:把|将)?竹椅(?:挪到|移到)(?:院墙边|墙边|一旁)'),
    ];
    for (var level = 1; level <= 10; level++) {
      final story = chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['林夏', '周叔', '院落', '竹椅', '茶桌', '通行']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(
        chairYieldPatterns.any((pattern) => pattern.hasMatch(story)),
        isTrue,
        reason: 'Lv$level bamboo chair physically yields from passage',
      );
      expect(story, contains('放回'), reason: 'Lv$level return handoff');
      expect(story, contains('没有'), reason: 'Lv$level release of direct control');
      expect(story, isNot(contains('调查表')));
      expect(story, isNot(contains('商业活动')));
      expect(story, isNot(contains('仍在使用')));
      expect(story, isNot(contains('历史真实性')));
      expect(story, isNot(contains('第二天')));
      expect(story, isNot(contains('研究生')));
    }
  });

  test('Lin Xia role, goal, conflict, handoffs, choice, climax and ending are enacted', () {
    final advanced = chengduKuanzhaiOnePassLevels[9].storyParagraphs.join();
    expect(advanced, contains('二十四岁的林夏是年轻的院落接待员'));
    expect(advanced, contains('宽巷子、窄巷子与井巷子'));
    expect(advanced, contains('茶馆'));
    expect(advanced, contains('周叔'));
    expect(advanced, contains('固定位置'));
    expect(advanced, contains('第二个方案也失败了'));
    expect(advanced, contains('真正冲突的是院落入口的有限空间与不断变化的使用时序'));
    expect(advanced, contains('林夏放弃给竹椅指定永久归属，改成亲手建立交接节奏'));
    expect(advanced, contains('不必等她发令'));
    expect(advanced, contains('周叔先看见来人，没有喊她，也没有等提示'));
    expect(advanced, contains('茶客继续停留，服务人员继续穿行'));
    expect(advanced, contains('最后，一位离桌的客人顺手又为经过的人移开同一把竹椅'));
    expect(advanced, contains('林夏看着那只手完成动作，没有出声'));
    expect(advanced, contains('一把没有固定位置的竹椅'));
  });

  test('new engine is not field research, evidence reclassification, overlay, refusal, or farewell', () {
    final allStories = chengduKuanzhaiOnePassLevels.map((level) => level.storyParagraphs.join()).join();
    for (final forbidden in <String>[
      '使用痕迹调查',
      '调查表',
      '把“商业活动”划掉',
      '仍在使用',
      '第二天提交',
      '真实性',
      '叠着两条路线',
      '实线与点线',
      '倒计时',
      '捷径',
      '告别',
      '最后一圈',
    ]) {
      expect(allStories, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[for (final level in chengduKuanzhaiOnePassLevels) level.storyParagraphs.join()];
    expect(chengduKuanzhaiOnePassWords, hasLength(chengduKuanzhaiWordTraces.length));
    expect(chengduKuanzhaiOnePassWords, hasLength(chengduKuanzhaiWordFirstAppears.length));
    for (final word in chengduKuanzhaiOnePassWords) {
      final trace = chengduKuanzhaiWordTraces.firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(stories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} exact source');
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(first, chengduKuanzhaiWordFirstAppears[word.word], reason: '${word.word} first appears');
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
    final active = chengduKuanzhaiOnePassWords.map((word) => word.word).toSet();
    expect(active, isNot(containsAll(<String>['调查表', '历史真实性', '商业活动', '仍在使用'])));
  });

  test('Discovery is ten sourced entries and does not retell old survey engine', () {
    final sourceIds = chengduKuanzhaiSources.map((source) => source.id).toSet();
    expect(chengduKuanzhaiDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = chengduKuanzhaiDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final joined = '${spec.storyLink}${spec.entry.text}${spec.learnerInsight}${spec.answer}';
      expect(joined, isNot(contains('划掉“商业活动”')));
      expect(joined, isNot(contains('提交调查')));
      final resolved = chengduKuanzhaiOnePassLevelContent(level);
      expect(resolved.discoveries, hasLength(1));
      expect(identical(resolved.discoveries.single, spec.entry), isTrue);
    }
  });

  test('source discipline distinguishes verified context from fictional action', () {
    expect(chengduKuanzhaiSourceDiscipline['historic-lanes-courtyards-current-use'], 'VERIFIED FACT');
    expect(chengduKuanzhaiSourceDiscipline['street-lane-courtyard-circulation-link'], 'SAFE NARRATIVE INFERENCE');
    for (final key in <String>['Lin-Xia-teahouse-role', 'Zhou-Shu-regular-guest-role', 'bamboo-chair-movement', 'tea-service-and-dialogue']) {
      expect(chengduKuanzhaiSourceDiscipline[key], 'FICTIONAL CHARACTER ACTION');
    }
    expect(chengduKuanzhaiSourceDiscipline.values, isNot(contains('UNSUPPORTED')));
  });

  test('Challenge covers Lv1-Lv10 with exact active-story anchors', () {
    const approved = <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'};
    expect(chengduKuanzhaiChallenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = chengduKuanzhaiChallenges.where((item) => item.level == level).toList();
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(story, contains(challenge.anchor), reason: 'Lv$level ${challenge.type}');
        expect(challenge.answer, challenge.anchor);
      }
    }
  });

  test('Memory and Complete encode handoff rather than record correction', () {
    final memory = chengduKuanzhaiMemory.map((item) => item.answer).join();
    for (final anchor in <String>['林夏', '周叔', '竹椅', '院落', '茶桌', '通行', '交接']) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(memory, isNot(contains('调查表')));
    expect(chengduKuanzhaiCompletion.achievement, '院落节奏协调者');
    expect(chengduKuanzhaiCompletion.memoryAnchor, '一把没有固定位置的竹椅');
    expect(chengduKuanzhaiCompletion.challengeReward, '共享交接印记');
    expect(chengduKuanzhaiCompletion.journeyCompletion, contains('林夏没有介入'));
  });

  test('Narrative DNA is derived from handoff Story and remains unique', () {
    final ids = approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet();
    expect(ids, containsAll(<String>{'beijing-summer-palace', 'beijing-forbidden-city', 'shanghai-bund', 'xian-city-wall', 'hangzhou-west-lake', 'nanjing-qinhuai-river', chengduKuanzhaiJourneyId}));
    final chengdu = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == chengduKuanzhaiJourneyId);
    expect(chengdu.narrativeIdentity, 'courtyard-chair-handoffs-create-shared-use-rhythm');
    expect(chengdu.protagonistArchetype, contains('courtyard-host'));
    expect(chengdu.conflictType, contains('fixed-space-assignment'));
    expect(chengdu.climaxType, contains('independently'));
    expect(chengdu.memoryAnchorType, contains('bamboo-chair'));
    final references = approvedNarrativeDnaCatalog.where((item) => item.journeyId != chengduKuanzhaiJourneyId);
    expect(narrativeDnaIsUnique(chengdu, references), isTrue);
    for (final reference in references) {
      expect(duplicatedMajorDimensions(chengdu, reference), lessThan(3), reason: reference.journeyId);
    }
  });

  test('semantic fingerprint proves handoff engine and zero Gold collision', () {
    final fingerprint = approvedGoldSemanticFingerprints[chengduKuanzhaiJourneyId]!;
    expect(fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily), NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol);
    expect(fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily), isNot(NarrativeMechanismFamily.evidenceForcesReclassification));
    expect(fingerprint.mechanism(NarrativeSemanticDimension.choiceMechanism), NarrativeMechanismFamily.facilitateHandoffInsteadOfPermanentAllocation);
    expect(fingerprint.mechanism(NarrativeSemanticDimension.climaxMechanism), NarrativeMechanismFamily.participantIndependentlyReproducesHandoff);
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
    final comparisons = semanticDifferenceMatrixAgainstApprovedGold(fingerprint);
    expect(comparisons, hasLength(7));
    expect(comparisons.every((comparison) => !comparison.isCollision), isTrue);
    final hangzhou = comparisons.singleWhere((comparison) => comparison.journeyA == 'hangzhou-west-lake' || comparison.journeyB == 'hangzhou-west-lake');
    expect(hangzhou.coreMatchCount, 0);
    expect(hangzhou.ruleA, isFalse);
    expect(hangzhou.ruleB, isFalse);
  });

  test('28 Gold pairs contain zero historical semantic collision debt', () {
    final audit = auditApprovedGoldSemanticPairs();
    expect(audit, hasLength(28));
    expect(audit.where((item) => item.isCollision), isEmpty);
    expect(audit.where((item) => item.classification == SemanticCollisionClassification.existingSemanticCollisionDebt), isEmpty);
  });

  test('runtime classifies Chengdu as dedicated Gold and resolves immutable snapshots', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(chengduKuanzhaiJourneyId), isTrue);
    expect(usesSharedGenericAdaptivePipeline(chengduKuanzhaiJourneyId), isFalse);
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(experience, profile: levelAgent.profileForPhoenixLevel(level));
      expect(identical(resolved.storyParagraphs, chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs), isTrue);
      expect(resolved.storyParagraphs.join(), contains('竹椅'));
      expect(resolved.storyParagraphs.join(), isNot(contains('调查表')));
      expect(resolved.discoveries, hasLength(1));
    }
  });
}
