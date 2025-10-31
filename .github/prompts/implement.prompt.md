---
description: Execute a development task file end-to-end: plan, implement, validate, generate evaluation metrics, and produce an implementation report.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` MUST be the absolute or repo-relative path to a single task markdown file (created from `task_template.md`).

## Purpose
Implement the referenced task file completely and safely: load context, plan granular steps, perform implementation, continuously validate, generate evaluation metrics, and produce an implementation report. Abort early if the task is already fully completed.

## Outline

1. **Setup & Load Task File:**
	- Run `{SCRIPT}` and parse JSON for: `repo_root`, `docs_dir`, `tasks_root`.
	- Export or internally track these values; treat them as environment-scoped variables for subsequent path references.
	- Read the entire task file at `$ARGUMENTS`.
	- Parse sections (Purpose, Requirement Reference, Tasks, ToDo Task checklist, Implementation Plan, Validation Strategy).

1.1 **Baseline Build Validation:**
	- Detect build command heuristically (order: `package.json` -> `npm run build` / `pnpm build`; `pyproject.toml` -> `python -m build` or tests; `.csproj`/`.sln` -> `dotnet build`; `pom.xml` -> `mvn -q -DskipTests package`; `Cargo.toml` -> `cargo build`; fallback: attempt known project script `build` or skip with NA justification).
	- Execute the build; capture exit status and first/last 20 lines of output for the Implementation Report.
	- If build fails → abort early with status `BASELINE_BUILD_FAIL` (do NOT proceed to implementation) and advise remediation steps (lint, dependency install, missing code ref).
	- Record chosen command as `baseline_build_cmd` in Execution Metadata.

2. **Assess Completion:**
	- If all ToDo checklist items are already checked (`[X]` / `[x]`), terminate with message: "All tasks were implemented".

3. **Load Core Context Docs:**
	- Read (if present): `${docs_dir}/spec.md`, `${docs_dir}/design.md`, `${docs_dir}/designsystem.md`, `${docs_dir}/codeanalysis.md`.
	- Summarize constraints, domain rules, design tokens, and code analysis insights.
	- Context Pattern Detection: Identify relevant layers/technologies from changed files; emphasize associated cross-cutting concerns (security, performance, accessibility).

4. **UI Design Integration (Conditional):**
	- If task mentions UI / component / page / styling → load `${docs_dir}/designstyle.md` (Figma links / images / tokens) and/or `${docs_dir}/designsystem.md` if present.

5. **Framework Version Pinning:**
	- Use Context7 `resolve-library-id` on detected frameworks/libraries.
	- Fetch version-specific docs via `get-library-docs` for critical APIs referenced in the task.

6. **Create Execution Plan (TodoWrite):**
	- Break task into executable steps (≤30–45 min each) covering implementation + validation.
	- Include final step: "Generate evaluation metrics".
	- Enumerate dependency ordering (e.g., data schema → service layer → API surface → UI integration) and note any prerequisites.
	- Enumerate edge cases & negative scenarios; map each to a planned validation action or test artifact.

7. **Validation Loop Setup (Use Sequential thinking MCP):**
	- PLAN: Run `mcp__sequential_thinking__plan` to materialize verification checklist from acceptance criteria & NFRs.
	- CRITIQUE: Run Run `mcp__sequential_thinking__critique` to map evidence (files, tests, endpoints) to each checklist item (Pass/Gap/Fail).
	- REFLECT: Run `mcp__sequential_thinking__reflect` to summarize risks, produce fix list & missing tests.
	- Integrate Cross-Cutting Concerns: Add checklist entries for performance, security, accessibility, and observability items relevant to detected layers; flag any High/Critical gaps as risks.

8. **Iterative Implementation:**
	- For each planned step: implement code following existing patterns (naming, structure).
	- Update task file checkboxes from `[ ]` → `[X]` immediately after each successfully validated step.
	- Maintain incremental validity (tests remain green; build compiles if applicable).


9. **UI Pixel Validation (Conditional):**
	- For UI tasks: use Playwright MCP to capture & compare component/page against `${docs_dir}/designsystem.md`.
		- Validate spacing, typography, color tokens, and component states.
		- Verify responsive breakpoints & layout shifts.
		- Confirm accessibility roles, focus order, and landmark regions.
		- Check contrast where token definitions allow.
		- Attach snapshot diffs for any adjustments.

10. **Continuous Validation:**
	- After each change: execute incremental/full build (`baseline_build_cmd`), then lint, then tests, then type/type-check, then security/static scans (where applicable). Fix any failure before advancing.
	- On build failure mid-process → mark `BUILD_FAIL` and re-attempt after fix; do not tick the related todo until build re-passes.

11. **Finalize Validation Loop:**
	- Re-run critique after fixes; ensure all critical items Pass or have explicit accepted risk.

12. **Generate Comprehensive Evaluation Metrics & Assessment:**
	- Measure Metrics 1-11 (BuildSuccess, AllTestsPassed, RequirementsFulfilled, SecurityClean, NoRegressions, CodeQualityScore, TestCoverage, StaticAnalysisClean, DocumentationComplete, ProductionSafe, OriginalCodeCompliance).
	- Populate columns: Index, Metric, Value, Production Gate, Notes.
	- Use real measurement sources (build exit status, test runner summary, coverage report %, static analysis output, secret/vulnerability scan, diff/adaptation analysis).
	- If any MUST PASS metric fails, loop back to implement missing fixes before proceeding unless explicitly accepted and recorded under Failed Gates with remediation.
	- (Optional) Also gather supplemental operational metrics (Task Coverage %, Checked Items Count, New/Modified Files, Docs Updated (Y/N), Pixel Deviation (UI), Framework Version Pins) for context.

13. **Implementation Report Generation:**
	- Summarize key changes: files touched, rationale, tests added/modified.
	- Produce Risk Register table (ID | Area | Severity | Mitigation | Status) including any residual accepted risks.
	- Document mitigated vs residual risks.

14. **Completion Gate:**
	- Verify all acceptance criteria satisfied, no unchecked required todos remain, metrics table present.

## Rollback & Restoration Strategy
- Define restoration checkpoint(s) prior to high-impact or multi-file changes (e.g., schema migration, core refactor).
- Optionally create a lightweight reversible artifact (tag or patch diff) before proceeding.
- Document rollback trigger conditions and steps in the Implementation Report.
- After rollback (if invoked), re-run essential validations (build, tests) to confirm integrity.

## Mandatory Sections (Output Expectations)
1. Execution Metadata
2. Task Summary & Initial State
3. Planning Breakdown (TodoWrite Plan)
4. Implementation Changes Overview
5. Validation & Test Results
6. Evaluation Metrics & Assessment (11-metric table + Failed Gates list)
7. Risk Register
8. Final Status & Next Recommendations

## Success Criteria
- Already-complete task detected → graceful abort with required message.
- All original unchecked todos are either completed (`[X]`) or explicitly justified as intentionally excluded (with rationale recorded).
- Validation loop (PLAN → CRITIQUE → REFLECT) executed at least once after implementation changes.
- Comprehensive 11-metric evaluation table present (no placeholders) with Metrics 1-11 in order.
- All MUST PASS gates (BuildSuccess, AllTestsPassed, SecurityClean, NoRegressions, StaticAnalysisClean, DocumentationComplete, ProductionSafe, OriginalCodeCompliance) are PASS or appear in Failed Gates with explicit remediation plan.
- RequirementsFulfilled = 100% (justify if <100% with scope rationale).
- TestCoverage ≥ 80% (or documented project override) with coverage source cited.
- CodeQualityScore ≥ 70 (or documented override) with originating tool named.
- No critical/high static analysis issues unresolved.
- OriginalCodeCompliance validated: adapted code only, no verbatim unmodified third-party blocks; adaptations documented.
- Metrics Integrity: table has no TBD/???/placeholder/empty cells; NA only with justification.
- Failed Gates section either lists each failing metric + remediation or states "None".
- Each metric row includes a Source or NA + justification (if adopting provenance; see Metrics table).
- Risk Register present with severity & mitigation for each open or accepted risk.
- External adaptation evidence recorded (source & rationale) for any incorporated external logic.
 - Baseline build executed and passed prior to any implementation steps (or justified NA if project has no build concept).
 - Mid-process build failures resolved before subsequent steps (no unchecked BUILD_FAIL events at completion gate).
 - Context detections enumerated; cross-cutting concern checklist populated; unmitigated High/Critical items appear in Risk Register.

## Scripts
sh: .github/scripts/bash/setup-implement.sh --json
ps: .github/scripts/powershell/setup-implement.ps1 -Json
Instructions:
- Invoke the appropriate script BEFORE beginning Outline step 1 logic.
- Treat returned JSON keys as environment variables or in-memory bindings: `repo_root`, `docs_dir`, `tasks_root`.
- All path references in this prompt MUST be resolved via these variables; do not hard-code repository absolute paths.
## Error Handling
5. **UI Design Integration (Conditional):**
	- If task mentions UI / component / page / styling → load `${docs_dir}/DesignReference.md` (Figma links / images / tokens).
6. **Framework Version Pinning:**
| Missing task file path | Abort with message; no changes | `INPUT_MISSING` |
| Task file unreadable | Abort; report path & reason | `FATAL_TASK_IO` |
7. **Create Execution Plan (TodoWrite):**
| Context doc missing | Proceed; list under Gaps | `MISSING_OPTIONAL_DOC` |
| Library resolution failure | Continue; mark doc fetch degraded | `DEGRADED_EXT_RES` |
| Metric measurement unavailable | Continue; set Value=NA with justification | `DEGRADED_METRIC` |
| Mandatory metric missing | Abort before completion gate | `MISSING_METRIC` |
| Gate failed w/o remediation note | Re-enter implementation loop | `UNJUSTIFIED_GATE_FAIL` |
| Baseline build failure | Abort; show log excerpt & remediation | `BASELINE_BUILD_FAIL` |
| Iterative build failure | Block progress; fix & re-run build | `BUILD_FAIL` |
8. **Validation Loop Setup:**
- Read & write only within repository scope; no deletion of unrelated files.
- Do not introduce external dependencies without evidence of necessity.
- No destructive refactors beyond task scope.
9. **Iterative Implementation:**

## Output Formatting Rules
- Markdown sections use level-2 headings for all mandatory output sections.
- File paths rendered in backticks.
- Evaluation Metrics table must not contain: TBD, ???, placeholder, or empty cells.
- Failed Gates subsection must always appear ("None" if no failures).
- Any NA metric values must include a parenthetical justification.
- No duplicate metrics tables; only the comprehensive one plus optional supplemental list.

## Evaluation Metrics & Assessment

### Evaluation Metrics (AI-Generated, Requires Human Verification)

Task Type: [FE/BE/DB/Integration/Docs/Infrastructure]

| # | Metric | Value | Source | Production Gate | Notes |
|---|--------|-------|--------|-----------------|-------|
| 1 | BuildSuccess | PASS/FAIL | build log / CI | MUST PASS | Build completed without errors |
| 2 | AllTestsPassed | PASS/FAIL | test runner | MUST PASS | 100% tests pass |
| 3 | RequirementsFulfilled | 0–100% | coverage matrix | = 100% | All requirements implemented |
| 4 | SecurityClean | PASS/FAIL | secret/vuln scan | MUST PASS | No secrets / critical vulns |
| 5 | NoRegressions | PASS/FAIL | diff + regression tests | MUST PASS | Existing functionality intact |
| 6 | CodeQualityScore | 0–100 | quality tool | ≥ 70 | From quality tool (name it) |
| 7 | TestCoverage | 0–100% | coverage report | ≥ 80% | Line/branch coverage |
| 8 | StaticAnalysisClean | PASS/FAIL | static analysis | MUST PASS | No critical/high issues |
| 9 | DocumentationComplete | PASS/FAIL | doc diff | MUST PASS | README/API/comments updated |
| 10 | ProductionSafe | PASS/FAIL | validation review | MUST PASS | Logging, validation, error handling present |
| 11 | OriginalCodeCompliance | PASS/FAIL | diff inspection | MUST PASS | Adapted code; no verbatim external blocks |

Metric Notes:
- All metrics must be measured, not estimated.
- Use NA only if genuinely non-applicable (include justification).
- Thresholds (70%, 80%) may be overridden by project standards (state overrides explicitly).
- Human review is the final arbiter.

Supplemental Metrics (Optional):
- Task Coverage %
- Checked Items Count
- New/Modified Files
- Docs Updated (Y/N)
- Pixel Deviation (UI)
- Framework Version Pins

### Evaluation Assessment

Failed Gates:
- None (replace with list and remediation plans if any fail)

OriginalCodeCompliance Definition: No wholesale copy-paste of third-party code. Adaptations must reflect integration changes (renamed symbols, structural adjustments, added contextual comments).

## External Code Adaptation Policy
All incorporated external logic MUST be:
1. Adapted (renamed symbols, localized abstractions, integrated patterns).
2. Documented with source & rationale either in code comments or Implementation Report.
3. Security-reviewed (no unsafe patterns, secret exposure, injection risks).
4. License-compatible (avoid incompatible copyleft unless project policy allows).
Evidence forms may include: contextual diff changes, added tests proving integration, inline rationale comments.

Self-Check Procedure:
1. Re-scan task file: confirm all target todos now `[X]`.
2. Ensure evaluation metrics table contains numeric or Y/N values (no placeholders).
3. Confirm MCP validation phases recorded.
4. For UI tasks: verify captured validation evidence present.
5. If any fail trigger present, remediate before final output.
6. Verify metrics table lists Metrics 1-11 in correct order.
7. Confirm all MUST PASS metrics are PASS or appear in Failed Gates with remediation.
8. Ensure any NA value includes justification.
9. Check for absence of TBD/???/placeholder tokens.
10. If Failed Gates not "None", ensure loop-back or acceptance rationale documented.
11. Confirm Risk Register table present and populated.
12. Confirm any external adaptation entries include source & rationale.
13. Baseline build log captured; BuildSuccess metric derived from final build exit status; no unresolved `BUILD_FAIL` or `BASELINE_BUILD_FAIL` statuses.

BEGIN EXECUTION WHEN INVOKED.