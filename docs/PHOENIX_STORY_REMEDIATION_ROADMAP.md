# Phoenix Horizontal Gold Audit / Remediation Matrix

**Status:** CURRENT-RUNTIME GOVERNANCE AUDIT

**Baseline:** main after Founder-approved Summer Palace PR #176

**Baseline SHA:** `38b798c314b819792b6a827e9b9c672efcdb8946`

**Scope:** current nine Founder-approved Gold Journeys

**Authority:** audit and sequencing only; this document authorizes no Journey rewrite

This audit reads the active runtime resolver and binding before it judges a Story. Historical candidates, legacy constants, old PR bodies, and inactive packages are archive evidence only. `FILE EXISTS != ACTIVE PRODUCT`.

`STORY TITLE`, `HEADLINE`, `DESCRIPTION`, and `MEMORY ANCHOR` are four distinct fields. Active identity proof verifies each from its current runtime or canonical metadata authority; none may be inferred from another because its wording is more memorable.

## Active Story identity proof

No Journey may receive `PASS`, `LIGHT REFINE`, or `REMEDIATION REQUIRED` until its active identity is verified.

| Journey ID | Active Story | Active runtime source / resolver | Protagonist + relationship | Goal | Conflict | Choice | Cost | Memory Moment | Ending identity | Active identity verified |
|---|---|---|---|---|---|---|---|---|---|---|
| `beijing-summer-palace` | 《留下痕迹的风景》 | `summer_palace_journey.dart` / Summer Palace adaptive resolver | 许澄 + 外婆周岚 | 为校展拍到十七孔桥季节金光 | 最佳光线与坠落旧照片同时出现 | 放下快门，先捡旧照片 | 等了一下午的金光消失 | 新构图中的桥洞、旧照片与外婆 | 记录时节、位置与照片来源，接受有痕迹的真实 | PASS |
| `beijing-forbidden-city` | 《两条路，一张图》 | `daily_journey_catalog.dart` + `forbidden_city_journey_runtime.dart` / `forbiddenCityLevelContent(...)` | 营造学徒沈砚 ↔ 年幼侍役阿宁（跨角色同伴） | 练习把“建筑怎样组织人的移动”画成一张可读的宫城学习图；最初认为一张好图应只有一条明确主线 | 沈砚的唯一主线假设遇到阿宁另一条同样真实、同样到达共同节点的路线 | 不选一条覆盖另一条，把两条路线叠在同一张图上并用不同线型保留 | 放弃唯一、整齐、单一标准答案带来的确定性 | 一张叠着两条路线的图 | 沈砚与阿宁从共享节点走向各自方向，纸上两条路线都未被擦掉 | PASS |
| `shanghai-bund` | 《旧提单过江》 | `daily_journey_catalog.dart` + `shanghai_bund_one_pass.dart` / `shanghaiBundOnePassLevels` + `shanghaiBundOnePassRemediation` | 林岸 ↔ 母亲（母子） | 在离开家庭旧行业、开始陆家嘴新职业的同一晚，完成一次真实的黄浦江跨越 | 他把过江理解成切断外滩与家庭经济来路，但旧海运提单迫使他决定是否必须丢掉一岸，才能走向另一岸 | 临上轮渡前把旧提单放进电脑包，带着它上船，同时继续选择陆家嘴的新职业 | identity / certainty cost：放弃“必须否定并丢下旧的一岸，才能证明走向新职业”的干净切割 | 旧提单进入电脑包并随轮渡过江 | 林岸仍走向陆家嘴的新工作；回望时外滩不再是必须删除的过去 | PASS |
| `xian-city-wall` | 《没有按停的一圈》 | `daily_journey_catalog.dart` / active daily experience | 周遥 + 家人 | 在搬家前完成城墙一圈 | 结束一圈也意味着承认离开 | 跑完后不按停跑表 | 放弃一个封闭、漂亮的终点 | 永宁门后仍在走的跑表 | 一圈结束，但时间继续向新家走 | PASS |
| `hangzhou-west-lake` | 《还认得这条路》 | `hangzhou_west_lake_one_pass.dart` / `hangzhouWestLakeReopenedLevels` + `hangzhouWestLakeReopenedRemediation` | 方毓 ↔ 结婚四十三年的丈夫周绍庭（夫妻） | 确认结婚四十三年的丈夫还记得多少，同时回避直接谈论记忆门诊。 | 她越用西湖景名测试丈夫，两个人越无法说出共同面对的害怕 | 停止测试并公开交出记忆门诊预约卡 | 放弃从正确答案取得确定性，夫妻必须共同面对记忆衰退 | 湿石阶上扶住手肘的那只手 | 周绍庭把预约卡放进自己钱包，主动询问去医院哪一站下 | PASS |
| `chengdu-kuanzhai-alley` | 《一把没有固定位置的竹椅》 | `chengdu_kuanzhai_one_pass.dart` / `chengduKuanzhaiOnePassLevels` + `chengduKuanzhaiOnePassRemediation` | 茶馆院落接待员林夏 ↔ 常来的年长茶客周叔（共同使用者） | 让宽窄巷子院落茶馆同时保持茶客停留与入口通行，而不永久排除任何一种合理使用。 | 有限院落入口无法靠一个固定座位布局持续满足随时间变化的茶座、服务与通行需求。 | 不再寻找永远正确的位置；谁先看见通行就先移椅，通道清空后再把椅子交还茶桌 | 放弃固定布局的确定性，也放弃由林夏一人持续维持秩序的控制 | 林夏还没起身，周叔已移开竹椅；人通过后，他又把椅子放回茶桌旁 | 周叔独立复现 handoff，林夏没有再介入；最终另一位使用者也接续同一动作 | PASS |
| `nanjing-qinhuai-river` | 《亮灯前七分钟》 | `nanjing_qinhuai_one_pass.dart` / `nanjingQinhuaiCanonicalTitle` + `nanjingQinhuaiOnePassLevels` | 灯光技术员魏舟 ↔ 周工（师徒工作关系） | 在秦淮灯会开场前恢复安全、可用的沿河照明路线 | 完整视觉效果与已确认、安全、遗产敏感的运行安排冲突 | 拒绝未经确认的临时改线，主动牺牲装饰效果 | 路线开放，但一段装饰灯继续黑着 | 亮灯以后仍然黑着的那一段装饰灯 | 周工把最终灯光状态记录交给魏舟填写和汇报 | PASS |
| `guangzhou-chen-clan-academy` | 《不入镜》 | `guangzhou_chen_clan_one_pass.dart` / `guangzhouChenClanOnePassLevels → _guangzhouLockedLevel(...)` + `guangzhouChenClanRemediatedJourney` | 陈秀仪 ↔ 成年亲生女儿刘嘉禾（亲生母女；刘嘉禾三十四年前由亲戚收养） | 与成年亲生女儿刘嘉禾继续来往，同时面对亲戚要求公开认回的压力。 | 陈秀仪渴望迟到三十四年的合照，但刘嘉禾拒绝被陈家亲戚公开“认回来” | 把手机扣在匾额下的青砖上，说“她叫刘嘉禾。今天不入镜” | 失去三十四年后重逢的合照 | 匾额下被扣在青砖上的手机 | 刘嘉禾在门槛前放慢一步，两人并肩走入下一进院落 | PASS |
| `suzhou-humble-administrators-garden` | 《下一处等我》 | `journey_expansion_catalog.dart` / `_suzhouAdaptiveStory(...)` + active Suzhou experience | 外婆陈玉兰 ↔ 十二岁外孙程朗（祖孙） | 在程朗即将开始独立通勤前，练习让他走在前面，并逐渐不再因暂时看不见他就把他叫回来 | 长廊、曲桥和屋角反复切断视线，使“立刻叫回孩子”与“必须开始放手”直接冲突 | 第二次看不见程朗时，陈玉兰抬起手，名字已到嘴边，却没有喊 | 承担短暂看不见孩子、无法立即控制距离的不安 | 抬起却没有呼喊的手 | 程朗转过去，背影很快又被房屋挡住；陈玉兰没有追上去 | PASS |

