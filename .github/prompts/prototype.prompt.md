---
description: Rapidly plan, build, and validate a minimal hypothesis-driven prototype with explicit confirmation gates and measurable evaluation metrics.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` may be hypothesis text, problem statement, feature concept, or path to a short markdown file (<10KB recommended for brevity).

## Purpose
Convert a raw hypothesis or problem statement into a minimal working prototype under `prototype/` that validates core assumptions quickly. Deliverables: (1) Scoped Validation Brief (pre-implementation, gated), (2) Working Source Code, (3) Evaluation Metrics & Evidence Report. Prioritize validation over feature completeness.

## Scripts
sh: .github/scripts/bash/setup-prototype.sh --json
ps: .github/scripts/powershell/setup-prototype.ps1 -Json

If setup script is missing, infer defaults: `repo_root = .`, `prototype_dir = ./prototype`.

## Outline

1. **Environment Setup**
	- Invoke `{SCRIPT}`; parse JSON: `repo_root`, `prototype_dir`, `timestamp_utc`, `agent_version`.
	- Prepare `prototype/src/` path plan (no writes yet).
2. **Input Classification & Extraction**
	- Determine if `$ARGUMENTS` is file path or inline text.
	- Validate length (>25 non-space chars) else set status `INPUT_TOO_BRIEF` and request augmentation.
3. **Hypothesis & Objectives Derivation**
	- Extract: Hypothesis, Target Users, Success Signals, Invalidators/Falsifiers.
4. **Persona & Scenario Sketch (Optional)**
	- Up to 2 personas; skip with rationale if purely backend prototype.
5. **Validation Scope Definition**
	- In-Scope vs Out-of-Scope items. Minimal data entities (if applicable). Core interaction flow.
6. **Tech & Stack Selection**
	- Detect UI need (keywords: ui, screen, page, component). If UI → plan shadcn components. If API need inferred → plan Express mock server.
7. **Risks & Constraints Enumeration**
	- Early feasibility + resource constraints.
8. **Confirmation Gate (Scope Approval)**
	- Present "Prototype Scope Brief" with all above sections. Await explicit YES before any file writes.
9. **Code Generation Plan (Post-Approval)**
	- File matrix: path | purpose | type | creation sequence | validation method.
10. **Implementation Execution**
	 - Create directories, scaffold entrypoints, implement minimal UI/API logic; incremental validation after each major step.
11. **Optional Backend Stub**
	 - If needed: add `prototype/src/server.js` with mock endpoints; document endpoints.
12. **UI Layer (Conditional)**
	 - Integrate minimal shadcn components (layout, button, form). Basic accessibility checks.
13. **Validation Assets Creation**
	 - Add README (launch steps), hypothesis brief, lightweight tests, optional Playwright flows.
14. **Evaluation Metrics Assembly**
	 - Populate metrics table (see below) with measured values.
15. **Evidence & Report Generation**
	 - Summarize implementation, remaining risks, decisions, and next recommendations.
16. **Completion Review Gate**
	 - Present metrics & readiness; await YES to finalize or NO to iterate.

## Mandatory Output Artifacts (Post-Gate Phases)
1. `prototype/hypothesis-brief.md`
2. `prototype/src/` (runnable code; UI and/or API as applicable)
3. `prototype/README.md`
4. `prototype/evaluation-report.md`
5. `prototype/test-results/` (if tests executed; else omission note)

## Evaluation Metrics Table
| # | Metric | Value | Gate | Notes |
|---|--------|-------|------|-------|
| 1 | BuildSuccess | PASS/FAIL | MUST PASS | Build/launch succeeds |
| 2 | HypothesisCoverage | 0–100% | ≥ 80% | % validation criteria implemented |
| 3 | LaunchReady | PASS/FAIL | MUST PASS | Usable with documented steps |
| 4 | DocsReady | PASS/FAIL | MUST PASS | README + hypothesis brief complete |
| 5 | TimeUsedHours | X/Target | ≤ 24 (advisory) | Tracked or estimated |
| 6 | TestCoverage | 0–100% | ≥ 50% baseline | Raise if standard higher |
| 7 | AccessibilityCheck | PASS/WARN/FAIL | PASS target | Basic semantic & contrast checks |
| 8 | APIStubReady | PASS/FAIL/NA | PASS if API planned | Mock endpoints respond |
| 9 | DependencyFootprint | Count | Advisory | Minimal libs only |
| 10 | SecurityScan | PASS/WARN/FAIL | PASS target | No secrets / critical vulns |
| 11 | OriginalCodeCompliance | PASS/FAIL | MUST PASS | Adapted, no wholesale copy |

Rules:
- NA only allowed for APIStubReady if no backend.
- WARN acceptable for AccessibilityCheck & SecurityScan with mitigation note.
- All MUST PASS metrics must pass or trigger iteration.

## Success Criteria
- Scope confirmation gate accepted before any code writes.
- Completion review gate accepted before finalization.
- Prototype launches locally with documented steps.
- All code confined to `prototype/` directory.
- Metrics table fully populated (no placeholders, TBD, ???, empty cells).
- No unresolved High/Critical risk lacking mitigation path.
- All MUST PASS gates satisfied at completion.

## Error Handling
| Condition | Action | Status |
|-----------|--------|--------|
| Missing input | Abort after metadata | `INPUT_MISSING` |
| Too brief input | Request augmentation | `INPUT_TOO_BRIEF` |
| Scope rejected | Refine & re-present | `SCOPE_REVISE` |
| Build failure | Re-enter implementation loop | `BUILD_FAIL` |
| Metrics incomplete | Block completion gate | `MISSING_METRICS` |
| MUST PASS gate fail | Iterate & remediate | `GATE_BLOCK` |

## Constraints
- No writes before Scope Approval.
- Keep dependency footprint minimal & justified.
- Neutral, accessible UI (avoid heavy ornamental styling).
- Only sanctioned tool use for external lookups.
- Deterministic section ordering.

## Output Formatting Rules
- Use level-2 headings for major sections.
- All file paths prefixed with `prototype/`.
- Single metrics table in evaluation report (no duplicates).
- No placeholder tokens in final artifacts.

## Confirmation Gates (Exact Text)
Scope Gate:
AWAITING USER CONFIRMATION: Reply YES to create prototype scope and begin code generation. Reply NO to refine first.

Completion Gate:
AWAITING USER CONFIRMATION: Prototype ready for review. Reply YES to finalize. Reply NO to iterate.

## Self-Check Procedure
1. Mandatory sections present & ordered.
2. No unresolved placeholders `$ARGUMENTS` or template markers.
3. File matrix references confined paths.
4. Metrics table fully populated (applies at completion review gate only).
5. MUST PASS metrics all PASS or iteration triggered.
6. Risks table includes mitigation for Critical items.
7. Confirmation gate text appears exactly once per gate.

DO NOT include this prompt content inside generated artifacts.

BEGIN EXECUTION WHEN INVOKED.