# Phoenix Story Production Pipeline

Documentation Status: Reconstructed and Reviewed
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Story Production Process)
Owner: Phoenix Story System

---

# 1. Purpose

Phoenix Story Production Pipeline（简称 Story Pipeline）定义每篇 Phoenix Story 从需求进入正式发布的完整生产流程。

本文件将 Story Constitution 与 Story Philosophy 转化为可执行阶段，并为每个阶段明确：

- 输入。
- 动作。
- 输出。
- Gate。
- 失败回退路径。

本 Pipeline 适用于：

- 新普通 Journey。
- 新特别 Journey。
- 现有 Story 重写。
- Canonical Story 变更。
- Phoenix Lv.1–10 适配。
- Story、Vocabulary、Discovery、Challenge 与 Memory 的联动更新。
- 当前发布目录中的单篇与批量 Story 生产。

本 Pipeline 不负责：

- 改写 `STORY_CONSTITUTION.md` 或 `STORY_PHILOSOPHY.md`。
- 替代未来独立的 `STORY_QUALITY_GATE.md`、`STORY_CHECKLIST.md` 或 `STORY_REVIEW_PROMPT.md`。
- 定义 Visual、Learning、UI、Audio、Code、QA 或 Release System 的内部实现。
- 将 AI Output、测试结果、Preview 或代码存在视为自动发布许可。
- 声称当前仓库中所有 Story 已经执行本 Pipeline。

任何适用阶段或强制 Gate 未完成，Story 不得进入正式版。

---

# 2. Authority and Reading Order

执行本 Pipeline 前必须按以下顺序读取真实存在且适用的规范：

1. 当前用户明确指令与任务边界。
2. 安全、法律、版权、隐私与平台限制。
3. Phoenix Core Product Principles。
4. `docs/systems/README.md`。
5. `SYSTEM_ARCHITECTURE.md`。
6. `SYSTEM_DEPENDENCY.md`。
7. `SYSTEM_LIFECYCLE.md`。
8. `SYSTEM_PRIORITY.md`。
9. `docs/story/README.md`。
10. `STORY_CONSTITUTION.md`。
11. `STORY_PHILOSOPHY.md`。
12. 真实存在且适用的 Story Guidelines 与 Ordinary/Special Guidelines。
13. 本 Story Pipeline。
14. 真实存在且适用的 Story Quality Gate、Checklist 与 Review Prompt。
15. 对应 Learning、Visual、Audio、UI、Accessibility、QA 与 Release 规范。
16. 目标 Journey 数据、Source、代码、测试、Branch、Commit、Preview 与 Release Evidence。

发生冲突时依照 `docs/systems/SYSTEM_PRIORITY.md` 处理。

缺失高优先级规范不得由本 Pipeline、代码或 AI 猜测补充。

---

# 3. Pipeline Overview

Phoenix Story Production 的固定顺序为：

```text
需求与 Journey 定位
→ 故事库重复检查
→ 城市、文化或原典研究
→ 学习目标确认
→ 主角与角色设计
→ 目标、冲突与关键选择设计
→ 情绪曲线设计
→ 场景与结构设计
→ 初稿
→ 文学编辑
→ 语言难度与 HSK/TOCFL 适配
→ 生词、发现、挑战和回忆衔接
→ Story Quality Gate
→ Story Checklist
→ Story Review
→ 页面级 QA
→ 正式发布
```

Pipeline 是顺序依赖。

后续阶段可以向上游提供反馈，但不得反向成为上游权威。

例如：

- Visual 可以报告 Scene 不可表达，但不能改变 Story Meaning。
- Learning 可以报告某 Level 不可理解，但不能改写核心冲突。
- Audio 可以报告朗读不自然，但不能维护另一份正文。
- UI 可以报告长度风险，但不能删除必要情节。
- QA 可以证明失败，但不能创造 Story 规则。
- Release 可以拒绝不完整 Candidate，但不能降低 Gate。

---

# 4. Roles

每个 Story Candidate 必须明确以下责任角色；同一人可在低风险范围承担多个角色，但批准权与生成权必须保持可审查：

| Role | Primary responsibility |
| --- | --- |
| Product / Journey Owner | 需求、Journey 定位、范围与最终产品目标 |
| Story Owner | Canonical Meaning、Story Direction 与阶段状态 |
| Content Researcher | 来源、事实、文化、原典与权利证据 |
| Story Architect | 主角、目标、冲突、选择、情绪与结构 |
| Story Writer | 初稿与经批准的重写 |
| Literary Editor | 文学性、自然中文、节奏、留白与 AI 痕迹 |
| Learning Owner | Phoenix Level、学习目标与衔接 Contract |
| Language Reviewer | 中文、拼音、翻译、朗读与 Level 表达 |
| Cultural / Source Reviewer | 事实、地方文化、原典、改编与敏感内容 |
| AI Review | 辅助发现重复、结构、语言与一致性问题 |
| QA Owner | 自动、人工、页面、设备与回归证据 |
| Release Owner | 候选版本、授权、交付与 Release Evidence |

AI 可以生成 Candidate 与 Findings。

AI 不得独立批准自己刚生成的 Story。

---

# 5. Required Story Record

Pipeline 从 Stage 1 开始建立并持续更新 Story Record。

Story Record 至少包含：

- Journey ID。
- Story ID。
- Story Version。
- Candidate ID。
- Branch 与目标 Commit。
- Ordinary 或 Special 类型。
- Genre。
- Owner 与 Reviewer。
- 当前 Stage。
- 当前状态：Draft、In Review、Needs Revision、Blocked、Approved Candidate、Released 或 Deprecated。
- Source IDs 与 Source Status。
- Canonical Meaning。
- Phoenix Level 范围。
- Consumer Impact。
- Gate Results。
- Failure History 与 Return Stage。
- Approval Evidence。

没有稳定 ID、Version、Owner 与状态的内容，不得在阶段之间流转。

---

# 6. Gate Result Model

每个阶段 Gate 只能输出：

