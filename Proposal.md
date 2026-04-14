# Proposal: 星轴宇宙命名方案

## 1. Problem Analysis

当前文档虽然已经大量采用 `Stellar Axis`、`StarMap`、`Nebula` 这一类宇宙意象，但仍然混入了另一套传统哲学命名体系。两套语义并行会带来几个问题：

- 对外品牌、对内模块、代码仓库、SDK 包名之间容易出现风格漂移。
- 中文命名里存在强地域文化指向，不利于后续统一品牌表达。
- 工程名、展示名、叙事名不在同一语义层，扩展新组件时容易继续分裂。
- AI 层、消息层、治理层之间缺少一致的命名语法。

因此，这份提案的目标不是继续叠加第三套名字，而是把现有体系统一收敛为“纯宇宙元素命名”。

## 2. Design

### 2.1 命名总原则

建议采用三层命名模型：

- **品牌层**：统一使用 `Stellar Axis / 星轴`。
- **产品层**：统一使用“英文宇宙名 + 中文宇宙名”双轨表达。
- **工程层**：仓库、包名、制品名统一优先英文，中文只保留在文档、官网和产品展示中。

这样做的理由：

- `Stellar Axis` 负责对外传播、开源生态、仓库命名、依赖坐标。
- `星轴` 负责中文品牌主名，与英文含义保持同源。
- 各产品统一绑定星图、星云、星轨、视界、奇点等宇宙意象，后续扩展时规则清晰。

### 2.2 建议的品牌架构

推荐采用以下结构：

| 层级 | 英文命名 | 中文命名 | 用途 |
| :--- | :--- | :--- | :--- |
| 总品牌 | **Stellar Axis** | **星轴** | 整套微服务中间件体系总称 |
| Java 技术栈 | **Stellar Core** | **星核** | Java 侧框架与 SDK 发行体系 |
| Go 技术栈 | **Stellar Pulse** | **星脉** | Go 侧框架与 SDK 发行体系 |
| 核心矩阵 | **Core Constellation** | **核心星群** | 核心基础设施产品集合 |
| 消息中枢 | **CometFlow** | **彗流** | 消息、事件、异步流转层 |
| AI 层 | **Astral Layer** | **星穹层** | LLM、Memory、Agent、MCP 总称 |

其中：

- `Stellar Axis / 星轴` 作为总品牌固定不再切换。
- Java/Go 双栈统一切换到宇宙语义，不再保留非宇宙意象命名。
- 消息中枢收敛为 `CometFlow / 彗流`，不再使用其他平行名称。

### 2.3 核心命名决策

#### 决策 A：总品牌固定

总品牌固定为：

- 英文：`Stellar Axis`
- 中文：`星轴`

推荐标准表达方式：

> **Stellar Axis（星轴）**

#### 决策 B：组件统一采用“双宇宙命名”

每个核心中间件统一采用：

> **English Product Name + Chinese Cosmic Name**

例如：

- `StarMap · 星图`
- `Nebula · 星云`
- `Orbit · 星轨`
- `EventHorizon · 视界`

#### 决策 C：英文负责工程，中文负责展示

后续所有扩展组件遵循一个规则：

- 仓库、模块、包名、制品名统一只用英文工程名。
- 中文命名只保留宇宙意象，不再引入哲学、拼音或混合别名。

### 2.4 核心组件推荐命名表

| 领域 | 推荐英文名 | 推荐中文名 | 命名结论 |
| :--- | :--- | :--- | :--- |
| 服务注册中心 | **StarMap** | **星图** | 保留 `StarMap` 为主名 |
| 配置中心 | **Nebula** | **星云** | 保留 `Nebula`，强调承载与生成 |
| 链路追踪 | **StarTrace** | **星迹** | 用轨迹意象表达可观测链路 |
| 服务治理 | **Orbit** | **星轨** | 用轨道意象表达路由与治理 |
| 限流熔断 | **Pulsar** | **脉冲** | 用节律与阈值表达保护能力 |
| 分布式任务 | **Astrolabe** | **星盘** | 用天体测位与时间校准表达调度 |
| 分布式锁 | **Singularity** | **奇点** | 用收束与唯一性表达排他控制 |
| 智能网关 | **EventHorizon** | **视界** | 用边界层表达接入与转发 |
| 消息队列 / 事件流 | **CometFlow** | **彗流** | 统一作为消息层主名 |

说明：

- 英文名与中文名都必须能直接映射到宇宙元素。
- 不再保留任何拼音、传统哲学或混合命名。

### 2.5 AI 星穹层命名建议

| 层级 | 英文建议 | 中文建议 | 说明 |
| :--- | :--- | :--- | :--- |
| AI 总层 | **Astral Layer** | **星穹层** | AI Native 扩展总称 |
| LLM 推理 | **Quasar Engine** | **类星引擎** | 推理与理解中枢 |
| Memory | **StarVault Memory** | **星库** | 长短期知识蓄积 |
| Agent | **Orbit Agent** | **轨使** | 执行编排与自治代理 |
| MCP Context | **Sensor MCP** | **星感** | 感知资源与上下文 |
| MCP Tools | **Vector MCP** | **星行** | 工具调用与执行 |
| MCP Prompt | **GuideStar MCP** | **导星** | 智能引导与提示编排 |

建议：

- AI 子体系继续保持独立层级，但命名也必须落在同一宇宙语法里。
- 不再把 AI 层绑定到任何传统结构映射上。

