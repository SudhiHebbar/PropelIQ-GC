---
applyTo: "**/{spec.md,codeanalysis.md,design.md}"
description: "Architecture patterns guidance for spec, design, and code analysis artifacts"
---

# Architecture Patterns Authoring Instructions

Purpose: Ensure `spec.md`, `design.md`, and `codeanalysis.md` documents consistently apply vetted architecture patterns without duplicating broader guidance (performance, security, anti-patterns, redundancy rules).

## When Selecting a Pattern
- Start with problem drivers: domain volatility, team autonomy, scaling, latency, auditability.
- Choose smallest viable pattern (prefer Layered / Modular Monolith before Microservices).
- Justify pattern selection with 3 bullets: Context → Decision → Expected Benefit.
- Record trade-offs (latency, complexity, operational overhead) explicitly.

## Core Pattern Decision Matrix (Summarize, do NOT expand)
| Need | Prefer | Also Consider |
|------|--------|---------------|
| Simple CRUD, stable domain | Layered | Hexagonal if heavy test isolation needed |
| High testability / framework independence | Hexagonal | Layered + DI |
| Independent deploy & team scaling | Microservices | Modular Monolith (transition) |
| Real-time event flows | Event-Driven | Streaming / Reactive |
| Full audit & temporal queries | CQRS + Event Sourcing | Append-only ledger |
| Spiky / variable load | Serverless/FaaS | Container autoscaling |
| Frontend feature autonomy (UI + state + data hooks) | Vertical Slice (Frontend) | Modular Monolith or Microservices (later) |

## Mandatory Validation Sections per Artifact
- spec.md: Architecture Overview, Pattern Choice Rationale, Risk & Mitigation Table, NFR Mapping (Perf / Security / Reliability / Observability).
- design.md: Component & Boundary Diagram (textual if diagram tooling absent), Data Flow Steps, Failure Modes & Recovery, Evolution Notes (what scales first).
- codeanalysis.md: Detected Pattern(s), Boundary Violations (if any), Coupling Hotspots, Recommended Refactors (ranked by impact/effort).

## Boundary & Dependency Rules
- No lateral skips: presentation → domain/service → data/integration only.
- Each module declares responsibility in first doc mention; avoid cross-module leakage.
- Data ownership: one authoritative writer per data set (note if transitional sharing exists).
- External integration surfaces must have explicit retry/backoff/circuit policies documented.

## Event & Async Guidance (If Applicable)
- Events are immutable; version via additive changes; never mutate historical records.
- Handlers must be idempotent (state-safe replays). Document idempotency key strategy.
- Define at-least-once vs exactly-once expectations and compensating actions.

## Microservices Specific (Include ONLY if chosen)
- State the service boundary using ubiquitous language phrase.
- List owned data stores; deny cross-service table reads (API/Event only).
- Deployment independence test: "Can we release this service today without coordinating others?" (Yes/No, why).

## Hexagonal Specific (If chosen)
- List Ports (inbound/outbound) with one-line purpose; map each Adapter.
- Assert core domain has zero framework imports (note exceptions, justify).

## Vertical Slice (Frontend) Specific (If chosen)
- Scope: Frontend feature slices only (UI components + local state + data access hooks/adapters). Not a backend service boundary.
- Structure: `feature-name/` contains components, state (store/hooks), API client/adapters, tests, and feature-level styles.
- Isolation: Cross-slice imports limited to explicitly exported public API (e.g., `feature-name/index.ts`). No deep path drilling.
- Data Access: Prefer colocated query hooks (e.g., React Query/Zustand bindings) per slice; shared API client abstractions only after ≥2 identical patterns appear.
- Duplication Policy: Allow short-term duplication rather than premature shared libs (justify when extracting).
- Evolution: Promote to shared module ONLY when: (a) ≥3 slices use it, (b) API shape stable, (c) clear ownership assigned.
- Documentation Table (add to design/spec when using): Slice | Purpose | Key Components | State Mechanism | External Calls | Risks / Growth Triggers.
- Anti-Patterns: Global slice coupling via implicit singletons; cross-slice mutable state; leaking backend concerns (business rules) into presentation slice.

## CQRS + Event Sourcing (If chosen)
- Separate write model (commands/events) vs read model (projections) explicitly.
- Document projection latency expectations & read-model rebuild strategy.

## Quality Gates for Documents
- Pattern rationale < 12 lines (concise, outcome-focused).
- No unexplained acronyms; define on first use.
- Every risk has mitigation & detection method.
- No duplicated checklist items across sections (merge or reference).
- All non-functional requirements map to measurable metric (e.g., p95 latency < X ms).

## Common Anti-Patterns to Flag (Reference, don't restate)
- Distributed Monolith risk: synchronous chains across >3 services.
- Shared Database: multiple services writing same tables.
- Leaky Abstractions: domain layer referencing transport/persistence types.
- Chatty Interfaces: >3 sequential remote calls per user action.

## Output Style
- Use tables for risk, NFR, refactor priorities.
- Prefer bullet lists over prose walls.
- Link rather than duplicate existing decisions from earlier artifacts.

---