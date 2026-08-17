from pathlib import Path

# 1) Dedicated Honghe Story publication contract mirrors other dedicated Gold/candidates.
p = Path('app/test/seven_day_journey_catalog_test.dart')
s = p.read_text()
needle = """      } else if (journey.id == lijiangOldTownJourneyId) {
        expect(
          journey.content.storyParagraphs,
          lijiangOldTownGoldLevelContent(5).storyParagraphs,
          reason: journey.id,
        );
      } else if (journey.id == 'jiangmen-kaiping-diaolou') {"""
replacement = """      } else if (journey.id == lijiangOldTownJourneyId) {
        expect(
          journey.content.storyParagraphs,
          lijiangOldTownGoldLevelContent(5).storyParagraphs,
          reason: journey.id,
        );
      } else if (journey.id == hongheHaniRiceTerracesJourneyId) {
        expect(
          journey.content.storyParagraphs,
          hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs,
          reason: journey.id,
        );
      } else if (journey.id == 'jiangmen-kaiping-diaolou') {"""
if needle not in s:
    raise SystemExit('seven-day insertion point not found')
s = s.replace(needle, replacement, 1)
# add import next to Lijiang import
import_needle = "import 'package:phoenix_journeys/data/lijiang_old_town_gold_content.dart';\n"
if import_needle not in s:
    raise SystemExit('seven-day Lijiang import not found')
s = s.replace(import_needle, import_needle + "import 'package:phoenix_journeys/data/honghe_hani_rice_terraces_gold_content.dart';\n", 1)
p.write_text(s)

# 2) Dedicated Honghe Discovery publication contract uses canonical Lv5 depth (3), not generic 4.
p = Path('app/test/daily_journey_engine_test.dart')
s = p.read_text()
needle = """      } else if (journey.id == lijiangOldTownJourneyId) {
        expect(
          journey.content.storyParagraphs,
          lijiangOldTownGoldLevelContent(5).storyParagraphs,
          reason: 'Lijiang candidate catalog metadata must bind active Lv5 Story',
        );
        expect(
          journey.discoveries,
          hasLength(lijiangOldTownGoldLevelContent(5).discoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == 'jiangmen-kaiping-diaolou') {"""
replacement = """      } else if (journey.id == lijiangOldTownJourneyId) {
        expect(
          journey.content.storyParagraphs,
          lijiangOldTownGoldLevelContent(5).storyParagraphs,
          reason: 'Lijiang candidate catalog metadata must bind active Lv5 Story',
        );
        expect(
          journey.discoveries,
          hasLength(lijiangOldTownGoldLevelContent(5).discoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == hongheHaniRiceTerracesJourneyId) {
        expect(
          journey.content.storyParagraphs,
          hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs,
          reason: 'Honghe candidate catalog metadata must bind active Lv5 Story',
        );
        expect(
          journey.discoveries,
          hasLength(hongheHaniRiceTerracesGoldLevelContent(5).discoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == 'jiangmen-kaiping-diaolou') {"""
if needle not in s:
    raise SystemExit('daily insertion point not found')
s = s.replace(needle, replacement, 1)
import_needle = "import 'package:phoenix_journeys/data/lijiang_old_town_gold_content.dart';\n"
if import_needle not in s:
    raise SystemExit('daily Lijiang import not found')
s = s.replace(import_needle, import_needle + "import 'package:phoenix_journeys/data/honghe_hani_rice_terraces_gold_content.dart';\n", 1)
p.write_text(s)

# 3) Replace brittle literal-only assertions with causal/behavioral equivalents.
p = Path('app/test/honghe_hani_rice_terraces_gold_test.dart')
s = p.read_text()
s = s.replace("          '水牛',\n", "          '牛',\n", 1)
s = s.replace("      expect(spec.longTermAnchor, contains('没犁完'));\n", "      expect(spec.longTermAnchor, contains('没有犁完'));\n", 1)
p.write_text(s)
