from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text(encoding='utf-8')
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one match, found {count}: {old[:80]!r}')
    p.write_text(text.replace(old, new, 1), encoding='utf-8')


SOURCE = 'app/lib/data/quanzhou_kaiyuan_gold_content.dart'
TEST = 'app/test/quanzhou_kaiyuan_gold_runtime_test.dart'
DNA = 'app/lib/data/journey_narrative_dna_catalog.dart'
SEMANTIC = 'app/lib/data/journey_semantic_fingerprint_catalog.dart'

replace_once(
    SOURCE,
    "const quanzhouKaiyuanDescription =\n    '许安、许宁与家庭细节均为虚构；开元寺戒坛、民国初年传戒活动及泉州海洋商贸遗产机制依据 UNESCO 与泉州官方资料。';",
    "const quanzhouKaiyuanDescription =\n    '许安、许宁、家庭关系与西街旧宅位置均为虚构；开元寺的西街位置、甘露戒坛、民国初年传戒活动及泉州海洋商贸遗产机制依据官方与 UNESCO 资料。';",
)
replace_once(
    SOURCE,
    "const quanzhouStorySignature =\n    'PRACTICE CAUSALITY × ADULT SIBLING BELONGING × ORDINATION THRESHOLD × RELINQUISHED UNCHANGED FALLBACK';",
    "const quanzhouStorySignature =\n    'PRACTICE CAUSALITY × ADULT SIBLING BELONGING × SAME-STREET ORDINATION THRESHOLD × RELINQUISHED AUTOMATIC HOME ACCESS';",
)

replace_once(
    SOURCE,
    "  StorySourceRecord(\n    id: 'quanzhou-religion-kaiyuan',\n    title: '泉州开元寺',\n    publisher: '泉州市民族与宗教事务局',\n    url: 'https://mzzj.quanzhou.gov.cn/zjzc/qzzjhdcs/200712/t20071207_2313558.htm',\n    kind: StorySourceKind.government,\n    languageCode: 'zh-CN',\n    geoNodeIds: [quanzhouKaiyuanGeoNodeId],\n    verificationStatus: StoryVerificationStatus.verified,\n    accessedOn: '2026-08-15',\n  ),\n];",
    "  StorySourceRecord(\n    id: 'quanzhou-religion-kaiyuan',\n    title: '泉州开元寺',\n    publisher: '泉州市民族与宗教事务局',\n    url: 'https://mzzj.quanzhou.gov.cn/zjzc/qzzjhdcs/200712/t20071207_2313558.htm',\n    kind: StorySourceKind.government,\n    languageCode: 'zh-CN',\n    geoNodeIds: [quanzhouKaiyuanGeoNodeId],\n    verificationStatus: StoryVerificationStatus.verified,\n    accessedOn: '2026-08-15',\n  ),\n  StorySourceRecord(\n    id: 'licheng-government-kaiyuan-west-street',\n    title: '开元寺',\n    publisher: '鲤城区人民政府',\n    url: 'https://www.qzlc.gov.cn/zjlc/lcfq/ji/200804/t20080405_1279117.htm',\n    kind: StorySourceKind.government,\n    languageCode: 'zh-CN',\n    geoNodeIds: [quanzhouKaiyuanGeoNodeId],\n    verificationStatus: StoryVerificationStatus.verified,\n    accessedOn: '2026-08-15',\n  ),\n];",
)

