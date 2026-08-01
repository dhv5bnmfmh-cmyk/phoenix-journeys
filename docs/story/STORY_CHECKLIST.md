# Phoenix Story Release Checklist

Documentation Status: Reconstructed and Reviewed
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Pre-release Checklist)
Owner: Phoenix Story System

---

# 1. Purpose

Phoenix Story Release Checklist（简称 Story Checklist）是 Story 进入独立 Review、页面级 QA 与正式发布前的逐项检查清单。

本 Checklist 用于确认：

- Story Pipeline 的关键输出真实存在。
- Story Quality Gate 的要求具有逐项 Evidence。
- Narrative、Literature、Culture、Level、Learning、Visual 与 Audio 没有遗漏。
- Story Candidate 与当前审核版本、页面版本和发布版本一致。
- 任何禁止发布条件都能在进入 Release 前被阻断。

本 Checklist 不负责：

- 创造高于 Story Constitution、Philosophy、Decision Tree 或 Pipeline 的规则。
- 替代独立 Story Quality Gate。
- 替代 Story Review、页面级 QA 或 Release Authorization。
- 用总分覆盖事实、文化、版权、安全、文学或学习 Blocking Failure。
- 因清单未列出某项上游强制要求，就将其视为不适用。
- 声称当前仓库中的 Story 已经完成本 Checklist。

Checklist PASS 只表示本清单要求通过。

它不自动等于 Story Quality Gate PASS、Story Review PASS、Page-level QA PASS 或 Released。

---

# 2. Required Reading

执行本 Checklist 前必须读取：

1. 当前用户明确指令与任务边界。
2. `docs/systems/` 下全部适用规范。
3. `docs/story/README.md`。
4. `STORY_CONSTITUTION.md`。
5. `STORY_PHILOSOPHY.md`。
6. `STORY_DECISION_TREE.md`。
7. `STORY_PIPELINE.md`。
8. 真实存在且适用的 Story Guidelines。
9. 真实存在且适用的 Story Quality Gate 与 Review Prompt。
10. 对应 Learning、Visual、Audio、Accessibility、QA 与 Release 规范。
11. 当前完整 Story Package、Story Library、代码、测试、Branch、Commit、Preview 与 Release Evidence。

缺失必须规范或证据时不得猜测。

必须标记 `BLOCKED` 并报告缺失项。

---

# 3. Checklist Result Model

每个检查项必须选择一个结果：

- `[ ] PASS`：要求满足，Evidence 可追踪。
- `[ ] FAIL`：要求不满足，必须修正并返回指定 Stage。
- `[ ] BLOCKED`：无法判断、缺少证据或存在不可继续边界。
- `[ ] N/A`：仅用于明确的条件项，必须写明为什么不适用。

不得留空。

每个 Section 必须记录：

- Result。
- Evidence Path / ID。
- Finding。
- Owner。
- Return Stage（FAIL / BLOCKED 时）。
- Recheck Version。

`N/A` 禁止用于：

- 开场。
- 主角。
- 目标。
- 冲突。
- 关键选择。
- 情绪变化。
- 高潮或最高叙事压力点。
- 结尾。
- 人物成长或变化。
- 文学质量。
- 自然中文。
- 可朗读性。
- 文化真实性。
- AI 痕迹检查。
- 跨故事重复检查。
- Phoenix Level / 难度检查。
- 生词、发现、挑战、留下印象与盖章衔接。
- Visual 与 Audio 衔接。
- 最终评分与禁止发布检查。

普通 Journey 可以将“特别 Journey 原典精神”标为 `N/A`。

特别 Journey 可以将“城市真实性”标为 `N/A`，但若绑定真实城市或地点，该项仍必须执行。

---

# 4. Candidate Identity

在内容检查前填写：

- Journey ID：
- Story ID：
- Story Version：
- Candidate ID：
- Branch：
- Commit SHA：
- Preview / Artifact ID：
- Journey Type：Ordinary / Special
- Primary Genre：
- Phoenix Level Scope：
- Language / Locale Scope：
- Story Owner：
- Writer / AI Generation Owner：
- Literary Editor：
- Cultural Reviewer：
- Learning Reviewer：
- QA Owner：
- Checklist Reviewer：
- Checklist Date：

## Identity Checks

- [ ] PASS [ ] FAIL [ ] BLOCKED — Journey ID、Story ID、Version 与 Candidate ID 唯一且一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Branch、Commit、Preview 与被审核文件完全一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Ordinary / Special 与 Primary Genre 已通过 Decision Tree。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 当前状态没有把 Draft、In Development 或 Planned 写成 Released。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 所有 Reviewer 知道自己的责任范围。
- [ ] PASS [ ] FAIL [ ] BLOCKED — AI 生成与人工修改范围已记录。

