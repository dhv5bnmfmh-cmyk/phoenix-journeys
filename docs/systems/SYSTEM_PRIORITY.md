# Phoenix System Priority

Documentation Status: Reconstructed and Reviewed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest)
Owner: Phoenix Documentation Architecture

---

# 1. Purpose

Phoenix System Priority（简称 PSP）定义 Phoenix 在规范、指令、计划、记录与既有实现发生冲突时的唯一裁决顺序。

本文件负责：

- 识别真实冲突。
- 确定适用的上位权威。
- 规定高优先级规则覆盖低优先级内容的条件。
- 规定无法安全裁决时的停止与报告机制。
- 规定临时例外的授权、期限、补偿措施与回收方式。
- 规定上游规范变更向下游 Documentation、实现、测试与发布流程的传播方式。

本文件不负责：

- 替代 `PHOENIX_CONSTITUTION`、`PRODUCT_PRINCIPLES` 或任何 Professional System 规范。
- 创造 Story、Learning、Visual、UI、Audio 或其他专业规则。
- 将计划、任务、历史记录或现有代码提升为产品原则。
- 以“优先级较高”为理由绕过安全、法律、平台权限或强制 Quality Gate。
- 声称仓库中尚不存在的规范已经完成。

本文件适用于未来 AI、开发者、设计者、内容作者、审核者、QA 与 Release Owner。

---

# 2. Core Rule

Phoenix 使用两层裁决模型：

1. **Boundary Gate**：先检查安全、法律、平台能力与当前操作权限。任何越界请求必须被阻止，不能进入普通优先级比较。
2. **Authority Order**：在 Boundary Gate 允许的范围内，按本文件的唯一顺序确认产品意图、专业规则、执行方式与实现状态。

因此，“用户当前明确指令”是允许范围内最高的任务意图与授权来源；它不是安全、法律或平台限制的豁免权。

任何文件不得通过重新编号、局部声明或实现惯例改变本顺序。若下游文档给出不同顺序，以本文件为准，并必须修正下游文档。

---

# 3. Canonical Priority Order

以下 17 项构成 Phoenix 唯一规范优先级。编号不得被理解为允许第 1 项覆盖第 2 项；第 2 项是对全部项目生效的不可覆盖 Boundary Gate。

## 1. 用户当前明确指令

用户在当前任务中明确给出的目标、范围、禁止事项、交付物与授权，是允许范围内最高的任务意图来源。

它可以：

- 缩小或停止当前任务。
- 指定只修改某个文件。
- 改变 ROADMAP 或 TODO 中的执行顺序。
- 要求现有实现与正式规范对齐。
- 明确发起一项规范变更，但该变更仍须完成相应治理、同步与 Gate。

它不可以被推断为：

- 同意未说明的破坏性修改。
- 同意覆盖用户已有工作。
- 同意合并、发布、删除、迁移或外部写入。
- 放弃安全、版权、隐私、可访问性、质量或平台权限要求。
- 授权与当前目标无关的系统扩张。

旧聊天记录、模糊记忆与推测出的偏好不等于当前明确指令。

## 2. 安全、法律和平台限制

安全、法律、版权、隐私、平台政策、运行环境权限与不可绕过的技术限制，是绝对边界。

它们必须在执行第 1 项前检查。发生冲突时：

- 禁止执行不安全、违法、侵权、越权或平台不允许的动作。
- 禁止以用户授权、项目规范、时间压力或既有实现作为例外理由。
- 必须说明被阻止的具体动作、原因与可行的安全替代方案。
- 若没有合规替代方案，必须停止。

## 3. `PHOENIX_CONSTITUTION`

Phoenix Constitution 定义产品不可轻易改变的核心身份、价值、保护边界与最高产品原则。

它约束全部 Professional Systems、产品决策与正式发布。任何下游规范不得削弱其要求。

