# Phoenix System Architecture

Documentation Status: Reconstructed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest)
Owner: Phoenix System Architecture

---

# 1. Purpose

Phoenix System Architecture（简称 PSA）定义 Phoenix Professional Systems 的正式系统边界、依赖方向与接口关系。

本文件回答：

- Phoenix 由哪些系统组成。
- 每个系统为什么存在。
- 每个系统负责什么。
- 每个系统不负责什么。
- 系统之间如何交换输入与输出。
- 哪些依赖可以存在。
- 哪些职责不得跨越。
- 当前仓库中哪些结构能够作为实现证据。
- 哪些能力仍处于开发中或规划中。

本文件不负责：

- 替代各 System 的 Constitution、Philosophy、Guidelines、Pipeline 或 Gate。
- 声称代码文件存在就代表正式能力完成。
- 定义具体页面设计、Story 内容、视觉样式、音频参数或发布命令。
- 绕过 `docs/systems/README.md` 的 Documentation Navigation。

任何 Professional System 的详细规则，必须在该 System 自己的正式 Documentation 中定义。

---

# 2. Authority

本文件位于：

```text
Phoenix Constitution and Product Principles

↓

Documentation System README

↓

SYSTEM_ARCHITECTURE

↓

SYSTEM_DEPENDENCY

↓

SYSTEM_LIFECYCLE

↓

SYSTEM_PRIORITY

↓

Professional System Documentation

↓

Implementation
```

本文件拥有：

- 系统划分权。
- 系统职责边界定义权。
- 系统级输入输出定义权。
- 系统接口方向定义权。

本文件不拥有：

- Professional System 内部规则解释权。
- 产品宪法修改权。
- Visual Constitution 修改权。
- 功能完成状态批准权。
- Release 批准权。

发生冲突时：

1. 先确认冲突是否属于系统边界。
2. 系统边界冲突由本文件处理。
3. 专业规则冲突由对应 System 的正式上位文件处理。
4. Visual 内部规则以 `VISUAL_CONSTITUTION.md` 为最高权威。
5. 无法确定时停止开发，等待正式决策。

---

# 3. Architecture Mission

Phoenix System Architecture 的使命是：

> 让 Phoenix 能够长期增加 Journey、内容、视觉、学习能力、交互、音频、AI 与发布能力，而不让任何单一系统无限扩张并破坏其它系统。

Phoenix 不是由页面堆叠形成的产品。

Phoenix 是由职责清楚、输入可追踪、输出可验证的 Professional Systems 共同形成的产品。

一个系统成功，不代表整体成功。

例如：

- Story 优秀，但文化事实错误，整体失败。
- Visual 优秀，但影响阅读，整体失败。
- Learning 完整，但 UI 无法操作，整体失败。
- Code 通过测试，但 Accessibility 失败，整体失败。
- Preview 可打开，但 Release Evidence 不完整，不能视为正式发布。

---

# 4. Architecture Principles

## Principle One

One System, One Primary Responsibility。

每个 System 必须拥有一个主要专业职责。

不得因为实现方便而吞并相邻系统。

---

## Principle Two

Explicit Inputs and Outputs。

系统不能根据猜测开始工作。

每个系统必须知道：

- 输入来自哪里。
- 输入是否已审核。
- 输出交给谁。
- 输出通过什么 Gate。

---

## Principle Three

Upstream Defines Intent。

上游定义目标、意义与约束。

下游负责表达、实现、验证与交付。

下游不得反向修改上游意图。

---

## Principle Four

Downstream Provides Evidence。

下游可以向上游提供：

- 实现限制。
- 性能证据。
- 可访问性问题。
- QA 失败。
- 用户体验发现。

但不能静默改变上游规则。

需要改变规则时，必须回到正确 System 正式决策。

---

## Principle Five

Cross-cutting Systems Do Not Own Product Meaning。

Performance、Accessibility、QA 与 AI Review 横跨所有系统。

它们可以阻断不合格输出。

但不得创造 Story、Learning 或 Visual 方向。

---

## Principle Six

Release Does Not Create Quality。

Release 负责证明合格输出被正确交付。

Release 不负责在最后阶段补造质量。

---

## Principle Seven

Implementation Is Evidence, Not Authority。

当前代码说明产品已经如何实现。

代码不能自动成为最高产品规则。

---

# 5. Architecture Layers

Phoenix Professional Systems 分为五个协作层。

```text
Layer 1 — Product Authority

Core System

↓

Layer 2 — Meaning and Experience

Story System
Content System
Learning System
Visual System
UI/UX System
Audio System
Animation System

↓

Layer 3 — Implementation

Code System

↓

Layer 4 — Cross-cutting Assurance

Performance System
Accessibility System
AI Review System
QA System

↓

Layer 5 — Delivery

Release System
```

这不是单向瀑布流程。

系统可以反馈问题。

但正式权责方向保持不变：

- Core 定义不可违背的产品边界。
- Meaning and Experience Systems 定义专业意图。
- Code 实现已经批准的意图。
- Assurance Systems 验证结果。
- Release 交付通过验证的结果。

---

# 6. System Status Model

Architecture 定义系统，不等于系统已经完整实现。

每个系统必须分别记录：

- Documentation Status。
- Implementation Status。
- Validation Status。
- Release Status。

允许的 Product Status：

- `Completed`：需求、实现、验证、验收与目标交付证据完整。
- `In Development`：存在部分实现或有效工作，但未满足全部完成条件。
- `Planned`：存在目标或架构位置，但尚无完整可验证实现。

本文件中提到代码路径，只说明存在实现证据。

不代表该 System 已经 `Completed`。

---

# 7. Core System

## 7.1 Mission

定义 Phoenix 为什么存在、为谁存在，以及所有系统不得违背的产品基础。

## 7.2 Responsibilities

- 定义 Phoenix 作为 Language Journey Platform 的产品定位。
- 定义 Explorer 的长期价值与尊重原则。
- 定义 Truth、Originality、Learning、Privacy 与 No Advertising 等不可协商原则。
- 定义免费与付费边界的产品伦理。
- 批准跨系统的根本方向变化。
- 为全部 Professional Systems 提供最高产品约束。

## 7.3 Boundary

Core 只定义最高产品意图与不可违背原则。

Core 不设计具体 Journey、页面、图片、算法、动画或发布步骤。

## 7.4 Inputs

- Founder 决策。
- Explorer 长期需求。
- 产品使命。
- 法律、伦理、隐私与商业约束。
- 已验证的重大产品研究。

## 7.5 Outputs

- Phoenix Constitution。
- Product Principles。
- Non-negotiable Rules。
- 产品定位与长期边界。
- 需要所有 System 遵守的正式决策。

