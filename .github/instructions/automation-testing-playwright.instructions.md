---
applyTo: "**/*.{spec,test}.ts"
description: "Advanced Playwright automation testing guidance – complements (does not repeat) baseline rules in playwright-typescript.instructions.md by focusing on anti-pattern prevention, stability, isolation, and maintainability."
---

## Scope & Non-Duplication
This instruction file augments existing Playwright guidance. It deliberately omits baseline topics already defined elsewhere (e.g., basic locator priority, file naming, fundamental assertions) and focuses on higher-order stability, avoidance of hidden flakiness, and suite sustainability.

## Core Principles
- Each test is an independent specification – never rely on side effects from prior tests.
- Prefer user-observable outcomes over implementation details.
- Eliminate non-determinism (timing races, shared mutable state, environment leakage).
- Optimize for fast feedback: keep tests lean; push exhaustive combinatorics to lower layers or data-driven parametrization.
- Fail fast with actionable diagnostics (clear assertion intent + context).

## Critical Anti-Patterns (MUST Avoid)
| Category | Anti-Pattern | Safer Alternative |
|----------|--------------|-------------------|
| Timing | `waitForTimeout()` as synchronization | Web-first assertions / explicit state waits |
| Selectors | Styling / dynamic ID / nth-child chains | Role, accessible name, test id (only if role not feasible) |
| State | Test B depends on login done in Test A | Each test performs (or reuses stored) auth setup |
| Assertions | Existence-only (`toBeTruthy()` element handle) | User-facing state & text, accessibility tree, URL, visibility, enabled/disabled |
| Network | Live external API dependency | Route interception + mocked deterministic responses |
| Page Objects | Embedding test logic / assertions in page class | Page object = interaction + lightweight state queries only |
| Data | Hard-coded inline credentials / magic literals | Centralized fixtures + env-driven secrets |
| Debugging | Leftover `page.pause()`, console spam, long sleeps | Targeted trace/screenshot on failure only |
| Performance | Repeating expensive setup per test | Reuse authenticated storage state / worker fixtures |
| Security | Plain-text secrets committed | Environment variables + secret store integration |

## Test Independence & State Management
- Never rely on execution order; tests must pass when run alone (`--grep` filtering scenario).
- Use storage state snapshots (login once per worker) when safe; refresh if auth-scoped data mutates.
- Clear persisted state (localStorage, sessionStorage, IndexedDB) in `beforeEach` or via a shared fixture when tests require clean slate.
- Random data: seed any generated values so failures are reproducible (e.g., use a seeded RNG helper).

## Synchronization & Timing Strategy
- Prefer assertion-driven waiting (Playwright auto-wait) rather than manual waits.
- Explicitly wait for: navigation completion, network idle where business-critical, component readiness flags.
- Use `page.waitForResponse()` only when asserting a specific request side-effect; otherwise rely on UI signals.
- Guard against race conditions by sequencing: (trigger) → (assert intermediate state) → (proceed). Avoid chaining actions without verifying state transitions.

## Assertion Quality
Good assertions:
- Express the user intent ("success banner visible", "URL includes /dashboard").
- Provide precise failure messages (custom message wrapper when ambiguity likely).
- Avoid probing private globals or framework internals.
- Include negative assertions for critical absence (spinner removed) with reasonable timeout.

## Network & API Control
- Intercept and fulfill external endpoints with stable fixtures for: 3rd-party services, volatile datasets, failure paths.
- Model error scenarios (4xx/5xx) explicitly—each critical API should have at least one resilience test.
- Coalesce frequently reused mock responses into helper factories (e.g., `buildUser()`), resisting copy-paste JSON.

## Page Object Discipline
Page objects SHOULD:
- Expose clear intent methods (e.g., `login(email, password)`), thin wrappers around interactions.
- Provide lightweight state accessors (e.g., `isLoggedIn()` returning a locator expectation or boolean via evaluation).
Page objects MUST NOT:
- Contain test assertions beyond basic state queries.
- Embed arbitrary sleeps or environment mutation.
- Chain multiple business flows (keep them composable; tests orchestrate flows).

## Test Data & Fixtures
- Centralize canonical test users, roles, and boundary values (e.g., max length strings) inside a single fixture module.
- Generate fresh entities (like unique emails) via deterministic helpers to avoid cross-test collisions.
- Use parameterized tests for input matrices rather than duplicating near-identical test bodies.
- Mask or redact sensitive data in logged output.

## Configuration & Suite Performance
- Keep global timeout modest; rely on per-assertion stability instead of inflating timeouts.
- Run in parallel by default; switch to serial only for truly non-isolatable side effects (document why with a comment).
- Reuse browser contexts judiciously: isolate when test mutates fundamental app configuration.
- Capture traces/screenshots ONLY on failure (or first retry) to minimize IO overhead.

## Debugging & Diagnostics
- Use `page.pause()` only locally; never commit it.
- Enable trace viewer on flaky investigation branches; remove before merge.
- Attach context metadata (test id, seed, user role) to failure logs to accelerate triage.

## Security & Secrets
- Read credentials from environment (never literal in repo). Provide fallbacks ONLY in secure local dev scripts (not in test code).
- Rotate test secrets separately from production; keep scopes minimal (least privilege accounts).
- Scrub secrets from captured traces if traces may be shared externally.

## Stability & Flakiness Checklist (Augmentative)
Before marking a test "stable":
- [ ] No direct `waitForTimeout` calls.
- [ ] All selectors are role / label / test id (no brittle chains).
- [ ] No shared mutable cross-test state.
- [ ] Network dependencies mocked where non-deterministic.
- [ ] Assertions reflect user-visible outcomes.
- [ ] Page objects free of test logic & sleeps.
- [ ] Secrets & credentials sourced via environment.
- [ ] Parallel-safe (passes when isolated & in random order).

## Minimal Example (Refactored for Independence & Stability)
```typescript
import { test, expect } from '@playwright/test';
import { LoginPage } from './pages/login.page';
import { buildUser } from './fixtures/users';

test.describe('Dashboard', () => {
  test.use({ storageState: 'auth/user.json' }); // Pre-auth state produced by a global setup

  test('shows recent activity after login', async ({ page }) => {
    const user = buildUser(); // deterministic seed inside helper
    const login = new LoginPage(page);
    await login.ensureAuthenticated(); // idempotent (no-op if already logged in)

    await page.goto('/dashboard');
    await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible();
    await expect(page.getByRole('list', { name: 'Recent Activity' })).toHaveCount(1);
    await expect(page.getByText(user.displayName)).toBeVisible();
  });
});
```

## Maintenance Guidelines
- Refactor duplicated locator fragments into helper functions once repeated >2 times.
- When fixing flakiness, document root cause + mitigation in commit body (not just "retry added").
- Periodically audit slowest 10 tests (max duration budget) and optimize or re-scope.

## Glossary (Focused)
- Deterministic Fixture: Data setup whose values derive from a reproducible seed.
- Idempotent Helper: Function safe to call multiple times without altering final state unexpectedly.
- Storage State: Playwright-authentication JSON snapshot reused to bypass repetitive UI login.