replace_once(
    SOURCE,
    "  {\n    'SOURCE_ID': 'QZ-S4',\n    'SOURCE_TITLE': '泉州开元寺',\n    'AUTHORITY': '泉州市民族与宗教事务局',\n    'SOURCE_TYPE': 'OFFICIAL RELIGIOUS-SITE RECORD',\n    'RELEVANT_CLAIMS': 'Kaiyuan ordination platform history and temple layout',\n    'WHAT_IT_CAN_PROVE': 'corroborating Kaiyuan place identity and ordination-platform chronology',\n    'WHAT_IT_CANNOT_PROVE': 'private human Story facts',\n    'CONFIDENCE': 'HIGH',\n    'NOTES': 'Used as corroboration only where its wording is direct.',\n  },\n];",
    "  {\n    'SOURCE_ID': 'QZ-S4',\n    'SOURCE_TITLE': '泉州开元寺',\n    'AUTHORITY': '泉州市民族与宗教事务局',\n    'SOURCE_TYPE': 'OFFICIAL RELIGIOUS-SITE RECORD',\n    'RELEVANT_CLAIMS': 'Kaiyuan ordination platform history and temple layout',\n    'WHAT_IT_CAN_PROVE': 'corroborating Kaiyuan place identity and ordination-platform chronology',\n    'WHAT_IT_CANNOT_PROVE': 'private human Story facts',\n    'CONFIDENCE': 'HIGH',\n    'NOTES': 'Used as corroboration only where its wording is direct.',\n  },\n  {\n    'SOURCE_ID': 'QZ-S5',\n    'SOURCE_TITLE': '开元寺',\n    'AUTHORITY': '鲤城区人民政府',\n    'SOURCE_TYPE': 'OFFICIAL PLACE RECORD',\n    'RELEVANT_CLAIMS': 'Kaiyuan Temple is on the north side of the middle section of West Street; Ganlu Ordination Platform lies on the temple central axis',\n    'WHAT_IT_CAN_PROVE': 'verified Kaiyuan-to-West-Street spatial relationship used by the repaired place-causal hinge',\n    'WHAT_IT_CANNOT_PROVE': 'that Xu An, Xu Ning or any real family lived on West Street',\n    'CONFIDENCE': 'HIGH',\n    'NOTES': 'The fictional old-house placement on West Street is explicitly fiction; only the temple/street relationship is historical fact.',\n  },\n];",
)

replace_once(
    SOURCE,
    "  {\n    'CLAIM_ID': 'QZ-C6-fictional-family',\n    'CLAIM': '许安、许宁、旧宅、空房、钥匙、孩子与姐弟对话均为虚构。',\n    'CLAIM_TYPE': 'FICTIONAL CHARACTER ACTION',\n    'SOURCE': 'Phoenix authored fiction',\n    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou Story production record',\n    'CONFIDENCE': 'EXPLICIT FICTION',\n    'STORY_USE': 'human causal spine',\n    'DISCOVERY_USE': 'truth-boundary reminder only',\n    'INTERPRETATION_BOUNDARY': '不对应任何真实僧人、家庭、戒牒或寺院档案。',\n    'RESULT': 'PASS',\n  },\n];",
    "  {\n    'CLAIM_ID': 'QZ-C6-fictional-family',\n    'CLAIM': '许安、许宁、旧宅、空房、钥匙、孩子与姐弟对话均为虚构。',\n    'CLAIM_TYPE': 'FICTIONAL CHARACTER ACTION',\n    'SOURCE': 'Phoenix authored fiction',\n    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou Story production record',\n    'CONFIDENCE': 'EXPLICIT FICTION',\n    'STORY_USE': 'human causal spine',\n    'DISCOVERY_USE': 'truth-boundary reminder only',\n    'INTERPRETATION_BOUNDARY': '不对应任何真实僧人、家庭、戒牒或寺院档案。',\n    'RESULT': 'PASS',\n  },\n  {\n    'CLAIM_ID': 'QZ-C7-west-street-location',\n    'CLAIM': '开元寺位于泉州西街中段北侧，寺院中轴包含甘露戒坛。',\n    'CLAIM_TYPE': 'VERIFIED FACT',\n    'SOURCE': '鲤城区人民政府 · 开元寺 + 泉州市人民政府 · 开元寺',\n    'SOURCE_LOCATION_OR_IDENTIFIER': 'licheng-government-kaiyuan-west-street ; quanzhou-government-kaiyuan-temple',\n    'CONFIDENCE': 'HIGH',\n    'STORY_USE': 'verified spatial anchor for the fictional same-West-Street walk to ordination',\n    'DISCOVERY_USE': 'Kaiyuan / West Street spatial relationship',\n    'INTERPRETATION_BOUNDARY': '只证明开元寺与西街、戒坛的真实空间关系；许安许宁旧宅设在西街是明确虚构，不对应真实住址。',\n    'RESULT': 'PASS',\n  },\n];",
)