当前仓库未提供已确认完成的 `PHOENIX_CONSTITUTION` 正式文件。未来该文件建立前，不得虚构其条款，也不得用较低层文档冒充 Constitution。遇到必须依赖其裁决的核心身份冲突时，必须报告缺失并停止相关决定。

## 4. `PRODUCT_PRINCIPLES`

Product Principles 将 Phoenix 的产品价值转化为跨系统的产品决策原则。

它约束 Architecture 与各 Professional System，但不得覆盖 Constitution。仓库中的 `docs/PRODUCT_PRINCIPLES.md` 只能按其实际状态、版本与内容使用；文件存在不自动证明它已完成正式治理或高于本层级。

## 5. Systems Architecture

Systems Architecture 层包括：

- `docs/systems/README.md`
- `docs/systems/SYSTEM_ARCHITECTURE.md`
- `docs/systems/SYSTEM_DEPENDENCY.md`
- `docs/systems/SYSTEM_LIFECYCLE.md`
- `docs/systems/SYSTEM_PRIORITY.md`

该层定义 Documentation Navigation、系统职责边界、依赖方向、生命周期、Gate 位置与冲突裁决。它不替代专业系统内部规则。

同层文件发生表面冲突时，先按职责裁决：

- 入口、读取顺序与维护：Documentation README。
- 系统使命、职责、边界与接口：SYSTEM_ARCHITECTURE。
- 必须依赖、可选依赖与信息流：SYSTEM_DEPENDENCY。
- 阶段、进入条件、退出条件与回退：SYSTEM_LIFECYCLE。
- 规范冲突与例外：SYSTEM_PRIORITY。

若职责分流后仍存在直接矛盾，必须停止并提交 Systems Documentation Review，不得任意选择。

## 6. 对应 System Constitution

Professional System Constitution 定义该系统内部不可违反的最高规则。

例如，Visual 任务必须服从 `docs/visual/VISUAL_CONSTITUTION.md`。System Constitution 只在自身专业边界内具有最高专业权威，不得改变 Story、Learning、UI、Audio、QA、Release 或其他系统的所有权。

## 7. 对应 Philosophy

Philosophy 解释对应 System Constitution 应如何转化为长期设计判断、体验倾向与取舍原则。

Philosophy 不得新增与 Constitution 相反的硬规则，也不得替代具体 Guidelines、Pipeline 或 Gate 的执行要求。

## 8. 对应 Guidelines

Guidelines 将 Constitution 与 Philosophy 转化为可执行的专业规范、限制与推荐做法。

Guidelines 必须保持上游含义，不得因便于实现而降低上游标准。领域专项 Guidelines 在其明确范围内优先于通用 Guidelines，但必须同时服从同一上游。

## 9. Decision Tree

Decision Tree 根据已批准的上游规范帮助执行者在具体条件下选择路径。

Decision Tree 只能路由决定，不能创造新的 Constitution、Philosophy 或 Guideline。缺少适用分支时必须返回上游澄清，不能自行补写产品原则。

## 10. Pipeline

Pipeline 定义从输入到可审核产物的执行阶段、负责人、输入、动作、输出与回退路径。

Pipeline 必须执行上游决定，不得通过阶段顺序弱化专业规则。若 Pipeline 与 Decision Tree 冲突，先按 Decision Tree 确认所选路径，再修正 Pipeline。

## 11. Quality Gate

Quality Gate 定义产物是否可以进入下一阶段或 Release 的强制通过条件。

Gate 是上游标准的验证机制，不是新的产品原则。任何强制 Gate 失败都必须阻止流转，并按对应 Pipeline 或 Lifecycle 返回上游修正。

## 12. Checklist

Checklist 是执行与审核时的完整性核对工具。

Checklist 不得降低 Gate，也不能因为项目未列入清单就证明其合格。发现清单遗漏上游强制项时，必须先遵循上游规则并同步修正 Checklist。

## 13. Review Prompt

