# 星轴

`星轴` 是一套自研微服务中间件体系，其正式英文总品牌为 `Stellar Axis`。整套体系只采用宇宙意象命名：以“星轴”作为品牌主线，以“星图、星云、星轨、视界”等名称表达核心产品，以“星穹层”表达 AI 扩展能力，面向高并发、高可用、可治理、可演进的分布式系统场景。

本仓库当前聚焦四类内容：

- 总品牌与体系定位
- 核心组件命名与职责映射
- 仓库布局与模块边界
- 依赖约束与架构决策

## 核心定位

星轴不是若干开源组件的简单拼装，而是一套统一命名、统一分层、统一依赖约束的中间件体系。整体设计遵循以下原则：

- 以 `Stellar Axis（星轴）` 作为唯一总品牌
- 以 `英文正式名 + 中文宇宙名` 作为核心组件展示方式
- 以英文工程名作为仓库、模块、依赖坐标的唯一命名口径
- 以协议、SDK、事件和控制面作为跨产品协作边界

双栈定位如下：

- Java 框架：`Stellar Core（星核）`
- Go 框架：`Stellar Pulse（星脉）`

## 核心组件矩阵

| 领域 | 英文全称/中文全称 | 简称 |
| :--- | :---------------- | :--- |
| 注册中心 | `StarMap / 星图` | `星图` |
| 配置中心 | `Nebula / 星云` | `星云` |
| 链路追踪 | `StarTrace / 星迹` | `星迹` |
| 服务治理 | `Orbit / 星轨` | `星轨` |
| 流控熔断 | `Pulsar / 脉冲` | `脉冲` |
| 任务调度 | `Astrolabe / 星盘` | `星盘` |
| 分布式锁 | `Singularity / 奇点` | `奇点` |
| 网关入口 | `EventHorizon / 视界` | `视界` |
| 消息队列 | `CometFlow / 彗流` | `彗流` |
| 指标平台 | `Constellation / 星座` | `星座` |
| 告警平台 | `NovaSignal / 星讯` | `星讯` |
| 零信平台 | `StarShield / 星盾` | `星盾` |
| 密钥中心 | `StarKey / 星钥` | `星钥` |

推荐展示方式：

- `StarMap · 星图`
- `Nebula · 星云`
- `Orbit · 星轨`
- `CometFlow · 彗流`

## 核心组件命名释义

这一套命名不再引入地域文化或传统哲学别名，所有名称都直接绑定到宇宙、轨道、光学、时空和天体结构，让品牌语义更加统一、清晰、易扩展。

### StarMap · 星图

- `StarMap` 指星图与星位坐标。服务注册中心的本质，就是为所有服务实例提供统一坐标系，使调用方能够完成定位、发现与导航。
- 中文名 `星图` 与英文名保持完全同源，既适合品牌传播，也适合工程语境下的理解与记忆。

### Nebula · 星云

- `Nebula` 指星云。星云既是广阔的承载空间，也是新结构的孕育场，契合配置中心承载环境、分发参数、组织运行态的职责。
- 中文名 `星云` 直接表达“承载与生成”的语义，不再引入额外隐喻层。

### StarTrace · 星迹

- `StarTrace` 强调轨迹可见、路径可追。链路追踪的核心价值，就是把原本不可见的调用过程变成可观测的路径记录。
- 中文名 `星迹` 与调用链“留痕、显影、回放”的能力高度贴合。

### Orbit · 星轨

- `Orbit` 指轨道。治理系统本质上是在定义请求如何沿着既定轨道运行，包括路由、负载、灰度、流量牵引与治理策略。
- 中文名 `星轨` 直接体现“路径、约束、演化”的工程语义。

### Pulsar · 脉冲

- `Pulsar` 指脉冲星。脉冲星的节律、阈值和周期感，非常适合表达限流、配额、熔断和过载保护中的频率控制。
- 中文名 `脉冲` 简洁直接，适合在系统中表达“节拍限制”和“压力闸门”。

