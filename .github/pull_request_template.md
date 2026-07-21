## 本次修改

- 

## 独立体验链接

- 等待 `cloudflare/preview` 自动生成

## 合并前检查

- [ ] Phoenix Agent 规则测试通过
- [ ] Flutter Analyze 通过
- [ ] Flutter Test 通过
- [ ] Web Release 构建通过
- [ ] 独立 PR 体验链接可以打开
- [ ] 故事页朗读、暂停、继续、调速正常
- [ ] 发现页朗读、暂停、继续、调速正常
- [ ] 所有朗读默认 `1.0×` 本地自然语速，范围为 `0.5×–1.5×`
- [ ] 速度数字下方显示“减速 / 加速”，每次固定变化 `0.1×`，调整后全部朗读入口同步同一倍率
- [ ] 中文、英文、越南语使用正确本地语言与自然声音
- [ ] 声音、三角形、短文高亮同步
- [ ] 声音、进度、百分比、当前段落和字符三角形同步
- [ ] 生词与「注」临时朗读后从原准确位置继续
- [ ] 所有朗读入口共用 `NarrationController`，没有独立播放状态或计时器
- [ ] 故事页与发现页生词均显示词性、探索者母语和英文释义
- [ ] 生词查看与朗读正常
- [ ] 开发分支与 PR 体验版保持全部旅程开放
- [ ] 免费探索者每天稳定随机早晚各一段，同日两段不重复
- [ ] 付费探索者可以打开全部已发布旅程
- [ ] 免费、付费与随机旅程权限统一经过 `JourneyAccessPolicy`
- [ ] PhoenixBrainAgent 是唯一 AI 总调度入口
- [ ] Guide / Writing / Conversation / Learning 均由 PhoenixBrainAgent 调度并经过 PhoenixQualityAgent 隐藏复核
- [ ] GPT-5.6 通过 OpenAI Responses API 优先运行，Cloudflare Workers AI 自动回退
- [ ] PhoenixMemoryAgent 只处理有限客户端学习档案，服务器不持久保存
- [ ] PhoenixKnowledgeAgent 只提供已审核 Journey 背景
- [ ] 在线 AI 返回 orchestrator / provider / model / quality / memory / knowledge
- [ ] `OPENAI_API_KEY` 仅存在于 Cloudflare Secret，仓库与客户端没有密钥
- [ ] 思考、表达、旅程回忆键盘稳定
- [ ] 进度保存、简繁切换正常
- [ ] 用户已确认可以合并到 `main`

## 规则

未经体验确认，不合并到 `main`。一个 PR 只开发或修复一项功能。
朗读功能必须遵守 `docs/development-workflow.md` 中的「永久朗读开发准则」。
故事与发现生词必须遵守同文件中的「永久生词展示准则」。
所有 AI 功能必须遵守同文件中的「永久 AI Agent 开发准则」。
旅程开放、免费随机与付费权限必须遵守同文件中的「永久旅程访问与订阅准则」。
