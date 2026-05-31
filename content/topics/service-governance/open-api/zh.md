# Open API 标准设计方式研究

## 摘要

Open API 是面向外部系统、合作方、开发者或跨平台调用方开放的应用程序接口。其标准化设计不仅包含接口文档格式，还包含传输协议、资源建模、鉴权授权、限流配额、网关承载、业务复用、可观测性和性能优化等多个方面。OpenAPI Specification（OAS）定义了面向 HTTP API 的、与编程语言无关的接口描述格式，使调用方能够在不访问源代码、不检查网络流量的情况下理解服务能力[1]。基于 OAS 3.1.1、HTTP Semantics、OAuth 2.0、OpenID Connect、W3C Trace Context、OpenTelemetry、Prometheus、Envoy 等官方标准和文档，本文归纳 Open API 的标准设计方式，并给出面向大型企业基础架构平台的实现结构。

**关键词**：Open API；OpenAPI Specification；HTTP API；OAuth 2.0；API Gateway；Rate Limit；Observability

## 1 引言

Open API 的核心目标是将系统能力以稳定、可理解、可治理的方式暴露给外部调用方。与内部 RPC 或前端私有接口相比，Open API 的调用方不可控、流量来源复杂、变更成本高，因此需要在协议层、契约层、安全层和治理层形成统一约束。

OpenAPI Specification 并不是新的网络传输协议，而是 HTTP API 的标准描述格式。OAS 官方定义其为“标准的、与编程语言无关的 HTTP API 接口描述”，用于描述服务的路径、操作、参数、请求体、响应、鉴权方式和扩展信息[1]。因此，Open API 的协议基础应当是 HTTP/HTTPS，接口契约应当使用 OpenAPI Specification 描述，当前新建项目可采用 OAS 3.1.1 作为契约基线。OpenAPI Initiative 在 2024 年 10 月的发布说明中明确指出，3.1.1 是当时最新且推荐的新项目目标版本[2]。

## 2 Open API 的协议基础

### 2.1 协议选择

Open API 广泛采用 HTTP/HTTPS 作为应用层协议，接口表现形式通常为 REST 风格的 HTTP API。HTTP Semantics RFC 9110 定义了 HTTP 的整体架构、核心术语、URI scheme、方法、状态码、字段和通用语义[3]。HTTP 的资源标识、请求方法、响应状态码、头字段、内容协商和缓存机制，为开放接口提供了通用语义基础。

在数据交换格式上，JSON 是常用选择。RFC 8259 将 JSON 定义为轻量级、文本型、与编程语言无关的数据交换格式[4]。OAS 3.1 的 Schema Object 与 JSON Schema 2020-12 对齐，能够表达请求和响应数据结构、字段类型、必填属性和约束条件[5]。

因此，Open API 的标准协议组合可以表述为：传输层使用 TLS 保护的 HTTPS，应用层使用 HTTP 语义，接口契约使用 OpenAPI Specification 3.1.1，主要数据格式使用 JSON，复杂二进制场景通过 HTTP media type 明确描述。

### 2.2 HTTP 版本选择

HTTP 语义与具体传输版本分离。RFC 9110 定义 HTTP 通用语义，RFC 9112、RFC 9113 和 RFC 9114 分别定义 HTTP/1.1、HTTP/2 和 HTTP/3 的线上传输形式[3][6]。HTTP/2 在同一连接上支持多路复用和字段压缩，HTTP/3 将 HTTP 语义映射到 QUIC 传输上[6]。因此，Open API 的接口语义不应绑定到某一个 HTTP 传输版本；在网关和客户端均支持的情况下，可在边缘网关层启用 HTTP/2 或 HTTP/3，而接口契约仍以 HTTP 方法、路径、状态码、Header 和 Body 为标准语义单位。

## 3 Open API 的接口设计原则

### 3.1 以资源和操作语义建模

