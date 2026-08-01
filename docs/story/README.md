# Phoenix Story System

Documentation Status: Reconstructed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest within Story Documentation Entry)
Owner: Phoenix Story System

---

# 1. Purpose

Phoenix Story System（简称 Story System）是 Phoenix 全部故事生产、维护、审核与发布治理的唯一入口。

本文件负责：

- 定义 Story System 的使命、职责与边界。
- 区分普通 Journey 与特别 Journey。
- 规定 Story Documentation 的结构与读取顺序。
- 规定故事从需求、研究、创作到发布和维护的完整流程。
- 定义 Story 与 Learning、Visual、Audio、Content、AI Review、QA 和 Release 的接口。
- 建立 Story Quality Gate 与故事库级别审核规则。
- 区分 Documentation、内容与实现的已完成、开发中和规划中状态。
- 为未来 AI、Story Editor、Content Researcher、开发者与 Reviewer 提供可直接执行的入口。

本文件不负责：

- 替代未来的 Story Constitution、Philosophy、Guidelines、Pipeline、Quality Gate、Checklist 或 Review Prompt。
- 定义 Visual 风格、图片生成方法或背景构图。
- 定义 Learning 流程、题目逻辑、奖励或难度算法。
- 定义 UI 布局、Audio Engine、代码架构或 Release 操作。
- 声称代码中存在的故事已经通过正式 Story Review 或进入正式版。
- 将旧聊天记录、Roadmap、测试或既有实现提升为 Story 最高规范。

Story System 定义故事世界与意义。

Story System 不决定这个世界如何绘制、页面如何交互、语音如何播放或代码如何组织。

---

# 2. Story Mission

Phoenix Story System 的使命是：

> 为每一个 Journey 建立可信、值得阅读、具有文化意义、能够被记住并支持语言学习的叙事世界。

每个 Phoenix Story 必须让 Explorer：

- 感到自己正在进入一个世界，而不是阅读练习材料。
- 看见人物、地点、时间、行动与变化。
- 理解故事为什么值得发生。
- 在真实文化与文学想象之间获得清楚边界。
- 在不同 Phoenix Level 中读到同一个故事，而不是十个意义不同的版本。
- 能够自然进入 Vocabulary、Discovery、Challenge、Memory 与 Stamp 等后续学习体验。

Story 不是景点介绍的改写。

Story 不是历史资料的拼接。

Story 不是为生词、题目、图片或动效服务的占位文本。

Story 也不是 AI 一次生成即可发布的内容。

---

# 3. Authority and Boundaries

Story 工作必须遵守：

1. 当前用户明确指令与任务边界。
2. 安全、法律、版权、隐私与平台 Boundary Gate。
3. 当前有效的 Phoenix Core Product Principles。
4. `docs/systems/README.md`。
5. `docs/systems/SYSTEM_ARCHITECTURE.md`。
6. `docs/systems/SYSTEM_DEPENDENCY.md`。
7. `docs/systems/SYSTEM_LIFECYCLE.md`。
8. `docs/systems/SYSTEM_PRIORITY.md`。
9. 本 Story README。
10. 对应 Story Constitution、Philosophy、Guidelines 与专项规范（真实存在且适用时）。
11. Story Pipeline、Quality Gate、Checklist 与 Review Prompt（真实存在且适用时）。
12. ROADMAP、TODO、CHANGELOG 与当前实现证据。

发生冲突时，必须使用 `SYSTEM_PRIORITY.md` 裁决。

当前正式 Story Constitution、Philosophy、Guidelines、Pipeline、Quality Gate、Checklist 与 Review Prompt 尚未在本目录重建。它们保留应有的权威层级，但不得被虚构为已经存在或已经批准。

在这些文件重建前，本 README 与现有 Systems 规范提供 Story System 的入口治理；现有实现型文档和代码只提供当前事实与验证证据。

---

# 4. Story Responsibilities

Story System 负责：

- Journey Identity。
- 故事主题、核心意义与情绪弧线。
- 人物、视角、地点、时间、天气与叙事空间。
- 开场、行动、变化、冲突、转折、选择与结尾。
- 事实、传说、争议、解释、改编与原创想象的区分。
- 来源关系、文化真实性与文化尊重。
- 普通 Journey 与特别 Journey 的叙事边界。
- Phoenix Lv.1–10 的 Meaning Preservation。
- Story 正文、结构、Metadata 与 Version。
- 向下游提供稳定、可追踪的 Story Contract。
- 单篇、单 Journey 与故事库级别的质量审核。

