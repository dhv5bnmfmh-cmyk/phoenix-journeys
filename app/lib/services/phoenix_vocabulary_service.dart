import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/journey_data.dart';

class PhoenixVocabularyExample {
  const PhoenixVocabularyExample({
    required this.chinese,
    required this.pinyin,
    required this.native,
    required this.english,
    required this.usageNote,
    required this.isOfflineFallback,
    this.provider = 'local',
    this.model = '',
    this.qualityReviewed = false,
    this.qualityScore = 0,
  });

  final String chinese;
  final String pinyin;
  final String native;
  final String english;
  final String usageNote;
  final bool isOfflineFallback;
  final String provider;
  final String model;
  final bool qualityReviewed;
  final int qualityScore;

  WordExample toWordExample({required String nativeLanguage}) {
    return WordExample(
      chinese: chinese,
      pinyin: pinyin,
      vietnamese: nativeLanguage == '英语' ? english : native,
      english: english,
    );
  }
}

class PhoenixVocabularyService {
  PhoenixVocabularyService({
    http.Client? client,
    Uri? endpoint,
    this.timeout = const Duration(seconds: 42),
  })  : _client = client ?? http.Client(),
        endpoint = endpoint ?? Uri.base.resolve('/api/phoenix-ai');

  static final Map<String, PhoenixVocabularyExample> _sessionCache = {};

  final http.Client _client;
  final Uri endpoint;
  final Duration timeout;

  Future<PhoenixVocabularyExample> generateExample({
    required WordEntry entry,
    required String language,
    required String journeyId,
    required String contextChinese,
    required String contextPinyin,
    required String contextNative,
    required String contextEnglish,
    required PhoenixVocabularyExample fallback,
  }) async {
    final cacheKey = '$journeyId|${entry.word}|$language';
    final cached = _sessionCache[cacheKey];
    if (cached != null) return cached;

    try {
      final response = await _client
          .post(
            endpoint,
            headers: const {'content-type': 'application/json'},
            body: jsonEncode({
              'mode': 'vocabulary',
              'text': entry.word,
              'word': entry.word,
              'pinyin': entry.pinyin,
              'partOfSpeech': entry.partOfSpeech,
              'simpleChinese': entry.simpleChinese,
              'nativeDefinition': entry.nativeDefinition(language),
              'englishDefinition': entry.englishDefinition,
              'contextChinese': contextChinese,
              'contextPinyin': contextPinyin,
              'contextNative': contextNative,
              'contextEnglish': contextEnglish,
              'language': language,
              'journeyId': journeyId,
            }),
          )
          .timeout(timeout);
      final body = _decodeObject(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError(_readText(body, 'error', 'Phoenix AI 请求失败。'));
      }

      final example = _readObject(body, 'example');
      final quality = _readObject(body, 'quality');
      final generated = PhoenixVocabularyExample(
        chinese: _readText(example, 'chinese', ''),
        pinyin: _readText(example, 'pinyin', ''),
        native: _readText(example, 'native', ''),
        english: _readText(example, 'english', ''),
        usageNote: _readText(example, 'usageNote', ''),
        isOfflineFallback: false,
        provider: _readText(body, 'provider', 'cloudflare'),
        model: _readText(body, 'model', ''),
        qualityReviewed: quality['reviewed'] == true,
        qualityScore: _readInt(quality, 'score'),
      );
      _validate(generated, entry.word);
      _sessionCache[cacheKey] = generated;
      return generated;
    } catch (_) {
      _sessionCache[cacheKey] = fallback;
      return fallback;
    }
  }

  void _validate(PhoenixVocabularyExample example, String word) {
    final forbidden = [
      '故事里出现了',
      '老师请我解释',
      '我想学会使用',
      '这个词出现在故事里',
    ];
    if (!example.chinese.contains(word) ||
        example.pinyin.isEmpty ||
        example.native.isEmpty ||
        example.english.isEmpty ||
        example.usageNote.isEmpty ||
        forbidden.any(example.chinese.contains)) {
      throw const FormatException('Phoenix AI returned a placeholder example.');
    }
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

  void close() {
    _client.close();
  }
}
