from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCREEN = ROOT / 'app/lib/screens/journey_screen.dart'
TEST = ROOT / 'app/test/forbidden_city_ten_level_content_contract_test.dart'
WORKFLOW = ROOT / '.github/workflows/forbidden-city-content-only-apply.yml'
SELF = Path(__file__).resolve()

text = SCREEN.read_text(encoding='utf-8')


def replace_once(old: str, new: str, label: str) -> None:
    global text
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one match, got {count}')
    text = text.replace(old, new, 1)


replace_once(
    "  bool get _isSummerPalacePilot => false;\n  bool get _isForbiddenCity => _experience.id == forbiddenCityJourneyId;\n",
    "  bool get _isSummerPalacePilot => false;\n  bool get _isForbiddenCity => _experience.id == forbiddenCityJourneyId;\n\n"
    "  int get _forbiddenCityContentLevel {\n"
    "    final story = _levelContent.storyParagraphs.join('\\n');\n"
    "    final index = forbiddenCityLockedStories.indexOf(story);\n"
    "    if (index < 0) {\n"
    "      throw StateError('Forbidden City level could not be derived from active Story.');\n"
    "    }\n"
    "    return index + 1;\n"
    "  }\n",
    'insert Forbidden City content level resolver',
)

replace_once(
    "    if (_isForbiddenCity) {\n"
    "      return buildJourneyStageNarrationItems(\n"
    "        stage: 'memory',\n"
    "        displayedLines: [\n"
    "          for (final item in forbiddenCityMemoryReviews) ...[\n"
    "            _appState.displayText(item.prompt),\n"
    "            _appState.displayText(item.answer),\n"
    "          ],\n"
    "        ],\n"
    "      );\n"
    "    }\n",
    "    if (_isForbiddenCity) {\n"
    "      final memory = forbiddenCityMemoryForLevel(_forbiddenCityContentLevel);\n"
    "      return buildJourneyStageNarrationItems(\n"
    "        stage: 'memory',\n"
    "        displayedLines: [\n"
    "          _appState.displayText(memory.recall),\n"
    "          _appState.displayText(memory.characterShift),\n"
    "          _appState.displayText(memory.anchor),\n"
    "          _appState.displayText(memory.takeaway),\n"
    "        ],\n"
    "      );\n"
    "    }\n",
    'bind Memory narration to level',
)

replace_once(
    "    if (_isForbiddenCity) {\n"
    "      return buildJourneyStageNarrationItems(\n"
    "        stage: 'completion',\n"
    "        displayedLines: const [\n"
    "          forbiddenCityAchievementName,\n"
    "          forbiddenCityJourneySummary,\n"
    "          forbiddenCityMemoryAnchor,\n"
    "          forbiddenCityChallengeRewardName,\n"
    "          forbiddenCityChallengeRewardMeaning,\n"
    "          forbiddenCityJourneyCompletion,\n"
    "        ],\n"
    "      );\n"
    "    }\n",
    "    if (_isForbiddenCity) {\n"
    "      final completion =\n"
    "          forbiddenCityCompletionForLevel(_forbiddenCityContentLevel);\n"
    "      return buildJourneyStageNarrationItems(\n"
    "        stage: 'completion',\n"
    "        displayedLines: [\n"
    "          forbiddenCityAchievementName,\n"
    "          completion.storyClosure,\n"
    "          completion.discovery,\n"
    "          completion.learning,\n"
    "          completion.memory,\n"
    "          completion.relationship,\n"
    "          completion.emotionalClosure,\n"
    "          completion.unlockResult,\n"
    "        ],\n"
    "      );\n"
    "    }\n",
    'bind Completion narration to level',
)

replace_once(
    "    await _appState.completeJourney(\n"
    "      _isForbiddenCity ? forbiddenCityMemoryAnchor : memoryController.text,\n"
    "    );\n",
    "    await _appState.completeJourney(\n"
    "      _isForbiddenCity\n"
    "          ? forbiddenCityMemoryForLevel(_forbiddenCityContentLevel).anchor\n"
    "          : memoryController.text,\n"
    "    );\n",
    'persist level-specific Memory anchor',
)