- `PASS`：全部强制条件满足，可进入下一阶段。
- `NEEDS_REVISION`：存在可修正缺陷，必须返回指定上游阶段。
- `BLOCKED`：关键输入、授权、安全、法律、版权、文化真实性或系统依赖缺失，禁止继续。
- `NOT_APPLICABLE`：仅用于明确不适用的条件项，必须记录理由；不能用于整个强制阶段。

每个 Gate Result 必须记录：

- Candidate ID。
- Story Version。
- Scope。
- Stage。
- Reviewer / Owner。
- Result。
- Findings。
- Evidence。
- Decision Time。
- Required Return Stage。

无 Evidence 的 PASS 无效。

失败不得默认返回最近阶段。

必须返回能够修正根因的最早 Owner Stage。

---

# 7. Stage 1 — 需求与 Journey 定位

## Input

- 当前明确用户需求。
- 产品目标与目标 Explorer。
- Journey 候选主题。
- 当前 ROADMAP、Catalog 与产品状态证据。
- Systems 与 Story 上游规范。

## Action

- 明确为什么需要这篇 Story。
- 定义 Story 要为用户提供的阅读价值与学习价值。
- 确认是新建、重写、Level Adaptation 还是局部修订。
- 确认 Ordinary Journey 或 Special Journey。
- 普通 Journey 绑定城市、地点、Geo Identity 与现实范围。
- 特别 Journey 绑定文学、神话、志怪、民间传统或批准的原创 Genre。
- 定义目标语言、Phoenix Level 范围、发布范围与非目标。
- 指定 Story Owner、Research Owner 与初始风险。
- 建立 Candidate ID 与 Story Record。

## Output

- Story Requirement Brief。
- Journey Positioning Statement。
- Ordinary/Special Classification。
- Scope / Non-scope。
- Owner Matrix。
- Initial Risk Record。

## Gate — Journey Positioning Gate

必须确认：

- 用户目标与任务边界明确。
- Story 对 Journey 有真实必要性。
- Ordinary/Special 分类明确且有理由。
- Journey Identity 不与现有正式 Identity 冲突。
- 目标 Explorer、语言、Level 与发布范围明确。
- Owner 与风险已记录。
- 未把规划中功能写成已完成要求。

任一项缺失：`NEEDS_REVISION` 或 `BLOCKED`。

## Failure Return Path

- 需求不清：留在 Stage 1 请求澄清。
- Journey 类型不明：留在 Stage 1，由 Story Owner 裁决。
- 与 Core 或 Systems 冲突：返回 Requirement / Systems Review。
- 授权、法律或平台边界不明：停止并报告。
- 只是重复需求：关闭 Candidate 或合并到已批准 Requirement，不进入 Stage 2。

---

# 8. Stage 2 — 故事库重复检查

## Input

- PASS 的 Story Requirement Brief。
- 当前目标 Commit 的完整普通与特别 Journey 聚合目录。
- 全部 Canonical Story、Level Variant 与 Story Metadata。
- 已弃用、开发中与规划中 Story 清单。
- 已知重复 Finding 与 Library Review Evidence。

## Action

- 从目标 Commit 重新计算完整 Story Library Scope。
- 比较主角、关系、目标、冲突、变化、关键选择、物件、场景、结构、情绪曲线与结尾。
- 检查城市、地方文化、原典、Genre 与叙事视角是否重复。
- 检查常见 AI 骨架、开场套话、通用转折与结尾模板。
- 区分必要呼应、同主题变奏与不可接受的换名复用。
- 为 Candidate 定义不可替代性。
- 记录最相近 Story 及差异理由。

## Output

- Story Library Duplicate Report。
- Nearest-story Comparison。
- Originality / Differentiation Contract。
- Library Scope Counts and Commit Evidence。

## Gate — Library Originality Gate

必须确认：

- 检查覆盖完整发布目录，而非抽样或单一 Catalog。
- Candidate 不只是替换城市、人物、物件或 Genre 皮肤。
- 主角、目标、冲突、选择与结尾至少形成独立组合。
- 地方文化或原典真实参与叙事，不是装饰。
- 与最相近 Story 的差异可被具体说明。
- 没有明显 AI 流水账或重复骨架。

## Failure Return Path

- 需求本身重复：返回 Stage 1，合并或取消。
- Story Direction 重复：返回 Stage 1 重新定位。
- 仅结构重复：返回 Stage 5 或 Stage 6 前置设计，不得进入研究后直接写稿。
- Library Scope 不完整：留在 Stage 2 补齐数据。
- 无法判断版本：返回 Stage 1 修正 ID、Version 与 Catalog Scope。

---

# 9. Stage 3 — 城市、文化或原典研究

## Input

- PASS 的定位与重复检查结果。
- Research Questions。
- Ordinary/Special Classification。
- 目标城市、文化、历史、地理、文学或原典范围。
- Source、版权与文化敏感性要求。

## Action

- 普通 Journey 研究真实城市、地点、生活、空间、历史与当代变化。
- 特别 Journey 研究原典、不同版本、后世演变、文化精神与可原创边界。
- 区分事实、传说、争议、解释、改编与 Phoenix 原创。
- 优先使用政府、博物馆、UNESCO、学术、原典及其他适当可靠来源。
- 记录 Source ID、Publisher、URL、Language、Access Date 与适用 Claim。
- 检查版权、翻译、改编与商业使用边界。
- 识别民族、宗教、身份、战争、灾难、性别、阶层与其他敏感内容。
- 提取能够进入人物行动的地方或文学细节，不复制研究原文。

## Output

- Content Research Evidence。
- Source Record and Claim Map。
- Culture / Original-text Brief。
- Fact / Legend / Adaptation / Originality Matrix。
- Copyright and Commercial-use Status。
- Cultural Risk Record。

## Gate — Research and Cultural Truth Gate

必须确认：

- 核心 Claim 有可追踪来源。
- 事实、传说、版本、改编与原创边界清楚。
- 普通 Journey 的地方文化具体且可信。
- 特别 Journey 的原典与文化精神已被理解。
- 来源足以支持 Story Direction。
- 版权与商业使用状态允许当前范围。
- 敏感内容有适当 Reviewer 与处理方式。

