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
    updated, count = re.subn(pattern, lambda _: replacement, text, count=1, flags=re.S)
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

# 4. Bind every Pingyao grammar repair to exact active teaching at its own level.
challenge = "app/lib/data/pingyao_ancient_city_challenge_profile.dart"
profile_pattern = r"""  grammar: <GoldChallengeGrammarSpec>\[\n.*?\n  \],\n  storyDistractors:"""
profile_replacement = """  grammar: <GoldChallengeGrammarSpec>[
    GoldChallengeGrammarSpec(
      targetId:'pingyao-ba-silver-order',
      prefix:'程砚',
      brokenSegment:'把存进票号银两',
      suffix:'，换成汇票。',
      correctReplacement:'把银两存进票号',
      distractors:<String>['把票号存进银两','银两把存进票号','把银两票号存进'],
      errorType:'“把 + 对象 + 动作”语序',
      whyWrong:'Lv1 Story 已把“把银两存进票号”作为程砚的实际动作；“银两”是被处置对象，应紧跟“把”。',
      revisionRule:'先找被处置对象，再写“把 + 对象 + 动作/结果”。',
      memoryTip:'把什么？银两。做什么？存进票号。',
      misconception:'把地点和处置对象的位置混在一起',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-instead-of',
      prefix:'票号经营异地汇兑，使',
      brokenSegment:'商人把大批现银不必一路搬到远方',
      suffix:'。',
      correctReplacement:'商人不必把大批现银一路搬到远方',
      distractors:<String>['商人把大批现银一路不必搬到远方','商人不把大批现银必一路搬到远方','商人把不必大批现银一路搬到远方'],
      errorType:'“不必 + 把 + 对象 + 动作”语序',
      whyWrong:'Lv2 Discovery 已明确写出“使商人不必把大批现银一路搬到远方”；“不必”应放在“把”字结构之前。',
      revisionRule:'表达没有必要执行某个“把”字动作时，用“不必 + 把 + 对象 + 动作”。',
      memoryTip:'先说“不必”，再说把什么搬到哪里。',
      misconception:'把“不必”塞进“把”字结构内部，破坏否定范围',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-branch-after-verify',
      prefix:'汇票到达异地分号后，',
      brokenSegment:'需要才经过核验兑付现银',
      suffix:'。',
      correctReplacement:'需要经过核验才兑付现银',
      distractors:<String>['才需要经过核验兑付现银','经过核验需要才兑付现银','需要经过才核验兑付现银'],
      errorType:'“需要……才……”条件与顺序结构',
      whyWrong:'Lv3 Discovery 已说明汇票到达异地分号后需要经过核验才兑付现银；“才”标记核验完成后的兑付结果。',
      revisionRule:'表达前项是后项必要条件时，用“需要 + 前项动作 + 才 + 后项动作”。',
      memoryTip:'先核验，才兑付。',
      misconception:'把“才”提前到必要条件之前，打乱条件与结果',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-not-equal-risk-zero',
      prefix:'故事里的程砚、程岳、母亲和布店',
      brokenSegment:'是都虚构人物与私人事件',
      suffix:'；票号、汇兑、分号核验和古城金融地位来自可核查资料。',
      correctReplacement:'都是虚构人物与私人事件',
      distractors:<String>['都虚构是人物与私人事件','虚构都是人物与私人事件','是虚构都人物与私人事件'],
      errorType:'范围副词“都”的位置',
      whyWrong:'Lv4 Discovery 用“都是虚构人物与私人事件”划清虚构人物与可核查历史机制；“都”应放在判断动词“是”之前。',
      revisionRule:'“都”概括前面的并列主语时，通常放在谓语或判断动词之前。',
      memoryTip:'先列人，再用“都”概括。',
      misconception:'把范围副词“都”塞进判断结构内部',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-rather-than',
      prefix:'一张汇票能成立是因为背后有可识别的票据、账目与异地分号，',
      brokenSegment:'而不是纸本身因为有价值',
      suffix:'。',
      correctReplacement:'而不是因为纸本身有价值',
      distractors:<String>['而因为不是纸本身有价值','而不是纸本身有因为价值','所以不是因为纸本身有价值'],
      errorType:'“因为……而不是因为……”对比结构',
      whyWrong:'Lv5 Discovery 对比汇票成立的制度原因与纸张本身；第二个原因也要由“因为”引出。',
      revisionRule:'比较“真正原因 A”与“并非原因 B”时，可用“因为 A，而不是因为 B”。',
      memoryTip:'两个原因，两次“因为”。',
      misconception:'把第二个“因为”移进原因短语，破坏对比',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-ledger-result',
      prefix:'这一次，他只',
      brokenSegment:'把移到另一张柜台自己的账本、店章和下一批货单',
      suffix:'。',
      correctReplacement:'把自己的账本、店章和下一批货单移到另一张柜台',
      distractors:<String>['把移到另一张柜台自己的账本、店章和下一批货单','自己的账本、店章和下一批货单把移到另一张柜台','把自己的账本、店章和下一批货单另一张柜台移到'],
      errorType:'复杂“把”字句的宾语与处所顺序',
      whyWrong:'Lv6 Story 把一组宾语放在“把”之后，再用“移到另一张柜台”说明结果处所。',
      revisionRule:'“把 + 对象 + 动作 + 到 + 处所”先交代对象，再交代动作结果。',
      memoryTip:'把什么，移到哪里。',
      misconception:'把结果处所提前到“把”的宾语之前',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-credit-network',
      prefix:'',
      brokenSegment:'异地汇兑等于并不风险消失',
      suffix:'，而是把部分风险从长途携银转移到票据、记录、核验与机构信用上。',
      correctReplacement:'异地汇兑并不等于风险消失',
      distractors:<String>['异地汇兑等于风险并不消失','异地汇兑不并等于风险消失','异地汇兑并等于不风险消失'],
      errorType:'“并不等于”否定判断结构',
      whyWrong:'Lv7 Discovery 明确说异地汇兑并不等于风险消失；“并不”整体修饰“等于”。',
      revisionRule:'强调否定某个判断时，用“并不 + 判断动词”。',
      memoryTip:'并不，放在“等于”前。',
      misconception:'拆开“并不”或把否定放进被判断内容',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-who-must-leave',
      prefix:'这种网络',
      brokenSegment:'是既金融技术，也是社会协作',
      suffix:'：有人记录、有人核对、有人在远方兑付。',
      correctReplacement:'既是金融技术，也是社会协作',
      distractors:<String>['既金融技术，是也社会协作','是金融技术，既也是社会协作','既是金融技术，社会协作也'],
      errorType:'“既……也……”并列结构',
      whyWrong:'Lv8 Discovery 把票号网络同时定义为金融技术与社会协作；“既……也……”要平行连接两个判断。',
      revisionRule:'连接两个并列属性时，用“既是 A，也是 B”。',
      memoryTip:'既是 A，也是 B。',
      misconception:'把“既”放到判断动词之后，破坏并列对称',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-even-if-paid',
      prefix:'',
      brokenSegment:'当价值必须不再由同一个人亲自押送，人们对责任、在场和信任的理解重新可能分配',
      suffix:'。',
      correctReplacement:'当价值不再必须由同一个人亲自押送，人们对责任、在场和信任的理解可能重新分配',
      distractors:<String>['当价值必须不再由同一个人亲自押送，人们对责任、在场和信任的理解可能重新分配','当价值不再由同一个人必须亲自押送，人们对责任、在场和信任的理解可能重新分配','当价值不再必须由同一个人亲自押送，人们对责任、在场和信任的理解重新可能分配'],
      errorType:'“当……，……”条件框架与副词顺序',
      whyWrong:'Lv9 Discovery 用“当……”建立制度变化条件，并用“不再必须”和“可能重新”准确限定变化范围。',
      revisionRule:'“不再”应修饰“必须”，可能性副词“可能”应放在结果谓语之前。',
      memoryTip:'当条件变化，结果才“可能”重新分配。',
      misconception:'颠倒“不再/必须”或“可能/重新”的修饰顺序',
    ),
    GoldChallengeGrammarSpec(
      targetId:'pingyao-not-proof',
      prefix:'货款若在北京顺利兑付，',
      brokenSegment:'只能证明这套金融机制完成了它的工作；哥哥的信任它也自动能兑回来',
      suffix:'。',
      correctReplacement:'只能证明这套金融机制完成了它的工作；它不能自动把哥哥的信任一起兑回来',
      distractors:<String>['既能证明这套金融机制完成了它的工作，也能证明哥哥重新相信程砚','只能证明哥哥重新相信程砚；金融机制是否完成并不重要','证明这套金融机制完成了它的工作，所以哥哥的信任也会自动回来'],
      errorType:'证据范围与“只能……；不能……”限制结构',
      whyWrong:'Lv10 Story 把机制成功与关系修复明确分开；兑付结果只能证明机制完成工作，不能自动证明哥哥的信任恢复。',
      revisionRule:'限定证据能支持的结论时，用“只能证明 A；不能证明/不能自动推出 B”。',
      memoryTip:'机制成功，不等于关系自动修复。',
      misconception:'把有限证据扩大成关系结论',
    ),
  ],
  storyDistractors:"""
