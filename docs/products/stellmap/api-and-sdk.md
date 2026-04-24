---
title: Stellmap · 星图 · API 与 SDK
outline: deep
---

# API 与 SDK

> 注册中心，负责服务实例注册、健康检查、发现订阅与拓扑变更推送。

[返回产品首页](/products/stellmap/)

## 接口分层

- 提供 HTTP/gRPC 注册接口和 Java、Go 客户端

## SDK 说明

- 客户端统一暴露注册、发现、订阅和事件监听能力
- 建议在启动阶段完成预热订阅，减少首次调用冷启动抖动
