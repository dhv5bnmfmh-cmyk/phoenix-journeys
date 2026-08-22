from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text()


def write(path: str, value: str) -> None:
    (ROOT / path).write_text(value)


def replace_once(path: str, old: str, new: str) -> None:
    value = text(path)
    count = value.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one match, found {count}: {old[:100]!r}')
    write(path, value.replace(old, new, 1))


def replace_between(path: str, start: str, end: str, replacement: str) -> None:
    value = text(path)
    left = value.find(start)
    if left < 0:
        raise SystemExit(f'{path}: missing start marker {start!r}')
    right = value.find(end, left)
    if right < 0:
        raise SystemExit(f'{path}: missing end marker {end!r}')
    write(path, value[:left] + replacement + value[right:])


# -----------------------------------------------------------------------------
# 1. Author the advanced Forbidden City Story to the current Phoenix length
#    contract without padding it with essay prose. Each addition is enacted
#    through character action, evidence checking, relationship change, or a
#    visible consequence in the route map.
# -----------------------------------------------------------------------------
runtime = 'app/lib/data/forbidden_city_journey_runtime_base.dart'
advanced_replacements = {
    '沈砚想做一张能解释紫禁城空间组织的学习图。他从午门进入，沿中轴穿过外朝的连续院落与宫门，把路线连接到乾清门前；从这里再向北，空间进入与内廷关系更密切的区域。中轴给了他稳定的观察顺序，他便误把“最容易组织的路线”当成“所有人都应采用的路线”。阿宁的任务不同：她从东侧空间来到乾清门前，核对记录后还要回到东边。她的路线没有复制沈砚的线，却同样利用真实的宫门和连接关系。':
        '沈砚想做一张能解释紫禁城空间组织的学习图。他从午门进入，沿中轴穿过外朝的连续院落与宫门，把路线连接到乾清门前；从这里再向北，空间进入与内廷关系更密切的区域。中轴给了他稳定的观察顺序，他便误把“最容易组织的路线”当成“所有人都应采用的路线”。阿宁的任务不同：她从东侧空间来到乾清门前，核对记录后还要回到东边。她的路线没有复制沈砚的线，却同样利用真实的宫门和连接关系。到乾清门前，阿宁没有急着证明自己，而是先把东侧经过的宫门和院落一一指给沈砚看，问他哪些连接是两个人共同面对的。',
    '阿宁主动提出把“路线对不对”拆成两个问题：空间能不能连接，路线是不是适合这个人的任务。两人逐项比较后，沈砚承认自己的图只表达了一个观察顺序。他把外朝、内廷、共同节点和两人的任务一起标注在图上，不再把阿宁的路线降成次要旁线。阿宁也改变了对沈砚的看法：她原以为他只会守着自己的图，现在愿意让他把中轴关系补进她的记录。两张路线因此不再互相排斥，而是共同解释同一座宫城。':
        '阿宁主动提出把“路线对不对”拆成两个问题：空间能不能连接，路线是不是适合这个人的任务。两人逐项比较后，沈砚承认自己的图只表达了一个观察顺序。他把外朝、内廷、共同节点和两人的任务一起标注在图上，不再把阿宁的路线降成次要旁线。阿宁也改变了对沈砚的看法：她原以为他只会守着自己的图，现在愿意让他把中轴关系补进她的记录。两张路线因此不再互相排斥，而是共同解释同一座宫城。周师傅让他们把理由写在路线旁。沈砚第一次发现，图上多一条线并不会让关系变乱，反而能看清每条线为什么出现。',
    '沈砚从午门沿中轴记录外朝的宫门和院落，到乾清门前时，他已经形成一个判断：这条连续、清楚、常用的线最能代表紫禁城的空间组织。阿宁从东侧来到乾清门前，她要完成东边的记录任务，所以路线从一开始就服从另一个目标。沈砚把差异当成错误，阿宁却要求他先检查证据。她没有只说“我也对”，而是带他回看两条线分别经过的连接点，并让他区分“建筑允许怎样连接”和“任务要求我去哪里”。':
        '沈砚从午门沿中轴记录外朝的宫门和院落，到乾清门前时，他已经形成一个判断：这条连续、清楚、常用的线最能代表紫禁城的空间组织。阿宁从东侧来到乾清门前，她要完成东边的记录任务，所以路线从一开始就服从另一个目标。沈砚把差异当成错误，阿宁却要求他先检查证据。她没有只说“我也对”，而是带他回看两条线分别经过的连接点，并让他区分“建筑允许怎样连接”和“任务要求我去哪里”。阿宁把自己的任务记录递给沈砚，让他先指出其中与宫门、院落不相符的地方；若找不到，就不能只因为路线不同判她错。',
    '证据改变了争论。中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。两人面对的是同一组建筑约束，却从不同任务与视角作出选择。沈砚因此撤回“只有一条正确路线”的判断，在图上标出共同节点、不同目标和各自路线。阿宁看到他愿意让证据改变结论，也不再把他当成只相信图纸的人。周师傅让他们交换图笔：沈砚请阿宁画她的线，阿宁请沈砚补上中轴与外朝的关系。':
        '证据改变了争论。中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。两人面对的是同一组建筑约束，却从不同任务与视角作出选择。沈砚因此撤回“只有一条正确路线”的判断，在图上标出共同节点、不同目标和各自路线。阿宁看到他愿意让证据改变结论，也不再把他当成只相信图纸的人。周师傅让他们交换图笔：沈砚请阿宁画她的线，阿宁请沈砚补上中轴与外朝的关系。沈砚重新检查后，在两条路线旁分别写下“空间连接”“任务目标”“下一步行动”。阿宁看到他真正改了判断，也把自己原先只顾赶路的几处记录补成别人能读懂的说明。',
    '沈砚在午门进入紫禁城后，沿中轴观察外朝。他记录连续的宫门、院落与方向，到乾清门前时，把这条清晰的观察路线当成理解宫城的首选框架。阿宁却从东侧空间抵达同一位置。她负责核对东边的记录点，选择的路线优先满足任务效率。沈砚最初用自己的图评价她，认为偏离中轴就削弱了路线的解释力。阿宁没有把冲突变成输赢，她主动提出三个问题：两条线各自有哪些空间证据？各自服务谁的任务？哪些建筑条件是两人都不能忽略的？':
        '沈砚在午门进入紫禁城后，沿中轴观察外朝。他记录连续的宫门、院落与方向，到乾清门前时，把这条清晰的观察路线当成理解宫城的首选框架。阿宁却从东侧空间抵达同一位置。她负责核对东边的记录点，选择的路线优先满足任务效率。沈砚最初用自己的图评价她，认为偏离中轴就削弱了路线的解释力。阿宁没有把冲突变成输赢，她主动提出三个问题：两条线各自有哪些空间证据？各自服务谁的任务？哪些建筑条件是两人都不能忽略的？她把东侧记录摊开，请沈砚先删掉任何不符合建筑连接的部分；沈砚检查后只能指出两处表达不清，却找不到“这条线不成立”的空间证据。阿宁因此要求他把“常用”与“唯一”分开。',
    '他们重新检查后发现，中轴、宫门与院落构成共同的空间条件，乾清门前又是两条路线可以相遇的位置；真正不同的是人物的目标、视角和下一步行动。沈砚据此改变判断：一条路线可以是常用框架，却不能自动取得排他的地位。他让阿宁决定怎样呈现自己的路线，自己只补充两条线之间的连接说明。阿宁则主动把原先只为完成任务而画的线改成别人也能读懂的记录。两人的合作从“谁纠正谁”变成“谁提供哪一种证据”。':
        '他们重新检查后发现，中轴、宫门与院落构成共同的空间条件，乾清门前又是两条路线可以相遇的位置；真正不同的是人物的目标、视角和下一步行动。沈砚据此改变判断：一条路线可以是常用框架，却不能自动取得排他的地位。他让阿宁决定怎样呈现自己的路线，自己只补充两条线之间的连接说明。阿宁则主动把原先只为完成任务而画的线改成别人也能读懂的记录。两人的合作从“谁纠正谁”变成“谁提供哪一种证据”。周师傅没有给答案，只让两人各自为对方补一条证据。沈砚补上中轴与外朝的关系，阿宁补上东侧门户与共同节点的关系。图上出现了相同条件下的不同优先次序，也出现了两人新的分工：谁提出判断，谁就要说明依据。',
    '沈砚从午门沿中轴进入紫禁城，外朝连续的宫门与院落让他的观察形成稳定的空间骨架。到乾清门前，他把这条常用路线视为最有解释力的路线偏好，并进一步误认为其他路线都应向它靠拢。阿宁从东侧抵达，她的任务要求她在东边几个记录点之间移动，再到乾清门前与周师傅会合。她不否认中轴的重要性，却指出：如果只用沈砚的视角评价所有行动，图会隐藏任务差异。为了证明这一点，她主动放慢自己的进度，和沈砚逐点检查两条路线的空间证据。':
        '沈砚从午门沿中轴进入紫禁城，外朝连续的宫门与院落让他的观察形成稳定的空间骨架。到乾清门前，他把这条常用路线视为最有解释力的路线偏好，并进一步误认为其他路线都应向它靠拢。阿宁从东侧抵达，她的任务要求她在东边几个记录点之间移动，再到乾清门前与周师傅会合。她不否认中轴的重要性，却指出：如果只用沈砚的视角评价所有行动，图会隐藏任务差异。为了证明这一点，她主动放慢自己的进度，和沈砚逐点检查两条路线的空间证据。沈砚起初还想把阿宁的路线画成细线，表示“次要”。阿宁没有争线条粗细，她把自己的记录折到他面前，让他逐项检查：东侧节点是否真实相连，乾清门前是否能会合，任务是否要求她返回东边。三项都成立后，她只问：“如果条件成立，为什么一定要降级？”',
    '比较结果没有把任何一条线变成错误。建筑的中轴、宫门、院落、外朝与内廷关系构成共同条件，但这些条件并不会取消人物目标。沈砚意识到，自己的路线偏好来自学习任务，而不是来自一条支配所有行动的答案。他于是把图改成多层表示：共同空间骨架放在底层，两人的目标和路线分别标在上面。更重要的是，他把解释阿宁路线的笔交给阿宁本人。阿宁也不再把沈砚看作只守主线的人，她请他指出自己的记录在哪些地方缺少整体空间关系。两人的图因为保留差异而变得更完整。':
        '比较结果没有把任何一条线变成错误。建筑的中轴、宫门、院落、外朝与内廷关系构成共同条件，但这些条件并不会取消人物目标。沈砚意识到，自己的路线偏好来自学习任务，而不是来自一条支配所有行动的答案。他于是把图改成多层表示：共同空间骨架放在底层，两人的目标和路线分别标在上面。更重要的是，他把解释阿宁路线的笔交给阿宁本人。阿宁也不再把沈砚看作只守主线的人，她请他指出自己的记录在哪些地方缺少整体空间关系。两人的图因为保留差异而变得更完整。周师傅让两人交换图笔。沈砚不能替阿宁解释她的动机，只能标出共同空间骨架；阿宁不能否定中轴的重要性，只能说明自己的任务怎样改变优先次序。最后两层路线仍然分开，但每一层都能看到另一层的条件。沈砚把原先的粗细等级擦掉，改用同样清楚的线条。',
    '沈砚想把紫禁城画成一张“任何人一看就知道怎样走”的图。他从午门沿中轴进入，外朝连续的宫门与院落提供强烈的南北秩序；到乾清门前，外朝与内廷的关系又让这里成为理解空间转换的重要位置。于是他把自己的学习路线设为默认答案。阿宁从东侧抵达，她负责东边记录点，必须在任务效率、可连接的宫门与会合地点之间权衡。她承认沈砚的路线适合读中轴，却拒绝把“适合一种任务”偷换成“适合所有任务”。她主动让沈砚用三类证据检验两条线：建筑连接、人物目标、行动后果。':
        '沈砚想把紫禁城画成一张“任何人一看就知道怎样走”的图。他从午门沿中轴进入，外朝连续的宫门与院落提供强烈的南北秩序；到乾清门前，外朝与内廷的关系又让这里成为理解空间转换的重要位置。于是他把自己的学习路线设为默认答案。阿宁从东侧抵达，她负责东边记录点，必须在任务效率、可连接的宫门与会合地点之间权衡。她承认沈砚的路线适合读中轴，却拒绝把“适合一种任务”偷换成“适合所有任务”。她主动让沈砚用三类证据检验两条线：建筑连接、人物目标、行动后果。阿宁先把自己的路线交给沈砚，让他按三类证据逐项挑错。沈砚发现东侧节点与乾清门前的连接成立，却质疑她只顾任务效率，可能忽略整体空间关系。阿宁接受这一点，主动在记录上补出中轴和外朝；随后她反过来问沈砚：若他的路线适合学习观察，却让东侧任务多绕一段，他凭什么把它称作所有人的默认答案？',
    '沈砚逐项重画后发现，两条路线共享午门以后所读到的宫城结构，也在乾清门前发生关系，但它们的空间偏好由不同任务塑造。若删掉阿宁的线，图会失去东侧任务的行动逻辑；若否认中轴，阿宁的局部记录又难以放回整体。沈砚因此不再裁定谁服从谁，而是保留两条路线并写下各自成立的条件。阿宁看到他愿意让别人的证据改变图的结构，也把自己的记录交给他补充整体关系。周师傅最后没有选“标准答案”，只让他们共同署名。沈砚在图角写下一句：一条常用路线，并不等于唯一正确的路线。':
        '沈砚逐项重画后发现，两条路线共享午门以后所读到的宫城结构，也在乾清门前发生关系，但它们的空间偏好由不同任务塑造。若删掉阿宁的线，图会失去东侧任务的行动逻辑；若否认中轴，阿宁的局部记录又难以放回整体。沈砚因此不再裁定谁服从谁，而是保留两条路线并写下各自成立的条件。阿宁看到他愿意让别人的证据改变图的结构，也把自己的记录交给他补充整体关系。周师傅最后没有选“标准答案”，只让他们共同署名。沈砚在图角写下一句：一条常用路线，并不等于唯一正确的路线。周师傅把两张草图并排放下，要求他们各自说出删掉对方路线会失去什么。沈砚说会失去东侧任务的行动逻辑；阿宁说会失去中轴把局部放回整体的能力。两人于是把“可连接”“适合任务”“能解释整体”分成三栏，在每条路线旁写明成立条件。共同署名前，沈砚把最后一处“标准路线”改成“常用观察路线”，阿宁也把“最快”改成“对本次任务更直接”。',
}
for old, new in advanced_replacements.items():
    replace_once(runtime, old, new)