Identity Section Result：

Evidence：

Failure Return：Stage 1 / Stage 14

Identity 任一 FAIL 或 BLOCKED：禁止继续签署 Checklist。

---

# 5. 开场 Checklist

开场负责建立继续阅读的动力，而不是先提供背景说明。

- [ ] PASS [ ] FAIL [ ] BLOCKED — 第一处叙事动作在合理范围内出现。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角或明确叙事视角能够被识别。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 当前处境、异常、欲望或问题至少有一项被建立。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 开场让读者想知道下一步，而非只展示环境。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有以城市简介、历史知识、原典解释或教学目标开场。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有依赖通用天气、晨光、薄雾、到达、醒来、信件、敲门或陌生人套式开场。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 若使用高频开场机制，已证明人物压力、目标与后续结构不可替代。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 开场与结尾存在有意义的关系，但不是机械首尾呼应。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 开场在全部 Level 中保持相同 Story Identity。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 开场脱离 Visual、Audio 与 UI 仍可成立。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 8；若定位错误返回 Stage 1。

---

# 6. 主角 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角是具体人物或具有明确处境的第二人称角色。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角不是空白摄像机、游客、听讲者或任务接收器。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角拥有与本 Journey 有关的身份、关系、记忆或责任。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角能够主动行动并影响结果。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角拥有盲点、犹豫、限制或不完美之处，而非自动正确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角的语言和行为符合年龄、身份、时代与文化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 第二人称“你”拥有本 Story 独有的角色定义。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角与故事库其他主角没有无授权重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 若属于持续角色，Series Contract 与成长连续性明确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持同一主角与人物关系。

Section Score：___ / 4

Evidence：

Finding：

Failure Return：Stage 5；定位导致的角色错误返回 Stage 1。

---

# 7. 目标 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角想得到、完成、保护、理解、寻找、归还、离开或决定的事情具体明确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 目标能够推动连续行动。
- [ ] PASS [ ] FAIL [ ] BLOCKED — “参观、了解、学习、听故事、完成 Journey”没有被当作叙事目标。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 目标来自人物处境，而非作者为了展示文化或生词而安排。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 目标属于当前城市、文化、原典或 Story Identity。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 目标具有足够重要性，使冲突与选择产生重量。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾明确回应目标是否实现、改变或被放弃。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同核心目标。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 6；目标源于错误 Journey 定位时返回 Stage 1。

---

# 8. 冲突 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突真实阻止主角直接完成目标。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突与人物、关系、城市、文化或原典发生具体关系。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突不是可轻易删除的天气、迷路、失物、赶时间或陌生人任务。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 若使用常见机制，人物代价、文化关系与后果具有不可替代性。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突在故事中升级或变得更清楚。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 外部冲突与人物内部问题彼此影响。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突不会把真实文化或群体当成障碍或奇观。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突不由学习目标、Challenge 答案或 Visual 需求强行制造。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 冲突与故事库其他 Story 没有核心机制重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同核心冲突与代价。

Section Score：___ / 4

Evidence：

Finding：

Failure Return：Stage 6；文化根因返回 Stage 3。

---

# 9. 关键选择 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角面对至少一个有意义的决定。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择的可能性不是明显正确与明显错误的假选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择揭示人物的欲望、价值、关系或变化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择具有代价、风险或不可兼得之处。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择产生可见后果。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择不是为了适配 UI 的通用二选一。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Challenge 不会反向决定 Story 中的选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选择与故事库其他 Story 的关键选择不重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同关键选择与结尾意义。

Section Score：___ / 4

Evidence：

Finding：

Failure Return：Stage 6。

---

# 10. 情绪变化 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 开场情绪状态明确但没有被过度解释。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 情绪至少发生一次有因果的变化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 情绪变化来自信息、行动、关系、后果或选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 不从头到尾只有温暖、神秘、紧张、治愈或怀旧一种氛围。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 允许复合情绪，而非强制单一积极结论。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 情绪不是由天气、音乐、Visual 或旁白宣布。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾情绪回应主角变化和关键选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 情绪曲线与故事库高频路线没有模板重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持同一情绪变化逻辑。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 7；人物或冲突根因返回 Stage 5–6。

---

# 11. 高潮 Checklist

Phoenix 短篇 Story 可以使用克制高潮，但必须存在最高叙事压力点。

- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 有一个可识别的最高压力、最难选择或最大意义转向。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高潮由前文行动与冲突自然累积。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角在高潮中行动、选择或明确拒绝选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高潮改变人物、关系、处境或理解。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高潮不依赖突然出现的新人物、能力、规则或信息解决问题。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高潮不是最高音量、最强动效、最危险事件或最长段落的同义词。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高潮没有被教学说明、词汇解释或 Challenge 提示打断。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同高潮功能。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 6–8。

---

# 12. 结尾 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾回应开场、目标、冲突、选择与变化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 事件完成；开放结尾不是中断或漏写。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物变化通过行动、关系或物件位置被看见。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾保留适量余韵，不替读者完成全部判断。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有使用“终于明白”“这个故事告诉我们”“我们应该”等总结。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有以夕阳回望、微笑离开、决定传承、梦醒、物件发光或奖励提示作为通用结束。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 反转没有取消前文全部意义或后果。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾不依赖 Stamp、Reward、Visual 或 Audio 才能完成。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾与故事库其他 Story 不重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同结尾意义。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 8；选择根因返回 Stage 6。

---

# 13. 人物成长 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 主角、关系、理解、处境或世界在结尾与开场不同。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 变化来自冲突、行动与选择，而非旅行自动使人成熟。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 成长不等于变得“正确、积极、勇敢或懂得传承”。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 若人物拒绝成长，拒绝与代价在 Story 中可见。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 变化适合人物年龄、身份与经历。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物没有由老人、老师或旁白直接告知道理后立刻改变。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结尾行动比总结更能证明变化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持相同人物变化。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 7；人物或冲突根因返回 Stage 5–6。

---

# 14. 文学质量 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 移除奖励、题目与视觉后，Story 仍有继续阅读价值。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 首先是一篇文学内容，而非教学短文、景点说明或知识包装。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物、行动、冲突、变化与语言形成统一作品。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 画面感来自人物与空间关系，不是形容词堆叠。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 具体细节参与行动、关系、文化或记忆。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 节奏有快慢、停顿与转向，不是均匀流水账。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 留白有足够线索，不是逻辑缺失。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 意义从行动与后果产生，没有强行说教。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 对儿童可追随，对成人仍保持尊重和层次。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 脱离 App 仍可独立阅读。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 为整个 Library 增加不可替代的内容。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Literary Editor 已完成独立审核并留下 Evidence。

Section Score：___ / 6

Evidence：

Finding：

Failure Return：Stage 5–10，返回最早根因阶段。

---

# 15. 自然中文 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 中文信息顺序自然，主语、指代与动作关系清楚。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 搭配符合真实中文语境。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物语言符合身份、关系、时代与压力。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有翻译腔、说明腔、论文腔或统一 AI 语气。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有连续“他开始、他继续、然后、最后”的机械推进。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有频繁使用“仿佛、似乎、不禁、终于、原来、悄然”代替变化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有“古老与现代交融”“感受文化魅力”“值得传承保护”等空泛套语。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有用成语、生僻词、长句或抽象词证明高级。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 初级表达简单但因果完整，不是短句清单。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 标点、引号、专名与中文格式正确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Language Reviewer 已完成审核。

Section Score：___ / 5

Evidence：

Finding：

Failure Return：Stage 10–11。

---

# 16. 可朗读性 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 全文已由真人大声朗读审核。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 句子拥有自然呼吸、连接与停顿。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 长短句服务叙事节奏，不是机械统一。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 段落边界符合意义和情绪转向。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 对话角色在纯音频中仍可辨识。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 专名、多音字、文化词、数字与外来语有发音 Evidence。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 连续听取时能理解人物、因果、转折与结尾。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 文本不因 TTS 限制被降格为机械句子。
- [ ] PASS [ ] FAIL [ ] BLOCKED — TTS 可播放不被当作唯一可朗读性证明。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 无音频时用户仍可完整阅读和理解。

Section Score：___ / 4

Evidence：

Finding：

Failure Return：Stage 10–11；Runtime Audio 问题返回 Audio Development / Stage 16。

---

# 17. 文化真实性 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 核心事实性 Claim 均绑定可追踪 Source。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 事实、传说、争议、版本、改编与 Phoenix 原创清楚区分。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Source Publisher、URL、Language、Access Date 与适用范围完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有编造引文、历史人物内心、地方说法或“相传”。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 文化不是地标、服饰、食物、节日或符号堆叠。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 文化通过人物生活、关系、行动与选择进入 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有把真实群体异域化、刻板化或工具化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 民族、宗教、身份、战争、灾难、死亡等敏感内容经过适当 Review。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 版权、翻译、改编与商业使用权明确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Cultural Reviewer 的身份、范围与结论可追踪。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 文化不准确没有被文学自由或学习价值覆盖。

Section Score：___ / 8