## Failure Return Path

- 证据不足：留在 Stage 3 继续研究。
- 研究范围错误：返回 Stage 1 重新定位。
- Candidate 与真实文化不相容：返回 Stage 1 或 Stage 5 重建方向。
- 原典版本冲突未处理：留在 Stage 3，标记多版本，不得任选其一冒充唯一版本。
- 版权、商业使用权或文化真实性无法确认：`BLOCKED`，禁止进入 Stage 4。

---

# 10. Stage 4 — 学习目标确认

## Input

- PASS 的 Research Package。
- Journey Purpose。
- Learning Contract。
- 目标 Explorer 与 Phoenix Level 范围。
- 当前 Vocabulary、Discovery、Challenge 与 Memory 规则。

## Action

- 明确用户在 Story 后应能够理解、感受、注意或使用什么。
- 区分阅读目标、语言目标、文化目标与后续学习目标。
- 确认目标适合 Story，而不是要求 Story 伪装题目。
- 定义可自然出现的 Vocabulary Opportunity。
- 定义 Discovery 应扩展而非重复的内容。
- 定义 Challenge 可验证的故事理解范围。
- 定义 Memory 应保留的形象、选择、语言或文化锚点。
- 确认 Phoenix Lv.1–10 的 Meaning Preservation 边界。
- 将 HSK/TOCFL 仅作为内部校准证据，不向用户宣称官方等值。

## Output

- Learning Objective Contract。
- Story / Learning Boundary。
- Phoenix Level Meaning-preservation Rules。
- Vocabulary / Discovery / Challenge / Memory Opportunity Map。

## Gate — Learning Alignment Gate

必须确认：

- 文学目标与学习目标可以同时成立。
- 学习目标不会预先决定人物、冲突或结尾。
- Vocabulary 不要求不自然句子。
- Discovery 不要求 Story 写成百科。
- Challenge 不要求正文暴露答案句。
- HSK/TOCFL 只作为内部参考。
- 所有公开难度使用 Phoenix Level Identity。

## Failure Return Path

- 学习目标不清：留在 Stage 4，由 Learning Owner 澄清。
- 目标与 Story Direction 冲突：返回 Stage 1 或 Stage 3 重定范围。
- 目标词无法自然进入：调整学习目标；不得强行写入 Story。
- Level 要求无法保持 Canonical Meaning：返回 Learning Architecture / Stage 4。
- Learning 试图接管 Story：停止并依 SYSTEM_PRIORITY 升级。

---

# 11. Stage 5 — 主角与角色设计

## Input

- PASS 的 Journey、Research 与 Learning Contracts。
- Library Originality Contract。
- Cultural Risk Record。
- Ordinary/Special Narrative Boundary。

## Action

- 设计独立主角、身份、处境、关系、欲望、盲点与行动能力。
- 若使用第二人称“你”，定义该 Journey 独有的角色身份与处境。
- 设计必要配角及其与主角不同的目标。
- 让角色属于目标城市、时代、文化或文学空间。
- 检查角色是否只是导游、老师、讲解员或任务发放者。
- 检查角色能否通过行动显露，而非由旁白解释。
- 检查年龄、身份、群体与文化表达是否刻板。
- 与故事库中的角色关系模式比较。

## Output

- Protagonist Contract。
- Character Map。
- Relationship and Motivation Record。
- Voice / Perspective Decision。
- Character Cultural Review Notes。

## Gate — Character Integrity Gate

必须确认：

- 主角独立、具体并具有行动能力。
- 主角拥有目标前提，而非空白观察者。
- 配角不只是知识输出工具。
- 角色关系能够产生行动与冲突。
- 人物属于当前 Journey，不能无差别迁移。
- 没有刻板化、工具化或文化不尊重。

## Failure Return Path

- 主角与 Journey 不匹配：返回 Stage 1。
- 角色缺少研究基础：返回 Stage 3。
- 角色只服务学习目标：返回 Stage 4 或 Stage 5。
- 角色与故事库高度重复：返回 Stage 2 / Stage 5 重建。
- 角色不可行动：留在 Stage 5 重新设计。

---

# 12. Stage 6 — 目标、冲突与关键选择设计

## Input

- PASS 的 Character Package。
- Journey Purpose。
- Research and Cultural Boundaries。
- Learning Boundary。
- Originality Contract。

## Action

- 定义主角想得到、完成、保护、理解、寻找、归还、离开或决定的具体目标。
- 设计真正阻止目标直接完成的冲突。
- 让冲突与人物、地方、文化或原典发生关系。
- 设计升级、代价与不可轻易回避的压力。
- 设计至少一个揭示人物或价值的关键选择。
- 定义选择的真实后果。
- 检查冲突是否只是天气、迷路、失物、陌生人或时间到期的通用机制。
- 检查选择是否只是 UI 二选一而不改变意义。

## Output

- Goal Contract。
- Conflict Architecture。
- Stakes and Escalation Map。
- Key Choice and Consequence Contract。
- Core Change Statement。

## Gate — Narrative Engine Gate

必须确认：

- 目标具体并推动行动。
- 冲突阻止目标且不能被轻易移除。
- 冲突只属于或强烈属于当前 Journey。
- 关键选择揭示人物并产生后果。
- 变化可由冲突与选择产生。
- 没有模板化 Story Skeleton。

## Failure Return Path

- 目标来自错误 Journey Positioning：返回 Stage 1。
- 冲突缺少文化/原典依据：返回 Stage 3。
- 冲突被学习目标强行制造：返回 Stage 4。
- 人物无法承担选择：返回 Stage 5。
- 冲突或选择与故事库重复：返回 Stage 2 / Stage 6。
- 后果不成立：留在 Stage 6 重建。

---

# 13. Stage 7 — 情绪曲线设计

## Input

- PASS 的 Narrative Engine。
- Character Motivation。
- Key Choice and Consequences。
- Story Philosophy。

## Action