old_memory_page = """  Widget _forbiddenCityMemoryPage() {
    return _page(
      title: '旅程回忆',
      narrationStage: 'memory',
      narrationItems: _memoryNarrationItems(),
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 6),
        itemCount: forbiddenCityMemoryReviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final item = forbiddenCityMemoryReviews[index];
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
              color: Colors.black.withValues(alpha: .26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appState.displayText(item.prompt),
                  style: const TextStyle(
                    color: Color(0xFFFFD879),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _appState.displayText(item.answer),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
"""

new_memory_page = """  Widget _forbiddenCityMemoryPage() {
    final memory = forbiddenCityMemoryForLevel(_forbiddenCityContentLevel);
    final reviews = <ForbiddenCityMemoryReview>[
      ForbiddenCityMemoryReview(prompt: '回想 Story', answer: memory.recall),
      ForbiddenCityMemoryReview(
        prompt: '人物关系变化',
        answer: memory.characterShift,
      ),
      ForbiddenCityMemoryReview(prompt: 'Memory Anchor', answer: memory.anchor),
      ForbiddenCityMemoryReview(
        prompt: '这一等级要带走什么',
        answer: memory.takeaway,
      ),
    ];
    return _page(
      title: '旅程回忆',
      narrationStage: 'memory',
      narrationItems: _memoryNarrationItems(),
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 6),
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final item = reviews[index];
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
              color: Colors.black.withValues(alpha: .26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appState.displayText(item.prompt),
                  style: const TextStyle(
                    color: Color(0xFFFFD879),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _appState.displayText(item.answer),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
"""
replace_once(old_memory_page, new_memory_page, 'bind Memory page to level')

old_complete_page = """  Widget _forbiddenCityCompletePage() {
    return _page(
      title: '北京已点亮',
      narrationStage: 'completion',
      narrationItems: _completionNarrationItems(),
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => unawaited(_exitJourney()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedCityJourneyStamp(journey: _experience, size: 96),
            ),
            const SizedBox(height: 8),
            const Text(
              forbiddenCityAchievementName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PhoenixTheme.red,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const _ForbiddenCityCompleteCard(
              title: 'Journey Summary',
              body: forbiddenCityJourneySummary,
            ),
            const SizedBox(height: 6),
            const _ForbiddenCityCompleteCard(
              title: 'Memory Anchor',
              body: forbiddenCityMemoryAnchor,
            ),
            const SizedBox(height: 6),
            const _ForbiddenCityCompleteCard(
              title: 'Challenge Reward',
              body:
                  '$forbiddenCityChallengeRewardName\\n$forbiddenCityChallengeRewardMeaning',
            ),
            const SizedBox(height: 6),
            const _ForbiddenCityCompleteCard(
              title: 'Journey Completion',
              body: forbiddenCityJourneyCompletion,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: JourneyShareButton(
                      isTraditional: _appState.isTraditional,
                      city: _experience.city,
                      place: _experience.place,
                      compact: true,
                      label: _appState.displayText('分享旅程'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(_restartJourney()),
                      icon: const Icon(Icons.replay_rounded, size: 16),
                      label: const Text(
                        '重新体验',
                        style: TextStyle(fontSize: 10.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
"""

new_complete_page = """  Widget _forbiddenCityCompletePage() {
    final completion =
        forbiddenCityCompletionForLevel(_forbiddenCityContentLevel);
    return _page(
      title: '北京已点亮',
      narrationStage: 'completion',
      narrationItems: _completionNarrationItems(),
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => unawaited(_exitJourney()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedCityJourneyStamp(journey: _experience, size: 96),
            ),
            const SizedBox(height: 8),
            const Text(
              forbiddenCityAchievementName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PhoenixTheme.red,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            _ForbiddenCityCompleteCard(
              title: 'Journey Summary',
              body: completion.storyClosure,
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Memory Anchor',
              body: completion.memory,
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Challenge Reward',
              body: '$forbiddenCityChallengeRewardName\\n${completion.learning}',
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Journey Completion',
              body:
                  '${completion.discovery}\\n${completion.relationship}\\n${completion.emotionalClosure}\\n${completion.unlockResult}',
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: JourneyShareButton(
                      isTraditional: _appState.isTraditional,
                      city: _experience.city,
                      place: _experience.place,
                      compact: true,
                      label: _appState.displayText('分享旅程'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(_restartJourney()),
                      icon: const Icon(Icons.replay_rounded, size: 16),
                      label: const Text(
                        '重新体验',
                        style: TextStyle(fontSize: 10.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
"""
replace_once(old_complete_page, new_complete_page, 'bind Completion page to level')

