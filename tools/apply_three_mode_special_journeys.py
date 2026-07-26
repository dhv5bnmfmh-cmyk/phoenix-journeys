from __future__ import annotations

import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected exactly one match, found {count}')
    return text.replace(old, new, 1)


def patch_daily_catalog() -> None:
    path = ROOT / 'app/lib/data/daily_journey_catalog.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "import 'summer_palace_journey.dart';\n",
        "import 'summer_palace_journey.dart';\nimport 'special_journey_catalog.dart';\n",
        'special journey catalog import',
    )
    text = replace_once(
        text,
        "  ...extendedJourneyExperiences,\n];\n\nfinal List<WordEntry> allDailyJourneyWords = List<WordEntry>.unmodifiable(\n",
        "  ...extendedJourneyExperiences,\n];\n\n"
        "final allJourneyExperiences = <DailyJourneyExperience>[\n"
        "  ...dailyJourneyExperiences,\n"
        "  ...specialJourneyExperiences,\n"
        "];\n\n"
        "final List<WordEntry> allDailyJourneyWords = List<WordEntry>.unmodifiable(\n",
        'all journey experience aggregate',
    )
    text = replace_once(
        text,
        '    for (final journey in dailyJourneyExperiences)\n',
        '    for (final journey in allJourneyExperiences)\n',
        'all journey word aggregate',
    )
    text = replace_once(
        text,
        "  return dailyJourneyExperiences.firstWhere(\n"
        "    (journey) => journey.id == id,\n"
        "    orElse: () => dailyJourneyExperiences.first,\n"
        "  );\n",
        "  return allJourneyExperiences.firstWhere(\n"
        "    (journey) => journey.id == id,\n"
        "    orElse: () => dailyJourneyExperiences.first,\n"
        "  );\n",
        'require all journey experience',
    )
    path.write_text(text, encoding='utf-8')


def patch_location_binding() -> None:
    path = ROOT / 'app/lib/services/journey_location_binding.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        '  for (final journey in dailyJourneyExperiences) {\n',
        '  for (final journey in allJourneyExperiences) {\n',
        'location binding all journeys',
    )
    path.write_text(text, encoding='utf-8')


def patch_world_geo() -> None:
    path = ROOT / 'app/lib/data/world_geo_catalog.dart'
    text = path.read_text(encoding='utf-8')
    marker = "  GeoNode(\n    id: 'cn-guangdong-guangzhou-chen-clan',"
    if marker not in text:
        raise RuntimeError('world geo final marker not found')
    addition = """
  GeoNode(
    id: 'phoenix-realms',
    name: '万象异境',
    kind: GeoNodeKind.country,
    localType: '幻想文化世界',
    parentId: 'world',
    aliases: ['Phoenix Realms', '万象奇旅'],
  ),
  GeoNode(
    id: 'phoenix-realms-dream-butterfly',
    name: '梦蝶竹林',
    kind: GeoNodeKind.place,
    localType: '文学幻想之境',
    parentId: 'phoenix-realms',
    latitude: 38.2,
    longitude: 105.8,
    aliases: ['庄周梦蝶', 'Dream Butterfly Grove'],
  ),
  GeoNode(
    id: 'phoenix-realms-moon-letter',
    name: '桂影山径',
    kind: GeoNodeKind.place,
    localType: '神话幻想之境',
    parentId: 'phoenix-realms',
    latitude: 36.4,
    longitude: 112.6,
    aliases: ['月宫遗简', 'Moon Letter Path'],
  ),
  GeoNode(
    id: 'phoenix-realms-shadowless-inn',
    name: '无影客栈',
    kind: GeoNodeKind.place,
    localType: '志怪幻想之境',
    parentId: 'phoenix-realms',
    latitude: 29.7,
    longitude: 109.4,
    aliases: ['聊斋夜客', 'Shadowless Inn'],
  ),
  GeoNode(
    id: 'phoenix-realms-upstream-lantern',
    name: '逆流渡口',
    kind: GeoNodeKind.place,
    localType: '民俗幻想之境',
    parentId: 'phoenix-realms',
    latitude: 25.8,
    longitude: 117.8,
    aliases: ['逆流河灯', 'Upstream Lantern Ford'],
  ),
"""
    end = text.rfind('];')
    if end < 0:
        raise RuntimeError('world geo list ending not found')
    text = text[:end] + addition + text[end:]
    path.write_text(text, encoding='utf-8')