regex_once(challenge, profile_pattern, profile_replacement)

# Replace the stale all-level/8-character heuristic with strict level-aware full-phrase provenance.
detector_pattern = r"""      final allActive = <String>\[\n.*?      \}\n    \}\);"""
detector_replacement = r"""      String normalizeTeaching(String value) =>
          value.replaceAll(RegExp(r'[\s，。；：“”？、‘’（）]'), '');
      for (var index = 0; index < gold.grammar.length; index++) {
        final grammar = gold.grammar[index];
        expect(grammar.correctReplacement, isNot(grammar.brokenSegment));
        expect(<String>{grammar.correctReplacement, ...grammar.distractors}, hasLength(4));
        expect(grammar.misconception.trim().length, greaterThanOrEqualTo(8));

        final taughtThroughLevel = <String>[
          for (var level = 1; level <= index + 1; level++)
            pingyaoAncientCityGoldLevelContent(level).storyParagraphs.join(),
          for (var level = 1; level <= index + 1; level++)
            pingyaoDiscoveriesForLevel(level).map((entry) => entry.text).join(),
        ].join();

        expect(
          normalizeTeaching(taughtThroughLevel)
              .contains(normalizeTeaching(grammar.correctReplacement)),
          isTrue,
          reason:
              '${grammar.targetId} must be taught in current or earlier Story/Discovery',
        );
      }
    });"""
regex_once(gold_test, detector_pattern, detector_replacement)

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
