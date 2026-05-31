# Research on Standard Design Methods for Open APIs

## Abstract

An Open API is an application programming interface exposed to external systems, partners, developers, or cross-platform callers. Its standardized design includes not only an interface documentation format, but also transport protocols, resource modeling, authentication and authorization, rate limits and quotas, gateway hosting, business reuse, observability, and performance optimization. The OpenAPI Specification (OAS) defines a programming-language-independent interface description format for HTTP APIs, allowing callers to understand service capabilities without accessing source code or inspecting network traffic [1]. Based on official standards and documentation including OAS 3.1.1, HTTP Semantics, OAuth 2.0, OpenID Connect, W3C Trace Context, OpenTelemetry, Prometheus, and Envoy, this article summarizes standard design methods for Open APIs and proposes an implementation structure for large enterprise infrastructure platforms.

**Keywords**: Open API; OpenAPI Specification; HTTP API; OAuth 2.0; API Gateway; Rate Limit; Observability

## 1. Introduction

The core objective of an Open API is to expose system capabilities to external callers in a stable, understandable, and governable way. Compared with internal RPC or frontend-private APIs, Open API callers are less controllable, traffic sources are more complex, and change costs are higher. Therefore, unified constraints must be formed across the protocol layer, contract layer, security layer, and governance layer.

The OpenAPI Specification is not a new network transport protocol. It is a standard description format for HTTP APIs. The official OAS definition describes it as a standard, programming-language-independent HTTP API description used to describe service paths, operations, parameters, request bodies, responses, authentication methods, and extension information [1]. Therefore, the protocol foundation of an Open API should be HTTP/HTTPS, the interface contract should be described with the OpenAPI Specification, and new projects can use OAS 3.1.1 as the contract baseline. In its October 2024 release notes, the OpenAPI Initiative clearly stated that 3.1.1 was then the latest version and the recommended target version for new projects [2].

## 2. Protocol Foundation of Open APIs

### 2.1 Protocol Selection

Open APIs widely use HTTP/HTTPS as the application-layer protocol, and their interface form is usually REST-style HTTP APIs. HTTP Semantics RFC 9110 defines the overall architecture, core terminology, URI schemes, methods, status codes, fields, and general semantics of HTTP [3]. HTTP resource identification, request methods, response status codes, header fields, content negotiation, and caching mechanisms provide a common semantic foundation for open interfaces.

For data exchange, JSON is a common choice. RFC 8259 defines JSON as a lightweight, text-based, programming-language-independent data interchange format [4]. The Schema Object in OAS 3.1 aligns with JSON Schema 2020-12 and can express request and response data structures, field types, required properties, and constraints [5].

Therefore, the standard protocol combination for Open APIs can be expressed as follows: use TLS-protected HTTPS at the transport layer, HTTP semantics at the application layer, OpenAPI Specification 3.1.1 for interface contracts, JSON as the primary data format, and HTTP media types to explicitly describe complex binary scenarios.

### 2.2 HTTP Version Selection

HTTP semantics are separated from specific transport versions. RFC 9110 defines common HTTP semantics, while RFC 9112, RFC 9113, and RFC 9114 define HTTP/1.1, HTTP/2, and HTTP/3 wire formats respectively [3][6]. HTTP/2 supports multiplexing and field compression on the same connection, while HTTP/3 maps HTTP semantics onto QUIC transport [6]. Therefore, Open API interface semantics should not be bound to one specific HTTP transport version. When both gateway and client support it, HTTP/2 or HTTP/3 can be enabled at the edge gateway layer, while the interface contract continues to use HTTP methods, paths, status codes, headers, and bodies as standard semantic units.

## 3. Open API Interface Design Principles

### 3.1 Model Resources and Operation Semantics

One design goal of HTTP is to separate resource identification from request semantics. Request semantics are expressed by the method and certain request header fields [3]. Therefore, Open API paths should represent resource collections or resource instances, while operation semantics should be carried by HTTP methods. For example, `GET /orders/{orderId}` reads an order resource, `POST /orders` creates an order resource, `PUT /orders/{orderId}` replaces an order resource, and `DELETE /orders/{orderId}` deletes an order resource.

