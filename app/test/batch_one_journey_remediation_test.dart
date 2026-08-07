import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const requestedIds = <String>{
    'beijing-forbidden-city',
    'shanghai-bund',
  };

  bool containsEventsInOrder(String story, RemediatedJourney journey) {
    var cursor = -1;
    for (final event in journey.events) {
      final next = story.indexOf(event.coreChinese, cursor + 1);
      if (next <= cursor) return false;
      cursor = next;
    }
    return true;
  }

  String eventText(RemediatedJourney journey, String eventId) {
    final event = journey.events.firstWhere((item) => item.id == eventId);
    return '${event.coreChinese}${event.detailChinese}';
  }

  group('Phoenix Batch 1 Journey remediation', () {
    test('scope preserves exactly the requested Journey IDs', () {
      expect(batchOneJourneyIds, requestedIds);
      expect(batchOneRemediatedJourneys.keys.toSet(), requestedIds);
      for (final id in requestedIds) {
        expect(requireDailyJourneyExperience(id).id, id);
      }
    });

    test('Challenge contains exactly the three approved modes', () {
      expect(
        fixedJourneyChallengeTypes,
        const <JourneyChallengeType>[
          JourneyChallengeType.paragraphRebuild,
          JourneyChallengeType.grammarRepair,
          JourneyChallengeType.missingSentence,
        ],
      );
      for (final journey in batchOneRemediatedJourneys.values) {
        expect(
          journey.challenges.map((item) => item.type).toList(),
          batchOneChallengeTypes,
        );
        for (final challenge in journey.challenges) {
          expect(challenge.anchor.trim(), isNotEmpty);
          expect(challenge.storyEventIds, isNotEmpty);
          expect(
            challenge.storyEventIds.every(journey.eventIds.contains),
            isTrue,
          );
        }
      }
    });

    test('all listed quality gates pass from implemented content', () {
      final results = <String, bool>{};
      for (final id in requestedIds) {
        final experience = requireDailyJourneyExperience(id);
        final remediation = batchOneRemediationFor(id)!;
        final memory = batchOneMemorySpecFor(id);
        final protagonistName = remediation.protagonist.split('，').first;
        final levels = levelAgent.allProfiles
            .map(
              (profile) => resolveAdaptiveJourneyLevel(
                experience,
                profile: profile,
              ),
            )
            .toList(growable: false);
        final levelTenStory = levels.last.storyParagraphs.join();
        final sourceIds = remediation.sources.map((item) => item.id).toSet();

        results['$id Story Continuity'] = levels.every(
          (content) => containsEventsInOrder(
            content.storyParagraphs.join(),
            remediation,
          ),
        );
        results['$id Character Consistency'] = levels.every(
          (content) => content.storyParagraphs.join().contains(protagonistName),
        );
        results['$id Timeline Consistency'] = id == 'beijing-forbidden-city'
            ? levels.every((content) {
                final story = content.storyParagraphs.join();
                return story.contains('雷雨') && story.contains('次日');
              })
            : levels.every((content) {
                final story = content.storyParagraphs.join();
                return story.contains('九点半') &&
                    story.contains('开场前') &&
                    story.contains('网络恢复后');
              });
        results['$id Historical Accuracy'] = remediation.discoveryTraces.every(
          (trace) => trace.sourceIds.isNotEmpty &&
              trace.sourceIds.every(sourceIds.contains) &&
              trace.storyEventIds.every(remediation.eventIds.contains),
        );
        results['$id Cultural Authenticity'] = id == 'beijing-forbidden-city'
            ? levelTenStory.contains('国家仪式') &&
                levelTenStory.contains('内廷') &&
                levelTenStory.contains('宫寝生活')
            : levelTenStory.contains('不平等条约') &&
                levelTenStory.contains('贸易') &&
                levelTenStory.contains('信用');
        results['$id Architecture Accuracy'] = id == 'beijing-forbidden-city'
            ? levelTenStory.contains('三层汉白玉台基') &&
                levelTenStory.contains('石雕龙头') &&
                levelTenStory.contains('排水')
            : levelTenStory.contains('历史建筑') &&
                levelTenStory.contains('不同年代和风格') &&
                levelTenStory.contains('天际线');
        results['$id Geography Accuracy'] = id == 'beijing-forbidden-city'
            ? levelTenStory.contains('午门') &&
                levelTenStory.contains('中轴') &&
                levelTenStory.contains('外朝')
            : levelTenStory.contains('黄浦江') &&
                levelTenStory.contains('西岸') &&
                levelTenStory.contains('浦东');
        results['$id Vocabulary Source Validation'] =
            remediation.wordTraces.length == remediation.words.length &&
            remediation.wordTraces.every((trace) {
              if (!remediation.eventIds.contains(trace.eventId)) return false;
              final source = eventText(remediation, trace.eventId);
              return source.contains(trace.sourceText) &&
                  trace.sourceText.contains(trace.word) &&
                  trace.usage.trim().isNotEmpty;
            }) &&
            levels.every((content) {
              final story = content.storyParagraphs.join();
              return content.words.isNotEmpty &&
                  content.words.every(
                    (word) => story.contains(word.word) &&
                        word.pinyin.trim().isNotEmpty &&
                        word.simpleChinese.trim().isNotEmpty &&
                        word.translation.trim().isNotEmpty &&
                        word.englishDefinition.trim().isNotEmpty &&
                        word.examples.length >= 3 &&
                        word.examples.every(
                          (example) =>
                              example.chinese.contains(word.word) &&
                              example.pinyin.trim().isNotEmpty &&
                              example.vietnamese.trim().isNotEmpty &&
                              example.english.trim().isNotEmpty,
                        ),
                  );
            });
        results['$id Vocabulary Quality'] = remediation.words
            .map((entry) => entry.word)
            .toSet()
            .length == remediation.words.length;
        results['$id Discovery Quality'] = levels.every(
          (content) =>
              content.discoveries.isNotEmpty &&
              content.discoveries.length <= 2 &&
              content.discoveries.every(
                (entry) =>
                    entry.text.trim().isNotEmpty &&
                    entry.pinyin.trim().isNotEmpty &&
                    entry.simpleChinese.trim().isNotEmpty &&
                    entry.vietnamese.trim().isNotEmpty &&
                    entry.english.trim().isNotEmpty,
              ),
        ) &&
            remediation.discoveryTraces.length == remediation.discoveries.length;
        results['$id Challenge Quality'] =
            remediation.challenges.length == 3 &&
            remediation.challenges.map((item) => item.type).toList().join('|') ==
                batchOneChallengeTypes.join('|');
        results['$id Memory Quality'] = memory != null &&
            remediation.memory.map((item) => item.category).toSet().containsAll(
              <String>{
                'protagonist',
                'events',
                'history',
                'culture',
                'architecture',
                'vocabulary',
              },
            ) &&
            remediation.memory.every(
              (item) =>
                  item.answer.trim().isNotEmpty &&
                  item.storyEventIds.isNotEmpty &&
                  item.storyEventIds.every(remediation.eventIds.contains),
            );
        results['$id Completion Quality'] = memory != null &&
            remediation.completion.journeySummary.trim().isNotEmpty &&
            remediation.completion.achievement.trim().isNotEmpty &&
            remediation.completion.memoryAnchor.trim().isNotEmpty &&
            remediation.completion.challengeReward.trim().isNotEmpty &&
            remediation.completion.journeyCompletion.trim().isNotEmpty;
        results['$id Multilingual Consistency'] = levels.asMap().entries.every(
          (levelEntry) {
            final level = levelEntry.key + 1;
            final content = levelEntry.value;
            if (content.storyAnnotations.length !=
                content.storyParagraphs.length) {
              return false;
            }
            final pinyin = content.storyAnnotations
                .map((annotation) => annotation.pinyin)
                .join(' ');
            final vietnamese = content.storyAnnotations
                .map((annotation) => annotation.vietnamese)
                .join(' ');
            final english = content.storyAnnotations
                .map((annotation) => annotation.english)
                .join(' ');
            return remediation.events.every((event) {
              final corePresent = pinyin.contains(event.corePinyin) &&
                  vietnamese.contains(event.coreVietnamese) &&
                  english.contains(event.coreEnglish);
              final detailShouldAppear = level >= event.detailFromLevel;
              final detailPresent = event.detailChinese.isEmpty ||
                  (pinyin.contains(event.detailPinyin) &&
                      vietnamese.contains(event.detailVietnamese) &&
                      english.contains(event.detailEnglish));
              return corePresent && (detailShouldAppear == detailPresent);
            });
          },
        );
        results['$id Lv1~Lv10 Continuity'] = levels.length == 10 &&
            levels.asMap().entries.every((entry) {
              if (entry.key == 0) return true;
              return entry.value.storyParagraphs.join().runes.length >
                  levels[entry.key - 1].storyParagraphs.join().runes.length;
            });
        results['$id Location Identity'] = id == 'beijing-forbidden-city'
            ? <String>['午门', '太和殿', '丹陛', '外朝', '内廷', '千龙吐水']
                .every(levelTenStory.contains)
            : <String>['外滩', '黄浦江', '浦东', '开埠', '贸易', '金融']
                .every(levelTenStory.contains);
        results['$id Story Originality'] = id == 'beijing-forbidden-city'
            ? <String>['工牌', '投影长度', '斜长', '最快实习生']
                .every((anchor) => !levelTenStory.contains(anchor))
            : <String>['旧照片', '底片编号', '说明牌', '档案志愿者']
                .every((anchor) => !levelTenStory.contains(anchor));
        results['$id No Reflection'] = !<String>[
          levelTenStory,
          ...remediation.memory.map((item) => item.answer),
          remediation.completion.journeySummary,
        ].join().contains('反思');
        results['$id No Writing'] = !<String>[
          ...remediation.challenges.map((item) => item.anchor),
          ...remediation.memory.map((item) => item.answer),
        ].join().contains(RegExp('自由写作|写一篇|写一段|日记'));

        for (var index = 0; index < levels.length; index++) {
          final profile = levelAgent.allProfiles[index];
          final target = phoenixStoryLengthTargetFor(profile);
          final story = levels[index].storyParagraphs.join();
          results['$id ${profile.displayLabel} length'] =
              story.runes.length >= target.minimumCharacters &&
              story.runes.length <= target.maximumCharacters;
        }
      }

      final forbidden = batchOneRemediationFor('beijing-forbidden-city')!;
      final bund = batchOneRemediationFor('shanghai-bund')!;
      final forbiddenStory = forbidden.levels.last.storyParagraphs.join();
      final bundStory = bund.levels.last.storyParagraphs.join();
      results['Narrative Uniqueness'] = forbidden.protagonist != bund.protagonist &&
          forbidden.completion.memoryAnchor != bund.completion.memoryAnchor &&
          forbidden.completion.journeySummary != bund.completion.journeySummary;
      results['Genre Diversity'] = forbiddenStory.contains('雷雨') &&
          forbiddenStory.contains('临时导排') &&
          bundStory.contains('金融公开课') &&
          bundStory.contains('角色') &&
          !forbiddenStory.contains('金融公开课') &&
          !bundStory.contains('临时导排');

      expect(
        results.entries.where((entry) => !entry.value).map((entry) => entry.key),
        isEmpty,
      );
    });
  });
}