# -----------------------------------------------------------------------------
# 2. Move dedicated screen selection out of the normal six-stage build region.
# -----------------------------------------------------------------------------
ref_screen = 'app/lib/screens/forbidden_city_reference_journey_screen.dart'
replace_once(
    ref_screen,
    "class ForbiddenCityReferenceJourneyScreen extends StatefulWidget {",
    "Widget? resolveDedicatedJourneyRuntimeScreen(String journeyId) {\n"
    "  if (journeyId == forbiddenCityJourneyId) {\n"
    "    return const ForbiddenCityReferenceJourneyScreen();\n"
    "  }\n"
    "  return null;\n"
    "}\n\n"
    "class ForbiddenCityReferenceJourneyScreen extends StatefulWidget {",
)

journey_screen = 'app/lib/screens/journey_screen.dart'
replace_once(
    journey_screen,
    "  List<NarrationItem>? _cachedDiscoveryNarrationItems;\n\n  // Pilot N1 content remains",
    "  List<NarrationItem>? _cachedDiscoveryNarrationItems;\n"
    "  Widget? _dedicatedRuntimeScreen;\n\n"
    "  // Pilot N1 content remains",
)
replace_once(
    journey_screen,
    "    _experience = requireDailyJourneyExperience(journeyId);\n    if (_experience.id == forbiddenCityJourneyId) {",
    "    _experience = requireDailyJourneyExperience(journeyId);\n"
    "    _dedicatedRuntimeScreen = resolveDedicatedJourneyRuntimeScreen(journeyId);\n"
    "    if (_experience.id == forbiddenCityJourneyId) {",
)
replace_once(
    journey_screen,
    "  @override\n  Widget build(BuildContext context) {\n    if (_isForbiddenCity) {\n      return const ForbiddenCityReferenceJourneyScreen();\n    }",
    "  @override\n  Widget build(BuildContext context) {\n"
    "    final dedicatedRuntime = _dedicatedRuntimeScreen;\n"
    "    if (dedicatedRuntime != null) {\n"
    "      return dedicatedRuntime;\n"
    "    }",
)

