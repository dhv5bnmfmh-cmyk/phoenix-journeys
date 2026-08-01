# Phoenix Story Decision Tree

Documentation Status: Reconstructed
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Story Routing Standard)
Owner: Phoenix Story System

---

# 1. Purpose

Phoenix Story Decision Tree（简称 Story Decision Tree）定义 Story 需求、类型、用户适配与质量问题的唯一处理路径。

本文件用于回答：

- 这个 Journey 应进入普通 Journey 还是特别 Journey。
- 普通 Journey 应采用城市现实故事还是历史文化故事。
- 特别 Journey 属于神话、志怪、传奇、民间文学、诗词衍生或其他需要升级确认的类型。
- 同一个 Story 如何面对不同学习等级、年龄与能力用户。
- 发现故事、角色、冲突、开场、结尾、文化、文学、学习或难度问题时应返回哪里。
- Story 无法自然连接 Phoenix 学习流程时，应该修改 Story、Learning Contract，还是停止 Candidate。

本 Decision Tree 不负责：

- 创造新的 Constitution、Philosophy 或 Guidelines。
- 替代 `STORY_PIPELINE.md` 的阶段输入、动作、输出与 Gate。
- 替代 Story Quality Gate、Checklist、Review 或页面级 QA。
- 用分类决定文学质量。
- 用 AI 建议自动批准 Story。
- 声称当前 Story Catalog 已按本 Decision Tree 完成 Review。

Decision Tree 负责选择路径。

Pipeline 负责执行路径。

Gate 负责验证结果。

---

# 2. Authority

本 Decision Tree 必须服从：

1. 当前明确用户指令与合法任务边界。
2. 安全、法律、版权、隐私与平台限制。
3. Phoenix Core Product Principles。
4. Systems Architecture、Dependency、Lifecycle 与 Priority。
5. `docs/story/README.md`。
6. `STORY_CONSTITUTION.md`。
7. `STORY_PHILOSOPHY.md`。
8. 真实存在且适用的 Story Guidelines 与 Ordinary/Special Guidelines。

本文件高于 Story Pipeline、Quality Gate、Checklist 与 Review Prompt 的路径选择，但不得削弱它们的强制执行。

若本文件与 `STORY_PIPELINE.md` 出现冲突：

1. 先确认上游 Constitution、Philosophy 与 Guidelines。
2. 采用本 Decision Tree 选择的路径。
3. 修正 Pipeline 中不一致的路由描述。
4. 重新执行受影响阶段与 Gate。

无法根据上游规范作出决定时，必须停止并升级 Story Owner 与 Documentation Architecture。

---

# 3. Decision Outcomes

每个 Decision Node 只能给出以下结果：

| Outcome | Meaning | Required action |
| --- | --- | --- |
| `CONTINUE` | 当前条件满足 | 进入指定下一 Node 或 Pipeline Stage |
| `RETURN` | 根因可修正 | 返回指定 Pipeline Stage，修正后从该点重跑 |
| `RECLASSIFY` | Journey / Genre 分类错误 | 返回 Stage 1 重新定位，并使下游批准失效 |
| `REBUILD` | Story 架构不可通过局部编辑修复 | 返回指定 Story Architecture Stage 重建 |
| `SPLIT` | 一个 Candidate 混合多个独立 Story | 拆成独立 Requirement，各自从 Stage 1 开始 |
| `MERGE` | Candidate 与现有 Story 本质相同 | 合并 Requirement 或关闭重复 Candidate |
| `BLOCKED` | 来源、权利、真实性、授权或关键依赖缺失 | 停止下游生产与发布，报告解除条件 |
| `ESCALATE` | 规范无法裁决或跨系统权威冲突 | 停止并交给指定 Owner 决策 |
| `REJECT` | Candidate 与 Phoenix Story 原则根本不相容 | 关闭 Candidate，保留 Decision Record |

任何结果必须记录：

- Candidate ID。
- Story Version。
- Decision Node。
- 输入证据。
- 选择结果。
- 理由。
- Return Stage / Next Node。
- Owner。
- 受影响的下游批准。

---

# 4. Mandatory Entry Conditions

进入 Decision Tree 前必须具备：

- 当前明确需求。
- Journey 候选目标。
- 目标 Explorer。
- 当前完整 Story Library Scope。
- 已知城市、文化、历史、文学或原典线索。
- 初步 Learning Goal。
- Candidate ID 与 Owner。

缺少当前完整 Story Library：

`BLOCKED → 补齐目标 Commit 的全部普通、特别、开发中、规划中与已弃用 Story Evidence → 重新进入 Node 1`。

缺少 Candidate ID 或 Owner：

`RETURN → STORY_PIPELINE Stage 1`。

只提供一句 Prompt、一个视觉资产或一个学习词表：

`RETURN → Stage 1 建立 Journey Requirement，不得直接生成 Story`。

---

# 5. Master Decision Sequence

所有 Story Candidate 必须依次经过：

```text
Node 1  是否需要 Story？
→ Node 2  普通或特别 Journey？
→ Node 3  具体叙事类型？
→ Node 4  来源与文化路径？
→ Node 5  故事库是否重复？
→ Node 6  用户年龄、能力与 Level 路径？
→ Node 7  文学与学习是否同时成立？
→ Node 8  能否自然连接 Phoenix Learning Flow？
→ Node 9  进入 Story Pipeline 对应 Stage
```

