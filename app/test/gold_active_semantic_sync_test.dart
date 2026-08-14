import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/extended_journey_catalog.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

ChineseProficiencyProfile _profile(int level) => ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '$level',
      levelLabel: '$level',
      band: PhoenixReadingBand.intermediate,
      phoenixLevel: level,
    );

String _canonicalPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void _expectAnchors(String value, List<String> anchors, String reason) {
  final normalized = value.toLowerCase();
  for (final anchor in anchors) {
    expect(normalized, contains(anchor.toLowerCase()), reason: '$reason: $anchor');
  }
}

void main() {
  final hangzhou = dailyJourneyExperiences.singleWhere(
    (item) => item.id == 'hangzhou-west-lake',
  );
  final guangzhou = extendedJourneyExperiences.singleWhere(
    (item) => item.id == 'guangzhou-chen-clan-academy',
  );
  final suzhou = dailyJourneyExperiences.singleWhere(
    (item) => item.id == 'suzhou-humble-administrators-garden',
  );

  final hangzhouVietnamese = <List<String>>[
    ['mặt hồ', 'núi', 'đô thị', 'cảnh quan văn hóa'],
    ['bắc tống', 'nạo vét', 'bùn', 'đê tô'],
    ['unesco', 'hai đê', 'ba đảo', 'thế kỷ 9', 'thế kỷ 12'],
    ['mặt hồ', 'núi ở ba phía', 'đê', 'đảo', 'cầu', 'tháp', 'cây cối'],
    ['không phải di tích khép kín', 'mặt hồ', 'đê', 'vườn', 'thành phố phía đông', 'du thuyền'],
    ['thế kỷ 9', 'thi nhân', 'học giả', 'nghệ sĩ', 'nhật bản', 'triều tiên'],
    ['nam tống', 'địa điểm', 'mùa', 'thời tiết', 'cách nhìn', 'ký ức văn hóa'],
    ['cầu', 'đình', 'tháp', 'chùa', 'cây cối', 'tầm nhìn', 'tuyến đi', 'không gian'],
    ['2011', 'di sản thế giới', 'tự nhiên', 'kiến tạo', 'nhiều thời đại', 'truyền thống văn hóa'],
    ['hơn một nghìn năm', 'tự nhiên', 'nhân tạo', 'không có con người'],
  ];
  final hangzhouEnglish = <List<String>>[
    ['lake surface', 'hills', 'urban area', 'cultural landscape'],
    ['northern song', 'dredging', 'silt', 'su causeway'],
    ['unesco', 'two principal causeways', 'three artificial islands', 'ninth', 'twelfth'],
    ['lake', 'hills on three sides', 'causeways', 'islands', 'bridges', 'pagodas', 'planting'],
    ['not a closed monument', 'lake', 'causeways', 'gardens', 'eastern city', 'boating'],
    ['ninth century', 'poets', 'scholars', 'artists', 'japan', 'korean peninsula'],
    ['southern song', 'places', 'seasons', 'weather', 'ways of viewing', 'cultural memory'],
    ['bridges', 'pavilions', 'pagodas', 'temples', 'planting', 'sightlines', 'routes', 'spatial'],
    ['2011', 'world heritage', 'natural scenery', 'human shaping', 'cultural traditions'],
    ['more than a thousand years', 'natural–human', 'protecting', 'unpeopled historical stage'],
  ];

  final guangzhouVietnamese = <List<String>>[
    ['tấm biển', 'trần thị thư viện', 'quảng đông', 'góp tiền'],
    ['trần gia từ', 'trần thị thư viện', 'hai lớp', 'lịch sử'],
    ['không phải', 'một gia đình', 'nhiều dòng họ', 'góp vốn'],
    ['cùng xây dựng', 'tế tự', 'liên lạc', 'thư viện'],
    ['ba trục ngang', 'ba lớp dọc', 'cửa', 'sảnh', 'sân'],
    ['sân', 'ánh sáng', 'không khí', 'hành lang', 'nối', 'đơn vị kiến trúc'],
    ['ba trục ba lớp', 'chính-phụ', 'trước-sau'],
    ['chạm gỗ', 'gạch', 'đá', 'tượng gốm', 'đúc', 'vẽ màu', 'vị trí', 'biểu đạt'],
    ['bảo tàng', 'công trình lịch sử', 'bộ sưu tập', 'trưng bày', 'công chúng'],
    ['trọng điểm cấp quốc gia', 'bố cục tổng thể', 'ba trục ba lớp', 'thủ công lĩnh nam', 'văn hóa công cộng'],
  ];
  final guangzhouEnglish = <List<String>>[
    ['plaque', 'chen clan academy', 'across guangdong', 'jointly funded'],
    ['chen clan ancestral hall', 'chen clan academy', 'identity'],
    ['not one household', 'private hall', 'shared lineage', 'funded'],
    ['jointly built', 'shared lineage hall', 'ritual', 'networking', 'academy'],
    ['three transverse routes', 'three successive depths', 'gates', 'halls', 'courts'],
    ['courtyards', 'light', 'air', 'corridors', 'connect'],
    ['three-route', 'hierarchy', 'front-to-back'],
    ['wood', 'brick', 'stone', 'ceramic', 'casting', 'painting', 'position'],
    ['folk arts museum', 'historic building', 'collections', 'displays', 'public'],
    ['protected at the national level', 'complete three-route', 'lingnan craftsmanship', 'public cultural function'],
  ];

  final suzhouVietnamese = <List<String>>[
    ['mặt nước', 'kiến trúc', 'cây cối', 'lối đi'],
    ['đình', 'hành lang', 'mặt nước', 'tuyến tham quan'],
    ['hành lang', 'tường', 'cây cối', 'tầm nhìn'],
    ['hành lang hẹp', 'mặt ao', 'phản chiếu', 'rộng hơn'],
    ['hành lang', 'mặt nước', 'gần xa', 'chiều sâu'],
    ['cửa sổ hoa', 'phân cách', 'phía bên kia', 'đổi vị trí'],
    ['mượn cảnh', 'ngoài vườn', 'vị trí nhìn', 'gần với xa'],
    ['nước', 'đá', 'cây', 'kiến trúc', 'mùa'],
    ['hữu hạn', 'che–hiện', 'mượn cảnh', 'tranh sơn thủy'],
    ['di sản thế giới', 'thiết kế tổng thể', 'truyền thống', 'bảo tồn'],
  ];
  final suzhouEnglish = <List<String>>[
    ['water', 'buildings', 'planting', 'paths'],
    ['pavilions', 'corridors', 'water', 'movement'],
    ['corridors', 'walls', 'planting', 'sightlines'],
    ['narrow corridor', 'open water', 'reflections', 'space'],
    ['corridors', 'water', 'near–far', 'depth'],
    ['openwork windows', 'separation', 'partial views', 'viewer moves'],
    ['borrowed scenery', 'outside', 'viewpoint', 'distant'],
    ['water', 'rocks', 'planting', 'architecture', 'seasons'],
    ['limited urban land', 'concealment', 'borrowed scenery', 'landscape painting'],
    ['world heritage', 'complete spatial design', 'garden tradition', 'conservation'],
  ];

  test('active Lv1-Lv10 Discovery support preserves every semantic fixture', () {
    final journeys = [
      (hangzhou, hangzhouVietnamese, hangzhouEnglish),
      (guangzhou, guangzhouVietnamese, guangzhouEnglish),
      (suzhou, suzhouVietnamese, suzhouEnglish),
    ];
    for (final journey in journeys) {
      for (var level = 1; level <= 10; level++) {
        final active = resolveAdaptiveJourneyLevel(
          journey.$1,
          profile: _profile(level),
        );
        final discoveryVietnamese =
            active.discoveries.map((entry) => entry.vietnamese).join(' ');
        final discoveryEnglish =
            active.discoveries.map((entry) => entry.english).join(' ');

        if (journey.$1.id == 'suzhou-humble-administrators-garden') {
          for (final discovery in active.discoveries) {
            expect(
              discovery.pinyin,
              _canonicalPinyin(discovery.text),
              reason: '${journey.$1.id} Lv$level complete Discovery Pinyin',
            );
          }
        } else {
          expect(active.discoveries, hasLength(1));
          final discovery = active.discoveries.single;
          expect(
            discovery.pinyin,
            _canonicalPinyin(discovery.text),
            reason: '${journey.$1.id} Lv$level complete Pinyin',
          );
        }
        _expectAnchors(
          discoveryVietnamese,
          journey.$2[level - 1],
          '${journey.$1.id} Lv$level Vietnamese',
        );
        _expectAnchors(
          discoveryEnglish,
          journey.$3[level - 1],
          '${journey.$1.id} Lv$level English',
        );
      }
    }
  });

  test('active Story support and all visible learning content reject legacy identities', () {
    final cases = [
      (hangzhou, ['方毓', '周绍庭', '预约卡', '医院'], ['许澄', '声景', '麦克风', '录音项目', 'soundscape project', 'recording archive']),
      (guangzhou, ['陈秀仪', '刘嘉禾', '不入镜'], ['梁遥', '贺真', '纸桥', '原型', 'paper bridge', 'prototype']),
      (suzhou, ['陈玉兰', '程朗', '下一处等我'], ['方毓', '周绍庭', '陈秀仪', '刘嘉禾', '许澄', '梁遥']),
    ];
    for (final item in cases) {
      for (var level = 1; level <= 10; level++) {
        final active = resolveAdaptiveJourneyLevel(item.$1, profile: _profile(level));
        final story = active.storyParagraphs.join();
        final storySupport = active.storyAnnotations
            .map((annotation) => '${annotation.pinyin} ${annotation.vietnamese} ${annotation.english}')
            .join(' ');
        final discoverySupport = active.discoveries
            .map((entry) => '${entry.text} ${entry.pinyin} ${entry.vietnamese} ${entry.english}')
            .join(' ');
        final visible = '$story $storySupport $discoverySupport '
            '${active.words.map((word) => word.word).join(' ')} '
            '${active.wonderQuestion} ${active.expressQuestion}';
        for (final anchor in item.$2) {
          expect(story, contains(anchor), reason: '${item.$1.id} Lv$level $anchor');
        }
        for (final forbidden in item.$3) {
          expect(visible.toLowerCase(), isNot(contains(forbidden.toLowerCase())),
              reason: '${item.$1.id} Lv$level stale $forbidden');
        }
        expect(active.storyAnnotations, hasLength(active.storyParagraphs.length));
        for (var index = 0; index < active.storyParagraphs.length; index++) {
          expect(
            active.storyAnnotations[index].pinyin,
            _canonicalPinyin(active.storyParagraphs[index]),
            reason: '${item.$1.id} Lv$level Story paragraph ${index + 1}',
          );
        }
      }
    }
  });

  test('active Gold vocabulary publishes auditable Lv1-Lv10 counts', () {
    const agent = PhoenixLanguageLevelAgent();
    for (final journey in [hangzhou, guangzhou, suzhou]) {
      final evidence = <String>[];
      for (var level = 1; level <= 10; level++) {
        final profile = _profile(level);
        final plan = agent.planFor(profile);
        final active = resolveAdaptiveJourneyLevel(journey, profile: profile);
        final visible = '${active.storyParagraphs.join()}'
            '${active.discoveries.map((entry) => entry.text).join()}';
        expect(active.words.length, greaterThanOrEqualTo(plan.targetVocabularyCount));
        expect(active.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
        for (final word in active.words) {
          expect(visible, contains(word.word), reason: '${journey.id} Lv$level ${word.word}');
        }
        evidence.add(
          'Lv$level=${active.words.length}/${plan.targetVocabularyCount}/${plan.maximumVocabularyCount}',
        );
      }
      // Kept in CI output as exact Founder evidence: actual/target/maximum.
      // ignore: avoid_print
      print('GOLD_VOCAB ${journey.id} ${evidence.join(' ')}');
    }
  });
}