Review Prompt 为 AI 或人工 Reviewer 提供一致的检查输入、角色、问题与输出格式。

Review Prompt 不具有修改规范的权力。Prompt 输出是 Review Evidence，不是自动批准；最终结论必须依据相应 Gate 与负责人权限。

## 14. `ROADMAP`

ROADMAP 记录已批准方向、阶段目标、依赖与预期顺序。

ROADMAP 描述未来准备做什么，不证明功能已经实现，也不得覆盖正式规范或当前明确指令。

## 15. `TODO`

TODO 记录可执行但尚未完成的工作项、负责人、状态与近期待办。

TODO 不是产品规范、完成证据或 Release 许可。TODO 与 ROADMAP 冲突时，应先依据 ROADMAP 与当前明确指令澄清任务来源。

## 16. `CHANGELOG`

CHANGELOG 记录已经发生并经过确认的版本变化、迁移、修复与发布事实。

CHANGELOG 不能定义未来行为，也不能为不符合上游规范的实现追授合法性。记录错误时应更正记录并保留可追踪的修正事实。

## 17. 代码中的既有实现

代码、资源、配置与当前页面行为是“当前实现是什么”的证据，不是“产品应当是什么”的最高来源。

既有实现与正式规范冲突时，默认结论是 Implementation Gap：修正实现、补充测试，并在需要时更新 CHANGELOG。只有在上游规范经过正式变更后，才可保留不同于旧规范的实现。

不得因为代码已经存在、测试已经通过或用户已经看见，就跳过产品、专业、QA 或 Release 规则。

---

# 4. Current Repository Reality

优先级是治理结构，不是文件完成状态声明。

执行任务前必须逐项确认：

- 目标层级的文件是否真实存在。
- 文件是否标记为 Completed、Reconstructed、Draft、Deprecated 或其他实际状态。
- 版本是否适用于当前产品与任务。
- 文件是否被更高层规范替代。
- 相应实现、测试与发布证据是否存在。

当前已确认重建的 Systems 文件不能证明全部 Core、Story、Learning、UI、Audio、QA、Code 或 Release 规范已经恢复。当前已恢复的 Visual 文件只对 Visual System 的专业范围负责。

缺失文件保留其应有层级，但不能被引用为已经写明某项规则。不得用低层文件自动填补高层规范内容。

---

# 5. Conflict Identification

冲突不是“两个文件提到同一主题”，而是两个可适用要求在同一时间、同一对象、同一范围内无法同时满足。

每次冲突检查必须完成以下动作：

1. **确认对象**：页面、Journey、资产、数据、交互、代码、流程或 Release。
2. **确认范围**：全局、系统、功能、页面、设备、地区、语言、版本或环境。
3. **确认状态**：已完成、开发中、规划中、已弃用或未经确认。
4. **提取要求**：将相关内容转成可验证的“必须、禁止、允许、推荐”陈述。
5. **确认来源**：记录文件路径、章节、版本、状态与当前用户指令原文。
6. **确认时间**：判断要求是否属于当前有效版本，而非历史记录或未来计划。
7. **尝试并存**：先检查是否只是范围不同、阶段不同、专业职责不同或实现尚未同步。
8. **认定冲突**：只有无法同时满足时才进入优先级裁决。

以下情况通常不是规范冲突：

- ROADMAP 描述规划中能力，而代码尚未实现。
- CHANGELOG 描述历史行为，而当前 Guidelines 已更新。
- Visual 与 Story 分别定义表现和叙事内容，且没有越过接口边界。
- Checklist 遗漏某项 Gate 要求。
- 代码没有达到正式 Documentation 的要求。

这些情况分别属于状态差异、历史差异、职责分工、工具遗漏或 Implementation Gap，必须按各自流程处理。

---

# 6. Conditions for Override

高优先级来源只有同时满足以下条件，才能覆盖低优先级来源：