RFC 9110 defines safe methods and idempotent methods. GET, HEAD, OPTIONS, and TRACE are safe methods. PUT, DELETE, and safe methods are idempotent methods [7]. Therefore, interface design should align method semantics with business side effects: query interfaces should not produce business state changes; repeated PUT and DELETE requests should keep the same server-side state effect; and POST should be used for creation, submission, workflow triggering, and other non-idempotent business actions.

### 3.2 Use Standard Status Codes and Error Structures

Open APIs should not wrap all responses as HTTP 200 and then express success or failure through business fields. HTTP status codes themselves express protocol-layer results: 2xx indicates success, 3xx indicates redirection or cache-related results, 4xx indicates client request problems, and 5xx indicates server processing problems. For error responses, RFC 9457 defines the Problem Details format for HTTP APIs. It carries machine-readable error details and avoids every API defining incompatible error structures [8].

A standard error response can use the following structure:

```json
{
  "type": "https://api.example.com/problems/quota-exceeded",
  "title": "Quota exceeded",
  "status": 429,
  "detail": "The tenant has exceeded the configured quota.",
  "instance": "/requests/01HV..."
}
```

Here, `type` indicates the documentation address for the error type, `title` indicates an error summary, `status` corresponds to the HTTP status code, `detail` provides a concrete explanation, and `instance` identifies this particular error occurrence.

### 3.3 Use OpenAPI Contracts to Constrain Interfaces

OpenAPI documents should serve as the source of interface contracts. A contract should describe `servers`, `paths`, `operationId`, `parameters`, `requestBody`, `responses`, `components.schemas`, `components.securitySchemes`, and global or operation-level `security` configurations [1][9]. The `operationId` should be stable and unique because it is often used for SDK generation, gateway routing, monitoring dimensions, and audit positioning.

Request parameters should clearly distinguish path, query, header, and cookie parameters. Request bodies and response bodies should describe field structures through Schema Objects. Constraints such as enum values, length, format, numeric range, array length, and required fields should be included in the contract instead of existing only in explanatory documentation.

### 3.4 Versioning, Pagination, and Compatibility

When an Open API targets external callers, interface changes should follow compatibility constraints. Adding optional fields is usually compatible. Removing fields, changing field types, changing enum meanings, changing status code semantics, or changing authentication requirements usually counts as a breaking change. Versions can be expressed through path versions, header versions, or media type versions, but they must be explicitly declared in OpenAPI documentation.

Pagination interfaces should avoid returning unbounded collections at once. Pagination information can be expressed through query parameters such as `limit`, `cursor`, and `pageToken`, or combined with HTTP Link headers to express related resource links. RFC 8288 defines the Web Linking model and how links are serialized through the HTTP Link header [10].

## 4. Authentication and Authorization Design for Open APIs

### 4.1 Secure Transport

Open interfaces should use HTTPS. The OWASP REST Security Cheat Sheet clearly states that secure REST services must provide HTTPS endpoints only, to protect authentication credentials such as passwords, API keys, and JWTs during transport and to provide server authentication and data integrity protection for clients [11].

### 4.2 Authentication Protocols

OpenAPI supports five types of security schemes: API Key, HTTP Authentication, Mutual TLS, OAuth 2.0, and OpenID Connect [9]. OAuth 2.0 is the standard framework for open authorization. RFC 6749 defines OAuth 2.0 as a framework that enables third-party applications to obtain limited access to HTTP services under resource owner authorization or application self-authorization [12]. RFC 6750 defines how Bearer Tokens are used in HTTP requests to access OAuth 2.0 protected resources [13]. OpenID Connect Core 1.0 defines authentication capabilities and claims transfer on top of OAuth 2.0 [14].

Therefore, the authentication model of Open APIs can be divided into three categories.

First, service-to-service calls use OAuth 2.0 Client Credentials. The caller exchanges `client_id`, `client_secret`, private keys, or certificates for an Access Token. The gateway or resource service verifies the token signature, expiration time, issuer, audience, scope, and tenant information.

Second, user-agent calls use OAuth 2.0 Authorization Code Flow, combined with OpenID Connect when identity authentication is needed. Resource services use Access Tokens to determine access permissions, and use ID Tokens or UserInfo endpoints to identify user identity.