- 定义开场情绪状态。
- 定义每次信息、行动、关系与后果如何改变情绪。
- 设计情绪转向，而不是持续同一种“温暖、神秘或紧张”。
- 建立外部事件与内部感受之间的因果。
- 允许复合情绪与不完全解决。
- 设计结尾余韵。
- 检查是否依靠天气、音乐、灯光或旁白宣布情绪。
- 与故事库情绪曲线比较。

## Output

- Emotional Arc。
- Emotion Trigger Map。
- Character Internal Change。
- Ending Resonance Statement。

## Gate — Emotional Movement Gate

必须确认：

- 情绪至少发生一次有因果的变化。
- 变化来自事件、关系、信息或选择。
- 情绪与人物一致，不是外部滤镜。
- 结尾情绪回应 Story Core Change。
- 不复制故事库常见情绪路线。
- 不通过说教解释情绪意义。

## Failure Return Path

- 情绪没有叙事原因：返回 Stage 6。
- 人物反应不可信：返回 Stage 5。
- 情绪依赖文化刻板印象：返回 Stage 3。
- 情绪曲线重复：返回 Stage 2 / Stage 7。
- 只有单一氛围：留在 Stage 7 重新设计。

---

# 14. Stage 8 — 场景与结构设计

## Input

- PASS 的 Character、Narrative Engine 与 Emotional Arc。
- City / Culture / Original-text Research。
- Learning Boundary。
- Story Length and Runtime Constraints as Feedback。

## Action

- 选择能够承载人物行动与文化关系的场景。
- 定义开场、推进、阻碍、转折、选择、后果与结尾。
- 定义每个段落或结构单元的主要叙事动作。
- 安排信息、线索、留白与回收顺序。
- 让地方物件与空间参与冲突，不作为装饰。
- 设计可被想象的空间关系，不编写 Visual 指令。
- 保持短篇结构完整，不把长故事机械截短。
- 检查普通 Journey 是否像旅游路线。
- 检查特别 Journey 是否依赖通用梦、门、雾、信物或反转模板。

## Output

- Scene Map。
- Story Beat Sheet。
- Paragraph / Structural Unit Purpose。
- Information and Foreshadowing Map。
- Opening and Ending Contract。
- Canonical Story Architecture。

## Gate — Story Architecture Gate

必须确认：

- 每个 Scene 推动行动、关系、文化理解或选择。
- Story 包含完整开场、推进、转折、选择与结尾。
- 结构与情绪曲线一致。
- 留白有线索，不是缺失。
- 地方或原典参与结构。
- 删除任何核心 Scene 都会改变 Story，而非只是缩短。
- 结构不依赖 Visual、UI 或 Audio 才能成立。

## Failure Return Path

- Scene 缺少研究基础：返回 Stage 3。
- 学习与结构冲突：返回 Stage 4。
- 人物在结构中被动：返回 Stage 5。
- 冲突、选择或后果不成立：返回 Stage 6。
- 情绪与结构不一致：返回 Stage 7。
- 结构模板化：返回 Stage 2 / Stage 8。

---

# 15. Stage 9 — 初稿

## Input

- PASS 的 Canonical Story Architecture。
- Character Voice and Perspective。
- Research / Source Boundaries。
- Emotional Arc。
- Natural Chinese and Read-aloud Principles。
- Generation Constraints（AI 参与时）。

## Action

- 依据已批准结构写出完整 Canonical Draft。
- 使用自然中文与具体动作。
- 让文化通过人物、空间、物件与选择进入文本。
- 保持画面、节奏、留白与情绪变化。
- 标记需核验的 Claim、专名、引文、文化词与改编内容。
- 记录 AI 使用范围、模型/工具、输入来源与人工修改责任（适用时）。
- 不在初稿阶段强行塞入全部目标词、翻译或题目答案。
- 进行首次大声朗读。

## Output

- Versioned Canonical Draft。
- Draft Notes。
- Claim and Verification Markers。
- AI Generation Record（适用时）。
- Initial Read-aloud Notes。

## Gate — Draft Completeness Gate

必须确认：

- 初稿覆盖 Approved Architecture。
- 主角、目标、冲突、变化、选择与结尾完整出现。
- 没有明显事实编造、文化越界或来源冒充。
- 没有以 Discovery、百科或教学说明代替 Story。
- AI Output 被标记为 Candidate。
- Draft 有稳定 Version，可进入编辑。

## Failure Return Path

- Draft 偏离 Journey：返回 Stage 1 / Stage 8。
- 事实或文化问题：返回 Stage 3。
- 人物、冲突或情绪在文字中无法成立：返回 Stage 5–7。
- 结构缺陷：返回 Stage 8。
- 只是局部语言问题：留在 Stage 9 修订后重过 Gate。
- AI 编造、流水账或大面积模板：废弃 Draft，返回 Stage 8 或 Stage 9 重新创作，禁止只润色。

---

# 16. Stage 10 — 文学编辑

## Input

- PASS 的 Versioned Draft。
- Story Constitution and Philosophy。
- Research Evidence。
- Library Duplicate Report。
- Read-aloud Notes。

## Action

- 编辑文学性、人物主动性、因果、节奏、画面、留白、情绪与结尾。
- 检查自然中文、搭配、指代、视角、时态感与对话身份。
- 删除空泛形容、翻译腔、说明腔、说教与重复解释。
- 检查 AI 流水账、均匀段落、高频套词、通用转折和 Plot Convenience。
- 验证每个具体细节是否参与叙事。
- 大声朗读并调整呼吸、停顿与段落。
- 对照最相近 Story，检查结构与语言重复。
- 保留 Change Record，不静默改变 Canonical Meaning。

## Output

- Literary Edited Candidate。
- Editorial Change Record。
- Read-aloud Review Record。
- AI Trace Review Findings。
- Meaning Preservation Confirmation。

## Gate — Literary Quality Gate

必须确认：

- Story 本身值得继续阅读。
- 文学性不依赖华丽词汇或 Visual。
- 人物行动、冲突、变化与选择可信。
- 中文自然、具体、有节奏并可朗读。
- 留白可推断，结尾完成而不说教。
- 没有明显 AI 痕迹、模板、重复套路或批量换名。
- 编辑未改变事实、文化边界与 Canonical Meaning。

