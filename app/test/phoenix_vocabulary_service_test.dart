import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/services/phoenix_vocabulary_service.dart';

void main() {
  const fallback = PhoenixVocabularyExample(
    chinese: '秦淮河边可以看到传统牌坊。',
    pinyin: 'Qínhuái Hé biān kěyǐ kàndào chuántǒng páifāng.',
    native: 'Có thể thấy cổng bài truyền thống bên sông Tần Hoài.',
    english: 'Traditional archways can be seen beside the Qinhuai River.',
    usageNote: '来自当前旅程的真实语境。',
    isOfflineFallback: true,
  );

  const entry = WordEntry(
    word: '牌坊',
    pinyin: 'páifāng',
    partOfSpeech: '名词',
    simpleChinese: '有纪念或标志作用的传统门式建筑。',
    translation: 'Cổng bài truyền thống.',
    englishDefinition: 'ceremonial archway',
    symbol: '门',
  );

  test('explorer runtime returns the preloaded example without HTTP', () async {
    var requested = false;
    final client = MockClient((_) async {
      requested = true;
      throw StateError('Explorer runtime must not request AI examples.');
    });
    final service = PhoenixVocabularyService(
      client: client,
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final result = await service.generateExample(
      entry: entry,
      language: '越南语',
      journeyId: 'nanjing-qinhuai-river',
      contextChinese: fallback.chinese,
      contextPinyin: fallback.pinyin,
      contextNative: fallback.native,
      contextEnglish: fallback.english,
      fallback: fallback,
    );

    expect(requested, isFalse);
    expect(result.chinese, fallback.chinese);
    expect(result.provider, 'phoenix-preloaded-pack');
    expect(result.model, 'bundled');
    expect(result.qualityReviewed, isTrue);
    expect(result.qualityScore, 100);
    expect(result.usageNote, contains('预先下载'));
    service.close();
  });

  test('content pipeline can still generate a reviewed AI example', () async {
    final client = MockClient((request) async {
      final payload = jsonDecode(request.body) as Map<String, dynamic>;
      expect(payload['mode'], 'vocabulary');
      expect(payload['word'], '牌坊');
      return http.Response(
        jsonEncode({
          'provider': 'openai',
          'model': 'gpt-test',
          'example': {
            'chinese': '傍晚的灯光照亮了古老的牌坊。',
            'pinyin': 'Bàngwǎn de dēngguāng zhàoliàng le gǔlǎo de páifāng.',
            'native': 'Ánh đèn buổi tối chiếu sáng cổng vòm cổ.',
            'english': 'Evening lights illuminated the old ceremonial archway.',
            'usageNote': '“牌坊”常与“古老、石制、入口处”等词搭配。',
          },
          'quality': {'reviewed': true, 'score': 96},
        }),
        200,
        headers: const {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final service = PhoenixVocabularyService(
      client: client,
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final result = await service.generateExampleForContentPipeline(
      entry: entry,
      language: '越南语',
      journeyId: 'nanjing-qinhuai-river-authoring',
      contextChinese: fallback.chinese,
      contextPinyin: fallback.pinyin,
      contextNative: fallback.native,
      contextEnglish: fallback.english,
      fallback: fallback,
    );

    expect(result.chinese, contains('牌坊'));
    expect(result.isOfflineFallback, isFalse);
    expect(result.qualityReviewed, isTrue);
    expect(result.qualityScore, 96);
    service.close();
  });
}