Third, high-security B2B APIs can add mTLS or DPoP on top of OAuth 2.0. RFC 8705 defines OAuth 2.0 mutual TLS client authentication and certificate-bound tokens. RFC 9449 defines DPoP, which uses an application-layer proof-of-possession mechanism to bind OAuth 2.0 tokens and reduce token replay risk [15].

### 4.3 Authorization Model

Authentication answers "who the caller is"; authorization answers "whether the caller can access this resource." Open API authorization should not stop at the interface level. It should include tenant-level, application-level, user-level, scope-level, and object-level authorization. OWASP API Security Top 10 2023 lists Broken Object Level Authorization as an API risk, where attackers can access unauthorized objects by tampering with object IDs in requests [16]. Therefore, resource services must validate object ownership, tenant boundaries, and operation permissions at the business layer.

A standard authorization context should include at least `tenant_id`, `client_id`, `user_id`, `subject`, `scopes`, `roles`, `resource_owner`, `operationId`, and `resource_id`. The gateway can perform token validation, preliminary scope screening, and tenant identification. The resource service must complete object-level and business-level authorization.

## 5. Rate Limit and Tenant Quota Design for Open APIs

### 5.1 Rate Limit Dimensions

Open API rate limiting should target multidimensional resource consumption, not only count by IP address. Basic dimensions include tenant, application, Access Token, user, interface operationId, HTTP method, route template, call source, region, cost unit, and time window. For multiple applications under the same tenant, the system should support tenant-wide quotas, application sub-quotas, and interface-level quotas.

A typical quota model is:

```text
tenant_quota = 10000 requests/minute
app_quota    = 2000 requests/minute
api_quota    = 500 requests/minute for POST /v1/orders
cost_quota   = 100000 cost-units/day
```

The cost unit can distinguish resource costs of different interfaces. For example, an ordinary query consumes 1 unit, a batch export consumes 100 units, and a complex computation API consumes 500 units.

### 5.2 Rate Limit Responses

When a caller exceeds the limit, HTTP should return 429 Too Many Requests. RFC 6585 defines 429 as indicating that the user has sent too many requests in a given amount of time, and notes that the response can include the Retry-After header to indicate how long to wait before retrying [17]. A rate limit response can include both Problem Details and rate-limit-related headers:

```http
HTTP/1.1 429 Too Many Requests
Content-Type: application/problem+json
Retry-After: 60
RateLimit: limit=2000, remaining=0, reset=60
RateLimit-Policy: 2000;w=60
```

The IETF HTTPAPI working group's RateLimit Header draft defines `RateLimit` and `RateLimit-Policy` fields to declare current limits and policies to clients, helping clients avoid triggering rate limits [18]. Because that document is still an Internet-Draft, production implementations need to define compatibility strategies and may also keep widely used fields such as `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and `X-RateLimit-Reset` for compatibility.

### 5.3 Tenant-Based Quotas

Tenant-based quotas should treat the tenant as the highest governance boundary. When a request enters, the gateway or rate limit service parses `tenant_id`, and then decides whether to allow the request based on the tenant plan, application identifier, API level, and current time window. Implementation can use a centralized global rate limit service, or a local token bucket with global quota synchronization. Envoy official documentation explains that Envoy supports global rate limiting: per-connection or per-HTTP-request checks, and quota-based rate limiting based on periodic load reports. The latter is suitable for large-scale Envoy deployments and high-RPS scenarios [19].

## 6. Gateway Design Behind Open APIs

The Open API gateway is the first governance entry point for external traffic entering an enterprise system. Its responsibilities include TLS termination, protocol upgrade, route matching, authentication and authorization, rate limiting, request size limits, header normalization, CORS, canary routing, circuit breaking, timeout, retry, access logging, metrics collection, and trace propagation.

Taking Envoy as an example, HTTP Connection Manager transforms raw bytes into HTTP-level messages and events, and provides routing, header processing, access logging, and HTTP filter chain capabilities [20]. Envoy HTTP Filters can process HTTP messages in the connection manager without needing to care whether the underlying physical protocol is HTTP/1.1, HTTP/2, or another multiplexed protocol [21]. Therefore, gateways should put common cross-cutting capabilities into the filter chain and leave business logic in backend services.

A standard gateway path can be designed as:

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

