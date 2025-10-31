---
applyTo: "**/*.{cs,csproj,fs,fsproj,go,py,rb,java,kt,ts,js,yml,yaml,json,Dockerfile}"
description: "Backend engineering advanced guidance: service design, resilience, data boundaries, observability, and operational readiness. Excludes duplication of security, performance, anti-pattern, and language-specific rules covered elsewhere."
---

## Scope & Intent
This file augments existing security, performance, anti-pattern, .NET, and language/stack instructions. It focuses on higher-level backend system design & operational excellence: correctness under failure, evolvability, data integrity, observability, and production readiness.

## Architectural Cohesion & Module Boundaries
- Explicit Bounded Contexts: Each service / module must own its ubiquitous language; no leaking foreign aggregates.
- Public Surface Minimalism: Expose only stable contracts (DTOs, events). Internal helpers remain internal.
- Directional Dependencies: In multi-project solutions, domain core has zero outward dependencies on infrastructure frameworks.
- Change Isolation: A single business rule change should affect at most one module + its tests.

## API & Contract Governance
- Contract-First: Define schemas (OpenAPI / JSON Schema / Protobuf) before implementation for new externally consumed endpoints.
- Backward Compatibility: Additive changes preferred; breaking changes require explicit versioning strategy + deprecation timeline artifact.
- Idempotency: Mutating endpoints that can receive retries (network/intermediate failures) must implement idempotency keys or natural idempotence.
- Pagination & Retrieval: Enforce cursor-based pagination for unbounded collections; offset pagination allowed only for small, static sets.
- Consistent Error Envelope: Standard shape (traceId, code, message, details[], timestamp) – no raw framework stack leaks.

## Data Ownership & Persistence Discipline
- Single Source of Truth: A record is authoritatively stored in exactly one service-owned datastore.
- Avoid Shared Database: Never couple services by reading each other's tables; use published events or APIs.
- Write Model vs Read Model: Introduce projection/read store only when justified by a measured query bottleneck or latency/shape mismatch.
- Referential Integrity Strategy: Enforce at database level within a bounded context; cross-context links use immutable foreign identifiers only.
- Migration Safety: All schema migrations are forward-compatible (expand → deploy code using both → contract old fields later). No destructive changes inline with deploy.

## Transaction & Consistency Strategy
- Prefer Local ACID transactions within a single service boundary.
- Use Outbox Pattern for cross-service reliable event publishing (transactionally persist event + relay asynchronously).
- Eventual Consistency Transparency: Document eventual states and client-facing interim representations (e.g., STATUS=PENDING until compensation completes).
- Idempotent Consumers: Event handlers must tolerate duplicate deliveries (natural keys, processed-event ledger, or upsert semantics).

## Caching & State Management
- Cache Taxonomy: Specify purpose per cache (response, domain aggregate, computation) with explicit invalidation rules.
- Staleness Budget: Define max tolerated age (TTL) per cache entry type. Do not default to arbitrary long TTLs.
- Negative Caching: Short-lived negative caching for repeated miss amplification (e.g., 15–60s) to reduce DB hot spots.
- Invalidation First: Design invalidation path before adding a cache layer.

## Resilience & Fault Handling
- Timeouts Everywhere: All outbound calls MUST specify explicit timeout < consumer SLA headroom.
- Circuit Breakers: Apply to dependency classes with failure burst risk; log open/half-open transitions.
- Bulkheads: Isolate thread/async pools for high-latency or 3rd-party calls to prevent resource exhaustion.
- Retries With Jitter: Exponential backoff + jitter; retry only safe (idempotent) operations.
- Dead Letter Strategy: Undeliverable messages/events captured with actionable metadata (attempt count, last error) and monitored.

## Observability & Diagnostics
- Correlation: Propagate trace/span IDs through logs, metrics, and events; create new root only when genuinely external origin unknown.
- Structured Logging: Key fields: traceId, spanId, userId (if authenticated), tenantId (if multi-tenant), cause, latencyMs, outcome.
- Cardinality Control: Avoid unbounded label values in metrics (e.g., raw user IDs). Bucket or hash where needed.
- Golden Signals: Expose RED metrics (Rate, Errors, Duration) per critical endpoint / queue consumer.
- App Health Model: Liveness = process viability; Readiness = dependency set reachable; Startup probe for heavy warm-up phases.

