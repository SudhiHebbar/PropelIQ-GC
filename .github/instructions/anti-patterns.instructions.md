---
applyTo: "**"
description: "Focused anti-pattern avoidance instructions"
---

# Anti-Pattern Avoidance Instructions

These instructions supplement (not repeat) existing guidance (performance, security, a11y, architecture, commenting). They enforce fast detection and prevention of common code & architecture mistakes.

<!-- Removed explicit reference to gotchas/anti_patterns.md per request -->

## Core Enforcement Principles
- Prefer deletion/refactor over layering fixes atop flawed code.
- Fail fast: surface anti-pattern risk in PR description or task output.
- Never add TODOs for known anti-patterns—fix or justify inline.
- If a pattern appears twice, extract it (utility/module) or consciously isolate duplication with a comment: `// DUPLICATION-INTENTIONAL: reason`.

## Must-Block Anti-Patterns (Reject in PR)
1. God objects/functions (multiple unrelated responsibilities)
2. Copy-paste blocks > ~5 lines without abstraction
3. Hidden side effects (mutating external/shared state without clear naming)
4. Circular dependencies (module → module cycles)
5. Layer violations (UI → data persistence directly, skipping domain/service)
6. Silent error swallowing (empty catch, broad catch w/out logging/handling)
7. Magic constants (non-trivial numbers/strings inline w/out named constant)
8. Shared mutable singletons for request-scoped data
9. Hard-coded config/credentials/URLs (must use env/config provider)
10. Overloaded interfaces / fat DTOs mixing concerns (transport + domain + view)

## Conditional (Require Justification)
- Premature optimization (micro-optimizing w/out profiler evidence)
- Introducing new abstraction for single usage
- Adding dependency for trivial functionality available in stdlib
- Large switch/if chains better expressed as strategy / map dispatch
- Broad exported surface (export * or large barrels) increasing accidental coupling

## Architecture Integrity Checks
- Boundary direction: high-level modules NEVER import low-level framework specifics directly (see `dotnet-architecture-good-practices.instructions.md`).
- Each new module states its responsibility in first comment block (WHY, not WHAT). If not, flag as potential cohesion issue.
- Data flow clarity: any cross-module call that performs IO must expose a clear return contract (no hidden mutations).

## Event / Async Patterns
- Handlers must be idempotent (safe on re-run) unless explicitly documented: `// NON-IDEMPOTENT: reason`.
- No business logic inside serialization, mapping, or migration helpers.
- Avoid chatty interfaces: batch related calls; if >3 sequential remote calls in one function, refactor or aggregate.

## Testing Related Anti-Patterns
- Tests asserting multiple unrelated behaviors in one case (split them).
- Mocking internal implementation details instead of public contract.
- Copy-pasted test data fixtures—centralize or generate.
- Ignoring flaky test w/out ticket linkage and root-cause note.

## Validation Hooks (Apply During Review / Generation)
When generating or modifying code, perform this checklist locally before output:
- [ ] Single responsibility preserved
- [ ] No new duplication without justification
- [ ] No layering / boundary violations
- [ ] All caught errors handled or rethrown with context
- [ ] All magic values extracted or commented
- [ ] No direct shared state mutation across concurrency boundaries
- [ ] Config & secrets externalized
- [ ] Added code tested (or testability rationale documented)

## Auto-Refactor Guidance
If anti-pattern detected:
- Minimize surface change: isolate refactor to smallest scope.
- Write replacement first, switch references, then delete obsolete block.
- Preserve API signatures unless breakage is explicitly approved.

## Documentation & Traceability
- Link refactors to the anti-pattern category (e.g., `Refactor: eliminate copy-paste (anti_patterns: DRY)`).
- Provide a brief remediation note in PR body: Problem → Impact → Fix → Residual Risk.

## Escalation
If blocked by systemic issue (framework limitation, legacy coupling):
- Create remediation ticket with: scope, risk, proposed staged plan.
- Do NOT introduce compensating complexity unless approved.

This file intentionally excludes security, performance, accessibility, and language-specific rules already covered elsewhere.
