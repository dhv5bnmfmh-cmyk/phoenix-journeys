import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../services/journey_story_length_expander.dart';
import '../services/narrative_quality_shaper.dart';
import '../services/phoenix_story_length_policy.dart';
import '../services/special_journey_story_length_expander.dart';
import 'all_journey_language_level_catalog.dart';
import 'batch_one_adaptive_story_levels.dart';
import 'daily_journey_experience.dart';
import 'dedicated_adaptive_journey_catalog.dart';
import 'forbidden_city_content_cache.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'guangzhou_chen_clan_one_pass.dart';
import 'journey_expansion_catalog.dart';
import 'summer_palace_adaptive_story_levels.dart';
import 'summer_palace_language_level_catalog.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();
const _specialJourneyIds = <String>{
  'literary-roaming',
  'myth-tracing',
  'strange-night-talks',
  'folk-secret-land',
};

const _forbiddenCityStoryExtensions =
    <int, (String chinese, String vietnamese, String english)>{
  6: (
    '阿宁没有停在口头解释上。她把自己的记录点、下一步要回到东边的任务和乾清门前的会合位置逐一圈出，再请沈砚沿着宫门与院落核对每一处连接。沈砚发现，同一段空间既能支持他的中轴观察，也能支持阿宁完成东侧任务；真正需要比较的不是谁更像“标准路线”，而是哪条路线在真实建筑条件下更适合当前任务。',
    'A Ninh không dừng ở lời giải thích. Cô khoanh từng điểm ghi chép, nhiệm vụ phải quay về phía đông và điểm gặp trước Càn Thanh Môn, rồi cùng Thẩm Nghiên kiểm tra từng kết nối qua cổng và sân. Anh nhận ra cùng một không gian có thể phục vụ cả quan sát theo trục giữa lẫn nhiệm vụ phía đông; điều cần so sánh là tuyến nào phù hợp nhiệm vụ trong điều kiện kiến trúc có thật.',
    'A Ning does not stop at explanation. She circles her recording points, her need to return east, and the meeting place before the Gate of Heavenly Purity, then asks Shen Yan to verify every connection through gates and courtyards. He sees that the same space can support both his axial study and her east-side task; the real comparison is which route fits the task under the actual architectural conditions.',
  ),
  7: (
    '周师傅没有替两人裁定，而是让他们把刚才检查过的连接重新写到图边。沈砚先指出中轴、外朝院落与乾清门前这些共同事实，阿宁再补上东侧任务要求她经过的节点。两人发现，只要少掉其中一类证据，判断都会变得过快。沈砚于是把原先写在图角的“错误路线”划掉，改成“另一任务下成立的路线”，并请阿宁检查自己的改写有没有歪曲她的目的。',
    'Thầy Chu không phán xử thay họ mà yêu cầu ghi lại các kết nối vừa kiểm tra. Thẩm Nghiên nêu những sự thật chung về trục giữa, sân Ngoại triều và khu trước Càn Thanh Môn; A Ninh bổ sung các điểm mà nhiệm vụ phía đông buộc cô phải đi qua. Họ nhận ra thiếu một lớp bằng chứng sẽ dẫn đến kết luận quá nhanh. Thẩm Nghiên xóa nhãn “tuyến sai” và đổi thành “tuyến hợp lệ trong một nhiệm vụ khác”, rồi nhờ A Ninh kiểm tra xem anh có bóp méo mục đích của cô không.',
    'Master Zhou refuses to decide for them and asks them to write the verified connections beside the map. Shen Yan states the shared facts of the central axis, Outer Court courtyards, and the area before the Gate of Heavenly Purity; A Ning adds the nodes required by her east-side task. They see that omitting either evidence layer makes the judgment premature. Shen Yan crosses out “wrong route,” replaces it with “a route valid for another task,” and asks A Ning whether his revision misstates her purpose.',
  ),
  8: (
    '阿宁随后提出一个更难的问题：如果两个人都说自己有不同视角，怎样避免把任何路线都说成合理？她把图转回沈砚面前，让他先指出不能改变的事实。两人重新确认中轴、宫门、院落和乾清门前的连接，再分别说明各自任务。沈砚意识到，视角只能解释为什么偏好不同，不能替代空间事实；一条路线如果穿过并不存在的连接，即使符合个人愿望也不能成立。阿宁因此接受同一套事实标准，同时坚持自己的任务路线。',
    'A Ninh đặt câu hỏi khó hơn: nếu ai cũng viện dẫn góc nhìn riêng, làm sao tránh coi mọi tuyến đều hợp lý? Cô đưa bản đồ lại cho Thẩm Nghiên và yêu cầu anh nêu trước những sự thật không thể thay đổi. Họ xác nhận lại trục giữa, cổng, sân và kết nối trước Càn Thanh Môn rồi mới giải thích nhiệm vụ riêng. Thẩm Nghiên hiểu rằng góc nhìn giải thích ưu tiên, nhưng không thể thay thế sự thật không gian; một tuyến đi qua kết nối không tồn tại thì không thể hợp lệ. A Ninh chấp nhận cùng tiêu chuẩn sự thật mà vẫn giữ tuyến phù hợp nhiệm vụ của mình.',
    'A Ning then raises a harder question: if everyone cites a different perspective, how do they avoid calling every route reasonable? She turns the map back to Shen Yan and asks him to state the facts that cannot change. They reconfirm the central axis, gates, courtyards, and the connections before the Gate of Heavenly Purity before explaining their separate tasks. Shen Yan realizes that perspective can explain different preferences but cannot replace spatial fact; a route through a nonexistent connection cannot be valid. A Ning accepts the same factual standard while keeping her task-based route.',
  ),
  9: (
    '周师傅让他们把两张记录叠放，却不准先写结论。沈砚先画共同空间骨架：午门、中轴、外朝院落、乾清门前以及与东侧相接的门户；阿宁再把任务节点和行动方向叠在上面。图上有些段落重合，有些在共同节点后分开。沈砚这才看出，所谓路线偏好必须依附于共同空间事实，而不能把个人习惯冒充整座宫城的唯一结构。他把自己原来的粗线改细，并在旁边补上“学习任务”四个字。阿宁也把自己的东侧记录补上回到共同节点的条件，避免把局部经验说成普遍规律。',
    'Thầy Chu yêu cầu họ chồng hai bản ghi nhưng chưa được viết kết luận. Thẩm Nghiên vẽ trước khung không gian chung gồm Ngọ Môn, trục giữa, sân Ngoại triều, khu trước Càn Thanh Môn và các cổng nối về phía đông; A Ninh chồng các điểm nhiệm vụ và hướng hành động lên trên. Có đoạn trùng nhau, có đoạn tách ra sau điểm chung. Thẩm Nghiên hiểu rằng ưu tiên tuyến phải dựa trên sự thật không gian chung, không thể biến thói quen cá nhân thành cấu trúc duy nhất. Anh ghi rõ “nhiệm vụ học tập”, còn A Ninh bổ sung điều kiện để tuyến phía đông quay lại điểm chung.',
    'Master Zhou asks them to overlay the two records without writing a conclusion first. Shen Yan draws the shared spatial framework: Meridian Gate, the central axis, Outer Court courtyards, the area before the Gate of Heavenly Purity, and gates connecting eastward. A Ning layers her task nodes and movement directions on top. Some segments overlap and others diverge after a shared node. Shen Yan sees that route preference must rest on shared spatial facts rather than turning personal habit into the palace’s only structure. He labels his line “study task,” while A Ning adds the condition that returns her east-side record to the shared node.',
  ),
  10: (
    '为了检验新方法，周师傅临时换了任务：假设要从午门进入后先说明外朝的中轴秩序，再到乾清门前核对东侧记录，最后把两组信息交给后来的人复查。沈砚没有立刻沿用自己的旧线，而是先和阿宁列出建筑连接、人物目标和每一步行动可能造成的后果。阿宁指出，如果一条线虽然空间上能走通，却让她错过东侧记录点，就不能因为“熟悉”而被选作最佳路线；沈砚则提醒，如果一条线忽略中轴与功能分区，后来的人就难以理解局部记录属于整座宫城的什么位置。两人据此重新权衡，在共同空间骨架上保留不同任务段，并给每一段写明成立条件。',
    'Để kiểm tra phương pháp mới, thầy Chu đổi nhiệm vụ: sau khi vào từ Ngọ Môn phải giải thích trật tự trục giữa của Ngoại triều, đến khu trước Càn Thanh Môn kiểm tra ghi chép phía đông, rồi giao cả hai nhóm thông tin cho người đến sau kiểm chứng. Thẩm Nghiên không dùng ngay tuyến cũ mà cùng A Ninh liệt kê kết nối kiến trúc, mục tiêu và hệ quả hành động. Họ loại các tuyến tuy đi được nhưng bỏ lỡ nhiệm vụ, đồng thời giữ quan hệ với trục giữa và phân khu chức năng. Cuối cùng hai người ghi rõ điều kiện để từng đoạn tuyến được xem là hợp lệ trên cùng khung không gian.',
    'To test the new method, Master Zhou changes the assignment: enter through Meridian Gate, explain the Outer Court’s axial order, verify east-side records before the Gate of Heavenly Purity, then leave both sets of information for later review. Shen Yan does not automatically reuse his old line. He and A Ning list architectural connections, goals, and action consequences first. They reject routes that are spatially possible but fail the task, while preserving the relation to the axis and functional zones. They then keep different task segments on the shared framework and state the conditions under which each segment is justified.',
  ),
};