### Astrolabe · 星盘

- `Astrolabe` 指星盘或天体测位仪，天然带有时间、方位、周期和校准的语义。
- 中文名 `星盘` 适合作为调度系统名称，因为它同时涵盖时钟、周期、定位与编排。

### Singularity · 奇点

- `Singularity` 指奇点，强调在复杂分布式空间中收束为唯一控制点，这与锁的排他性与唯一性高度一致。
- 中文名 `奇点` 也保留了“集中、收束、单点裁决”的表达力。

### EventHorizon · 视界

- `EventHorizon` 指事件视界，是内外边界的临界面。网关正是系统内部与外部流量的边界层，承担接入、聚合、鉴权与转发职责。
- 中文名 `视界` 直接表达“边界、门面、临界面”的含义，适合作为网关家族主名。

### CometFlow · 彗流

- `CometFlow` 强调高速流动、跨域穿行和轨迹清晰，适合表达消息、事件、异步数据和系统内能量的流转。
- 中文名 `彗流` 保留了快速、持续、可观测的流动感，适合作为消息系统的主名。

### Constellation · 星座

- `Constellation` 指由多个观测点组成的结构化星座，适合表达由海量指标构成的观测图谱。
- 中文名 `星座` 对应指标聚合、拓扑映射和全局观测的工程角色。

### NovaSignal · 星讯

- `NovaSignal` 指高可见度、快速扩散的事件信号，适合作为告警、通知、升级和值守联动平台的名称。
- 中文名 `星讯` 适合承载规则告警、阈值告警和事件编排。

### StarShield · 星盾

- `StarShield` 强调边界防护、身份保护和信任裁定，适合作为统一认证鉴权与零信任平台的工程品牌。
- 中文名 `星盾` 清晰表达了身份安全与访问防护的职责。

### StarKey · 星钥

- `StarKey` 把密钥系统和统一主钥语义直接绑定到品牌中，适合作为 KMS 与密钥分发系统的工程名称。
- 中文名 `星钥` 适合承载密钥生命周期管理、证书分发、轮换与机密托管等能力。

## AI 星穹层

在核心治理矩阵之外，体系还定义了独立的 AI 星穹层：

| 英文正式名 | 中文正式名 | 职责 |
| :--- | :--- | :--- |
| `Astral Layer` | `星穹层` | AI 能力总体品牌 |
| `Quasar Engine` | `类星引擎` | 模型推理与理解 |
| `StarVault Memory` | `星库` | 记忆与知识蓄积 |
| `Orbit Agent` | `轨使` | Agent 编排与自治执行 |
| `Sensor MCP` | `星感` | 上下文感知协议 |
| `Vector MCP` | `星行` | 工具执行协议 |
| `GuideStar MCP` | `导星` | Prompt 引导协议 |

星穹层不再绑定任何传统哲学结构，而是作为治理层之上的认知扩展层存在。

## AI 命名释义

### Astral Layer · 星穹层

- `Astral Layer` 表示覆盖在治理体系之上的智能层。
- 中文名 `星穹层` 强调它不是单点模型，而是一层负责理解、记忆、推理与执行的认知结构。

### Quasar Engine · 类星引擎

- `Quasar Engine` 借用类星体的高能、高密度与强辐射意象，强调推理引擎的高强度理解与生成能力。
- 中文名 `类星引擎` 兼顾品牌辨识度与技术感。

### StarVault Memory · 星库

- `StarVault Memory` 表示统一的知识与上下文储备空间，用于积累、检索和回放模型所需的信息。
- 中文名 `星库` 直观表达“稳定存储、可检索、可沉淀”的能力。

### Orbit Agent · 轨使

- `Orbit Agent` 强调代理在既定轨道中执行、编排和协同，而不是无边界地扩张。
- 中文名 `轨使` 适合表达面向任务链路的自治执行能力。