## 7.6 Upstream Dependencies

- Founder Authority。
- 真实用户与产品证据。
- 法律与平台不可规避要求。

Core 没有其它 Phoenix Professional System 作为上游。

## 7.7 Downstream Dependencies

全部 Phoenix Systems 都依赖 Core。

## 7.8 Forbidden Responsibilities

Core 禁止：

- 直接规定代码类名。
- 直接制作 Story 或 Visual Asset。
- 绕过专业 System 决定实现细节。
- 把短期 Roadmap 提升为不可改变原则。
- 用商业指标覆盖 Explorer、Truth 或 Learning 原则。

## 7.9 Interfaces

- 向 Story 提供真实性、意义与文化尊重边界。
- 向 Learning 提供学习价值与无焦虑原则。
- 向 Visual 提供原创、合法与服务阅读的产品边界。
- 向 Code 提供隐私、安全与产品行为约束。
- 向 QA 提供不可妥协的验收依据。
- 向 Release 提供不得绕过的发布条件。

---

# 8. Story System

## 8.1 Mission

为每一个 Journey 建立可信、值得阅读、具有文化意义并能够支持语言学习的叙事世界。

## 8.2 Responsibilities

- 定义 Story 主题、人物、空间、冲突、转折与结尾。
- 定义 Ordinary Journey 与 Special Journey 的叙事差异。
- 维护 Story 与 Journey Identity。
- 区分事实、传说、争议、解释与文学想象。
- 维护文化真实性、来源关系与叙事完整性。
- 为 Phoenix Lv.1–10 提供同一故事意义下的语言表达基础。
- 向 Visual、Learning、Audio 与 Content 输出稳定的 Story Contract。

## 8.3 Boundary

Story 定义世界与意义。

Story 不决定该世界如何绘制、页面如何交互、语音如何播放或代码如何组织。

## 8.4 Inputs

- Core Product Principles。
- Journey 目标。
- 可靠文化、历史、地理与文学来源。
- Explorer Language Level 需求。
- Ordinary 或 Special Journey 类型。
- Content Research 与 Source Records。

## 8.5 Outputs

- Story 正文与结构。
- Story Metadata。
- 人物、时间、天气、地点与情绪定义。
- 事实、传说与文学想象标记。
- 多等级 Story Meaning Contract。
- Visual、Learning、Audio 与 Content 可消费的叙事输入。

## 8.6 Upstream Dependencies

- Core System。
- Content System 提供的研究与来源证据。

## 8.7 Downstream Dependencies

- Visual System。
- Learning System。
- Content System 的内容封装阶段。
- UI/UX System 的阅读呈现。
- Audio System。
- Animation System 中与叙事节奏有关的部分。
- AI Review System 与 QA System。

## 8.8 Forbidden Responsibilities

Story 禁止：

- 为配合已有图片改写核心意义。
- 指定 UI Business Logic。
- 规定代码实现。
- 把未经证实内容写成事实。
- 把 Learning 评估结果写入叙事规则。
- 决定 Release 是否合并。

## 8.9 Interfaces

- 与 Content 通过 Source Record、Journey Metadata 与审校状态交换事实依据。
- 与 Visual 通过 Scene、Emotion、Time、Weather、Culture 与 Character Contract 连接。
- 与 Learning 通过语言难度、词汇机会、Discovery 线索与意义保持要求连接。
- 与 Audio 通过语言文本、段落边界、发音要求与叙事节奏连接。
- 与 QA 通过 Story Quality Gate、事实检查与跨等级一致性连接。

---

# 9. Visual System

## 9.1 Mission

帮助 Explorer 进入 Story、理解空间、形成文化与 Journey 记忆，同时始终保护阅读和学习。

## 9.2 Responsibilities

- 维护 Visual Constitution、Philosophy 与 Guidelines。
- 定义 Phoenix 整体视觉语言与 Journey Visual Identity。
- 定义 Background、Map、Passport、Banner、Loading、Splash 与 UI Illustration 的视觉表达。
- 定义构图、前景、中景、远景、光影、色彩与阅读安全区。
- 定义 AI 原创视觉生成、错误检查、文化真实性与版权要求。
- 定义静态背景、动态源层、设备变体与静态降级的视觉要求。
- 通过 Visual Pipeline、Gate、Checklist 与 Review 管理视觉品质。

## 9.3 Boundary

Visual 定义世界如何被看见。

Visual 不定义 Story 意义、Learning Logic、UI Business Logic、Audio 行为或 Release 决策。

Visual 的完整权威来自 `docs/visual/README.md` 及其正式规范。

## 9.4 Inputs

- Core Product Principles。
- Story Contract。
- Journey Metadata。
- 文化与城市研究。
- Learning 页面内容密度。
- UI Reading Safe Area 与 Button Safe Area 需求。
- Accessibility 与 Performance 约束。
- 版权与商业使用证据。

## 9.5 Outputs

- Visual Direction。
- Journey Visual Identity。
- Approved Visual Masters。
- Runtime Visual Variants。
- Background 与 Illustration Assets。
- Visual Metadata。
- Static Fallback 与 Reduced Motion Visual Variant。
- Visual Review Evidence。

## 9.6 Upstream Dependencies

- Core System。
- Story System。
- Content System 的研究与版权证据。
- UI/UX System 提供的布局与安全区接口。
- Accessibility System 与 Performance System 的目标约束。

## 9.7 Downstream Dependencies

- UI/UX System 的最终页面呈现。
- Animation System。
- Code System。
- Performance System。
- Accessibility System。
- AI Review System。
- QA System。
- Release System。

## 9.8 Forbidden Responsibilities

Visual 禁止：

- 改写 Story。
- 增加学习内容。
- 改变 Challenge 规则。
- 以氛围为理由降低文字或按钮可读性。
- 让 Animation 决定 Visual Meaning。
- 使用版权状态不明资源。
- 将导入成功等同于视觉审核完成。

## 9.9 Interfaces

- 与 Story 通过 Scene Brief 与 Journey Identity 连接。
- 与 UI 通过 Reading Safe Area、Button Safe Area、Layer、Crop 与 Responsive Contract 连接。
- 与 Animation 通过可运动层、静止层、幅度、节奏与 Static Fallback Contract 连接。
- 与 Performance 通过格式、尺寸、加载、解码、降级与资源预算连接。
- 与 Accessibility 通过 Reduced Motion、对比、可读性与非颜色信息连接。
- 与 AI Review 通过生成记录、AI Error、Culture、Copyright 与 Visual Consistency Review 连接。
- 与 QA 通过 Image Quality Gate、Visual Checklist 与真实页面验证连接。