`guangzhouChenClanLegacyPaperBridgeLevels` is explicitly inactive and is not current runtime authority. 梁遥、贺真、纸桥、prototype、maker / material reencoding must never be used as current Guangzhou failure evidence.

## Horizontal Gold audit matrix

`REVIEW` means the new Journey-specific evidence has not yet been produced. It is not a Gold blocker and does not authorize rewriting an approved Story.

| Journey | Active Story | Active Identity Verified | Story × Culture | Place Causality | Cultural Residue | Discovery Depth | Level Semantic Delta | Lv10 Mastery | Multilingual | Visible QA Language | Classification | Evidence Summary |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `beijing-summer-palace` | 《留下痕迹的风景》 | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | **PASS** | Founder-experienced exact-head Pilot proves the complete canonical model. |
| `beijing-forbidden-city` | 《两条路，一张图》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Current active two-route decision is distinct and place-causal; new Level/Discovery gates need isolated evidence. |
| `shanghai-bund` | 《旧提单过江》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Active crossing and carried-document continuity remain Gold; formal adjacent-Level evidence is pending. |
| `xian-city-wall` | 《没有按停的一圈》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | The active circuit and un-stopped watch are place-causal; new cognitive-depth evidence is pending. |
| `hangzhou-west-lake` | 《还认得这条路》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Current embodied-recognition Story supersedes the old soundscape Story; audit only current levels. |
| `chengdu-kuanzhai-alley` | 《一把没有固定位置的竹椅》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Shared-use handoff is relationship- and place-causal; formal depth evidence remains future work. |
| `nanjing-qinhuai-river` | 《亮灯前七分钟》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Canonical title and the separate dark-segment Memory Anchor are both verified; responsible refusal remains Gold. |
| `guangzhou-chen-clan-academy` | 《不入镜》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Current evidence is 陈秀仪、刘嘉禾、手机与“不入镜”; legacy Paper Bridge architecture is excluded. New Level/Discovery proof needs an isolated audit. |
| `suzhou-humble-administrators-garden` | 《下一处等我》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Current approved Gold Story supersedes the former candidate-rewrite conclusion; new depth evidence is pending. |

## Remediation governance

1. Never modify Journeys in this standards PR.
2. Select one Journey only after explicit Founder authorization.
3. Re-read current active runtime, resolver, and binding; never revive a legacy Story audit.
4. Classify findings `MUST FIX`, `SHOULD FIX`, or `LATER`.
5. Preserve exact-head Preview and Founder authority.
6. Freeze a Gold result when required gates pass; no endless polish loop.

## Recommended next Journey

**FURTHER ISOLATED AUDIT REQUIRED.** No current Story-level blocker is proven. Before selecting a Journey, compare the active runtime evidence for Place Causality, Story × Culture, Level Gradient, unfinished work, and implementation risk. This is not authorization to begin work and does not revive any historical branch or PR.
