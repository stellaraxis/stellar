# Repository Bootstrap Plan

## 1. Problem Analysis

路线图解决的是“先做什么、后做什么”，但还没有解决“每个仓库落地时第一天要创建什么”的问题。

如果没有初始化计划，常见问题包括：

- 仓库名字确定了，但目录和占位模块迟迟没有落地
- 不同仓库初始化粒度不一致，后续很难统一维护
- README、构建文件、目录骨架、示例和占位清单经常被遗漏

因此，这份文档的目标是给出每个仓库的初始化计划，明确第一批目录、占位文件、基础模块和可验证动作。

## 2. Design

### 2.1 初始化原则

所有仓库初始化统一遵循以下原则：

- **先建目录骨架，再写主实现**
- **先建 README 与构建文件，再建业务模块**
- **先放占位模块，再逐步填充功能**
- **仓库初始化必须与 [Repo-Layout.md](./Repo-Layout.md) 一致**
- **依赖方向必须与 [Module-Dependency.md](./Module-Dependency.md) 一致**

### 2.2 初始化输出标准

每个仓库初始化至少包含：

- `README.md`
- License
- `.gitignore`
- 构建入口文件
- 规范目录骨架
- 至少一个占位模块

## 3. Implementation

### 3.1 总入口仓库：`stellar-axis`

#### 第一步创建

- `README.md`
- `README-EN.md`
- `Proposal.md`
- `Naming-Convention.md`
- `Repo-Layout.md`
- `Module-Dependency.md`
- `Architecture-Decision-Record.md`
- `Roadmap.md`
- `Repository-Bootstrap-Plan.md`

#### 第二步创建目录

```text
stellar-axis/
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
└── links/
```

### 3.2 Java 聚合仓库：`stellar-core`

#### 第一步创建

- `README.md`
- `pom.xml`
- `.mvn/` 或等价构建目录

#### 第二步创建模块

```text
stellar-core/
├── stellar-core-bom/
├── stellar-core-common/
├── stellar-core-runtime/
├── stellar-core-testing/
├── stellar-core-observability/
├── starters/
├── sdks/
├── integrations/
├── examples/
└── docs/
```

#### 第三步创建首批占位模块

- `starters/starmap-spring-boot-starter`
- `starters/nebula-spring-boot-starter`
- `starters/orbit-spring-boot-starter`
- `starters/comet-flow-spring-boot-starter`
- `sdks/starmap-client`
- `sdks/nebula-client`
- `sdks/orbit-client`
- `sdks/comet-flow-client`

### 3.3 Go 聚合仓库：`stellar-pulse`

#### 第一步创建

- `README.md`
- `go.mod`

#### 第二步创建目录

```text
stellar-pulse/
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
├── sidecars/
├── internal/
├── examples/
└── docs/
```

#### 第三步创建首批占位模块

- `sdk/starmap`
- `sdk/nebula`
- `sdk/orbit`
- `sdk/cometflow`
- `sidecars/orbit-sidecar`
- `sidecars/pulsar-sidecar`

### 3.4 控制平面仓库：`stellar-control-plane`

#### 第一步创建

- `README.md`
- 顶层构建与工作区文件

#### 第二步创建目录

```text
stellar-control-plane/
├── docs/
├── backend/
│   ├── api/
│   ├── application/
│   ├── domain/
│   ├── infrastructure/
│   └── interfaces/
├── frontend/
├── modules/
├── auth/
├── deploy/
└── test/
```

#### 第三步创建首批模块

- `modules/starmap-console`
- `modules/nebula-console`
- `modules/orbit-console`
- `modules/comet-flow-console`

### 3.5 CLI 仓库：`stellarctl`

#### 第一步创建

- `README.md`
- 顶层构建文件

#### 第二步创建目录

```text
stellarctl/
├── cmd/
├── pkg/
│   ├── client/
│   ├── output/
│   ├── config/
│   └── auth/
├── internal/
├── docs/
└── test/
```

#### 第三步创建首批命令

- `cmd/root`
- `cmd/starmap`
- `cmd/nebula`
- `cmd/orbit`
- `cmd/comet-flow`

### 3.6 示例仓库：`stellar-examples`

#### 第一步创建

- `README.md`

#### 第二步创建目录

```text
stellar-examples/
├── java/
├── go/
├── fullstack/
└── docs/
```

#### 第三步创建首批示例

- `java/starmap-demo`
- `java/nebula-demo`
- `java/orbit-demo`
- `go/starmap-demo`
- `go/pulsar-demo`
- `go/comet-flow-demo`

### 3.7 部署仓库：`stellar-deploy`

#### 第一步创建

- `README.md`

#### 第二步创建目录

```text
stellar-deploy/
├── docker-compose/
├── kubernetes/
├── helm/
├── terraform/
├── ansible/
└── scripts/
```

#### 第三步创建首批部署资产

- `docker-compose/dev-stack`
- `kubernetes/starmap`
- `kubernetes/nebula`
- `helm/comet-flow`

### 3.8 AI 聚合仓库：`astral-layer`

#### 第一步创建

- `README.md`

#### 第二步创建目录

```text
astral-layer/
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

### 3.9 核心产品仓库初始化模板

适用于：

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

#### 第一步创建

- `README.md`
- 构建入口文件

#### 第二步创建目录

```text
{product}/
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
├── sidecars/
├── operators/
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

#### 第三步创建最小占位模块

- `api/openapi`
- `api/protobuf`
- `server/app`
- `clients/java`
- `clients/go`
- `deploy/docker`
- `test/integration`

#### 条件模块

按需创建：

- `starters/{product}-spring-boot-starter`
- `sidecars/{product}-sidecar`
- `operators/{product}-operator`

### 3.10 第一批核心仓库 Bootstrap 顺序

建议按以下顺序初始化：

1. `stellar-axis`
2. `stellar-core`
3. `stellar-pulse`
4. `starmap`
5. `nebula`
6. `orbit`
7. `comet-flow`
8. `stellar-examples`
9. `stellar-control-plane`
10. `stellarctl`

### 3.11 初始化检查清单

每个新仓库创建后统一检查：

- 仓库名是否符合 [Naming-Convention.md](./Naming-Convention.md)
- 目录结构是否符合 [Repo-Layout.md](./Repo-Layout.md)
- 依赖方向是否符合 [Module-Dependency.md](./Module-Dependency.md)
- README 是否说明仓库职责
- 构建入口是否可执行
- 至少一个占位模块是否可编译

## 4. Complete Code

以下内容可作为初始化摘要直接复用：

~~~md
# Repository Bootstrap Plan

## 第一批先建

- `stellar-axis`
- `stellar-core`
- `stellar-pulse`
- `starmap`
- `nebula`
- `orbit`
- `comet-flow`

## 聚合仓库最小要求

- README
- 构建入口
- 核心目录骨架
- 至少一个 starter/sdk/sidecar 占位模块

## 单产品仓库最小要求

- `docs/`
- `api/`
- `server/`
- `clients/`
- `deploy/`
- `test/`
~~~