---

# 10. Learning System

## 10.1 Mission

将 Story、语言、文化探索、练习、反馈与记忆组织成对 Explorer 有意义且无焦虑的学习旅程。

## 10.2 Responsibilities

- 定义 Phoenix Learning Flow。
- 定义 Story、Vocabulary、Discovery、Challenge、Reflection/Memory 与 Stamp 的学习关系。
- 定义 Phoenix Lv.1–10 的能力适配与内容负担。
- 定义词汇解释、复习、Challenge 机会、反馈与奖励逻辑。
- 定义学习进度、记忆、历史与继续学习行为。
- 保证学习公平、尊重与无强迫式留存。
- 定义跟读训练的学习目标与反馈语义。

## 10.3 Boundary

Learning 定义学习为什么发生、以什么顺序发生、如何判断学习反馈。

Learning 不绘制页面、不生成 Story 世界、不实现语音引擎、不决定视觉风格。

## 10.4 Inputs

- Core 的学习与 Explorer 原则。
- Story 与语言内容。
- Content Metadata、Vocabulary 与 Source Records。
- Explorer Level 与学习状态。
- Audio 能力与限制。
- Accessibility 需求。
- QA 学习效果与交互发现。

## 10.5 Outputs

- Learning Flow Contract。
- Level Adaptation Rules。
- Vocabulary、Discovery 与 Challenge Requirements。
- Feedback、Retry、Reward 与 Progress Rules。
- Memory 与 Stamp Completion Criteria。
- UI、Audio、Code 与 QA 可执行的学习状态定义。

## 10.6 Upstream Dependencies

- Core System。
- Story System。
- Content System。
- Accessibility System 提供的学习可达性约束。

## 10.7 Downstream Dependencies

- UI/UX System。
- Audio System。
- Content System 的学习资源封装。
- Code System。
- AI Review System。
- QA System。
- Release System。

## 10.8 Forbidden Responsibilities

Learning 禁止：

- 改写 Story 核心意义。
- 规定图片风格。
- 以奖励制造焦虑或强迫留存。
- 将付费能力变成内容知识壁垒。
- 通过 UI 临时行为创造未记录学习规则。
- 把算法分数视为完整学习判断。

## 10.9 Interfaces

- 与 Story 通过 Level、Vocabulary Opportunity、Discovery 与 Meaning Preservation 连接。
- 与 Content 通过结构化学习单元与多语言辅助内容连接。
- 与 UI 通过页面顺序、状态、主操作与错误恢复连接。
- 与 Audio 通过朗读、跟读、速度、反馈与训练状态连接。
- 与 Code 通过稳定 State Contract、Progress Event 与 Persistence Contract 连接。
- 与 QA 通过学习路径、难度、反馈与无焦虑验收连接。

---

# 11. UI/UX System

## 11.1 Mission

让 Explorer 能够清楚、自然、可恢复地完成每一次 Journey、阅读、操作、练习与回顾。

## 11.2 Responsibilities

- 定义 Information Architecture。
- 定义 Navigation、Screen、Component 与 Interaction State。
- 定义 Primary Action、Secondary Action 与状态反馈。
- 定义 Mobile-first Responsive Layout。
- 定义 Loading、Empty、Error、Offline 与 Return State。
- 定义触控、键盘、焦点、可读性与输入行为。
- 将 Visual、Learning、Audio 与 Content 组织成统一页面体验。

## 11.3 Boundary

UI/UX 定义如何操作与如何呈现信息层级。

UI/UX 不创造 Story、Learning Rule、Visual Style、Audio Content 或 Release Policy。

## 11.4 Inputs

- Core 的产品简洁与 Explorer 原则。
- Learning Flow 与 State Contract。
- Story 与 Content Structure。
- Visual Assets、Safe Areas 与 Visual Tokens。
- Audio Controls 与状态。
- Accessibility Requirements。
- Performance Budgets。

## 11.5 Outputs

- Navigation Model。
- Screen Structure。
- Component Contract。
- Interaction State Machine。
- Responsive Layout Rules。
- Error、Loading、Offline 与 Recovery Experience。
- Code 与 QA 可验证的 UI Acceptance Criteria。

## 11.6 Upstream Dependencies

- Core System。
- Story System。
- Learning System。
- Visual System。
- Audio System。
- Content System。
- Accessibility System。
- Performance System。

## 11.7 Downstream Dependencies

- Code System。
- Animation System 的交互状态部分。
- Accessibility System 的运行验证。
- Performance System 的页面预算验证。
- QA System。
- Release System。

## 11.8 Forbidden Responsibilities

UI/UX 禁止：

- 只根据截图反推完整产品规则。
- 为减少开发成本删除 Learning 必要步骤。
- 让背景或动画覆盖文字与按钮。
- 使用装饰元素模拟真实交互控件。
- 静默改变 Audio 或 Progress State。
- 把桌面布局简单缩小为手机体验。

## 11.9 Interfaces

- 与 Learning 通过 Flow、State、Action 与 Completion Contract 连接。
- 与 Visual 通过 Layer、Safe Area、Asset Role 与 Responsive Crop 连接。
- 与 Audio 通过 Play、Pause、Seek、Voice、Error 与 Restoration State 连接。
- 与 Animation 通过 Trigger、Duration、Interrupt、Reduced Motion 与 Completion Event 连接。
- 与 Code 通过 Screen、Widget、State 与 Navigation Contract 连接。
- 与 QA 通过 viewport、interaction、accessibility 与 recovery scenarios 连接。

---

# 12. Audio System

## 12.1 Mission

通过自然、可靠、可控制的朗读、发音与跟读体验，帮助 Explorer 理解语言并练习表达。

## 12.2 Responsibilities

- 定义 Story、Discovery 与 Word Audio 行为。
- 定义 Voice Selection 与语言地区匹配。
- 定义 Play、Pause、Resume、Seek、Rate 与 Position Restoration。
- 定义 Narration Follow 与文字同步所需事件。
- 定义 Shadowing Recording、Recognition、Scoring 与 Coaching 接口。
- 定义浏览器、设备与权限失败处理。
- 定义 Audio Accessibility 与无声降级体验。

## 12.3 Boundary

Audio 定义听觉与语音交互。

Audio 不改写文本、不定义学习奖励、不设计视觉氛围、不控制发布。

## 12.4 Inputs

- Story 与 Content Text。
- Language、Locale、Pinyin 与 Pronunciation Metadata。
- Learning Goal 与 Level。
- UI Control Events。
- Device Speech Capability。
- Accessibility Preference。
- Privacy 与 Permission Requirements。

## 12.5 Outputs