Story System 禁止：

- 为配合现有 Visual Asset 改写 Story 核心意义。
- 把未经确认的历史、地理、宗教、民族或文化内容写成事实。
- 用 Discovery 原文、景点百科或通用城市描述填充故事长度。
- 为覆盖生词而写不自然的句子。
- 为适配 Audio Engine 改变人物、事件或结局。
- 为适配 UI 空间静默删除必要叙事信息。
- 直接定义 Learning Business Logic、Challenge 答案机制或奖励规则。
- 直接定义 UI、Visual、Audio、Animation、Code 或 Release 方案。
- 把 AI Output、测试通过或代码存在当作人工授权与正式发布。

---

# 5. Ordinary Journey

普通 Journey 建立在真实世界、真实地点、真实文化和真实生活之上。

普通 Journey 的目标是让 Explorer 通过一个有行动和变化的故事进入目的地，而不是阅读旅游宣传或建筑百科。

普通 Journey 必须：

- 绑定稳定的 Journey ID、Geo Identity 与地点范围。
- 以可验证的文化、历史、地理或生活研究作为上游证据。
- 使用可信的人物行动、空间关系与生活细节。
- 区分史实、当代观察、解释与作者组织的叙事情节。
- 保持地点独特性，不能替换城市名后仍然成立。
- 让文化信息自然进入人物、选择、物件、环境或变化。
- 在 Lv.1–10 保持相同核心事件、人物关系与结尾意义。
- 向 Visual 提供真实 Scene、Time、Weather、Culture 与 Character Contract。

普通 Journey 不得：

- 神话化真实人物或真实地点。
- 把未经证实的传说写成事实。
- 使用通用“古老街道、修复建筑、保护遗产”文本替代具体故事。
- 以旅游口号、景点评价或知识清单代替叙事。
- 为制造戏剧性而破坏文化真实性。

当前代码中可读取的普通 Journey 数据包括北京、上海、西安、杭州、成都、南京、广州、苏州、洛阳、泉州及其他扩展目的地相关 Catalog。该列表只说明实现数据存在，不是当前正式发布数量或完成状态声明。

---

# 6. Special Journey

特别 Journey 使用文学、神话、志怪、民间想象、传说意象或 Phoenix 原创幻想建立独立叙事空间。

特别 Journey 可以超现实，但不能失去文化来源、类型完整性与内部可信度。

特别 Journey 必须：

- 明确 Genre、灵感来源、原创范围与改编关系。
- 区分古籍原文、后世演变、民间流传与 Phoenix 原创情节。
- 保持对应文学传统、神话系统或地方文化的精神。
- 建立自己的叙事规则、物件、线索、选择与结尾。
- 保持内部因果与情绪连续性。
- 防止不同特别 Journey 回落为同一套通用奇幻模板。
- 在 Lv.1–10 保持相同类型、核心意象、事件弧线与意义。
- 向 Visual 和 Audio 提供明确但不越权的氛围与叙事节奏输入。

特别 Journey 不得：

- 冒充古籍原文或唯一正统版本。
- 混用互不相容的神话、宗教、地域或时代符号而不作说明。
- 依赖廉价惊吓、紫黑雾气、现代网游奇幻或欧美魔幻模板建立神秘感。
- 用通用建筑、修复、街道或遗产保护段落填充幻想故事。
- 因 Visual 已完成而改变 Story Identity。

当前代码中可读取的特别 Journey 包含“庄周梦蝶”“月宫遗简”“无影客栈”“逆流河灯”等已实现主题，以及长安末班车、潮汐广播、游戏厅失物、茶马回声、冰城星图等扩展数据。它们属于当前实现事实；每一项是否进入正式发布，必须以目标 Commit 的 Catalog、Story Gate、QA 与 Release Evidence 为准。

---

# 7. Story Documentation Map

`docs/story/` 是 Story System 的正式 Documentation 目录。

