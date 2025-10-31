---
applyTo: "**/*.{cs,csproj,fs,fsproj,go,py,rb,java,kt,ts,js,sql,yml,yaml,json,Dockerfile}"
description: "Advanced database & data access guidance: modeling, consistency strategies, performance diagnostics, migration safety, multi-tenancy, and operational observability. Excludes basics covered in sql-sp, security, performance, and anti-pattern instruction files."
---

## Scope & Positioning
Focus on higher-order data architecture & operational data quality. Foundational SQL style, generic injection prevention, and basic performance indexing rules are intentionally excluded (covered elsewhere). Apply when generating or reviewing code that defines schema, data access layers, migrations, or persistence-impacting logic.

## Data Modeling Principles (Advanced)
- Intent-Revealing Names: Tables & columns articulate business meaning (avoid overloaded generic names like `Data`, `Value`).
- Narrow Tables First: Prefer decomposing wide tables (>40 columns) into cohesive sub-entities with clear ownership.
- Immutable Facts vs Mutable State: Separate append-only event/fact tables from current-state snapshot tables for clarity & auditing.
- Enumerations Strategy: Centralize enumerated domain concepts (lookup tables or constrained enum types); never replicate magic strings across services.
- Temporal Modeling: For entities where historical state matters, adopt bitemporal or effective dating (valid_from, valid_to) instead of overwriting.

## Keys & Identity
- Natural Key Preference When Stable: Use natural composite keys where business guarantees stability (e.g., ISO code + version); fall back to surrogate keys when volatility risk exists.
- Surrogate + Natural Hybrid: Keep a surrogate primary key, enforce unique natural key constraint for business validation.
- UUID vs INT: Use monotonic (ULID / sequential UUID) where write hot-spot & index fragmentation are concerns.
- Foreign Key Optionality: Only nullable when true business optionality exists—avoid nulls as a substitute for incomplete ingestion state (use staging tables instead).

## Normalization vs Strategic Duplication
- Normalize for integrity until proven hot path read amplification; only denormalize with measured latency evidence & documented invalidation rules.
- Precompute / Materialize: Create derived projection tables for expensive aggregations accessed frequently (document refresh cadence & staleness SLA).
- Avoid Partial Denormalization: Either fully own a projection or not at all—no half-copied entity fragments that silently drift.

## Query Shape & Access Layer Design
- Explicit Repository / Data Gateway Boundaries: Application layer depends on abstraction; raw ORM/query objects remain internal.
- Deterministic Loading Plans: Avoid ad-hoc lazy loading in loops; pre-plan eager vs selective column projection per use case.
- N+1 Prevention: Detect via automated test (capture query count threshold) in integration suite.
- Result Set Contracts: Data access methods guarantee ordering, filtering semantics, and pagination determinism.

## Concurrency & Consistency
- Optimistic Concurrency Tokens: Use row version / etag columns; reject conflicting writes with explicit domain error.
- Lost Update Safeguards: Never perform read-modify-write without version predicate.
- Write Contention Mitigation: Shard hot aggregates logically (e.g., per tenant or bucket) before introducing cross-node distributed locks.
- Multi-Step Consistency: Multi-entity updates prefer single transaction; if spanning bounded contexts, employ saga / orchestration with compensations documented.

## Transactions & Isolation Strategy
- Default Isolation Baseline: Use READ COMMITTED or equivalent; elevate (REPEATABLE READ/SERIALIZABLE) only around correctness-critical sections with bounded scope.
- Idempotent Retry Blocks: Wrap transient-failure retry logic only around idempotent transactional units.
- Savepoints: Utilize for partial rollback in complex multi-operation batches instead of oversizing transaction spans.

## Migration Safety & Lifecycle
- Expand → Migrate Data → Switch Usage → Contract pattern; never drop or rename in same deploy that introduces replacement logic.
- Reversible Migrations: Provide down path until migration proven stable in production.
- Zero-Downtime Additions: Add nullable columns first; backfill in controlled batches; enforce NOT NULL only after completeness verified.
- Large Table Changes: Prefer online schema change tools / chunked backfills with progress logging & cancellation hooks.
- Migration Observability: Emit metrics (migration name, batch rate, rows processed, error count) for long-running data transformations.