replace_once(
    SOURCE,
    "  {'ITEM': '钥匙作为“冻结旧生活”的叙事载体', 'CLASSIFICATION': 'INTERPRETIVE STORY DEVICE', 'RESULT': 'PASS'},\n  {'ITEM': '桑树开白莲等建寺传说', 'CLASSIFICATION': 'LEGEND / FOLKLORE — STORY UNUSED', 'RESULT': 'PASS'},",
    "  {'ITEM': '钥匙作为“冻结旧生活”的叙事载体', 'CLASSIFICATION': 'INTERPRETIVE STORY DEVICE', 'RESULT': 'PASS'},\n  {'ITEM': '开元寺位于西街中段北侧', 'CLASSIFICATION': 'VERIFIED FACT', 'RESULT': 'PASS'},\n  {'ITEM': '许安、许宁的虚构旧宅也设在西街', 'CLASSIFICATION': 'FICTIONAL SPATIAL DEVICE', 'RESULT': 'PASS'},\n  {'ITEM': '桑树开白莲等建寺传说', 'CLASSIFICATION': 'LEGEND / FOLKLORE — STORY UNUSED', 'RESULT': 'PASS'},",
)

replace_once(
    SOURCE,
    "  'PLACE_PRESSURE': '戒坛让身份转变成为实际发生的仪式阈值',",
    "  'PLACE_PRESSURE': '开元寺位于西街；姐弟从虚构的同街旧宅走到甘露戒坛，受戒把“近在身边仍可照旧进门”的退路变成当天必须处理的关系选择',",
)
replace_once(
    SOURCE,
    "    'PLACE_PRESSURE': '戒坛把身份转变从计划变成仪式行动',",
    "    'PLACE_PRESSURE': '同一条西街把虚构旧宅与真实开元寺戒坛放在近距离生活空间里；受戒让他必须决定是否仍保留自动进入旧宅的权利',",
)
replace_once(
    SOURCE,
    "    'PLACE_SUBSTITUTION_RESULT': 'PASS — generic museum/monument/district cannot create ordination; generic temple lacks verified Kaiyuan platform/practice binding',",
    "    'PLACE_SUBSTITUTION_RESULT': 'PASS — replacing Kaiyuan with a generic ordination-capable temple loses the verified West-Street-to-Ganlu spatial hinge; preserving the same nearby-door cost would require inventing a new place relationship rather than changing nouns',",
)