# -----------------------------------------------------------------------------
# 3. Replace retired descriptive DNA with metadata derived from the active
#    dual-route Story and its current co-authored ending.
# -----------------------------------------------------------------------------
dna = 'app/lib/data/journey_narrative_dna_catalog.dart'
new_dna = """const forbiddenCityRemediatedNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'beijing-forbidden-city',
  narrativeIdentity:
      'dual-valid-route-overlay-becomes-evidence-tested-coauthored-palace-map',
  protagonistIdentity:
      'Shen-Yan-seventeen-year-old-heritage-building-apprentice',
  protagonistAgeIdentity: 'seventeen-year-old-apprentice',
  protagonistArchetype:
      'young-heritage-building-apprentice-revising-route-judgment-through-evidence',
  openingSituation:
      'familiar-central-axis-route-is-mistaken-for-the-only-correct-route-before-A-Ning-arrives-from-the-east',
  storyGoal:
      'make-palace-spatial-relations-readable-without-erasing-task-dependent-route-differences',
  locationMechanism:
      'Meridian-Gate-central-axis-Outer-Court-Inner-Court-Gate-of-Heavenly-Purity-and-east-side-connections-form-the-shared-spatial-framework',
  movementPattern:
      'central-axis-observation-and-east-side-task-route-meet-at-Gate-of-Heavenly-Purity-then-are-compared-and-layered',
  conflictType:
      'single-authoritative-route-model-vs-coexisting-role-and-purpose-dependent-routes',
  choiceType:
      'preserve-both-valid-routes-and-label-their-task-conditions-on-one-map',
  climaxType:
      'shared-architectural-evidence-forces-route-judgment-revision-at-the-common-node',
  consequenceType:
      'coauthored-map-keeps-two-routes-and-their-validity-conditions-visible',
  emotionalArc:
      'single-line-certainty-to-judgment-to-evidence-check-to-reciprocal-respect-to-coauthorship',
  historicalLearningMechanism:
      'verified-axis-gate-courtyard-Outer-Inner-Court-and-east-side-gate-relations-become-the-common-spatial-scaffold-for-fictional-route-comparison',
  resolutionType:
      'two-task-dependent-routes-survive-one-common-evidence-test-without-being-collapsed',
  endingMechanism:
      'Shen-Yan-and-A-Ning-co-sign-a-map-with-both-routes-and-their-conditions-legible',
  memoryAnchorType:
      'two-overlaid-routes-with-explicit-validity-conditions-on-one-shared-map',
  achievementType: 'evidence-tested-multi-perspective-palace-space-reader',
  rewardSymbolism:
      'two-clearly-labeled-lines-represent-conditional-validity-and-reciprocal-interpretation',
  temporalPattern: 'single-study-day-without-external-countdown',
  supportingStructure:
      'cross-role-peer-perspective-exchange-between-Shen-Yan-and-A-Ning-with-mentor-refusing-to-supply-the-answer',
  centralMetaphor:
      'one-architectural-framework-can-support-multiple-valid-movement-logics-when-their-conditions-are-made-explicit',
  narrativeVoice: 'third-person-action-led-spatial-comparison',
  storyRhythm:
      'route-assertion-peer-contradiction-evidence-check-mutual-correction-layered-map-coauthorship',
);

"""
replace_between(
    dna,
    'const forbiddenCityRemediatedNarrativeDna = JourneyNarrativeDnaRecord(',
    'const chengduRemediatedNarrativeDna = JourneyNarrativeDnaRecord(',
    new_dna,
)