| File | Responsibility | Current documentation state |
| --- | --- | --- |
| `README.md` | Story System 唯一入口、导航、边界与总体治理 | Reconstructed in this Sprint |
| `STORY_CONSTITUTION.md` | Story 不可违反的最高专业规则 | Not yet reconstructed |
| `STORY_PHILOSOPHY.md` | 长期叙事判断、体验与取舍原则 | Not yet reconstructed |
| `STORY_GUIDELINES.md` | 可执行的生成、编辑与审校规范 | Not yet reconstructed |
| `ORDINARY_JOURNEY_GUIDELINES.md` | 普通 Journey 的真实世界叙事规范 | Not yet reconstructed |
| `SPECIAL_JOURNEY_GUIDELINES.md` | 特别 Journey 的文学与幻想叙事规范 | Not yet reconstructed |
| `STORY_PIPELINE.md` | Story Production 输入、动作、输出、Owner 与回退 | Not yet reconstructed |
| `STORY_QUALITY_GATE.md` | 正式 Story 强制质量门槛 | Not yet reconstructed |
| `STORY_CHECKLIST.md` | 写作、编辑与审核完整性核对 | Not yet reconstructed |
| `STORY_REVIEW_PROMPT.md` | AI 与人工 Review 的标准输入与输出 | Not yet reconstructed |

以上未重建文件是 Documentation Architecture 中的目标结构，不是 TODO，也不代表内容已存在。未来每个文件必须在单独 Recovery Sprint 或 Documentation Sprint 中建立、审查与提交。

现有 `docs/journey-content-quality-gate.md` 记录当前实现型内容审计与 CI 行为。它是重要 Evidence，但不能替代尚未重建的正式 `docs/story/STORY_QUALITY_GATE.md`。

现有 `content/README.md` 描述 Journey 内容仓库建议结构。当前 `content/CN/BJ/CN-BJ-001/` 仍不能证明完整 Story Package 已经建立；缺少正文、Metadata、Source 或授权记录时不得宣称可发布。

---

# 8. Story Reading Order

## 8.1 Every Story Task

所有 Story 任务必须按顺序读取：

1. 当前用户明确指令。
2. 当前仓库 README 与 `docs/systems/README.md`。
3. `SYSTEM_ARCHITECTURE.md`。
4. `SYSTEM_DEPENDENCY.md`。
5. `SYSTEM_LIFECYCLE.md`。
6. `SYSTEM_PRIORITY.md`。
7. 本 Story README。
8. 真实存在且适用的 Story Constitution。
9. 真实存在且适用的 Story Philosophy。
10. 真实存在且适用的 Story Guidelines。
11. Ordinary 或 Special Journey 专项规范。
12. Journey Purpose、Metadata、现有 Story、Source 与 Decision Evidence。
13. 适用的 Learning、Visual、Audio、Accessibility 与 QA 规范。
14. Story Pipeline、Quality Gate、Checklist 与 Review Prompt。
15. 目标 Catalog、代码、测试、Preview 与 Release Evidence。

文件缺失时必须按 `SYSTEM_PRIORITY.md` 的 Missing Authority 规则处理，不得猜测。

## 8.2 New Journey

新 Journey 额外读取：

1. Journey 需求与目标 Explorer。
2. Content Research 与 Source Requirements。
3. Ordinary 或 Special 分类依据。
4. Geo Identity 或 Literary/Cultural Identity。
5. Phoenix Level 与 Learning Contract。
6. Visual、Audio 与 UI 的接口需求。
7. Release Scope 与适用 Gate。

Story 必须先稳定 Meaning Contract，Visual 与 Runtime Packaging 才能正式开始。

## 8.3 Story Revision

修改现有 Story 额外读取：

1. 当前 Approved Story Version 与目标 Commit。
2. 修改原因、问题证据与影响范围。
3. 全部 Lv.1–10 版本。
4. Vocabulary、Discovery、Challenge 与 Narration Consumer。
5. Scene Brief、Background、Animation 与 UI Reading Layout。
6. 既有 QA、Preview、Release 与用户反馈。

不得只修改当前显示等级或一个下游副本。

## 8.4 Story Review

Reviewer 必须读取：