HTTP 的设计目标之一是将资源标识与请求语义分离，请求语义由方法和部分请求头字段表达[3]。因此，Open API 的路径应表示资源集合或资源实例，操作语义应由 HTTP Method 承担。例如，`GET /orders/{orderId}` 表示读取订单资源，`POST /orders` 表示创建订单资源，`PUT /orders/{orderId}` 表示替换订单资源，`DELETE /orders/{orderId}` 表示删除订单资源。

RFC 9110 定义了安全方法和幂等方法。GET、HEAD、OPTIONS、TRACE 属于安全方法；PUT、DELETE 以及安全方法属于幂等方法[7]。因此，接口设计应使方法语义与业务副作用一致：查询接口不应产生业务状态变更；PUT 和 DELETE 的重复请求应保持相同的服务端状态效果；POST 用于创建、提交、触发流程等非幂等业务动作。

### 3.2 使用标准状态码和错误结构

Open API 不应将所有响应都包装为 HTTP 200，再通过业务字段表达成功或失败。HTTP 状态码本身承担协议层结果表达：2xx 表示成功，3xx 表示重定向或缓存相关结果，4xx 表示客户端请求问题，5xx 表示服务端处理问题。对于错误响应，RFC 9457 定义了 HTTP API 的 Problem Details 格式，用于承载机器可读的错误详情，避免每个 API 自行定义互不兼容的错误结构[8]。

标准错误响应可采用如下结构：

```json
{
  "type": "https://api.example.com/problems/quota-exceeded",
  "title": "Quota exceeded",
  "status": 429,
  "detail": "The tenant has exceeded the configured quota.",
  "instance": "/requests/01HV..."
}
```

其中 `type` 表示错误类型文档地址，`title` 表示错误摘要，`status` 对应 HTTP 状态码，`detail` 表示具体错误说明，`instance` 表示本次错误实例。

### 3.3 使用 OpenAPI 契约约束接口

OpenAPI 文档应作为接口契约源。契约中应描述 `servers`、`paths`、`operationId`、`parameters`、`requestBody`、`responses`、`components.schemas`、`components.securitySchemes` 和全局或操作级 `security` 配置[1][9]。其中，`operationId` 应稳定且唯一，因为它通常会被用于 SDK 生成、网关路由、监控维度和审计定位。

请求参数应明确区分 path、query、header 和 cookie 参数。请求体和响应体应通过 Schema Object 描述字段结构。枚举值、长度、格式、数值范围、数组长度、是否必填等约束应进入契约，而不是仅保存在说明文档中。

### 3.4 版本、分页和兼容性

Open API 面向外部调用方时，接口变更应遵循兼容性约束。新增可选字段通常是兼容变更；删除字段、修改字段类型、修改枚举含义、改变状态码语义或改变鉴权要求通常属于破坏性变更。版本可通过路径版本、Header 版本或媒体类型版本表达，但必须在 OpenAPI 文档中显式声明。

分页接口应避免一次性返回无界集合。分页信息可通过 query 参数表达，例如 `limit`、`cursor`、`pageToken`，也可结合 HTTP Link Header 表达相关资源链接。RFC 8288 定义了 Web Linking 模型以及通过 HTTP Link Header 序列化链接的方式[10]。

## 4 Open API 的鉴权与授权设计

### 4.1 安全传输

开放接口应使用 HTTPS。OWASP REST Security Cheat Sheet 明确指出，安全 REST 服务只能提供 HTTPS endpoint，以保护密码、API Key、JWT 等认证凭据在传输过程中的安全，并为客户端提供服务端认证和数据完整性保护[11]。

### 4.2 鉴权协议

OpenAPI 支持五类安全方案：API Key、HTTP Authentication、Mutual TLS、OAuth 2.0 和 OpenID Connect[9]。其中，OAuth 2.0 是开放授权的标准框架。RFC 6749 定义 OAuth 2.0 用于使第三方应用在资源所有者授权或应用自身授权的条件下，获得对 HTTP 服务的有限访问权限[12]。RFC 6750 定义 Bearer Token 在 HTTP 请求中访问 OAuth 2.0 受保护资源的使用方式[13]。OpenID Connect Core 1.0 在 OAuth 2.0 之上定义身份认证能力和 Claims 传递方式[14]。