replace_once(
    SOURCE,
    "const quanzhouPlaceCausalMechanism = <String, String>{\n  'VERIFIED_PLACE_PROPERTY': '开元寺甘露戒坛始建于1019年，古代戒坛用于僧侣受戒；民国初期开元寺等仍有开坛传戒活动。',\n  'SOURCE': '泉州市人民政府 · 开元寺 / 佛教',\n  'VERIFIED_CULTURAL_HISTORICAL_MECHANISM': '受戒是实际宗教实践；戒坛把身份变化落实为有地点、有时刻的仪式行动。',\n  'CHARACTER_ENCOUNTER': '虚构许安在开坛受戒当天由姐姐陪到甘露戒坛前。',\n  'PRESSURE_CREATED': '他无法继续把生活变化说成“以后再处理”，必须处理要求姐姐冻结旧宅空间的退路。',\n  'WHY_KAIYUAN_TEMPLE_MATTERS': 'Story 使用的是有权威史料支持的开元寺戒坛与传戒实践，不是佛寺外观。',\n  'WHY_QUANZHOU_MATTERS': '开元寺同时属于泉州海洋商贸遗产系统，Discovery 可解释宗教机构与城市网络的关系。',\n  'GOAL_EFFECT': '从抽象“想改变生活”变成当天要完成受戒与家庭安排。',\n  'RELATIONSHIP_EFFECT': '姐姐必须决定是否继续替弟弟维持旧生活不变；弟弟必须回应她承担的实际成本。',\n  'CONFLICT_EFFECT': '亲情延续与旧生活冻结被拆开。',\n  'CHOICE_EFFECT': '弟弟在仪式阈值前交出钥匙。',\n  'COST_EFFECT': '失去随时按旧方式回家的无条件入口。',\n  'CONSEQUENCE_EFFECT': '姐姐可以继续安排家庭空间；未来回来要先敲门。',\n  'GENERIC_PLACE_SUBSTITUTION': 'PASS — museum/monument/heritage district cannot enact ordination; unspecified temple does not preserve the verified Kaiyuan practice-and-platform specificity.',\n};",
    "const quanzhouPlaceCausalMechanism = <String, String>{\n  'CURRENT_GENERIC_MECHANISM': '受戒日把可以拖延的旧宅钥匙问题变成当天必须处理的决定。',\n  'WHY_IT_MIGRATES': '单独的受戒阈值可以迁移到另一座能够传戒的寺院。',\n  'VERIFIED_PLACE_PROPERTY': '开元寺位于泉州西街中段北侧；甘露戒坛位于寺院中轴，且民国初期开元寺等仍有开坛传戒活动。',\n  'SOURCE': '鲤城区人民政府 · 开元寺 / 泉州市人民政府 · 开元寺 / 佛教',\n  'VERIFIED_CULTURAL_HISTORICAL_MECHANISM': '开元寺真实的西街位置与受戒实践叠加：人物不因受戒远离旧家，近在同街的旧门仍可抵达，因此交钥匙必须改变的是自动进入权而不是旅行便利。',\n  'CHARACTER_ENCOUNTER': '虚构许安与许宁从同样虚构的西街旧宅沿街走到真实开元寺甘露戒坛前。',\n  'PRESSURE_CREATED': '旧宅并未因受戒变远；许安若继续握着钥匙，就仍能从同一条西街随时按旧方式进门。',\n  'WHY_KAIYUAN_TEMPLE_MATTERS': '开元寺的西街位置与甘露戒坛共同拥有行动：同一条街把近在身边的旧家庭入口与当天受戒阈值直接连在一起。',\n  'WHY_QUANZHOU_MATTERS': '西街是泉州古城真实街道，开元寺位于其上；宋元海洋商贸系统等更深历史仍留在 Discovery。',\n  'GOAL_EFFECT': '许安必须在受戒当天处理家庭退路，而且不能把改变归因于远行。',\n  'RELATIONSHIP_EFFECT': '许宁可以继续住在同一生活空间并欢迎弟弟，但不再替他保留无需请求的旧入口。',\n  'CONFLICT_EFFECT': '问题从“离开后还回不回来”变成“明明近在同街，亲情是否必须附带自动进入权”。',\n  'CHOICE_EFFECT': '许安在仍能轻易走回旧门的情况下把钥匙交给姐姐。',\n  'COST_EFFECT': '失去近在身边、原本随时可用的单方面旧宅进入权；以后回来必须先敲门。',\n  'CONSEQUENCE_EFFECT': '姐姐可以使用那间房；许安即使仍在同一条西街生活世界里，回家也改成请求式欢迎。',\n  'GENERIC_PLACE_SUBSTITUTION': 'PASS — another generic ordination-capable temple does not preserve the verified Kaiyuan-on-West-Street plus Ganlu-platform spatial hinge; keeping the same nearby-door Choice/Cost/Consequence would require a new verified place relationship, not a noun swap.',\n};",
)

replace_once(
    SOURCE,
    "  'SOURCE': 'official Kaiyuan ordination-platform history + official Republican-era ordination record',\n  'CHARACTER_ENCOUNTER': 'ordination-day threshold meets a deferred sibling-home conflict',\n  'ACTION_CAUSED': 'Xu An must stop postponing the household consequence and physically relinquish unchanged access',\n  'CONSTRAINT': 'the ritual makes the new life concrete now rather than hypothetical later',",
    "  'SOURCE': 'official Kaiyuan West Street location + ordination-platform history + official Republican-era ordination record',\n  'CHARACTER_ENCOUNTER': 'a same-West-Street old-home route reaches Kaiyuan ordination-day threshold without geographic departure',\n  'ACTION_CAUSED': 'Xu An must relinquish nearby automatic household access rather than explain the change as distance',\n  'CONSTRAINT': 'the ritual makes the new life concrete now while the old household door remains physically near',",
)
replace_once(
    SOURCE,
    "  'REMOVAL_TEST': 'without the verified ordination threshold, the same conversation can be postponed indefinitely and Goal-Conflict-Choice-Climax-Consequence lose their present causal pressure',",
    "  'REMOVAL_TEST': 'without Kaiyuan ordination plus the verified West Street spatial hinge, the Story either becomes deferrable or loses the specific cost of surrendering automatic access to a nearby old door',",
)

