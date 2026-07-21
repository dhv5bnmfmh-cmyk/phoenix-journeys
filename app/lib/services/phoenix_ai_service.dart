import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PhoenixGuideFeedback {
  const PhoenixGuideFeedback({
    required this.reply,
    required this.isOfflineFallback,
    this.provider = 'local',
    this.model = '',
    this.qualityReviewed = false,
    this.qualityScore = 0,
  });

  final String reply;
  final bool isOfflineFallback;
  final String provider;
  final String model;
  final bool qualityReviewed;
  final int qualityScore;
}

class PhoenixWritingFeedback {
  const PhoenixWritingFeedback({
    required this.corrected,
    required this.explanation,
    required this.natural,
    required this.encouragement,
    required this.isOfflineFallback,
    this.provider = 'local',
    this.model = '',
    this.qualityReviewed = false,
    this.qualityScore = 0,
  });

  final String corrected;
  final String explanation;
  final String natural;
  final String encouragement;
  final bool isOfflineFallback;
  final String provider;
  final String model;
  final bool qualityReviewed;
  final int qualityScore;
}

class PhoenixConversationFeedback {
  const PhoenixConversationFeedback({
    required this.reply,
    required this.isOfflineFallback,
    this.provider = 'local',
    this.model = '',
    this.qualityReviewed = false,
    this.qualityScore = 0,
  });

  final String reply;
  final bool isOfflineFallback;
  final String provider;
  final String model;
  final bool qualityReviewed;
  final int qualityScore;
}

class PhoenixLearningReport {
  const PhoenixLearningReport({
    required this.summary,
    required this.strengths,
    required this.focusAreas,
    required this.nextActions,
    required this.recommendedWords,
    required this.recommendedPattern,
    required this.isOfflineFallback,
    this.provider = 'local',
    this.model = '',
    this.qualityReviewed = false,
    this.qualityScore = 0,
  });

  final String summary;
  final List<String> strengths;
  final List<String> focusAreas;
  final List<String> nextActions;
  final List<String> recommendedWords;
  final String recommendedPattern;
  final bool isOfflineFallback;
  final String provider;
  final String model;
  final bool qualityReviewed;
  final int qualityScore;
}

class PhoenixAiService {
  PhoenixAiService({
    http.Client? client,
    Uri? endpoint,
    this.timeout = const Duration(seconds: 42),
  }) : _client = client ?? http.Client(),
       endpoint = endpoint ?? Uri.base.resolve('/api/phoenix-ai');

  final http.Client _client;
  final Uri endpoint;
  final Duration timeout;