1. Story Source Record。
2. Journey Identity 与 Story Meaning Contract。
3. 当前 Story Version 与全部 Level Variants。
4. 适用的 Ordinary 或 Special 规则。
5. Story Quality Gate。
6. 下游一致性证据。
7. AI Review Findings 与人工处理结果。

Reviewer 不得只阅读页面截图或单一等级文本。

---

# 9. Story Contract

进入下游生产前，每个 Journey 必须形成可追踪的 Story Contract。

Story Contract 至少包含：

- Journey ID。
- Story ID 与 Story Version。
- Ordinary 或 Special 类型。
- Genre 与目标体验。
- 目标 Explorer 与 Phoenix Level 范围。
- 地点、时间、天气与空间边界。
- 主要人物、视角与人物关系。
- 开场状态、叙事行动、变化、转折与结尾。
- 核心意义与不可改变元素。
- 事实、传说、改编与原创内容标记。
- Source IDs、Source Status 与访问日期。
- 文化敏感项与 Reviewer。
- Lv.1–10 Meaning Preservation Rules。
- Vocabulary 与 Discovery Opportunities。
- Visual Scene/Emotion/Character Inputs。
- Audio Language、段落与朗读边界。
- QA Acceptance Criteria。
- Story Owner、Review Status 与 Approval Evidence。

Story Contract 不完整、版本不稳定或来源状态不明时，下游只能进行明确标注的探索，不得进行正式导入或发布。

---

# 10. Story Production Flow

Story 生成、编辑、审核与发布必须遵循以下流程：

```text
Requirement
→ Story Review
→ Research
→ Journey Identity
→ Story Architecture
→ Source and Meaning Contract
→ Draft
→ Editorial Revision
→ Level Adaptation
→ Cross-system Alignment
→ Self Review
→ Story Quality Gate
→ Library-level Review
→ QA
→ Preview
→ User Validation
→ Release Authorization
→ Monitoring and Maintenance
```

## 10.1 Requirement and Story Review

输入：当前明确需求、目标 Journey、Explorer、范围与非目标。

动作：确认 Story 是否必要、属于 Ordinary 或 Special、涉及哪些 Professional Systems、风险与 Owner。

输出：Approved Story Brief 或 Rejected/Clarification Decision。

失败返回：Requirement。

## 10.2 Research

输入：Story Brief、地点或文学身份、文化问题与 Source Requirements。

动作：收集可靠来源，区分事实、传说、版本、争议、改编与原创空间；记录版权和商业使用边界。

输出：Content Research Evidence 与 Source Record。

失败返回：Research；来源不足、文化真实性不明或权利无法确认时禁止进入正式写作和发布。

## 10.3 Journey Identity and Story Architecture

输入：Approved Brief 与 Research Evidence。

动作：建立主题、人物、视角、空间、开场、行动、变化、转折、结尾与核心意义。

输出：Journey Identity、Story Architecture 与 Meaning Contract。

失败返回：Story Review 或 Research。

## 10.4 Draft

输入：已批准的 Story Architecture 与 Source/Meaning Contract。

动作：由 Story Writer 或受控 AI 生成正文；保持叙事而非百科表达，并标记所有需核验内容。

输出：Versioned Draft 与 Generation Record。

失败返回：Story Architecture 或 Research。

AI 只可生成 Candidate，不得批准自己的输出。

## 10.5 Editorial Revision

输入：Draft、Source Evidence 与 Story Guidelines。

动作：检查自然语言、人物行动、因果、节奏、画面感、文化语境、原创边界与结尾意义；删除填充、重复和 AI 痕迹。

输出：Editorial Candidate 与 Change Record。

失败返回：Draft、Architecture 或 Research，取决于根因。

## 10.6 Level Adaptation

输入：Approved Meaning Candidate 与 Phoenix Level Contract。

动作：建立 Lv.1–10 表达，调整长度、词汇、句法与支持信息，但保持人物、事件、关系、类型与结尾意义。

输出：Level Variant Set 与 Meaning Consistency Evidence。

失败返回：Editorial Revision；无法在目标等级保留意义时返回 Story Architecture 或 Learning Architecture。

## 10.7 Cross-system Alignment

输入：Story Candidate、Level Variants 与下游接口需求。

动作：同步 Learning、Visual、Audio、Content 与 UI Consumer；只接受不改变 Story 核心意义的专业反馈。