质量检查中发现问题时，不重新从最近 Node 开始，而是使用本文件的 Failure Decision Trees 返回最早根因阶段。

---

# 6. Node 1 — 是否需要 Story

## Question

当前需求是否需要一个拥有独立主角、目标、冲突、变化、选择与结尾的 Story？

## YES

`CONTINUE → Node 2`。

## NO — 只是事实说明

若内容目标是提供历史、文化、空间或现实知识：

`RECLASSIFY → Content / Discovery System，不得用 Story 包装说明文`。

## NO — 只是词汇或语法例句

`RECLASSIFY → Learning / Content Production，不得创造假情节包裹词表`。

## NO — 只是页面、背景或 Visual Brief

`RECLASSIFY → Visual / UI Requirement，仍须读取已有 Story Contract；不得反向生成 Story`。

## UNCLEAR

`RETURN → Pipeline Stage 1，要求 Journey Owner 明确用户体验与叙事必要性`。

---

# 7. Node 2 — 普通 Journey 或特别 Journey

## Question A

Story 的世界是否以真实城市、地点、生活、历史与当代文化为基本现实？

### YES

分类为：

`普通 Journey → Node 3A`。

普通 Journey 可以包含：

- 虚构人物。
- 虚构但可信的日常事件。
- 被明确标记的传说。
- 人物的想象、记忆或梦。

只要这些内容不改变真实世界的基本规则，也不把虚构写成事实。

## Question B

Story 的核心是否依赖神话、志怪、传奇、民间文学、诗词意境、超现实规则或文学幻想？

### YES

分类为：

`特别 Journey → Node 3B`。

## BOTH

若真实城市只是特别文学世界的入口，核心冲突依赖超现实规则：

`特别 Journey → Node 3B`。

若传说或文学只是现实人物理解城市的一部分，事件仍遵守真实世界：

`普通 Journey → Node 3A`。

若两个世界各自拥有独立主角、目标、冲突与结尾：

`SPLIT → 两个 Candidate，各自从 Stage 1 开始`。

## UNCLEAR

`RETURN → Stage 1 明确 Journey Positioning；必要时先进入 Stage 3 Research，再回 Stage 1 分类`。

不得为了使用更夸张 Visual 而把普通 Journey 改成特别 Journey。

不得为了降低研究要求而把特别 Journey 改成普通 Journey。

---

# 8. Node 3A — 普通 Journey 类型

# 8.1 城市现实故事

## Question

Story 的核心是否发生在当代或可明确定位的现实城市生活中，并由现实人物、关系、工作、家庭、通勤、社区、空间或城市变化推动？

## YES

选择：

`城市现实故事`。

处理路径：

```text
Stage 3 研究当前城市、地方生活与空间
→ Stage 5 设计属于此地的现实人物
→ Stage 6 让城市条件参与冲突与选择
→ Stage 8 以生活场景建立结构
```

必须检查：

- 城市不只是地标背景。
- 当地居民不是供 Explorer 观看的文化对象。
- 生活细节有可靠研究或适当验证。
- 更换城市名后 Story 不成立。
- 冲突不依赖虚假异域化。

若 Story 只是游览、观看、听讲与感悟：

`REBUILD → Stage 5–8，建立人物目标、现实冲突与关键选择`。

若城市现实无法被可靠研究：

`BLOCKED → Stage 3`。

# 8.2 历史文化故事

## Question

Story 的核心是否由真实历史时期、文化实践、遗产空间、人物记忆、代际关系或历史与当下的连接推动？

## YES

选择：

`历史文化故事`。

处理路径：

```text
Stage 3 建立史实、争议、传说与虚构边界
→ Stage 5 选择适合的叙事视角
→ Stage 6 让历史处境产生冲突
→ Stage 8 设计不依赖讲解员的叙事结构
```

若使用真实历史人物：

- 必须提高 Source 与文化 Review 强度。
- 不得编造关键思想、引文、关系或行为并写成事实。
- 无法确认的内心活动必须谨慎处理或避免。

若使用虚构人物进入真实历史：

- 人物可以原创。
- 时代、制度、空间与生活条件必须可信。
- 原创情节不得改变关键史实。

若 Story 主要是历史知识说明：

`RETURN → Stage 5–8，将历史放入人物行动；无法形成 Story 时 RECLASSIFY → Discovery`。

若核心依赖传说中的超现实事件真实发生：

`RECLASSIFY → 特别 Journey / Node 3B`。

# 8.3 城市现实与历史文化同时存在

## Question

当前人物的现实目标是否因历史空间、文化记忆或代际关系而改变？

### YES

保持普通 Journey，标记：

`Primary: 城市现实故事；Secondary: 历史文化`，或反向标记。

Primary Type 由核心冲突发生的时间与人物目标决定。

### NO

若历史信息只作为插入说明：

`RETURN → Stage 8 删除说明性插入，移交 Discovery`。

若两个方向各有完整 Story：

`SPLIT`。

---

# 9. Node 3B — 特别 Journey 类型

特别 Journey 必须选择一个 Primary Genre。

可以记录 Secondary Influence，但不能以“混合类型”逃避原典、文化与结构责任。

# 9.1 神话