Evidence：

Finding：

Failure Return：Stage 3；Story Direction 与文化不相容时返回 Stage 1 / Stage 5–8。

来源、真实性、版权或商业使用权任一无法确认：`BLOCKED`。

---

# 18. 城市真实性 Checklist — Ordinary Journey

特别 Journey 若不绑定真实城市，可标记 `N/A` 并说明。

- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 城市、地点与 Geo Identity 正确绑定。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 地理、空间、交通、季节、天气与时间关系可信。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 当地生活细节经过可靠研究或适当验证。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 城市有人生活，不是等待参观的背景。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 地方文化真实影响人物目标、冲突或选择。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — Story 不是旅游路线、景点清单、建筑百科或宣传文案。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 没有通用“古老与现代交融”的城市描述。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 替换城市名后 Story 不再成立。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 历史与当代关系没有被简化为“传统需要传承”。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 真实居民与群体没有被异域化。

Section Score：___ / 7（Ordinary）或 N/A（Special without real-city binding）

Evidence：

N/A Reason：

Finding：

Failure Return：Stage 3 / Stage 5–8。

---

# 19. 特别 Journey 原典精神 Checklist

普通 Journey 可标记 `N/A` 并说明。

- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — Primary Genre 已明确为神话、志怪、传奇、民间文学、诗词衍生或经批准类型。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 已研究原典、早期来源、版本差异与后世演变。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 原典内容、后世解释与 Phoenix 原创清楚区分。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — Story 看得见文化根源，也看得见独立原创叙事。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — Story 不冒充原典、唯一正统版本或历史事实。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 核心问题、意象与人物关系没有被降格为游戏任务或奇幻皮肤。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 没有无理由混合时代、宗教、地域或文化符号。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 神秘感来自文化、未知、留白与内部规则，不是廉价惊吓或特效。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 没有使用通用梦、灯、雨、门、脚印、禁令、老人、信物与醒来模板。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 引用、翻译、改编与商业使用边界明确。
- [ ] PASS [ ] FAIL [ ] BLOCKED [ ] N/A — 对应 Genre / Culture Reviewer 已批准范围与原创声明。

Section Score：___ / 7（Special）或 N/A（Ordinary）

Evidence：

N/A Reason：

Finding：

Failure Return：Stage 3；类型错误返回 Stage 1；结构错误返回 Stage 5–8。

原典、版本、文化精神或权利无法确认：`BLOCKED`。

---

# 20. AI 痕迹 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 不是“到达—观看—听讲—感悟”流水账。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 段落长度、句式、转折与情绪不机械均匀。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有批量使用天气、光线、薄雾和环境形容开场。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有通用“收到物件—追随线索—面对选择—醒来”骨架。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有用“仿佛、似乎、终于、原来、悄然”等高频套词制造文学性。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有模板式文化赞叹、保护传承结论或温暖成长结尾。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物情绪由动作与关系表现，不是直接命名。
- [ ] PASS [ ] FAIL [ ] BLOCKED — AI 没有编造 Source、引文、历史、文化、原典或地方细节。
- [ ] PASS [ ] FAIL [ ] BLOCKED — AI 使用范围、输入、Candidate 与人工修改可追踪。
- [ ] PASS [ ] FAIL [ ] BLOCKED — AI 没有独立批准自己生成的 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 结构性问题通过重写解决，不是表面替词润色。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人工 Literary、Cultural 与Language Review 均已完成。

Section Score：___ / 5

Evidence：

Finding：

Failure Return：Stage 8–10；虚假事实返回 Stage 3。

明显 AI Error、编造或模板化骨架：禁止发布。

---

# 21. 跨故事重复率 Checklist

“重复率”必须同时使用可量化检查与人工结构比较。

不得只以字符串相似度判定。

- [ ] PASS [ ] FAIL [ ] BLOCKED — 使用目标 Commit 的完整普通与特别 Story Library，而非抽样。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已记录普通、特别、总 Story 与 Level Scope 数量。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查逐句与段落近似重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查主角功能与角色关系重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查目标与冲突机制重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查关键物件、线索与转折重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查关键选择与后果重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查开场机制重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查结尾机制重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已检查情绪曲线、人物成长与主题结论重复。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 已识别最相近 Story 并写明不可替代差异。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 自动相似度 Finding 已经过人工 Review。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 没有只更换城市、角色名、天气、物件或文化符号的换皮 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Series Character 的重复具有批准的 Series Contract。

Quantitative Text Similarity Evidence：

Structural Similarity Finding：

Nearest Story：

Differentiation Evidence：

Section Score：___ / 5

