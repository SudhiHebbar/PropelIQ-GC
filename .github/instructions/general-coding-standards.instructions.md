---
applyTo: "**/*.{cs,csproj,fs,fsproj,go,py,rb,java,kt,ts,js,jsx,tsx,sql,yml,yaml,json,Dockerfile}"
description: "Universal coding standards: simplicity, clarity, size discipline, naming, TDD workflow, review gates, and tooling expectations. Excludes topics covered by dedicated security, performance, anti-pattern, backend, frontend, database, and commenting instruction files." 
---

## Scope & Intent
Provide cross-language baseline guardrails for generated or modified code. Focus on simplicity (KISS), avoidance of speculative complexity (YAGNI), fail-fast validation, structural size limits, naming clarity, deterministic test workflow, and review quality gates. Omit domain-specific architecture, performance micro-tuning, security deep-dives, and language idioms covered elsewhere.

## Core Principles
- KISS: Prefer straightforward, readable solutions; no cleverness without measurable benefit.
- YAGNI: Ship only required functionality; defer abstractions until duplication or change pressure appears.
- Fail Fast: Validate inputs at boundaries; surface explicit errors early (no silent fallbacks).
- Self-Explanatory Code: Improve naming before adding comments; comment WHY not WHAT when necessary.

## Size Discipline (Soft Caps)
Use these caps as refactor signals (not hard compile gates):
- Source File ≤ ~500 LOC (tests ≤ ~800 due to fixtures).
- Function/Method ≤ ~50 LOC (tests ≤ ~100, focused on AAA: Arrange/Act/Assert).
- Class ≤ ~200 LOC; Interface/Type Schema ≤ ~150 LOC.
- Line Length target 80–100 chars (exceptions: long URLs, imports, literals).
Trigger refactor when exceeding caps unless justified (add inline rationale).

## Refactoring Guidance
Large function split heuristic:
1. Extract validation. 2. Extract transformation. 3. Extract IO/persistence. 4. Preserve orchestration minimal.
Prefer composition over deep inheritance (>2 levels discouraged).

## Naming Conventions (Language Agnostic)
- Variables: descriptive, avoid terse abbreviations (e.g., `totalPrice`, not `tp`).
- Functions: verb + target (e.g., `loadUserProfile`).
- Classes: noun representing cohesive concept (e.g., `InvoiceAggregator`).
- Constants: SCREAMING_SNAKE_CASE (e.g., `MAX_RETRY_ATTEMPTS`).
- Avoid generic catch-all names (`Helper`, `Util`, `Manager`)—choose specific intent.

## Error Handling
- Never swallow exceptions silently; add context or rethrow.
- Differentiate recoverable vs fatal errors; propagate with typed / structured error objects.
- User-facing messages sanitized; internal logs retain technical detail (without secrets).

## Test-Driven Workflow (TDD / Behavior-first)
Minimal cycle: Red → Green → Refactor.
- Red: Write failing test expressing behavior & edge conditions.
- Green: Implement minimal solution (no extra branches).
- Refactor: Improve readability, remove duplication; tests remain green.
Use deterministic data & seeded randomness for reproducibility.

## Test Structure
- AAA Ordering: Clear separation of setup, execution, assertions.
- Single Responsibility: One behavioral expectation per test case.
- Isolation: No cross-test state leakage; reset shared fixtures.
- Edge Coverage: Include negative, boundary, and typical path; skip contrived scenarios until required.

## Tooling Expectations
- Fast Search: Prefer ripgrep (`rg`) or equivalent over slower recursive shell searches.
- Static Analysis: All new code must pass lint/type checks; fix warnings instead of suppressing.
- Complexity Scans: Flag deeply nested conditionals (>3 levels) or monstrous functions; refactor or justify.

## Code Review Quality Gates
Checklist baseline (augment with specialized files):
- Architecture Cohesion: Function/class has single clear purpose (one-sentence test).
- Duplication: No copy-paste blocks >5 lines without abstraction.
- Naming: Descriptive & context-rich; no ambiguous abbreviations.
- Tests: Added for new logic (happy + at least one failure/edge path).
- Errors: Properly handled; no empty catch blocks.
- Secrets: Not hardcoded (env/config driven).
- Magic Values: Extracted to named constants.
- Size: Exceeding caps justified or refactored.
- Comments: Present only where intent/decision is non-obvious.

## Validation Heuristics (Quick Scans)
Patterns to grep during review (adapt to stack):
- Hardcoded Secrets: patterns `password=`, `token=` outside test mocks.
- Deep Relative Imports: `../` repeated ≥3 times (consider restructuring).
- Long Functions: regex for `{[\s\S]{2000,}}` in language-specific tooling for candidate review.
- Debug Statements: `console.log`, `print(`, temporary logging—remove before merge.

## Magic & Constants Policy
- Extract any non-trivial numeric/time/string literal appearing >1 time or having domain meaning.
- Document rationale for thresholds (e.g., retry counts, timeout durations) inline.

## Early Return Pattern
Prefer multiple guard returns over deep nested conditionals for readability.

## Documentation Minimalism
- Public API surface: brief docstring with purpose, parameters, error modes, example.
- Complex Algorithms: short rationale + reference; avoid verbose step commentary.
- Internal trivial helpers: no comments if name conveys intent.

## Continuous Integration (Delta Only)
- Lint & Typecheck: Must pass with zero severe violations.
- Code Coverage: Minimum ~80% for core logic; focus on critical paths not trivial getters.
- Performance Regression Guard: Basic smoke/perf thresholds (specialized guidance in performance instructions).
- Security Scan: No high/critical issues unaddressed.

## Anti-Pattern Fast Flags
If encountered, refactor or justify inline:
- God object/function (multi-purpose, sprawling responsibilities).
- Deep nesting (>3 levels) obscuring main logic flow.
- Speculative abstraction (unused generic layers).
- Silent failure (empty catch or ignored promise).
- Unbounded growth (collections without cap or pruning strategy).

## Quality Checklist (Universal)
- [ ] Simplicity maintained (no unnecessary abstraction).
- [ ] YAGNI observed (no unused features/params).
- [ ] Input validation present at boundaries.
- [ ] Errors surfaced with context, not swallowed.
- [ ] Naming conveys intent everywhere.
- [ ] No hardcoded secrets / credentials.
- [ ] Magic values extracted & explained.
- [ ] Functions/classes within size guidance (or justified).
- [ ] Tests added & deterministic.
- [ ] Debug artifacts removed.
- [ ] Public APIs documented succinctly.

## Focused Terminology
- Guard Clause: Early conditional exit simplifying primary logic path.
- Magic Value: Literal with implicit meaning lacking a named constant.
- Speculative Abstraction: Structure added before proven necessity (violates YAGNI).
- Deterministic Test: Produces consistent outcome on repeat runs regardless of environment state.