输出：Stable Story Contract 与 Consumer Impact List。

失败返回：拥有根因的 Story、Learning、Visual、Audio、Content 或 UI Stage。

## 10.8 Self Review and Story Quality Gate

输入：完整 Story Package 与 Contract。

动作：执行人工核对、确定性审计、AI Review 和强制 Story Quality Gate。

输出：PASS、NEEDS REVISION 或 BLOCKED，以及逐项 Evidence。

失败返回：Research、Architecture、Draft、Editorial Revision 或 Level Adaptation。

## 10.9 Library-level Review and QA

输入：单篇 Gate PASS 的 Candidate 与当前完整发布目录。

动作：检查故事库多样性、重复、类型覆盖、文化分布、难度一致性、ID/Version、下游完整性与回归。

输出：Library Review Record、QA Evidence 与 Release Candidate。

失败返回：对应 Story Production Stage；不得只从 Release Catalog 隐藏问题而不记录决定。

## 10.10 Preview, Validation and Release

输入：Story Gate PASS、Library Review PASS、QA PASS 与可追踪 Candidate Commit。

动作：在真实页面、设备、等级、朗读和完整 Journey Flow 中验证；由授权 Owner 作出 Release 决定。

输出：Preview Evidence、User Validation Result、Release Record 或 Rejection Record。

失败返回：最早能够修正根因的阶段。

Preview 不是 Release。Commit 不是 Release。代码存在不是 Release。

---

# 11. Story Quality Gate

Story Quality Gate 是每个 Story、每个受支持 Level 与每次发布都必须通过的强制 Gate。

## 11.1 Identity Gate

- Journey ID、Story ID、Version 与 Ordinary/Special 类型明确。
- Story 属于目标地点、文化或文学身份。
- 更换城市名、人物名或意象后不能无差别复用。
- Story 核心意义与 Journey Purpose 一致。

## 11.2 Source and Culture Gate

- 所有事实性 Claim 可追踪到适用 Source。
- 事实、传说、争议、版本、改编与原创想象清楚区分。
- 文化、历史、地理、民族、宗教和文学表达经过适当 Review。
- Source、版权或商业使用边界无法确认时 BLOCKED。
- Ordinary Journey 的真实世界基础可靠。
- Special Journey 的原典精神、类型与原创声明成立。

## 11.3 Narrative Gate

- 有明确开场、人物或视角、行动、变化与结尾。
- 段落之间存在因果或有意义的推进。
- Story 有画面感，但不是为图片写的说明。
- 不使用百科、Discovery、建筑修复或通用文化段落凑长度。
- 不存在重复、空洞、机械、突兀或明显 AI 生成错误。
- 结尾回应 Story 的核心问题或变化。

## 11.4 Language and Level Gate

- 当前 Level 的长度、词汇、句法与支持信息符合有效 Phoenix Level Contract。
- Lv.1–10 保持同一人物、事件、类型、文化边界与核心意义。
- 简化不造成事实错误、幼稚化、文化扭曲或情节断裂。
- 中文、拼音、越南语、英语及其他适用语言意义一致。
- Vocabulary 来自自然语境，不以不自然句子强行覆盖。

## 11.5 Learning Interface Gate

- Story 为 Vocabulary、Discovery 与 Challenge 提供真实学习机会。
- Discovery 提供新信息，不复制 Story。
- Challenge 可依据 Story 作答，但 Story 不为答案机制变形。
- Story 不制造焦虑、羞辱、惩罚性语言或错误学习暗示。
- 当前正式 Journey Flow 中所有 Story Consumer 使用同一 Approved Version。

## 11.6 Visual and UI Interface Gate

- Visual Brief 源自 Approved Story Contract。
- Visual 没有反向改变人物、地点、时间、文化或意义。
- Story 在目标页面与设备上可读，文字和操作不被视觉遮挡。
- 动效不干扰阅读；不自然时使用合格高清静态方案。
- Visual Asset 失败不能通过改写 Story 掩盖。

## 11.7 Audio Gate

- 可朗读文本、语言、段落与停顿边界明确。
- 发音、专名、多音字与文化词具有可验证处理。
- Audio 不漏读、重复、错序或改变正文。
- 无音频、Audio 失败或 Reduced Motion/Accessibility 场景下仍可完成阅读。