因此，Open API 的鉴权模型可分为三类：

第一，服务到服务调用使用 OAuth 2.0 Client Credentials，调用方通过 `client_id`、`client_secret`、私钥或证书换取 Access Token。网关或资源服务验证 Token 的签名、有效期、签发方、受众、scope 和租户信息。

第二，用户代理调用使用 OAuth 2.0 Authorization Code Flow，并在需要身份认证时结合 OpenID Connect。资源服务通过 Access Token 判断调用权限，通过 ID Token 或用户信息端点识别用户身份。

第三，高安全等级 B2B 接口可在 OAuth 2.0 基础上叠加 mTLS 或 DPoP。RFC 8705 定义 OAuth 2.0 的 mutual TLS 客户端认证和证书绑定 Token；RFC 9449 定义 DPoP，用于通过应用层的持有证明机制约束 OAuth 2.0 Token，降低 Token 重放风险[15]。

### 4.3 授权模型

鉴权回答“调用方是谁”，授权回答“调用方是否可以访问该资源”。Open API 的授权不应只停留在接口级别，还应包含租户级、应用级、用户级、scope 级和对象级授权。OWASP API Security Top 10 2023 将 Broken Object Level Authorization 列为 API 风险之一，攻击者可通过篡改请求中的对象 ID 访问未授权对象[16]。因此，资源服务必须在业务层校验对象归属、租户边界和操作权限。

标准授权上下文应至少包含：`tenant_id`、`client_id`、`user_id`、`subject`、`scopes`、`roles`、`resource_owner`、`operationId` 和 `resource_id`。网关可完成 Token 校验、scope 初筛和租户识别；资源服务必须完成对象级和业务级授权。

## 5 Open API 的限流与租户配额设计

### 5.1 限流维度

Open API 的限流应以多维度资源消耗为对象，而不是只按 IP 计数。基础维度包括：租户、应用、Access Token、用户、接口 operationId、HTTP method、路由模板、调用来源、地域、成本单元和时间窗口。对于同一租户下的多个应用，应支持租户总额度、应用子额度和接口级额度。

一个典型额度模型如下：

```text
tenant_quota = 10000 requests/minute
app_quota    = 2000 requests/minute
api_quota    = 500 requests/minute for POST /v1/orders
cost_quota   = 100000 cost-units/day
```

其中 cost unit 可用于区分不同接口的资源成本。例如，普通查询消耗 1 个单位，批量导出消耗 100 个单位，复杂计算接口消耗 500 个单位。

### 5.2 限流响应

当调用方超过限制时，HTTP 应返回 429 Too Many Requests。RFC 6585 定义 429 表示用户在给定时间内发送了过多请求，并指出响应可以包含 Retry-After Header，表示多久之后可重新请求[17]。限流响应可同时包含 Problem Details 与限流相关 Header：

```http
HTTP/1.1 429 Too Many Requests
Content-Type: application/problem+json
Retry-After: 60
RateLimit: limit=2000, remaining=0, reset=60
RateLimit-Policy: 2000;w=60
```

IETF HTTPAPI 工作组的 RateLimit Header 草案定义了 `RateLimit` 和 `RateLimit-Policy` 字段，用于向客户端声明当前限制和策略，帮助客户端避免触发限流[18]。由于该文档仍处于 Internet-Draft 状态，生产实现需要明确兼容策略，并可同时保留已经广泛使用的 `X-RateLimit-Limit`、`X-RateLimit-Remaining`、`X-RateLimit-Reset` 作为兼容字段。

### 5.3 分租户额度

分租户配额应以租户为最高治理边界。网关或限流服务在请求进入时解析 `tenant_id`，然后根据租户套餐、应用标识、接口等级和当前时间窗口计算是否允许请求。实现上可采用集中式全局限流服务，也可采用本地令牌桶加全局配额同步。Envoy 官方文档说明，Envoy 支持全局限流：每连接或每 HTTP 请求检查，以及基于周期性负载报告的 quota-based 限流，后者适用于大规模 Envoy 部署和高 RPS 场景[19]。

