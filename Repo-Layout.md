# Repo Layout

## 1. Problem Analysis

在 [Proposal.md](./Proposal.md) 和 [Naming-Convention.md](./Naming-Convention.md) 中，我们已经解决了“叫什么”的问题，但还没有完全解决“怎么拆”的问题。

如果仓库布局没有统一规则，后续会迅速出现以下问题：

- 不同中间件仓库目录层级不一致，开发体验和维护成本都会变差。
- Java 与 Go 双栈无法形成稳定的横向对照关系。
- Starter、Sidecar、Operator、Agent Runtime 的位置不固定，导致依赖和职责边界混乱。
- 文档、SDK、示例、部署清单、控制平面可能被散落在各个仓库中，后续难以治理。

因此，这份文档的目标是定义一套最终可执行的仓库与目录布局规范，使整套 `Stellar Axis（星轴）` 体系可以在扩展时保持一致。

## 2. Design

### 2.1 布局设计原则

仓库布局遵循以下原则：

- **按产品边界拆仓**：每个核心中间件拥有独立产品仓库。
- **按语言栈聚合**：Java 与 Go 各自有统一的聚合仓库承载公共运行时、SDK 与 Starter。
- **按部署形态拆模块**：核心库、服务端、客户端、Starter、Sidecar、Operator、控制面分层明确。
- **按使用对象分目录**：开发者依赖、平台运维、控制平面、示例工程分别放置。
- **按长期演进设计**：目录结构要支持单体起步，也能支持未来拆出独立团队维护。

### 2.2 仓库分层模型

建议采用三层仓库模型：

#### 第一层：品牌与聚合仓库

用于承载总文档、全局 BOM、规范、示例导航与跨产品聚合逻辑。

- `stellar-axis`
- `stellar-core`
- `stellar-pulse`
- `astral-layer`
- `stellar-control-plane`

#### 第二层：核心产品仓库

每个核心中间件单独一个仓库。

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

#### 第三层：配套能力仓库

用于承载控制面、运维工具、示例工程、基准测试、平台扩展。

- `stellar-examples`
- `stellar-benchmarks`
- `stellar-deploy`
- `stellarctl`

### 2.3 仓库职责边界

#### `stellar-axis`

作为总入口仓库，职责是：

- 总 README
- 命名规范
- 仓库布局规范
- 架构图与产品矩阵
- 跳转到各子仓库

它不承载具体中间件源码，只承载全局说明与治理规则。

#### `stellar-core`

作为 Java 聚合仓库，职责是：

- Java 通用运行时
- 公共 API 与 SPI
- Spring Boot Starter
- Java SDK 聚合
- Java BOM

它是 Java 研发者接入体系的主入口。

#### `stellar-pulse`

作为 Go 聚合仓库，职责是：

- Go 通用运行时
- 公共接口与协议抽象
- Go SDK 聚合
- Sidecar 支持库
- 高并发基础组件

它是 Go 研发者和边缘运行时接入体系的主入口。

#### 单产品仓库

如 `starmap`、`nebula`、`orbit` 等，每个仓库都只负责一个产品的完整生命周期：

- server
- api/protocol
- client sdk
- starter
- sidecar
- operator
- docs
- deploy

这样可以保证产品边界清晰，后续也容易独立迭代。

## 3. Implementation

### 3.1 最终仓库清单

#### 顶层品牌与聚合仓库

| 仓库名 | 作用 |
| :--- | :--- |
| `stellar-axis` | 总入口、规范、架构、产品导航 |
| `stellar-core` | Java 聚合仓库 |
| `stellar-pulse` | Go 聚合仓库 |
| `astral-layer` | AI 星穹层聚合仓库 |
| `stellar-control-plane` | 控制平面与统一管理后台 |
| `stellarctl` | CLI 工具仓库 |
| `stellar-examples` | 官方示例仓库 |
| `stellar-deploy` | Helm、Kustomize、Compose、Terraform 等部署资产 |
| `stellar-benchmarks` | 基准测试与性能对比仓库 |

#### 核心产品仓库

| 仓库名 | 产品名 | 职责 |
| :--- | :--- | :--- |
| `starmap` | `StarMap · 星图` | 服务注册与发现 |
| `nebula` | `Nebula · 星云` | 配置中心 |
| `startrace` | `StarTrace · 星迹` | 链路追踪 |
| `orbit` | `Orbit · 星轨` | 服务治理与流量路由 |
| `pulsar` | `Pulsar · 脉冲` | 限流、熔断、过载保护 |
| `astrolabe` | `Astrolabe · 星盘` | 分布式调度 |
| `singularity` | `Singularity · 奇点` | 分布式锁 |
| `event-horizon` | `EventHorizon · 视界` | 网关与边界入口 |
| `comet-flow` | `CometFlow · 彗流` | MQ / Event Streaming |

### 3.2 总入口仓库结构

#### `stellar-axis`

推荐目录结构：

```text
stellar-axis/
├── README.md
├── README-EN.md
├── Proposal.md
├── Naming-Convention.md
├── Repo-Layout.md
├── docs/
│   ├── architecture/
│   ├── concepts/
│   ├── glossary/
│   └── decisions/
├── assets/
│   ├── diagrams/
│   ├── logos/
│   └── brand/
├── product-matrix/
│   ├── starmap.md
│   ├── nebula.md
│   ├── orbit.md
│   └── ...
└── links/
    ├── repositories.md
    └── roadmap.md
```