## Failure Return Path

- 研究错误：返回 Stage 3。
- 人物、冲突、情绪或结构问题：返回 Stage 5–8。
- Draft 整体机械或模板化：返回 Stage 8 / Stage 9 重写。
- 局部语言问题：留在 Stage 10 编辑。
- 文学与学习目标无法同时成立：返回 Stage 4 与 Stage 8 联合重设。

---

# 17. Stage 11 — 语言难度与 HSK/TOCFL 适配

## Input

- PASS 的 Literary Edited Canonical Candidate。
- Approved Canonical Meaning。
- Phoenix Lv.1–10 Contract。
- HSK/TOCFL Internal Calibration Evidence。
- Language、Vocabulary 与 Accessibility Requirements。

## Action

- 为所有目标 Phoenix Level 建立完整可读版本。
- 调整词汇、句法、句长、段落密度、明示程度与语言支持。
- 保持主角、目标、冲突、关键行动、关系、文化事实、变化、选择与结尾意义。
- 使用 HSK/TOCFL 词汇与难度资料作为内部校准，不宣称官方等级等值。
- 检查简化是否造成幼稚化、事实错误、因果断裂或 Story 消失。
- 检查高级化是否只是堆词、典故与长句。
- 建立中文、拼音、越南语、英语及适用语言的意义对齐。
- 对每个 Level 进行朗读检查。

## Output

- Phoenix Level Variant Set。
- Internal HSK/TOCFL Calibration Record。
- Cross-level Meaning Matrix。
- Multilingual Alignment Record。
- Level Read-aloud Evidence。

## Gate — Level Meaning Preservation Gate

必须确认：

- 每个公开 Level 是完整 Story。
- 所有 Level 保持 Canonical Story Identity 与 Meaning。
- 难度变化真实、连续且适合目标能力。
- HSK/TOCFL 未在用户界面或内容中被错误宣称为官方等值。
- 多语言与拼音意义、人物、因果和文化边界一致。
- 每个 Level 可读、可朗读且不依赖其他 Level 补足情节。

## Failure Return Path

- Canonical Story 不适合分级：返回 Stage 8 / Stage 10。
- 某 Level 无法保留意义：留在 Stage 11 重写该 Level，并重跑全级一致性。
- Learning Contract 不可执行：返回 Stage 4 / Learning Architecture。
- 文化或事实被简化错误：返回 Stage 3 与 Stage 11。
- 翻译或拼音错误：留在 Stage 11，由 Language Reviewer 修正。
- 任一公开 Level 缺失：`BLOCKED`，不得进入 Stage 12。

---

# 18. Stage 12 — 生词、发现、挑战和回忆衔接

## Input

- PASS 的 Canonical Story 与 Level Variant Set。
- Learning Objective Contract。
- 当前 Vocabulary、Discovery、Challenge 与 Memory 规范。
- Journey Flow and Consumer Schema。

## Action

- 从真实 Story 语境选择 Vocabulary，不反向改写 Story 塞词。
- 为生词建立词性、释义、拼音、目标母语、英语与自然例句等适用内容。
- 设计 Discovery，扩展 Story 留下的历史、文化、空间或现实问题，不复制 Story。
- 设计 Challenge，验证人物、因果、细节、选择或意义，不使用歧义和生硬答案句。
- 设计 Memory，保存 Story 的形象、语言、文化或选择，而非只保存分数。
- 检查各 Level 的内容适配与同一 Source of Truth。
- 检查 Story、Vocabulary、Discovery、Challenge、Memory 与 Stamp 的顺序与版本引用。

## Output

- Story Learning Handoff Package。
- Vocabulary Set and Source Links。
- Discovery Set and Novelty Evidence。
- Challenge Contract and Answer Evidence。
- Memory Anchor。
- Consumer Version Map。

## Gate — Learning Integration Gate

必须确认：

- Vocabulary 来自自然、准确的 Story 语境。
- Discovery 提供新信息，不重复正文。
- Challenge 可以由 Approved Story 作答，且不扭曲 Story。
- Memory 保留故事意义，不是奖励摘要。
- 全部 Consumer 指向同一 Approved Story Version。
- 学习内容不暴露 HSK/TOCFL 官方等值声明。
- Story 的文学节奏未被学习元素破坏。

## Failure Return Path

- 目标词不自然：返回 Stage 4 调整学习目标，不得改坏 Story。
- Discovery 缺少来源：返回 Stage 3。
- Challenge 暴露结构缺陷：返回 Stage 6 / Stage 8；若只是题目缺陷，留在 Stage 12。
- Memory 无 Story 锚点：返回 Stage 7 / Stage 8 或重设 Memory。
- Consumer Version 冲突：留在 Stage 12，与 Content/Code Owner 同步。
- Learning 试图改写 Canonical Meaning：停止并升级 Story/Learning Owner。

---

# 19. Stage 13 — Story Quality Gate

## Input

- 完整 Story Package。
- Research and Source Evidence。
- Canonical Story and Level Variants。
- Learning Handoff Package。
- Library Duplicate Report。
- Editorial, Cultural, Language and AI Review Records。
- 当前适用 Story Quality Gate。

## Action

- 对每个 Journey、每个公开 Phoenix Level 与每个适用语言执行质量检查。
- 检查 Identity、Source、Culture、Narrative、Literature、Language、Level、Learning Interface、Audio Readability 与 Technical Integrity。
- 执行确定性 Auditor 与 AI Review（适用时）。
- 检查完整发布聚合目录，而非只检查改动项或 daily 子集。
- 将自动 Findings 交由明确 Reviewer 处置。
- 为每项要求链接 Evidence。

## Output

- Story Quality Gate Record。
- Per-journey / Per-level Findings。
- Library-level Counts and Scope。
- PASS、NEEDS_REVISION 或 BLOCKED。
- Repair Instructions and Return Stage。