### Sensor MCP · 星感

- `Sensor MCP` 用于上下文感知协议，强调 AI 与外部资源之间首先发生的是感知与识别。
- 中文名 `星感` 表达环境感知、上下文采样与资源发现。

### Vector MCP · 星行

- `Vector MCP` 用于工具执行协议，强调执行路径清晰、动作可达、结果可验证。
- 中文名 `星行` 表达工具调用的运行轨迹与稳定执行。

### GuideStar MCP · 导星

- `GuideStar MCP` 用于 Prompt 引导协议，强调系统通过明确导向帮助模型进入正确理解与执行路径。
- 中文名 `导星` 适合作为提示、引导和约束协议的名称。

## 工程命名口径

以下口径已经固定：

- 总品牌：`Stellar Axis（星轴）`
- Java 聚合仓库：`stellar-core`
- Go 聚合仓库：`stellar-pulse`
- AI 聚合仓库：`astral-layer`
- 控制平面：`stellar-control-plane`
- CLI：`stellarctl`
- 公开依赖坐标根命名空间：`io.stellar.axis`

不再保留任何带传统哲学意象或混合语义的旧别名。

## 网关家族命名建议

你现在有内部网关、外部网关、LLM 网关、边缘网关。它们适合共享同一个网关家族主名，并通过二级限定词区分不同职责。

建议规则：

- 家族主名统一使用 `EventHorizon · 视界`
- 不同项目通过二级限定词区分
- 仓库名、模块名和部署单元继续使用英文工程后缀区分

推荐方案如下：

| 场景 | 英文建议 | 中文建议 | 说明 |
| :--- | :--- | :--- | :--- |
| 内部网关 | `EventHorizon Internal` | `视界·内域` | 面向服务网格内部、东西向流量与内部路由治理 |
| 外部网关 | `EventHorizon External` | `视界·外域` | 面向南北向入口、开放接入与统一暴露 |
| LLM 网关 | `EventHorizon LLM` | `视界·智域` | 面向模型路由、模型鉴权、Token 治理与 AI 请求编排 |
| 边缘网关 | `EventHorizon Edge` | `视界·边域` | 面向边缘节点、接入加速、就近转发与边缘计算场景 |

如果落实到仓库名，建议分别使用：

- `event-horizon-internal`
- `event-horizon-external`
- `event-horizon-llm`
- `event-horizon-edge`

## 仓库布局

整个体系采用“品牌聚合仓库 + 核心产品仓库 + 配套能力仓库”的三层结构。

顶层聚合仓库：

- `stellar-axis`
- `stellar-core`
- `stellar-pulse`
- `astral-layer`
- `stellar-control-plane`
- `stellarctl`
- `stellar-examples`
- `stellar-deploy`

核心产品仓库：

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

单产品统一目录骨架：

```text
{product}/
├── docs/
├── api/
├── server/
├── clients/
├── starters/
├── sidecars/
├── operators/
├── deploy/
├── test/
└── examples/
```

## 依赖规则

整套体系统一采用单向依赖约束。

允许的原则：

- 依赖公开 API、SDK 和稳定协议
- 通过控制面、事件流和官方客户端实现跨产品协作
- `starter` 依赖 `clients/api`
- `sidecar` 依赖 `clients/api/runtime`
- `operator` 依赖 `api` 和 Kubernetes Runtime

禁止的原则：

- `starter -> server`
- `client -> server`
- `operator -> server`
- `control-plane -> product/internal`
- `productA/server -> productB/server`
- `examples -> product/internal`

## 文档导航

- [命名提案](./Proposal.md)
- [命名规范](./Naming-Convention.md)
- [仓库布局](./Repo-Layout.md)
- [模块依赖](./Module-Dependency.md)
- [架构决策记录](./Architecture-Decision-Record.md)

## 架构口号

> 以星轴定向，以星图定位，以星轨协同，以视界守边。

## License

Apache License 2.0
