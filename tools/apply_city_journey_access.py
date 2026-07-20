from pathlib import Path
import re

JOURNEY = Path('app/lib/screens/journey_screen.dart')
EXPLORE = Path('app/lib/screens/explore_screen.dart')
RULE = Path('worker/daily_journey_engine_rule.test.mjs')

journey = JOURNEY.read_text(encoding='utf-8')

single_screen_pattern = re.compile(
    r"\n                    else\n"
    r"                      Container\(\n"
    r"                        padding: const EdgeInsets\.symmetric\(\n"
    r"                          horizontal: 7,\n"
    r"                          vertical: 3,\n"
    r"                        \),\n"
    r"                        decoration: BoxDecoration\(\n"
    r"                          color: PhoenixTheme\.gold\.withValues\(alpha: \.12\),\n"
    r"                          borderRadius: BorderRadius\.circular\(99\),\n"
    r"                        \),\n"
    r"                        child: const Text\(\n"
    r"                          '单屏模式',\n"
    r"                          style: TextStyle\(\n"
    r"                            color: PhoenixTheme\.red,\n"
    r"                            fontSize: 8\.5,\n"
    r"                            fontWeight: FontWeight\.w900,\n"
    r"                          \),\n"
    r"                        \),\n"
    r"                      \),"
)
journey, count = single_screen_pattern.subn('', journey, count=1)
if count != 1:
    raise RuntimeError('Could not remove the single-screen mode label')
JOURNEY.write_text(journey, encoding='utf-8')

explore = EXPLORE.read_text(encoding='utf-8')
explore = explore.replace(
    "import '../state/app_state.dart';\n",
    "import '../data/daily_journey_catalog.dart';\n"
    "import '../state/app_state.dart';\n",
    1,
)
explore = explore.replace(
    "    if (state.activeJourneyId != state.todayJourney.id) {\n"
    "      WidgetsBinding.instance.addPostFrameCallback((_) {\n"
    "        unawaited(state.refreshDailyJourney());\n"
    "      });\n"
    "    }\n",
    '',
    1,
)

old_open = """    Future<void> openJourney() async {
      if (state.journeyCompleted) {
        await state.restartJourney();
      }
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => JourneyScreen(
            journeyId: state.activeJourneyId,
          ),
        ),
      );
    }
"""
new_open = """    Future<void> openJourneyById(String journeyId) async {
      await state.activateJourney(journeyId);
      if (state.journeyCompleted) {
        await state.restartJourney();
      }
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => JourneyScreen(journeyId: journeyId),
        ),
      );
    }

    Future<void> chooseJourney() async {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        builder: (sheetContext) => Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('选择城市旅程'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                state.displayText('今日旅程是推荐路线，其他城市也可随时继续。'),
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
              const SizedBox(height: 8),
              ...dailyJourneyExperiences.map(
                (journey) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    key: ValueKey('journey-picker-${journey.id}'),
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: PhoenixTheme.red.withValues(alpha: .10),
                      child: Text(
                        state.displayText(journey.stampSymbol),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    title: Text(
                      state.displayText('${journey.city} · ${journey.place}'),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      state.displayText(
                        journey.id == state.todayJourney.id
                            ? '今日推荐 · 点击进入'
                            : state.isJourneyStampEarned(journey.id)
                                ? '印章已获得 · 可再次体验'
                                : '可随时开始或继续',
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      unawaited(openJourneyById(journey.id));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
"""
if old_open not in explore:
    raise RuntimeError('Could not find the Explore openJourney block')
explore = explore.replace(old_open, new_open, 1)

old_card_call = "              _JourneyCard(state: state, onOpen: openJourney),"
new_card_call = """              _JourneyCard(
                state: state,
                onOpen: () => unawaited(
                  openJourneyById(state.activeJourneyId),
                ),
                onChoose: () => unawaited(chooseJourney()),
              ),"""
if old_card_call not in explore:
    raise RuntimeError('Could not find the Journey card call')
explore = explore.replace(old_card_call, new_card_call, 1)

old_constructor = """class _JourneyCard extends StatelessWidget {
  const _JourneyCard({required this.state, required this.onOpen});

  final AppState state;
  final VoidCallback onOpen;
"""
new_constructor = """class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.state,
    required this.onOpen,
    required this.onChoose,
  });

  final AppState state;
  final VoidCallback onOpen;
  final VoidCallback onChoose;
"""
if old_constructor not in explore:
    raise RuntimeError('Could not find the Journey card constructor')
explore = explore.replace(old_constructor, new_constructor, 1)

old_today = """              const Spacer(),
              Text(
                state.displayText('今日旅程'),
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
"""
new_today = """              const Spacer(),
              TextButton.icon(
                key: const ValueKey('choose-city-journey'),
                onPressed: onChoose,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.swap_horiz_rounded, size: 14),
                label: Text(
                  state.displayText('选择城市'),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
"""
if old_today not in explore:
    raise RuntimeError('Could not find the Today Journey label')
explore = explore.replace(old_today, new_today, 1)
EXPLORE.write_text(explore, encoding='utf-8')

rule = RULE.read_text(encoding='utf-8')
append = """

test('journey pages stay clean and every city remains directly accessible', () => {
  assert.doesNotMatch(journey, /单屏模式/);
  assert.match(explore, /choose-city-journey/);
  assert.match(explore, /选择城市旅程/);
  assert.match(explore, /dailyJourneyExperiences\.map/);
  assert.match(explore, /openJourneyById/);
  assert.doesNotMatch(explore, /refreshDailyJourney\(\)/);
});
"""
if 'journey pages stay clean and every city remains directly accessible' not in rule:
    rule += append
RULE.write_text(rule, encoding='utf-8')