## Gate — Mandatory Story Quality Gate

只有以下条件同时满足才可 PASS：

- 所有 Blocking Item 为零。
- 所有 Required Item 有证据。
- 全部公开 Journey、Level 与语言在 Scope 内。
- 自动审计与人工 Review 结论一致或差异已处理。
- Source、Culture、Copyright 与 Commercial-use 状态明确。
- 没有明显 AI Error、模板、重复或 Meaning Drift。
- Story 与 Learning Package 版本一致。

`NEEDS_REVISION` 与 `BLOCKED` 均禁止进入 Stage 14。

## Failure Return Path

- Source / Culture / Copyright：返回 Stage 3。
- Learning Goal：返回 Stage 4。
- Character：返回 Stage 5。
- Goal / Conflict / Choice：返回 Stage 6。
- Emotional Arc：返回 Stage 7。
- Structure：返回 Stage 8。
- Draft / Literature / AI Trace：返回 Stage 9 或 Stage 10。
- Level / Language：返回 Stage 11。
- Learning Integration：返回 Stage 12。
- Gate Scope 或 Evidence 不完整：留在 Stage 13，补齐后完整重跑。

---

# 20. Stage 14 — Story Checklist

## Input

- PASS 的 Story Quality Gate Record。
- 完整 Story Package。
- 当前适用 Story Checklist。
- Pipeline Stage Evidence。

## Action

- 逐项核对需求、重复、研究、学习、人物、冲突、情绪、结构、文学、Level、衔接与 Gate Evidence。
- 核对 ID、Version、Owner、Status、Source 与 Consumer Link。
- 核对 Ordinary/Special 专项要求。
- 核对 AI 使用记录与人工处置。
- 核对所有阶段没有被静默跳过。
- 发现 Checklist 遗漏上游强制项时，遵守上游并记录 Checklist 缺陷。

## Output

- Completed Story Checklist。
- Missing / Inconsistent Item List。
- Evidence Index。
- Checklist Sign-off。

## Gate — Checklist Completeness Gate

必须确认：

- 全部强制项已明确勾选并链接 Evidence。
- `NOT_APPLICABLE` 有具体理由与 Owner。
- 没有用 Checklist PASS 覆盖 Story Gate FAIL。
- Candidate ID、Version 与 Stage 13 完全一致。
- 没有未处理的缺失、冲突或过期 Evidence。

## Failure Return Path

- Checklist 发现真实内容缺陷：返回根因所属 Stage 1–12，并重跑 Stage 13。
- Gate Evidence 缺失：返回 Stage 13。
- Checklist 本身缺项：留在 Stage 14 报告规范缺陷；不得自行降低要求。
- Version 不一致：返回 Stage 12 / Stage 13 重建完整 Candidate。

---

# 21. Stage 15 — Story Review

## Input

- Story Gate PASS。
- Completed Story Checklist。
- Canonical Story、全部 Level、语言与学习衔接内容。
- Source、Culture、Literary、AI 与 Library Evidence。
- 当前适用 Story Review Prompt。

## Action

- 由未独立生成该 Candidate 的合格 Reviewer 阅读完整 Package。
- 进行文学 Review：是否真正值得阅读、是否有画面、节奏、留白、情绪与余韵。
- 进行人物 Review：主角、目标、冲突、变化、选择与结尾是否成立。
- 进行文化 Review：普通 Journey 的地方真实性或特别 Journey 的原典精神是否成立。
- 进行学习 Review：Level 与衔接是否保护 Story。
- 进行全库 Review：是否增加不可替代内容，是否与现有 Story 重复。
- 比较自动 Review Findings 与人工判断。
- 记录批准、拒绝、条件与明确理由。

## Output

- Story Review Record。
- Reviewer Findings and Disposition。
- Approved Story Candidate 或 Revision Request。
- Approved Story Version and Consumer Freeze。

## Gate — Independent Story Review Gate

必须确认：

- Reviewer Scope 覆盖完整 Candidate。
- Reviewer 不以 AI 分数、测试通过或代码存在代替文学判断。
- 生成者没有独立批准自己的输出。
- 所有 Findings 有处置，不存在静默忽略。
- Approved Version、Owner、Scope 与 Evidence 明确。
- Story Gate 和 Checklist 仍为 PASS。

## Failure Return Path

- 文学失败：返回 Stage 8–10。
- 文化/来源失败：返回 Stage 3。
- Level/语言失败：返回 Stage 11。
- Learning 衔接失败：返回 Stage 12。
- Gate/Checklist Evidence 问题：返回 Stage 13 / Stage 14。
- Reviewer 无法独立判断：`BLOCKED`，补充 Reviewer 或 Evidence，不得默认批准。

---

# 22. Stage 16 — 页面级 QA

## Input

- Approved Story Candidate。
- Frozen Story Version and Consumer Map。
- 目标 Branch、Commit 与 Preview Candidate。
- Story、Vocabulary、Discovery、Challenge、Memory、Visual 与 Audio Runtime。
- Device、Accessibility、Performance 与 QA Requirements。

## Action

- 在真实 Story 页面和完整 Journey Flow 中验证。
- 覆盖目标手机、平板、方向、字体缩放与适用语言。
- 验证 Story 正文、段落、标点、翻译、拼音与 Level 切换。
- 验证 Visual 不遮挡文字、按钮或学习流程，也不与 Story 冲突。
- 验证 Narration 文本、语言、顺序、停顿、Highlight 与无声降级。
- 验证 Vocabulary、Discovery、Challenge 与 Memory 指向同一 Story Version。
- 验证返回、继续、重进、状态恢复与错误路径。
- 验证性能、Accessibility、Reduced Motion 与静态降级。
- 记录截图、日志、设备、Build、Commit 与结果。

## Output

- Page-level QA Record。
- Device and Locale Matrix。
- Story Flow Regression Evidence。
- Accessibility / Performance / Audio / Visual Findings。
- Release Candidate Recommendation 或 Rejection。

## Gate — Page-level QA Gate

必须确认：

