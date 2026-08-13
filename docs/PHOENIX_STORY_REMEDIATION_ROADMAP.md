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
| `beijing-forbidden-city` | 《两条路，一张图》 | `daily_journey_catalog.dart` / active daily experience | 沈砚 + 阿宁 | 保留两条都成立的路线 | 单一路线会抹去另一人的观看 | 在一张图上叠加两条线 | 放弃唯一、整齐的答案 | 两条路线和共同节点留在同一张图 | 两人走向不同出口，两条线都被保留 | PASS |
| `shanghai-bund` | 《旧提单过江》 | `daily_journey_catalog.dart` / active daily experience | 林岸 + 母亲 | 把旧提单带过江 | 文件、城市变化与家庭记忆互相拉扯 | 带着旧提单完成渡江 | 必须承担文件与记忆的重量 | 抵达对岸时仍在手中的旧提单 | 人和文件一起抵达对岸 | PASS |
| `xian-city-wall` | 《没有按停的一圈》 | `daily_journey_catalog.dart` / active daily experience | 周遥 + 家人 | 在搬家前完成城墙一圈 | 结束一圈也意味着承认离开 | 跑完后不按停跑表 | 放弃一个封闭、漂亮的终点 | 永宁门后仍在走的跑表 | 一圈结束，但时间继续向新家走 | PASS |
| `hangzhou-west-lake` | 《还认得这条路》 | `hangzhou_west_lake_one_pass.dart` / `hangzhouWestLakeReopenedLevels` + `hangzhouWestLakeReopenedRemediation` | 方毓 ↔ 结婚四十三年的丈夫周绍庭（夫妻） | 确认结婚四十三年的丈夫还记得多少，同时回避直接谈论记忆门诊。 | 她越用西湖景名测试丈夫，两个人越无法说出共同面对的害怕 | 停止测试并公开交出记忆门诊预约卡 | 放弃从正确答案取得确定性，夫妻必须共同面对记忆衰退 | 湿石阶上扶住手肘的那只手 | 周绍庭把预约卡放进自己钱包，主动询问去医院哪一站下 | PASS |
| `chengdu-kuanzhai-alley` | 《一把没有固定位置的竹椅》 | `chengdu_kuanzhai_one_pass.dart` / `chengduKuanzhaiOnePassLevels` | 林夏 + 周叔 | 决定竹椅该留下给谁 | 私人记忆与街巷共享使用冲突 | 把椅子留在可继续被使用的位置 | 放弃独占纪念物 | 同一把不断转手的竹椅 | 椅子继续服务街巷，关系通过交接延续 | PASS |
| `nanjing-qinhuai-river` | 《亮灯前七分钟》 | `nanjing_qinhuai_one_pass.dart` / `nanjingQinhuaiCanonicalTitle` + `nanjingQinhuaiOnePassLevels` | 灯光技术员魏舟 ↔ 周工（师徒工作关系） | 在秦淮灯会开场前恢复安全、可用的沿河照明路线 | 完整视觉效果与已确认、安全、遗产敏感的运行安排冲突 | 拒绝未经确认的临时改线，主动牺牲装饰效果 | 路线开放，但一段装饰灯继续黑着 | 亮灯以后仍然黑着的那一段装饰灯 | 周工把最终灯光状态记录交给魏舟填写和汇报 | PASS |
| `guangzhou-chen-clan-academy` | 《不入镜》 | `guangzhou_chen_clan_one_pass.dart` / `guangzhouChenClanOnePassLevels → _guangzhouLockedLevel(...)` + `guangzhouChenClanRemediatedJourney` | 陈秀仪 ↔ 成年亲生女儿刘嘉禾（亲生母女；刘嘉禾三十四年前由亲戚收养） | 与成年亲生女儿刘嘉禾继续来往，同时面对亲戚要求公开认回的压力。 | 陈秀仪渴望迟到三十四年的合照，但刘嘉禾拒绝被陈家亲戚公开“认回来” | 把手机扣在匾额下的青砖上，说“她叫刘嘉禾。今天不入镜” | 失去三十四年后重逢的合照 | 匾额下被扣在青砖上的手机 | 刘嘉禾在门槛前放慢一步，两人并肩走入下一进院落 | PASS |
| `suzhou-humble-administrators-garden` | 《下一处等我》 | `journey_expansion_catalog.dart` / active Suzhou experience | 陈玉兰 + 程朗（祖孙） | 在园中确认孩子仍会回望与等待 | 放手让孩子前行与想叫住他的冲动冲突 | 奶奶抬手后没有呼喊 | 承担短暂失去控制与距离 | 抬起又放下的手、孩子回头再出现 | 孩子在下一处等她，关系从牵住转为信任 | PASS |

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
