# Stellar Axis

`Stellar Axis` is a self-developed microservice middleware system. Its official Chinese brand name is `星轴`. The entire system now uses a pure cosmic naming model: the global brand is built around the axis metaphor, core products use names such as `StarMap`, `Nebula`, `Orbit`, and `EventHorizon`, and the AI extension is grouped under `Astral Layer`.

This repository currently focuses on four areas:

- overall brand and system positioning
- component naming and role mapping
- repository layout and module boundaries
- dependency constraints and architecture decisions

## Positioning

Stellar Axis is not a loose collection of unrelated middleware pieces. It is a unified system with consistent naming, repository layout, and dependency boundaries.

The system follows these rules:

- `Stellar Axis` is the only official global English brand
- core components are presented as `English product name + Chinese cosmic name`
- repositories, modules, packages, and coordinates use English engineering names only
- cross-product collaboration happens through APIs, SDKs, events, and the control plane

Dual-stack positioning:

- Java framework: `Stellar Core`
- Go framework: `Stellar Pulse`

## Core Component Matrix

| Domain | English Full Name / Chinese Full Name | Short Name | Responsibility |
| :--- | :--- | :--- | :--- |
| Service discovery | `StarMap / 星图` | `星图` | service metadata, instance discovery, registration |
| Config center | `Nebula / 星云` | `星云` | dynamic configuration and environment distribution |
| Tracing | `StarTrace / 星迹` | `星迹` | tracing, observability, request path reconstruction |
| Governance | `Orbit / 星轨` | `星轨` | routing, traffic governance, rollout control |
| Limiting and circuit breaking | `Pulsar / 脉冲` | `脉冲` | rate limiting, circuit breaking, overload protection |
| Distributed scheduling | `Astrolabe / 星盘` | `星盘` | scheduling, cadence control, job orchestration |
| Distributed locking | `Singularity / 奇点` | `奇点` | exclusivity and concurrency control |
| Gateway | `EventHorizon / 视界` | `视界` | ingress, boundary traffic, protocol aggregation |
| Messaging and event flow | `CometFlow / 彗流` | `彗流` | messaging, event streaming, asynchronous decoupling |

Recommended presentation style:

- `StarMap · 星图`
- `Nebula · 星云`
- `Orbit · 星轨`
- `CometFlow · 彗流`

## Naming Rationale for Core Components

The naming system no longer relies on regional philosophy or legacy symbolic aliases. Every product name is derived directly from cosmic structures, motion, light, time-space boundaries, or observable celestial patterns.

### StarMap · 星图

- `StarMap` refers to a celestial map or coordinate chart. A service registry is effectively the coordinate system of the platform, allowing services to locate and discover one another.
- `星图` is a direct Chinese mirror of the same concept, keeping the brand model simple and consistent.

### Nebula · 星云

- `Nebula` evokes a carrier field that holds matter and gives rise to structure. That aligns with a config center, which carries environment state and shapes runtime behavior.
- `星云` stays close to the English name and avoids introducing an unrelated symbolic layer.

### StarTrace · 星迹

- `StarTrace` highlights the act of leaving a visible trajectory. Distributed tracing exists to make invisible call paths visible across the system.
- `星迹` conveys path visibility, historical replay, and causal reconstruction.

### Orbit · 星轨

- `Orbit` expresses governed movement along an established path. That directly fits routing, policy-driven traffic shaping, and service governance.
- `星轨` makes the same idea explicit in Chinese: a path that is stable, guided, and observable.

### Pulsar · 脉冲

- `Pulsar` suggests stable cadence and precise periodic control. That maps well to quotas, thresholds, and controlled frequency in rate limiting and circuit breaking.
- `脉冲` keeps the meaning compact and operational.

### Astrolabe · 星盘

- `Astrolabe` refers to a celestial instrument used for position and time-related calculation. That makes it a natural fit for scheduling and orchestration.
- `星盘` captures timing, calibration, and navigation in a single image.

### Singularity · 奇点

- `Singularity` captures the idea of collapsing many concurrent contenders into one exclusive control point.
- `奇点` preserves the same sense of convergence and unique arbitration.

### EventHorizon · 视界

- `EventHorizon` represents a boundary surface between inside and outside. A gateway is exactly that boundary for ingress traffic.
- `视界` expresses boundary, threshold, and formal ingress in a concise way.

### CometFlow · 彗流

- `CometFlow` emphasizes fast movement across space with a clear visible trail. That is a strong metaphor for messages, events, and asynchronous flow.
- `彗流` keeps the product rooted in the same cosmic language as the rest of the system.

## AI Extension Layer

Beyond the core governance products, the system defines an independent AI-native extension layer:

| English Name | Chinese Name | Responsibility |
| :--- | :--- | :--- |
| `Astral Layer` | `星穹层` | overall AI capability layer |
| `Quasar Engine` | `类星引擎` | reasoning and model understanding |
| `StarVault Memory` | `星库` | memory and knowledge accumulation |
| `Orbit Agent` | `轨使` | agent orchestration and autonomous execution |
| `Sensor MCP` | `星感` | context perception protocol |
| `Vector MCP` | `星行` | tool execution protocol |
| `GuideStar MCP` | `导星` | prompt guidance protocol |

The AI layer is defined as a separate cognitive layer above the governance stack, using the same cosmic naming grammar.

## Engineering Naming Rules

The following names are fixed:

- global brand: `Stellar Axis`
- Java aggregate repository: `stellar-core`
- Go aggregate repository: `stellar-pulse`
- AI aggregate repository: `astral-layer`
- control plane: `stellar-control-plane`
- CLI: `stellarctl`
- coordinate namespace: `io.stellar.axis`

Legacy names built from mixed symbolic systems are removed from the documentation baseline.

## Repository Layout

The system uses a three-level repository model.

Top-level aggregate repositories:

- `stellar-axis`
- `stellar-core`
- `stellar-pulse`
- `astral-layer`
- `stellar-control-plane`
- `stellarctl`
- `stellar-examples`
- `stellar-deploy`

Core product repositories:

- `starmap`
- `nebula`
- `startrace`
- `orbit`
- `pulsar`
- `astrolabe`
- `singularity`
- `event-horizon`
- `comet-flow`

Unified product repository skeleton:

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

## Dependency Rules

The system uses strict one-way dependency rules.

Allowed patterns:

- depend on public APIs, SDKs, and stable protocols
- use the control plane, event flow, or official clients for cross-product collaboration
- `starter` depends on `clients/api`
- `sidecar` depends on `clients/api/runtime`
- `operator` depends on `api` and Kubernetes runtime

Forbidden patterns:

- `starter -> server`
- `client -> server`
- `operator -> server`
- `control-plane -> product/internal`
- `productA/server -> productB/server`
- `examples -> product/internal`

## Documentation

- [Naming Proposal](./Proposal.md)
- [Naming Convention](./Naming-Convention.md)
- [Repository Layout](./Repo-Layout.md)
- [Module Dependency](./Module-Dependency.md)
- [Architecture Decision Record](./Architecture-Decision-Record.md)

## Motto

> Align with the axis, discover through the map, coordinate on the orbit, and guard the boundary at the horizon.

## License

Apache License 2.0
