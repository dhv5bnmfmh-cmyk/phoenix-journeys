# Phoenix Visual Performance Guide

Documentation Status: Active  
Documentation Version: 1.0.0

本规范是 Phoenix 全部视觉资源的性能、交付、生命周期与降级标准。视觉品质不得以首屏速度、页面流畅度、手机和平板能力、弱网络体验、内存稳定性、电池、可访问性或页面状态恢复为代价。高级感必须建立在稳定、流畅、克制、可测量和可降级的技术基础上。

本文件规定预算与执行方法，不替代 [Visual Pipeline](./VISUAL_PIPELINE.md)、[Visual Decision Tree](./VISUAL_DECISION_TREE.md)、[Image Quality Gate](./IMAGE_QUALITY_GATE.md)、[Visual Checklist](./VISUAL_CHECKLIST.md)、[Visual Review Prompt](./VISUAL_REVIEW_PROMPT.md) 或 [Copyright Policy](./COPYRIGHT_POLICY.md)。平台、浏览器与测量标准变化时，必须核验当时有效规范；若平台批准预算更严格，使用更严格者。

## 1. 适用范围

本规范适用于 AI 原创图片、静态与动态背景、Journey 背景、首页视觉、世界地图、城市地图、护照、故事、生词、发现、挑战、留下印象、盖章、Banner、Loading、Splash、UI 插画、Icon、SVG、Canvas、WebGL、CSS 动画、分层视差、短循环视频、程序化效果及其他 Phoenix 视觉资源。

它覆盖工作母版到运行时 Variant、传输、解码、渲染、缓存、回退、离页释放、返回恢复及页面级 QA。仅存档且永不进入构建的 Master 也须隔离，不能因“不直接显示”而进入生产包。

## 2. 性能最高原则

1. 首屏核心内容优先于装饰视觉。
2. 阅读和交互永远不能等待非必要动画。
3. 每个动态背景必须有同版本静态降级。
4. 弱网络和低性能设备必须能完成核心学习流程。
5. 不为视觉炫技引入过重依赖。
6. 不允许长期占用 GPU、CPU 或内存。
7. 页面离开或不可见后必须暂停或释放非必要资源。
8. 返回页面时必须恢复正确内容、状态与媒体关系。
9. 性能失败不可由视觉评分、排期或开发投入补偿。
10. 资源生成完成、单图清晰或高性能电脑运行正常，均不等于性能合格。

## 3. 性能预算体系

### 3.1 预算等级

| 等级 | 含义 | 处理 |
|---|---|---|
| `Target` | 日常设计与开发目标，保留设备和网络余量 | 超过时先优化并记录原因 |
| `Maximum` | 默认批准上限，也是上游 Gate 的边界 | 达到但未超过时必须提供实测理由；不得成为常态 |
| `Blocker Limit` | 超过即触发 Release Blocker | 必须优化、拆分、改变形式或降级；不得 Waive |

除另有批准专项预算外，`Maximum` 与 `Blocker Limit` 使用同一数值边界；“超过 Maximum”即“超过 Blocker Limit”。这保持与 `IMAGE_QUALITY_GATE.md` Gate 12 一致。专项预算只能更严格，不能由单个开发者放宽。

### 3.2 默认传输与资源预算

以下均指生产编码后的传输体积；页面总量按实际下载的唯一字节计算，缓存命中须另列，不能用缓存掩盖首次访问超限。

| 项目 | Target | Maximum / Blocker Limit | 判断范围 |
|---|---:|---:|---|
| 首屏关键静态视觉，单个 | ≤350 KB | 500 KB | LCP 或首屏必要背景 Variant |
| 首屏全部视觉总量 | ≤700 KB | 1 MB | 首次可用前实际请求视觉资源 |
| 非首屏全屏静态背景 | ≤550 KB | 800 KB | 单个 Device Variant |
| Banner / Card Illustration | ≤150 KB | 220 KB | 单个 Variant |
| Thumbnail / Map Node / Passport Marker | ≤80 KB | 120 KB | 单个资源 |
| Raster Icon | ≤20 KB | 32 KB | 单个资源；优先 SVG |
| 静态降级图 | ≤550 KB | 800 KB | 对应单个背景 Variant |
| 动态背景传输总量 | ≤1.5 MB | 2.5 MB | 进入页面所需全部动态层或视频 |
| 短循环视频 | ≤1.5 MB | 2.5 MB | 单个视频；必须 Poster 与静态回退 |
| SVG | ≤24 KB、≤200 个渲染节点 | 64 KB、≤500 个渲染节点 | 超出任一边界即改造或栅格化评估 |
| 新增 JS 动画依赖 | ≤30 KB gzip | 60 KB gzip | 单页面新增关键路径；共享依赖按实际增量 |
| 单 Journey 运行视觉总量 | ≤4 MB | 6 MB | 不含隔离 Master；含可能进入完整流程的 Variant |
| 单页面首轮并发视觉请求 | ≤6 | 10 | 首屏必要请求；非关键必须延迟 |