- 两者确实适用于同一对象、范围、时间与版本。
- 高优先级要求内容明确，不依赖猜测或旧聊天记录。
- 高优先级来源真实存在、状态有效且未被废弃。
- 执行方式通过安全、法律与平台 Boundary Gate。
- 覆盖不越过 Professional System 的职责边界。
- 所需变更已获得与风险相称的明确授权。
- 强制 Lifecycle 与 Quality Gate 仍被执行。
- 受影响的下游文档、代码、测试和记录进入同步清单。

“覆盖”表示当前决策采用上位要求，并修正不一致的下位内容。它不表示可以保留永久矛盾，也不表示可以静默改写历史事实。

高优先级来源存在歧义、缺失、失效或内部矛盾时，不得凭排名强行裁决。

---

# 7. User Instruction and Hidden Damage

当前明确用户指令必须被尊重，但不得造成隐性破坏。

执行前必须检查：

- 是否会修改请求范围外的文件、系统或外部资源。
- 是否会覆盖用户已有且与任务无关的改动。
- 是否包含删除、强制覆盖、不可逆迁移、合并或发布。
- 是否会改变数据、账号、权限、成本、隐私或第三方状态。
- 是否会绕过版权、文化真实性、Accessibility、Performance、QA 或 Release Gate。
- 是否会使 Story、Learning 或核心操作流程变得不可读、不可用或不可验证。
- 是否将“实现一个结果”错误扩展为“改变正式规范”。

若损害不是用户实现当前目标所必需且明确授权的，不得执行。

若用户指令与用户同一请求中的禁止事项、交付目标或保护条件冲突，必须指出具体矛盾并请求裁决。不得选择更方便执行的一条，也不得把沉默当作授权。

---

# 8. Conflict Decision Procedure

所有规范冲突必须按以下顺序处理：

1. 暂停受冲突影响的修改、导入、合并或发布。
2. 执行安全、法律与平台 Boundary Gate。
3. 写明冲突对象、双方要求、来源、状态、版本与影响范围。
4. 排除状态差异、职责分工、范围差异与 Implementation Gap。
5. 为真实冲突标注本文件中的权威层级。
6. 验证高位要求是否满足覆盖条件。
7. 采用高位要求，并确定低位内容的修正方式。
8. 建立下游同步清单、Owner 与验证证据。
9. 重新执行受影响的 Review、QA 与 Quality Gate。
10. 只有全部强制项通过后，才允许继续 Preview、Release 或正式导入。

若无法确认适用范围、权威层级、用户真实意图、必要授权或安全结果，必须停止并报告，不得自行折中。

报告至少包含：

- 冲突摘要。
- 涉及文件与章节。
- 相关实现或证据。
- 无法裁决的原因。
- 已停止的动作。
- 可选方案及各自影响。
- 需要谁作出什么决定。

---

# 9. Same-Level Conflict

同一层级的内容不得按文件更新时间、篇幅、作者身份或实现便利程度裁决。

必须依次检查：

1. 专业职责是否不同。
2. 通用规则与专项规则的范围是否不同。
3. 文件版本与状态是否不同。
4. 是否已有明确的替代或弃用记录。
5. 是否存在更高层共同上游可作裁决。

专项规则只在其明确范围内优先于通用规则。它不得违反共同上游。

仍无法解决时，必须停止，并由对应 System Owner 与 Documentation Architecture 共同 Review。涉及 Core 身份、跨系统边界或 Release 阻断时，还必须升级至 Product Owner 或用户明确裁决。

---

# 10. Temporary Exceptions

临时例外只用于有边界、可恢复、可验证的短期情况，不得成为规避正式规范的捷径。

每个例外必须在执行前记录：