## 11.8 Technical and Release Gate

- Schema、ID、Version、Locale 与 Catalog 引用完整。
- 当前完整发布目录已被审核，不是只检查抽样或日更子集。
- 所有适用自动测试、人工 Review、页面 QA 与回归 PASS。
- Preview Artifact 与目标 Commit 一致。
- Story Gate、Library Review、QA 或 Release Authorization 任一缺失时禁止正式发布。

任一 Blocking Item 失败，结论必须为 BLOCKED。

存在需要修正但不构成立即安全或法律阻断的问题，结论必须为 NEEDS REVISION；仍禁止进入正式版。

只有全部 Required Items 有证据通过时，结论才可为 PASS。

---

# 12. Story Library-level Review

单篇 Story PASS 不等于故事库 PASS。

每次 Preview Candidate 与 Release Candidate 都必须对当前完整发布聚合目录执行故事库级别审核。

审核范围必须从目标 Commit 的真实 Catalog 重新计算。不得把历史文档中的固定数量当作永久基线，也不得只检查 `dailyJourneyExperiences`、最近修改文件或页面当前可见项目。

故事库级别审核至少检查：

- 全部普通 Journey 与特别 Journey 是否被纳入。
- 每个 Journey 的全部公开 Phoenix Level 是否被纳入。
- Journey ID、Story ID、Geo ID、Genre、Version 与 Locale 是否唯一、稳定且正确绑定。
- 是否存在相同开场、冲突、转折、结尾、意象或句式的批量重复。
- 普通 Journey 是否具有目的地独特性，而非换名模板。
- 特别 Journey 是否保持文学幻想、神话、志怪、民间幻想及其他批准 Genre 的差异。
- 地区、时代、人物、生活、文化与叙事视角是否过度集中或刻板化。
- Lv.1–10 是否在全库使用一致等级标准。
- Vocabulary、Discovery 与 Challenge 是否跨 Journey 大量重复或失去关联。
- Story Source、文化 Review、原创声明和权利记录是否完整。
- Story、Learning、Visual、Audio、Content 与 UI 是否消费同一 Approved Version。
- 被移除、替换、Deprecated 或计划中的 Story 是否被误纳入 Release。
- 自动审计 Findings 是否全部有人工处置与证据。

Library Review 输出必须包含：

- 目标 Branch、Commit 与 Catalog Entry Point。
- 普通、特别、总 Journey 与 Level Inspection 的实际数量。
- Included、Excluded、Deprecated 与 Planned 清单。
- 重复、覆盖、缺失、文化风险与跨系统不一致 Findings。
- 每项 Owner、Severity、Disposition 与 Evidence。
- PASS、NEEDS REVISION 或 BLOCKED。

只要完整目录未被检查、数量无法解释、任一公开 Journey 缺少 Level、Source、Review 或 Consumer Synchronization，故事库不得进入正式版。

---

# 13. Relationship with Learning

Story 向 Learning 提供：

- Approved Story Meaning。
- 人物、事件、关系、语境与结尾。
- Level Adaptation 的意义保持边界。
- Vocabulary 与 Discovery Opportunity。
- Challenge 可验证的叙事信息。

Learning 向 Story 提供：

- Explorer 能力与 Phoenix Level Requirement。
- 阅读长度、词汇密度与认知负荷反馈。
- Vocabulary、Discovery 与 Challenge 的学习目标。
- Accessibility 与无焦虑要求。

Learning 可以要求表达适配，但不得改写 Story 核心意义。

Story 可以提供学习机会，但不得定义 Learning Flow、评分、奖励或完成逻辑。

---

# 14. Relationship with Visual

Story 向 Visual 提供：

- Journey Identity。
- Scene、Place、Time、Weather 与 Emotion。
- Character、Object、Culture 与 Narrative Focus。
- 事实与文学想象边界。
- 必须保留和禁止改变的 Story Elements。

Visual 向 Story 提供非权威反馈：

- Scene 可表达性。
- Reading Safe Area 风险。
- 文化视觉研究 Finding。
- 设备、性能、动态与静态降级限制。

Story Before Visual。

视觉服务故事。故事不为视觉改写。

