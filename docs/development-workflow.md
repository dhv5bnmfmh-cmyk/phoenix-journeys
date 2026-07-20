# Phoenix Journeys 开发流程

## 稳定基线

- 正式分支：`main`
- 稳定备份：`stable/phoenix-baseline-2026-07-19`
- 稳定 Commit：`bbc5daf2dcbb88c72ac641d9bd4ab58a884384a1`

`main` 只保存已经体验确认、测试通过并可以正式上线的版本。

## 分支规则

- 新功能：`feature/<功能名称>`
- Bug 修复：`fix/<问题名称>`
- 工程与流程：`chore/<任务名称>`
- 稳定备份：`stable/<版本名称>`

每个分支只处理一项功能或一个问题。

## 标准流程

1. 从最新 `main` 创建独立分支。
2. 只在独立分支修改代码。
3. 创建 Pull Request。
4. 自动运行 Agent 测试、Flutter Analyze、Flutter Test 和 Web Release 构建。
5. 自动部署独立 Cloudflare Preview Worker。
6. 在 PR 中提供独立体验链接。
7. 用户在手机上体验新功能和旧功能回归。
8. 用户明确确认后，才允许合并到 `main`。
9. 合并后由 Cloudflare 正式部署。
10. PR 关闭后自动删除独立 Preview Worker。

## 永久朗读开发准则

以下规则适用于故事、发现、生词、例句、「注」、AI 内容以及今后新增的任何朗读入口，不得单独实现另一套朗读逻辑：

1. 所有朗读默认使用设备对应语言的本地自然语速，默认倍率固定为 `1.0×`。
2. 用户可调范围固定为 `0.5×–1.5×`；调整速度后必须从当前准确位置继续，禁止重新从头朗读。
   - 速度数字下方必须固定显示“减速”和“加速”两个选择；禁止改回独立倍率弹出菜单。
   - 每次点按“减速”或“加速”固定只变化 `0.1×`，不得使用其他步长。
   - 任一入口调整速度时，所有现有与之后打开的朗读入口必须立刻同步为同一倍率。
3. 简体中文使用 `zh-CN`，繁体中文使用 `zh-TW`，英文使用 `en-US`，越南语使用 `vi-VN`；优先选择 Natural、Premium 或 Enhanced 本地声音。
4. 所有朗读必须共用 `NarrationController`，它是播放、暂停、继续、速度、进度、百分比、当前段落和字符三角形的唯一状态来源。
5. 声音、进度条、百分比、当前段落和字符三角形必须同步；禁止 Widget 自己维护另一套计时器或播放状态。
6. 生词或「注」的临时朗读必须先保存原文准确位置；临时朗读结束后，仅当原文之前正在播放时，才从该位置自动继续。
7. 暂停、继续、切换语速、打开或关闭弹窗后，都不得丢失当前朗读位置。
8. 新增任何朗读功能时，必须同时增加或更新回归测试；违反以上规则时 CI 必须失败，禁止合并。

## 永久生词展示准则

以下规则同时适用于故事页与发现页，不允许两页使用不同的生词解释逻辑：

1. 故事页和发现页必须共用 `InteractiveStoryText` 与同一个 `WordEntry` 数据来源。
2. 点按短文中的生词后，必须显示汉字、拼音、词性、探索者母语释义和英文释义。
3. “探索者母语”和“English”必须有清楚标签；空间不足时允许自适应布局或滚动，但不得隐藏这两项释义。
4. 每个生词必须提供有效的 `partOfSpeech`、`translation` 与 `englishDefinition`，禁止用空值上线。
5. 修改任一页的生词展示时，必须同步验证另一页并更新回归测试；违反规则时 CI 必须失败。

## 永久 AI Agent 开发准则

以下规则适用于 Phoenix AI 2.0 与今后新增的任何 AI 功能：

