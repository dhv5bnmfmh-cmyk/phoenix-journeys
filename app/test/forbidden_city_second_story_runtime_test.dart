import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/beijing_story_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_pipeline_fixture.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_second_story_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';

void main() {
  group('Forbidden City second Story pilot runtime', () {
    test('imports approved canonical Story without rewriting it', () {
      final content = forbiddenCitySecondStoryPilotLevelContent();
      expect(forbiddenCitySecondStoryPilotTitle, '交接前的标记');
      expect(
        content.storyParagraphs,
        forbiddenCityPipelineFixture.storyContent.lines
            .map((line) => line.text)
            .toList(growable: false),
      );
      expect(content.storyParagraphs, hasLength(7));
      expect(content.storyParagraphs.join(), contains('林乔'));
      expect(content.storyParagraphs.join(), contains('许澄'));
      expect(content.storyParagraphs.join(), isNot(contains('沈砚')));
      expect(content.storyParagraphs.join(), isNot(contains('阿宁')));
    });

    test('stays inside the existing Forbidden City Journey identity', () {
      final bundle = forbiddenCitySecondStoryPilotPreparedBundle(
        phoenixLevel: 5,
        scriptMode: 'simplified',
      );
      expect(bundle.key.journeyId, forbiddenCityJourneyId);
      expect(forbiddenCitySecondStoryPilotQueryValue, 'handoff-v1');
      expect(
        beijingJourneyCatalog.where((journey) => journey.id == forbiddenCityJourneyId),
        hasLength(1),
      );
      expect(
        beijingJourneyCatalog.map((journey) => journey.title),
        isNot(contains('交接前的标记')),
      );
      expect(
        beijingJourneyCatalog.map((journey) => journey.id),
        isNot(contains(forbiddenCityPipelineFixturePackageId)),
      );
    });

    test('Vocabulary is the approved fixture Vocabulary and exists in Story', () {
      final content = forbiddenCitySecondStoryPilotLevelContent();
      expect(
        content.words.map((word) => word.word),
        orderedEquals(<String>['中轴', '景运门', '核对', '交接']),
      );
      for (final word in content.words) {
        expect(content.storyParagraphs.join(), contains(word.word));
        expect(word.pinyin, isNotEmpty);
        expect(word.simpleChinese, isNotEmpty);
        expect(word.translation, isNotEmpty);
        expect(word.englishDefinition, isNotEmpty);
      }
    });

    test('Discovery imports approved text and canonical sourceRefs', () {
      final content = forbiddenCitySecondStoryPilotLevelContent();
      expect(content.discoveries, hasLength(forbiddenCityPipelineFixture.discoveries.length));
      for (var i = 0; i < content.discoveries.length; i += 1) {
        final runtime = content.discoveries[i];
        final fixture = forbiddenCityPipelineFixture.discoveries[i];
        expect(runtime.text, fixture.text);
        expect(runtime.sourceRefs, fixture.sourceRefs);
        expect(runtime.sourceRefs, isNotEmpty);
      }
    });

    test('Challenge runtime is derived only from approved taught targets', () {
      expect(
        forbiddenCitySecondStoryPilotChallengeSourceMaterial,
        forbiddenCityPipelineFixture.challenges
            .map((item) => '${item.targetText}。')
            .toList(growable: false),
      );
      for (final target in forbiddenCityPipelineFixture.challenges) {
        expect(
          target.knowledgeUnitRefs.every(
            forbiddenCityPipelineFixture.knowledgeUnitRefs.contains,
          ),
          isTrue,
        );
        expect(target.teachingSourceRefs, isNotEmpty);
      }
      final challenge = forbiddenCitySecondStoryPilotChallengeSet(5);
      expect(challenge.journeyId, forbiddenCityJourneyId);
      expect(challenge.questions, hasLength(12));
      for (final mode in StoryChallengeMode.values) {
        expect(challenge.questions.where((question) => question.mode == mode), hasLength(4));
      }
      final challengeText = <String>[
        for (final question in challenge.questions)
          ...<String>[
            question.sourceSentence,
            question.prompt,
            question.answer,
            question.narrationText,
          ],
      ].join();
      expect(challengeText, isNot(contains('沈砚')));
      expect(challengeText, isNot(contains('阿宁')));
      expect(challengeText, isNot(contains('周师傅')));
    });

    test('Memory is mapped from approved fixture Memory', () {
      final memory = forbiddenCitySecondStoryPilotMemoryForLevel(5);
      final fixture = forbiddenCityPipelineFixture.memory;
      expect(memory.anchor, fixture.storyAnchor.text);
      expect(memory.recall, fixture.knowledgeTakeaway.text);
      expect(memory.characterShift, fixture.characterMoment.text);
      expect(memory.takeaway, fixture.vocabularyRecall.text);

      final completion = forbiddenCitySecondStoryPilotCompletionForLevel(5);
      expect(completion.memory, fixture.storyAnchor.text);
      expect(completion.discovery, fixture.knowledgeTakeaway.text);
      expect(completion.relationship, fixture.characterMoment.text);
      expect(
        completion.emotionalClosure,
        forbiddenCityPipelineFixture.storyContent.lines.last.text,
      );
    });

    test('FACT TRACE provenance and learning alignment remain intact', () {
      final package = forbiddenCityPipelineFixture;
      expect(package.validationReport.automatedValidation, isTrue);
      expect(package.factTrace, isNotEmpty);
      expect(package.provenance, isNotEmpty);
      expect(package.learningAlignment.storyKnowledgeUnitRefs, isNotEmpty);
      expect(
        package.factTrace.single.storyClaim,
        '景运门位于乾清门前广场东侧。',
      );
      expect(
        package.factTrace.single.sourceRefs,
        contains(forbiddenCityJingyunGateSourceRef),
      );
    });

    test('Founder PASS Story remains byte-for-byte unchanged', () {
      expect(
        forbiddenCityStoryParagraphsByLevel.first.single,
        '十七岁的古建学徒沈砚跟周师傅走进紫禁城。沈砚从午门出发，沿中轴向北走。他要画一张路线图，给新学徒看。他走到乾清门前，觉得这条路线最正确。阿宁从东侧来到乾清门前。她要把记录送回东边，目标和沈砚不同。沈砚说：“你走错了。”阿宁说：“我们一起看。”两人重新看图。两条路线都到乾清门前。沈砚留下两条路线。周师傅问：“为什么？”沈砚说：“同一个地方，可以有不同路线。”',
      );
      expect(forbiddenCityJourney01.title, '两条路，一张图');
      expect(forbiddenCityMemoryAnchor, '两条都能走通的路线');
    });

    test('runtime adapter has no UI dependency', () {
      final source = File('lib/data/forbidden_city_second_story_runtime.dart')
          .readAsStringSync();
      expect(source, isNot(contains('package:flutter/material.dart')));
      expect(source, isNot(contains('Widget build(')));
      expect(source, isNot(contains('Navigator')));
      expect(source, isNot(contains('Button')));
      expect(source, isNot(contains('TextStyle')));
      expect(source, isNot(contains('EdgeInsets')));
    });
  });
}
