import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_cache.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';

String _expectedPinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void _expectMarkers(
  String actual,
  List<String> markers, {
  required String reason,
}) {
  final normalizedActual = actual.toLowerCase();
  for (final marker in markers) {
    expect(
      normalizedActual,
      contains(marker.toLowerCase()),
      reason: '$reason: $marker',
    );
  }
}

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
  final profiles = levelAgent.allProfiles.toList(growable: false)
    ..sort(
      (a, b) => (a.phoenixLevel ?? 0).compareTo(b.phoenixLevel ?? 0),
    );

  const vietnameseMarkers = <List<List<String>>>[
    <List<String>>[
      <String>['17 tuổi', 'Ngọ Môn', 'Càn Thanh Môn', 'mục tiêu', 'hai tuyến'],
    ],
    <List<String>>[
      <String>['17 tuổi', 'Đừng xóa vội', 'nhiệm vụ', 'mục tiêu', 'trục giữa'],
    ],
    <List<String>>[
      <String>['cổng', 'sân', 'phía đông', 'hội tụ'],
      <String>['nộp bản ghi muộn', 'cổng', 'sân', 'thầy Chu'],
    ],
    <List<String>>[
      <String>['Ngoại triều', 'nhiệm vụ', 'phía đông', 'mục tiêu'],
      <String>['kết nối không gian', 'Ngọ Môn', 'Ngoại triều', 'thầy Chu'],
    ],
    <List<String>>[
      <String>['quan hệ không gian', 'đường đậm', 'kiểm tra', 'phán đoán'],
      <String>['bằng chứng', 'cổng', 'sân', 'quan sát trục giữa', 'hợp tác'],
    ],
    <List<String>>[
      <String>['Ngoại triều', 'Nội đình', 'tuyến dễ tổ chức nhất', 'phía đông'],
      <String>['kết nối', 'phù hợp', 'nhiệm vụ', 'điểm chung'],
    ],
    <List<String>>[
      <String>['phán đoán', 'bằng chứng', 'kết nối', 'nhiệm vụ'],
      <String>['ràng buộc kiến trúc', 'góc nhìn', 'bằng chứng', 'thầy Chu'],
    ],
    <List<String>>[
      <String>['hiệu quả nhiệm vụ', 'sức giải thích', 'ba câu hỏi', 'bằng chứng không gian'],
      <String>['điều kiện không gian chung', 'mục tiêu', 'góc nhìn', 'hành động tiếp theo', 'vị thế loại trừ'],
    ],
    <List<String>>[
      <String>['khung không gian ổn định', 'ưu tiên', 'thầy Chu', 'bằng chứng không gian'],
      <String>['Ngoại triều', 'Nội đình', 'nhiệm vụ học tập', 'nhiều lớp', 'khung không gian chung'],
    ],
    <List<String>>[
      <String>['đáp án mặc định', 'cân nhắc', 'ba loại bằng chứng', 'hệ quả hành động'],
      <String>['logic hành động', 'điều kiện', 'thầy Chu', 'cùng ký tên'],
    ],
  ];

  const englishMarkers = <List<List<String>>>[
    <List<String>>[
      <String>['Seventeen-year-old', 'Meridian Gate', 'Gate of Heavenly Purity', 'goal', 'both routes'],
    ],
    <List<String>>[
      <String>['Seventeen-year-old', 'Don’t erase it yet', 'different tasks', 'goals', 'central axis'],
    ],
    <List<String>>[
      <String>['gates', 'courtyards', 'east', 'converges'],
      <String>['submit the record later', 'gates', 'courtyards', 'Master Zhou'],
    ],
    <List<String>>[
      <String>['Outer Court', 'task', 'east', 'goals'],
      <String>['spatial connections', 'Meridian Gate', 'Outer Court', 'Master Zhou'],
    ],
    <List<String>>[
      <String>['spatial relationships', 'thick line', 'checking', 'judgment'],
      <String>['evidence', 'gates', 'courtyards', 'central-axis observation', 'cooperate'],
    ],
    <List<String>>[
      <String>['Outer Court', 'Inner Court', 'easiest route to organize', 'east'],
      <String>['connect', 'appropriate', 'task', 'shared node'],
    ],
    <List<String>>[
      <String>['judgment', 'evidence', 'connection points', 'task'],
      <String>['architectural constraints', 'perspectives', 'evidence', 'Master Zhou'],
    ],
    <List<String>>[
      <String>['task efficiency', 'explanatory power', 'three questions', 'spatial evidence'],
      <String>['shared spatial conditions', 'goals', 'perspectives', 'next actions', 'exclusive status'],
    ],
    <List<String>>[
      <String>['stable spatial framework', 'route preference', 'Master Zhou', 'spatial evidence'],
      <String>['Outer Court', 'Inner Court', 'study task', 'layered representation', 'shared spatial framework'],
    ],
    <List<String>>[
      <String>['default answer', 'weigh', 'three kinds of evidence', 'action consequences'],
      <String>['action logic', 'conditions', 'Master Zhou', 'sign together'],
    ],
  ];

  test('Lv1-Lv10 cached Story Reading Support is paragraph-source aligned', () {
    for (var index = 0; index < 10; index += 1) {
      final level = index + 1;
      final content = cachedForbiddenCityLevelContent(level);
      expect(
        content.storyAnnotations,
        hasLength(content.storyParagraphs.length),
        reason: 'Lv$level annotation count must match Story paragraph count',
      );
      expect(vietnameseMarkers[index], hasLength(content.storyParagraphs.length));
      expect(englishMarkers[index], hasLength(content.storyParagraphs.length));

      for (var paragraphIndex = 0;
          paragraphIndex < content.storyParagraphs.length;
          paragraphIndex += 1) {
        final story = content.storyParagraphs[paragraphIndex];
        final annotation = content.storyAnnotations[paragraphIndex];
        expect(
          annotation.pinyin,
          _expectedPinyin(story),
          reason: 'Lv$level paragraph ${paragraphIndex + 1} Pinyin provenance',
        );
        expect(annotation.vietnamese.trim(), isNotEmpty);
        expect(annotation.english.trim(), isNotEmpty);
        _expectMarkers(
          annotation.vietnamese,
          vietnameseMarkers[index][paragraphIndex],
          reason: 'Lv$level paragraph ${paragraphIndex + 1} Vietnamese source alignment',
        );
        _expectMarkers(
          annotation.english,
          englishMarkers[index][paragraphIndex],
          reason: 'Lv$level paragraph ${paragraphIndex + 1} English source alignment',
        );
      }
    }
  });

  test('adaptive Story Reading Support follows CURRENT refined Story', () {
    const extensionMarkers = <int, ({List<String> vi, List<String> en})>{
      5: (
        vi: <String>['Thầy Chu', 'lý do', 'căn cứ'],
        en: <String>['Master Zhou', 'labeled', 'grounds'],
      ),
      6: (
        vi: <String>['điểm ghi chép', 'quay về phía đông', 'phù hợp nhiệm vụ hiện tại'],
        en: <String>['recording points', 'return east', 'fit the current task'],
      ),
      7: (
        vi: <String>['sự thật chung', 'tuyến sai', 'nhiệm vụ khác'],
        en: <String>['shared facts', 'wrong route', 'another task'],
      ),
      8: (
        vi: <String>['sự thật không thể thay đổi', 'kết nối không tồn tại', 'cùng tiêu chuẩn sự thật'],
        en: <String>['facts that cannot change', 'nonexistent connection', 'same factual standard'],
      ),
      9: (
        vi: <String>['chồng hai bản ghi', 'khung không gian chung', 'nhiệm vụ học tập'],
        en: <String>['overlay the two records', 'shared spatial framework', 'study task'],
      ),
      10: (
        vi: <String>['đổi nhiệm vụ', 'hệ quả hành động', 'điều kiện'],
        en: <String>['changes the assignment', 'action consequences', 'conditions'],
      ),
    };

    for (var index = 0; index < profiles.length; index += 1) {
      final level = index + 1;
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: profiles[index],
      );
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (var paragraphIndex = 0;
          paragraphIndex < content.storyParagraphs.length;
          paragraphIndex += 1) {
        expect(
          content.storyAnnotations[paragraphIndex].pinyin,
          _expectedPinyin(content.storyParagraphs[paragraphIndex]),
          reason: 'Lv$level CURRENT paragraph ${paragraphIndex + 1} Pinyin',
        );
      }

      final extension = extensionMarkers[level];
      if (extension != null) {
        final current = content.storyAnnotations.last;
        _expectMarkers(
          current.vietnamese,
          extension.vi,
          reason: 'Lv$level adaptive Vietnamese extension provenance',
        );
        _expectMarkers(
          current.english,
          extension.en,
          reason: 'Lv$level adaptive English extension provenance',
        );
      }
    }
  });

  test('non-monotonic level switching cannot reuse previous-level annotations', () {
    const sequence = <int>[8, 1, 10, 5, 3, 9, 2, 7, 4, 6, 1, 10];
    for (final level in sequence) {
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: profiles[level - 1],
      );
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (var paragraphIndex = 0;
          paragraphIndex < content.storyParagraphs.length;
          paragraphIndex += 1) {
        expect(
          content.storyAnnotations[paragraphIndex].pinyin,
          _expectedPinyin(content.storyParagraphs[paragraphIndex]),
          reason: 'Lv$level switch paragraph ${paragraphIndex + 1}',
        );
      }
      _expectMarkers(
        content.storyAnnotations.first.vietnamese,
        vietnameseMarkers[level - 1].first,
        reason: 'Lv$level switched Vietnamese provenance',
      );
      _expectMarkers(
        content.storyAnnotations.first.english,
        englishMarkers[level - 1].first,
        reason: 'Lv$level switched English provenance',
      );
    }
  });
}