### 3.3 设备、运行与体验预算

| 项目 | Target | Maximum / Blocker Limit | 证据 |
|---|---:|---:|---|
| 动画帧率 | 稳定 60 fps | p95 ≥55 fps；不得持续出现 >50 ms 长帧 | 真机 Frame/Performance Trace |
| 低性能模式帧率 | 稳定 30 fps 或静态 | p95 <28 fps 持续 3 秒即必须再降级 | 低端真机录屏与 Trace |
| 页面视觉切换完成 | ≤300 ms | 800 ms | Route/User Timing；不含用户主动等待内容 |
| 可交互状态切换响应 | ≤100 ms | 200 ms | Event 到可见反馈 |
| 3G 模拟下核心文字可读 | ≤3 s | 5 s | 冷缓存、规定网络 Profile |
| 3G 模拟下静态背景或占位成立 | ≤5 s | 10 s | 超时必须保持可用并进入回退 |
| Long Task | 无 >50 ms | 单次 >200 ms 或连续阻断交互即 Blocker | Performance Trace |
| 视觉增量解码/渲染内存：低档手机 | ≤64 MiB | 96 MiB | 进入页面相对稳定基线增量 |
| 视觉增量解码/渲染内存：标准手机 | ≤96 MiB | 160 MiB | 同上 |
| 视觉增量解码/渲染内存：平板 | ≤160 MiB | 256 MiB | 同上 |

内存数值是 Phoenix 默认测试预算，不是浏览器进程总内存。若工具无法准确分离视觉增量，必须记录测量方法、连续 Journey 趋势和峰值；任何持续无界增长、崩溃、Context 丢失或系统强制回收均直接 Blocker，不受数值补偿。

### 3.4 分层判定

预算必须同时按页面用途（首屏/非首屏、地图、故事、学习页）、设备档位（低档手机、标准手机、平板）、DPI、网络、可见时长和静态/动态形式登记。高 DPI 不自动获得无限体积；浏览器只应取得接近实际显示槽位所需的最小 Variant。若画质与预算冲突，返回构图、格式、尺寸或静态/动态决策，不得静默突破 Blocker Limit。

## 4. 图片格式选择

| 格式 | 适用 | 禁止或谨慎场景 | 回退与编码原则 |
|---|---|---|---|
| AVIF | 大尺寸照片、复杂插画、压缩收益明确的背景 | 目标浏览器/解码性能不明；细线或透明边缘失真 | `<picture>` 优先源；必须 WebP/JPEG 回退；以目标显示尺寸验证色彩、透明度和解码 |
| WebP | 通用背景、插画、透明资源及 AVIF 回退 | 编码后纹理、文字边缘或透明度不合格 | 作为主兼容格式；质量按实际页面而非编码数字决定 |
| PNG | 必须无损、复杂透明通道且其他格式不满足 | 照片型大背景、无理由的超大透明画布 | 先裁空白、量化与验证；不得以 PNG 规避格式决策 |
| SVG | Icon、简单图形、地图节点、可缩放 UI 与程序化视觉 | 复杂照片式矢量、大量 Path/Filter、未清理外部引用或脚本 | 清理脚本与外部引用；限制 DOM/路径复杂度；提供语义或装饰标记 |
| JPEG | 兼容回退或无透明的特定照片资源 | 透明资源、多次重编码、明显色带/压缩块 | 单次从母版编码；质量以目标设备可见缺陷为准 |

格式选择必须记录候选体积、画质、浏览器支持、解码成本和回退。不得仅因某格式“更新”就忽略目标设备解码表现。

## 5. 响应式图片

每个适用资源必须提供手机、平板、桌面预留、横/竖屏、DPR、缩略图、首屏和静态降级所需 Variant。使用 `srcset` 声明宽度候选、用 `sizes` 描述真实显示槽位、用 `<picture>` 处理 AVIF/WebP/JPEG 或艺术裁切；基础 `<img>` 必须具有兼容源、固有宽高及适当加载优先级。

浏览器应自动选择最接近实际需求的资源。禁止小屏下载桌面原图、用 CSS 单纯缩小 4K 文件、无上限供应 DPR、同时请求多套格式、因媒体条件重叠重复下载。每个 Variant 必须验证主体裁切、多语言安全区与横竖屏，不得只验证像素尺寸。

## 6. 图片生成与导出

原始生成尺寸应支持最大批准裁切和必要高 DPI，不以“越大越好”为目标。工作母版保留最大可编辑质量；发布文件从母版一次导出手机版、平板版、高 DPI 版、缩略图和静态回退版，不从已压缩发布文件继续派生。

导出流程必须记录：母版尺寸和色彩空间、目标显示槽位、导出尺寸、编码格式与参数、压缩前后体积、目标页面截图、质量结果、元数据清理、文件名、SHA-256 和 Git Blob SHA。发布资源使用适合 Web 的一致色彩空间；删除无用 EXIF、定位、设备、作者隐私及冗余 Profile，同时保留版权政策要求的私密证据关联。

