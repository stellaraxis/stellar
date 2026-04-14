# Architecture Decision Record

## 1. Problem Analysis

The system already has clear naming, layout, and dependency decisions, but those decisions previously mixed multiple semantic systems. Without a single decision record, the team may drift back to legacy aliases, inconsistent repository structures, or invalid dependencies.

This document consolidates the architecture decisions that define the current form of the system.

It serves as the authoritative summary of:

- brand decisions
- naming decisions
- repository structure decisions
- dependency boundary decisions

Related documents:

- [Proposal.md](./Proposal.md)
- [Naming-Convention.md](./Naming-Convention.md)
- [Repo-Layout.md](./Repo-Layout.md)
- [Module-Dependency.md](./Module-Dependency.md)

## 2. Design

This ADR follows four decision groups:

- ADR-001: Global brand
- ADR-002: Product naming
- ADR-003: Repository topology
- ADR-004: Dependency boundaries

Each decision includes:

- context
- decision
- consequence

## 3. Implementation

### ADR-001: Global Brand

#### Context

The project previously mixed multiple top-level expressions and symbolic systems. That created ambiguity across documentation, repository names, and future ecosystem growth.

#### Decision

The official global brand is fixed as:

- English: `Stellar Axis`
- Chinese: `星轴`
- first combined presentation: `Stellar Axis（星轴）`

The brand model is now purely cosmic and no longer carries parallel philosophical aliases.

#### Consequence

- English-facing documents, repository namespaces, and coordinates use `Stellar Axis`
- Chinese-facing materials use `星轴`
- legacy symbolic naming is removed from the documentation baseline

### ADR-002: Core Product Naming

#### Context

The system needs names that work both as technical products and as part of a coherent brand grammar.

#### Decision

Every core infrastructure product uses:

> `English product name + Chinese cosmic name`

Final component set:

| Domain | English Name | Chinese Name |
| :--- | :--- | :--- |
| Registry | `StarMap` | `星图` |
| Config | `Nebula` | `星云` |
| Tracing | `StarTrace` | `星迹` |
| Governance | `Orbit` | `星轨` |
| Limiter | `Pulsar` | `脉冲` |
| Scheduler | `Astrolabe` | `星盘` |
| Locking | `Singularity` | `奇点` |
| Gateway | `EventHorizon` | `视界` |
| Messaging | `CometFlow` | `彗流` |

The AI extension layer is defined separately:

| English Name | Chinese Name |
| :--- | :--- |
| `Astral Layer` | `星穹层` |
| `Quasar Engine` | `类星引擎` |
| `StarVault Memory` | `星库` |
| `Orbit Agent` | `轨使` |
| `Sensor MCP` | `星感` |
| `Vector MCP` | `星行` |
| `GuideStar MCP` | `导星` |

#### Consequence

- documentation and product cards use the dual cosmic naming convention
- repositories and engineering modules use English engineering names only
- non-cosmic legacy aliases are not part of the active naming system

### ADR-003: Repository Topology

#### Context

Without a stable repository topology, different products will evolve incompatible structures and ownership boundaries.

#### Decision

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

Each product repository follows the same skeleton:

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

Conditional modules are created only when needed:

- `starters/`
- `sidecars/`
- `operators/`
- `examples/`

#### Consequence

- each core product remains independently evolvable
- Java and Go have stable aggregate entry points
- platform and runtime concerns remain separated

### ADR-004: Dependency Boundaries

#### Context

Repository separation alone is not enough. Clear dependency rules are required to prevent architectural erosion.

#### Decision

The system uses strict one-way dependency rules.

Allowed dependency principles:

- depend on public APIs, SDKs, and stable contracts
- use events, public clients, and control-plane APIs for cross-product collaboration
- keep internal implementation private

Forbidden dependency principles:

- `starter -> server`
- `client -> server`
- `operator -> server`
- `control-plane -> product/internal`
- `productA/server -> productB/server`
- `examples -> product/internal`

Repository-level rules:

- `stellar-axis` has no runtime code dependencies
- `stellar-core` and `stellar-pulse` depend on public contracts only
- product repositories may depend on their own `api/` and shared runtime abstractions
- the control plane depends on public management surfaces, not internal implementations

#### Consequence

- internal implementation details remain encapsulated
- products can evolve independently
- cross-product integration remains contract-driven
- future splitting, replacement, or versioning becomes manageable

## 4. Complete Code

The current architecture is defined by the following fixed decisions:

~~~md
# Architecture Decision Record

## Fixed decisions

1. The only official global brand is `Stellar Axis（星轴）`.
2. Core products use `English product name + Chinese cosmic name`.
3. Repositories, modules, and dependency coordinates use English engineering names only.
4. The repository model is split into aggregate repositories, core product repositories, and supporting repositories.
5. Cross-product collaboration must happen through public APIs, SDKs, events, or control-plane interfaces.
6. Direct dependencies on internal implementation are forbidden across repository boundaries.
~~~
