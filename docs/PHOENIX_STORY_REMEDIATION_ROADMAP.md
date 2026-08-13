# Phoenix Horizontal Gold Audit / Remediation Matrix

**Status:** CURRENT-RUNTIME GOVERNANCE AUDIT

**Baseline:** main after Founder-approved Summer Palace PR #176

**Baseline SHA:** `38b798c314b819792b6a827e9b9c672efcdb8946`

**Scope:** current nine Founder-approved Gold Journeys

**Authority:** audit and sequencing only; this document authorizes no Journey rewrite

This audit reads the active runtime resolver and binding before it judges a Story. Historical candidates, legacy constants, old PR bodies, and inactive packages are archive evidence only. `FILE EXISTS != ACTIVE PRODUCT`.

## Active Story identity proof

No Journey may receive `PASS`, `LIGHT REFINE`, or `REMEDIATION REQUIRED` until its active identity is verified.

| Journey ID | Active Story | Active runtime source / resolver | Protagonist + relationship | Goal | Conflict | Choice | Cost | Memory Moment | Ending identity | Active identity verified |
|---|---|---|---|---|---|---|---|---|---|---|
| `beijing-summer-palace` | 《留下痕迹的风景》 | `summer_palace_journey.dart` / Summer Palace adaptive resolver | 许澄 + 外婆周岚 | 为校展拍到十七孔桥季节金光 | 最佳光线与坠落旧照片同时出现 | 放下快门，先捡旧照片 | 等了一下午的金光消失 | 新构图中的桥洞、旧照片与外婆 | 记录时节、位置与照片来源，接受有痕迹的真实 | PASS |
| `beijing-forbidden-city` | 《两条路，一张图》 | `daily_journey_catalog.dart` / active daily experience | 沈砚 + 阿宁 | 保留两条都成立的路线 | 单一路线会抹去另一人的观看 | 在一张图上叠加两条线 | 放弃唯一、整齐的答案 | 两条路线和共同节点留在同一张图 | 两人走向不同出口，两条线都被保留 | PASS |
| `shanghai-bund` | 《旧提单过江》 | `daily_journey_catalog.dart` / active daily experience | 林岸 + 母亲 | 把旧提单带过江 | 文件、城市变化与家庭记忆互相拉扯 | 带着旧提单完成渡江 | 必须承担文件与记忆的重量 | 抵达对岸时仍在手中的旧提单 | 人和文件一起抵达对岸 | PASS |
| `xian-city-wall` | 《没有按停的一圈》 | `daily_journey_catalog.dart` / active daily experience | 周遥 + 家人 | 在搬家前完成城墙一圈 | 结束一圈也意味着承认离开 | 跑完后不按停跑表 | 放弃一个封闭、漂亮的终点 | 永宁门后仍在走的跑表 | 一圈结束，但时间继续向新家走 | PASS |
| `hangzhou-west-lake` | 《还认得这条路》 | `hangzhou_west_lake_one_pass.dart` / `hangzhouWestLakeReopenedLevels` | 方毓 + 周绍庭 | 判断父亲是否还认得旧路 | 记忆测试伤害尊严，身体又需要照顾 | 停止追问并交出就诊卡 | 放弃得到确定答案 | 湿石阶上扶住手肘的手 | 两人走向医院公交站，关系从测试转为陪伴 | PASS |
| `chengdu-kuanzhai-alley` | 《一把没有固定位置的竹椅》 | `chengdu_kuanzhai_one_pass.dart` / `chengduKuanzhaiOnePassLevels` | 林夏 + 周叔 | 决定竹椅该留下给谁 | 私人记忆与街巷共享使用冲突 | 把椅子留在可继续被使用的位置 | 放弃独占纪念物 | 同一把不断转手的竹椅 | 椅子继续服务街巷，关系通过交接延续 | PASS |
| `nanjing-qinhuai-river` | 《亮灯以后留下的暗段》 | `nanjing_qinhuai_one_pass.dart` / active locked levels | 魏舟 + 周工 | 在亮灯前完成安全确认 | 时间压力要求接上未经确认的线路 | 拒绝冒险接线 | 一段装饰灯在亮灯后仍黑着 | 亮灯以后留下的暗段 | 暗段被保留为负责判断的可见结果 | PASS |
| `guangzhou-chen-clan-academy` | 《不入镜》 | `guangzhou_chen_clan_one_pass.dart` / `guangzhouChenClanOnePassLevels → _guangzhouLockedLevel(...)` | 陈秀仪 + 刘嘉禾（阔别三十四年的同伴） | 在陈家祠重逢并决定如何留下这一刻 | 合影冲动与对方不愿被拍的边界冲突 | 把手机扣在匾额下的青砖上，说“今天不入镜” | 失去三十四年后重逢的合照 | 匾额下被扣在青砖上的手机 | 两人不靠合影证明重逢，继续并肩走入下一进院落 | PASS |
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
| `nanjing-qinhuai-river` | 《亮灯以后留下的暗段》 | PASS | PASS | PASS | PASS | REVIEW | REVIEW | REVIEW | PASS | PASS | **LIGHT REFINE** | Responsible refusal under place/time pressure remains Gold; absent new evidence is not Story failure. |
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