replace_once(
    SOURCE,
    "    chinese: '民国初年，泉州开元寺仍有开坛传戒的仪式。虚构青年许安要在这里受戒，姐姐许宁陪他走到甘露戒坛前。',\n    vietnamese: 'Vào đầu thời Dân Quốc, chùa Khai Nguyên ở Tuyền Châu vẫn có các nghi lễ mở giới đàn truyền giới. Chàng trai hư cấu Hứa An sắp thọ giới tại đây, và chị gái Hứa Ninh đi cùng anh tới trước Giới đàn Cam Lộ.',\n    english: 'In the early Republican period, Kaiyuan Temple in Quanzhou still held ordination ceremonies. The fictional young man Xu An is to receive ordination here, and his older sister Xu Ning walks with him to the Ganlu Ordination Platform.',",
    "    chinese: '民国初年，泉州开元寺仍有开坛传戒的仪式。虚构青年许安要在这里受戒。他和姐姐许宁住过的旧宅也在西街；受戒这天，许宁陪他沿街走到甘露戒坛前。',\n    vietnamese: 'Vào đầu thời Dân Quốc, chùa Khai Nguyên ở Tuyền Châu vẫn có các nghi lễ truyền giới. Nhân vật hư cấu Hứa An sắp thọ giới tại đây. Ngôi nhà cũ nơi anh và chị gái Hứa Ninh từng sống cũng ở trên phố Tây; ngày thọ giới, Hứa Ninh đi cùng anh dọc con phố tới trước Giới đàn Cam Lộ.',\n    english: 'In the early Republican period, Kaiyuan Temple in Quanzhou still held ordination ceremonies. The fictional Xu An is to receive ordination there. The old house where he and his older sister Xu Ning once lived is also on West Street; on ordination day, she walks with him along the street to the Ganlu Ordination Platform.',",
)
replace_once(
    SOURCE,
    "    chinese: '他早已对姐姐说过要换一种生活，却一直把“以后还能照旧回家”留作不肯碰的退路。',\n    vietnamese: 'Anh đã nói với chị từ lâu rằng mình muốn sống một đời khác, nhưng vẫn giữ ý nghĩ “sau này vẫn có thể về nhà như trước” như một lối lui không chịu chạm tới.',\n    english: 'He has long told his sister that he wants a different life, yet he keeps “being able to come home exactly as before” as a fallback he refuses to examine.',",
    "    chinese: '从旧宅到开元寺，他们一直沿着西街走。许安早已对姐姐说过要换一种生活，却没有去远方，也一直把“以后还能照旧回家”留作不肯碰的退路。',\n    vietnamese: 'Từ ngôi nhà cũ tới chùa Khai Nguyên, họ đi dọc phố Tây suốt quãng đường. Hứa An đã nói với chị từ lâu rằng mình muốn sống một đời khác, nhưng anh không đi tới nơi xa xôi và vẫn giữ ý nghĩ “sau này vẫn có thể về nhà như trước” như một lối lui không chịu chạm tới.',\n    english: 'From the old house to Kaiyuan Temple they walk along West Street the whole way. Xu An has long told his sister that he wants a different life, yet he is not going far away and still keeps “being able to come home exactly as before” as a fallback he refuses to examine.',",
)
replace_once(
    SOURCE,
    "  _QuanzhouStorySegment(\n    fromLevel: 3,\n    paragraph: 0,\n    chinese: '开元寺的戒坛始建于1019年；在古代，戒坛是僧人受戒的场所。站到这里，许安不能再把受戒只说成一个遥远打算。',\n    vietnamese: 'Giới đàn của chùa Khai Nguyên được dựng lần đầu vào năm 1019; trong lịch sử, giới đàn là nơi tăng nhân thọ giới. Đứng ở đây, Hứa An không còn có thể coi việc thọ giới chỉ là một dự định xa xôi.',\n    english: 'Kaiyuan Temple’s ordination platform was first established in 1019; historically, an ordination platform was a place where Buddhist monastics received precepts. Standing here, Xu An can no longer treat ordination as a distant plan.',\n  ),\n  _QuanzhouStorySegment(\n    fromLevel: 3,\n    paragraph: 0,\n    chinese: '泉州官方资料还记录，民国初年开元寺等寺院仍举行传戒度僧仪式。这个地点与今天的决定之间，有直接的制度联系。',\n    vietnamese: 'Tư liệu chính thức của Tuyền Châu còn ghi rằng vào đầu thời Dân Quốc, chùa Khai Nguyên và các chùa khác vẫn tổ chức nghi lễ truyền giới cho người xuất gia. Vì thế, nơi này có liên hệ trực tiếp với quyết định của ngày hôm nay.',\n    english: 'Official Quanzhou records also state that Kaiyuan and other temples still held monastic ordination ceremonies in the early Republican period. The place therefore has a direct institutional connection to today’s decision.',\n  ),",
    "  _QuanzhouStorySegment(\n    fromLevel: 3,\n    paragraph: 0,\n    chinese: '走到开元寺门前，许安回头看了看他们刚走过的西街。许宁问：“你又不是走得回不来，为什么还要我把房间一直空着？”这一次，他没有再说“以后再说”。',\n    vietnamese: 'Tới trước cổng chùa Khai Nguyên, Hứa An ngoái nhìn con phố Tây mà họ vừa đi qua. Hứa Ninh hỏi: “Em đâu có đi xa đến mức không về được, vậy tại sao vẫn muốn chị để căn phòng trống mãi?” Lần này, anh không nói “để sau hãy tính” nữa.',\n    english: 'At Kaiyuan Temple’s gate, Xu An looks back at the stretch of West Street they have just walked. Xu Ning asks, “You are not going somewhere you cannot come back from, so why do you still need me to keep the room empty?” This time, he does not say, “We’ll deal with it later.”',\n  ),",
)
replace_once(
    SOURCE,
    "    chinese: '甘露戒坛不是普通背景。受戒制度曾受官方管理；走到这里，许安不能再要求姐姐假装家里的关系什么都没有改变。',\n    vietnamese: 'Giới đàn Cam Lộ không chỉ là phông nền. Chế độ thọ giới từng chịu sự quản lý chính thức; tới đây, Hứa An không thể tiếp tục đòi chị mình giả vờ rằng quan hệ trong nhà chưa thay đổi gì.',\n    english: 'The Ganlu Ordination Platform is not mere scenery. Ordination was historically subject to official regulation; at this threshold, Xu An can no longer ask his sister to pretend that nothing in their household relationship has changed.',",
    "    chinese: '走到戒坛前时，许安忽然想起，旧宅并没有因为受戒就变远。那把钥匙也不是“暂时用不上”：只要握着它，他仍能从同一条西街上随时照旧进门。',\n    vietnamese: 'Khi tới trước giới đàn, Hứa An chợt nghĩ rằng ngôi nhà cũ không hề xa đi chỉ vì anh thọ giới. Chiếc chìa khóa cũng không phải là thứ “tạm thời không dùng đến”: chỉ cần còn cầm nó, anh vẫn có thể từ cùng con phố Tây bước vào nhà theo cách cũ bất cứ lúc nào.',\n    english: 'At the ordination platform, Xu An realizes that the old house has not become distant simply because he is being ordained. The key is not merely something he “won’t need for a while”: as long as he keeps it, he can still enter the old house from the same West Street exactly as before whenever he chooses.',",
)