- Narration State。
- Playback Events。
- Voice、Rate 与 Position State。
- Word Boundary 或 Paragraph Boundary Event。
- Recognition Result。
- Shadowing Score 与 Coaching Evidence。
- Audio Error 与 Fallback State。

## 12.6 Upstream Dependencies

- Core System。
- Story System。
- Learning System。
- Content System。
- UI/UX System 的控制需求。
- Accessibility System。

## 12.7 Downstream Dependencies

- UI/UX System 的实时状态呈现。
- Animation System 中合法的音画协调。
- Code System。
- Performance System。
- Accessibility System 的验证。
- QA System。
- Release System。

## 12.8 Forbidden Responsibilities

Audio 禁止：

- 为适配语音引擎修改 Story 意义。
- 将浏览器支持推断为所有设备支持。
- 在朗读状态变化时触发干扰阅读的视觉效果。
- 未经明确权限采集或保存语音。
- 把 Recognition Confidence 当作完整语言能力。
- 用静默失败伪装正在播放。

## 12.9 Interfaces

- 与 Story/Content 通过可朗读文本、Locale、段落与词边界连接。
- 与 Learning 通过训练目标、速度建议、评分语义与重试规则连接。
- 与 UI 通过控制命令、状态事件、错误与恢复连接。
- 与 Animation 只通过已批准的低干扰状态事件连接。
- 与 Accessibility 通过 Caption、Visual State、Reduced Cognitive Load 与 Permission Alternative 连接。
- 与 QA 通过真实设备、浏览器、权限、暂停恢复与失败场景连接。

---

# 13. Animation System

## 13.1 Mission

让 Phoenix 的界面、Journey 世界与状态变化自然可感知，同时保持阅读、学习、控制与设备稳定性。

## 13.2 Responsibilities

- 实现由 Visual 或 UI/UX 批准的 Motion Intent。
- 定义背景动态、视差、镜头、转场与状态反馈的技术行为。
- 定义 Trigger、Duration、Easing、Amplitude、Loop 与 Interrupt Rules。
- 定义 Reduced Motion 与 Static Fallback 行为。
- 定义页面隐藏、返回、切换与恢复时的动画状态。
- 保证 Animation 不阻断触控、朗读或学习流程。
- 与 Performance 共同控制绘制、帧率与资源成本。

## 13.3 Boundary

Animation 决定已经批准的视觉或交互意图如何运动。

Visual 决定为什么动、什么应该动以及动态应表达什么。

UI/UX 决定交互状态为何变化。

Animation 不拥有 Visual Philosophy 或 Learning Logic。

## 13.4 Inputs

- Visual Motion Intent。
- UI State Transition。
- Journey、Page 与 Asset Metadata。
- Audio 中允许使用的状态事件。
- Reduced Motion Preference。
- Performance Budget。
- Device Capability。

## 13.5 Outputs

- Motion Specification。
- Runtime Animation Behavior。
- Transition State。
- Static Fallback Trigger。
- Reduced Motion Variant。
- Animation Performance Evidence。
- QA 可验证的 Loop、Interrupt 与 Restoration Criteria。

## 13.6 Upstream Dependencies

- Visual System。
- UI/UX System。
- Accessibility System。
- Performance System。
- Audio System 仅提供被批准的状态事件。

## 13.7 Downstream Dependencies

- Code System。
- UI/UX System 的最终体验。
- Performance System 的运行验证。
- Accessibility System 的运行验证。
- QA System。
- Release System。

## 13.8 Forbidden Responsibilities

Animation 禁止：

- 自行决定 Journey Visual Identity。
- 用动态掩盖静态图片问题。
- 让所有层同时运动。
- 以降低速度代替真正 Reduced Motion。
- 在朗读、Challenge 或按钮后方制造高频动态。
- 动态不自然时强行保留。
- 缺少静态降级仍进入正式版。

## 13.9 Interfaces

- 与 Visual 通过 Layer、Motion Intent、Reading Safe Area 与 Static Fallback 连接。
- 与 UI 通过 State Trigger、Completion、Cancel 与 Restore Event 连接。
- 与 Audio 通过最小、明确、可中断的状态事件连接。
- 与 Performance 通过 Frame Budget、Layer Count、Pause 与 Degradation Strategy 连接。
- 与 Accessibility 通过 Reduced Motion 与 Non-motion Alternative 连接。
- 与 QA 通过自然度、循环、交互覆盖、返回恢复与设备场景连接。

动态效果不自然时：

必须退回高质量静态方案。

---

# 14. Content System

## 14.1 Mission

将经过研究、审校和结构化处理的 Story、Vocabulary、Discovery、Challenge、翻译与来源记录，安全地提供给产品运行。

## 14.2 Responsibilities

- 管理 Journey Content Schema。
- 管理 Story、Vocabulary、Discovery、Challenge 与辅助语言内容。
- 管理 Source Records、Evidence 与 Review Status。
- 管理 Journey ID、Geo ID、Level 与版本关系。
- 管理简体、繁体、拼音、母语与英语辅助内容的一致性。
- 保证运行时内容与审核来源可追踪。
- 区分内容候选、已审核内容、运行时内容与归档内容。

## 14.3 Boundary

Content 负责结构化、校验、封装与分发内容。

Content 不拥有 Story 最高叙事决策，不定义 Learning Logic，也不决定 UI 呈现。

## 14.4 Inputs

- Story System 输出。
- Learning Content Requirements。
- 可靠研究与来源。
- Translation 与 Language Support。
- Journey、Geo 与 Level Metadata。
- AI Review 与 Human Review Result。

## 14.5 Outputs

- Reviewed Journey Content。
- Structured Content Records。
- Vocabulary 与 Discovery Data。
- Challenge Content。
- Source 与 Evidence Records。
- Runtime Catalog。
- Content Validation Evidence。

## 14.6 Upstream Dependencies

- Core System。
- Story System。
- Learning System。
- 可靠外部来源。
- AI Review 与人工审校。

## 14.7 Downstream Dependencies

- Learning System 的运行内容。
- Visual System 的 Story/Journey Brief。
- UI/UX System。
- Audio System。
- Code System。
- QA System。
- Release System。

## 14.8 Forbidden Responsibilities

Content 禁止：

- 将未经审核生成内容直接放入运行时 Catalog。
- 用翻译便利改写中文核心意义。
- 将事实、传说与虚构混为同一状态。
- 用文件存在代替来源审查。
- 让 AI 自动批准自己的内容。
- 以批量生产为理由降低质量。

## 14.9 Interfaces