String _forbiddenCityPinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

JourneyLevelContent resolveAdaptiveJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (!usesDedicatedAdaptiveJourneyRuntime(experience.id)) {
    return resolveSharedAdaptiveJourneyLevel(
      experience,
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == forbiddenCityJourneyId) {
    return _resolveForbiddenCityAdaptiveLevel(
      profile,
      knownWords: knownWords,
    );
  }
  if (isBatchOneGoldJourney(experience.id)) {
    return buildBatchOneGoldLevel(
      experience,
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == 'beijing-summer-palace') {
    return _resolveSummerPalaceN1Level(
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == guangzhouChenClanJourneyId) {
    return guangzhouChenClanOnePassLevelContent(
      profile.phoenixLevel ?? _levelForBand(profile.band),
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == 'suzhou-humble-administrators-garden') {
    return suzhouGardenCanonicalLevelContent(
      profile.phoenixLevel ?? _levelForBand(profile.band),
      profile: profile,
      knownWords: knownWords,
    );
  }
  throw StateError(
    'Dedicated adaptive Journey has no registered resolver: ${experience.id}',
  );
}

JourneyLevelContent _resolveForbiddenCityAdaptiveLevel(
  ChineseProficiencyProfile profile, {
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _levelForBand(profile.band);
  final base = cachedForbiddenCityLevelContent(level);
  final extension = _forbiddenCityStoryExtensions[level];
  final paragraphs = <String>[
    for (var index = 0; index < base.storyParagraphs.length; index += 1)
      '${base.storyParagraphs[index].replaceAll('古建学徒', '营造学徒')}${extension != null && index == base.storyParagraphs.length - 1 ? extension.$1 : ''}',
  ];
  final annotations = <ReadingAnnotation>[
    for (var index = 0; index < paragraphs.length; index += 1)
      ReadingAnnotation(
        pinyin: _forbiddenCityPinyin(paragraphs[index]),
        vietnamese:
            '${base.storyAnnotations[index].vietnamese}${extension != null && index == paragraphs.length - 1 ? ' ${extension.$2}' : ''}',
        english:
            '${base.storyAnnotations[index].english}${extension != null && index == paragraphs.length - 1 ? ' ${extension.$3}' : ''}',
      ),
  ];
  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: unseenWords.isEmpty ? base.words : unseenWords,
    discoveries: List<DiscoveryEntry>.unmodifiable(
      <DiscoveryEntry>[base.discoveries.first],
    ),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

int _levelForBand(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 9,
      PhoenixReadingBand.mastery => 10,
    };

JourneyLevelContent resolveSharedAdaptiveJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final content = buildAdaptiveLevelForJourney(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
  final refined = refineAdaptiveNarrativeQuality(
    experience,
    content,
    profile: profile,
  );
  if (!profile.isPhoenix) return refined;
  if (_specialJourneyIds.contains(experience.id)) {
    return expandSpecialJourneyStoryToTarget(
      experience.id,
      refined,
      profile: profile,
    );
  }
  return expandJourneyStoryToTarget(
    experience,
    refined,
    profile: profile,
  );
}

JourneyLevelContent resolveLegacySummerPalaceGenericExpansionForTesting(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final content = buildAdaptiveLevelForJourney(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
  final refined = refineAdaptiveNarrativeQuality(
    experience,
    content,
    profile: profile,
  );
  return expandJourneyStoryToTarget(
    experience,
    refined,
    profile: profile,
  );
}

JourneyLevelContent _resolveSummerPalaceN1Level({
  required ChineseProficiencyProfile profile,
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _legacySummerPalaceLevel(profile.band);
  final target = phoenixStoryLengthTargetFor(profile);
  final plan = _languageLevelAgent.planFor(profile);
  final source = summerPalaceN1LevelForPhoenixLevel(level);
  final limited = source.withReadingLimit(
    paragraphCount:
        profile.isPhoenix ? target.paragraphCount : plan.paragraphCount,
  );
  final base = JourneyLevelContent(
    storyParagraphs: limited.storyParagraphs,
    storyAnnotations: limited.storyAnnotations,
    words: source.words,
    discoveries: source.discoveries,
    wonderQuestion: source.wonderQuestion,
    expressQuestion: source.expressQuestion,
  );
  final context = <String>[
    ...base.storyParagraphs,
    ...base.discoveries.map((entry) => entry.text),
  ].join();
  final contextWords = summerPalaceAdaptiveWords
      .where((entry) => context.contains(entry.word))
      .toList(growable: false);
  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: contextWords,
    levelCatalog: summerPalaceVocabularyLevels,
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: selectedWords,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

int _legacySummerPalaceLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