## Index Strategy (Advanced)
- Hypothesis Driven: Each index must have recorded rationale (workload, query pattern) & review date.
- Covering Indexes: Use to eliminate bookmark lookups on hottest read paths; keep width disciplined to avoid write amplification.
- Composite Order: Place most selective & equality-filtered columns first; defer range / ordering columns.
- Index Bloat Monitoring: Track dead tuple %, fragmentation, and stale statistics—automate alerts beyond threshold.
- Cleanup Cadence: Schedule periodic review to drop unused indexes (observed via usage DMVs / pg_stat / sys.dm_db_index_usage_stats).

## Caching & Persistence Interplay
- Multi-Layer Awareness: Ensure cache invalidation occurs inside same transaction boundary or via outbox event dispatch.
- Write-Through vs Write-Behind: Use write-behind only with durability assurances & replay mechanics for crash recovery.
- Cache Stampede Prevention: Employ request coalescing / per-key mutex + probabilistic early refresh (e.g., jittered TTL).

## Observability & Diagnostics
- Structured Query Logging: Log slow queries above threshold with: normalized statement, duration, rows, plan hash, correlation id.
- Plan Regression Detection: Track plan hash drift for top N queries; alert on sudden change + latency increase.
- Cardinality Risk Flags: Identify queries with high variance row estimates vs actual (planner misestimation) for tuning.
- Data Quality Metrics: Freshness (lag between source & projection), completeness (% non-null where required), duplication rate on unique keys.

## Security & Governance (Delta Only)
- Least Privilege DB Roles: Separate migration role, app read/write role, read-only analytics role; no shared superuser usage.
- Restricted Dynamic SQL: Allow only in vetted utility modules with input sanitization & parameterization wrappers.
- PII Tagging: Classify sensitive columns; enforce encryption / masking policy at rest & in logs.

## Multi-Tenancy & Sharding
- Strategy Declaration: Chosen model (shared schema, schema-per-tenant, database-per-tenant, key-based shard) documented with routing logic.
- Hotspot Mitigation: Hash-based distribution for sequential tenant identifiers to avoid shard skew.
- Cross-Tenant Queries: Prohibit unless routed through sanctioned analytics pipeline with anonymization.
- Tenant Data Lifecycle: Provide explicit archival + purge workflows respecting retention policies (automated where feasible).

## Event Sourcing & Change Data Capture (CDC)
- Immutable Event Store: Append-only; no in-place mutation—corrections via compensating events.
- Snapshotting Policy: Periodic snapshot per aggregate after threshold events to bound replay latency.
- CDC Consumption: Deduplicate on primary key + LSN/sequence; treat gaps as backpressure signals & alert.

## Performance Diagnostics (Non-Redundant)
- Workload Baselines: Capture periodic query distribution histograms; compare on deploy for anomalies.
- Lock Contention Analysis: Monitor wait events / lock graphs; refactor patterns causing long-held locks.
- Queue Depth vs Throughput: For write-heavy ingestion, track commit latency vs input queue depth to detect saturation early.

## Testing & Verification
- Migration Dry Run: Require simulation against masked production snapshot; compare row counts & constraint violations pre/post.
- Query Budget Tests: Assert max queries per high-level operation (fails if N+1 introduced).
- Data Drift Tests: Periodically validate projections vs authoritative sources (checksum or row count parity per partition).
- Fixture Realism: Seed datasets representing edge cardinalities (empty, typical, high-volume) for performance-sensitive paths.

## Quality & Safety Checklist
Before merging data-impacting changes ensure:
- [ ] Migration follows expand → migrate → switch → contract sequence.
- [ ] New/changed queries covered by test preventing N+1 regression.
- [ ] Added indexes have documented rationale & monitored usage plan.
- [ ] Long-running data task includes progress & cancellation support.
- [ ] Caching layer invalidation path defined & tested.
- [ ] Concurrency control (version token / predicate) applied to mutable aggregates.
- [ ] Sensitive columns classified & protected per policy.
- [ ] Multi-tenant isolation preserved (scoped queries & role segregation).
- [ ] Event / CDC consumers idempotent & duplicate-safe.
- [ ] Performance baseline compared (no significant regression without justification).

## Focused Terminology
- Plan Hash: Identifier derived from normalized execution plan for drift detection.
- Snapshotting (Event Sourcing): Periodic persisted materialization of aggregate state reducing replay cost.
- Cardinality Estimation: Query planner predicted vs actual row counts guiding optimization.
- Shard Skew: Disproportionate load/storage concentrated on subset of shards degrading balance.
- Data Drift: Divergence between source-of-truth and derived projection representations.