## Question

Story 是否以神、创世、宇宙秩序、神圣人物、神话空间、仪式性意象或长期流传的神话叙事为核心来源？

## YES

选择：

`神话`。

处理路径：

```text
Stage 3 研究早期来源、多个版本与后世形象
→ 标记哪些属于原典、演变与 Phoenix 原创
→ Stage 5–8 建立新人物或新视角
→ Story Review 增加 Mythology / Culture Reviewer
```

若把后世熟悉版本写成唯一原典：

`RETURN → Stage 3`。

若把神话写成历史事实：

`BLOCKED → Stage 3 修正 Fact / Myth Status`。

若只借用神名、宝物或视觉符号：

`REBUILD → Stage 1 / Stage 3；文化意象必须参与核心问题`。

# 9.2 志怪

## Question

Story 是否以现实秩序中的异常、鬼神精怪、不可完全解释的事件、短促记录感或人与未知的接触为核心？

## YES

选择：

`志怪`。

处理路径：

```text
Stage 3 研究志怪传统、来源与时代语境
→ Stage 6 设计人与异常的具体冲突
→ Stage 7 保留克制、未知与复合情绪
→ Stage 8 使用有线索的留白，不用逻辑缺失制造神秘
```

若只靠暴雨、敲门、影子、脚印、禁令或鸡鸣：

`RETURN → Stage 2 比较全库；重复则 REBUILD → Stage 6–8`。

若主要目标是恐吓：

`REJECT`，除非重新定位为有文化与人物意义的 Story。

若未知没有内部线索：

`RETURN → Stage 8`。

# 9.3 传奇

## Question

Story 是否以具有完整人物弧线、命运变化、爱情、侠义、奇遇、社会关系或唐传奇及相关叙事传统为核心？

## YES

选择：

`传奇`。

处理路径：

```text
Stage 3 研究具体传奇传统、文本与时代关系
→ Stage 5 建立复杂人物欲望与社会位置
→ Stage 6 设计选择、代价与命运转折
→ Stage 8 保持完整人物弧线，不缩成奇遇摘要
```

若“传奇”只是“很神奇的故事”的泛称：

`RETURN → Stage 1 重新分类`。

若人物只是被奇遇带着走：

`RETURN → Stage 5–6`。

若原作受版权保护且改编权不明：

`BLOCKED → Stage 3 Copyright Review`。

# 9.4 民间文学

## Question

Story 是否来自民间故事、地方传说、口述传统、歌谣、节俗叙事、地方英雄或群体长期共享的叙事？

## YES

选择：

`民间文学`。

处理路径：

```text
Stage 3 记录地区、讲述群体、版本与采集来源
→ 区分地方版本、后世整理与 Phoenix 原创
→ Stage 5–8 保留地方逻辑与人物关系
→ Cultural Review 检查群体尊重与商业使用边界
```

若找不到具体地区、群体或版本：

`BLOCKED → Stage 3；不得写成“相传”后继续`。

若多个地方版本互相不同：

`CONTINUE → 明确选择依据，并在 Source Record 保留差异；不得宣布唯一版本`。

若把真实群体写成猎奇对象：

`REBUILD → Stage 3 / Stage 5，必要时 REJECT`。

# 9.5 诗词衍生故事

## Question

Story 是否从诗、词、曲或古典诗性意象出发，扩展人物、处境、动作与选择？

## YES

选择：

`诗词衍生故事`。

处理路径：

```text
Stage 3 核对原作、作者、时代、文本版本与语境
→ 识别诗中明确内容与后世解释
→ Stage 5–8 创造独立 Story，不把诗意改写成散文说明
→ Review 检查新故事是否保留原作精神且清楚标记原创
```

若只是逐句翻译或扩写诗词画面：

`RECLASSIFY → Discovery / Literary Explanation，或 REBUILD → Stage 5–8`。

若把后世解读写成作者唯一意图：

`RETURN → Stage 3`。

若引用文本存在版本或版权问题：

`BLOCKED → Stage 3`。

若新 Story 没有独立主角、目标、冲突、变化、选择与结尾：

`REBUILD → Stage 5–8`。

# 9.6 多类型或无法分类

若一个 Story 同时受神话、志怪、传奇、民间文学或诗词影响：

1. 以核心冲突依赖的传统选择 Primary Genre。
2. 将其他来源记录为 Secondary Influence。
3. 分别完成对应 Source 与文化检查。

若没有任何 Genre 对核心冲突具有决定作用：

`RETURN → Stage 1，明确特别 Journey 为什么必须存在`。

若多个 Genre 各自拥有独立主角与完整事件：

`SPLIT`。

若属于尚未规范的新 Genre：

`ESCALATE → Story Owner / Documentation Review；在 Genre Contract 批准前 BLOCKED`。

---

# 10. Node 4 — 来源与文化路径

## Question 1

所有核心事实、文化细节、原典关系、版本与改编边界是否可追踪？

### YES

`CONTINUE → Node 5`。

### NO — 可以补充研究

`RETURN → Pipeline Stage 3`。

### NO — 来源不存在或无法确认

`BLOCKED`。

不得用：

- “据说”。
- “相传”。
- “古人认为”。
- “当地人一直相信”。
- AI 生成的引用。
- 无法定位的网页摘要。

