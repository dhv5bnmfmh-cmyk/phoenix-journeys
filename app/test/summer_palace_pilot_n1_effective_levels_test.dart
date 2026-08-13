import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/summer_palace_adaptive_story_levels.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();
  const expectedDiscoveryCounts = <int, int>{
    1: 2,
    2: 2,
    3: 2,
    4: 2,
    5: 3,
    6: 3,
    7: 3,
    8: 3,
    9: 3,
    10: 3,
  };

  test('Summer Palace Lv1-Lv10 preserve human spine and cultural causal ledger', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');

    for (var level = 1; level <= 10; level += 1) {
      final profile = agent.profileForPhoenixLevel(level);
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final target = phoenixStoryLengthTargetFor(profile);
      final story = content.storyParagraphs.join();

      expect(
        summerPalaceN1EventOrderForLevel(level),
        summerPalaceN1RequiredEventOrder,
      );
      expect(
        story.runes.length,
        inInclusiveRange(
          target.acceptedMinimumCharacters,
          target.acceptedMaximumCharacters,
        ),
        reason: 'Lv.$level story length',
      );
      expect(content.storyParagraphs, hasLength(target.paragraphCount));
      expect(content.storyAnnotations, hasLength(target.paragraphCount));
      expect(content.discoveries, hasLength(expectedDiscoveryCounts[level]!));
      expect(summerPalaceN1ContainsGenericTouristEnrichment(content), isFalse);

      for (final anchor in <String>[
        '许澄',
        '周岚',
        '校展',
        '旧照片',
        '十七孔桥',
        '按快门',
        '先捡回照片',
        '画面没了',
        '《留下痕迹的风景》',
        '不再替她调构图',
        '交给许澄保存',
      ]) {
        expect(story, contains(anchor), reason: 'Lv.$level human spine: $anchor');
      }

      final residue = <bool>[
        story.contains('冬至') && story.contains('十七孔桥'),
        story.contains('园林修复') && story.contains('旧照片'),
        story.contains('东堤') && story.contains('南湖岛'),
        story.contains('长廊') && story.contains('昆明湖'),
        story.contains('一八六〇年受损') && story.contains('一八八六年修复'),
      ].where((value) => value).length;
      final requiredResidue = level <= 4 ? 2 : 3;
      expect(
        residue,
        greaterThanOrEqualTo(requiredResidue),
        reason: 'Lv.$level Story Cultural Knowledge Residue',
      );
    }
  });

  test('Vocabulary meets target/max and uses Story plus every active Discovery entry', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');

    for (var level = 1; level <= 10; level += 1) {
      final profile = agent.profileForPhoenixLevel(level);
      final plan = agent.planFor(profile);
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final visible = <String>[
        ...content.storyParagraphs,
        ...content.discoveries.map((entry) => entry.text),
      ].join();

      expect(
        content.words,
        hasLength(plan.targetVocabularyCount),
        reason: 'Lv.$level target vocabulary',
      );
      expect(content.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
      for (final word in content.words) {
        expect(
          visible,
          contains(word.word),
          reason: 'Lv.$level visible provenance for ${word.word}',
        );
      }

      final known = content.words.take(2).map((word) => word.word).toSet();
      final reviewed = resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
        knownWords: known,
      );
      expect(
        reviewed.words,
        hasLength(plan.targetVocabularyCount),
        reason: 'Lv.$level knownWords keeps target semantics',
      );
      for (final word in reviewed.words) {
        expect(visible, contains(word.word));
      }
    }
  });

  test('Founder-visible reflection prompts stay human and contain no QA language', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');
    const beginnerWonder =
        '桥洞的金光正在移动，许澄为什么还是先去捡外婆的旧照片？';
    const beginnerExpress =
        '请用两到三句话写出桥洞金光、旧照片和许澄的选择之间发生了什么。';
    const advancedWonder =
        '颐和园经历过损毁和修复。许澄最后把旧照片和正在暗下来的桥洞一起拍进画面，你觉得她对“无瑕”的理解发生了什么变化？';
    const advancedExpress =
        '请用三到五句话写一段许澄可能放在校展照片旁的说明。写出拍摄的时节、十七孔桥、旧照片，以及她最后决定留下什么。';
    const forbiddenQaTerms = <String>[
      'Story',
      'Choice',
      'Cost',
      'Place Substitution Test',
      '不能换成普通公园',
      '因果测试',
      '文化因果 Gate',
      '工程验证',
      'PASS',
      'FAIL',
    ];

    expect(journey.wonderQuestion, advancedWonder);
    expect(journey.expressQuestion, advancedExpress);

    final visibleContent = <String>[
      journey.appBarTitle,
      journey.storyTitle,
      journey.headline,
      journey.description,
      journey.discoveryTeaser,
      journey.wonderQuestion,
      journey.expressQuestion,
      ...journey.content.storyParagraphs,
      ...journey.discoveries.expand(
        (entry) => <String>[
          entry.text,
          entry.pinyin,
          entry.simpleChinese,
          entry.vietnamese,
          entry.english,
        ],
      ),
      ...journey.words.expand(
        (entry) => <String>[
          entry.word,
          entry.pinyin,
          entry.simpleChinese,
          entry.translation,
          entry.englishDefinition,
          ...entry.examples.expand(
            (example) => <String>[
              example.chinese,
              example.pinyin,
              example.vietnamese,
              example.english,
            ],
          ),
        ],
      ),
    ].join('\n');

    for (final term in forbiddenQaTerms) {
      expect(visibleContent, isNot(contains(term)), reason: term);
    }

    for (var level = 1; level <= 10; level += 1) {
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: agent.profileForPhoenixLevel(level),
      );
      expect(
        content.wonderQuestion,
        level <= 4 ? beginnerWonder : advancedWonder,
        reason: 'Lv.$level Wonder',
      );
      expect(
        content.expressQuestion,
        level <= 4 ? beginnerExpress : advancedExpress,
        reason: 'Lv.$level Express',
      );
      final prompts = '${content.wonderQuestion}\n${content.expressQuestion}';
      for (final term in forbiddenQaTerms) {
        expect(prompts, isNot(contains(term)), reason: 'Lv.$level: $term');
      }
    }
  });

  test('Place substitution damages the causal chain instead of merely renaming it', () {
    final story = summerPalaceN1LevelForPhoenixLevel(7).storyParagraphs.join();
    final generic = story
        .replaceAll('颐和园', '公园')
        .replaceAll('十七孔桥', '桥')
        .replaceAll('东堤', '岸边')
        .replaceAll('南湖岛', '小岛')
        .replaceAll('昆明湖', '湖')
        .replaceAll('长廊', '走廊')
        .replaceAll('冬至', '冬天')
        .replaceAll('金光穿洞', '夕阳');

    expect(story, contains('冬至前后十七孔桥会出现“金光穿洞”'));
    expect(story, contains('十七孔桥东接东堤、西连南湖岛'));
    expect(story, contains('特意绕到西北方向站定'));
    expect(story, contains('原本铺在桥洞内壁上的亮色已经移开'));
    expect(generic, isNot(contains('金光穿洞')));
    expect(generic, isNot(contains('东堤')));
    expect(generic, isNot(contains('南湖岛')));
    expect(
      summerPalaceStoryCulturalCausality.every(
        (record) =>
            record.storyActionCaused.trim().isNotEmpty &&
            record.pressureCaused.trim().isNotEmpty &&
            record.whatBreaksIfRemoved.trim().isNotEmpty,
      ),
      isTrue,
    );
  });

  test('Gold Narrative DNA and semantic fingerprint remain unique and active', () {
    final dna = approvedNarrativeDnaCatalog
        .singleWhere((record) => record.journeyId == 'beijing-summer-palace');
    expect(dna.locationMechanism, contains('Seventeen-Arch-Bridge'));
    expect(dna.climaxType, contains('light-shifts'));
    expect(narrativeDnaIsUnique(dna, approvedNarrativeDnaCatalog), isTrue);

    final fingerprint =
        approvedGoldSemanticFingerprints['beijing-summer-palace']!;
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
    expect(
      fingerprint.coreEvidence.expand((record) => record.sourceTexts).join(),
      contains('桥洞金光已移动'),
    );

    final pairs = auditApprovedGoldSemanticPairs();
    final n = approvedGoldSemanticFingerprints.length;
    expect(pairs, hasLength(n * (n - 1) ~/ 2));
    expect(pairs.where((pair) => pair.isCollision), isEmpty);
  });

  test('the public resolver is unchanged for every generic Journey', () {
    final genericJourneys = allJourneyExperiences
        .where((journey) => usesSharedGenericAdaptivePipeline(journey.id))
        .toList(growable: false);
    expect(genericJourneys, isNotEmpty);

    for (final journey in genericJourneys) {
      for (final profile in agent.allProfiles) {
        final public = resolveAdaptiveJourneyLevel(journey, profile: profile);
        final shared = resolveSharedAdaptiveJourneyLevel(journey, profile: profile);
        expect(public.storyParagraphs, shared.storyParagraphs);
        expect(
          public.words.map((entry) => entry.word),
          shared.words.map((entry) => entry.word),
        );
        expect(
          public.discoveries.map((entry) => entry.text),
          shared.discoveries.map((entry) => entry.text),
        );
      }
    }
  });
}