# -----------------------------------------------------------------------------
# 4. Rebind all ten CORE semantic evidence dimensions to exact active Story
#    spans. Mechanism families remain stable; provenance becomes truthful.
# -----------------------------------------------------------------------------
fingerprint = 'app/lib/data/journey_semantic_fingerprint_catalog.dart'
new_fingerprint = """final _forbiddenFingerprint = JourneySemanticFingerprint(
  journeyId: _forbidden,
  surfaceIdentity:
      'Shen Yan / heritage-building apprentice / A Ning / evidence-tested dual-route palace map',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.dualValidRoutesCreateOpeningContradiction,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.apprenticeSeekingCompleteUnderstanding,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.crossRolePeerPerspectiveExchange,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.makePluralRouteRelationsLegible,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.singleAuthoritativeRouteVsCoexistingValidRoutes,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.preserveBothRoutesThroughOverlay,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.sharedNodeRevealsOverlapAndDivergence,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.compositeRepresentationAddsRelationalInformation,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.singleRouteTruthToRoleDependentSpatialSystem,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.sharedNodeThenPurposefulDivergence,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.roleDifferentiatedArchitectureMakesPluralRoutesLegible,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.overlaidRoutesPreserveCoexistingPerspectives,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.compareAlignOverlayThenDiverge,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.singleStudyDayWithoutExternalCountdown,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.peerContributesIndependentRoutePerspective,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
  }),
  coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.openingMechanism,
      mechanism: NarrativeMechanismFamily.dualValidRoutesCreateOpeningContradiction,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。',
        '阿宁却从东侧来到乾清门前。',
      ],
      semanticRationale:
          'The opening contradiction is produced by two viable approaches to the same Forbidden City node, not by a generic disagreement.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.conflictMechanism,
      mechanism: NarrativeMechanismFamily.singleAuthoritativeRouteVsCoexistingValidRoutes,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '沈砚说她走错了。',
        '两条线都能到乾清门前，却服务不同任务。',
      ],
      semanticRationale:
          'Shen Yan turns his familiar route into an exclusive rule while the Story demonstrates two task-dependent routes reaching the same node.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.choiceMechanism,
      mechanism: NarrativeMechanismFamily.preserveBothRoutesThroughOverlay,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '阿宁没有让他改口，而是做了一个选择：她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。',
        '于是他在图上分别标注“中轴观察”和“东侧记录”，把两条路线都保留。',
      ],
      semanticRationale:
          'A Ning spends time to make the competing route inspectable, and Shen Yan answers by preserving both lines rather than erasing one.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.climaxMechanism,
      mechanism: NarrativeMechanismFamily.sharedNodeRevealsOverlapAndDivergence,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '证据改变了争论。',
        '中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。',
      ],
      semanticRationale:
          'The common architectural node turns disagreement into a checkable comparison in which both routes survive the same spatial test.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.consequenceMechanism,
      mechanism: NarrativeMechanismFamily.compositeRepresentationAddsRelationalInformation,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '他于是把图改成多层表示：共同空间骨架放在底层，两人的目标和路线分别标在上面。',
      ],
      semanticRationale:
          'The visible artifact gains information by separating the shared spatial framework from task-specific routes instead of collapsing them.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.transformationMechanism,
      mechanism: NarrativeMechanismFamily.singleRouteTruthToRoleDependentSpatialSystem,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '沈砚据此改变判断：一条路线可以是常用框架，却不能自动取得排他的地位。',
        '两人的合作从“谁纠正谁”变成“谁提供哪一种证据”。',
      ],
      semanticRationale:
          'The protagonist changes both his spatial model and his way of working with A Ning: claims now require evidence and task context.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.endingMechanism,
      mechanism: NarrativeMechanismFamily.sharedNodeThenPurposefulDivergence,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '周师傅最后没有选“标准答案”，只让他们共同署名。',
        '沈砚在图角写下一句：一条常用路线，并不等于唯一正确的路线。',
      ],
      semanticRationale:
          'The ending refuses a single winner and preserves distinct route conditions in a jointly owned representation.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.relationshipGeometry,
      mechanism: NarrativeMechanismFamily.crossRolePeerPerspectiveExchange,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '临走时，他请阿宁把自己的路线再画清楚；阿宁也愿意听他说明中轴。',
        '更重要的是，他把解释阿宁路线的笔交给阿宁本人。',
      ],
      semanticRationale:
          'Authority moves from Shen Yan judging A Ning to reciprocal interpretation, with each person retaining authorship of the evidence they know best.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.culturalAnchorFunction,
      mechanism: NarrativeMechanismFamily.roleDifferentiatedArchitectureMakesPluralRoutesLegible,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '他从午门进入，沿中轴穿过外朝的连续院落与宫门，把路线连接到乾清门前；从这里再向北，空间进入与内廷关系更密切的区域。',
        '建筑的中轴、宫门、院落、外朝与内廷关系构成共同条件，但这些条件并不会取消人物目标。',
      ],
      semanticRationale:
          'Verified Forbidden City axes, gates, courtyards, functional zones, and the Gate of Heavenly Purity create the causal spatial framework; the same Story cannot be transplanted unchanged to a generic mall or street.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.dramaticEngineFamily,
      mechanism: NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她主动让沈砚用三类证据检验两条线：建筑连接、人物目标、行动后果。',
        '沈砚因此不再裁定谁服从谁，而是保留两条路线并写下各自成立的条件。',
      ],
      semanticRationale:
          'The causal engine tests two perspectives against the same architectural facts, keeps both where their conditions hold, and produces a richer relational model instead of a winner.',
    ),
  ]),
);

"""
replace_between(
    fingerprint,
    'final _forbiddenFingerprint = JourneySemanticFingerprint(',
    'final _chengduFingerprint = JourneySemanticFingerprint(',
    new_fingerprint,
)

