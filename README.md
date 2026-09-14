# Phoenix Journeys

**世界很大，从一门语言开始。**

Phoenix Journeys 是一款以“语言旅程”为核心的移动学习产品。第一阶段专注中文，通过故事、词汇、文化探索、AI 互动与个人回忆，让 Explorer 不只是学习语言，也逐渐理解中国与世界。

## 当前阶段

- 版本：v0.1 Founder Prototype
- 平台：Flutter
- 首个 Journey：北京 · 紫禁城
- 状态：内部开发与 Founder 验收
- 首位 Explorer：Toni

## 核心原则

- 中文为主要学习内容，翻译只是辅助。
- 所有事实必须可验证；传说、争议观点和解释必须明确标注。
- 图片、字体、音乐、插图和 UI 资源必须原创或拥有合法授权。
- 免费 Explorer 可以探索所有 Journey；付费仅提高每日探索容量。
- 不加入第三方广告。
- 不使用签到焦虑、金币诱导或强迫式留存。
- 每次学习自动保存，形成可回顾的成长时间轴。

## Repository Structure

- `app/` Flutter 移动应用
- `backend/` Supabase 数据库与服务设计
- `ai/` AI Prompt、内容审核和交互规范
- `content/` Journey 内容、词汇和来源记录
- `design/` 设计系统、原创素材规范和授权记录
- `docs/` 产品文档、验收规范和决策记录
- `roadmap/` 版本路线图
- `.github/` Issue、PR 与 CI 工作流模板

## 本地运行

```bash
cd app
flutter pub get
flutter run
```

## 下一里程碑

完成 v0.2 Founder Experience：

1. 中文为主、母语解释可设置
2. 简繁一键切换
3. Story 点词释义
4. AI 回应思考与写作
5. 自动保存 Memory
6. 原创词汇小插图
7. 正确的北京地图定位