## 6 Open API 背后的网关设计

Open API 网关是外部流量进入企业系统的第一层治理入口。其职责包括 TLS 终止、协议升级、路由匹配、认证鉴权、限流、请求大小限制、Header 规范化、CORS、灰度路由、熔断、超时、重试、访问日志、指标采集和 Trace 透传。

以 Envoy 为例，HTTP Connection Manager 将原始字节转换为 HTTP 级别消息和事件，并提供路由、Header 处理、访问日志和 HTTP Filter 链能力[20]。Envoy HTTP Filter 可以在连接管理器中处理 HTTP 消息，而不需要关心底层物理协议是 HTTP/1.1、HTTP/2 还是其他复用协议[21]。因此，网关应将通用横切能力放入 Filter 链，将业务逻辑留在后端服务。

标准网关链路可设计为：

```text
Client
  -> DNS / CDN / WAF
  -> API Gateway / Envoy
       -> TLS termination
       -> request normalization
       -> authentication
       -> authorization pre-check
       -> tenant identification
       -> rate limit / quota check
       -> request size limit
       -> route matching
       -> timeout / retry / circuit breaking
       -> access log / metrics / tracing
  -> Open API Adapter
  -> Application Service
  -> Domain Service
  -> Infrastructure
```

Envoy External Authorization Filter 可将授权决策委托给外部服务[22]；Envoy Local Rate Limit Filter 可在路由或虚拟主机级别应用 token bucket 限流[23]；Envoy Overload Manager 用于基于内存、CPU、文件描述符等资源保护 Envoy 实例免于过载[24]。因此，网关层应承担协议和治理职责，但不应承载核心业务规则。

## 7 Open API 与前端入口的业务逻辑复用

Open API 与前端入口可能处理相同业务能力，但二者面向的客户端不同。前端入口通常服务于浏览器或 App 页面，接口形态可围绕页面展示聚合；Open API 服务于外部系统，接口形态应围绕稳定资源、权限边界和契约兼容性建模。因此，复用不应发生在 Controller 层或 DTO 层，而应发生在应用服务层和领域服务层。

标准结构如下：

```text
Frontend Controller / BFF
        \
         -> Application Service -> Domain Service -> Repository / Client
        /
Open API Controller / Open API Adapter
```

其中，Frontend Controller 可返回页面友好的 View DTO；Open API Adapter 返回公开契约 DTO。两类入口共享应用服务和领域服务，但分别维护请求校验、权限上下文转换、DTO 转换、错误码映射和审计策略。这样可以避免前端私有字段泄漏到 Open API，也可以避免 Open API 的兼容性要求反向约束前端快速迭代。

在大型企业中，Open API 的契约 DTO 应与内部领域模型隔离。领域模型变化不应直接导致 Open API 响应结构变化；Open API DTO 的废弃应通过版本策略、字段 `deprecated` 标记和迁移周期处理。

## 8 Open API 的埋点设计

Open API 的埋点应覆盖日志、指标和链路追踪三类遥测数据。OpenTelemetry 将自身定义为用于生成、收集和导出 traces、metrics、logs 等遥测数据的厂商中立开源可观测性框架[25]。W3C Trace Context 定义 `traceparent` 和 `tracestate` Header，用于在分布式系统中传播追踪上下文[26]。OpenTelemetry HTTP Semantic Conventions 定义 HTTP span、metric 和 log 的语义约定，可用于 HTTP/HTTPS 以及 HTTP/1.1、HTTP/2 等版本[27]。

### 8.1 日志字段

访问日志应记录以下字段：`timestamp`、`trace_id`、`span_id`、`request_id`、`tenant_id`、`client_id`、`user_id`、`operation_id`、`method`、`route_template`、`path`、`status_code`、`error_type`、`latency_ms`、`request_bytes`、`response_bytes`、`upstream_service`、`upstream_status`、`auth_result`、`rate_limit_result`、`quota_policy`、`source_ip`、`user_agent`。