禁止无优化导入 4K 或更大原始文件、重复有损保存、不必要高位深、无用 EXIF/隐私数据、把原始生成文件当发布文件或把 Master 放入生产构建。

## 7. 首屏加载策略

先识别核心文字、交互与唯一 LCP 候选。只有当前路由首屏必见、决定 LCP 且预算允许的资源可预加载，并使用正确的响应式候选与优先级；不是所有首页、地图或 Journey 资源都应预加载。

非关键背景、动效层和后续页面资源延后。占位可使用稳定颜色、轻量渐变、低清模糊图或同构图静态封面，必须预留宽高以避免布局跳动。加载完成采用克制渐进显示；失败时保持占位和核心操作，禁止黑屏、空白背景或长遮罩。重复预加载、预加载错误 Variant、抢占字体/核心 JS/音频或预加载后不使用均判为性能问题。

## 8. 懒加载与预取

非首屏图片默认懒加载。下一页面只在用户路径高度确定、当前关键请求完成、网络与设备允许且资源预算明确时预取。地图热点、护照条目、特别 Journey 和动态资源按需加载；用户未进入的页面不得无意义下载。

快速切换时必须取消或忽略旧请求结果，使用 Asset ID 与页面实例防止陈旧响应覆盖新页面。返回页面优先复用有效缓存与已解码的合理小资源，但不得保留高成本动态实例。失败须进入有限次数、指数退避或用户触发的重试；离线、超时和缓存命中分别记录。预取不得造成重复请求或挤占自动朗读与当前交互。

## 9. 缓存与版本管理

生产资源使用内容哈希文件名；不可变 URL 可长期缓存，HTML、Manifest 与映射采用能及时发现新版本的策略。资源更新必须产生新哈希与 URL；旧资源只有在所有引用和回滚窗口结束后清理。

缓存策略必须同时记录 `Cache-Control`、CDN、浏览器与 Service Worker 行为。Service Worker 不得缓存错误响应、无限增长或长期固定旧 Manifest；更新失败应回到已验证版本，缓存损坏应可删除并重新获取。防止缓存穿透、多个 URL 存相同内容、删除文件仍被旧代码引用及各自拼接无统一规则的 Cache Busting。

## 10. 动态背景技术选择

| 技术 | 适用条件 | 主要成本与限制 | 必须降级 |
|---|---|---|---|
| CSS Animation | 少量 transform/opacity、简单循环 | 合成层、重绘与可读性 | 静态状态 |
| SVG Animation | 少量矢量形状与 Icon 状态 | DOM/Path/Filter 成本 | 静态 SVG/位图 |
| Canvas | 中等数量程序化对象且 DOM 不适合 | 主线程、DPR、重绘与内存 | 分层或单张静态 |
| WebGL | 只有 GPU 渲染能明显提升且已证明兼容 | 初始化、纹理、Context、GPU、电池 | Canvas 或静态 |
| 分层视差 | 已有前中远景且小幅位移能增强空间 | 多层解码、合成与眩晕 | 单张静态 |
| 短循环视频 | 连续复杂运动无法由轻量方案表达 | 传输、解码、内存、电池、自动播放 | Poster/高清静态 |
| 程序化粒子 | 少量、必要、可控的氛围效果 | CPU/GPU、机械循环、视觉干扰 | 无粒子静态 |
| 混合方案 | 单一方案确实不能满足且总成本更低 | 生命周期和失败路径复杂 | 去除高成本层后的静态 |

选择必须比较视觉价值、复杂度、维护、体积、CPU/GPU/内存、电池、兼容、无障碍、降级和开发成本。不得为技术展示选择 WebGL、视频或重型库；若轻量方案或高清静态提供等价体验，选择更简单者。

## 11. 动画性能

目标为稳定 60 fps；Gate 标准为审核设备 p95 不低于 55 fps，且不持续出现超过 50 ms 的长帧。低性能模式可稳定 30 fps，若 p95 低于 28 fps 持续 3 秒必须继续降级或静态化。掉帧按 Frame Trace 与用户可见卡顿共同判断，不能只看平均值。

同时运行的持续背景动画层 Target ≤3、Maximum 5；超过即合并或静态化。动画只在可见且必要时运行；`visibilitychange`、路由离开、组件卸载、Reduced Motion、低性能或省电状态必须暂停/销毁，返回时从业务状态而非重复初始副作用恢复。

优先 `transform`、`opacity` 和经过验证的有限合成层。谨慎使用大面积 `filter`、`blur`、动画 `box-shadow`、触发布局属性、高频 DOM 更新、大量粒子和多层视频。不得以 `will-change` 无限创建合成层；只在动画前短期启用，结束后移除。

## 12. 视频背景规范

视频仅在连续运动对故事氛围有明确价值、轻量动画或分层静态无法等价表达、版权通过、预算通过且所有回退存在时允许。故事阅读密集页、挑战操作区、弱网默认路径、Reduced Motion、低性能设备或仅为装饰的场景禁止自动使用视频。