replace_once(
    SOURCE,
    "    chinese: '开元寺是宋元泉州规模大、官方地位突出的佛教寺院。理解它不能只看寺院内部，还要看到它与海洋商贸城市的宗教、社会和交通网络共同存在。',\n    simple: '开元寺既是佛教寺院，也是宋元泉州城市网络中的重要组成。',\n    vietnamese: 'Khai Nguyên là một ngôi chùa Phật giáo quy mô lớn và có địa vị chính thức nổi bật ở Tuyền Châu thời Tống-Nguyên. Hiểu ngôi chùa không chỉ là nhìn vào bên trong chùa, mà còn phải thấy nó cùng tồn tại với các mạng lưới tôn giáo, xã hội và giao thông của đô thị thương mại hàng hải.',\n    english: 'Kaiyuan was a large Buddhist monastery of prominent official standing in Song-Yuan Quanzhou. Understanding it requires looking beyond the temple enclosure to its place alongside the religious, social, and transport networks of a maritime trading city.',",
    "    chinese: '开元寺位于泉州古城西街中段北侧。宋元时期，它也是泉州规模大、官方地位突出的佛教寺院。理解它不能只看寺院内部，还要看到它与海洋商贸城市的宗教、社会和交通网络共同存在。',\n    simple: '开元寺位于西街，也是宋元泉州城市网络中的重要佛教寺院。',\n    vietnamese: 'Chùa Khai Nguyên nằm ở phía bắc đoạn giữa phố Tây trong thành cổ Tuyền Châu. Vào thời Tống-Nguyên, đây cũng là một ngôi chùa Phật giáo quy mô lớn và có địa vị chính thức nổi bật. Hiểu ngôi chùa không chỉ là nhìn vào bên trong chùa, mà còn phải thấy nó cùng tồn tại với các mạng lưới tôn giáo, xã hội và giao thông của đô thị thương mại hàng hải.',\n    english: 'Kaiyuan Temple stands on the north side of the middle section of West Street in Quanzhou’s historic city. In the Song-Yuan period it was also a large Buddhist monastery of prominent official standing. Understanding it requires looking beyond the temple enclosure to its place alongside the religious, social, and transport networks of a maritime trading city.',",
)