### 3.3 Java 聚合仓库结构

#### `stellar-core`

推荐目录结构：

```text
stellar-core/
├── README.md
├── pom.xml
├── stellar-core-bom/
├── stellar-core-runtime/
├── stellar-core-common/
├── stellar-core-testing/
├── stellar-core-observability/
├── starters/
│   ├── starmap-spring-boot-starter/
│   ├── nebula-spring-boot-starter/
│   ├── startrace-spring-boot-starter/
│   ├── orbit-spring-boot-starter/
│   ├── pulsar-spring-boot-starter/
│   ├── astrolabe-spring-boot-starter/
│   ├── singularity-spring-boot-starter/
│   ├── event-horizon-spring-boot-starter/
│   └── comet-flow-spring-boot-starter/
├── sdks/
│   ├── starmap-client/
│   ├── nebula-client/
│   ├── startrace-client/
│   ├── orbit-client/
│   ├── pulsar-client/
│   ├── astrolabe-client/
│   ├── singularity-client/
│   ├── event-horizon-client/
│   └── comet-flow-client/
├── integrations/
├── examples/
└── docs/
```

### 3.4 Go 聚合仓库结构

#### `stellar-pulse`

推荐目录结构：

```text
stellar-pulse/
├── README.md
├── go.mod
├── cmd/
├── pkg/
│   ├── runtime/
│   ├── transport/
│   ├── config/
│   ├── discovery/
│   ├── governance/
│   ├── resilience/
│   └── observability/
├── sdk/
│   ├── starmap/
│   ├── nebula/
│   ├── startrace/
│   ├── orbit/
│   ├── pulsar/
│   ├── astrolabe/
│   ├── singularity/
│   ├── eventhorizon/
│   └── cometflow/
├── sidecars/
│   ├── orbit-sidecar/
│   ├── pulsar-sidecar/
│   ├── startrace-sidecar/
│   └── event-horizon-sidecar/
├── internal/
├── examples/
└── docs/
```

### 3.5 AI 聚合仓库结构

#### `astral-layer`

推荐目录结构：

```text
astral-layer/
├── README.md
├── docs/
├── quasar-engine/
├── starvault-memory/
├── orbit-agent/
├── protocols/
│   ├── sensor-mcp/
│   ├── vector-mcp/
│   └── guidestar-mcp/
├── sdk/
├── examples/
└── deploy/
```

### 3.6 单产品仓库统一结构

每个核心产品仓库统一采用相同骨架。

以 `starmap` 为例：

```text
starmap/
├── README.md
├── docs/
│   ├── architecture/
│   ├── api/
│   ├── operations/
│   └── faq/
├── api/
│   ├── openapi/
│   ├── protobuf/
│   └── model/
├── server/
│   ├── app/
│   ├── bootstrap/
│   ├── domain/
│   ├── infrastructure/
│   └── interfaces/
├── clients/
│   ├── java/
│   ├── go/
│   └── http/
├── starters/
│   └── starmap-spring-boot-starter/
├── sidecars/
│   └── starmap-sidecar/
├── operators/
│   └── starmap-operator/
├── deploy/
│   ├── docker/
│   ├── kubernetes/
│   ├── helm/
│   └── scripts/
├── test/
│   ├── integration/
│   ├── e2e/
│   └── benchmark/
└── examples/
```

该骨架适用于以下仓库：

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

### 3.7 Starter / Sidecar / Operator 规范

统一命名：

- Starter：`{product}-spring-boot-starter`
- Sidecar：`{product}-sidecar`
- Operator：`{product}-operator`

职责约束：

- Starter 只负责接入体验，不承载核心业务逻辑。
- Sidecar 只负责独立进程形态的运行能力。
- Operator 只负责 Kubernetes 生命周期管理。

### 3.8 模块拆分约束

为了避免仓库越来越乱，统一遵循以下约束：

#### 必备模块

每个核心产品仓库至少包含：

- `docs/`
- `api/`
- `server/`
- `clients/`
- `deploy/`
- `test/`

#### 条件模块

满足条件时才创建：

- `starters/`：提供 Java Spring Boot 接入时创建
- `sidecars/`：存在边车部署形态时创建
- `operators/`：存在 Kubernetes 生命周期管理需求时创建
- `examples/`：产品具备独立最小示例时创建

#### 禁止事项

以下做法统一禁止：

- 在总仓库 `stellar-axis` 中放置具体产品实现代码
- 在单产品仓库中混放多个核心产品
- 在 Starter 中放置服务端主实现
- 在 SDK 中放置控制平面逻辑
- 在 Operator 中放置业务客户端 SDK

## 4. Complete Code

以下内容可作为仓库布局摘要直接复用：

~~~md
# Repo Layout

## 顶层仓库

- `stellar-axis`：总入口与规范仓库
- `stellar-core`：Java 聚合仓库
- `stellar-pulse`：Go 聚合仓库
- `astral-layer`：AI 星穹层聚合仓库
- `stellar-control-plane`：统一控制平面
- `stellarctl`：CLI 工具
- `stellar-examples`：示例仓库
- `stellar-deploy`：部署资产仓库

## 核心产品仓库

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

## 单产品统一目录骨架

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
~~~
```