Envoy External Authorization Filter can delegate authorization decisions to an external service [22]. Envoy Local Rate Limit Filter can apply token bucket rate limiting at the route or virtual host level [23]. Envoy Overload Manager protects Envoy instances from overload based on resources such as memory, CPU, and file descriptors [24]. Therefore, the gateway layer should carry protocol and governance responsibilities, but should not carry core business rules.

## 7. Business Logic Reuse Between Open APIs and Frontend Entrypoints

Open APIs and frontend entrypoints may process the same business capabilities, but they serve different client types. Frontend entrypoints usually serve browser or app pages, and their interface shape can be organized around page display aggregation. Open APIs serve external systems, and their interface shape should be modeled around stable resources, permission boundaries, and contract compatibility. Therefore, reuse should not happen at the controller layer or DTO layer. It should happen at the application service layer and domain service layer.

The standard structure is:

```text
Frontend Controller / BFF
        \
         -> Application Service -> Domain Service -> Repository / Client
        /
Open API Controller / Open API Adapter
```

The Frontend Controller can return page-friendly View DTOs, while the Open API Adapter returns public contract DTOs. Both entrypoint types share application services and domain services, but separately maintain request validation, permission context transformation, DTO conversion, error code mapping, and audit strategies. This avoids leaking frontend-private fields into Open APIs, and also avoids Open API compatibility requirements constraining rapid frontend iteration.

In large enterprises, Open API contract DTOs should be isolated from internal domain models. Changes in domain models should not directly cause changes in Open API response structures. Deprecation of Open API DTOs should be handled through version strategies, field `deprecated` markers, and migration windows.

## 8. Instrumentation Design for Open APIs

Open API instrumentation should cover three types of telemetry data: logs, metrics, and distributed traces. OpenTelemetry defines itself as a vendor-neutral open source observability framework for generating, collecting, and exporting telemetry data such as traces, metrics, and logs [25]. W3C Trace Context defines the `traceparent` and `tracestate` headers for propagating tracing context in distributed systems [26]. OpenTelemetry HTTP Semantic Conventions define semantic conventions for HTTP spans, metrics, and logs, and can be used for HTTP/HTTPS as well as versions such as HTTP/1.1 and HTTP/2 [27].

### 8.1 Log Fields

Access logs should record the following fields: `timestamp`, `trace_id`, `span_id`, `request_id`, `tenant_id`, `client_id`, `user_id`, `operation_id`, `method`, `route_template`, `path`, `status_code`, `error_type`, `latency_ms`, `request_bytes`, `response_bytes`, `upstream_service`, `upstream_status`, `auth_result`, `rate_limit_result`, `quota_policy`, `source_ip`, and `user_agent`.

The `route_template` should record the template path, such as `/v1/orders/{orderId}`, to avoid writing real IDs into high-cardinality labels. Sensitive fields such as tokens, secrets, phone numbers, identity document numbers, and bank card numbers must not enter plaintext logs.

### 8.2 Metric Fields

Prometheus defines metric types such as Counter, Gauge, Histogram, and Summary. Histogram records observed value distributions with buckets and provides sum and count [28]. Open API metrics can include:

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

Metric label cardinality must be controlled. Fields such as `user_id`, `order_id`, full URL, and detailed error text should not be used as labels.

### 8.3 Trace Design

After receiving a request, the gateway should read or generate `traceparent` and propagate it to backend services. Trace spans should cover gateway processing, authentication services, rate limit services, backend application services, database access, and external dependency calls. Span attributes should include HTTP method, route, status_code, tenant_id, client_id, operationId, and rate limit decision result. Sampling strategies can be configured at the gateway layer. Error requests, slow requests, and rate-limited requests can receive higher sampling priority.

## 9. Open API Performance Optimization

Open API performance optimization should cover the protocol, cache, gateway, backend service, and data access layers.

First, HTTP/2 or HTTP/3 can be enabled at the protocol layer. HTTP/2 improves network resource utilization and reduces latency through field compression and multiple concurrent exchanges on the same connection [6]. HTTP/3 maps HTTP semantics to QUIC and uses QUIC stream multiplexing, flow control, and low-latency connection establishment [6].

Second, the cache layer should use HTTP cache semantics. RFC 9111 defines HTTP caches and header fields that control cache behavior or identify cacheable responses [29]. Cacheable GET APIs should use `Cache-Control`, `ETag`, `Last-Modified`, `If-None-Match`, `If-Modified-Since`, and 304 Not Modified. For tenant-isolated data, cache keys must include tenant, authorization scope, and resource version to avoid cross-tenant cache contamination.