replace_once(
    SOURCE,
    "    wonderQuestion: '许安为什么必须在走向戒坛前处理那把钥匙？',\n    expressQuestion: '开元寺的受戒实践怎样把姐弟之间可以拖延的问题变成当天必须完成的选择？',",
    "    wonderQuestion: '许安为什么在同一条西街上走向戒坛前，反而要交出旧宅钥匙？',\n    expressQuestion: '开元寺的受戒实践和西街近在身边的旧宅，怎样一起改变“以后回来”的意义？',",
)

replace_once(
    SOURCE,
    "    RemediatedMemoryReview(category: 'place', prompt: '为什么这个决定在开元寺戒坛前特别有压力？', answer: '开元寺有真实的受戒制度与戒坛历史；传戒当天把生活变化变成必须面对的现实行动。', storyEventIds: ['QZ-E1', 'QZ-E2']),",
    "    RemediatedMemoryReview(category: 'place', prompt: '为什么这个决定在开元寺戒坛前特别有压力？', answer: '开元寺真实位于西街，传戒当天许安从虚构的同街旧宅走到戒坛；旧门仍近在身边，所以交钥匙改变的是自动进入权，而不是远行造成的不便。', storyEventIds: ['QZ-E1', 'QZ-E2']),",
)
replace_once(
    SOURCE,
    "    journeyCompletion: '开元寺不是旅游背景：戒坛让人物的生活变化在这里成为必须完成的行动，而海洋商贸与多元文化深度留在 Discovery 中解释。',",
    "    journeyCompletion: '开元寺的戒坛把受戒变成当天行动；西街上的旧宅仍近在身边，所以许安交出的不是一段远行的便利，而是照旧自动进门的权利。',",
)
replace_once(
    SOURCE,
    "    RemediatedSourceBinding(id: 'quanzhou-religion-kaiyuan', publisher: '泉州市民族与宗教事务局', scope: 'Kaiyuan ordination-platform chronology and religious-site corroboration'),\n  ],",
    "    RemediatedSourceBinding(id: 'quanzhou-religion-kaiyuan', publisher: '泉州市民族与宗教事务局', scope: 'Kaiyuan ordination-platform chronology and religious-site corroboration'),\n    RemediatedSourceBinding(id: 'licheng-government-kaiyuan-west-street', publisher: '鲤城区人民政府', scope: 'Kaiyuan location on West Street and central-axis place relationship'),\n  ],",
)
replace_once(
    SOURCE,
    "        sourceIds: const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history', 'quanzhou-religion-kaiyuan'],",
    "        sourceIds: const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history', 'quanzhou-religion-kaiyuan', 'licheng-government-kaiyuan-west-street'],",
)
replace_once(
    SOURCE,
    "  'FICTIONAL_FAMILY_MISREPRESENTED_AS_ARCHIVE': 'NONE',",
    "  'FICTIONAL_FAMILY_MISREPRESENTED_AS_ARCHIVE': 'NONE',\n  'FICTIONAL_WEST_STREET_HOUSE_MISREPRESENTED_AS_FACT': 'NONE — only Kaiyuan/West Street location is verified; the Xu household placement is explicit fiction',",
)