掩盖来源缺失。

## Question 2

内容是否涉及真实群体、宗教、民族、身份、灾难、战争、死亡或其他敏感文化？

### YES

`CONTINUE WITH REQUIRED REVIEW → Stage 3 指定合格 Cultural Reviewer`。

若没有合格 Reviewer 或必要证据：

`BLOCKED`。

## Question 3

版权、翻译、改编与商业使用权是否明确？

### YES

`CONTINUE → Node 5`。

### NO

`BLOCKED → Stage 3 Copyright / Legal Review`。

文化真实性不足不能由文学自由、学习价值或用户喜欢覆盖。

---

# 11. Node 5 — 故事库重复检查

重复必须比较完整 Story Library，并分别回答以下问题。

# 11.1 故事过于相似

## Question

Candidate 是否与现有 Story 共享大部分核心组合：主角功能、目标、冲突、关键物件、转折、选择、变化与结尾？

### NO

`CONTINUE → Node 6`。

### YES — 相同 Story 的合理版本

若只是同一 Canonical Story 的 Level、语言或无意义改变的格式版本：

`MERGE → 现有 Story Version / Level Pipeline，不创建新 Story`。

### YES — Journey 需求本质重复

`MERGE 或 REJECT → Pipeline Stage 1`。

### YES — 主题相同但可形成独立作品

必须至少重建核心叙事组合：

`REBUILD → Stage 5–8 → 重跑 Library Originality Gate`。

不得只更换城市、时代、角色名、天气或文化物件。

# 11.2 角色重复

## Question

主角是否再次成为相同的空白 Explorer、年轻游客、讲解员学生、听老人讲故事的人、失物寻找者或被动接受任务者？

### NO

`CONTINUE`。

### YES — 同一持续角色且有正式 Series Contract

`CONTINUE WITH SERIES REVIEW`，必须确认：

- 关系与成长连续。
- 本篇目标、冲突、选择与变化独立。
- 新 Story 不依赖读者完成旧 Story 才能理解。

任一不满足：

`RETURN → Stage 5`。

### YES — 无 Series Contract

`REBUILD → Stage 5`。

若角色重复来自 Journey Positioning：

`RETURN → Stage 1`。

# 11.3 冲突重复

## Question

冲突是否再次依赖迷路、失物、赶时间、修复旧物、陌生人请求、传统即将消失、禁令不可违反或二选一？

### NO

`CONTINUE`。

### YES — 表面机制相同但人物代价与文化关系不同

`CONTINUE WITH DEEP COMPARISON → Stage 6`，必须证明：

- 主角想要的不同。
- 受阻原因不同。
- 选择代价不同。
- 变化与结尾不同。

证明失败：

`REBUILD → Stage 6`。

### YES — 核心机制与后果相同

`REBUILD → Stage 1 / Stage 6`。

# 11.4 开场重复

## Question

开场是否重复到达城市、醒来、收到信物、天气描写、迷路、敲门、发现异常物件或被陌生人搭话？

### NO

`CONTINUE`。

### YES — 开场只是表面重复

检查它是否立即建立独立人物目标与当前压力。

若是：

`CONTINUE WITH EDITORIAL NOTE`。

若否：

`RETURN → Stage 8 重建 Opening Contract`。

若全库高频开场模式明显：

`REBUILD → Stage 2 / Stage 8`。

# 11.5 结尾重复

## Question

结尾是否重复“终于明白”、夕阳回望、微笑离开、决定传承、梦醒、物件发光、归还信物或开放二选一？

### NO

`CONTINUE`。

### YES — 回环是本 Story 必要结构

必须证明：

- 结尾回应本篇独有开场。
- 选择产生独有后果。
- 人物变化可由行动看见。
- 不是通用道德总结。

证明成立：

`CONTINUE`。

证明失败：

`REBUILD → Stage 6–8`。

若结尾只是 Learning Summary：

`RETURN → Stage 8 / Stage 10；学习总结移交 Learning System`。

---

# 12. Node 6 — 不同学习等级

Phoenix 面向 Lv.1–10。

HSK/TOCFL 只作为内部校准证据，不向用户宣称官方等值。

# 12.1 是否已有 Approved Canonical Story

## YES

`CONTINUE → Pipeline Stage 11 Level Adaptation`。

## NO

`RETURN → Stage 5–10，先完成 Canonical Story；禁止直接批量生成 Level Variants`。

# 12.2 初级用户路径

若目标 Explorer 语言能力较低：

```text
保留主角、目标、冲突、选择与结尾
→ 降低词汇与句法负担
→ 增加必要语言支持
→ 保持完整因果
→ 执行 Read-aloud 与 Meaning Preservation Review
```

若简化后 Story 变成动作清单：

`RETURN → Stage 11；必要时 Stage 8 重设可分级结构`。

若必须删除核心冲突才能理解：

`RETURN → Stage 4 / Stage 8，不得发布该 Level`。

# 12.3 中级用户路径

```text
保持完整 Story
→ 减少显性解释
→ 增加自然连接与人物语言
→ 让 Vocabulary / Discovery 承担扩展
→ 检查难度连续性
```

若与低级或高级版本没有实质难度差异：

`RETURN → Stage 11`。

# 12.4 高级用户路径