Failure Return：Stage 2；角色返回 Stage 5；冲突返回 Stage 6；开场/结尾返回 Stage 8。

发现核心 Story Skeleton 重复：禁止发布，必须 Merge、Rebuild 或 Reject。

---

# 22. HSK/TOCFL 与 Phoenix Level 难度 Checklist

Phoenix Lv.1–10 是面向用户的唯一难度 Identity。

HSK/TOCFL 仅用于内部校准与迁移证据，不代表官方等值。

- [ ] PASS [ ] FAIL [ ] BLOCKED — Approved Canonical Story 已先于 Level Adaptation 完成。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 所有目标 Phoenix Level 均存在完整版本。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 全部 Level 保持同一主角、目标、冲突、选择、变化与结尾意义。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 难度随 Level 连续变化，没有倒置或无差异层级。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 初级版本简单但完整，不是动作清单。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 高级版本自然但有层次，不是生僻词、成语与长句堆叠。
- [ ] PASS [ ] FAIL [ ] BLOCKED — HSK/TOCFL 词汇与难度数据只保存在内部 Calibration Evidence。
- [ ] PASS [ ] FAIL [ ] BLOCKED — UI、正文与用户说明没有官方等值声明。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 年龄、语言能力、阅读经验与 Accessibility 没有被错误绑定。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 中文、拼音、越南语、英语及适用语言意义一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 每个 Level 已完成自然中文与可朗读性检查。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 任一 Level 不依赖其他 Level 才能理解完整 Story。

Section Score：___ / 5

Evidence：

Finding：

Failure Return：Stage 11；Learning Contract 根因返回 Stage 4。

任一公开 Level 缺失或 Meaning Drift：禁止发布。

---

# 23. 生词 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — 每个生词真实出现在 Approved Story 或批准的 Learning Context 中。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 生词因人物、动作、地方、文化或选择而自然存在。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 没有为了塞词产生不自然行动或句子。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 词形、词性、拼音、释义与语境准确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 目标母语与英文释义意义一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 例句使用目标词、正确词义与词性，且不是万能占位句。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 生词数量与难度适合对应 Phoenix Level。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 不同页面使用同一 Approved Word Source。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 生词没有跨 Story 大量重复而缺乏必要性。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 生词与 Narration、Highlight 和点击边界一致。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 12；词汇目标错误返回 Stage 4；语言错误返回 Stage 11。

---

# 24. 发现 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 提供 Story 未直接讲完的新信息。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 回应 Story 留下的真实文化、历史、空间或现实问题。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 不复制、改写或总结 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 每个事实可追踪到 Source。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 事实、传说、版本、解释与原创边界清楚。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 不以资料量证明学习价值。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 与目标 Phoenix Level 和年龄/能力适配。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 与 Story 使用同一 Journey / Culture Identity。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 不提前解释 Story 的全部文学意义。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Discovery 朗读与多语言内容准确。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 12；来源不足返回 Stage 3；Story 过度说明返回 Stage 8。

---

# 25. 挑战 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — Challenge 验证 Approved Story 的人物、因果、细节、选择或意义。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 正确答案可由 Story 与批准的 Learning Contract 证明。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 没有为了暴露答案加入生硬提示句。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 选项、答案长度与干扰项不会通过形式泄露答案。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 干扰项可信但不制造文化、语言或事实错误。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Challenge 难度适合对应 Phoenix Level 与用户能力。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Feedback 无羞辱、惩罚或焦虑语言。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 尝试、奖励与完成逻辑属于 Learning System，没有写入 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Challenge 与 Story 使用同一 Approved Version。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 页面级 QA 已覆盖正确、错误、重试与完成路径。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 12；Story 因果不清返回 Stage 6 / Stage 8；难度根因返回 Stage 11。

---

# 26. 留下印象 Checklist

“留下印象”对应当前 Story 的 Memory / Reflection 连接，不定义未来 UI 名称或状态实现。

- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 留下具体的形象、动作、物件、选择、语言或文化锚点。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Memory Anchor 来自 Story，不是系统自动生成的通用总结。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 留下印象保存意义与感受，不只保存分数或答案。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 用户不被要求复述标准道理。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 内容不制造羞辱、比较或失败焦虑。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Memory 与 Story 使用同一 Approved Version。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 年龄、Level、Locale 与 Accessibility 适配成立。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 数据、隐私与持久化行为由对应系统批准，不由 Story 猜测。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 返回 Story 时 Memory 仍能对应正确情节与语言。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 12；无记忆锚点返回 Stage 7–8。

---

# 27. 盖章 Checklist

盖章是 Journey 完成的表达，不是 Story 的文学结尾。