# -----------------------------------------------------------------------------
# 5. Update tests that were explicitly asserting retired Forbidden City prose
#    or pre-Asia hierarchy. Do not relax current quality gates.
# -----------------------------------------------------------------------------
trace = 'app/test/forbidden_city_final_trace_test.dart'
replace_once(
    trace,
    "bool _enactsRouteSynthesis(String story) =>\n    <String>['同一张', '叠', '保留', '同时进入一张图', '复合表示', '同处一页'].any(story.contains);\n\nbool _preservesPurposefulRouteDivergence(String story) =>\n    <String>['分开', '分向', '分岔', '转向别处', '转向各自的方向'].any(story.contains);",
    "bool _enactsRouteSynthesis(String story) =>\n"
    "    story.contains('两条') &&\n"
    "    <String>['保留', '同时', '共同', '多层表示', '标出', '写下各自成立的条件']\n"
    "        .any(story.contains);\n\n"
    "bool _preservesPurposefulRouteDivergence(String story) =>\n"
    "    story.contains('中轴') &&\n"
    "    story.contains('东侧') &&\n"
    "    <String>['任务', '目标'].any(story.contains);",
)
replace_once(
    trace,
    "      expect(story, contains('十七岁的营造学徒沈砚'), reason: 'Lv${index + 1}');",
    "      expect(story, contains('沈砚'), reason: 'Lv${index + 1}');",
)
replace_once(
    trace,
    "    expect(corpus, contains('午门是紫禁城的正门'));\n    expect(corpus, contains('南北轴线'));\n    expect(corpus, contains('外朝'));\n    expect(corpus, contains('内廷'));\n    expect(corpus, contains('乾清门'));\n    expect(corpus, contains('多种推荐参观路线'));\n    expect(corpus, contains('不是历史官方'));",
    "    expect(corpus, contains('午门是紫禁城正门'));\n"
    "    expect(corpus, contains('南北轴线'));\n"
    "    expect(corpus, contains('外朝'));\n"
    "    expect(corpus, contains('内廷'));\n"
    "    expect(corpus, contains('乾清门'));\n"
    "    expect(corpus, contains('景运门'));\n"
    "    expect(corpus, contains('路线必须服从这些真实空间条件'));\n"
    "    expect(corpus, isNot(contains('不是历史官方')));",
)