必须提供目标浏览器支持的编码与兼容回退、按设备尺寸的分辨率、24–30 fps 的默认帧率、尽可能短且无接缝的循环、静音、Poster、2.5 MB Blocker Limit、自动播放失败处理、网络/省电判断、Reduced Motion 静态替代、离页暂停、解码失败回退与内存释放。不得为了循环延长无变化片段；若视频不比分层静态或轻量动画明显更好，禁止使用。

## 13. Canvas 与 WebGL

Canvas/WebGL 必须有批准的必要性、设备矩阵与静态替代。初始化只发生一次；组件实例持有明确 Owner。页面隐藏时停止 `requestAnimationFrame`，离开时取消帧、解绑监听、删除纹理/Buffer/Program、清空引用并在适用时释放 Context。

纹理尺寸不得超过实际显示与设备能力；DPR Target 上限 2，低性能模式上限 1.5，除非真机证据证明更高 DPR 有必要且预算通过。支持动态降低渲染分辨率和帧率。必须处理 `webglcontextlost`、阻止错误循环、释放旧资源，并在 `webglcontextrestored` 后完整重建状态；恢复失败立即静态回退。

必须测试设备能力、浏览器支持、GPU/内存、Context 丢失、后台、旋转和多次路由进入。禁止 Context 泄漏、纹理未释放、未取消 RAF、多页面重复实例、后台持续渲染或高 DPR 过载。无障碍语义由等价 DOM 内容提供，Canvas/WebGL 不能成为唯一学习信息来源。

## 14. 内存管理

性能记录必须分别观察图片解码、视频缓冲、Canvas backing store、WebGL 纹理、页面缓存和媒体并发。大图不可见后应释放解码引用；可复用小资源按受控缓存复用；视频停止并卸载不再需要的 Source；Blob URL 在最后使用者结束后 `revokeObjectURL`。

组件卸载必须清理事件监听、Observer、定时器、Promise/请求结果写入、RAF、Worker、Canvas 与 WebGL 资源。连续执行至少 10 次 Journey 进入→完成关键页→返回循环，比较稳定基线、每轮峰值和回落值；预热后内存不得持续单调增长。出现持续增长、崩溃、系统回收或返回页面重复实例即失败。

## 15. 页面生命周期

| 状态 | 资源动作 | 状态动作 |
|---|---|---|
| 首次进入/加载 | 请求核心静态与内容；延后非关键动态 | 建立唯一页面实例和加载状态 |
| 可见 | 仅启动已批准动态；音频与视觉按优先级协调 | 恢复当前 Journey/Page 状态 |
| 隐藏/切后台 | 暂停视频、Canvas、WebGL、视差和非必要动画 | 保存可恢复位置，不重复完成事件 |
| 页面离开 | 取消请求与 RAF；释放大图、视频、纹理、监听和 Blob URL | 保存必要业务状态，销毁展示实例 |
| 返回页面 | 复用有效缓存或重新加载必要资源 | 恢复而非重复初始化、奖励或自动播放副作用 |
| 横竖屏切换 | 选择正确 Variant，重新计算安全区与渲染尺寸 | 保持阅读、朗读和学习进度 |
| 刷新/路由快速切换 | 防止陈旧请求写入；按持久化 Contract 恢复 | 旧实例不得与新实例叠加 |

禁止返回后背景消失、动画重复启动、自动朗读与背景争抢导致无声、页面隐藏后高负载、多个动画实例叠加或旧页面请求覆盖当前页面。

## 16. 弱网络策略

必须覆盖 Offline、极慢、2G、3G、高延迟、丢包、超时、CDN 失败及单/多资源失败。核心文字、按钮、学习状态和已缓存音频不得依赖背景成功才可使用。

按“缓存可用静态 → 低分辨率静态 → 颜色/渐变占位”提供回退；动态加载失败直接静态化。请求具有明确超时、有限自动重试和用户重试；不可恢复时显示克制错误状态，不无限 Loading。缓存优先不得长期固定旧版本。弱网证据须含冷缓存与热缓存、网络 Profile、传输量、时间线和最终状态。

## 17. 低性能设备策略

能力判断组合 CPU/并发能力、GPU/Canvas/WebGL 支持、可用内存信号、DPR、屏幕、网络、浏览器能力、Reduced Motion 与省电偏好；不得仅依赖单一 User-Agent 或一次 Benchmark。能力探测本身必须轻量且保护隐私。

降级顺序为：降低动画复杂度 → 减少粒子 → 降低渲染分辨率 → 降低帧率 → 停止次要动态 → 分层静态 → 单张高清静态 → 轻量颜色/渐变占位。任何一级都必须保持文字、按钮、字幕、朗读、挑战和完成流程可用；设备在会话中持续掉帧、发热或内存压力增加时允许继续向下动态降级，不自动升级造成抖动。

## 18. `prefers-reduced-motion`