replace_once(
    DNA,
    "  locationMechanism: 'verified-Kaiyuan-ordination-platform-and-Republican-ordination-practice-make-vocation-change-enacted-here',\n  movementPattern: 'household-key-in-brothers-hand-to-sisters-hand-to-ordination-platform',",
    "  locationMechanism: 'verified-Kaiyuan-on-West-Street-plus-Ganlu-ordination-practice-keeps-old-home-near-while-vocation-change-is-enacted',\n  movementPattern: 'fictional-West-Street-old-home-to-Kaiyuan-gate-to-key-transfer-to-Ganlu-ordination-platform',",
)
replace_once(
    DNA,
    "  historicalLearningMechanism: 'verified-ordination-practice-causes-Story-threshold-while-Song-Yuan-maritime-and-material-history-remain-in-Discovery',",
    "  historicalLearningMechanism: 'verified-Kaiyuan-West-Street-location-and-ordination-practice jointly cause the Story hinge while chronology, Song-Yuan maritime and material history remain in Discovery',",
)
replace_once(
    DNA,
    "  storyRhythm: 'ordination-arrival-fallback-request-sister-boundary-key-transfer-cost-sister-welcome-walk-empty-waist',",
    "  storyRhythm: 'same-street-walk-Kaiyuan-arrival-fallback-request-sister-boundary-key-transfer-nearby-access-cost-sister-welcome-walk-empty-waist',",
)

replace_once(
    SEMANTIC,
    "  surfaceIdentity: 'Xu An / Xu Ning / Kaiyuan ordination threshold / returned household key / knock-before-opening',",
    "  surfaceIdentity: 'Xu An / Xu Ning / Kaiyuan-on-West-Street ordination threshold / nearby household key / knock-before-opening',",
)

replace_once(
    TEST,
    "      expect(story, contains('受戒'), reason: 'Lv$level place/ritual anchor');\n      expect(story, contains('钥匙'), reason: 'Lv$level enacted choice object');",
    "      expect(story, contains('受戒'), reason: 'Lv$level place/ritual anchor');\n      expect(story, contains('西街'), reason: 'Lv$level Kaiyuan-specific spatial hinge');\n      expect(story, contains('钥匙'), reason: 'Lv$level enacted choice object');",
)
replace_once(
    TEST,
    "      expect(story, isNot(contains('离开寺院时，你会发现')));",
    "      expect(story, isNot(contains('离开寺院时，你会发现')));\n      expect(story, isNot(contains('戒坛始建于1019年')), reason: 'Lv$level history explanation belongs in Discovery');\n      expect(story, isNot(contains('官方资料还记录')), reason: 'Lv$level source commentary belongs in Discovery');",
)
replace_once(
    TEST,
    "  test('Quanzhou adjacent levels deepen one locked Story and Lv10 keeps action ending', () {",
    "  test('Quanzhou repaired Story keeps Kaiyuan place causality without exposition leakage', () {\n    final lv1 = resolveAdaptiveJourneyLevel(\n      quanzhou,\n      profile: agent.profileForPhoenixLevel(1),\n    );\n    final lv5 = resolveAdaptiveJourneyLevel(\n      quanzhou,\n      profile: agent.profileForPhoenixLevel(5),\n    );\n    expect(lv1.storyParagraphs.join(), contains('旧宅也在西街'));\n    expect(lv1.storyParagraphs.join(), contains('沿街走到甘露戒坛前'));\n    expect(lv5.storyParagraphs.join(), contains('你又不是走得回不来'));\n    expect(lv5.storyParagraphs.join(), isNot(contains('1019年')));\n    expect(lv5.storyParagraphs.join(), isNot(contains('官方资料')));\n    expect(lv5.discoveries.any((item) => item.text.contains('1019年')), isTrue);\n    expect(lv5.discoveries.any((item) => item.text.contains('西街中段北侧')), isTrue);\n  });\n\n  test('Quanzhou adjacent levels deepen one locked Story and Lv10 keeps action ending', () {",
)
replace_once(
    TEST,
    "    expect(quanzhouSourceLedger, hasLength(4));",
    "    expect(quanzhouSourceLedger, hasLength(5));",
)
replace_once(
    TEST,
    "    expect(quanzhouPlaceCausalMechanism['GENERIC_PLACE_SUBSTITUTION'], startsWith('PASS'));",
    "    expect(quanzhouPlaceCausalMechanism['GENERIC_PLACE_SUBSTITUTION'], startsWith('PASS'));\n    expect(quanzhouPlaceCausalMechanism['VERIFIED_PLACE_PROPERTY'], contains('西街'));\n    expect(quanzhouFactFictionLedger.any((item) => item['ITEM'] == '许安、许宁的虚构旧宅也设在西街'), isTrue);",
)

print('Quanzhou Founder repair patch prepared successfully.')
