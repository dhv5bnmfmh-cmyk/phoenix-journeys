from pathlib import Path
import re


def require_replace(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise SystemExit(f'{label} anchor not found')
    return text.replace(old, new, 1)


data_path = Path('app/lib/data/datong_yungang_gold_content.dart')
data = data_path.read_text()

discovery_block = r'''const _commonDiscovery = _Fact('云冈石窟位于今天的大同，主要营造于北魏以平城为都城的五至六世纪。它既是皇室支持的佛教石窟工程，也是观察北魏政治、宗教与艺术交流的重要遗存。', '云冈主要形成于北魏平城时代，是皇室支持的佛教石窟工程。', 'Hang đá Vân Cương ở Đại Đồng ngày nay, chủ yếu được kiến tạo trong thế kỷ V–VI khi Bình Thành là kinh đô Bắc Ngụy. Đây vừa là công trình hang đá Phật giáo được hoàng gia bảo trợ, vừa là di sản quan trọng để quan sát chính trị, tôn giáo và giao lưu nghệ thuật thời Bắc Ngụy.', 'The Yungang Grottoes in present-day Datong were created mainly in the fifth and sixth centuries while Pingcheng was the Northern Wei capital. They were both an imperially supported Buddhist cave project and an important record of Northern Wei politics, religion, and artistic exchange.');

const _levelFacts = <_Fact>[
  _Fact('398年北魏定都平城，也就是今天的大同一带。云冈靠近这个政治中心，后来才有条件集中资源进行大规模开凿。', '北魏定都平城后，云冈靠近国家政治中心。', 'Năm 398, Bắc Ngụy định đô ở Bình Thành, khu vực Đại Đồng ngày nay. Vân Cương ở gần trung tâm chính trị này nên về sau mới có điều kiện tập trung nguồn lực để khai tạc quy mô lớn.', 'In 398 the Northern Wei established its capital at Pingcheng, in the area of present-day Datong. Yungang’s proximity to this political center later made large-scale, resource-intensive carving possible.'),
  _Fact('460年，文成帝支持昙曜主持开凿五所大像窟，今天称为昙曜五窟，即第16至20窟。它们把皇室支持与云冈早期的巨型造像直接联系起来。', '460年开凿的昙曜五窟是云冈早期大型营造的核心。', 'Năm 460, Văn Thành Đế ủng hộ Đàm Diệu chủ trì khai tạc năm hang tượng lớn, ngày nay gọi là Ngũ động Đàm Diệu, tức hang 16 đến 20. Chúng liên kết trực tiếp sự bảo trợ của hoàng gia với tượng khổng lồ thời kỳ đầu Vân Cương.', 'In 460, with Emperor Wencheng’s support, Tanyao directed the carving of five great image caves, now known as the Five Caves of Tanyao, Caves 16 through 20. They directly connect imperial support with Yungang’s early colossal imagery.'),
  _Fact('云冈早期大型开凿不是孤立的宗教活动。文成帝时期，朝廷对佛教的支持转化为由国家资源推动的石窟营造，说明宗教政策会改变开窟的规模与条件。', '文成帝时期的佛教支持推动了云冈早期大型开凿。', 'Việc khai tạc quy mô lớn thời kỳ đầu Vân Cương không phải hoạt động tôn giáo tách biệt. Dưới thời Văn Thành Đế, sự ủng hộ Phật giáo của triều đình được chuyển thành công trình hang đá do nguồn lực nhà nước thúc đẩy, cho thấy chính sách tôn giáo có thể thay đổi quy mô và điều kiện khai tạc.', 'Yungang’s early monumental carving was not an isolated religious activity. Under Emperor Wencheng, court support for Buddhism became a cave-building program backed by state resources, showing how religious policy could change the scale and conditions of carving.'),
  _Fact('按洞窟形制、造像内容和艺术样式，云冈通常分为早、中、晚三个主要阶段：早期以昙曜五窟为代表，中期进入大规模营造高峰，494年迁都洛阳以后转入以中小型窟龛为主的晚期。', '云冈可分早、中、晚三期，494年迁都是重要转折。', 'Theo hình thức hang, nội dung tượng và phong cách nghệ thuật, Vân Cương thường được chia thành ba giai đoạn chính: thời kỳ đầu tiêu biểu là Ngũ động Đàm Diệu, thời kỳ giữa đạt đỉnh kiến tạo quy mô lớn, và sau khi dời đô đến Lạc Dương năm 494 bước vào thời kỳ muộn với các hang và khám cỡ vừa, nhỏ là chủ yếu.', 'By cave form, iconographic content, and artistic style, Yungang is commonly divided into three main phases: an early phase represented by the Five Caves of Tanyao, a middle peak of large-scale construction, and a late phase after the 494 move to Luoyang dominated by smaller caves and niches.'),
  _Fact('云冈中期在孝文帝时期达到营造高峰。洞窟布局与雕饰更加复杂，也出现更多中国宫殿建筑式样和本土化表达，显示佛教石窟艺术正在北魏社会中继续转化。', '中期云冈更复杂，也出现更多中国式建筑与本土化表达。', 'Thời kỳ giữa Vân Cương đạt đỉnh kiến tạo dưới thời Hiếu Văn Đế. Bố cục hang và trang trí trở nên phức tạp hơn, đồng thời xuất hiện nhiều mô thức kiến trúc cung điện Trung Hoa và cách biểu đạt bản địa hóa hơn, cho thấy nghệ thuật hang đá Phật giáo tiếp tục biến đổi trong xã hội Bắc Ngụy.', 'Yungang’s middle phase reached a construction peak under Emperor Xiaowen. Cave layouts and decoration became more complex, with more Chinese palace-architectural forms and localized expression, showing Buddhist cave art continuing to transform within Northern Wei society.'),
  _Fact('494年北魏迁都洛阳后，云冈大规模开凿随之停止，但造像活动没有同时消失。政治中心的移动改变了大型皇家工程的条件，却没有让这处石窟在同一天失去所有营造者。', '494年迁都使大规模开凿停止，但造像活动没有立刻结束。', 'Sau khi Bắc Ngụy dời đô đến Lạc Dương năm 494, việc khai tạc quy mô lớn ở Vân Cương chấm dứt, nhưng hoạt động tạo tượng không biến mất cùng lúc. Sự chuyển dịch trung tâm chính trị làm thay đổi điều kiện của công trình hoàng gia lớn, chứ không khiến nơi này mất toàn bộ người tiếp tục kiến tạo ngay trong một ngày.', 'After the Northern Wei moved its capital to Luoyang in 494, large-scale carving at Yungang ceased, but image-making did not vanish at the same moment. The political shift changed the conditions for major royal projects without instantly ending all carving at the site.'),
  _Fact('迁都以后，贵族、中下层官吏与普通信众继续利用平城留下的技术，在云冈开凿许多中小型洞窟和龛像。赞助者范围的变化，也解释了为什么晚期规模变小而活动仍能延续。', '迁都后，更多社会群体继续开凿中小型窟龛。', 'Sau khi dời đô, quý tộc, quan lại cấp trung và thấp cùng tín đồ bình dân tiếp tục sử dụng kỹ thuật còn lại ở Bình Thành để khai tạc nhiều hang và khám cỡ vừa, nhỏ tại Vân Cương. Sự thay đổi phạm vi người bảo trợ cũng giải thích vì sao quy mô thời kỳ muộn nhỏ đi nhưng hoạt động vẫn tiếp tục.', 'After the capital move, nobles, middle- and lower-ranking officials, and lay believers continued using skills retained at Pingcheng to carve many smaller caves and niches at Yungang. The broadened range of patrons helps explain why late works became smaller while activity continued.'),
  _Fact('云冈艺术并不是把一种外来样式原样搬进中国。它吸收南亚、中亚佛教艺术因素，又与中国文化传统结合，在五世纪形成具有本地特色的石窟艺术语言。', '云冈融合南亚、中亚佛教艺术与中国文化传统。', 'Nghệ thuật Vân Cương không đơn thuần sao chép một phong cách ngoại lai. Nó tiếp nhận các yếu tố nghệ thuật Phật giáo từ Nam Á và Trung Á rồi kết hợp với truyền thống văn hóa Trung Hoa, hình thành ngôn ngữ nghệ thuật hang đá mang đặc sắc địa phương trong thế kỷ V.', 'Yungang art did not simply copy a foreign style. It absorbed Buddhist artistic elements from South and Central Asia and combined them with Chinese cultural traditions, forming a distinctive local cave-art language in the fifth century.'),
  _Fact('把云冈的早、中、晚三期放在一起看，可以看到政治、赞助者和艺术语言同步变化：从皇室支持的巨像，到更复杂的中期洞窟，再到迁都后的中小窟龛，石窟群本身就是一条历史时间线。', '云冈各期的规模、赞助与艺术变化组成一条历史时间线。', 'Khi đặt ba giai đoạn đầu, giữa và muộn của Vân Cương cạnh nhau, có thể thấy chính trị, người bảo trợ và ngôn ngữ nghệ thuật thay đổi đồng thời: từ tượng khổng lồ được hoàng gia hỗ trợ, đến hang thời giữa phức tạp hơn, rồi các hang và khám nhỏ sau dời đô. Chính quần thể hang đá tạo thành một dòng thời gian lịch sử.', 'Viewed together, Yungang’s early, middle, and late phases show politics, patronage, and artistic language changing in tandem: from imperially backed colossal images, to more complex middle-period caves, to smaller post-capital-move caves and niches. The cave complex itself becomes a historical timeline.'),
  _Fact('云冈的重要性不只在规模。联合国教科文组织认为，它让佛教石窟艺术在中国形成鲜明的自身特征，并对后来中国乃至东亚的佛教石窟艺术产生深远影响，因此也是理解佛教艺术在中国发展与转化的重要节点。', '云冈形成鲜明艺术特征，并深刻影响后来中国和东亚的佛教石窟艺术。', 'Tầm quan trọng của Vân Cương không chỉ nằm ở quy mô. UNESCO cho rằng nơi đây giúp nghệ thuật hang đá Phật giáo hình thành đặc trưng riêng rõ nét tại Trung Quốc và tạo ảnh hưởng sâu rộng đến nghệ thuật hang đá Phật giáo về sau ở Trung Quốc và Đông Á, vì vậy đây là một nút quan trọng để hiểu quá trình phát triển và biến đổi của nghệ thuật Phật giáo tại Trung Quốc.', 'Yungang matters for more than its scale. UNESCO identifies it as a place where Buddhist cave art developed a distinct character in China and exerted far-reaching influence on later Buddhist cave art in China and East Asia, making it a key point for understanding the development and transformation of Buddhist art in China.'),
];

DiscoveryEntry _discovery'''

data, count = re.subn(
    r"const _commonDiscovery = _Fact\(.*?\n\];\n\nDiscoveryEntry _discovery",
    discovery_block,
    data,
    count=1,
    flags=re.S,
)
if count != 1:
    raise SystemExit(f'discovery block replacement count={count}')

data = require_replace(
    data,
    "  final discoveries = <DiscoveryEntry>[_discovery(_commonDiscovery), _discovery(_levelFacts[level - 1]), if (level >= 5) _discovery(_levelFacts[(level + 3) % _levelFacts.length])];",
    "  final discoveries = <DiscoveryEntry>[_discovery(_commonDiscovery), if (level >= 5) _discovery(_levelFacts[level - 2]), _discovery(_levelFacts[level - 1])];",
    'Discovery selection rule',
)
data = require_replace(
    data,
    "sourceIds: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes'])",
    "sourceIds: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes', 'neac-datong-yungang-context'])",
    'Discovery source trace',
)
source_anchor = "    RemediatedSourceBinding(id: 'ncha-datong-yungang-grottoes', publisher: '国家文物局', scope: 'Yungang phases, Tanyao caves, post-494 smaller and popular carving'),\n"
data = require_replace(
    data,
    source_anchor,
    source_anchor + "    RemediatedSourceBinding(id: 'neac-datong-yungang-context', publisher: '国家民族事务委员会', scope: 'Pingcheng capital context, imperial support, Tanyao Five Caves and cultural interaction'),\n",
    'source binding',
)
data_path.write_text(data)

challenge_path = Path('app/lib/widgets/journey_challenge_panel.dart')
challenge = challenge_path.read_text()
challenge = require_replace(
    challenge,
    "      'suzhou-humble-administrators-garden' =>\n        _adaptiveGrammarForJourney(journeyId, difficulty),",
    "      'suzhou-humble-administrators-garden' ||\n      'datong-yungang-grottoes' =>\n        _adaptiveGrammarForJourney(journeyId, difficulty),",
    'grammar journey switch',
)
challenge = require_replace(
    challenge,
    "      'literary-roaming' => (\n",
    """      'datong-yungang-grottoes' => (\n          focus: '昙曜五窟与迁都后的较小窟龛',\n          insight: '理解云冈规模怎样随时代改变',\n          subject: '云冈的早中晚分期',\n          action: '记录营造规模和艺术语言的变化',\n          result: '理解迁都前后的历史转折',\n          cause: '494年北魏迁都洛阳',\n          resultSubject: '云冈大规模的皇家开凿',\n          resultAction: '随之停止，而较小窟龛继续出现',\n        ),\n      'literary-roaming' => (\n""",
    'adaptive grammar context',
)
suzhou_block = """      'suzhou-humble-administrators-garden' => [\n        '程朗第一次消失后，陈玉兰没有叫他回来。',\n        '第二次看不见程朗时，陈玉兰立刻追过转弯。',\n        '程朗在下一处没有回头，也没有等待外婆。',\n        '陈玉兰说完“下一处等我”，最后还是追了上去。',\n      ],\n      _ => [\n"""
datong_distractors = """      'suzhou-humble-administrators-garden' => [\n        '程朗第一次消失后，陈玉兰没有叫他回来。',\n        '第二次看不见程朗时，陈玉兰立刻追过转弯。',\n        '程朗在下一处没有回头，也没有等待外婆。',\n        '陈玉兰说完“下一处等我”，最后还是追了上去。',\n      ],\n      'datong-yungang-grottoes' => [\n        '父亲把三段墨绳重新接回一根，三个人继续等他发号施令。',\n        '魏岚保住了唯一传人的位置，也没有把墨绳分给魏朔和阿砾。',\n        '魏朔第一次弹线时，魏岚立刻替他收回绳子并改掉黑线。',\n        '父亲在崖路转弯处叫魏岚追上去，她带着整根墨绳离开。',\n      ],\n      _ => [\n"""
challenge = require_replace(challenge, suzhou_block, datong_distractors, 'Datong distractors')
missing_anchor = """  static List<String> _missingDistractors(\n    String journeyId,\n    List<String> discoveries,\n    JourneyChallengeDifficulty difficulty,\n  ) {\n    final specific = switch (journeyId) {\n"""
missing_replacement = """  static List<String> _missingDistractors(\n    String journeyId,\n    List<String> discoveries,\n    JourneyChallengeDifficulty difficulty,\n  ) {\n    if (journeyId == 'datong-yungang-grottoes') {\n      return _regularJourneyDistractors(journeyId);\n    }\n    final specific = switch (journeyId) {\n"""
challenge = require_replace(challenge, missing_anchor, missing_replacement, 'missing distractor function')
challenge_path.write_text(challenge)

runtime_test = Path('app/test/datong_yungang_gold_runtime_test.dart')
test = runtime_test.read_text()
old_test = """  test('Discovery is deep and vocabulary is active-only', () {\n    for (var level = 1; level <= 10; level++) {\n      final content = datongYungangGoldLevelContent(level);\n      expect(content.discoveries.length, level < 5 ? 2 : 3);\n      final visible = '${content.storyParagraphs.join()}${content.discoveries.map((item) => item.text).join()}';\n      expect(content.words.every((word) => visible.contains(word.word)), isTrue);\n    }\n  });\n"""
new_test = """  test('Discovery is deep, chronological and four-language aligned', () {\n    const newKnowledgeAnchors = <String>[\n      '398年北魏定都平城',\n      '460年',\n      '宗教政策',\n      '早、中、晚三个主要阶段',\n      '中期',\n      '494年',\n      '贵族、中下层官吏与普通信众',\n      '南亚、中亚',\n      '历史时间线',\n      '东亚',\n    ];\n    for (var level = 1; level <= 10; level++) {\n      final content = datongYungangGoldLevelContent(level);\n      expect(content.discoveries.length, level < 5 ? 2 : 3);\n      expect(content.discoveries.last.text, contains(newKnowledgeAnchors[level - 1]));\n      expect(\n        content.discoveries.every(\n          (item) => item.pinyin.isNotEmpty && item.vietnamese.isNotEmpty && item.english.isNotEmpty,\n        ),\n        isTrue,\n      );\n      if (level >= 5) {\n        expect(\n          content.discoveries[1].text,\n          datongYungangGoldLevelContent(level - 1).discoveries.last.text,\n        );\n      }\n      final visible = '${content.storyParagraphs.join()}${content.discoveries.map((item) => item.text).join()}';\n      expect(content.words.every((word) => visible.contains(word.word)), isTrue);\n    }\n  });\n\n  test('Founder-reviewed Datong vocabulary catalog is preserved', () {\n    expect(\n      datongYungangWords.map((word) => word.word).toList(growable: false),\n      const ['迁都', '墨绳', '巨像', '传人', '散伙', '石阶', '断口', '小龛', '开凿', '崖壁', '分期', '营造'],\n    );\n  });\n"""
test = require_replace(test, old_test, new_test, 'runtime Discovery test')
runtime_test.write_text(test)

Path('app/test/datong_yungang_challenge_runtime_test.dart').write_text(r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/datong_yungang_gold_content.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

String _identity(String value) => value;

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Datong active Challenge is journey-grounded in all three modes', (tester) async {
    final lv1 = datongYungangGoldLevelContent(1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 430,
            height: 900,
            child: JourneyChallengePanel(
              journeyId: datongYungangJourneyId,
              storyParagraphs: lv1.storyParagraphs,
              discoveryTexts: lv1.discoveries.map((item) => item.text).toList(growable: false),
              profile: null,
              seed: 186,
              displayText: _identity,
              onResolved: (_, __) async {},
              onAllCompleted: () async {},
              autoNarrate: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('challenge-mode-paragraphRebuild')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('长廊'), findsNothing);
    await _tap(tester, 'challenge-option-correct-0');
    await _tap(tester, 'challenge-option-correct-1');
    await _tap(tester, 'challenge-submit');
    await _tap(tester, 'challenge-dialog-action');

    expect(find.byKey(const ValueKey('challenge-mode-grammarRepair')), findsOneWidget);
    expect(find.textContaining('昙曜五窟与迁都后的较小窟龛'), findsWidgets);
    expect(find.textContaining('通过参观这里'), findsNothing);
    await _tap(tester, 'challenge-grammar-segment-1');
    await _tap(tester, 'challenge-option-correct');
    await _tap(tester, 'challenge-submit');
    await _tap(tester, 'challenge-dialog-action');

    expect(find.byKey(const ValueKey('challenge-mode-missingSentence')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('很快离开了这里'), findsNothing);
    expect(find.textContaining('沿途景色'), findsNothing);
    expect(find.textContaining('园林'), findsNothing);
  });
}
''')
