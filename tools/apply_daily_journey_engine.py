from pathlib import Path
import re

JOURNEY = Path('app/lib/screens/journey_screen.dart')
EXPLORE = Path('app/lib/screens/explore_screen.dart')
RULE = Path('worker/daily_journey_engine_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing replacement target: {label}')
    return text.replace(old, new, 1)


journey = JOURNEY.read_text(encoding='utf-8')
if 'DailyJourneyExperience _experience' not in journey:
    journey = replace_once(
        journey,
        "import '../data/journey_data.dart';\n",
        "import '../data/daily_journey_catalog.dart';\n"
        "import '../data/journey_data.dart';\n",
        'daily journey import',
    )
    journey = replace_once(
        journey,
        "import '../widgets/forbidden_city_stamp.dart';\n",
        "import '../widgets/city_journey_stamp.dart';\n",
        'generic stamp import',
    )
    journey = replace_once(
        journey,
        "class JourneyScreen extends StatefulWidget {\n"
        "  const JourneyScreen({super.key});\n\n",
        "class JourneyScreen extends StatefulWidget {\n"
        "  const JourneyScreen({super.key, this.journeyId});\n\n"
        "  final String? journeyId;\n\n",
        'journey screen constructor',
    )
    journey = replace_once(
        journey,
        "  late final JourneyContentRecord _journeyContent;\n",
        "  late final DailyJourneyExperience _experience;\n"
        "  late final JourneyContentRecord _journeyContent;\n",
        'experience field',
    )
    journey = replace_once(
        journey,
        "    final worldStoryAgent = createPhoenixWorldStoryAgent();\n"
        "    _journeyContent = requireJourneyContent(\n"
        "      worldStoryAgent,\n"
        "      'beijing-forbidden-city',\n"
        "    );\n",
        "    final worldStoryAgent = createPhoenixWorldStoryAgent();\n"
        "    final journeyId = widget.journeyId ??\n"
        "        dailyJourneyForDate(DateTime.now()).id;\n"
        "    _experience = requireDailyJourneyExperience(journeyId);\n"
        "    _journeyContent = requireJourneyContent(\n"
        "      worldStoryAgent,\n"
        "      _experience.id,\n"
        "    );\n",
        'dynamic journey initialization',
    )

    # Replace only standalone catalog identifiers used by the Journey UI.
    journey = re.sub(r'\bdiscoveries\b', '_experience.discoveries', journey)
    journey = re.sub(r'\bstoryAnnotations\b', '_experience.storyAnnotations', journey)
    journey = re.sub(r'\bwonderQuestion\b', '_experience.wonderQuestion', journey)
    journey = re.sub(r'\bexpressQuestion\b', '_experience.expressQuestion', journey)
    journey = re.sub(r'\bwords\b', '_experience.words', journey)

    journey = replace_once(
        journey,
        "        title: const Text(\n"
        "          '北京 · 紫禁城',\n"
        "          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),\n"
        "        ),\n",
        "        title: Text(\n"
        "          _appState.displayText(_experience.appBarTitle),\n"
        "          style: const TextStyle(\n"
        "            fontSize: 16,\n"
        "            fontWeight: FontWeight.w900,\n"
        "          ),\n"
        "        ),\n",
        'dynamic app bar title',
    )
    journey = replace_once(
        journey,
        "            title: '紫禁城故事',\n",
        "            title: _appState.displayText(_experience.storyTitle),\n",
        'dynamic story player title',
    )
    journey = replace_once(
        journey,
        "      title: '北京已点亮',\n",
        "      title: '${_experience.city}已点亮',\n",
        'dynamic completion title',
    )
    journey = replace_once(
        journey,
        "          const Expanded(\n"
        "            child: Center(\n"
        "              child: FittedBox(\n"
        "                fit: BoxFit.contain,\n"
        "                child: AnimatedForbiddenCityStamp(),\n"
        "              ),\n"
        "            ),\n"
        "          ),\n",
        "          Expanded(\n"
        "            child: Center(\n"
        "              child: FittedBox(\n"
        "                fit: BoxFit.contain,\n"
        "                child: AnimatedCityJourneyStamp(\n"
        "                  journey: _experience,\n"
        "                ),\n"
        "              ),\n"
        "            ),\n"
        "          ),\n",
        'generic completion stamp',
    )
    journey = replace_once(
        journey,
        "                    isTraditional: _appState.isTraditional,\n"
        "                    compact: true,\n",
        "                    isTraditional: _appState.isTraditional,\n"
        "                    city: _experience.city,\n"
        "                    place: _experience.place,\n"
        "                    compact: true,\n",
        'generic completion share',
    )
    journey = journey.replace(
        'AppState.beijingJourneyLastStep',
        'AppState.journeyLastStep',
    )
    journey = journey.replace(
        'AppState.beijingJourneyStepLabels',
        'AppState.journeyStepLabels',
    )

JOURNEY.write_text(journey, encoding='utf-8')

