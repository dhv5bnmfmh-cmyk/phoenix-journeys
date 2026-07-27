import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:phoenix_journeys/services/phoenix_ai_service.dart';

const _jsonHeaders = <String, String>{
  'content-type': 'application/json; charset=utf-8',
};

void main() {
  test('guide client returns online PhoenixGuideAgent response', () async {
    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['mode'], 'guide');
      expect(body['journeyId'], 'beijing-forbidden-city');
      expect(body['language'], '越南语');

      return http.Response(
        jsonEncode({
          'mode': 'guide',
          'agent': 'PhoenixGuideAgent',
          'reply': '红墙确实能让空间显得安静而有距离。你还可以观察光线怎样改变红色。清晨和傍晚，你觉得哪一个时刻更适合停留？',
        }),
        200,
        headers: _jsonHeaders,
      );
    });
    final service = PhoenixAiService(
      client: client,
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final feedback = await service.askGuide(
      text: '我想观察红墙，因为它很安静。',
      language: '越南语',
    );

    expect(feedback.isOfflineFallback, isFalse);
    expect(feedback.reply, contains('红墙'));
  });

  test('guide client labels transparent local fallback', () async {
    final service = PhoenixAiService(
      client: MockClient((_) async => http.Response('unavailable', 503)),
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final feedback = await service.askGuide(
      text: '我喜欢黄色的屋顶。',
      language: '越南语',
    );

    expect(feedback.isOfflineFallback, isTrue);
    expect(feedback.reply, startsWith('本地建议：'));
    expect(feedback.reply, contains('屋顶'));
  });

  test('writing client reads structured PhoenixWritingAgent feedback', () async {
    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['mode'], 'writing');

      return http.Response(
        jsonEncode({
          'mode': 'writing',
          'agent': 'PhoenixWritingAgent',
          'feedback': {
            'corrected': '我最想参观太和殿，因为它很壮观。',
            'explanation': '在原因分句前加逗号。',
            'natural': '我最想去看看雄伟的太和殿。',
            'encouragement': '你的重点很明确。',
          },
        }),
        200,
        headers: _jsonHeaders,
      );
    });
    final service = PhoenixAiService(
      client: client,
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final feedback = await service.reviewWriting(
      text: '我最想参观太和殿因为它很壮观',
      language: '越南语',
    );

    expect(feedback.isOfflineFallback, isFalse);
    expect(feedback.corrected, contains('，'));
    expect(feedback.natural, contains('太和殿'));
  });

  test('writing client never presents local fallback as online AI', () async {
    final service = PhoenixAiService(
      client: MockClient((_) async => throw Exception('offline')),
      endpoint: Uri.parse('https://example.test/api/phoenix-ai'),
    );

    final feedback = await service.reviewWriting(
      text: '我想观察红墙',
      language: '越南语',
    );

    expect(feedback.isOfflineFallback, isTrue);
    expect(feedback.corrected, '我想观察红墙。');
    expect(feedback.explanation, contains('无法连接'));
  });
}
