# Phoenix Documentation

> 状态：全项目文档导航  
> 最后整理：2026-08-01

本目录是 Phoenix 开发与内容治理入口。任何 AI 或开发者开始工作前，先读取 `AI_DEVELOPMENT_GUIDE.md`、`PRODUCT_PRINCIPLES.md`，再读取与任务相关的专项规范和当前代码、测试、PR、Preview。

## 读取优先级

1. Founder 当前任务中的最新明确决定
2. `AI_DEVELOPMENT_GUIDE.md`
3. `PRODUCT_PRINCIPLES.md`
4. 与任务对应的专项系统，例如 `story/`、`UI_GUIDELINES.md`、`CONTENT_QUALITY.md`
5. 当前代码与自动测试形成的可执行契约
6. `ROADMAP.md`、`TODO.md`
7. `CHANGELOG.md`

规则冲突不得静默处理。必须确认最新决定，并在同一次变更中同步文档、代码与测试。

## 核心文档

- `AI_DEVELOPMENT_GUIDE.md`：全项目最高级开发流程、权限与完成定义。
- `PRODUCT_PRINCIPLES.md`：产品使命、学习原则、访问规则、隐私与决策边界。
- `ROADMAP.md`：阶段方向与退出标准。
- `TODO.md`：尚未完成、可验收的工作。
- `CHANGELOG.md`：已完成变化、版本与发布证据。
- `CONTENT_QUALITY.md`：全 Journey × Phoenix Lv.1–10 内容发布 Gate。
- `UI_GUIDELINES.md`：移动端、朗读、地图、护照、视觉与交互规范。
- `REVIEW_CHECKLIST.md`：开发与发布复核清单。

## Story System

所有涉及故事、短文、特别旅程、Discovery、挑战语境、回忆提示或故事库扩张的任务，必须在开始前完整读取 `story/` 下全部规范。

入口：[`story/README.md`](story/README.md)

Story System 不是建议集，而是发布契约。任何故事或等级短文未通过 Story Quality Gate，不得进入 Preview 发布流程。

## 固定 Journey 流程

```text
故事 → 单词 → 发现 → 挑战 → 回忆 → 完成与盖章
```

“思考／表达”不属于公开 Journey 步骤。跟读训练保持独立导航入口。

## 维护规则

- 一个规则只在一个主文件中完整定义，其他文档使用链接引用。
- 新增长期规则时，必须同步相关测试或 Review Gate。
- 已完成 TODO 移入 `CHANGELOG.md`。
- 不直接修改或自动合并 `main`，只有 Founder 明确批准后才可合并。
