import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'nanjing_qinhuai_one_pass.dart';

/// Canonical level-appropriate vocabulary selection for the Nanjing Gold
/// Journey. The master Word library remains fully traceable, while each
/// runtime level exposes only the pedagogically useful Story-derived subset.
JourneyLevelContent nanjingQinhuaiCuratedLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = nanjingQinhuaiOnePassLevelContent(level);
  if (level >= 8) return base;

  final selectedNames = _nanjingQinhuaiCuratedWordNames[level]!;
  final availableByWord = <String, WordEntry>{
    for (final entry in base.words) entry.word: entry,
  };
  final selectedWords = <WordEntry>[
    for (final word in selectedNames)
      if (availableByWord[word] case final entry?) entry,
  ];

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(selectedWords),
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

const _nanjingQinhuaiCuratedWordNames = <int, List<String>>{
  1: <String>[
    '秦淮灯会',
    '照明',
    '通行',
    '装饰灯',
    '倒计时',
  ],
  2: <String>[
    '秦淮灯会',
    '技术员',
    '故障',
    '判断',
    '通行',
    '装饰灯',
  ],
  3: <String>[
    '秦淮灯会',
    '故障',
    '对讲机',
    '历史风貌',
    '配置',
    '通行',
    '装饰灯',
  ],
  4: <String>[
    '秦淮灯会',
    '故障',
    '照明',
    '临时',
    '确认',
    '历史风貌',
    '通行',
    '装饰灯',
  ],
  5: <String>[
    '秦淮灯会',
    '故障',
    '对讲机',
    '判断',
    '历史风貌',
    '确认',
    '复核',
    '配置',
    '通行',
    '装饰灯',
  ],
  6: <String>[
    '秦淮灯会',
    '故障',
    '照明',
    '确认',
    '通行',
    '装饰灯',
    '判断',
    '对讲机',
    '历史风貌',
    '配置',
    '复核',
  ],
  7: <String>[
    '秦淮灯会',
    '故障',
    '照明',
    '临时',
    '确认',
    '通行',
    '装饰灯',
    '判断',
    '对讲机',
    '历史风貌',
    '配置',
    '复核',
  ],
};