启动时检测系统设置，并监听有效变化；Phoenix 应用内“减少动态效果”可比系统更严格，不能覆盖系统减少请求而强制恢复动画。Reduced Motion 下停止或移除非必要动画、自动视频、Canvas、WebGL、视差、粒子与大幅页面转场；状态变化即时或使用短促淡入，切换为同版本静态背景。

减少动态是正式版必需能力。其状态必须跨页面一致、返回后保持、不会导致黑屏或丢失信息。功能必须通过真实页面与真机验证，不能只检查媒体查询存在。

## 19. 加载状态

| 状态 | 用户所见 | 读/操作 | 加载与记录 |
|---|---|---|---|
| `Initial` | 稳定布局与基础占位 | 核心内容准备后立即可用 | 尚未发起或已排队 |
| `Loading` | 颜色、渐变、轻量缩略图或 Poster | 不阻断已有文字和操作 | 计时、可取消、有超时 |
| `Loaded` | 正确 Variant | 可读可操作 | 记录资源、缓存与耗时 |
| `Failed` | 安全占位与必要提示 | 核心流程可用 | 记录错误并决定重试/回退 |
| `Retrying` | 保持当前安全视觉 | 可继续核心操作 | 有次数/退避，不重复并发 |
| `Degraded` | 低成本但完整视觉 | 完整可用 | 记录触发原因与档位 |
| `StaticFallback` | 同版本静态图 | 完整可用 | 停止动态请求和循环 |
| `Cancelled` | 当前页面视觉不被旧结果改变 | 当前页面可用 | 丢弃结果、释放资源、记录必要诊断 |

任何 Loading 都有超时和终态；不得无限等待、用长遮罩锁住页面或在失败后反复闪烁。

## 20. 错误处理与回退

图片 404/损坏/解码失败、AVIF/WebP 不支持、视频解码失败、Canvas/WebGL 初始化或 Context 失败、动画脚本异常、断网、缓存损坏、超时和 CDN 异常均须有明确处理。统一回退链为：动态方案 → 轻量动态 → 分层静态 → 单张静态 → 颜色/渐变占位。

格式不支持由 `<picture>` 或能力检测选择兼容源；网络/解码失败不得反复请求同一坏资源；缓存损坏时清理目标项而非全部用户数据；脚本失败隔离视觉模块，不能使页面、朗读或挑战崩溃。每次回退记录 Asset、错误、设备、网络、目标级别和最终可用状态。

## 21. 页面切换与闪屏

必须检查黑/白屏、背景闪烁、旧图残留、新旧重叠、透明度跳变、布局跳动、动画错误起点、返回重下与快速切换竞争。必要时在预算内预取下一静态资源；只有新资源完成解码后才进行短交叉淡入，Reduced Motion 下直接切换稳定帧。

保留上一背景只允许在同一安全页面状态、短时间且不会造成 Story/Journey 错配时使用。离开时取消旧请求，页面实例 Token 防止陈旧完成事件。动画在布局和正确资源就绪后启动。不得用长时间遮罩隐藏加载问题。

## 22. 性能测量

每个候选 Build 使用 Lighthouse、Web Vitals、浏览器 Performance/Network/Memory、FPS/Frame Trace、Long Tasks、Layout Shift、Resource Timing、图片/视频解码、GPU 工具（平台可用时）和真机测试。至少记录 LCP、CLS、INP、TTFB、FCP、Long Tasks、JS 执行、图片传输、解码、峰值内存和动画 FPS。

Web Vitals 阈值按测试日期的官方有效定义记录，且不得宽于 Phoenix 专项预算。测量必须锁定 Branch、Commit、Build、设备、OS、浏览器、网络 Profile、缓存状态、样本数和百分位。桌面模拟只能早期诊断，不能替代小屏旧手机、真实 Safari/Chrome、弱网和低内存设备。

## 23. 真机测试矩阵

| 环境 | 最低覆盖 |
|---|---|
| 手机 | 小屏旧款、标准、大屏；至少一台 iPhone 与一台 Android |
| 平板 | 竖屏与横屏；高 DPI |
| 浏览器 | Release Scope 内 Safari、Chrome 与其他明确支持浏览器 |
| 能力 | 低内存、低性能、标准性能、电池节省、Reduced Motion |
| 网络 | Offline、2G/极慢、3G、高延迟/丢包、正常网络 |

每种适用环境验证首屏、切换、Journey 进入/返回、动态、静态降级、音频并行、状态恢复、内存趋势和加载失败。设备缺失时状态为 `BLOCKED_MISSING_EVIDENCE`，不得用高性能结果推断通过。

## 24. 视觉与音频并行性能

背景与自动朗读、图片与音频解码、动态背景与 TTS、路由与音频停止、返回后的音频恢复必须联合测试。视觉预取与解码不得抢占当前朗读请求、主线程交互或媒体内存；音频失败也不得让背景状态机停滞。

同一时间仅保留当前必要媒体。页面离开先停止旧页面音频和视觉循环，再建立新页面；返回按业务规则恢复，不重复播放。测试必须包含“背景失败但朗读可用”和“朗读失败但页面视觉与按钮可用”。