explore = EXPLORE.read_text(encoding='utf-8')
if 'state.activeJourney.appBarTitle' not in explore:
    if "import 'dart:async';" not in explore:
        explore = replace_once(
            explore,
            "import 'dart:math' as math;\n",
            "import 'dart:async';\n"
            "import 'dart:math' as math;\n",
            'async import',
        )
    explore = replace_once(
        explore,
        "    final viewportHeight = MediaQuery.sizeOf(context).height;\n",
        "    final viewportHeight = MediaQuery.sizeOf(context).height;\n"
        "    if (state.activeJourneyId != state.todayJourney.id) {\n"
        "      WidgetsBinding.instance.addPostFrameCallback((_) {\n"
        "        unawaited(state.refreshDailyJourney());\n"
        "      });\n"
        "    }\n",
        'daily refresh',
    )
    explore = replace_once(
        explore,
        "      Navigator.of(\n"
        "        context,\n"
        "      ).push(MaterialPageRoute(builder: (_) => const JourneyScreen()));\n",
        "      Navigator.of(context).push(\n"
        "        MaterialPageRoute(\n"
        "          builder: (_) => JourneyScreen(\n"
        "            journeyId: state.activeJourneyId,\n"
        "          ),\n"
        "        ),\n"
        "      );\n",
        'open active journey',
    )

    explore = explore.replace('state.beijingStampEarned', 'state.activeJourneyStampEarned')
    explore = explore.replace("'北京已点亮 · 印章已获得'", "'${state.activeJourney.city}已点亮 · 印章已获得'")
    explore = explore.replace("'北京印章已收藏 · 可以再次出发'", "'${state.activeJourney.city}印章已收藏 · 可以再次出发'")
    explore = explore.replace("state.displayText('河内  →  北京')", "state.displayText('河内  →  ${state.activeJourney.city}')")
    explore = explore.replace("label: state.displayText('北京'),", "label: state.displayText(state.activeJourney.city),")
    explore = explore.replace("subtitle: 'PEK',", "subtitle: state.activeJourney.cityCode,")
    explore = explore.replace("if (state.journeyCompleted) return '再次探索北京';", "if (state.journeyCompleted) return '再次探索${state.activeJourney.city}';")
    explore = explore.replace("if (state.hasJourneyInProgress) return '继续北京 Journey';", "if (state.hasJourneyInProgress) return '继续${state.activeJourney.city} Journey';")
    explore = explore.replace("return '开始北京 Journey';", "return '开始${state.activeJourney.city} Journey';")
    explore = explore.replace("text: state.displayText('中国 · 北京'),", "text: state.displayText('中国 · ${state.activeJourney.city}'),")
    explore = explore.replace("state.displayText('第一站'),", "state.displayText('今日旅程'),")
    explore = explore.replace("state.displayText('第一次走进紫禁城')", "state.displayText(state.activeJourney.headline)")
    explore = explore.replace("state.displayText('跟随 AI 导游，用故事、词汇和文化打开北京。')", "state.displayText(state.activeJourney.description)")
    explore = explore.replace("'旅程完成 · 紫禁城印章已收入护照'", "'旅程完成 · ${state.activeJourney.place}印章已收入护照'")
    explore = explore.replace("state.displayText('北京印章已收藏，可以随时再次体验。')", "state.displayText('${state.activeJourney.city}印章已收藏，可以随时再次体验。')")
    explore = explore.replace("state.displayText('为什么故宫的屋顶大多是黄色？')", "state.displayText(state.activeJourney.discoveryTeaser)")
    explore = explore.replace("'1,670 km · 学习航程'", "'${state.activeJourney.distanceLabel} · 学习航程'")

EXPLORE.write_text(explore, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');

test('daily catalog contains three reviewed city journeys', () => {
  assert.match(catalog, /beijing-forbidden-city/);
  assert.match(catalog, /shanghai-bund/);
  assert.match(catalog, /xian-city-wall/);
  assert.match(catalog, /dailyJourneyForDate/);
  assert.match(catalog, /dailyJourneyExperiences\.length/);
});

test('daily progress and stamps are namespaced by journey id', () => {
  assert.match(state, /journey\.\$\{journeyId \?\? activeJourneyId\}/);
  assert.match(state, /earnedJourneyStampIds/);
  assert.match(state, /activateJourney/);
  assert.match(state, /refreshDailyJourney/);
});

test('one stable Journey screen renders all daily cities', () => {
  assert.match(journey, /final String\? journeyId/);
  assert.match(journey, /DailyJourneyExperience _experience/);
  assert.match(journey, /_experience\.storyAnnotations/);
  assert.match(journey, /_experience\.words/);
  assert.match(journey, /_experience\.discoveries/);
  assert.match(journey, /AnimatedCityJourneyStamp/);
  assert.doesNotMatch(journey, /AnimatedForbiddenCityStamp/);
});

test('Explore opens and describes the active daily journey', () => {
  assert.match(explore, /JourneyScreen\([\s\S]*journeyId: state\.activeJourneyId/);
  assert.match(explore, /state\.activeJourney\.headline/);
  assert.match(explore, /state\.activeJourney\.discoveryTeaser/);
  assert.match(explore, /state\.refreshDailyJourney/);
});
""", encoding='utf-8')