其中，`route_template` 应记录模板路径，例如 `/v1/orders/{orderId}`，避免将真实 ID 写入高基数标签。敏感字段如 Token、Secret、手机号、证件号和银行卡号不得进入明文日志。

### 8.2 指标字段

Prometheus 定义了 Counter、Gauge、Histogram、Summary 等指标类型；Histogram 用 bucket 记录观测值分布，并提供总和与计数[28]。Open API 的指标可包括：

```text
openapi_requests_total{tenant,client,operation,method,status}
openapi_request_duration_seconds_bucket{tenant,client,operation,method,status,le}
openapi_request_bytes_bucket{operation,le}
openapi_response_bytes_bucket{operation,le}
openapi_auth_failures_total{reason}
openapi_rate_limited_total{tenant,client,operation,policy}
openapi_quota_remaining{tenant,client,quota_type}
openapi_upstream_errors_total{upstream,reason}
openapi_upstream_timeout_total{upstream}
```

指标标签必须控制基数，不应将 `user_id`、`order_id`、完整 URL、错误详情文本等高基数字段作为标签。

### 8.3 Trace 设计

网关接收请求后应读取或生成 `traceparent`，并向后端服务透传。Trace Span 应覆盖网关处理、鉴权服务、限流服务、后端应用服务、数据库访问和外部依赖调用。Span 属性应包含 HTTP method、route、status_code、tenant_id、client_id、operationId 和限流决策结果。采样策略可在网关层配置，错误请求、慢请求和限流请求可进入更高采样优先级。

## 9 Open API 的性能优化

Open API 性能优化应覆盖协议、缓存、网关、后端服务和数据访问多个层面。

第一，协议层可启用 HTTP/2 或 HTTP/3。HTTP/2 通过字段压缩和同一连接上的多个并发交换提高网络资源利用率并降低延迟[6]。HTTP/3 将 HTTP 语义映射到 QUIC，并利用 QUIC 的流复用、流控和低延迟连接建立能力[6]。

第二，缓存层应使用 HTTP 缓存语义。RFC 9111 定义 HTTP Cache 以及控制缓存行为或标识可缓存响应的 Header 字段[29]。对于可缓存的 GET 接口，应使用 `Cache-Control`、`ETag`、`Last-Modified`、`If-None-Match`、`If-Modified-Since` 和 304 Not Modified。对于租户隔离数据，缓存 Key 必须包含租户、授权范围和资源版本，避免跨租户缓存污染。

第三，网关层应设置请求体大小限制、Header 大小限制、超时、重试、熔断和过载保护。Envoy Circuit Breaking 用于限制上游集群的连接、请求、重试等资源，防止重试量膨胀导致级联故障[30]。网关重试应只作用于幂等请求或明确可重试的业务操作。

第四，接口层应避免无界查询和过大响应。列表接口应分页；批量接口应设置最大批量大小；响应应支持字段裁剪或拆分；大文件导出应异步化并返回任务资源，而不是在同步请求中长时间占用连接。

第五，后端层应将鉴权结果、租户配置、OpenAPI 契约元数据、限流规则和路由规则进行本地缓存，并设置明确的失效机制。对于 JWT，可缓存 JWKS；对于 opaque token，可根据 RFC 7662 Token Introspection 获取 Token 活跃状态和元信息，但需要结合缓存和过期时间控制请求开销[31]。

## 10 结论

基于官方标准文档，Open API 的标准设计方式可以归纳为：以 HTTPS + HTTP 语义作为协议基础，以 OpenAPI Specification 3.1.1 作为契约基线，以 JSON 和 JSON Schema 描述数据结构，以 OAuth 2.0、OpenID Connect、mTLS 或 DPoP 建立身份认证和授权体系，以租户、应用、用户、接口和成本单元构建限流配额模型，以 API Gateway 承接外部流量治理，以应用服务和领域服务实现前端入口与 Open API 的业务复用，以 OpenTelemetry、W3C Trace Context 和 Prometheus 建立可观测性，以 HTTP 缓存、HTTP/2、HTTP/3、网关保护、分页和异步化提升性能。