Story 不规定画风、构图、动效或资源生成方式；这些属于 Visual System。所有视觉生产必须继续服从完整 Visual Documentation、版权、性能、设备适配与 Page-level QA。

---

# 15. Relationship with Audio

Story 向 Audio 提供：

- Approved Text 与 Version。
- Language、Locale 与段落边界。
- 专名、多音字、文化词与发音要求。
- 叙事节奏、停顿语义与不应改变的内容。

Audio 向 Story 提供非权威反馈：

- 朗读自然度。
- 句子过长、边界不清或发音歧义。
- 语音引擎限制与 Accessibility Alternative 需求。

Audio 可以请求编辑 Review，但不得自行删改 Story 或在运行时维护不同正文。

Story 修改后必须同步 Narration、Word Boundary、Highlight、Locale、Audio QA 与无声降级路径。

---

# 16. Relationship with QA and AI Review

QA 验证 Story 是否符合 Approved Contract 与 Gate。

QA 必须覆盖：

- Source 与文化真实性。
- 叙事完整性与语言质量。
- Ordinary/Special Genre Integrity。
- Lv.1–10 Meaning Consistency。
- 多语言一致性。
- Catalog、Schema、ID 与 Version。
- Learning、Visual、Audio、Content 与 UI Consumer。
- 完整页面、设备与 Journey Flow。
- 故事库级别回归。

AI Review 可以：

- 批量检查结构、重复、长度、语言对齐与 Genre Signal。
- 标记可能的事实、文化、AI Error 与跨等级问题。
- 提供可追踪的修正建议。

AI Review 不可以：

- 批准自己的 Story。
- 代替可靠 Source、文化 Reviewer 或 Story Owner。
- 用分数覆盖 Blocking Finding。
- 把未发现问题解释为 Story 已正式批准。

现有 `PhoenixJourneyContentQualityAgent`、确定性 Auditor、质量报告和相关测试属于当前实现证据。其 `approved`、`needsRevision` 与 `blocked` 结果必须被保留，但不能替代正式 Story Owner、Library Review、页面 QA 与 Release Authorization。

---

# 17. Current Story Sources and Runtime Evidence

当前仓库中可读取的 Story 与 Journey Evidence 包括：

- `app/lib/models/story_content.dart`：Source、Verification Status、Story Section 与 Content Record Model。
- `app/lib/data/daily_journey_catalog.dart`：日常普通 Journey 数据。
- `app/lib/data/extended_journey_catalog.dart` 与 Journey Expansion Catalog/Batch：扩展普通 Journey 数据。
- `app/lib/data/special_journey_catalog.dart`：特别 Journey 核心数据。
- `app/lib/data/special_journey_expansion_batch_one.dart`：特别 Journey 扩展数据。
- `app/lib/data/special_journey_story_enrichment.dart`：特别 Journey 叙事强化数据。
- `app/lib/data/all_journey_language_level_catalog.dart` 与相关 Level Catalog：等级内容与聚合输入。
- `app/lib/data/world_story_runtime.dart`：世界故事 Runtime 证据。
- `app/lib/services/journey_content_quality_auditor.dart`：确定性内容检查。
- `app/lib/agents/phoenix_world_story_agent.dart` 与 `phoenix_journey_content_quality_agent.dart`：AI 辅助 Story/Quality 行为。
- `app/tool/generate_journey_quality_report.dart`：质量报告生成入口。
- `app/test/` 下 Story、Journey、Level、Special Journey 与 Quality Tests：当前测试证据。
- `content/`：目标内容包与 Source Record 结构的早期仓库证据。

这些路径只证明相应代码、数据或结构存在于当前 Commit。

它们不自动证明：

- 全部内容已完成人工 Story Review。
- 全部 Source 与商业使用权已确认。
- 全部故事已完成 Library Review。
- 全部测试当前通过。
- 全部内容已合并 `main` 或正式发布。

使用任何数量、标题或状态前，必须从目标 Commit 重新读取并验证。

---

# 18. Status Definitions

Phoenix 必须严格区分 Documentation Status、Content Status、Implementation Status 与 Release Status。

## 18.1 Completed

只有同时满足对应范围的正式规范、批准证据、实现、测试、QA 与 Release Record，才可声称该范围已完成。