- 与 Story 通过 Narrative Contract 与 Source Status 连接。
- 与 Learning 通过 Level、Vocabulary、Discovery、Challenge 与 Feedback Content 连接。
- 与 Visual 通过 Journey Metadata、Scene、Culture 与 Asset Relationship 连接。
- 与 Audio 通过可朗读文本、Locale 与 Pronunciation Metadata 连接。
- 与 Code 通过 Schema、Catalog、ID 与 Validation Contract 连接。
- 与 AI Review/QA 通过事实、文化、多语言与完整性 Gate 连接。

---

# 15. Code System

## 15.1 Mission

将已经批准的 Phoenix 产品、内容与体验规则实现为可维护、可测试、可恢复且可发布的软件。

## 15.2 Responsibilities

- 定义 Application、State、Data、Service、Agent、Screen 与 Widget 的代码边界。
- 实现 Flutter Client、Worker、AI Gateway 与必要服务接口。
- 实现数据模型、持久化、错误处理、降级与恢复。
- 实现 Story、Learning、Visual、UI、Audio 与 Animation Contract。
- 维护依赖、测试结构、Build Configuration 与安全边界。
- 避免 Client Secret、未经审查远端内容与不可追踪行为。
- 为 QA 与 Release 提供可重复构建和测试证据。

## 15.3 Boundary

Code 负责如何实现。

Code 不决定为什么要改变产品、Story、Learning 或 Visual 原则。

## 15.4 Inputs

- Core 与 Professional System Documentation。
- Approved Requirements。
- Content Schema 与 Reviewed Assets。
- UI、Audio、Animation 与 State Contracts。
- Performance 与 Accessibility Constraints。
- QA Acceptance Criteria。

## 15.5 Outputs

- Application Code。
- Worker 与 Service Code。
- Tests。
- Build Artifacts。
- Runtime State 与 Error Behavior。
- Implementation Evidence。
- Technical Documentation。

## 15.6 Upstream Dependencies

- 所有定义产品行为或体验的 Professional Systems。
- Content System。
- Performance System。
- Accessibility System。
- 安全与平台要求。

## 15.7 Downstream Dependencies

- Performance System 的测量。
- Accessibility System 的运行验证。
- AI Review System 的集成检查。
- QA System。
- Release System。

## 15.8 Forbidden Responsibilities

Code 禁止：

- 将当前实现反向提升为产品原则。
- 静默省略不方便实现的正式要求。
- 在客户端提交 Secret。
- 绕过 Content、Visual 或 Copyright Review 导入资源。
- 用测试替代真实设备验证。
- 将 Prototype Route 当作正式产品状态。
- 在没有 Release Evidence 时声称已发布。

## 15.9 Interfaces

- 与各专业系统通过版本化 Contract、ID、State 与 Acceptance Criteria 连接。
- 与 Content 通过 Schema 与 Catalog 连接。
- 与 Performance 通过 Metric、Budget 与 Profile 连接。
- 与 Accessibility 通过 Semantics、Focus、Motion、Contrast 与 Alternative 连接。
- 与 QA 通过 Test、Fixture、Build 与 Reproduction Path 连接。
- 与 Release 通过 Commit、Artifact、Configuration 与 Deployment Contract 连接。

---

# 16. Performance System

## 16.1 Mission

保证 Phoenix 在目标手机、平板与 Web 环境中快速、稳定、节制地运行，不以牺牲学习、可访问性或内容正确性换取表面速度。

## 16.2 Responsibilities

- 定义启动、页面切换、资源加载、内存、解码、绘制与响应预算。
- 定义图片格式、尺寸、缓存、预加载与 Lazy Load 策略。
- 定义 Animation Layer、Frame、Pause 与 Degradation 策略。
- 定义低性能设备与网络失败降级。
- 验证 Audio、AI Request、Persistence 与大型 Content Catalog 的运行成本。
- 防止页面隐藏后持续消耗资源。
- 向 Code、Visual、Animation 与 Release 提供性能证据。

## 16.3 Boundary

Performance 定义资源和运行成本边界。

Performance 不改变 Story、Learning Goal、Visual Meaning 或 Accessibility Requirement。

## 16.4 Inputs

- Target Device Matrix。
- Runtime Assets。
- Code Build。
- Visual 与 Animation Specifications。
- Audio 与 Network Behavior。
- Accessibility Requirement。
- Real Measurement Data。

## 16.5 Outputs

- Performance Budget。
- Measurement Report。
- Bottleneck Evidence。
- Optimization Requirement。
- Degradation Strategy。
- Release Blocking Result。

## 16.6 Upstream Dependencies

- Core 的学习体验边界。
- Visual、UI/UX、Audio、Animation 与 Code Outputs。
- Target Platform Requirements。

## 16.7 Downstream Dependencies

- Visual Runtime Variant。
- Animation Runtime Behavior。
- Code Optimization。
- Accessibility Stability。
- QA System。
- Release System。

## 16.8 Forbidden Responsibilities

Performance 禁止：

- 首先降低文字质量或 UI 清晰度。
- 删除 Learning 必要步骤以通过指标。
- 以性能为理由保留来源不明低质量资源。
- 使用未经测量的“应该更快”结论。
- 把开发机结果视为全部设备结果。
- 隐藏失败而不提供降级。

## 16.9 Interfaces

- 与 Visual 通过 Runtime Resolution、Format、Compression、Load 与 Cache Contract 连接。
- 与 Animation 通过 Frame Budget、Layer Budget、Pause 与 Static Fallback 连接。
- 与 UI 通过 Responsive Cost、Loading State 与 Interaction Latency 连接。
- 与 Audio 通过 Startup、Buffer、Concurrency 与 Release Resource 连接。
- 与 Code 通过 Profiling、Metric 与 Optimization Change 连接。
- 与 QA/Release 通过设备矩阵和阻断阈值连接。

---

# 17. Accessibility System

## 17.1 Mission

保证不同视觉、听觉、运动、认知与操作需求的 Explorer 能够理解、控制并完成 Phoenix Journey。

## 17.2 Responsibilities

- 定义 Semantics、Screen Reader、Focus 与 Keyboard Requirements。
- 定义文字大小、对比、颜色非唯一表达与触控目标要求。
- 定义 Reduced Motion 与 Non-motion Alternative。
- 定义 Audio 的可见状态、错误替代与权限替代。
- 定义阅读、Challenge、Input、Map 与 Passport 的可达性。
- 定义认知负担、时间压力与无焦虑交互边界。
- 在真实设备与辅助技术中验证。

## 17.3 Boundary

Accessibility 定义任何正式体验必须满足的可达性条件。

Accessibility 不改写 Story、不降低 Learning Meaning，也不决定 Visual Style。

## 17.4 Inputs

