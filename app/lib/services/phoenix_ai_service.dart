import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PhoenixGuideFeedback {
  const PhoenixGuideFeedback({
    required this.reply,
    required this.isOfflineFallback,
  });

  final String reply;
  final bool isOfflineFallback;
}

class PhoenixWritingFeedback {
  const PhoenixWritingFeedback({
    required this.corrected,
    required this.explanation,
    required this.natural,
    required this.encouragement,
    required this.isOfflineFallback,
  });

  final String corrected;
  final String explanation;
  final String natural;
  final String encouragement;
  final bool isOfflineFallback;
}

class PhoenixAiService {
  PhoenixAiService({
    http.Client? client,
    Uri? endpoint,
    this.timeout = const Duration(seconds: 18),
  })  : _client = client ?? http.Client(),
        endpoint = endpoint ?? Uri.base.resolve('/api/phoenix-ai');

  final http.Client _client;
  final Uri endpoint;
  final Duration timeout;

  Future<PhoenixGuideFeedback> askGuide({
    required String text,
    required String language,
    String journeyId = 'beijing-forbidden-city',
  }) async {
    final answer = text.trim();
    if (answer.length < 2) {
      return const PhoenixGuideFeedback(
        reply: '先写下一点你的观察，我会认真陪你继续探索。',
        isOfflineFallback: true,
      );
    }

    try {
      final response = await _client
          .post(
            endpoint,
            headers: const {'content-type': 'application/json'},
            body: jsonEncode({
              'mode': 'guide',
              'text': answer,
              'language': language,
              'journeyId': journeyId,
            }),
          )
          .timeout(timeout);

      final body = _decodeObject(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final reply = body['reply'];
        if (reply is String && reply.trim().isNotEmpty) {
          return PhoenixGuideFeedback(
            reply: reply.trim(),
            isOfflineFallback: false,
          );
        }
      }
    } catch (_) {
      // Fall through to the transparent local response below.
    }

    return PhoenixGuideFeedback(
      reply: _localGuideReply(answer),
      isOfflineFallback: true,
    );
  }

  Future<PhoenixWritingFeedback> reviewWriting({
    required String text,
    required String language,
  }) async {
    final writing = text.trim();
    if (writing.length < 2) {
      return const PhoenixWritingFeedback(
        corrected: '',
        explanation: '请先写两三句话，我才能帮你分析。',
        natural: '',
        encouragement: '先把想法写出来，不需要一开始就追求完美。',
        isOfflineFallback: true,
      );
    }

    try {
      final response = await _client
          .post(
            endpoint,
            headers: const {'content-type': 'application/json'},
            body: jsonEncode({
              'mode': 'writing',
              'text': writing,
              'language': language,
            }),
          )
          .timeout(timeout);

      final body = _decodeObject(response.body);
      final feedback = body['feedback'];
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          feedback is Map<String, dynamic>) {
        return PhoenixWritingFeedback(
          corrected: _readText(feedback, 'corrected', writing),
          explanation: _readText(
            feedback,
            'explanation',
            '整体意思清楚，可以再补充一个具体细节。',
          ),
          natural: _readText(feedback, 'natural', writing),
          encouragement: _readText(
            feedback,
            'encouragement',
            '你已经把意思表达出来了，继续保持。',
          ),
          isOfflineFallback: false,
        );
      }
    } catch (_) {
      // Fall through to the transparent local response below.
    }

    final punctuated = _ensureChinesePunctuation(writing);
    return PhoenixWritingFeedback(
      corrected: punctuated,
      explanation: '目前无法连接 PhoenixWritingAgent，所以只完成了基础标点检查。',
      natural: punctuated,
      encouragement: '你的内容已经保存，可以稍后重新请求完整 AI 批改。',
      isOfflineFallback: true,
    );
  }

  Map<String, dynamic> _decodeObject(String source) {
    final value = jsonDecode(source);
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  String _readText(
    Map<String, dynamic> source,
    String key,
    String fallback,
  ) {
    final value = source[key];
    return value is String && value.trim().isNotEmpty ? value.trim() : fallback;
  }

  String _localGuideReply(String answer) {
    if (answer.contains('屋顶') || answer.contains('黄色')) {
      return '本地建议：你已经抓住了黄色屋顶这个醒目的细节。下次可以继续观察屋脊、光线和红墙怎样共同改变空间的感觉。它让你觉得更庄严，还是更温暖？';
    }
    if (answer.contains('红墙') || answer.contains('颜色')) {
      return '本地建议：红墙是很好的观察入口。你可以进一步写它在清晨、阴影或人群之间呈现出的变化。站在那里时，你最先感受到的是安静、距离，还是力量？';
    }
    if (answer.contains('人') || answer.contains('生活')) {
      return '本地建议：你正在把建筑和人的生活联系起来。可以再想象一个具体动作，例如走过宫门、等待仪式或守护文物。哪一个画面最能帮助你理解这里？';
    }
    return '本地建议：你的想法已经有清楚的方向。再加入一个你能看见、听见或触摸到的细节，画面会更具体。你愿意先补充哪一个细节？';
  }

  String _ensureChinesePunctuation(String value) {
    if (RegExp(r'[。！？!?]$').hasMatch(value)) return value;
    return '$value。';
  }

  void close() {
    _client.close();
  }
}