1. `PhoenixBrainAgent` 是唯一 AI 总调度入口；页面不得自行选择模型或绕过 Brain 直接调用专家 Agent。
2. `PhoenixModelGateway` 是唯一模型供应商入口；默认使用 OpenAI Responses API 的 `gpt-5.6`，允许由服务器环境变量升级模型；密钥缺失或请求失败时自动回退 Cloudflare Workers AI。
3. OpenAI 请求必须设置 `store: false`；`OPENAI_API_KEY` 只能保存在 Cloudflare Secret，禁止写入 Flutter、GitHub、日志、网页或任何客户端资料。
4. `PhoenixGuideAgent` 只负责有依据的文化观察、语言引导和追问；禁止模板化称赞及编造 Journey 之外的历史事实。
5. `PhoenixWritingAgent` 只负责中文写作批改；不得为了显示修改而制造错误，必须区分必要修改与可选自然表达。
6. `PhoenixConversationAgent` 只负责自然中文口语陪练；每轮最多纠正一个高价值问题，禁止把聊天变成机械批改清单。
7. `PhoenixLearningAgent` 只依据真实学习记录生成报告与下一步计划；禁止虚构时长、正确率、考试成绩或不存在的错误。
8. `PhoenixQualityAgent` 是隐藏复核层；Guide、Writing、Conversation 和 Learning 在线结果都必须尝试复核；复核故障时保留主 Agent 结果，不得让请求失败。
9. `PhoenixMemoryAgent` 只整理探索者在客户端保存并主动提交的有限学习档案；默认 `client-private`，服务器不得持久保存学习记忆。
10. `PhoenixKnowledgeAgent` 只提供 Phoenix 已审核 Journey 背景；没有依据的年代、人物、数字和事件必须明确不确定，不得猜测。
11. 所有专家 Agent 必须共享辅助语言、简繁模式、收藏生词、已完成旅程、近期观察与近期写作问题，并严格限制数量和长度。
12. 在线结果必须返回 `orchestrator`、`provider`、`model`、`quality`、`memory` 与 `knowledge` 状态；App 不得假装使用未配置的模型或已完成的复核。
13. 新增或修改 AI 架构时必须增加 Prompt、调度、结构化输出、自动回退、隐私、记忆、知识 grounding 和质量复核测试；CI 失败时禁止合并。

## 禁止事项

- 禁止直接在 `main` 开发或试验。
- 禁止未经手机体验确认就合并。
- 禁止一个 PR 同时修改多个无关功能。
- 禁止为了新功能删除或绕过既有回归测试。
- 禁止使用正式线上链接测试未完成的新功能。
- 禁止绕过 `NarrationController` 直接在页面或组件中创建独立朗读状态。
- 禁止把默认朗读速度改成慢速教学语音；默认必须保持 `1.0×` 本地自然语速。
- 禁止在客户端或仓库中保存 `OPENAI_API_KEY`。
- 禁止绕过 `PhoenixBrainAgent` 或 `PhoenixModelGateway` 直接调用模型供应商。
- 禁止默认在服务器持久保存探索者的学习记忆。

## 核心回归功能

每次合并前至少确认：

- 故事页与发现页朗读
- 所有朗读默认 `1.0×` 本地自然语速，可调范围 `0.5×–1.5×`，每次加减速固定 `0.1×`
- 故事页与发现页生词同步显示词性、探索者母语和英文释义
- 暂停、继续与调语速保留准确位置
- 声音、进度、百分比、当前段落和字符三角形同步
- 生词与「注」临时朗读后按原位置继续
- 生词查看与自动朗读
- 简体与繁体切换
- 思考、表达、旅程回忆键盘稳定
- 进度保存
- PhoenixBrainAgent 正确调度 Guide、Writing、Conversation 与 Learning
- GPT-5.6 主模型、Cloudflare 回退和 PhoenixQualityAgent 复核
- PhoenixMemoryAgent 保持客户端隐私且不在服务器持久保存
- PhoenixKnowledgeAgent 只使用已审核 Journey 背景
- AI 状态不得误报，客户端与仓库不得出现密钥
- 城市印章和完成旅程流程