- Core 的 Explorer Respect 原则。
- Story、Learning、Visual、UI、Audio 与 Animation Outputs。
- Target Device 与 Platform Accessibility API。
- User Preference。
- QA Evidence。

## 17.5 Outputs

- Accessibility Requirements。
- Semantics Contract。
- Focus and Input Contract。
- Reduced Motion Requirement。
- Contrast and Text Scale Result。
- Alternative Experience Requirement。
- Release Blocking Result。

## 17.6 Upstream Dependencies

- Core System。
- 全部 Experience Systems 的输出。
- 平台可访问性标准。

## 17.7 Downstream Dependencies

- Visual System。
- UI/UX System。
- Audio System。
- Animation System。
- Code System。
- Performance System。
- QA System。
- Release System。

## 17.8 Forbidden Responsibilities

Accessibility 禁止：

- 只提供一个设置开关而不验证真实行为。
- 只减慢动画而不提供 Reduced Motion。
- 只依赖颜色表达状态。
- 让自动朗读成为理解内容的唯一方式。
- 以“目标用户不需要”为理由跳过验证。
- 用自动检查替代辅助技术与真实交互验证。

## 17.9 Interfaces

- 与 Visual 通过 Contrast、Reading Safety 与 Non-color Cue 连接。
- 与 UI 通过 Semantics、Focus、Touch Target、Text Scale 与 Keyboard 连接。
- 与 Audio 通过 Visible State、Alternative、Permission 与 Error 连接。
- 与 Animation 通过 Reduced Motion 与 Static State 连接。
- 与 Code 通过 Platform Semantics 与 Preference Persistence 连接。
- 与 QA/Release 通过 Accessibility Matrix 与 Blocking Result 连接。

---

# 18. QA System

## 18.1 Mission

以可重复证据判断 Phoenix 的需求、规则、内容、体验与交付是否达到对应正式标准。

## 18.2 Responsibilities

- 将正式 Documentation 转换为可验证 Acceptance Criteria。
- 组织 Unit、Widget、Integration、Product Rule 与 Manual QA。
- 验证 Story、Content、Learning、Visual、UI、Audio 与 Animation。
- 验证 Performance、Accessibility、Security 与 Copyright Gate。
- 维护设备、浏览器、viewport、网络与恢复场景矩阵。
- 记录 PASS、FAIL、Blocked 与未验证项。
- 防止回归与不完整 Evidence 进入 Release。

## 18.3 Boundary

QA 验证规则。

QA 不创造规则，不降低 Gate，不批准缺少证据的完成声明。

## 18.4 Inputs

- Core 与 Professional System Documentation。
- Acceptance Criteria。
- Code、Content、Assets 与 Build。
- Test Results。
- Device、Browser 与 Preview。
- AI Review、Performance 与 Accessibility Results。

## 18.5 Outputs

- QA Plan。
- Test Evidence。
- PASS/FAIL/Blocked Result。
- Regression Report。
- Release Readiness Result。
- 可复现缺陷记录。

## 18.6 Upstream Dependencies

- 所有定义正式规则的 Systems。
- Code System。
- AI Review System。
- Performance System。
- Accessibility System。

## 18.7 Downstream Dependencies

- Code、Content、Visual、UI、Audio 与 Animation 的修正循环。
- Release System。

## 18.8 Forbidden Responsibilities

QA 禁止：

- 用个人偏好判定专业品质。
- 将未执行测试标记为通过。
- 将自动测试通过等同于真实设备通过。
- 允许“上线后再修”绕过强制 Gate。
- 直接修改规则以让失败项通过。
- 把 Preview 可访问等同于正式 Release。

## 18.9 Interfaces

- 与每个 System 通过 Acceptance Criteria、Gate 与 Failure Return Path 连接。
- 与 Code 通过 Test、Fixture、Build 与 Reproduction 连接。
- 与 AI Review 通过专项 Review Evidence 连接。
- 与 Performance/Accessibility 通过阻断结果连接。
- 与 Release 通过完整 Release Evidence Package 连接。

---

# 19. Release System

## 19.1 Mission

将已经通过专业审核与 QA 的 Phoenix 变更，以可追踪、可回滚、可验证的方式交付到正确环境。

## 19.2 Responsibilities

- 定义 Branch、Commit、PR、Review 与 Merge 流程。
- 定义 Preview、Stable、Alpha 与正式环境边界。
- 运行并记录 CI、Build、Deployment 与 Health Check。
- 管理 Version、Artifact、Configuration 与 Rollback。
- 维护 Release Evidence 与 CHANGELOG。
- 确认目标 Commit 与实际部署一致。
- 阻止未通过 Gate 的内容进入正式版。

## 19.3 Boundary

Release 负责交付。

Release 不定义产品方向，不修正专业内容，不替代 QA，不自动获得合并 `main` 授权。

## 19.4 Inputs

- Approved Commit 或 PR。
- QA PASS Evidence。
- Professional Gate Results。
- Build Configuration。
- Environment Configuration。
- Version Decision。
- Merge/Release Authorization。

## 19.5 Outputs

- Preview URL 或 Release Artifact。
- Deployment Record。
- Version Record。
- Health Check Result。
- Rollback Point。
- CHANGELOG Entry。
- 可验证的 Release Commit SHA。

## 19.6 Upstream Dependencies

- Core Release Boundary。
- 所有受影响 Professional Systems。
- Code System。
- Performance、Accessibility、AI Review 与 QA Systems。

## 19.7 Downstream Dependencies

- Explorer 使用环境。
- 运营、支持与未来 Development Baseline。
- 下一版本 Roadmap 与 Regression Baseline。

## 19.8 Forbidden Responsibilities

Release 禁止：

- 未经授权合并 `main`。
- 把本地 Commit 声称为已部署。
- 把 Preview 声称为正式版。
- 绕过失败的 QA、Copyright、Performance 或 Accessibility Gate。
- 部署无法追踪到 Commit 的 Artifact。
- 在没有 Rollback Path 时进行高风险正式发布。

## 19.9 Interfaces

- 与 Code 通过 Commit、Build 与 Artifact 连接。
- 与 QA 通过 Release Readiness Result 连接。
- 与 Performance/Accessibility/AI Review 通过 Gate Evidence 连接。
- 与 Git/CI/Hosting 通过 Branch、Workflow、Artifact 与 Deployment ID 连接。
- 与 Roadmap、TODO 与 CHANGELOG 通过状态转换连接。

---

# 20. AI Review System

## 20.1 Mission

使用可审查的 AI 辅助检查，提高 Phoenix Story、Content、Visual、Learning 与 Code 的一致性，同时确保最终权威仍来自正式 Documentation 与明确的人类责任。