- Preview Artifact 与目标 Commit 一致。
- Approved Story Version 在全部 Consumer 中一致。
- 文字可读、可滚动/呈现、不会被遮挡或截断。
- 学习流程可完成，按钮和关键操作可用。
- Audio 正确；无声时仍可完成。
- Visual 与 Story 一致；动态不自然时使用合格高清静态方案。
- 目标手机和平板适配完成。
- Performance 与 Accessibility Blocking Item 为零。
- 回归和错误路径有 Evidence。

## Failure Return Path

- Story 文本/结构缺陷：返回 Stage 8–10，并重新执行后续全部阶段。
- Level/翻译/拼音：返回 Stage 11。
- Vocabulary/Discovery/Challenge/Memory：返回 Stage 12。
- Visual 问题：返回 Visual Production；不得改写 Story。
- Audio 问题：返回 Audio Development；不得维护另一份正文。
- UI/Code 问题：返回对应 Development Stage。
- Performance/Accessibility 问题：返回 Architecture / Development / QA。
- Candidate 与 Commit 不一致：留在 Stage 16 重建 Preview。
- 任一 Blocking Item：禁止进入 Stage 17。

---

# 23. Stage 17 — 正式发布

## Input

- Story Review PASS。
- Page-level QA PASS。
- Story Quality Gate and Checklist Evidence。
- Approved Story Version。
- 完整 Release Candidate Commit and Artifact。
- CI、Regression、Accessibility、Performance 与 Consumer Evidence。
- Release Authorization and Rollback Plan。

## Action

- 核对 Candidate、Commit、Artifact、Catalog、Story Version 与 Evidence 完全一致。
- 核对所有 Required Gate 仍为 PASS，且没有在 Review 后发生未审查变更。
- 由 Release Owner 执行目标环境的正式交付流程。
- 记录 Release Version、时间、环境、Commit、Artifact 与 Owner。
- 完成交付后 Health Check。
- 若失败，执行 Rollback。
- 更新真实 Release Evidence 与适用 CHANGELOG；未完成项不得写成已发布。
- 进入 Monitoring 与 Maintenance。

## Output

- Release Record。
- Released Story Version。
- Deployment / Delivery Evidence。
- Health Check Result。
- Rollback Result（如适用）。
- Monitoring Handoff。

## Gate — Release Authorization and Verification Gate

只有以下条件同时满足才允许标记 Released：

- Story Gate、Checklist、Independent Review 与 Page-level QA 全部 PASS。
- Target Commit、Artifact、Catalog 与 Approved Story Version 一致。
- CI 与所有 Required Professional Gate PASS。
- Release Owner 明确授权。
- Rollback 可执行。
- 正式交付后 Health Check PASS。
- Release Evidence 完整可追踪。

Story Pipeline 只定义 Story 进入 Release 的必要条件。

Release 最终执行权属于 Release System，不属于 Story Writer、AI、Reviewer 或本文件。

## Failure Return Path

- 授权缺失：留在 Stage 17，保持未发布。
- Evidence 或版本不一致：返回 Stage 16 或对应最早缺陷 Stage。
- Build / CI 失败：返回 Code Development / QA。
- Deployment 失败：立即 Rollback，返回 Release Planning / Development。
- Health Check 失败：立即 Rollback，返回 Stage 16 / Development。
- Story 在发布前发生任何修改：冻结失效，返回受影响最早 Stage 并重跑 Gate。

Preview、Commit、PR、Merge、Build 或 Deployment 任一单独存在，都不等于正式发布。

---

# 24. Mandatory Gate Map

以下 Gate 全部强制，不得跳过：

| Stage | Gate | Minimum decision |
| --- | --- | --- |
| 1 | Journey Positioning Gate | 需求、类型、范围、Owner 成立 |
| 2 | Library Originality Gate | 全库检查完成，Candidate 不重复 |
| 3 | Research and Cultural Truth Gate | 来源、文化、原典与权利成立 |
| 4 | Learning Alignment Gate | 文学与学习目标可同时成立 |
| 5 | Character Integrity Gate | 独立主角与角色关系成立 |
| 6 | Narrative Engine Gate | 目标、冲突、选择与后果成立 |
| 7 | Emotional Movement Gate | 情绪变化有因果 |
| 8 | Story Architecture Gate | 场景、结构、留白与结尾成立 |
| 9 | Draft Completeness Gate | 完整、可追踪初稿成立 |
| 10 | Literary Quality Gate | 文学性、自然中文与无 AI 痕迹成立 |
| 11 | Level Meaning Preservation Gate | Lv.1–10 与语言意义一致 |
| 12 | Learning Integration Gate | 生词、发现、挑战、回忆自然衔接 |
| 13 | Mandatory Story Quality Gate | 全部专业要求有证据 PASS |
| 14 | Checklist Completeness Gate | 全流程与 Evidence 完整 |
| 15 | Independent Story Review Gate | 独立专业 Review PASS |
| 16 | Page-level QA Gate | 真实页面、设备与流程 PASS |
| 17 | Release Authorization and Verification Gate | 授权、交付、验证与回滚完整 |

任一 Gate 失败，下游全部先前未执行 Gate 保持未开始。

任一已通过上游 Artifact 发生变化，所有依赖该 Artifact 的下游 PASS 自动失效。

---

# 25. Failure Return Matrix

| Failure root cause | Required return stage |
| --- | --- |
| 需求、Journey 类型、范围、Owner 错误 | Stage 1 |
| 与故事库重复、模板化、不可替代性不足 | Stage 2 或 Stage 1 |
| 事实、城市文化、原典、版权、商业使用权问题 | Stage 3 |
| 学习目标、Phoenix Level Contract 错误 | Stage 4 |
| 主角、角色、视角、关系错误 | Stage 5 |
| 目标、冲突、关键选择、后果错误 | Stage 6 |
| 情绪变化或人物成长错误 | Stage 7 |
| 场景、结构、留白、开场或结尾错误 | Stage 8 |
| 初稿偏离 Approved Architecture | Stage 9 或更早根因 Stage |
| 文学性、自然中文、节奏、朗读、AI 痕迹错误 | Stage 10 |
| Level、HSK/TOCFL 内部校准、拼音或翻译错误 | Stage 11 |
| Vocabulary、Discovery、Challenge、Memory 或版本衔接错误 | Stage 12 |
| Story Gate Scope、Evidence 或检查错误 | Stage 13 |
| Checklist 或 Evidence Index 不完整 | Stage 14 |
| 独立专业 Review 不通过 | Finding 所属最早 Stage |
| 页面、Visual、Audio、UI、Code、设备、Accessibility 或 Performance 问题 | 对应专业 Development / Stage 16 |
| Release 授权、Artifact、部署或 Health Check 问题 | Stage 17 / Release Planning；必要时 Rollback |