## 25. 资源目录与重复资源

发布资源使用规范名称、内容哈希和 Journey/页面归属清单。构建或 CI 应检测相同哈希不同文件名、近似资源、未引用文件、旧版本、重复回退与孤立文件；人工确认相似资源是否有真实构图或设备差异。

禁止同图多名、未用 4K Master 进入生产包、旧背景无人引用仍长期打包、重复静态回退或多份近似动画。清理前必须通过引用追踪确认当前代码、Manifest、缓存回滚和历史 Release 不再需要，不能破坏已发布版本。

## 26. 构建与部署

构建必须验证图片处理、响应式产物、指纹、压缩、Tree Shaking、动态导入、CDN 路径、Base URL、Preview/Production 环境、缓存头、Source Map 影响、总产物体积、资源存在性和大小写路径。

构建报告列出新增/删除/超限资源和依赖增量。Preview 与 Production 使用等价的资源解析和回退规则；环境差异必须记录。必须测试从构建产物而非源码读取的 URL、格式、哈希和 MIME，防止本地正常但部署后 404、大小写失败、CDN 错误或回退缺失。

## 27. Preview 性能门槛

公开 Preview 必须满足核心可用、文字/按钮可用、无闪烁/眩晕、无内存泄漏、静态降级、加载失败回退和版权安全。它不能作为无限大资源、未优化视频、无回退或弱网不可用的公开试验环境。

允许低于正式版的只能是已记录、非阻断且不影响可用性的 Target 优化项；不得超过 Maximum/Blocker Limit。每项差异记录实际值、用户影响、负责人、关闭条件与到期时间。`APPROVED_FOR_PREVIEW` 不代表 `APPROVED_FOR_RELEASE`。

## 28. 正式版性能 Gate

`APPROVED_FOR_RELEASE` 必须同时满足：预算通过；首屏合理；响应式完整；格式与缓存正确；无严重闪屏；FPS 达标；无明显泄漏；弱网与低性能设备可用；Reduced Motion 和静态降级有效；离页正确暂停/释放；返回状态正确；真机矩阵与页面级 QA 通过。

以下不可 Waive：页面不可用、严重卡顿、严重掉帧、持续内存增长、无回退、Reduced Motion 失效、加载失败阻断核心流程、视觉破坏朗读或交互、高风险闪烁或眩晕。任一存在即 `BLOCKED`，总分、视觉品质、Preview 成功、排期和负责人批准均不能补偿。

## 29. 性能问题等级

| 等级 | 定义 | 发布后果 |
|---|---|---|
| `P0 BLOCKER` | 页面不可用、崩溃、严重内存泄漏、核心流程中断、高风险闪烁/眩晕 | 禁止 Preview 与 Release，立即返回根因阶段 |
| `P1 CRITICAL` | 严重卡顿、持续掉帧、弱网不可用、无静态降级、返回状态损坏 | 禁止 Release，修复并完整回归 |
| `P2 MAJOR` | 明显过慢、不必要大资源、缓存错误、响应式不完整 | 正式版前修复并复审 |
| `P3 MINOR` | 有证据证明不阻断发布的局部优化 | 可记录，但不得累积突破预算或品质 |

每项问题必须记录 ID、页面、资源、设备、网络、重现步骤、测量数据、用户影响、违反规范、修复要求、返回 Pipeline 阶段和回归范围。不得拆分问题以降低真实等级。

## 30. 性能证据记录

每个进入正式版的视觉资源必须保存：资源名称/ID、格式、原始与发布尺寸、传输体积、压缩设置、响应式版本、首屏/非首屏、预加载/懒加载、缓存策略、动画 FPS、峰值与稳定内存、弱网与低性能结果、Reduced Motion、静态降级、页面 QA、测试日期、设备/OS/浏览器/网络、Commit、PR 和 Build。

证据必须包含 Target/Actual/Maximum、测量工具、样本与百分位、截图/Trace/报告位置和审核人。不得只写“性能正常”。文件或代码、加载策略、依赖、页面、设备范围或构建变化后，受影响证据失效并重新审核。

## 31. 与其他 Visual 文件关系

- `VISUAL_PIPELINE.md` 定义生产流程与失败返回。
- `VISUAL_DECISION_TREE.md` 定义技术与方案选择。
- `IMAGE_QUALITY_GATE.md` 定义强制质量门与默认上限。
- `VISUAL_CHECKLIST.md` 定义逐项执行记录。
- `VISUAL_REVIEW_PROMPT.md` 定义最终联合审核。
- `COPYRIGHT_POLICY.md` 定义权利边界。
- 本文件定义性能、生命周期与降级标准。

性能失败时，无论视觉评分多高均不得正式发布。本文件不得改变 Story、Learning、UI、Audio、Accessibility、QA 或 Release System 的职责。

## 32. 固定性能检查清单

每项记录 `PASS`、`FAIL`、`BLOCKED` 或有事实理由的 `NOT_APPLICABLE`，并附 Actual、设备/网络、证据和审核人。Blocker 不得标记为 `NOT_APPLICABLE`。