semantic_test = 'app/test/journey_semantic_anti_template_gate_test.dart'
replace_once(
    semantic_test,
    "    expect(record.protagonistArchetype, contains('construction-apprentice'));",
    "    expect(record.protagonistArchetype, contains('heritage-building-apprentice'));",
)
replace_once(
    semantic_test,
    "    expect(record.consequenceType, contains('composite-map-adds-relational-information'));",
    "    expect(record.consequenceType, contains('coauthored-map-keeps-two-routes'));",
)
replace_once(
    semantic_test,
    "    expect(record.endingMechanism, contains('different-directions'));",
    "    expect(record.endingMechanism, contains('co-sign'));",
)
replace_once(
    semantic_test,
    "    expect(active, contains('十七岁的营造学徒沈砚'));\n    expect(active, contains('年幼侍役阿宁'));\n    expect(active, contains('一张叠着两条路线的图'));",
    "    expect(active, contains('十七岁的古建学徒沈砚'));\n"
    "    expect(active, contains('阿宁'));\n"
    "    expect(active, contains('把两条路线都留下'));\n"
    "    expect(active, contains('共同署名'));",
)

preview = 'app/test/batch_one_final_preview_binding_test.dart'
replace_once(
    preview,
    "    expect(forbiddenCityMemoryAnchor, '一张叠着两条路线的图');",
    "    expect(forbiddenCityMemoryAnchor, '两条都能走通的路线');",
)