def patch_destination_background() -> None:
    path = ROOT / 'app/lib/widgets/destination_background.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "import '../theme/phoenix_theme.dart';\n",
        "import '../theme/phoenix_theme.dart';\nimport 'special_realm_background.dart';\n",
        'special realm background import',
    )
    text = replace_once(
        text,
        "    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);\n\n"
        "    if (journeyId == _summerPalaceJourneyId) {\n",
        "    final visibleScrimStrength = (scrimStrength * .55).clamp(0.0, 1.0);\n\n"
        "    if (SpecialRealmBackground.supports(journeyId)) {\n"
        "      return SpecialRealmBackground(\n"
        "        journeyId: journeyId,\n"
        "        scrimStrength: visibleScrimStrength,\n"
        "        child: child,\n"
        "      );\n"
        "    }\n\n"
        "    if (journeyId == _summerPalaceJourneyId) {\n",
        'special realm background branch',
    )
    path.write_text(text, encoding='utf-8')


def patch_special_background_switch() -> None:
    path = ROOT / 'app/lib/widgets/special_realm_background.dart'
    text = path.read_text(encoding='utf-8')
    old = """    switch (journeyId) {
      case 'literary-roaming':
        _paintDreamButterfly(canvas, size);
      case 'myth-tracing':
        _paintMoonLetter(canvas, size);
      case 'strange-night-talks':
        _paintShadowlessInn(canvas, size);
      case 'folk-secret-land':
        _paintUpstreamLantern(canvas, size);
    }
"""
    new = """    switch (journeyId) {
      case 'literary-roaming':
        _paintDreamButterfly(canvas, size);
        return;
      case 'myth-tracing':
        _paintMoonLetter(canvas, size);
        return;
      case 'strange-night-talks':
        _paintShadowlessInn(canvas, size);
        return;
      case 'folk-secret-land':
        _paintUpstreamLantern(canvas, size);
        return;
    }
"""
    text = replace_once(text, old, new, 'special background switch returns')
    path.write_text(text, encoding='utf-8')


def patch_challenge_panel_icon() -> None:
    path = ROOT / 'app/lib/widgets/journey_challenge_panel.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "                completed\n                    ? Icons.check_circle_rounded\n                    : Icons.filter_${1}_rounded,\n",
        "                completed\n                    ? Icons.check_circle_rounded\n                    : Icons.radio_button_unchecked_rounded,\n",
        'mode chip icon',
    )
    path.write_text(text, encoding='utf-8')


def patch_journey_screen() -> None:
    path = ROOT / 'app/lib/screens/journey_screen.dart'
    text = path.read_text(encoding='utf-8')
    text = text.replace('  String? _challengeReward;\n', '')
    text = text.replace('        _challengeReward = null;\n', '')
    text = text.replace('            _challengeReward = reward;\n', '')
    old = """        displayText: state.displayText,
        initialReward: _challengeReward,
        onResolved: (reward, awardId) async {
          await state.awardChallengeRewardOnce(
            reward: reward,
            awardId: awardId,
          );
          if (!mounted) return;
          setState(() {
            _challengeResolved = true;
          });
        },
"""
    if old not in text:
        old = """        displayText: state.displayText,
        initialReward: _challengeReward,
        onResolved: (reward, awardId) async {
          await state.awardChallengeRewardOnce(
            reward: reward,
            awardId: awardId,
          );
          if (!mounted) return;
          setState(() {
            _challengeResolved = true;
            _challengeReward = reward;
          });
        },
"""
    new = """        displayText: state.displayText,
        onResolved: (reward, awardId) async {
          await state.awardChallengeRewardOnce(
            reward: reward,
            awardId: awardId,
          );
        },
        onAllCompleted: () async {
          if (!mounted || _challengeResolved) return;
          setState(() => _challengeResolved = true);
        },
"""
    text = replace_once(text, old, new, 'journey three-mode callbacks')
    path.write_text(text, encoding='utf-8')


def main() -> None:
    patch_daily_catalog()
    patch_location_binding()
    patch_world_geo()
    patch_destination_background()
    patch_special_background_switch()
    patch_challenge_panel_icon()
    patch_journey_screen()
    print('three-mode challenge and full special journeys integrated')


if __name__ == '__main__':
    main()
