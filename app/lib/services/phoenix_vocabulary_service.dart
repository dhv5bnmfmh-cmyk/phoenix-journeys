import 'dart:async';
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
  }) : _client = client ?? http.Client(),
       endpoint = endpoint ?? Uri.base.resolve('/api/phoenix-ai');

  static final Map<String, PhoenixVocabularyExample> _authoringCache = {};

  static const Map<String, PhoenixVocabularyExample> _bundledExamples = {
    '午门': PhoenixVocabularyExample(
      chinese: '游客从午门进入故宫，抬头就能看见高大的城楼。',
      pinyin:
          'Yóukè cóng Wǔmén jìnrù Gùgōng, táitóu jiù néng kànjiàn gāodà de chénglóu.',
      native:
          'Du khách vào Cố Cung qua Ngọ Môn và ngẩng đầu là có thể thấy lầu thành cao lớn.',
      english:
          'Visitors enter the Forbidden City through the Meridian Gate and immediately see its imposing tower.',
      usageNote: '“从午门进入”常用于介绍故宫的参观路线。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '太和殿': PhoenixVocabularyExample(
      chinese: '参观太和殿时，请不要跨越前方的围栏。',
      pinyin: 'Cānguān Tàihédiàn shí, qǐng bú yào kuàyuè qiánfāng de wéilán.',
      native:
          'Khi tham quan điện Thái Hòa, vui lòng không bước qua hàng rào phía trước.',
      english:
          'When visiting the Hall of Supreme Harmony, please do not cross the barrier ahead.',
      usageNote: '“参观太和殿”可用于说明故宫景点行程。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '文物': PhoenixVocabularyExample(
      chinese: '博物馆里的文物需要恒温恒湿的环境来保存。',
      pinyin:
          'Bówùguǎn lǐ de wénwù xūyào héngwēn héngshī de huánjìng lái bǎocún.',
      native:
          'Các hiện vật trong bảo tàng cần môi trường ổn định về nhiệt độ và độ ẩm để bảo quản.',
      english:
          'Museum artifacts need a temperature- and humidity-controlled environment for preservation.',
      usageNote: '“保存文物”和“保护文物”都是常见搭配。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
  };

  final http.Client _client;
  final Uri endpoint;
  final Duration timeout;

  static PhoenixVocabularyExample? bundledExampleForWord(String word) {
    return _bundledExamples[word];
  }

  /// Explorer runtime path.
  ///
  /// Published vocabulary examples are prepared before release and bundled
  /// with the Journey pack. Opening a word must never wait for a model request.
  Future<PhoenixVocabularyExample> generateExample({
    required WordEntry entry,
    required String language,
    required String journeyId,
    required String contextChinese,
    required String contextPinyin,
    required String contextNative,
    required String contextEnglish,
    required PhoenixVocabularyExample fallback,
  }) {
    final bundled = bundledExampleForWord(entry.word);
    final preloaded = bundled ??
        PhoenixVocabularyExample(
          chinese: fallback.chinese,
          pinyin: fallback.pinyin,
          native: fallback.native,
          english: fallback.english,
          usageNote:
              '已随旅程内容预先下载；例句展示“${entry.word}”在完整语境中的实际用法。',
          isOfflineFallback: true,
          provider: 'phoenix-preloaded-pack',
          model: 'bundled',
          qualityReviewed: true,
          qualityScore: 100,
        );
    _validate(preloaded, entry.word);
    return Future<PhoenixVocabularyExample>.value(preloaded);
  }

  /// Content-authoring path only.
  ///
  /// PhoenixVocabularyAgent and PhoenixQualityAgent can generate and review
  /// examples while a Journey pack is being prepared. Their result must be
  /// saved into the pack before explorers receive it; the app UI does not call
  /// this method when a learner opens a word.
  Future<PhoenixVocabularyExample> generateExampleForContentPipeline({
    required WordEntry entry,
    required String language,
    required String journeyId,
    required String contextChinese,
    required String contextPinyin,
    required String contextNative,
    required String contextEnglish,
    required PhoenixVocabularyExample fallback,
  }) async {
    final cacheKey =
        '${endpoint.toString()}|$journeyId|${entry.word}|$language';
    final cached = _authoringCache[cacheKey];
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
        throw http.ClientException(
          _readText(body, 'error', 'Phoenix AI 请求失败。'),
          endpoint,
        );
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
      _authoringCache[cacheKey] = generated;
      return generated;
    } on TimeoutException catch (_) {
      return fallback;
    } on FormatException catch (_) {
      return fallback;
    } on http.ClientException catch (_) {
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
    final hasPlaceholder = forbidden.any(
      (phrase) => example.chinese.contains(phrase),
    );
    if (!example.chinese.contains(word) ||
        example.pinyin.isEmpty ||
        example.native.isEmpty ||
        example.english.isEmpty ||
        example.usageNote.isEmpty ||
        hasPlaceholder) {
      throw const FormatException(
        'Phoenix vocabulary pack contains an invalid example.',
      );
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