- [ ] PASS [ ] FAIL [ ] BLOCKED — Story 在进入 Stamp 前已拥有完整文学结尾。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Stamp 对应正确 Journey、城市或 Special Identity。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Stamp 不修改 Story Meaning、结尾或文化事实。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 完成条件由 Learning / Progress Contract 定义，不由 Story 文本暗示。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Stamp 不以奖励替代阅读满足感。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Stamp 名称、符号与文化表达准确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 动画失败或 Reduced Motion 时仍有可理解完成状态。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 返回、重进与已完成状态不会错配 Story Version。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 页面级 QA 已覆盖盖章触发与保留结果。

Section Score：___ / 3

Evidence：

Finding：

Failure Return：Stage 12；Learning / UI / Animation / Code 问题返回对应 Development Stage。

---

# 28. 视觉衔接 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — Visual Brief 源自 Approved Story Contract。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 人物、地点、时间、天气、文化、情绪与 Story 一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Visual 没有反向改变主角、冲突、选择、结尾或意义。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Ordinary Journey 视觉符合真实城市与地方文化。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Special Journey 视觉尊重原典精神与 Genre，不使用通用奇幻模板。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 文字、按钮、生词与学习流程安全区完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 画面没有明显 AI Error、文化错误、重复元素或版权风险。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 动效自然且不干扰阅读；不自然时使用合格高清静态方案。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 手机、平板、方向、字体缩放与 Reduced Motion 已检查。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Performance 与静态降级完成。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Visual Quality Gate 与 Page-level QA Evidence 可追踪。

Section Score：___ / 5

Evidence：

Finding：

Failure Return：Visual Production / Page-level QA；不得改写 Story 修复 Visual。

Visual 影响阅读、按钮或学习流程：禁止发布。

---

# 29. 音频衔接 Checklist

- [ ] PASS [ ] FAIL [ ] BLOCKED — Narration 使用 Approved Story Version。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 语言、Locale、段落、句子与 Word Boundary 一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Audio 不漏读、重复、错序、增写或改写正文。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 专名、多音字、文化词与数字发音正确。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 停顿、速度与情绪服务文本，不规定唯一文学解释。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Narration Highlight 与实际声音同步。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story、Discovery、Vocabulary 等入口使用正确内容来源与语音设置。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 无声音、权限拒绝、引擎失败或网络异常时仍可完成阅读。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 返回、重进、切换 Level / Locale 后不会播放旧 Story。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 手机和平板的 Audio QA Evidence 完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Audio 没有要求 Story 为引擎限制改变 Meaning。

Section Score：___ / 5

Evidence：

Finding：

Failure Return：Audio / Content / Code Development 或 Stage 16；文本可朗读性根因返回 Stage 10–11。

Audio Version 错误、漏读或使学习流程不可完成：禁止发布。

---

# 30. Page-level and Release Evidence

- [ ] PASS [ ] FAIL [ ] BLOCKED — Story Quality Gate 为 PASS，且 Candidate ID 一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Story Pipeline Stage 1–13 Evidence 完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 当前 Checklist 的所有 Required Item 已完成。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Independent Story Review 尚未被本 Checklist 替代，并已安排或完成。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 页面级 QA 覆盖 Story、Vocabulary、Discovery、Challenge、Memory 与 Stamp。
- [ ] PASS [ ] FAIL [ ] BLOCKED — 手机、平板、Locale、Level、Accessibility、Visual 与 Audio 已覆盖。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Preview Artifact 与目标 Commit 一致。
- [ ] PASS [ ] FAIL [ ] BLOCKED — CI、自动测试、人工 Review 与回归 Evidence 完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Release Authorization、Artifact 与 Rollback Plan 完整。
- [ ] PASS [ ] FAIL [ ] BLOCKED — Checklist 后没有未审查 Story 或 Consumer 变更。

Evidence：

Finding：

Failure Return：Stage 13–17 或根因所属更早 Stage。

---

# 31. 最终评分

最终评分用于帮助 Reviewer 看见质量分布。

它不能覆盖任何 Required FAIL、BLOCKED 或禁止发布条件。

## Scoring Method

每个 Section 按证据质量与完成程度评分：

- 满分：全部核心要求明确 PASS，Evidence 完整，没有实质 Finding。
- 部分分：核心要求 PASS，但存在不阻断的明确改进项。
- 0 分：任一核心要求 FAIL、BLOCKED、无法验证或 Evidence 与 Candidate 不一致。

不得用平均分掩盖单项失败。

## Score Matrix