```text
保持 Canonical Meaning
→ 增加必要的语言细度、含蓄与文化表达
→ 不增加无关典故或生僻词
→ 保持自然中文与可朗读性
```

若高级化只是词汇替换或长句堆叠：

`RETURN → Stage 11`。

若高级版本增加新情节、改变人物或结尾：

`REBUILD → Stage 11；若新内容值得独立 Story，则 SPLIT → Stage 1`。

# 12.5 跨等级一致性

若任一 Level 改变主角、目标、冲突、关键选择、文化事实、变化或结尾意义：

`BLOCKED → Stage 11，全部下游 Gate 失效`。

若某 Level 缺失：

`BLOCKED → Stage 11`。

若不同 Level 的语言难度顺序不连续：

`RETURN → Stage 11`。

全部通过：

`CONTINUE → Node 7`。

---

# 13. Node 6B — 不同年龄和能力用户

年龄与语言能力必须分开判断。

儿童不自动等于初级语言用户。

成人不自动等于高级语言用户。

认知能力、阅读经验、语言能力、Accessibility 需求与内容敏感度必须分别记录。

# 13.1 儿童用户

## Question

儿童是否能识别主角、目标、行动、冲突变化与结尾？

### YES

继续检查：

- 内容安全但不空洞。
- 语言不居高临下。
- 不用道德答案替代故事。
- 敏感内容有适龄处理。
- 学习失败不与人物价值绑定。

全部满足：

`CONTINUE`。

### NO — 语言负担过高

`RETURN → Stage 11`。

### NO — Story Architecture 无法追随

`RETURN → Stage 8`。

### NO — 内容强度不适龄

`RETURN → Stage 1 / Stage 3 / Stage 7，重新定位、研究或调整情绪路径`。

不得通过删除冲突与人物复杂性把 Story 幼儿化。

# 13.2 成人用户

## Question

成人是否仍能相信人物动机、尊重文化层次，并在结尾获得非说教的余韵？

### YES

`CONTINUE`。

### NO — 语言幼稚化

`RETURN → Stage 10 / Stage 11`。

### NO — 冲突与人物扁平

`RETURN → Stage 5–7`。

### NO — 文化过度简化

`RETURN → Stage 3 / Stage 8`。

# 13.3 同时服务儿童与成人

若儿童可追随行动，成人可读出关系与余韵：

`CONTINUE`。

若只能为其中一方成立：

1. 先判断是否是语言难度问题。
2. 是：`RETURN → Stage 11` 建立适配版本。
3. 否：`RETURN → Stage 5–10` 重建共同 Story Core。

不得建立意义不同的“儿童版”和“成人版”冒充同一 Level Family。

# 13.4 能力与 Accessibility

若用户需要更清楚语言、更大文字、无音频、Reduced Motion 或其他支持：

- Story Meaning 不改变。
- Learning / UI / Audio / Accessibility 提供适当支持。

若内容只有通过 Audio 才能理解：

`RETURN → Stage 10 / Stage 16 Page-level QA`。

若页面或视觉让目标用户无法阅读：

`RETURN → 对应 UI / Visual / Accessibility Development；不得削弱 Story`。

年龄与能力路径通过后：

`CONTINUE → Node 7 Quality Balance`。

---

# 14. Node 7 Quality Balance — 文学与学习是否同时成立

# 14.1 文学性不足

## Question

Story 是否缺少继续阅读动力、具体人物、叙事行动、冲突重量、情绪变化、语言生命或结尾余韵？

### NO

`CONTINUE → 14.2`。

### YES — 人物问题

`RETURN → Stage 5`。

### YES — 目标、冲突、选择或后果问题

`RETURN → Stage 6`。

### YES — 情绪与成长问题

`RETURN → Stage 7`。

### YES — 场景、结构、留白、开场或结尾问题

`RETURN → Stage 8`。

### YES — 语言、节奏、朗读或 AI 痕迹问题

`RETURN → Stage 10`。

若 Story 本质只是说明文或教学材料：

`RECLASSIFY 或 REJECT → Stage 1`。

不得用 Visual、Audio、奖励、题目或高级词汇覆盖文学性不足。

# 14.2 学习价值不足

## Question

Story 是否缺少可理解语境、自然词汇机会、可扩展 Discovery、可验证理解、Memory Anchor 或 Level Adaptation 可能？

### NO

`CONTINUE → 14.3`。

### YES — 学习目标不适合 Story

`RETURN → Stage 4，修改 Learning Objective`。

### YES — Story 语境不清

`RETURN → Stage 8 / Stage 10`。

### YES — 无自然 Vocabulary Opportunity

先调整 Vocabulary 目标：

`RETURN → Stage 4 / Stage 12`。

不得为词表改坏人物行动。

### YES — 无可扩展 Discovery

若缺少研究：`RETURN → Stage 3`。

若 Story 已讲完全部知识：`RETURN → Stage 8 / Stage 12`，移动说明内容。

### YES — Challenge 无法验证理解

若 Story 因果不清：`RETURN → Stage 6 / Stage 8`。

若只是题目设计错误：`RETURN → Stage 12`。

### YES — 无 Memory Anchor

`RETURN → Stage 7 / Stage 8`。

不得用重复总结制造学习价值。

# 14.3 文学价值与学习价值互相破坏

若学习目标要求不自然语言、说教、重复解释或改变结尾：