- Exception ID。
- 提出者与批准者。
- 被例外的准确文件、章节与规则。
- 业务或技术原因。
- 适用系统、文件、页面、版本与环境。
- 生效时间与明确失效时间或撤销条件。
- 风险与受影响用户。
- 补偿控制与必须保留的 Gate。
- 验证方法与证据位置。
- 回滚方案与 Owner。
- 需要同步的 Documentation、代码、测试、ROADMAP、TODO 与 CHANGELOG。

临时例外不得覆盖：

- 安全、法律、版权、隐私或平台限制。
- 未经确认的商业使用权。
- Constitution 的不可违反要求。
- 未授权的破坏性操作、合并或 Release。
- 会阻断核心学习流程、阅读、操作或 Accessibility 的缺陷。
- 无法回滚、无法验证或没有责任人的风险。

例外到期即失效。继续使用必须重新 Review 与批准。例外不自动形成先例，也不得静默改写原规范；若短期情况成为长期需求，必须从相应上游规范发起正式变更。

---

# 11. Downstream Propagation

任何正式规范变更都必须传播到所有受影响的下游来源。只更新上游文件而保留已知矛盾，不算变更完成。

| 变更来源 | 必须检查的下游 |
| --- | --- |
| PHOENIX_CONSTITUTION | PRODUCT_PRINCIPLES、全部 Systems Architecture、各 System Constitution 及所有执行与发布规范 |
| PRODUCT_PRINCIPLES | Systems Architecture、相关 System Constitution、Philosophy、Guidelines、产品计划与实现 |
| Systems Architecture | Dependency、Lifecycle、Priority、相关专业系统接口、QA 与 Release |
| System Constitution | Philosophy、Guidelines、Decision Tree、Pipeline、Gate、Checklist、Review Prompt、实现与测试 |
| Philosophy | Guidelines、Decision Tree、Pipeline、Gate、Checklist、Review Prompt 与体验实现 |
| Guidelines | Decision Tree、Pipeline、Gate、Checklist、Review Prompt、代码、资产与测试 |
| Decision Tree | Pipeline、Gate、Checklist、Review Prompt 与条件分支实现 |
| Pipeline | Gate、Checklist、Review Prompt、负责人交接、自动化与运行手册 |
| Quality Gate | Checklist、Review Prompt、QA 证据、Release 阻断条件 |
| ROADMAP / TODO | 仅同步计划、任务状态与负责人；不得反向改写正式规范 |
| CHANGELOG | 同步真实已发生变化；不得反向授权规范或实现 |
| 既有实现 | 若不一致则修正实现；如需改变产品规则，必须先从适当上游发起正式变更 |

传播流程必须：

1. 建立受影响文件、系统、页面、资产、代码、测试与 Release 的清单。
2. 指定每项 Owner 与状态。
3. 更新上游版本与变更理由。
4. 按依赖方向更新下游，不得反向污染上游。
5. 重新执行相关 Review、QA 与 Quality Gate。
6. 将真实完成结果写入 CHANGELOG；未完成项只能进入 ROADMAP 或 TODO。
7. 在所有强制同步与验证完成前，阻止受影响内容进入正式版。

---

# 12. Cross-System Rules

跨系统冲突必须先遵守 Systems Architecture 与 System Dependency 的边界和流向。

- Story 定义叙事事实、语境、角色、地点与情绪目标；Visual 表达这些内容，不得擅自改变故事事实。
- Learning 定义学习目标、任务、反馈与评估；UI、Visual、Audio 与 Animation 不得妨碍理解和完成流程。
- Visual 定义视觉真实性、一致性、构图、生成与质量要求，但不得接管 Story 或 Learning 决策。
- UI/UX 定义交互层级、导航、可读性和操作反馈；不得以界面便利改写内容或学习目标。
- Audio 与 Animation 增强体验，但不得覆盖可访问性、性能、阅读或核心操作。
- QA 验证各系统的已批准标准，不替代专业 Owner 创造规则。
- Release 只接收通过全部必需依赖与 Gate 的候选版本，不能用排期压力降低标准。

