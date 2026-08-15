from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one target, found {count}')
    p.write_text(text.replace(old, new, 1))


# Quanzhou joins the existing dedicated Gold Discovery depth contract: Lv1-Lv4=2, Lv5-Lv10=3.
for path in [
    'app/lib/services/journey_content_quality_auditor.dart',
    'app/test/adaptive_story_quality_test.dart',
    'app/test/all_journey_adaptive_level_test.dart',
    'app/test/all_journey_adaptive_levels_test.dart',
]:
    replace_once(
        path,
        "              experience.id == 'luoyang-longmen-grottoes' ||\n              experience.id == 'jiangmen-kaiping-diaolou')" if 'services/' in path else
        "      journeyId == 'luoyang-longmen-grottoes' ||\n      journeyId == 'jiangmen-kaiping-diaolou')",
        "              experience.id == 'luoyang-longmen-grottoes' ||\n              experience.id == 'jiangmen-kaiping-diaolou' ||\n              experience.id == 'quanzhou-kaiyuan-temple')" if 'services/' in path else
        "      journeyId == 'luoyang-longmen-grottoes' ||\n      journeyId == 'jiangmen-kaiping-diaolou' ||\n      journeyId == 'quanzhou-kaiyuan-temple')",
    )

# Publication provenance: keep the existing Story sources and add independent official corroboration.
replace_once(
    'app/lib/data/quanzhou_kaiyuan_gold_content.dart',
    "        sourceIds: const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history'],",
    "        sourceIds: const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history', 'quanzhou-religion-kaiyuan'],",
)

# Existing catalog tests must recognize the promoted dedicated Quanzhou base package.
replace_once(
    'app/test/daily_journey_engine_test.dart',
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou') {\n        expect(journey.discoveries.length, 3, reason: journey.id);",
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou' ||\n          journey.id == 'quanzhou-kaiyuan-temple') {\n        expect(journey.discoveries.length, 3, reason: journey.id);",
)
replace_once(
    'app/test/seven_day_journey_catalog_test.dart',
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou') {\n        expect(journey.content.storyParagraphs, hasLength(2), reason: journey.id);",
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou' ||\n          journey.id == 'quanzhou-kaiyuan-temple') {\n        expect(journey.content.storyParagraphs, hasLength(2), reason: journey.id);",
)
replace_once(
    'app/test/seven_day_journey_catalog_test.dart',
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou') {\n        expect(journey.discoveries, hasLength(3), reason: journey.id);",
    "      } else if (journey.id == 'jiangmen-kaiping-diaolou' ||\n          journey.id == 'quanzhou-kaiyuan-temple') {\n        expect(journey.discoveries, hasLength(3), reason: journey.id);",
)

# Gold registry synchronization after Quanzhou promotion.
replace_once(
    'app/test/guangzhou_future_gold_candidate_test.dart',
    '    expect(approvedGoldSemanticFingerprints, hasLength(11));',
    '    expect(approvedGoldSemanticFingerprints, hasLength(12));',
)
replace_once(
    'app/test/guangzhou_future_gold_candidate_test.dart',
    '    expect(approvedNarrativeDnaCatalog, hasLength(11));',
    '    expect(approvedNarrativeDnaCatalog, hasLength(12));',
)
replace_once(
    'app/test/longmen_kaiping_compliance_closure_test.dart',
    "  test('approved Gold catalog has eleven identities and fifty-five clean pairs', () {\n    expect(approvedGoldSemanticFingerprints, hasLength(11));\n    final audit = auditApprovedGoldSemanticPairs();\n    expect(audit, hasLength(55));",
    "  test('approved Gold catalog has twelve identities and sixty-six clean pairs', () {\n    expect(approvedGoldSemanticFingerprints, hasLength(12));\n    final audit = auditApprovedGoldSemanticPairs();\n    expect(audit, hasLength(66));",
)
replace_once(
    'app/test/longmen_kaiping_compliance_closure_test.dart',
    "  test('Kaiping is approved Gold and remains distinct from the other ten', () {",
    "  test('Kaiping is approved Gold and remains distinct from the other eleven', () {",
)
replace_once(
    'app/test/longmen_kaiping_compliance_closure_test.dart',
    '    expect(comparisons, hasLength(10));',
    '    expect(comparisons, hasLength(11));',
)

# Adjacent-level proof: preserve the locked causal spine while allowing inserted semantic depth.
replace_once(
    'app/test/quanzhou_kaiyuan_gold_runtime_test.dart',
    """    for (var index = 1; index < stories.length; index++) {
      expect(stories[index], isNot(stories[index - 1]));
      expect(stories[index], contains(stories[index - 1]));
    }
""",
    """    for (var index = 1; index < stories.length; index++) {
      expect(stories[index], isNot(stories[index - 1]), reason: 'Lv${index + 1} must add semantic depth');
      expect(stories[index], contains('许安'), reason: 'Lv${index + 1} protagonist invariant');
      expect(stories[index], contains('许宁'), reason: 'Lv${index + 1} relationship invariant');
      expect(stories[index], contains('把钥匙放进姐姐手里'), reason: 'Lv${index + 1} enacted-choice invariant');
      expect(stories[index], contains('房间别替我留了'), reason: 'Lv${index + 1} cost/consequence spine');
    }
""",
)
