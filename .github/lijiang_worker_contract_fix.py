from pathlib import Path

p = Path('app/lib/data/journey_expansion_batch_two.dart')
text = p.read_text()

# Remove the extra runtime StorySourceRecord. NEAC remains in the internal Fact First
# ledger, but the batch-two active registry keeps its established two-source-per-Journey
# UNESCO + government contract.
extra = """  StorySourceRecord(
    id: 'neac-naxi-customs',
    title: '纳西族风俗习惯',
    publisher: '国家民族事务委员会',
    url: 'https://www.neac.gov.cn/seac/ztzl/nxz/fsxg.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-yunnan-lijiang-gucheng-dayan-old-town'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-17',
  ),
"""
if extra not in text:
    raise SystemExit('extra NEAC runtime source marker missing')
text = text.replace(extra, '', 1)

old = """final lijiangOldTownJourney = _record(
  id: lijiangOldTownJourneyId,
  title: '丽江 · 大研古城：$lijiangOldTownCanonicalTitle',
  geoNodeId: 'cn-yunnan-lijiang-gucheng-dayan-old-town',
  paragraphs: lijiangOldTownGoldLevelContent(5).storyParagraphs,
  sources: const [
    'unesco-lijiang-old-town',
    'yunnan-lijiang-old-town',
    'neac-naxi-customs',
  ],
  tags: const ['丽江', '大研古城', '纳西文化', '茶马古道', '水系'],
);"""
new = """final lijiangOldTownJourney = _record(
  id: 'lijiang-old-town',
  title: '丽江 · 大研古城：$lijiangOldTownCanonicalTitle',
  geoNodeId: 'cn-yunnan-lijiang-gucheng-dayan-old-town',
  paragraphs: lijiangOldTownGoldLevelContent(5).storyParagraphs,
  sources: const ['unesco-lijiang-old-town', 'yunnan-lijiang-old-town'],
  tags: const ['丽江', '大研古城', '纳西文化', '茶马古道', '水系'],
);"""
if old not in text:
    raise SystemExit('active Lijiang record marker missing')
text = text.replace(old, new, 1)
p.write_text(text)