geo_test = 'app/test/journey_location_hierarchy_test.dart'
for old, new in {
    "'chengdu-kuanzhai-alley': ['中国', '四川省', '成都市', '宽窄巷子'],":
        "'chengdu-kuanzhai-alley': ['亚洲', '中国', '四川省', '成都市', '宽窄巷子'],",
    "'hangzhou-west-lake': ['中国', '浙江省', '杭州市', '西湖文化景观'],":
        "'hangzhou-west-lake': ['亚洲', '中国', '浙江省', '杭州市', '西湖文化景观'],",
    "'xian-city-wall': ['中国', '陕西省', '西安市', '西安城墙'],":
        "'xian-city-wall': ['亚洲', '中国', '陕西省', '西安市', '西安城墙'],",
    "'nanjing-qinhuai-river': ['中国', '江苏省', '南京市', '夫子庙秦淮风光带'],":
        "'nanjing-qinhuai-river': ['亚洲', '中国', '江苏省', '南京市', '夫子庙秦淮风光带'],",
}.items():
    replace_once(geo_test, old, new)
replace_once(
    geo_test,
    "        '${entry.value[1]} · ${entry.value[2]}',",
    "        '${entry.value[2]} · ${entry.value[3]}',",
)
replace_once(
    geo_test,
    "      orderedEquals(['中国', '广东省', '广州市', '陈家祠']),",
    "      orderedEquals(['亚洲', '中国', '广东省', '广州市', '陈家祠']),",
)

