# Additional Context for Development

This document gives a comprehensive guide for command and task generation.

## Planning & Work Decomposition (Retained – Unique)

### User Story Breakdown
- Max 5 story points (1 pt ≈ 6 hours).
- Each story must be independently testable and deliver business value (INVEST).
- Avoid bundling unrelated concerns; split by clear acceptance criteria.

### Task Creation
- Standard task size: ~4 hours effort.
- Each task: explicit acceptance criteria, inputs/outputs, validation scope.
- Associate tasks with their layer (FE, BE, DB, Integration) for clarity.

### Project Scaffolding (When No Existing Codebase)
Create discrete tasks for:
1. Initialization (structure, build, configuration).
2. Dev environment (tooling, lint, formatting).
3. Framework selection (justify choice, record constraints).
4. Structure conventions (folders, naming, layering boundaries).
5. Build & CI/CD pipeline (tests, security, performance gates).
6. Documentation foundation (README, contributing guide).

### Stream Separation
- FE: UI, accessibility hooks, client-side state.
- BE: APIs, services, domain logic.
- DB: Schema evolution, migrations, performance diagnostics.
- Integration: Cross-layer workflows, contract validation, end-to-end tests.

### Integration Testing
- Validate primary user workflows (happy path + failure modes).
- Confirm interface contracts (payload shape, status codes, events, migrations applied).
- Include dependency edge cases (timeouts, retries, version mismatches).

### Dependencies & Critical Path
- Map blocking prerequisites early (e.g., schema migration before API endpoint).
- Identify parallelizable tasks; annotate tasks that unlock others.
- Record handoff artifacts (OpenAPI spec, migration scripts, event schemas).

### Task Documentation Essentials
- Purpose (WHY) not just action.
- Acceptance criteria (observable outcomes, test anchors).
- Risks / assumptions (e.g., latency SLA, feature flag gating).
- Reference canonical instruction files instead of duplicating rules.

### Quality Assurance Alignment
- Pair development tasks with test tasks (unit, integration, performance smoke where relevant).
- Add code review tasks for complex or security-sensitive changes.
- Separate documentation updates—do not bundle with logic changes.

## Code Generation Instructions
1. Preserve existing behavior unless explicitly changing it.
2. Analyze impact (dependencies, side effects) before edits.
3. Prefer maintained libraries; verify deprecation status.
4. Validate template outputs fully (no placeholder leakage).

## Migration of Legacy Paths
Prior references to `.propel/context/*` are deprecated. Use updated locations under `.github/` or project-specific context directories as established by current tooling. If a context folder does not yet exist, create it intentionally—do not assume legacy structure.

## MCP Pagination Policy (Retained – Unique)
Scope: Any MCP tool returning large lists, logs, files, or code.

Rules:
1. Always paginate (limit + offset/cursor).
2. Token budget: Hard ceiling 25,000 tokens per call; target ≤ 18,000 for reasoning headroom.
3. Projection first: Request only required fields.
4. Filter early: Apply server-side filters (since, ids, status, path, glob).

Defaults:
- Lists: start limit=50; if page <9k tokens, consider doubling (without exceeding safe budget). If ≥18k, halve next limit.
- Files/text: range reads (offset + length). Start 60k–80k chars (~15k–20k tokens). Return `nextOffset` + `hasMore`.

Stop & Safety:
- Stop when goal met or after 5 pages unless explicitly extended.
- If near 18k tokens or latency spikes, reduce limit 50% and tighten filters.
- Never full-dataset pulls; prefer targeted ranges.
- Log decisions succinctly (e.g., `pages: 3 limits 50→100→50 final <18k tokens`).