Third, the gateway layer should set request body size limits, header size limits, timeouts, retries, circuit breaking, and overload protection. Envoy Circuit Breaking limits upstream cluster resources such as connections, requests, and retries, preventing retry amplification from causing cascading failures [30]. Gateway retries should apply only to idempotent requests or business operations that are explicitly retryable.

Fourth, the interface layer should avoid unbounded queries and oversized responses. List APIs should be paginated. Batch APIs should set maximum batch size. Responses should support field trimming or splitting. Large file exports should be asynchronous and return task resources instead of occupying connections for a long time in synchronous requests.

Fifth, the backend layer should locally cache authentication results, tenant configuration, OpenAPI contract metadata, rate limit rules, and routing rules, with explicit invalidation mechanisms. For JWT, JWKS can be cached. For opaque tokens, RFC 7662 Token Introspection can be used to obtain token activity status and metadata, but request overhead must be controlled with caching and expiration time [31].

## 10. Conclusion

Based on official standards documents, standard Open API design can be summarized as follows: use HTTPS plus HTTP semantics as the protocol foundation; use OpenAPI Specification 3.1.1 as the contract baseline; use JSON and JSON Schema to describe data structures; use OAuth 2.0, OpenID Connect, mTLS, or DPoP to build authentication and authorization systems; build rate limit and quota models based on tenant, application, user, interface, and cost unit; use API Gateway to govern external traffic; use application services and domain services to reuse business logic between frontend entrypoints and Open APIs; establish observability with OpenTelemetry, W3C Trace Context, and Prometheus; and improve performance with HTTP caching, HTTP/2, HTTP/3, gateway protection, pagination, and asynchronous processing.

An Open API is not simply an internal interface exposed externally, nor is it an external version of a frontend API. It is an open interface system jointly formed by protocol standards, contract standards, security standards, governance standards, and observability standards.

[1] OpenAPI Specification v3.1.1 defines OAS as a standard, language-independent HTTP API description format. ([OpenAPI Initiative Publications][1])
[2] OpenAPI Initiative release notes: 3.1.1 was then the latest version and the recommended target version for new projects. ([openapis.org][2])
[3] RFC 9110: HTTP Semantics, defining HTTP architecture, terminology, URI schemes, methods, status codes, and general semantics. ([datatracker.ietf.org][3])
[4] RFC 8259: JSON is a lightweight, text-based, language-independent data interchange format. ([datatracker.ietf.org][4])
[5] Relationship between OpenAPI 3.1 and JSON Schema 2020-12. ([openapis.org][5])
[6] RFC 9113 / RFC 9114: standard definitions of HTTP/2 and HTTP/3. ([datatracker.ietf.org][6])
[7] RFC 9110: definition of HTTP idempotent methods. ([rfc-editor.org][7])
[8] RFC 9457: Problem Details for HTTP APIs. ([rfc-editor.org][8])
[9] OpenAPI Security: OAS supports API Key, HTTP Auth, mTLS, OAuth 2.0, and OpenID Connect. ([OpenAPI Documentation][9])
[10] RFC 8288: Web Linking and Link Header. ([datatracker.ietf.org][10])
[11] OWASP REST Security Cheat Sheet: REST services should provide HTTPS endpoints only. ([OWASP Cheat Sheet Series][11])
[12] RFC 6749: OAuth 2.0 Authorization Framework. ([datatracker.ietf.org][12])
[13] RFC 6750: OAuth 2.0 Bearer Token Usage. ([datatracker.ietf.org][13])
[14] OpenID Connect Core 1.0. ([OpenID Foundation][14])
[15] RFC 8705 and RFC 9449: OAuth 2.0 mTLS and DPoP. ([datatracker.ietf.org][15])
[16] OWASP API Security Top 10: Broken Object Level Authorization. ([OWASP Foundation][16])
[17] RFC 6585: HTTP 429 Too Many Requests. ([datatracker.ietf.org][17])
[18] IETF HTTPAPI RateLimit Header draft. ([datatracker.ietf.org][18])
[19] Envoy Global Rate Limiting official documentation. ([Envoy Proxy][19])
[20] Envoy HTTP Connection Manager official documentation. ([Envoy Proxy][20])
[21] Envoy HTTP Filters official documentation. ([Envoy Proxy][21])
[22] Envoy External Authorization Filter official documentation. ([Envoy Proxy][22])
[23] Envoy Local Rate Limit Filter official documentation. ([Envoy Proxy][23])
[24] Envoy Overload Manager official documentation. ([Envoy Proxy][24])
[25] OpenTelemetry official documentation: a vendor-neutral telemetry framework for traces, metrics, and logs. ([OpenTelemetry][25])
[26] W3C Trace Context. ([W3C][26])
[27] OpenTelemetry HTTP Semantic Conventions. ([OpenTelemetry][27])
[28] Prometheus Metric Types. ([Prometheus][28])
[29] RFC 9111: HTTP Caching. ([rfc-editor.org][29])
[30] Envoy Circuit Breaking official documentation. ([Envoy Proxy][30])
[31] RFC 7662: OAuth 2.0 Token Introspection. ([datatracker.ietf.org][31])