world_test = 'app/test/phoenix_world_story_agent_test.dart'
replace_once(
    world_test,
    "      ['世界', '中国', '北京市', '东城区', '故宫博物院'],",
    "      ['世界', '亚洲', '中国', '北京市', '东城区', '故宫博物院'],",
)

# The global Gold snapshot exercises the legacy generic 3-mode panel. The
# Reference Journey has a dedicated cognition-first Story/Evidence/Transfer gate
# and is exhaustively covered by forbidden_city_reference_* tests instead.
snapshot = 'app/test/all_gold_challenge_runtime_snapshot_test.dart'
replace_once(
    snapshot,
    "import 'package:phoenix_journeys/data/extended_journey_catalog.dart';\nimport 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';",
    "import 'package:phoenix_journeys/data/extended_journey_catalog.dart';\n"
    "import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';\n"
    "import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';",
)
replace_once(
    snapshot,
    "    final approvedIds = approvedNarrativeDnaCatalog\n        .map((record) => record.journeyId)\n        .toSet();",
    "    final approvedIds = approvedNarrativeDnaCatalog\n"
    "        .map((record) => record.journeyId)\n"
    "        .toSet();\n"
    "    final genericSnapshotIds = approvedIds\n"
    "        .where((id) => id != forbiddenCityJourneyId)\n"
    "        .toSet();",
)
replace_once(
    snapshot,
    "    for (final journeyId in approvedIds.toList()..sort()) {",
    "    for (final journeyId in genericSnapshotIds.toList()..sort()) {",
)
replace_once(
    snapshot,
    "    expect(rows.length, approvedIds.length * 10 * 3);",
    "    expect(rows.length, genericSnapshotIds.length * 10 * 3);",
)
replace_once(
    snapshot,
    "      'expectedChallengeUnits': approvedIds.length * 10 * 3,",
    "      'expectedChallengeUnits': genericSnapshotIds.length * 10 * 3,",
)

print('Forbidden City final convergence patch applied.')