`RETURN → Stage 4，优先重设 Learning Contract`。

若文学表达导致目标用户无法识别人物、行动与意义：

`RETURN → Stage 10 / Stage 11`。

若无法在当前 Story 中同时成立：

`REBUILD → Stage 1 / Stage 4 / Stage 8；在新方案 PASS 前 BLOCKED`。

不得默认牺牲文学或学习中的任何一方。

全部通过：

`CONTINUE → Node 8`。

---

# 15. Node 8 — 难度是否匹配

## Question 1

目标 Phoenix Level 的词汇、句法、段落密度、明示程度与阅读负担是否适合目标能力？

### YES

继续 Question 2。

### NO — 过难

`RETURN → Stage 11`，允许：

- 降低词汇负担。
- 调整句法。
- 缩短但不打断因果。
- 增加必要语言支持。

禁止：

- 删除主角目标。
- 删除核心冲突。
- 改变文化事实。
- 改变选择与结尾。

### NO — 过易

`RETURN → Stage 11`，允许增加语言细度、自然连接、含蓄与文化表达。

禁止用生僻词、成语、长句或典故堆叠伪造难度。

## Question 2

目标年龄与语言能力是否被错误绑定？

### YES

`RETURN → Stage 4 / Stage 11，拆分 Age、Language、Cognitive 与 Accessibility Profile`。

### NO

继续 Question 3。

## Question 3

HSK/TOCFL 是否只作为内部校准，并保持 Phoenix Level 为公开难度 Identity？

### YES

`CONTINUE → Node 9`。

### NO

`RETURN → Stage 4 / Stage 11，移除官方等值声明并重做校准记录`。

若难度不匹配无法在不改变 Story Meaning 的情况下修正：

`BLOCKED → Stage 4 / Stage 8 联合重设`。

---

# 16. Node 9 — 能否自然连接 Phoenix 学习流程

当前 Story 必须能够自然连接：

```text
Story
→ Vocabulary
→ Discovery
→ Challenge
→ Memory
→ Stamp
```

若正式 Learning Contract 更新流程，使用当前批准流程，但仍执行以下判断。

# 16.1 Vocabulary Connection

## Question

是否存在从真实人物、行动、文化与选择中自然出现的值得学习词语？

### YES

`CONTINUE → 16.2`。

### NO

先检查目标词是否错误：

- 是：`RETURN → Stage 4 / Stage 12`。
- 否，Story 语言空泛：`RETURN → Stage 10`。
- 无法自然产生任何语言学习机会：`REBUILD → Stage 4 / Stage 8`。

不得把目标词硬塞回正文。

# 16.2 Discovery Connection

## Question

Story 是否留下可由可靠文化、历史、空间或现实信息扩展的问题？

### YES

`CONTINUE → 16.3`。

### NO — Story 已把资料全部讲完

`RETURN → Stage 8 / Stage 12，将说明性内容移出 Story`。

### NO — 缺少研究深度

`RETURN → Stage 3`。

### NO — Story 与文化无真实关系

`REBUILD → Stage 1 / Stage 3 / Stage 8`。

# 16.3 Challenge Connection

## Question

Challenge 能否依据 Story 的人物、因果、细节、选择或意义验证理解？

### YES

`CONTINUE → 16.4`。

### NO — Story 因果或信息不足

`RETURN → Stage 6 / Stage 8`。

### NO — 题目设计错误

`RETURN → Stage 12`。

### NO — 必须在正文加入答案句才可出题

`RETURN → Stage 4 / Stage 12，修改 Challenge，不改坏 Story`。

# 16.4 Memory Connection

## Question

Story 是否留下一个具体形象、动作、物件、选择、语言或文化记忆锚点？

### YES

`CONTINUE → 16.5`。

### NO

- 情绪无变化：`RETURN → Stage 7`。
- 结构无回响：`RETURN → Stage 8`。
- 语言无具体性：`RETURN → Stage 10`。
- Memory 设计错误：`RETURN → Stage 12`。

# 16.5 Full Flow Connection

## Question

所有学习环节是否指向同一 Approved Story Version，并保护 Story 节奏、意义与无焦虑体验？

### YES

`CONTINUE → Story Pipeline Stage 13 Story Quality Gate`。

### NO — Version 不一致

`BLOCKED → Stage 12，同步 Consumer Version`。

### NO — 学习环节打断阅读或改变意义

`RETURN → Stage 4 / Stage 12；必要时 Learning Architecture Review`。

### NO — Story 只有依赖 UI、Visual 或 Audio 才能成立

`RETURN → Stage 8 / Stage 10`。

若经过重设仍无法自然连接完整 Phoenix Learning Flow：

`REJECT 或 RECLASSIFY → Stage 1`。

不能因为 Story 文学性较好就绕过 Learning Integration Gate。

---

# 17. Quality Failure Decision Tree

当 Story Quality Gate、Checklist、Review 或页面级 QA 发现问题时，使用以下路径。

# 17.1 文化真实性不足

## Is the problem missing evidence?

- YES → `RETURN Stage 3`。
- NO → 继续。

## Is fact, legend, version, adaptation or original content mislabeled?

- YES → `RETURN Stage 3`；修正后重审所有受影响正文、Discovery、Visual 与 Audio。
- NO → 继续。