### 2.6 工程命名规范

建议统一如下：

#### 仓库命名

- `stellar-axis`
- `stellar-core`
- `stellar-pulse`
- `astral-layer`
- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

#### Java Maven 坐标

- GroupId：`io.stellar.axis`
- ArtifactId 示例：
  - `stellar-core-runtime`
  - `starmap-client-spring-boot-starter`
  - `nebula-client-spring-boot-starter`
  - `orbit-governance-starter`
  - `comet-flow-client`

#### Go Module

- `github.com/stellar-axis/stellar-pulse`
- `github.com/stellar-axis/starmap`
- `github.com/stellar-axis/nebula`
- `github.com/stellar-axis/orbit`

#### CLI / 平台工具

- `stellarctl`
- `stellar-control-plane`

## 3. Implementation

基于以上分析，建议本项目正式采用以下命名方案。

### 3.1 最终推荐方案

#### 总品牌

- 英文：`Stellar Axis`
- 中文：`星轴`
- 标准展示：`Stellar Axis（星轴）`

#### 双栈品牌

- Java：`Stellar Core（星核）`
- Go：`Stellar Pulse（星脉）`

#### 核心基础设施矩阵

| 英文主名 | 中文主名 | 职责 |
| :--- | :--- | :--- |
| `StarMap` | `星图` | 服务注册与发现 |
| `Nebula` | `星云` | 配置中心 |
| `StarTrace` | `星迹` | 链路追踪 |
| `Orbit` | `星轨` | 服务治理与路由 |
| `Pulsar` | `脉冲` | 限流、熔断、过载保护 |
| `Astrolabe` | `星盘` | 分布式调度 |
| `Singularity` | `奇点` | 分布式锁 |
| `EventHorizon` | `视界` | 网关与流量入口 |
| `CometFlow` | `彗流` | MQ / Event Streaming |

#### AI 星穹层

| 英文主名 | 中文主名 | 职责 |
| :--- | :--- | :--- |
| `Astral Layer` | `星穹层` | AI 能力总体品牌 |
| `Quasar Engine` | `类星引擎` | LLM 推理 |
| `StarVault Memory` | `星库` | Memory / RAG |
| `Orbit Agent` | `轨使` | Agent 编排 |
| `Sensor MCP` | `星感` | 上下文感知 |
| `Vector MCP` | `星行` | 工具执行 |
| `GuideStar MCP` | `导星` | Prompt 引导 |

### 3.2 命名使用规范

对外介绍时：

> Stellar Axis（星轴）是一套自研微服务中间件体系，其核心治理矩阵由 StarMap·星图、Nebula·星云、Orbit·星轨 等组件构成。

在文档标题中：

- `StarMap · 星图 | Service Registry`
- `Nebula · 星云 | Config Center`
- `EventHorizon · 视界 | Gateway`

在仓库和依赖命名中：

- 只使用英文名，不混用拼音或哲学别名。

### 3.3 为什么这是当前最优解

这套方案同时满足四个目标：

- **统一性**：总品牌、组件名、SDK 名、AI 名称位于同一叙事体系下。
- **传播性**：英文名具备现代中间件品牌气质，适合开源与国际传播。
- **辨识度**：中文名全部来自宇宙意象，简洁直观，且与英文同源。
- **可扩展性**：后续新增组件时，可以继续遵循“宇宙对象 + 工程职责”的规则扩展。

## 4. Complete Code

以下内容可直接作为命名提案落地执行：

~~~md
# Proposal: 星轴宇宙命名方案

## 最终结论

本体系建议采用“**Stellar Axis（星轴）**”作为唯一总品牌。

- `Stellar Axis` 负责国际化传播、仓库命名、依赖坐标与工程生态。
- `星轴` 负责中文品牌表达，与英文含义保持一致。
- 核心中间件统一使用“**英文宇宙名 + 中文宇宙名**”的双命名制。

## 双栈命名

- Java: `Stellar Core（星核）`
- Go: `Stellar Pulse（星脉）`

## 核心组件命名

| 英文主名 | 中文主名 | 职责 |
| :--- | :--- | :--- |
| `StarMap` | `星图` | 服务注册与发现 |
| `Nebula` | `星云` | 配置中心 |
| `StarTrace` | `星迹` | 链路追踪 |
| `Orbit` | `星轨` | 服务治理与路由 |
| `Pulsar` | `脉冲` | 限流、熔断、过载保护 |
| `Astrolabe` | `星盘` | 分布式调度 |
| `Singularity` | `奇点` | 分布式锁 |
| `EventHorizon` | `视界` | 智能网关 |
| `CometFlow` | `彗流` | 消息队列 / 事件流 |

## AI 星穹层命名

| 英文主名 | 中文主名 | 职责 |
| :--- | :--- | :--- |
| `Astral Layer` | `星穹层` | AI 总体能力层 |
| `Quasar Engine` | `类星引擎` | LLM 推理 |
| `StarVault Memory` | `星库` | Memory / RAG |
| `Orbit Agent` | `轨使` | Agent 编排 |
| `Sensor MCP` | `星感` | Context |
| `Vector MCP` | `星行` | Tools |
| `GuideStar MCP` | `导星` | Prompt |

## 工程落地规则

1. 仓库、包名、依赖坐标统一使用英文名。
2. 官网、文档、架构图统一使用“双宇宙命名制”。
3. 不再保留任何传统哲学、拼音混合或多语义并列命名。
~~~