Open API 不是简单地把内部接口暴露出去，也不是前端接口的外部版本。它是以协议标准、契约标准、安全标准、治理标准和观测标准共同构成的开放接口体系。

[1] OpenAPI Specification v3.1.1 对 OAS 的定义：标准、语言无关的 HTTP API 描述格式。([OpenAPI Initiative Publications][1])
[2] OpenAPI Initiative 发布说明：3.1.1 是当时最新且推荐的新项目目标版本。([openapis.org][2])
[3] RFC 9110：HTTP Semantics，定义 HTTP 架构、术语、URI scheme、方法、状态码和通用语义。([datatracker.ietf.org][3])
[4] RFC 8259：JSON 是轻量级、文本型、语言无关的数据交换格式。([datatracker.ietf.org][4])
[5] OpenAPI 3.1 与 JSON Schema 2020-12 的关系。([openapis.org][5])
[6] RFC 9113 / RFC 9114：HTTP/2 与 HTTP/3 的标准定义。([datatracker.ietf.org][6])
[7] RFC 9110：HTTP 幂等方法定义。([rfc-editor.org][7])
[8] RFC 9457：Problem Details for HTTP APIs。([rfc-editor.org][8])
[9] OpenAPI Security：OAS 支持 API Key、HTTP Auth、mTLS、OAuth 2.0、OpenID Connect。([OpenAPI Documentation][9])
[10] RFC 8288：Web Linking 与 Link Header。([datatracker.ietf.org][10])
[11] OWASP REST Security Cheat Sheet：REST 服务应仅提供 HTTPS endpoint。([OWASP Cheat Sheet Series][11])
[12] RFC 6749：OAuth 2.0 Authorization Framework。([datatracker.ietf.org][12])
[13] RFC 6750：OAuth 2.0 Bearer Token Usage。([datatracker.ietf.org][13])
[14] OpenID Connect Core 1.0。([OpenID 基金会][14])
[15] RFC 8705 与 RFC 9449：OAuth 2.0 mTLS 与 DPoP。([datatracker.ietf.org][15])
[16] OWASP API Security Top 10：Broken Object Level Authorization。([OWASP基金会][16])
[17] RFC 6585：HTTP 429 Too Many Requests。([datatracker.ietf.org][17])
[18] IETF HTTPAPI RateLimit Header 草案。([datatracker.ietf.org][18])
[19] Envoy Global Rate Limiting 官方文档。([Envoy Proxy][19])
[20] Envoy HTTP Connection Manager 官方文档。([Envoy Proxy][20])
[21] Envoy HTTP Filters 官方文档。([Envoy Proxy][21])
[22] Envoy External Authorization Filter 官方文档。([Envoy Proxy][22])
[23] Envoy Local Rate Limit Filter 官方文档。([Envoy Proxy][23])
[24] Envoy Overload Manager 官方文档。([Envoy Proxy][24])
[25] OpenTelemetry 官方文档：厂商中立的 traces、metrics、logs 遥测框架。([OpenTelemetry][25])
[26] W3C Trace Context。([W3C][26])
[27] OpenTelemetry HTTP Semantic Conventions。([OpenTelemetry][27])
[28] Prometheus Metric Types。([Prometheus][28])
[29] RFC 9111：HTTP Caching。([rfc-editor.org][29])
[30] Envoy Circuit Breaking 官方文档。([Envoy Proxy][30])
[31] RFC 7662：OAuth 2.0 Token Introspection。([datatracker.ietf.org][31])

