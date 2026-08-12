import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    '紫禁城': PhoenixVocabularyExample(
      chinese: '紫禁城以中轴线组织宫门、院落和主要宫殿。',
      pinyin:
          'Zǐjìnchéng yǐ zhōngzhóuxiàn zǔzhī gōngmén, yuànluò hé zhǔyào gōngdiàn.',
      native:
          'Tử Cấm Thành tổ chức các cổng cung, sân và điện chính dọc theo trục trung tâm.',
      english:
          'The Forbidden City arranges its gates, courtyards, and principal halls along a central axis.',
      usageNote: '“紫禁城”是明清皇宫建筑群的历史名称，现代博物馆机构称“故宫博物院”。',
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
    '茶馆': PhoenixVocabularyExample(
      chinese: '窄巷子的茶馆把院落继续变成喝茶、交谈和停留的日常空间。',
      pinyin:
          'Zhǎi Xiàngzi de cháguǎn bǎ yuànluò jìxù biàn chéng hēchá, jiāotán hé tíngliú de rìcháng kōngjiān.',
      native:
          'Quán trà trong Ngõ Hẹp tiếp tục biến sân nhà thành không gian thường nhật để uống trà, trò chuyện và dừng chân.',
      english:
          'A teahouse in Zhai Alley keeps the courtyard in everyday use for tea, conversation, and lingering.',
      usageNote: '“茶馆”在成都历史街区语境中指提供饮茶、停留和社交的经营空间。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '砖木建筑': PhoenixVocabularyExample(
      chinese: '宽窄巷子的砖木建筑与院落仍保留可辨认的历史空间特征。',
      pinyin:
          'Kuānzhǎi Xiàngzi de zhuānmù jiànzhù yǔ yuànluò réng bǎoliú kě biànrèn de lìshǐ kōngjiān tèzhēng.',
      native:
          'Các công trình gạch và gỗ cùng sân nhà ở Kuanzhai vẫn giữ những đặc trưng không gian lịch sử có thể nhận biết.',
      english:
          'The brick-and-timber buildings and courtyards of Kuanzhai Alley retain legible historic spatial features.',
      usageNote: '“砖木建筑”用于描述以砖和木为主要材料并保留历史空间特征的建筑。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '世界遗产': PhoenixVocabularyExample(
      chinese: '龙门石窟是世界遗产，完整的洞窟、造像与河谷环境共同构成它的遗产价值。',
      pinyin:
          'Lóngmén Shíkū shì shìjiè yíchǎn, wánzhěng de dòngkū, zàoxiàng yǔ hégǔ huánjìng gòngtóng gòuchéng tā de yíchǎn jiàzhí.',
      native:
          'Long Môn Thạch Quật là Di sản Thế giới; các hang động, tượng và môi trường thung lũng sông còn nguyên vẹn cùng tạo nên giá trị di sản của địa điểm này.',
      english:
          'The Longmen Grottoes are a World Heritage property; their intact caves, sculptures, and river-valley setting together form its heritage value.',
      usageNote: '“世界遗产”指列入世界遗产名录、具有突出普遍价值的遗产地。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '保护': PhoenixVocabularyExample(
      chinese: '保护龙门石窟不能只关注著名大像，也要维护洞窟、山崖与河谷环境。',
      pinyin:
          'Bǎohù Lóngmén Shíkū bù néng zhǐ guānzhù zhùmíng dàxiàng, yě yào wéihù dòngkū, shānyá yǔ hégǔ huánjìng.',
      native:
          'Bảo vệ Long Môn Thạch Quật không thể chỉ tập trung vào những tượng lớn nổi tiếng; còn phải gìn giữ các hang động, vách núi và môi trường thung lũng sông.',
      english:
          'Protecting the Longmen Grottoes cannot focus only on famous monumental statues; it must also preserve the caves, cliffs, and river-valley setting.',
      usageNote: '“保护”在遗产语境中表示通过管理和维护减少损害并保存遗产价值。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),

  };

  static const PhoenixVocabularyExample _legacyForbiddenOpening =
      PhoenixVocabularyExample(
        chinese: '清晨，北京的天空刚刚泛白。你站在一扇巨大的红色宫门前，微风从护城河上轻轻吹来。',
        pinyin:
            'Qīngchén, Běijīng de tiānkōng gānggāng fànbái. Nǐ zhàn zài yí shàn jùdà de hóngsè gōngmén qián, wēifēng cóng hùchénghé shàng qīngqīng chuī lái.',
        native:
            'Sáng sớm, bầu trời Bắc Kinh vừa hửng sáng. Bạn đứng trước một cánh cổng cung điện màu đỏ khổng lồ, làn gió nhẹ thổi từ hào nước bao quanh thành.',
        english:
            'At dawn, the sky over Beijing is just beginning to brighten. You stand before a massive red palace gate as a light breeze drifts across the moat.',
        usageNote: '基础目录兼容例句，保留原词所在的完整语境。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'legacy-bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );

  static const PhoenixVocabularyExample _legacyForbiddenArchitecture =
      PhoenixVocabularyExample(
        chinese: '厚重的宫门慢慢打开。红墙、金色屋顶和宽阔的石路，一点一点出现在你的眼前。',
        pinyin:
            'Hòuzhòng de gōngmén mànmàn dǎkāi. Hóngqiáng, jīnsè wūdǐng hé kuānkuò de shílù, yìdiǎn yìdiǎn chūxiàn zài nǐ de yǎnqián.',
        native:
            'Cánh cổng nặng nề từ từ mở ra. Những bức tường đỏ, mái vàng và con đường đá rộng lớn dần hiện ra trước mắt bạn.',
        english:
            'The heavy palace gate slowly opens. Red walls, golden roofs, and broad stone paths gradually appear before you.',
        usageNote: '基础目录兼容例句，保留原词所在的完整语境。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'legacy-bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );

  static const PhoenixVocabularyExample _legacyForbiddenCourt =
      PhoenixVocabularyExample(
        chinese: '这里曾经是皇帝生活和处理国家事务的地方。今天，它被称为故宫，也被世界认识为紫禁城。',
        pinyin:
            'Zhèlǐ céngjīng shì huángdì shēnghuó hé chǔlǐ guójiā shìwù de dìfang. Jīntiān, tā bèi chēngwéi Gùgōng, yě bèi shìjiè rènshi wéi Zǐjìnchéng.',
        native:
            'Nơi đây từng là chỗ hoàng đế sinh sống và xử lý việc quốc gia. Ngày nay, nơi này được gọi là Cố Cung và được thế giới biết đến với tên Tử Cấm Thành.',
        english:
            'This was once where emperors lived and handled affairs of state. Today it is called the Palace Museum and is known around the world as the Forbidden City.',
        usageNote: '基础目录兼容例句，保留原词所在的完整语境。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'legacy-bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );

  static const PhoenixVocabularyExample _legacyForbiddenMemory =
      PhoenixVocabularyExample(
        chinese: '你不是来背诵年代的。你是来看看，一座宫殿怎样保存一个国家数百年的记忆。',
        pinyin:
            'Nǐ bú shì lái bèisòng niándài de. Nǐ shì lái kànkan, yí zuò gōngdiàn zěnyàng bǎocún yí gè guójiā shù bǎi nián de jìyì.',
        native:
            'Bạn không đến đây để học thuộc niên đại. Bạn đến để xem một cung điện đã lưu giữ ký ức của một đất nước suốt hàng trăm năm như thế nào.',
        english:
            'You are not here to memorize dates. You are here to see how a palace can preserve a nation’s memories across centuries.',
        usageNote: '基础目录兼容例句，保留原词所在的完整语境。',
        isOfflineFallback: true,
        provider: 'phoenix-preloaded-pack',
        model: 'legacy-bundled',
        qualityReviewed: true,
        qualityScore: 100,
      );

  final http.Client _client;
  final Uri endpoint;
  final Duration timeout;

  static PhoenixVocabularyExample? bundledExampleForWord(String word) {
    final bundled = _bundledExamples[word];
    if (bundled != null) return bundled;
    if (const <String>{'清晨', '泛白', '宫门', '微风', '护城河'}.contains(word)) {
      return _legacyForbiddenOpening;
    }
    if (const <String>{'厚重', '屋顶', '宽阔'}.contains(word)) {
      return _legacyForbiddenArchitecture;
    }
    if (const <String>{'皇帝', '国家事务'}.contains(word)) {
      return _legacyForbiddenCourt;
    }
    if (const <String>{'背诵', '年代', '保存', '记忆'}.contains(word)) {
      return _legacyForbiddenMemory;
    }
    return null;
  }

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
    return SynchronousFuture<PhoenixVocabularyExample>(preloaded);
  }

  /// Content-authoring path only.
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

  void close() => _client.close();

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
}
