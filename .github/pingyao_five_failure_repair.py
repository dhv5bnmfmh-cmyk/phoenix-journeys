from pathlib import Path
import re


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{path}: expected one exact match, found {count}")
    p.write_text(text.replace(old, new, 1))


def regex_once(path: str, pattern: str, replacement: str) -> None:
    p = Path(path)
    text = p.read_text()
    updated, count = re.subn(pattern, replacement, text, count=1, flags=re.S)
    if count != 1:
        raise SystemExit(f"{path}: expected one regex match, found {count}")
    p.write_text(updated)


# 1. Reviewed Pingyao-owned preload contexts for the two missing active words.
vocabulary_service = "app/lib/services/phoenix_vocabulary_service.dart"
brick_entry = """    '砖木建筑': PhoenixVocabularyExample(
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
"""
pingyao_preloads = """    // Pingyao candidate-owned preload contexts, reviewed against active Story/Discovery.
    '信任': PhoenixVocabularyExample(
      chinese: '票号没有把信任变成抽象口号，而是把它分配给柜台、账本、分号和凭证。',
      pinyin:
          'Piàohào méiyǒu bǎ xìnrèn biàn chéng chōuxiàng kǒuhào, érshì bǎ tā fēnpèi gěi guìtái, zhàngběn, fēnhào hé píngzhèng.',
      native:
          'Phiếu hiệu không biến niềm tin thành khẩu hiệu trừu tượng mà phân bổ nó cho quầy giao dịch, sổ sách, chi nhánh và chứng từ.',
      english:
          'The remittance house does not turn trust into an abstract slogan; it distributes trust across the counter, ledgers, branches, and documents.',
      usageNote: '平遥候选词汇例句，直接绑定 Lv8 Story 的信用机制语境。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
    '结算': PhoenixVocabularyExample(
      chinese: '从现银押运到汇票结算，关键变化不是“钱变成纸”，而是信用被放进可以跨地点核验的制度关系。',
      pinyin:
          'Cóng xiànyín yāyùn dào huìpiào jiésuàn, guānjiàn biànhuà bú shì “qián biàn chéng zhǐ”, érshì xìnyòng bèi fàng jìn kěyǐ kuà dìdiǎn héyàn de zhìdù guānxì.',
      native:
          'Từ áp tải bạc tiền mặt đến thanh toán bằng hối phiếu, thay đổi then chốt không phải là “tiền biến thành giấy”, mà là tín dụng được đặt vào quan hệ thể chế có thể kiểm tra giữa nhiều nơi.',
      english:
          'From escorting physical silver to settlement by draft, the key change is not that “money becomes paper”, but that credit is embedded in institutional relations that can be verified across locations.',
      usageNote: '平遥候选词汇例句，直接绑定 Lv8 Discovery 的汇票结算语境。',
      isOfflineFallback: true,
      provider: 'phoenix-preloaded-pack',
      model: 'bundled',
      qualityReviewed: true,
      qualityScore: 100,
    ),
"""
replace_once(vocabulary_service, brick_entry, brick_entry + pingyao_preloads)

# 2. Discovery progression verifies the semantic hinge, not a stale literal phrase.
gold_test = "app/test/pingyao_ancient_city_gold_test.dart"
replace_once(
    gold_test,
    "      expect(pingyaoDiscoveriesForLevel(5).map((e) => e.text).join(), contains('谁必须离开'));\n",
    "      final lv5Discovery = pingyaoDiscoveriesForLevel(5).map((e) => e.text).join();\n"
    "      expect(lv5Discovery, contains('钱怎样移动'));\n"
    "      expect(lv5Discovery, contains('人是否必须跟着移动'));\n",
)

# 3. Replace the provenance-breaking Lv8 word with an active word present Lv7-Lv10.
gold_content = "app/lib/data/pingyao_ancient_city_gold_content.dart"
replace_once(
    gold_content,
    "  WordEntry(word:'印记',pinyin:'yìnjì',partOfSpeech:'名词',simpleChinese:'用于识别或确认文件的印章痕迹。',translation:'Dấu dùng để nhận biết hoặc xác nhận giấy tờ.',englishDefinition:'seal mark',symbol:'🔖'),",
    "  WordEntry(word:'责任',pinyin:'zérèn',partOfSpeech:'名词',simpleChinese:'对事情、关系或结果应当承担的义务。',translation:'Trách nhiệm phải gánh đối với công việc, quan hệ hoặc kết quả.',englishDefinition:'responsibility',symbol:'⚖️'),",
)

# 4. Retarget Lv2 grammar repair to the 不必 structure actually taught in Lv2 Discovery.
challenge = "app/lib/data/pingyao_ancient_city_challenge_profile.dart"
pattern = r"""    GoldChallengeGrammarSpec\(
      targetId:'pingyao-instead-of',
.*?      misconception:'把范围副词插进否定谓语内部',
    \),"""
replacement = """    GoldChallengeGrammarSpec(
      targetId:'pingyao-instead-of',
      prefix:'这样的安排使长距离商业结算',
      brokenSegment:'总由同一批现银一路不必押送',
      suffix:'。',
      correctReplacement:'不必总由同一批现银一路押送',
      distractors:<String>['总不必由同一批现银一路押送','总由同一批现银不必一路押送','由同一批现银一路不必押送'],
      errorType:'否定情态副词“不必”的位置',
      whyWrong:'Lv2 Discovery 已用“不必总由同一批现银一路押送”说明结算方式的变化；“不必”应放在它否定的整个押送谓语之前。',
      revisionRule:'表达“没有必要做某事”时，用“不必 + 动词/动词短语”，并保持否定范围清楚。',
      memoryTip:'先说“不必”，再说哪件事不再必须发生。',
      misconception:'把“不必”的作用范围移进押送短语，破坏原有否定关系',
    ),"""
regex_once(challenge, pattern, replacement)

# 5. Bind daily publication to Pingyao's dedicated canonical Lv5 package.
daily = "app/test/daily_journey_engine_test.dart"
replace_once(
    daily,
    "import 'package:phoenix_journeys/data/luoyang_longmen_one_pass.dart';\n",
    "import 'package:phoenix_journeys/data/luoyang_longmen_one_pass.dart';\n"
    "import 'package:phoenix_journeys/data/pingyao_ancient_city_gold_content.dart';\n",
)
marker = "      } else if (journey.id == 'jiangmen-kaiping-diaolou') {\n"
pingyao_branch = """      } else if (journey.id == pingyaoAncientCityJourneyId) {
        expect(
          journey.content.storyParagraphs,
          pingyaoAncientCityGoldLevelContent(5).storyParagraphs,
          reason: 'Pingyao candidate catalog metadata must bind active Lv5 Story',
        );
        expect(
          journey.discoveries,
          hasLength(pingyaoAncientCityGoldLevelContent(5).discoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == 'jiangmen-kaiping-diaolou') {
"""
replace_once(daily, marker, pingyao_branch)