| ID | 检查项 | 严重性 | 通过条件 |
|---|---|---|---|
| `PERF-CHECK-001` | 资源格式 | Blocker | 每项格式、兼容与回退符合第 4 节 |
| `PERF-CHECK-002` | 资源尺寸 | Blocker | 发布像素接近实际槽位，无 4K Master 入包 |
| `PERF-CHECK-003` | 文件体积 | Blocker | 单项和页面总量未超 Blocker Limit |
| `PERF-CHECK-004` | 响应式 | Blocker | 手机/平板/方向/DPR Variant 与裁切通过 |
| `PERF-CHECK-005` | 预加载 | Major | 仅正确 LCP/首屏资源，且无重复与抢占 |
| `PERF-CHECK-006` | 懒加载与预取 | Major | 非首屏按需，取消/返回/失败无竞争 |
| `PERF-CHECK-007` | 缓存与版本 | Blocker | 内容哈希、缓存头、更新、失效和恢复通过 |
| `PERF-CHECK-008` | CSS/SVG 动画 | Blocker | FPS、并发、离页、Reduced Motion 通过 |
| `PERF-CHECK-009` | 视频 | 条件 Blocker | 必要性、体积、Poster、解码与回退通过 |
| `PERF-CHECK-010` | Canvas | 条件 Blocker | 初始化、RAF、DPR、销毁、静态替代通过 |
| `PERF-CHECK-011` | WebGL | 条件 Blocker | Context、纹理、丢失/恢复、释放与回退通过 |
| `PERF-CHECK-012` | 内存 | Blocker | 峰值预算通过，10 次循环无持续增长 |
| `PERF-CHECK-013` | 页面生命周期 | Blocker | 首进、隐藏、离开、返回、旋转和快速切换通过 |
| `PERF-CHECK-014` | 弱网络 | Blocker | Offline/2G/3G/延迟/失败下核心流程可用 |
| `PERF-CHECK-015` | 低性能设备 | Blocker | 能力判断和完整降级链有效 |
| `PERF-CHECK-016` | Reduced Motion | Blocker | 系统/应用设置、停止与静态替代有效 |
| `PERF-CHECK-017` | 加载失败 | Blocker | 所有格式、网络、脚本与渲染失败有终态回退 |
| `PERF-CHECK-018` | 页面切换 | Blocker | 无严重闪屏、竞争、错误背景或状态损坏 |
| `PERF-CHECK-019` | 视觉与音频并行 | Blocker | 背景不阻断朗读，朗读不阻断页面 |
| `PERF-CHECK-020` | 目录与重复资源 | Major | 无重复、孤立、未用 Master 或旧引用 |
| `PERF-CHECK-021` | 构建与部署 | Blocker | 产物、指纹、路径、MIME、CDN 与环境通过 |
| `PERF-CHECK-022` | 真机矩阵 | Blocker | 全部 Release Scope 设备与网络有证据 |
| `PERF-CHECK-023` | Preview | Blocker | 公开 Preview 最低门槛全部通过 |
| `PERF-CHECK-024` | Release | Blocker | 第 28 节条件、Gate、Review 与页面 QA 全部通过 |

任一适用 Blocker 失败，整体状态为 `BLOCKED`。修复必须改变真实资源、代码或配置，更新证据，并重跑受影响 Gate、Checklist、Review 和页面 QA；不得只修改检查结果。

## 33. 固定 Phoenix Visual Performance Review Prompt

以下 Prompt 可直接复制执行。方括号字段是执行时必须提供的 Evidence Package 字段；缺失时必须输出 `PERFORMANCE_REVIEW_BLOCKED_MISSING_EVIDENCE`，列出缺失项，不得推测通过。