## 20.2 Responsibilities

- 根据正式规则执行结构化 Review。
- 检查事实、文化、语言、叙事、学习、视觉与代码风险。
- 检查 AI 生成内容和视觉中的明显生成错误。
- 检查跨 Journey 重复、术语漂移与规范遗漏。
- 输出带规则来源的 Review Finding。
- 将不确定项升级到 Human Review。
- 保留 Input、Model/Tool Category、Prompt/Rule Version 与 Review Result 的可追踪关系。

## 20.3 Boundary

AI Review 是辅助审核系统。

AI Review 不拥有 Constitution、专业规则、事实来源、版权结论或 Release 决策权。

AI 不得审核并自动批准自己刚生成的资源而没有独立 Gate。

## 20.4 Inputs

- 正式 Documentation。
- Story、Content、Visual Asset、Code 或 Build Candidate。
- Source Records 与 Metadata。
- Review Prompt 与 Checklist。
- 当前实现和测试证据。
- 已知风险与历史 Finding。

## 20.5 Outputs

- Structured Findings。
- PASS、FAIL、Needs Human Review 或 Insufficient Evidence 建议。
- 规则引用。
- 风险级别。
- 修正方向。
- 可追踪 Review Record。

AI Review 的 PASS 建议不能单独替代正式 QA PASS。

## 20.6 Upstream Dependencies

- Core System。
- 被审核 Professional System 的正式 Documentation。
- Content Source 与 Metadata。
- Human-defined Review Prompt、Gate 与 Checklist。

## 20.7 Downstream Dependencies

- Story、Content、Visual、Learning、UI、Audio、Animation 与 Code 的修正循环。
- QA System。
- Release System 的 Evidence Package。

## 20.8 Forbidden Responsibilities

AI Review 禁止：

- 虚构来源。
- 根据模型记忆确认事实。
- 自动授予版权或商业使用许可。
- 以评分代替具体 Finding。
- 修改规则以通过自己的输出。
- 在证据不足时给出确定 PASS。
- 隐藏模型不确定性。
- 直接批准 Release。

## 20.9 Interfaces

- 与 Documentation 通过版本化规则、Checklist 与 Review Prompt 连接。
- 与 Story/Content 通过 Source、Claim、Language 与 Culture Finding 连接。
- 与 Visual 通过 AI Error、Culture、Copyright、Consistency 与 Quality Finding 连接。
- 与 Learning/UI/Audio 通过状态、可理解性、无焦虑与一致性 Finding 连接。
- 与 Code 通过静态检查、测试证据与 Contract Finding 连接。
- 与 QA 通过独立 Review Evidence 与人工复核升级连接。

当前仓库存在多种 Agent、Auditor 与 Product Rule Test 实现。

这些属于 AI Review 与规则验证的实现基础。

在完整 Review Governance、独立验证与 Release Evidence 建立前，不得声称 AI Review System 已完整完成。

---

# 21. Cross-system Interface Contracts

系统接口必须是明确 Contract，不得依赖隐含理解。

## 21.1 Story Contract

至少包含：

- Journey ID。
- Story Version。
- Ordinary 或 Special 类型。
- 地点、时间、天气与文化语境。
- 人物与核心意义。
- 事实、传说与文学想象状态。
- Level Meaning Preservation。
- Source Status。

消费者：

- Content。
- Learning。
- Visual。
- Audio。
- AI Review。
- QA。

## 21.2 Content Contract

至少包含：

- Stable IDs。
- Schema Version。
- Language 与 Locale。
- Level。
- Source/Evidence。
- Review Status。
- Runtime Eligibility。

消费者：

- Learning。
- UI/UX。
- Audio。
- Code。
- QA。

## 21.3 Visual Contract

至少包含：

- Asset ID。
- Journey ID。
- Page Type。
- Asset Role。
- Source、Copyright 与 Commercial Use Status。
- Reading/Button Safe Area。
- Device Variant。
- Static Fallback。
- Reduced Motion Variant。
- Review Status 与 Version。

消费者：

- UI/UX。
- Animation。
- Code。
- Performance。
- Accessibility。
- QA。

## 21.4 Learning State Contract

至少包含：

- Explorer Level。
- Journey Step。
- Completion Condition。
- Challenge Attempt 与 Result。
- Reward State。
- Memory/Reflection State。
- Stamp State。
- Persistence Requirement。

消费者：

- UI/UX。
- Audio。
- Code。
- QA。

## 21.5 UI State Contract

至少包含：

- Screen/Component ID。
- Ready、Loading、Empty、Error 与 Offline State。
- Primary/Secondary Action。
- Disabled Reason。
- Navigation Result。
- Focus 与 Semantics Requirement。
- Restoration State。

消费者：

- Code。
- Animation。
- Accessibility。
- QA。

## 21.6 Audio Contract

至少包含：

- Content ID。
- Locale 与 Voice State。
- Playing、Paused、Completed 与 Error State。
- Offset 与 Boundary Event。
- Permission State。
- Recognition/Shadowing Result。
- Fallback State。

消费者：

- Learning。
- UI/UX。
- Animation 的最小状态接口。
- Code。
- Accessibility。
- QA。

## 21.7 Release Evidence Contract

至少包含：

- Branch。
- Commit SHA。
- PR 或批准记录（适用时）。
- CI Result。
- Build Artifact Identity。
- Professional Gate Results。
- QA Result。
- Preview/Deployment Target。
- Health Check。
- Rollback Point。

消费者：

- Release Decision。
- CHANGELOG。
- 下一版本 Development Baseline。

---

# 22. End-to-end Product Flow

一个 Phoenix 能力从目标到交付，必须遵循：

```text
Core Intent

↓

Story / Learning / Product Requirement

↓

Content, Visual, UI, Audio and Animation Contracts

↓

Code Implementation

↓

Performance and Accessibility Validation

↓

AI Review and Professional Review

↓

QA

↓

Release

↓

Runtime Evidence and Feedback
```

任何阶段失败：

- 必须返回拥有该问题的正确上游 System。
- 不得由下游系统自行改写输入。
- 不得通过降低 Gate 继续进入 Release。

例如：

- Story 事实错误，返回 Story/Content。
- Visual 文化错误，返回 Visual 与文化研究。
- 动态不自然，返回 Animation，并使用高质量静态方案。
- UI 影响 Learning Flow，返回 UI/UX 与 Learning Interface。
- 性能不合格，返回 Code/Visual/Animation 优化。
- Accessibility 不合格，返回对应实现系统。
- 版权无法确认，返回 Content/Visual Source 阶段并禁止导入。
- QA 失败，返回产生失败的 System。

---