| Dimension | Maximum score |
| --- | ---: |
| 开场 | 3 |
| 主角 | 4 |
| 目标 | 3 |
| 冲突 | 4 |
| 关键选择 | 4 |
| 情绪变化 | 3 |
| 高潮 | 3 |
| 结尾 | 3 |
| 人物成长 | 3 |
| 文学质量 | 6 |
| 自然中文 | 5 |
| 可朗读性 | 4 |
| 文化真实性 | 8 |
| Journey 类型真实性：Ordinary 使用城市真实性；Special 使用原典精神 | 7 |
| AI 痕迹 | 5 |
| 跨故事重复率 | 5 |
| HSK/TOCFL 内部校准与 Phoenix Level 难度 | 5 |
| 生词 | 3 |
| 发现 | 3 |
| 挑战 | 3 |
| 留下印象 | 3 |
| 盖章 | 3 |
| 视觉衔接 | 5 |
| 音频衔接 | 5 |
| **Total** | **100** |

## Score Calculation

- Ordinary Journey：使用“城市真实性”7 分；“特别 Journey 原典精神”记 `N/A`，不进入加总。
- Special Journey：使用“特别 Journey 原典精神”7 分；若不绑定真实城市，“城市真实性”记 `N/A`，不进入加总。
- Special Journey 若绑定真实城市，城市真实性仍必须 PASS，但额外检查不增加总分。
- 任何必需项不得因不适用分值计算而被省略。

## Final Rating

| Score | Rating | Checklist decision |
| ---: | --- | --- |
| 95–100 | Exceptional Candidate | 仅在无 FAIL/BLOCKED、全部强制 Gate PASS 时可签署 Checklist PASS |
| 90–94 | Release-quality Candidate | 仅在无 FAIL/BLOCKED、全部强制 Gate PASS 时可签署 Checklist PASS |
| 80–89 | Needs Revision | 返回最低分或 Finding 的最早根因 Stage |
| 70–79 | Major Revision | 返回 Story Architecture / Research / Learning 的最早根因 Stage |
| 0–69 | Rebuild or Reject | 使用 Decision Tree 决定 Rebuild、Reclassify 或 Reject |

`90` 是 Checklist 的最低分数条件，不是 Release 的充分条件。

## Final Score Record

- Narrative subtotal：___ / 30
- Literature and Language subtotal：___ / 20
- Culture and Journey Identity subtotal：___ / 15
- Library and Level subtotal：___ / 10
- Learning Flow subtotal：___ / 15
- Visual and Audio subtotal：___ / 10
- **Final Score：___ / 100**
- Rating：
- Required FAIL Count：
- BLOCKED Count：
- N/A Items and Reasons：
- Story Quality Gate Result：
- Checklist Result：PASS / NEEDS REVISION / BLOCKED
- Reviewer：
- Date：
- Candidate ID / Version：

若 Subtotal 与 Section Score 不一致，Checklist 为 `BLOCKED`，直到计算与 Evidence 修正。

---

# 32. 禁止发布条件

以下任一条件出现，无论最终评分多高，Story 都禁止进入正式发布：

## Authority and Evidence

- [ ] 存在安全、法律、版权、隐私、平台或授权问题。
- [ ] Candidate ID、Story Version、Commit 或 Artifact 不一致。
- [ ] 上游规范缺失、冲突或无法确认且当前决定依赖该规范。
- [ ] Story Quality Gate 不是 PASS。
- [ ] Checklist 存在 Required FAIL、BLOCKED 或空白项。
- [ ] Independent Story Review、Page-level QA 或 Release Authorization 缺失。
- [ ] AI 生成并独立批准自己的 Story。
- [ ] Evidence 来自不同 Candidate 或过期版本。

## Narrative and Literature

- [ ] 缺少开场、独立主角、目标、冲突、关键选择、变化、高潮功能或结尾。
- [ ] Story 本质是说明文、旅游介绍、词汇容器、题目包装或 Visual Prompt。
- [ ] 存在明显 AI 流水账、模板化、批量换名、重复套路或逻辑断裂。
- [ ] 存在强行说教、标准答案结尾或用奖励代替文学结尾。
- [ ] 文学性不足且只能依靠 Visual、Audio、Reward 或 Challenge 维持兴趣。
- [ ] 中文不自然、不可理解或不可朗读。

## Culture and Rights

- [ ] 文化真实性、城市真实性或原典精神无法确认。
- [ ] 把事实、传说、争议、版本、改编或原创混写。
- [ ] 编造 Source、引文、历史、地方说法、原典或文化细节。
- [ ] 版权、翻译、改编或商业使用权不明确。
- [ ] 对真实群体存在刻板化、异域化、羞辱或不尊重。
- [ ] 普通 Journey 可无差别替换城市。
- [ ] 特别 Journey 冒充原典、唯一版本或历史事实。

