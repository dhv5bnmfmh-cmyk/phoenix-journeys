import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/extended_journey_catalog.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_one_pass.dart';
import 'package:phoenix_journeys/models/story_content.dart';

void main() {
  test('approved Nanjing government source record remains verified and applicable', () {
    final source = extendedJourneySources.singleWhere(
      (item) => item.id == nanjingQinhuaiSourceRecordId,
    );
    expect(source.title, '南京市夫子庙秦淮风光带风景名胜区条例');
    expect(source.publisher, '南京市人民政府');
    expect(source.kind, StorySourceKind.government);
    expect(source.verificationStatus, StoryVerificationStatus.verified);
    expect(source.languageCode, 'zh-CN');
    expect(source.geoNodeIds, contains('cn-jiangsu-nanjing-qinhuai'));
    expect(source.url, startsWith('https://www.nanjing.gov.cn/'));
  });

  test('supported narrative facts stay explicit and source-bounded', () {
    expect(
      nanjingQinhuaiSupportedNarrativeFacts,
      containsAll(<String>[
        '秦淮河及其两岸风貌属于风景名胜资源保护范围',
        '古桥梁属于受保护的风景名胜资源',
        '秦淮灯会属于保护传承的非物质文化遗产',
        '景区夜景照明受到专门管理',
        '照明等公用设施受规划、维护和安全要求约束',
        '移动或者改变公共设施需要依照规定取得批准',
      ]),
    );
    expect(
      nanjingQinhuaiSources.single.id,
      nanjingQinhuaiSourceRecordId,
    );
  });

  test('canonical learner content never asserts a cable-to-bridge prohibition', () {
    final learnerContent = <String>[
      for (final level in nanjingQinhuaiOnePassLevels)
        ...level.storyParagraphs,
      for (final spec in nanjingQinhuaiDiscoverySpecs) ...[
        spec.entry.text,
        spec.entry.simpleChinese,
        spec.entry.vietnamese,
        spec.entry.english,
        spec.learnerInsight,
        spec.check,
        spec.answer,
      ],
    ].join('\n');

    for (final unsupported in <String>[
      '电缆不得挂在古桥',
      '禁止把电缆固定在古桥',
      '古桥禁止挂线',
      '临时电缆不得',
      '桥体禁止布线',
    ]) {
      expect(
        learnerContent,
        isNot(contains(unsupported)),
        reason: 'unsupported claim must stay excluded: $unsupported',
      );
    }
    expect(
      RegExp(r'\d+\s*(V|伏|A|安培)').hasMatch(learnerContent),
      isFalse,
      reason: 'no invented engineering specification',
    );
  });

  test('old bridge remains generic and no fabricated named bridge restriction appears', () {
    final story = nanjingQinhuaiOnePassLevels
        .expand((level) => level.storyParagraphs)
        .join();
    expect(story, contains('古桥'));
    for (final namedBridge in <String>['文德桥', '武定桥', '镇淮桥', '文源桥']) {
      expect(story, isNot(contains(namedBridge)));
    }
    expect(story, isNot(contains('损坏古桥')));
    expect(story, isNot(contains('桥体受损')));
  });

  test('source guard records the unsupported claims we deliberately refuse to make', () {
    expect(
      nanjingQinhuaiExcludedUnsupportedClaims,
      contains('电缆不得挂在古桥上'),
    );
    expect(
      nanjingQinhuaiExcludedUnsupportedClaims,
      contains('临时照明电缆固定在古桥上被某一具体条文明确禁止'),
    );
    expect(
      nanjingQinhuaiExcludedUnsupportedClaims,
      contains('某座具名古桥存在本故事所称的特殊布线禁令'),
    );
  });
}