# 23. Current Repository Mapping

当前仓库结构提供以下实现证据。

| System | Current repository evidence | Current interpretation |
| --- | --- | --- |
| Core | `README.md`、`docs/PRODUCT_BIBLE.md`、`docs/PRODUCT_PRINCIPLES.md` | 存在早期产品原则；正式 Core Documentation 仍需恢复或重建。 |
| Story | Journey Catalog、Story Model、Story Agent、Story Tests | 存在大量 Story 实现；正式 Story Documentation 正在恢复。 |
| Visual | `docs/visual/`、`design/`、运行时图片、Background Widgets 与 Tests | 6 份 Visual 规范已恢复；完整 Visual 文档链与全资源复核仍未由本架构宣称完成。 |
| Learning | Level、Vocabulary、Challenge、Progress、Stamp Services 与 Tests | 存在真实实现；正式 Learning System 文档仍规划中。 |
| UI/UX | `app/lib/screens/`、`widgets/`、`theme/` 与 Widget Tests | 存在真实界面实现；全设备与正式 UI System 状态仍需独立验证。 |
| Audio | Narration、Voice、Web Speech、Shadowing Services 与 Tests | 存在真实实现；设备兼容和正式 Audio System 状态仍需独立验证。 |
| Animation | Background、Map、Stamp、Narration Visual Motion 与规则测试 | 存在部分动态实现；完整 Animation Documentation 与设备自然度验证仍未完成。 |
| Content | `content/`、Journey Data/Catalog、Evidence Catalog | 存在结构化内容与来源基础；全 Catalog 审核状态不能由文件存在推断。 |
| Code | Flutter App、Worker、Backend Schema、Tests | 核心代码结构存在；Backend 部署和 Cloud Sync 不得视为已完成。 |
| Performance | 资源格式、降级行为、部分规则测试 | 存在部分实践；完整预算、测量与设备证据仍需建立。 |
| Accessibility | Reduced Motion、Semantics、Responsive 与相关行为代码/测试 | 存在部分实现；完整辅助技术审核仍需建立。 |
| QA | Flutter Tests、Worker Product Rule Tests、Acceptance 文档 | 存在广泛自动验证；完整专业 Gate 与真实设备证据仍需分别确认。 |
| Release | GitHub Workflows、Cloudflare 与 Preview 文档 | 存在 CI/Preview/Deployment 基础；具体版本是否正式发布必须查 Release Evidence。 |
| AI Review | Agents、Auditors、Quality Rules 与 AI Gateway 基础 | 存在部分实现；独立审核治理与完整可追踪链仍在发展。 |

该表不是 Completion Matrix。

任何 `Completed` 结论必须由对应需求、验证、验收与 Release Evidence 支持。

---

# 24. Forbidden Architecture Coupling

Phoenix 禁止以下系统耦合：

- Visual Asset 反向决定 Story。
- UI 临时状态反向创造 Learning Rule。
- Audio Engine 限制反向改写文本意义。
- Animation 直接监听大量业务状态并制造未经批准效果。
- Code 将未审查 AI Output 直接写入 Runtime Content。
- Content Catalog 将来源未知图片视为正式资源。
- Performance 通过删除 Accessibility Alternative 达标。
- AI Review 自动批准自己的生成结果。
- QA 为让版本通过而修改 Acceptance Criteria。
- Release 在 Gate 失败时创建例外并直接发布。
- Roadmap 条目直接成为实现需求而没有专业 System Contract。
- Prototype、Preview 与 Official Release 共用模糊状态。

发现禁止耦合时：

1. 停止扩展。
2. 确认职责 Owner。
3. 建立明确 Contract。
4. 将决策移回正确 System。
5. 增加对应测试或 Gate。
6. 完成回归审核。

---

# 25. Architecture Change Rules

任何新增 System、删除 System、合并 System 或改变 System 边界的变更，必须：

1. 说明当前架构无法解决的问题。
2. 说明受影响的输入、输出与 Owner。
3. 更新 `SYSTEM_ARCHITECTURE.md`。
4. 更新 `SYSTEM_DEPENDENCY.md`。
5. 更新 `SYSTEM_LIFECYCLE.md`。
6. 更新 `SYSTEM_PRIORITY.md`。
7. 更新受影响 Professional System README。
8. 更新 Code Contract 与 Tests。
9. 更新 QA 与 Release Gate。
10. 使用独立可审查 Commit。

禁止：

- 因一个新类或新 Agent 就创建新 Professional System。
- 因目录调整就宣称架构改变。
- 只修改代码而不更新系统关系。
- 只修改架构图而不处理运行影响。

---

# 26. Architecture Review Checklist

System Architecture Review 必须确认：

- 每个 System 只有一个主要使命。
- 职责与边界同时清楚。
- 输入与输出可追踪。
- 上游与下游方向合理。
- 接口不是隐式共享状态。
- Visual System 职责没有被其它系统覆盖。
- Animation 受 Visual、UI、Accessibility 与 Performance 约束。
- AI Review 不拥有自动批准权。
- QA 不创造规则。
- Release 不降低质量。
- 当前实现与规划状态明确区分。
- 不存在因文件或测试存在而产生的完成声明。
- 失败能够返回正确上游 System。

任一关键边界不清楚：

Architecture Review 必须 FAIL。

不得继续扩大实现。

---

# 27. Permanent Rule

Phoenix 由以下 Professional Systems 共同组成：

- Core System。
- Story System。
- Visual System。
- Learning System。
- UI/UX System。
- Audio System。
- Animation System。
- Content System。
- Code System。
- Performance System。
- Accessibility System。
- QA System。
- Release System。
- AI Review System。

每个 System 必须拥有明确：

- 使命。
- 职责。
- 边界。
- 输入。
- 输出。
- 上游依赖。
- 下游依赖。
- 禁止承担的职责。
- 与其它系统的接口。

任何 System 都不得：

- 越过 Core 原则。
- 接管其它 System 的专业权威。
- 用实现便利修改上游意图。
- 用文件存在证明正式完成。
- 绕过 Performance、Accessibility、AI Review、QA 或 Release Gate。

Story 定义世界。

Content 让世界可追踪地进入产品。

Learning 定义如何学习。

Visual 定义世界如何被看见。

UI/UX 定义如何操作。

Audio 定义如何被听见和练习。

Animation 定义批准的状态如何自然运动。

Code 负责实现。

Performance 与 Accessibility 保证体验能够稳定抵达 Explorer。

AI Review 与 QA 提供独立检查证据。

Release 只交付已经通过审核的结果。

只有系统边界、接口、实现、验证与交付证据保持一致，Phoenix 才允许进入下一阶段。