[1]: https://spec.openapis.org/oas/v3.1.1.html "OpenAPI Specification v3.1.1"
[2]: https://www.openapis.org/blog/2024/10/25/announcing-openapi-specification-patch-releases "Announcing OpenAPI Specification versions 3.0.4 and 3.1.1"
[3]: https://datatracker.ietf.org/doc/html/rfc9110 "RFC 9110 - HTTP Semantics"
[4]: https://datatracker.ietf.org/doc/html/rfc8259 "RFC 8259 - The JavaScript Object Notation (JSON) Data Interchange Format"
[5]: https://www.openapis.org/blog/2021/02/18/openapi-specification-3-1-released "OpenAPI Specification 3.1.0 Released"
[6]: https://datatracker.ietf.org/doc/html/rfc9113 "RFC 9113 - HTTP/2"
[7]: https://www.rfc-editor.org/rfc/rfc9110.html "RFC 9110: HTTP Semantics"
[8]: https://www.rfc-editor.org/info/rfc9457/ "RFC 9457: Problem Details for HTTP APIs"
[9]: https://learn.openapis.org/specification/security.html "Describing API Security - OpenAPI Documentation"
[10]: https://datatracker.ietf.org/doc/html/rfc8288 "RFC 8288 - Web Linking"
[11]: https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html "REST Security Cheat Sheet"
[12]: https://datatracker.ietf.org/doc/html/rfc6749 "RFC 6749 - The OAuth 2.0 Authorization Framework"
[13]: https://datatracker.ietf.org/doc/html/rfc6750 "RFC 6750 - The OAuth 2.0 Authorization Framework"
[14]: https://openid.net/specs/openid-connect-core-1_0.html "OpenID Connect Core 1.0"
[15]: https://datatracker.ietf.org/doc/html/rfc8705 "RFC 8705 - OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens"
[16]: https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/ "API1:2023 Broken Object Level Authorization"
[17]: https://datatracker.ietf.org/doc/html/rfc6585 "RFC 6585 - Additional HTTP Status Codes"
[18]: https://datatracker.ietf.org/doc/html/draft-ietf-httpapi-ratelimit-headers "RateLimit Header Fields for HTTP"
[19]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_features/global_rate_limiting "Global rate limiting"
[20]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/http/http_connection_management "HTTP connection management"
[21]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/http/http_filters "HTTP filters"
[22]: https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter "External Authorization"
[23]: https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/local_rate_limit_filter "Local rate limit"
[24]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/operations/overload_manager "Overload manager"
[25]: https://opentelemetry.io/docs/ "Documentation"
[26]: https://www.w3.org/TR/trace-context/ "Trace Context"
[27]: https://opentelemetry.io/docs/specs/semconv/http/ "Semantic conventions for HTTP"
[28]: https://prometheus.io/docs/concepts/metric_types/ "Metric types"
[29]: https://www.rfc-editor.org/rfc/rfc9111.html "RFC 9111: HTTP Caching"
[30]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/circuit_breaking "Circuit breaking"
[31]: https://datatracker.ietf.org/doc/html/rfc7662 "RFC 7662 - OAuth 2.0 Token Introspection"
