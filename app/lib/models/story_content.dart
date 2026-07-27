enum StorySourceKind {
  museum,
  government,
  unesco,
  academic,
  editorial,
}

enum StoryVerificationStatus {
  draft,
  reviewed,
  verified,
  published,
  rejected,
}

enum JourneyNarrativeTone {
  realm,
  heritage,
  nature,
  urban,
}

JourneyNarrativeTone resolveJourneyNarrativeTone({
  required String title,
  required List<String> tags,
}) {
  final value = '$title ${tags.join(' ')}';
  if (_containsAny(value, const <String>[
    '梦',
    '蝶',
    '月宫',
    '客栈',
    '河灯',
    '神话',
    '志怪',
    '传说',
    '异境',
    '民俗秘境',
  ])) {
    return JourneyNarrativeTone.realm;
  }
  if (_containsAny(value, const <String>[
    '故宫',
    '宫殿',
    '城墙',
    '古城',
    '古镇',
    '祠',
    '寺',
    '塔',
    '陵',
    '遗址',
    '长城',
    '博物馆',
    '书院',
    '园林',
    '历史',
    '遗产',
    'heritage',
  ])) {
    return JourneyNarrativeTone.heritage;
  }
  if (_containsAny(value, const <String>[
    '山',
    '湖',
    '江',
    '河',
    '海',
    '瀑布',
    '峡谷',
    '森林',
    '草原',
    '湿地',
    '自然',
    'nature',
  ])) {
    return JourneyNarrativeTone.nature;
  }
  return JourneyNarrativeTone.urban;
}

bool _containsAny(String value, List<String> keywords) =>
    keywords.any(value.contains);

class StorySourceRecord {
  const StorySourceRecord({
    required this.id,
    required this.title,
    required this.publisher,
    required this.url,
    required this.kind,
    required this.languageCode,
    required this.geoNodeIds,
    required this.verificationStatus,
    this.accessedOn,
    this.notes,
  });

  final String id;
  final String title;
  final String publisher;
  final String url;
  final StorySourceKind kind;
  final String languageCode;
  final List<String> geoNodeIds;
  final StoryVerificationStatus verificationStatus;
  final String? accessedOn;
  final String? notes;

  bool get isVerified =>
      verificationStatus == StoryVerificationStatus.verified ||
      verificationStatus == StoryVerificationStatus.published;

  bool get isAuthoritative => switch (kind) {
        StorySourceKind.museum ||
        StorySourceKind.government ||
        StorySourceKind.unesco ||
        StorySourceKind.academic => true,
        StorySourceKind.editorial => false,
      };
}

class JourneyStorySection {
  const JourneyStorySection({
    required this.id,
    required this.text,
    required this.sourceIds,
  });

  final String id;
  final String text;
  final List<String> sourceIds;
}

class JourneyContentRecord {
  const JourneyContentRecord({
    required this.id,
    required this.title,
    required this.geoNodeId,
    required this.languageCode,
    required this.sections,
    required this.verificationStatus,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String geoNodeId;
  final String languageCode;
  final List<JourneyStorySection> sections;
  final StoryVerificationStatus verificationStatus;
  final List<String> tags;

  List<String> get storyParagraphs {
    final source = sections
        .map((section) => section.text.trim())
        .where((text) => text.isNotEmpty)
        .toList(growable: false);
    if (source.isEmpty) return const <String>[];

    final groups = _splitStoryIntoTwo(source);
    final tone = resolveJourneyNarrativeTone(title: title, tags: tags);
    return List<String>.generate(groups.length, (index) {
      final body = groups[index].join();
      return '$body${_storyReflectionChinese(tone, index)}';
    }, growable: false);
  }

  Set<String> get sourceIds => sections
      .expand((section) => section.sourceIds)
      .where((id) => id.trim().isNotEmpty)
      .toSet();
}

List<List<String>> _splitStoryIntoTwo(List<String> source) {
  if (source.length <= 2) {
    return source.map((text) => <String>[text]).toList(growable: false);
  }
  final split = (source.length + 1) ~/ 2;
  return <List<String>>[
    source.sublist(0, split),
    source.sublist(split),
  ];
}

String _storyReflectionChinese(JourneyNarrativeTone tone, int index) {
  final closing = index > 0;
  return switch (tone) {
    JourneyNarrativeTone.realm => closing
        ? '故事真正追问的，不是异境是否存在，而是人在梦、欲望、选择与记忆之间，究竟如何认识自己。'
        : '这并不是单纯的奇景，而是一道把现实与想象悄悄叠在一起的门。',
    JourneyNarrativeTone.heritage => closing
        ? '当古老秩序与今天的目光相遇，旅程留下的不只是知识，也是一种理解历史如何塑造当下的方式。'
        : '建筑与景物因此不再只是背景，而成为时代留下的证词。',
    JourneyNarrativeTone.nature => closing
        ? '走到这里，人看到的不只是壮阔，也会理解自然如何参与一座城市与一种文化的形成。'
        : '山水在这里不只是景色，也塑造了当地人的生活节奏、记忆与审美。',
    JourneyNarrativeTone.urban => closing
        ? '把这些细节放在一起，便能读到地点背后的人、时代与生活，而不只是一张漂亮的风景照。'
        : '眼前的景象不只是风景，也让这片土地的记忆变得可以触摸。',
  };
}
