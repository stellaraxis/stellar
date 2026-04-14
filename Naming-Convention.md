# Naming Convention

## 1. Problem Analysis

基于 [Proposal.md](./Proposal.md) 的决策，本文件用于把命名提案进一步收敛为可执行规范。

需要解决的核心问题有三个：

- **决策 A**：总品牌必须固定，不能在多个中文哲学名、拼音名和英文名之间来回切换。
- **决策 B**：核心组件必须有统一展示方式，不能有的用宇宙名，有的用传统别名，有的用混合拼写。
- **决策 C**：工程命名和品牌命名必须分层，不能把宣传名称直接拿去当仓库名、包名、模块名。

因此，这份文档的作用是给出最终命名结论，并解释为什么这样命名。

## 2. Design

### 2.1 总体命名原则

本体系采用三层命名结构：

- **品牌层**：定义整套体系的统一品牌。
- **产品层**：定义核心中间件与 AI 子体系的正式名称。
- **工程层**：定义仓库、包名、依赖、CLI、模块的命名格式。

三层之间的职责划分如下：

- 品牌层负责统一认知。
- 产品层负责统一展示。
- 工程层负责统一实现。

### 2.2 决策 A：总品牌固定

#### 最终命名

- 英文总品牌：`Stellar Axis`
- 中文总品牌：`星轴`
- 标准联合写法：`Stellar Axis（星轴）`

#### 使用规则

- 官网、白皮书、README 首次出现时，必须写作 `Stellar Axis（星轴）`。
- 在英文语境中，可单独使用 `Stellar Axis`。
- 在中文语境中，可单独使用 `星轴`。

#### 禁止写法

- 不使用任何传统哲学中文名作为总品牌主名。
- 不使用拼音品牌作为正式对外总称。
- 不使用去空格拼接形式作为品牌展示名。

### 2.3 决策 B：核心组件统一采用双宇宙命名制

#### 最终规则

所有核心中间件统一采用：

> **英文主名 + 中文宇宙名**

标准写法：

> `EnglishName · 中文名`

例如：

- `StarMap · 星图`
- `Nebula · 星云`
- `StarTrace · 星迹`
- `Orbit · 星轨`

#### 核心组件最终命名表

| 领域 | 英文正式名 | 中文正式名 | 解释 |
| :--- | :--- | :--- | :--- |
| 服务注册中心 | `StarMap` | `星图` | 统一坐标图，适合表达服务发现与节点定位 |
| 配置中心 | `Nebula` | `星云` | 用承载与生成表达配置分发能力 |
| 链路追踪 | `StarTrace` | `星迹` | 用轨迹显影表达可观测链路 |
| 服务治理 | `Orbit` | `星轨` | 轨道对应流量调度、路由治理 |
| 限流熔断 | `Pulsar` | `脉冲` | 脉冲节律对应阈值与频率控制 |
| 分布式调度 | `Astrolabe` | `星盘` | 天体测位与时间校准对应调度系统 |
| 分布式锁 | `Singularity` | `奇点` | 奇点表达唯一性与收束性 |
| 智能网关 | `EventHorizon` | `视界` | 事件视界表达边界入口 |
| 消息流转中枢 | `CometFlow` | `彗流` | 彗尾轨迹表达消息与事件流动 |

#### 使用规则

- 首次出现使用 `英文正式名 · 中文正式名`。
- 中文文档正文中，后续可以直接使用中文主名。
- 英文文档正文中，后续可以只使用英文正式名。

#### 不推荐写法

- 传统哲学中文别名
- 拼音卦位式命名
- 中英混拼的过渡命名

### 2.4 决策 C：英文负责工程，中文负责展示

#### 最终规则

- **核心基础设施组件**：必须同时具备英文工程名和中文宇宙名。
- **配套工程工具**：统一保留英文工程名，可选配中文展示名。
- **工程实体**：仓库、模块、包名、依赖坐标统一只使用英文。

#### 适用范围

适合挂中文宇宙名的对象：

- 核心中间件产品
- 架构图节点
- 官网产品卡片
- 中文方案文档

不适合挂中文宇宙名的对象：

- Git 仓库名
- Maven ArtifactId
- Go Module
- CLI 工具名
- Sidecar、Operator、Starter、SDK 子模块

## 3. Implementation

### 3.1 最终命名总表

#### 总品牌

| 类型 | 最终名称 | 解释 |
| :--- | :--- | :--- |
| 英文总品牌 | `Stellar Axis` | 整套体系唯一英文总品牌 |
| 中文总品牌 | `星轴` | 整套体系唯一中文总品牌 |
| 首次标准展示 | `Stellar Axis（星轴）` | 官网、README、方案文档首次出现统一写法 |

#### 双栈框架

| 类型 | 最终名称 | 解释 |
| :--- | :--- | :--- |
| Java 框架 | `Stellar Core` | 对应 `星核`，强调稳定核心与公共运行时 |
| Go 框架 | `Stellar Pulse` | 对应 `星脉`，强调高并发、流动性与节律 |
| 中文 Java 名 | `星核` | 仅用于中文品牌展示 |
| 中文 Go 名 | `星脉` | 仅用于中文品牌展示 |