```text
你是 Phoenix Visual Performance Reviewer，同时承担 Web 性能工程师、移动端性能工程师、视觉运行时审核者、无障碍运动审核者、Audio 并发审核者和 QA 负责人职责。你必须汇总为一个证据化结论，不能分别给出互不一致的意见，也不得为了让用户满意而虚假通过。

审核对象：
- 资源名称/Asset ID：[填写]
- 页面/Journey/类型：[填写]
- Branch、Commit、Build、PR：[填写]
- 真实代码、构建产物和可运行页面：[提供]
- 资源清单、原始/发布尺寸、格式、字节、Hash：[提供]
- 手机/平板/方向/DPR 响应式映射：[提供]
- 动画/视频/Canvas/WebGL 演示与实现：[适用时提供]
- 静态降级、Reduced Motion、弱网、低性能 Evidence：[提供]
- Network、Performance、Memory、Frame、Lighthouse/Web Vitals 报告：[提供]
- 页面级 QA、Visual Checklist、Image Quality Gate 结果：[提供]

开始前按 Phoenix Documentation 优先级读取 docs/systems/、适用 docs/story/，以及 docs/visual/README.md、VISUAL_CONSTITUTION.md、VISUAL_PHILOSOPHY.md、VISUAL_GUIDELINES.md、BACKGROUND_GUIDELINES.md、AI_IMAGE_GENERATION_GUIDE.md、VISUAL_PIPELINE.md、VISUAL_DECISION_TREE.md、IMAGE_QUALITY_GATE.md、VISUAL_CHECKLIST.md、VISUAL_REVIEW_PROMPT.md、COPYRIGHT_POLICY.md 和 PERFORMANCE_GUIDE.md。锁定同一 Candidate、Commit 与 Build。

必须检查真实代码和页面，不得只看源码、设计稿或独立资源推测性能通过。依次执行：
1. 从构建产物计算各资源、首屏、页面和 Journey 的实际传输体积，对照 Target/Maximum/Blocker Limit。
2. 核对 AVIF/WebP/PNG/JPEG/SVG 选择、响应式 srcset/sizes/picture、手机/平板/横竖屏/DPR Variant 与静态回退；确认小屏没有下载超大桌面图。
3. 检查首屏 LCP 候选、预加载、占位、懒加载、预取、重复请求、布局跳动和页面切换。
4. 检查内容哈希、Cache-Control、CDN、浏览器/Service Worker、旧资源失效和损坏恢复。
5. 对 CSS/SVG 动画、视频、Canvas、WebGL 分别核对必要性、文件/依赖成本、FPS、CPU/GPU、内存、电池、生命周期和失败回退。
6. 测量审核真机的 FPS/p95、Long Tasks、JS 执行、图片/视频解码、LCP、CLS、INP、FCP、TTFB、峰值和稳定内存；记录工具、设备、浏览器、网络、缓存、样本与 Trace。
7. 连续执行至少 10 次 Journey 进入、页面切换和返回，检查 RAF、监听、定时器、Blob URL、Canvas、WebGL、视频和大图是否释放，内存是否持续增长。
8. 测试页面首次进入、隐藏、切后台、恢复、离开、返回、刷新、旋转和快速连续切换；检查背景、动画、业务状态与自动/手动朗读恢复。
9. 测试 Offline、极慢/2G、3G、高延迟、丢包、超时、CDN/单资源/多资源失败；核心学习必须可用，Loading 必须有终态。
10. 在低性能设备、电池节省和高内存压力下验证完整降级顺序；不得用高性能设备代替。
11. 启用系统和应用 Reduced Motion，确认视频、Canvas、WebGL、视差和非必要动画停止，静态方案有效且状态保持。
12. 联合测试背景加载/解码与自动朗读、TTS、按钮和页面切换；视觉不得抢占学习与音频资源。
13. 核对 PERF-CHECK-001–024、Image Quality Gate 12、Visual Checklist、Visual Review 和页面 QA 的状态与真实证据，发现不一致以真实证据为准。

问题统一分级：P0 BLOCKER、P1 CRITICAL、P2 MAJOR、P3 MINOR。每项必须包含 ID、等级、页面、资源、设备、网络、重现步骤、测量值与预算、证据、用户影响、修复要求、返回 Pipeline 阶段和复审范围。

输出固定结构：
A. Review Summary：对象、版本、证据完整性、Preview/Release 结论。
B. Budget Table：每项 Target、Actual、Maximum、Status。
C. Metrics：LCP/CLS/INP/FCP/TTFB、资源字节、解码、FPS/p95、Long Tasks、峰值/循环内存。
D. Resource Delivery：格式、响应式、预/懒加载、缓存、构建产物。
E. Runtime：动画、视频、Canvas、WebGL、生命周期、页面切换、音频并行。
F. Degradation：弱网、低性能、Reduced Motion、静态与失败回退。
G. Device Matrix：每台设备、浏览器、方向、网络和结果。
H. Findings：按 P0–P3 列出全部问题。
I. Checklist/Gate Verification：PERF-CHECK-001–024 与上游证据。
J. Required Fixes and Re-review Scope。
K. Final Decision。

Final Decision 只能是：
- PERFORMANCE_REVIEW_BLOCKED_MISSING_EVIDENCE
- REJECTED
- BLOCKED
- REQUIRES_REVISION
- APPROVED_FOR_PREVIEW
- APPROVED_FOR_RELEASE

APPROVED_FOR_PREVIEW 必须满足公开 Preview 的全部不可降低项；它不代表 Release。APPROVED_FOR_RELEASE 只有在预算、响应式、格式、缓存、FPS、内存、弱网、低性能、Reduced Motion、静态降级、生命周期、音频并行、真机、Gate、Checklist、Visual Review 与页面 QA 全部通过，且 P0/P1 为零时允许。页面不可用、严重卡顿/掉帧、持续内存增长、无回退、Reduced Motion 失效、核心流程中断、视觉破坏朗读/交互或闪烁/眩晕风险不可 Waive、不可评分补偿。
```

固定 Prompt 只产生审核结论，不执行 Import、Merge 或 Release。修复后必须更新真实资源或实现、补充新证据并重跑明确的复审范围。