## Is the Story direction incompatible with verified culture or original-text spirit?

- YES → `REBUILD Stage 1 / Stage 5–8`。
- NO → 继续。

## Is copyright or commercial use unclear?

- YES → `BLOCKED Stage 3`。

文化真实性不足时禁止只修改几个名词继续发布。

# 17.2 文学性不足

## Is the content not actually a Story?

- YES → `RECLASSIFY or REJECT Stage 1`。
- NO → 继续。

## Is the protagonist passive or generic?

- YES → `RETURN Stage 5`。

## Are goal, conflict and choice weak?

- YES → `RETURN Stage 6`。

## Is emotional movement absent?

- YES → `RETURN Stage 7`。

## Are structure, opening, ending or white space weak?

- YES → `RETURN Stage 8`。

## Is language mechanical, explanatory or AI-like?

- YES → `RETURN Stage 10`；若结构也模板化，返回 Stage 8。

# 17.3 学习价值不足

## Is the Learning Objective wrong?

- YES → `RETURN Stage 4`。

## Is the Story incomprehensible at the target Level?

- YES → `RETURN Stage 11`；若 Meaning 无法保留，返回 Stage 4 / Stage 8。

## Are Vocabulary, Discovery, Challenge or Memory disconnected?

- YES → `RETURN Stage 12`；若暴露 Story 根因，返回对应 Stage 3–10。

## Does the Story create no meaningful learning opportunity?

- YES → `REBUILD Stage 1 / Stage 4 / Stage 8`；仍失败则 `REJECT`。

# 17.4 难度不匹配

- 词汇/句法问题 → `RETURN Stage 11`。
- 情节因果对目标用户不清 → `RETURN Stage 8 / Stage 11`。
- 内容强度与年龄不匹配 → `RETURN Stage 1 / Stage 3 / Stage 7`。
- Accessibility 支持不足 → `RETURN Learning/UI/Audio/Accessibility Development`。
- Level Meaning Drift → `BLOCKED Stage 11`。
- HSK/TOCFL 被公开当作官方等值 → `RETURN Stage 4 / Stage 11`。

# 17.5 无法自然连接学习流程

- Vocabulary 不自然 → `RETURN Stage 4 / Stage 12`。
- Discovery 重复 Story → `RETURN Stage 8 / Stage 12`。
- Challenge 无法由 Story 作答 → `RETURN Stage 6 / Stage 8 / Stage 12`，依根因。
- Memory 没有锚点 → `RETURN Stage 7 / Stage 8 / Stage 12`。
- Consumer Version 不一致 → `BLOCKED Stage 12`。
- 整体流程仍无法成立 → `RECLASSIFY or REJECT Stage 1`。

---

# 18. Compound Failure Priority

同一 Candidate 同时出现多个失败时，按最早根因处理：

1. 安全、法律、版权、授权或平台问题 → `BLOCKED`。
2. Journey 定位或类型错误 → Stage 1。
3. 故事库重复 → Stage 2。
4. 文化、城市、原典或 Source 错误 → Stage 3。
5. Learning Objective 错误 → Stage 4。
6. 角色错误 → Stage 5。
7. 目标、冲突与选择错误 → Stage 6。
8. 情绪与成长错误 → Stage 7。
9. 场景、结构、开场与结尾错误 → Stage 8。
10. 初稿偏离结构 → Stage 9。
11. 文学语言、朗读与 AI 痕迹错误 → Stage 10。
12. Level、年龄/能力表达与多语言错误 → Stage 11。
13. Learning Flow 衔接错误 → Stage 12。
14. Gate、Checklist、Review 或 QA Evidence 错误 → 对应 Stage 13–16。

例如：

若文本同时“文化不准确、语言机械、难度过高”，必须先返回 Stage 3。

不得只在 Stage 11 降低难度后继续。

---

# 19. Ordinary Journey Summary Route

```text
真实世界是否是基础？
├─ 否 → 特别 Journey Route
└─ 是
   ├─ 当代城市生活推动冲突？
   │  └─ 是 → 城市现实故事
   ├─ 历史/文化处境推动冲突？
   │  └─ 是 → 历史文化故事
   ├─ 两者共同推动？
   │  └─ 选择 Primary Type，Secondary Influence 留档
   └─ 都不是
      └─ RETURN Stage 1；可能不是 Story
```

无论选择哪条普通 Journey 路径，都必须：

- 进入 Stage 3 研究。
- 通过地方文化真实性检查。
- 让城市参与人物行动。
- 禁止旅游说明与换名模板。
- 继续执行全部 Pipeline Gate。

---

# 20. Special Journey Summary Route

```text
特别文学世界是否是核心？
├─ 否 → 普通 Journey Route
└─ 是
   ├─ 神与宇宙/神圣秩序 → 神话
   ├─ 现实中的异常与未知 → 志怪
   ├─ 完整人物命运与奇遇传统 → 传奇
   ├─ 地方口述与群体流传 → 民间文学
   ├─ 诗词文本与诗性意象衍生 → 诗词衍生故事
   ├─ 多种影响 → 选择 Primary Genre
   └─ 无法分类 → ESCALATE / BLOCKED
```

无论选择哪条特别 Journey 路径，都必须：