#### 核心中间件

| 英文正式名 | 中文正式名 | 最终解释 |
| :--- | :--- | :--- |
| `StarMap` | `星图` | 服务元数据与发现中枢 |
| `Nebula` | `星云` | 系统配置承载底座 |
| `StarTrace` | `星迹` | 链路显影与观测系统 |
| `Orbit` | `星轨` | 路由、流量、治理策略中枢 |
| `Pulsar` | `脉冲` | 限流、熔断、过载保护系统 |
| `Astrolabe` | `星盘` | 分布式时间调度系统 |
| `Singularity` | `奇点` | 分布式锁与唯一竞争控制 |
| `EventHorizon` | `视界` | 网关与入口边界系统 |
| `CometFlow` | `彗流` | 消息与事件流转中心 |

#### AI 星穹层

| 英文正式名 | 中文正式名 | 最终解释 |
| :--- | :--- | :--- |
| `Astral Layer` | `星穹层` | AI Native 总体能力层 |
| `Quasar Engine` | `类星引擎` | 模型推理与理解中枢 |
| `StarVault Memory` | `星库` | 记忆与知识蓄积层 |
| `Orbit Agent` | `轨使` | Agent 编排与自治执行层 |
| `Sensor MCP` | `星感` | Context 感知协议族 |
| `Vector MCP` | `星行` | Tools 执行协议族 |
| `GuideStar MCP` | `导星` | Prompt 引导协议族 |

### 3.2 工程命名规范

#### 仓库命名

统一规则：

- 全部使用小写英文
- 单词之间使用中划线 `-`
- 不使用中文
- 不使用拼音或哲学语义缩写

推荐仓库名：

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

#### Maven 坐标命名

统一规则：

- GroupId 固定为 `io.stellar.axis`
- ArtifactId 使用英文工程名
- Starter、SDK、Client、BOM 等后缀表达工程角色

推荐示例：

- `io.stellar.axis:stellar-core-runtime`
- `io.stellar.axis:stellar-core-bom`
- `io.stellar.axis:starmap-client-spring-boot-starter`
- `io.stellar.axis:nebula-client-spring-boot-starter`
- `io.stellar.axis:orbit-governance-starter`
- `io.stellar.axis:comet-flow-client`

#### Go Module 命名

统一规则：

- 使用 `github.com/stellar-axis/` 作为上层命名空间
- 模块名使用英文工程名
- 不使用中文和拼音

推荐示例：

- `github.com/stellar-axis/stellar-pulse`
- `github.com/stellar-axis/starmap`
- `github.com/stellar-axis/nebula`
- `github.com/stellar-axis/orbit`
- `github.com/stellar-axis/comet-flow`
- `github.com/stellar-axis/quasar-engine`

#### Java 包名命名

统一规则：

- 根包名固定为 `io.stellar.axis`
- 子包采用英文工程域
- 包结构体现职责，不体现展示名称

推荐示例：

- `io.stellar.axis.starmap.client`
- `io.stellar.axis.nebula.config`
- `io.stellar.axis.orbit.router`
- `io.stellar.axis.pulsar.limiter`
- `io.stellar.axis.cometflow.producer`

#### CLI / 平台工具命名

统一规则：

- 工具统一走英文工程名
- 总控工具绑定总品牌

最终建议：

- 总控 CLI：`stellarctl`
- 运维平台：`stellar-console`
- 管理平面：`stellar-control-plane`

## 4. Complete Code

以下内容可作为最终命名规则摘要直接复用：

~~~md
# Naming Convention

## 最终品牌命名

- 英文总品牌：`Stellar Axis`
- 中文总品牌：`星轴`
- 标准首次展示：`Stellar Axis（星轴）`

## 最终双栈命名

- Java：`Stellar Core（星核）`
- Go：`Stellar Pulse（星脉）`

## 最终核心组件命名

| 英文正式名 | 中文正式名 |
| :--- | :--- |
| `StarMap` | `星图` |
| `Nebula` | `星云` |
| `StarTrace` | `星迹` |
| `Orbit` | `星轨` |
| `Pulsar` | `脉冲` |
| `Astrolabe` | `星盘` |
| `Singularity` | `奇点` |
| `EventHorizon` | `视界` |
| `CometFlow` | `彗流` |

## 最终 AI 子体系命名

| 英文正式名 | 中文正式名 |
| :--- | :--- |
| `Astral Layer` | `星穹层` |
| `Quasar Engine` | `类星引擎` |
| `StarVault Memory` | `星库` |
| `Orbit Agent` | `轨使` |
| `Sensor MCP` | `星感` |
| `Vector MCP` | `星行` |
| `GuideStar MCP` | `导星` |

## 命名规则

1. 总品牌固定为 `Stellar Axis（星轴）`。
2. 核心组件统一使用“英文正式名 + 中文宇宙名”双命名制。
3. 仓库、包名、依赖坐标、CLI、模块统一只使用英文工程名。
4. 不再保留任何传统哲学、拼音混合或中英混拼命名。
~~~
