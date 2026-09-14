# Phoenix 目的地背景永久规则

本文件继续定义 Phoenix 目的地背景的最终图库数量、离线运行时选择、格式、库存和回归要求。所有新建或替换 Journey 背景的生产、版权/IP、Pilot、审核与接入流程，必须同时遵守 [PHOENIX AI BACKGROUND PRODUCTION STANDARD](PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md)。如旧的生产顺序与该标准冲突，以该标准的 Pilot-first 与 Rights Gate 规则为准；本文件中有效的最终库存、运行时、metadata 与测试规则继续有效。

1. Phoenix 所有主要页面必须显示与当前 Journey 目的地相关的原创背景，不得长期使用统一通用背景。
2. 正式模式为省钱的离线图集方案：图片由 `PhoenixBackgroundLibrarianAgent` 在内容生产阶段提前规划、生成、审核并写入 App；探索者打开页面时禁止现场生成或等待图片 AI。任何生成、替换、评估或接入工作开始前，Agent 必须先读取并遵守 `PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md`。
3. 北京、上海、西安、杭州、成都、南京、广州，以及未来新增的每个城市，最终正式离线背景图库固定保持 10 张已批准图片；此数量要求不得被解释为允许跳过 Pilot。
4. 新增城市或新视觉方向必须先完成 Visual DNA、跨 Journey 差异化、Shot Plan，并且只生成 1–3 张 Pilot。Pilot 通过 Rights/IP、历史/文化、Mobile、视觉质量以及适用的 Founder 审核后，才允许扩展为最终 10 张完整图库。已有城市少于 10 张时仍应按批准后的生产节奏补齐，达到 10 张后只替换低质量、重复或不合规图片。**禁止在 Pilot 批准前直接生成 10 张正式候选图。**
5. 每城 10 张必须在地点、时间、天气、观察角度和场景主题上明显不同；构图唯一率必须为 100%。不同城市不等于不同视觉设计，必须同时通过跨 Journey 差异化与 Anti-Template Gate。
6. 新增正式背景默认必须为 AI Original；无文字、无 Logo、无商标、无水印、无受版权保护角色、无名人肖像、无签名、无复制海报且不得模仿具名在世艺术家或特定摄影师。互联网图片只能作为研究参考，`REFERENCE ≠ ASSET`。任何第三方生产资产例外必须具有独立验证的商业权利并明确记录。
7. `PhoenixVisualComplianceAgent` 必须审核生成提示词与候选成图；合规分数低于 90 或视觉丰富度低于 80 的图片不得发布。`complianceScore`、`varietyScore`、分辨率、AI metadata、文件存在或 hash 只是必要的自动化/技术证据，**不足以单独证明视觉质量、版权/IP 安全或可接入性**。每张图片仍必须通过 Rights Gate、IP Similarity Review、视觉质量与适用的人类/Founder 审核。
8. 图片统一使用 WebP，文件名为 `{journey-id}-{slot}-{scene}.webp`，并同步更新图片目录、manifest、Flutter 资源索引和 GitHub 仓库。生成母版不得直接作为巨大运行时资产发布；运行时文件必须按移动端解码、内存、文件大小、加载与视觉保真要求优化。
9. App 端只能通过 `JourneyBackgroundPolicy` 按“目的地 + 页面类型 + 本地日期”稳定选择已审核图片。同一天同一页面保持稳定，隔天自动轮换。运行时不得静默回退到错误城市、错误 Journey 或错误历史时代；加载失败必须使用安全 Phoenix fallback。
10. 背景必须保留足够留白与 UI Readable Region，确保中文、拼音、越南语翻译、按钮和朗读进度清楚可读。Mobile 为最终权威，桌面端美观不能弥补 portrait crop 失败。
11. 七城完整目标库存为 70 张；未来城市数量增加时，总目标自动按“城市数 × 10”计算。该数字是批准后的最终运行时库存目标，不是预批准生成配额。
12. 不再依赖 OpenAI API Key 或每日付费生成工作流。GitHub Actions 只负责免费校验规则、库存计划与回归测试。生产 provenance 不得记录任何 API Key、credential 或 secret。
13. 修改背景 Agent、随机规则、合规规则、库存或页面接入时必须更新回归测试；CI 失败时禁止合并。Agent 不得通过删除测试、降低视觉 baseline、硬编码 PASS、跳过 Rights review 或 Founder review 来取得接受状态。
14. 用户以后可直接发送：“请生成并更新 Phoenix 所有城市离线背景图库”或指定数量、城市；AI 必须先检查现有库存，再按 `PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md` 输出预生成 Visual DNA + Cross-Journey Difference + Shot Plan + 1–3 Pilot 计划。只有 Pilot 被批准后，才能按每城最终保持 10 张的规则继续完整生产。
15. 已批准生产图片不得静默覆盖。替换必须记录 Asset ID、Version、Previous Version、Replacement Reason、Review Status 与 Rollback Path，并保留标准要求的 provenance。
16. `NO RIGHTS GATE PASS = NO RUNTIME INTEGRATION`。Rights 不明确时状态为 `NOT APPROVED` / `BLOCKED`，不得用公开网站、搜索结果、博物馆网站、社交媒体或“AI 已生成”作为商业使用权利的推定依据。

当前状态：运行时离线背景轮换已经启用；现有七城种子图库继续作为过渡库存。后续新建、补齐与替换批次必须按 binding AI background production standard 的 Pilot-first、Rights/IP、Mobile、质量与批准流程执行，再达到每城最终 10 张的目标。