[1]: https://spec.openapis.org/oas/v3.1.1.html?utm_source=chatgpt.com "OpenAPI Specification v3.1.1"
[2]: https://www.openapis.org/blog/2024/10/25/announcing-openapi-specification-patch-releases?utm_source=chatgpt.com "Announcing OpenAPI Specification versions 3.0.4 and 3.1.1"
[3]: https://datatracker.ietf.org/doc/html/rfc9110?utm_source=chatgpt.com "RFC 9110 - HTTP Semantics"
[4]: https://datatracker.ietf.org/doc/html/rfc8259?utm_source=chatgpt.com "RFC 8259 - The JavaScript Object Notation (JSON) Data ..."
[5]: https://www.openapis.org/blog/2021/02/18/openapi-specification-3-1-released?utm_source=chatgpt.com "OpenAPI Specification 3.1.0 Released"
[6]: https://datatracker.ietf.org/doc/html/rfc9113?utm_source=chatgpt.com "RFC 9113 - HTTP/2"
[7]: https://www.rfc-editor.org/rfc/rfc9110.html?utm_source=chatgpt.com "RFC 9110: HTTP Semantics"
[8]: https://www.rfc-editor.org/info/rfc9457/?utm_source=chatgpt.com "RFC 9457: Problem Details for HTTP APIs"
[9]: https://learn.openapis.org/specification/security.html?utm_source=chatgpt.com "Describing API Security - OpenAPI Documentation"
[10]: https://datatracker.ietf.org/doc/html/rfc8288?utm_source=chatgpt.com "RFC 8288 - Web Linking"
[11]: https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html?utm_source=chatgpt.com "REST Security Cheat Sheet"
[12]: https://datatracker.ietf.org/doc/html/rfc6749?utm_source=chatgpt.com "RFC 6749 - The OAuth 2.0 Authorization Framework"
[13]: https://datatracker.ietf.org/doc/html/rfc6750?utm_source=chatgpt.com "RFC 6750 - The OAuth 2.0 Authorization Framework"
[14]: https://openid.net/specs/openid-connect-core-1_0.html?utm_source=chatgpt.com "OpenID Connect Core 1.0 incorporating errata set 2"
[15]: https://datatracker.ietf.org/doc/html/rfc8705?utm_source=chatgpt.com "RFC 8705 - OAuth 2.0 Mutual-TLS Client Authentication ..."
[16]: https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/?utm_source=chatgpt.com "API1:2023 Broken Object Level Authorization"
[17]: https://datatracker.ietf.org/doc/html/rfc6585?utm_source=chatgpt.com "RFC 6585 - Additional HTTP Status Codes"
[18]: https://datatracker.ietf.org/doc/html/draft-ietf-httpapi-ratelimit-headers?utm_source=chatgpt.com "draft-ietf-httpapi-ratelimit-headers-11"
[19]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_features/global_rate_limiting?utm_source=chatgpt.com "Global rate limiting"
[20]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/http/http_connection_management?utm_source=chatgpt.com "HTTP connection management"
[21]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/http/http_filters?utm_source=chatgpt.com "HTTP filters — envoy 1.39.0-dev-287f07 documentation"
[22]: https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter?utm_source=chatgpt.com "External Authorization"
[23]: https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/local_rate_limit_filter?utm_source=chatgpt.com "Local rate limit — envoy 1.39.0-dev-287f07 documentation"
[24]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/operations/overload_manager?utm_source=chatgpt.com "Overload manager"
[25]: https://opentelemetry.io/docs/?utm_source=chatgpt.com "Documentation"
[26]: https://www.w3.org/TR/trace-context/?utm_source=chatgpt.com "Trace Context"
[27]: https://opentelemetry.io/docs/specs/semconv/http/?utm_source=chatgpt.com "Semantic conventions for HTTP"
[28]: https://prometheus.io/docs/concepts/metric_types/?utm_source=chatgpt.com "Metric types"
[29]: https://www.rfc-editor.org/rfc/rfc9111.html?utm_source=chatgpt.com "RFC 9111: HTTP Caching"
[30]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/circuit_breaking?utm_source=chatgpt.com "Circuit breaking"
[31]: https://datatracker.ietf.org/doc/html/rfc7662?utm_source=chatgpt.com "RFC 7662 - OAuth 2.0 Token Introspection"