  Future<PhoenixGuideFeedback> askGuide({
    required String text,
    required String language,
    String journeyId = 'beijing-forbidden-city',
    Map<String, dynamic> learnerProfile = const <String, dynamic>{},
    List<Map<String, String>> conversation = const <Map<String, String>>[],
  }) async {
    final answer = text.trim();
    if (answer.length < 2) {
      return const PhoenixGuideFeedback(
        reply: '先写下一点你的观察，我会认真陪你继续探索。',
        isOfflineFallback: true,
      );
    }

    try {
      final body = await _post({
        'mode': 'guide',
        'text': answer,
        'language': language,
        'journeyId': journeyId,
        'learnerProfile': learnerProfile,
        'conversation': conversation,
      });
      final reply = body['reply'];
      if (reply is String && reply.trim().isNotEmpty) {
        final quality = _readObject(body, 'quality');
        return PhoenixGuideFeedback(
          reply: reply.trim(),
          isOfflineFallback: false,
          provider: _readText(body, 'provider', 'cloudflare'),
          model: _readText(body, 'model', ''),
          qualityReviewed: quality['reviewed'] == true,
          qualityScore: _readInt(quality, 'score'),
        );
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
    String journeyId = 'beijing-forbidden-city',
    Map<String, dynamic> learnerProfile = const <String, dynamic>{},
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
      final body = await _post({
        'mode': 'writing',
        'text': writing,
        'language': language,
        'journeyId': journeyId,
        'learnerProfile': learnerProfile,
      });
      final feedback = _readObject(body, 'feedback');
      if (feedback.isNotEmpty) {
        final quality = _readObject(body, 'quality');
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
          provider: _readText(body, 'provider', 'cloudflare'),
          model: _readText(body, 'model', ''),
          qualityReviewed: quality['reviewed'] == true,
          qualityScore: _readInt(quality, 'score'),
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

  Future<PhoenixConversationFeedback> practiceConversation({
    required String text,
    required String language,
    String journeyId = 'beijing-forbidden-city',
    Map<String, dynamic> learnerProfile = const <String, dynamic>{},
    List<Map<String, String>> conversation = const <Map<String, String>>[],
  }) async {
    final speech = text.trim();
    if (speech.length < 2) {
      return const PhoenixConversationFeedback(
        reply: '先说一句你现在想到的话，我们从那里开始聊。',
        isOfflineFallback: true,
      );
    }

    try {
      final body = await _post({
        'mode': 'conversation',
        'text': speech,
        'language': language,
        'journeyId': journeyId,
        'learnerProfile': learnerProfile,
        'conversation': conversation,
      });
      final reply = body['reply'];
      if (reply is String && reply.trim().isNotEmpty) {
        final quality = _readObject(body, 'quality');
        return PhoenixConversationFeedback(
          reply: reply.trim(),
          isOfflineFallback: false,
          provider: _readText(body, 'provider', 'cloudflare'),
          model: _readText(body, 'model', ''),
          qualityReviewed: quality['reviewed'] == true,
          qualityScore: _readInt(quality, 'score'),
        );
      }
    } catch (_) {
      // Fall through to a transparent local response.
    }

    return PhoenixConversationFeedback(
      reply: '本地建议：你刚才说的是“$speech”。可以再补充一个原因或具体例子，让我们继续聊下去。',
      isOfflineFallback: true,
    );
  }

  Future<PhoenixLearningReport> buildLearningReport({
    required String text,
    required String language,
    String journeyId = 'beijing-forbidden-city',
    Map<String, dynamic> learnerProfile = const <String, dynamic>{},
  }) async {
    final learning = text.trim();
    if (learning.length < 2) {
      return const PhoenixLearningReport(
        summary: '学习记录还不够，完成一次回答或写作后再生成报告。',
        strengths: <String>[],
        focusAreas: <String>[],
        nextActions: <String>['先完成一次 Journey 回答或写作练习。'],
        recommendedWords: <String>[],
        recommendedPattern: '',
        isOfflineFallback: true,
      );
    }

    try {
      final body = await _post({
        'mode': 'learning',
        'text': learning,
        'language': language,
        'journeyId': journeyId,
        'learnerProfile': learnerProfile,
      });
      final report = _readObject(body, 'report');
      if (report.isNotEmpty) {
        final quality = _readObject(body, 'quality');
        return PhoenixLearningReport(
          summary: _readText(report, 'summary', '学习记录已整理。'),
          strengths: _readStringList(report, 'strengths'),
          focusAreas: _readStringList(report, 'focusAreas'),
          nextActions: _readStringList(report, 'nextActions'),
          recommendedWords: _readStringList(report, 'recommendedWords'),
          recommendedPattern: _readText(report, 'recommendedPattern', ''),
          isOfflineFallback: false,
          provider: _readText(body, 'provider', 'cloudflare'),
          model: _readText(body, 'model', ''),
          qualityReviewed: quality['reviewed'] == true,
          qualityScore: _readInt(quality, 'score'),
        );
      }
    } catch (_) {
      // Fall through to a transparent local response.
    }

    return const PhoenixLearningReport(
      summary: '目前无法连接 PhoenixLearningAgent，学习资料仍保存在本机。',
      strengths: <String>[],
      focusAreas: <String>['稍后重新生成完整学习分析。'],
      nextActions: <String>['复习本次 Journey 的生词并再写两句话。'],
      recommendedWords: <String>[],
      recommendedPattern: '因为……，所以……',
      isOfflineFallback: true,
    );
  }

  Future<Map<String, dynamic>> _post(Map<String, dynamic> payload) async {
    final response = await _client
        .post(
          endpoint,
          headers: const {'content-type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(timeout);
    final body = _decodeObject(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(_readText(body, 'error', 'Phoenix AI 请求失败。'));
    }
    return body;
  }

  Map<String, dynamic> _decodeObject(String source) {
    final value = jsonDecode(source);
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  Map<String, dynamic> _readObject(
    Map<String, dynamic> source,
    String key,
  ) {
    final value = source[key];
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

  int _readInt(Map<String, dynamic> source, String key) {
    final value = source[key];
    return value is num ? value.round() : 0;
  }

  List<String> _readStringList(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is! List) return const <String>[];
    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
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