## Library and Level

- [ ] 未检查目标 Commit 的完整 Story Library。
- [ ] Story Skeleton 与现有 Story 核心重复且未 Merge / Rebuild / Reject。
- [ ] 角色、冲突、开场或结尾存在未解决重复。
- [ ] 任一公开 Phoenix Level 缺失。
- [ ] 任一 Level 改变 Canonical Meaning。
- [ ] 难度与目标能力不匹配。
- [ ] 将 HSK/TOCFL 公开宣称为 Phoenix Level 的官方等值。
- [ ] 多语言、拼音或翻译改变事实、人物、因果或意义。

## Learning Flow

- [ ] 生词只能通过扭曲 Story 自然性才能出现。
- [ ] Discovery 复制 Story、缺少来源或与 Journey 无关。
- [ ] Challenge 无法由 Approved Story 作答，或 Story 被改写为答案提示。
- [ ] 留下印象没有 Story Memory Anchor，或只保存分数与标准答案。
- [ ] Stamp 被用作 Story 文学结尾，或绑定错误 Journey。
- [ ] Story 无法自然连接完整 Phoenix Learning Flow。
- [ ] Story、Vocabulary、Discovery、Challenge、Memory 与 Stamp 使用不同 Version。

## Visual, Audio and Page QA

- [ ] Visual 改写、误解或遮挡 Story。
- [ ] Visual 存在明显 AI Error、文化错误、版权风险或不合格动态且无静态降级。
- [ ] Audio 漏读、错读、重复、错序或使用旧 Story Version。
- [ ] 无 Audio 时用户无法完成阅读。
- [ ] 文字、按钮或学习流程被遮挡、截断或阻断。
- [ ] 手机或平板适配未完成。
- [ ] Accessibility、Performance、Reduced Motion 或错误路径存在 Blocking Failure。
- [ ] Preview Artifact 与目标 Release Candidate 不一致。

任一禁止发布条件被勾选：

1. Checklist Result = `BLOCKED` 或 `NEEDS REVISION`。
2. 记录对应 Finding、Evidence、Owner 与 Return Stage。
3. 停止 Story Review 下游签署、正式导入与 Release。
4. 返回 `STORY_DECISION_TREE.md` 与 `STORY_PIPELINE.md` 指定的最早根因 Stage。
5. 修改后重新执行全部受影响 Gate、Checklist、Review 与页面级 QA。

禁止通过取消勾选、提高分数、删除 Story 入口或隐藏 Finding 解除阻断。

---

# 33. Checklist Sign-off

Checklist 只有同时满足以下条件才可签署 PASS：

- [ ] Candidate Identity 全部 PASS。
- [ ] 所有 Required Item 已明确完成。
- [ ] 所有 N/A 有有效理由。
- [ ] Final Score ≥ 90。
- [ ] Required FAIL Count = 0。
- [ ] BLOCKED Count = 0。
- [ ] 禁止发布条件 = 0。
- [ ] Story Quality Gate = PASS。
- [ ] Evidence 与同一 Candidate ID、Version、Commit 和 Artifact 一致。
- [ ] Story Review 与 Page-level QA 仍将独立执行或已有同版本 PASS Evidence。
- [ ] Checklist Reviewer 不是唯一的 AI Generator。

Sign-off Result：PASS / NEEDS REVISION / BLOCKED

Checklist Reviewer：

Story Owner：

Learning Reviewer：

Cultural Reviewer：

QA Owner：

Candidate ID：

Story Version：

Commit SHA：

Sign-off Date：

Return Stage（非 PASS 时）：

Required Rechecks：

---

# 34. Final Checklist Rule

Phoenix Story Checklist 不是打勾仪式。

每一个 PASS 都必须对应真实 Story、同一 Candidate 与可复核 Evidence。

开场必须让用户想继续。

主角必须行动。

目标、冲突、关键选择、高潮、变化与结尾必须形成完整 Story。

文学质量、自然中文与可朗读性必须使 Story 脱离 App 仍值得阅读。

文化、城市与原典必须真实、尊重且权利明确。

AI 痕迹与跨故事重复必须在结构层被发现和修正。

Phoenix Level 必须保持 Canonical Meaning，HSK/TOCFL 只作内部校准。

生词、发现、挑战、留下印象与盖章必须从 Story 自然连接，而不是反向改写 Story。

Visual 与 Audio 必须服务同一 Approved Story Version。

最终评分只能显示质量分布，不能覆盖任何禁止发布条件。

任一 Required FAIL、BLOCKED、版本不一致或 Evidence 缺失，都必须停止并返回最早根因阶段。