- 研究原典、版本、演变与文化精神。
- 标记 Phoenix 原创范围。
- 确认版权与商业使用边界。
- 设计独立主角、目标、冲突、选择与结尾。
- 禁止通用 AI 奇幻模板。
- 继续执行全部 Pipeline Gate。

---

# 21. Age and Ability Summary Route

```text
先分离四个维度
├─ 年龄与内容敏感度
├─ 中文语言能力
├─ 阅读/认知经验
└─ Accessibility 需求

再决定
├─ Story Core 是否共同成立？
│  ├─ 否 → RETURN Stage 5–10
│  └─ 是
├─ 只是语言负担不同？
│  └─ 是 → Stage 11 Level Adaptation
├─ 只是呈现/访问需求不同？
│  └─ 是 → Learning/UI/Audio/Accessibility Support
└─ Meaning 被改变？
   └─ BLOCKED → Stage 4 / Stage 11
```

---

# 22. Decision Record Requirements

每次分类、重建、合并、拆分、阻断或拒绝必须记录：

- Story / Journey ID。
- Candidate Version。
- Decision Date。
- Decision Owner。
- Decision Node。
- 读取的 Documentation。
- 比较的 Story Library Commit 与 Scope。
- Source / Culture Evidence。
- Age / Ability / Level Profile。
- Selected Route。
- Rejected Alternatives。
- Return Stage。
- Downstream Invalidation。
- Required Re-review。

不得通过删除 Candidate、隐藏入口或改变文件名消除 Decision Evidence。

---

# 23. AI Execution Rules

未来 AI 使用本 Decision Tree 时必须：

1. 一次只回答当前 Decision Node。
2. 显示使用了哪些输入与证据。
3. 不用概率最高的 Genre 代替来源判断。
4. 不因关键词“月、梦、鬼、灯”自动分类。
5. 读取完整 Story Library 后再判断重复。
6. 分开比较角色、冲突、开场与结尾。
7. 分开判断年龄、语言能力、认知与 Accessibility。
8. 将 HSK/TOCFL 保留为内部校准。
9. 对缺失 Source 输出 `BLOCKED`，不补写事实。
10. 对复合失败返回最早根因阶段。
11. 不批准自己刚生成的 Story。
12. 记录 Selected Route 与所有失效下游 Gate。

AI 禁止输出：

- “看起来像神话，所以通过”。
- “主题不同，所以不重复”。
- “换一个主角即可解决”。
- “降低几个词就适合儿童”。
- “加入生词和问题即可增加学习价值”。
- “添加文化元素即可提高真实性”。
- “润色后即可消除 AI 痕迹”。

这些都不是可执行 Decision。

---

# 24. Mandatory Decision Checklist

在进入 Story Pipeline 下游 Gate 前必须确认：

- [ ] 已确认内容确实需要 Story。
- [ ] 已确认普通 Journey 或特别 Journey。
- [ ] 普通 Journey 已选择城市现实、历史文化或明确 Primary Type。
- [ ] 特别 Journey 已选择神话、志怪、传奇、民间文学、诗词衍生或经批准新 Genre。
- [ ] 已完成 Source、文化、原典、版本、版权与原创边界判断。
- [ ] 已读取完整故事库并检查故事整体相似度。
- [ ] 已分别检查角色、冲突、开场与结尾重复。
- [ ] 已区分年龄、语言能力、认知经验与 Accessibility。
- [ ] 已确认所有 Level 保持 Canonical Meaning。
- [ ] 已确认文学价值与学习价值同时成立。
- [ ] 已确认难度匹配且 HSK/TOCFL 仅作内部校准。
- [ ] 已确认 Vocabulary、Discovery、Challenge 与 Memory 可自然衔接。
- [ ] 无法自然连接完整 Phoenix Flow 的 Candidate 已返回、重分类或拒绝。
- [ ] 所有失败都有明确 Return Stage、Owner 与 Downstream Invalidation。
- [ ] 所有 `BLOCKED` 项在解除前未进入下游或正式发布。

任一强制项未满足，Decision Tree Result 不得标记为 PASS。

---

# 25. Final Decision Rule

Phoenix 不从题材名称开始写 Story。

Phoenix 先判断：

- 这个世界是真实还是文学超现实。
- 这个传统是什么。
- 这个城市或原典如何进入人物行动。
- 这篇 Story 是否真正不同。
- 哪个用户将如何进入同一个 Canonical Meaning。
- 文学与学习能否彼此保护。
- Story 能否自然进入 Phoenix Learning Flow。

普通 Journey 必须选择真实、具体且属于地方的路径。

特别 Journey 必须选择尊重原典、版本与文化精神的路径。

故事过于相似必须合并、重建或拒绝。

角色、冲突、开场与结尾重复必须分别处理，不能只更换表面元素。

文化真实性不足返回 Research 或直接 Blocked。

文学性不足返回 Story Architecture 或 Literary Editing 的最早根因阶段。

学习价值不足返回 Learning Objective、Story Structure 或 Integration Stage。

难度不匹配返回 Level Adaptation，不得改变 Canonical Meaning。

无法自然连接 Phoenix 学习流程的 Candidate 不得进入正式版。

任何无法由本 Decision Tree 与上游规范明确裁决的情况，都必须停止并报告，不能由 AI、Writer、Code 或既有实现自行决定。