禁止只在当前阶段修饰症状。

禁止为了保留排期选择较晚的回退阶段。

---

# 26. Change Invalidation Rules

以下变更必须使对应下游批准失效：

## Journey Positioning Change

Stage 2–17 全部失效。

## Source or Cultural Finding Change

Stage 3 之后全部失效；若影响定位，返回 Stage 1。

## Learning Goal Change

Stage 4 之后全部失效；若影响 Journey Purpose，返回 Stage 1。

## Character / Conflict / Choice / Ending Change

Stage 5 或 Stage 6 之后全部失效。

## Canonical Text Change

Stage 10–17 失效；若改变结构或意义，返回 Stage 5–8。

## Level or Translation Change

受影响 Level 与 Stage 11–17 失效；必须重跑全级 Meaning Consistency。

## Vocabulary / Discovery / Challenge / Memory Change

Stage 12–17 失效；若暴露 Story 根因，返回对应更早 Stage。

## Visual / Audio / UI / Code Change

至少 Stage 16–17 失效；若改变 Story Consumer Contract，Stage 12–17 失效。

## Candidate Commit Change

Stage 16–17 失效，直到新 Artifact 与全部 Evidence 重新绑定。

不得复用旧 Candidate 的 PASS 证明新 Candidate。

---

# 27. AI Execution Rules

未来 AI 执行本 Pipeline 时必须：

1. 读取全部适用上游规范。
2. 读取当前完整 Story Library，而非只读取示例。
3. 明确当前 Stage，不跨阶段生成“完整成品”冒充流程完成。
4. 保存每个阶段输入、输出、Finding 与版本。
5. 将未知事实标记为未知，不进行补写。
6. 将 AI 生成内容标记为 Candidate。
7. 在文学编辑阶段进行结构级重写，不只替换高频词。
8. 比较全库 Story Skeleton、情绪曲线与结尾。
9. 不审核并独立批准自己的输出。
10. 任一强制 Gate 失败时停止下游动作。
11. 返回能够修正根因的最早 Stage。
12. 报告实际完成、未完成、Blocked 与未验证状态。

AI 禁止：

- 编造 Source、引文、文化事实或原典内容。
- 批量复用同一主角、冲突、物件、选择与结尾。
- 用字数、分数或自动测试覆盖文学判断。
- 用 HSK/TOCFL 公开标签替代 Phoenix Level。
- 因 Visual、UI、Audio 或代码限制改写 Story Meaning。
- 在 Page-level QA 前声称 Story 可正式发布。
- 在 Release Record 前声称 Story 已正式发布。

---

# 28. Pipeline Evidence Package

进入 Stage 17 前，Story Candidate 必须具备：

- Story Requirement Brief。
- Library Duplicate Report。
- Research Evidence and Source Record。
- Learning Objective Contract。
- Character Package。
- Goal / Conflict / Choice Contract。
- Emotional Arc。
- Story Architecture。
- Versioned Draft and AI Record。
- Literary Edit and Read-aloud Record。
- Phoenix Level and Multilingual Package。
- Learning Integration Package。
- Story Quality Gate Record。
- Completed Story Checklist。
- Independent Story Review Record。
- Page-level QA Record。
- Candidate Commit / Artifact Identity。
- Release Authorization and Rollback Plan。

证据必须对应同一 Candidate ID 与 Story Version。

文件存在不证明内容有效。

自动报告存在不证明人工处置完成。

---

# 29. Prohibited Shortcuts

Phoenix Story Production 禁止：

- 跳过故事库重复检查后直接生成。
- 先写故事，再为已写内容寻找来源。
- 先确定目标词，再强行构造人物行动。
- 先生成 Visual，再要求 Story 配合。
- 只设计“事件”，不设计主角目标与选择。
- 以气氛代替情绪变化。
- 以短篇幅为理由删除冲突、变化或结尾。
- 用 AI 润色修复结构性失败。
- 只检查一个 Level 或一种语言。
- 只检查 `daily`、最近修改项或页面可见 Story。
- 用 Story Quality Gate 替代 Checklist 与独立 Review。
- 用 Checklist 替代 Quality Gate。
- 用 AI Review 替代文化、文学与 QA Owner。
- 用自动测试替代页面级 QA。
- 用 Preview、Commit、PR、Merge 或 Deployment 代替 Release Evidence。
- 在任一 Gate 失败时通过删除 Story 或隐藏入口掩盖失败而不记录决定。

---

# 30. Final Pipeline Rule

Phoenix Story Production 从 Journey 定位开始，而不是从 Prompt 开始。

它先确认故事库中为什么需要这篇 Story。

再通过研究、学习边界、人物、冲突、选择、情绪与结构，建立不可替代的叙事生命。

初稿只是 Candidate。

文学编辑让它成为值得阅读的作品。

Level Adaptation 让不同 Explorer 进入同一个故事。

生词、发现、挑战与回忆从 Story 自然生长。

Story Quality Gate、Checklist 与独立 Review 共同阻止未成熟内容进入页面。

页面级 QA 证明 Story 在真实 Phoenix Experience 中仍然可读、可听、可学、可操作。

只有 Release System 完成授权、交付与验证以后，Story 才能被标记为正式发布。

任何阶段缺少输入、输出、Gate Evidence 或失败回退记录，都必须停止，不得跳过、猜测或以既有实现代替。