“文件已写完”只代表该 Documentation 文件完成。

“故事已写入 Catalog”只代表实现存在。

“测试通过”只代表指定 Commit、环境与测试范围通过。

它们都不单独等于正式发布。

## 18.2 In Development

以下任一情况属于开发中：

- Draft 或 Editorial Revision 尚未批准。
- Source、文化或版权 Review 未完成。
- Level Variant、翻译或 Story Consumer 尚未同步。
- Story Gate、Library Review、QA 或 Preview 尚未通过。
- 代码已存在但 Release Evidence 不完整。
- 正式 Story Documentation 正在恢复。

开发中内容不得显示为正式完成。

## 18.3 Planned

ROADMAP、设计提案、未创建文件、未写入 Catalog 的故事概念和未来 Genre 属于规划中。

规划中内容：

- 不得进入当前发布计数。
- 不得被运行时当作 Approved Story。
- 不得使用完成式描述。
- 必须等待 Requirement、Research、Documentation、Production 与全部 Gate。

## 18.4 Current Reconstruction Status

当前可以确认：

- 五份 Systems Documentation 已重建并存在。
- 六份 Visual Documentation 已恢复并存在。
- 本 Story README 在本 Sprint 重建。
- 当前代码包含普通与特别 Journey、Level Adaptation、Story Agent、Content Auditor 与测试实现。

当前不能确认：

- Story System 其余正式规范已经重建。
- 所有代码故事均已完成正式 Story、Library、QA 与 Release Gate。
- `content/` 中每个 Journey 已形成完整、可发布的独立内容包。

---

# 19. Story Change Synchronization

任何 Story 正文、结构、来源、类型、意义、人物、地点、Level 或 Version 修改，必须同步检查：

- Content Version 与 Runtime Package。
- Journey Catalog 与聚合目录。
- Phoenix Lv.1–10 Variants。
- Vocabulary、Discovery、Challenge 与 Memory。
- Visual Scene、Background、Character 与 Journey Identity。
- UI Reading Length、Paragraph、State 与 Accessibility。
- Audio Text、Locale、Pronunciation、Boundary 与 Highlight。
- AI Review、Story Tests、QA 与 Library Review。
- Preview、Release Evidence 与 CHANGELOG。

失败必须返回拥有根因的最早阶段。

不得只修改运行时显示文本、单一等级、单一翻译或单一页面副本来掩盖版本冲突。

---

# 20. Mandatory Entry Checklist

任何 Story 工作开始前必须确认：

- [ ] 已读取当前明确用户指令与 Systems Documentation。
- [ ] 已读取本 Story README 与真实存在的适用 Story 规范。
- [ ] 已确认 Ordinary 或 Special Journey。
- [ ] 已确认 Journey ID、Story ID、Version、Owner 与目标 Commit。
- [ ] 已读取当前全部相关正文、短文、Level Variant、Source 与 Journey Data。
- [ ] 已区分事实、传说、改编、争议与原创想象。
- [ ] 已确认 Learning、Visual、Audio、Content、UI 与 QA Consumer。
- [ ] 已确认当前状态是 Completed、In Development 还是 Planned。
- [ ] 未把代码存在、测试结果或 Preview 当作正式发布。
- [ ] 已定义 Story Gate、Library Review、QA 与失败返回路径。
- [ ] 缺失规范、来源、授权或证据已停止并报告。

任一强制项未满足，不得进入不可逆生产、正式导入或 Release。

---

# 21. Final Rule

Phoenix Story System 是 Story 世界、意义与文化边界的 Owner。

普通 Journey 必须让真实地点与真实生活形成可信故事。

特别 Journey 必须让文学与想象形成独特、尊重来源且内部成立的故事。

Learning 可以适配表达，但不能改写意义。

Visual 可以表达世界，但不能反向决定故事。

Audio 可以增强朗读，但不能维护另一份正文。

AI 可以生成和检查 Candidate，但不能批准自己。

QA 可以验证标准，但不能创造 Story Authority。

单篇通过不等于故事库通过，Preview 通过不等于 Release。

任何来源不明、文化真实性不明、意义不稳定、明显 AI 错误、跨等级失真、Consumer 未同步或 Gate Evidence 不完整的 Story，都不得进入 Phoenix 正式版。