SCREEN.write_text(text, encoding='utf-8')

TEST.write_text(
    r'''import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';

void main() {
  test('Forbidden City has ten genuinely distinct six-stage content levels', () {
    expect(forbiddenCityLockedStories.length, 10);
    expect(forbiddenCityMemoryMoments.length, 10);
    expect(forbiddenCityCompletionMoments.length, 10);
    expect(forbiddenCityParagraphRebuild.length, 10);
    expect(forbiddenCityGrammarRepair.length, 10);
    expect(forbiddenCityMissingSentence.length, 10);

    final story = <String>{};
    final vocabulary = <String>{};
    final discovery = <String>{};
    final challenge = <String>{};
    final memory = <String>{};
    final completion = <String>{};

    for (var level = 1; level <= 10; level += 1) {
      final content = forbiddenCityLevelContent(level);
      final memoryMoment = forbiddenCityMemoryForLevel(level);
      final completionMoment = forbiddenCityCompletionForLevel(level);
      final rebuild = forbiddenCityParagraphRebuild[level - 1];
      final grammar = forbiddenCityGrammarRepair[level - 1];
      final transfer = forbiddenCityMissingSentence[level - 1];

      expect(content.storyParagraphs, isNotEmpty, reason: 'Lv$level Story');
      expect(content.words, isNotEmpty, reason: 'Lv$level Vocabulary');
      expect(content.discoveries, isNotEmpty, reason: 'Lv$level Discovery');

      final joinedStory = content.storyParagraphs.join('\n');
      for (final word in content.words) {
        expect(
          joinedStory.contains(word.word),
          isTrue,
          reason: 'Lv$level Vocabulary must trace to same-level Story: ${word.word}',
        );
      }

      story.add(joinedStory);
      vocabulary.add(content.words.map((word) => word.word).join('|'));
      discovery.add(content.discoveries.map((item) => item.text).join('|'));
      challenge.add(<String>[
        rebuild.segments.join('|'),
        grammar.correct,
        grammar.evidenceQuestion,
        transfer.transferQuestion,
        transfer.transferAnswer,
      ].join('||'));
      memory.add(<String>[
        memoryMoment.recall,
        memoryMoment.characterShift,
        memoryMoment.anchor,
        memoryMoment.takeaway,
      ].join('||'));
      completion.add(<String>[
        completionMoment.storyClosure,
        completionMoment.discovery,
        completionMoment.learning,
        completionMoment.memory,
        completionMoment.relationship,
        completionMoment.emotionalClosure,
        completionMoment.unlockResult,
      ].join('||'));
    }

    expect(story.length, 10, reason: 'Story must differ at every level');
    expect(vocabulary.length, 10, reason: 'Vocabulary must differ at every level');
    expect(discovery.length, 10, reason: 'Discovery must differ at every level');
    expect(challenge.length, 10, reason: 'Challenge must differ at every level');
    expect(memory.length, 10, reason: 'Memory must differ at every level');
    expect(completion.length, 10, reason: 'Completion must differ at every level');
  });

  test('Forbidden City keeps the locked Phoenix story mechanism at all levels', () {
    for (var level = 1; level <= 10; level += 1) {
      final story = forbiddenCityLockedStories[level - 1];
      expect(story.contains('沈砚'), isTrue, reason: 'Lv$level protagonist');
      expect(story.contains('阿宁'), isTrue, reason: 'Lv$level second protagonist');
      expect(
        story.contains('中轴') || story.contains('午门'),
        isTrue,
        reason: 'Lv$level Forbidden City spatial mechanism',
      );
      expect(
        story.contains('路线') || story.contains('线'),
        isTrue,
        reason: 'Lv$level route conflict',
      );
    }
  });
}
''',
    encoding='utf-8',
)

# Keep this repair content-only: remove the one-shot automation itself before commit.
if WORKFLOW.exists():
    WORKFLOW.unlink()
if SELF.exists():
    SELF.unlink()

print('FORBIDDEN CITY CONTENT-ONLY PATCH APPLIED')