## Background Jobs & Async Processing
- Explicit SLA vs SLO: Define latency SLO for job classes (e.g., transactional email < 1m, nightly rollup < 15m drift tolerance).
- Exactly-Once Illusion: Accept at-least-once semantics; design deduplication instead of attempting global locks.
- Work Partitioning: Use deterministic sharding keys to prevent hotspot workers.
- Visibility Timeout Alignment: Queue visibility timeout > worst-case processing time + safety buffer; extend proactively if nearing expiry.

## Domain Integrity & Validation
- Layered Validation: Transport (syntax) → Application (commands shape) → Domain (invariants) – never conflate responsibilities.
- Fail Fast Inside Domain: Throw domain-specific errors early; translate to API error envelope at boundary.
- Immutable Events: Once published, event contracts are append-only; new fields optional with defaults.

## Performance-Adjacent (Non-Duplicate)
- Hot Path Awareness: Annotate functions that are latency critical; avoid allocating transient large objects within them.
- Load Shedding: Prefer to return graceful overload responses (e.g., 429 or queue defer) rather than cascading failures.
- Streaming Interfaces: For large result sets, employ streaming (IAsyncEnumerable / chunked transfer) instead of materializing full collections.

## Deployment & Operational Readiness
- Config Immutability: Runtime config changes via environment / parameter store, never code redeploy for tuning.
- Safe Feature Delivery: Feature flags (short-lived) for risky changes; remove stale flags proactively.
- Blue/Green or Rolling: Choose strategy; database migrations aligned (expand/contract pattern) – never deploy code that requires a future migration.
- Disaster Recovery: Define RPO/RTO targets; test backup restore pipelines (no "assumed" success).
- Secrets Rotation: Automate rotation cadence; ensure dependent pods/workers reload without restart when possible.

## Testing Strategy Elevation (Beyond Basics)
- Contract Tests: Validate provider vs consumer expectations (schema + semantic behaviors).
- Deterministic Seeds: All randomness seeded per test run for reproducibility.
- Synthetic Load Smoke: Lightweight performance smoke in CI for top 5 business paths to catch gross regressions early.
- Failure Injection: Chaos tests (dependency latency, error rates) in non-prod environments with rollback metrics gating.

## Event & Message Design
- Event Name Semantics: Past-tense facts (OrderPlaced), not commands.
- Minimal Payload: Only include fields necessary for consumers; avoid leaking internal invariants.
- Versioning: Add `eventVersion`; consumers treat unknown fields as optional.
- Ordering Guarantees: Document whether ordering is guaranteed; if not, design consumers tolerant to reordering.

## Multi-Tenancy Considerations
- Tenant Boundary Enforcement: Always scope queries by tenant identifier at the data access layer; enforce row-level security where supported.
- Resource Quotas: Track and enforce per-tenant quotas (storage, request rate) to prevent noisy-neighbor issues.
- Data Isolation Strategy: Chosen pattern (shared DB, schema per tenant, DB per tenant) documented with trade-offs.

## Observability Runbook Hooks
- Each critical alert links to a runbook: expected cause spectrum, immediate triage steps, escalation matrix.
- Error Budgets: Track SLO error budget burn; feature rollout pauses when burn rate threshold exceeded.

## Quality & Sustainability Checklist
Before merging backend-affecting change ensure:
- [ ] Contracts (API/event) backward compatible or versioned.
- [ ] Idempotency for externally retryable operations.
- [ ] All new outbound calls have explicit timeout & retry policy (or rationale for omission).
- [ ] Structured log fields present for new code paths.
- [ ] Domain invariants enforced at correct layer (not only in controller/service).
- [ ] Caching additions have defined invalidation & staleness policy.
- [ ] Migrations adhere to expand → coexist → contract flow.
- [ ] Secrets/config read from environment or secret store.
- [ ] Added tests include at least one failure path.
- [ ] Performance-sensitive code paths documented (if any).
- [ ] Runbook / SLO updated when introducing/reclassifying critical dependency.

## Terminology (Focused)
- Bounded Context: Autonomous linguistic + model boundary with its own domain rules.
- Outbox Pattern: Local transactional table storing events for later dispatch guaranteeing atomicity.
- Idempotency Key: Client-supplied unique token ensuring retried mutation executes once logically.
- Backpressure: Mechanism to slow producers to match consumer capacity.
- Error Budget: Allowed failure window derived from SLO (e.g., 99.9% uptime => ~43m/month downtime budget).