Visual System 内部必须保持当前已恢复规范的权威关系：Visual Constitution 高于 Visual Philosophy 与各 Visual Guidelines。视觉美观不得覆盖文化真实性、版权、可读性、按钮安全区、学习流程、性能或设备适配要求。

明显 AI 错误、版权或商业使用权无法确认、影响阅读或操作、动态效果不自然且没有合格静态降级、设备与性能验证未完成的视觉资源，不得因已生成或已接入代码而进入正式版。

---

# 13. Missing or Unavailable Authority

任务需要的高优先级规范缺失、无法读取或状态不明时：

- 不得猜测其内容。
- 不得用代码、TODO、ROADMAP、旧聊天记录或低层规范代替。
- 可以继续不依赖该规则的只读调查与明确范围内工作。
- 必须阻止依赖缺失裁决的不可逆修改、正式批准或 Release。
- 必须报告缺失项、受影响决定与继续所需输入。

若用户明确授权重建缺失文件，重建内容必须标注真实 Documentation Status，并按单独任务、Review 与 Commit 处理；不得声称是旧文件的逐字恢复。

---

# 14. Review and Evidence

每次重要冲突裁决必须留下可复核证据：

- 当前用户指令。
- 使用的 Documentation 路径、版本与状态。
- 冲突分类与优先级判断。
- Boundary Gate 结论。
- 采用与拒绝的方案。
- 下游同步清单。
- Review、测试与 Gate 结果。
- 例外记录（如有）。
- Commit、Preview 或 Release 标识（如适用）。

“AI 已检查”“测试通过”或“代码可运行”均不是单独充分证据。证据必须对应具体要求、范围与版本。

---

# 15. Prohibited Practices

Phoenix 禁止：

- 选择最方便的规范而忽略更高优先级来源。
- 用模糊用户意图覆盖明确正式规范。
- 用旧聊天记录冒充当前授权。
- 用代码现状反向定义产品原则。
- 用 ROADMAP、TODO 或 CHANGELOG 证明功能完成。
- 用 Checklist 或 Review Prompt 降低 Quality Gate。
- 静默保留已知的上下游矛盾。
- 通过临时例外形成永久旁路。
- 因赶进度跳过安全、专业、QA 或 Release Gate。
- 在冲突未解决时继续合并、发布或正式导入。
- 将规划中、开发中与已完成状态混写。

---

# 16. Mandatory Conflict Checklist

在裁决完成前，负责人必须确认：

- [ ] 已识别当前明确用户指令与任务边界。
- [ ] 已通过安全、法律与平台 Boundary Gate。
- [ ] 已读取真实存在且适用的上游规范。
- [ ] 已确认文件状态、版本、范围与时间。
- [ ] 已区分真实冲突、状态差异、职责分工与 Implementation Gap。
- [ ] 已按 17 项唯一顺序标注双方权威层级。
- [ ] 高优先级覆盖满足全部必要条件。
- [ ] 未产生未授权或隐性的破坏。
- [ ] 无法裁决的项目已停止并报告。
- [ ] 临时例外具有批准、期限、补偿控制与回滚方案。
- [ ] 所有受影响下游文件、实现与测试已进入同步清单。
- [ ] 必需 Review、QA 与 Quality Gate 已重新执行。
- [ ] 受影响内容在验证完成前未进入正式版。

任一强制项未满足，冲突不得标记为已解决。

---

# 17. Final Authority Statement

Phoenix 的优先级用于保护产品意图、专业边界与真实状态，不用于为捷径提供理由。

任何执行者都必须先守住安全、法律与平台 Boundary Gate，再在允许范围内遵循本文件的唯一权威顺序。高位来源负责裁决方向，低位来源负责落实、验证与记录；二者不一致时必须修正并传播，不能共存为长期矛盾。

无法安全、明确、可追踪地解决的冲突，必须停止并报告。
