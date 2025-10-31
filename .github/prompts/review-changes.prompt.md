---
description: Review an implemented task's code changes against its task file to verify scope alignment, quality, risks, and gate readiness.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` MUST be the absolute or repo-relative path to a single implemented task markdown file (produced from `task_template.md`). Optionally append a commit range or diff spec (e.g., `:<commitA>..<commitB>` or `--since=3d`) — if absent, use the most recent commits touching referenced files.

## Purpose
Perform a post-implementation review validating that the delivered work for the given task file:
1. Implements 100% of acceptance criteria & checklist items.
2. Introduces no regressions or obvious design / architectural violations.
3. Meets quality, test, security, documentation, and compliance gates.
4. Surfaces residual risks, gaps, or remediation actions before integration or release.

Produces a structured Review Report ONLY (no code changes) with actionable findings and pass/fail gate summary.

## Outline

1. **Initialize & Parse Task File**
	- Load task file at `$ARGUMENTS` (strip any appended diff spec first).
	- Parse canonical sections: Purpose, Requirement Reference, Tasks, ToDo Task checklist, Implementation Plan, Validation Strategy.
2. **Determine Change Scope**
	- Collect referenced files (Inputs, Outputs, Impacted Components) from the task file.
	- Resolve actual changed files via git diff (range or heuristic: last N commits touching those paths).
3. **Load Supplemental Context**
	- Read `.propel/context/docs/spec.md`, `design.md`, `designsystem.md`, `codeanalysis.md` if present; summarize constraints & design tokens; record missing.
	- Context Pattern Detection: Derive expected layer/technology set from changed files + task declarations. Capture ExpectedContext vs DetectedContext tables (Layer/Tech | Trigger Evidence). Flag missing expected domains or unjustified additions.

4. **Execution Evidence Correlation**
	- Map each acceptance criterion & checklist item to concrete evidence: file lines, test names, commit hashes.
	- Mark coverage status: Implemented | Partial | Missing.

5. **Quality & Test Verification**
	- Extract or simulate: build success indicator, test pass summary, coverage % (if available), static analysis / lint markers, security/secret scan stubs.

6. **Architecture & Pattern Conformance**
	- Compare changes against architecture cues from `codeanalysis.md` (layering, boundaries, coupling hotspots). Flag divergences.
	- Evaluate context alignment: produce ContextDelta table (MissingExpected | UnjustifiedDetected) with mitigation or justification notes.

7. **Risk & Regression Assessment**
	- Identify potential regressions (API signature changes, removed validations, performance hotspots, error handling gaps).

8. **Original Code Compliance Check**
	- Scan additions for large unchanged external snippets (heuristic: long unreferenced blocks) — note any adaptation evidence.

9. **Gap & Remediation Enumeration**
	- For every Partial/Missing item produce remediation tasks or confirm if consciously deferred.

10. **Gate Evaluation Metrics Assembly**
	- Populate standardized metrics (BuildSuccess, AllTestsPassed, RequirementsFulfilled %, SecurityClean, NoRegressions, CodeQualityScore, TestCoverage %, StaticAnalysisClean, DocumentationComplete, ProductionSafe, OriginalCodeCompliance).

11. **Overall Verdict & Recommendation**
	- Provide PASS (ready), CONDITIONAL PASS (minor follow-ups), or FAIL (blocking issues) with rationale.

12. **Finalize & Output**
	- Generate Review Report (in-memory output only) following Mandatory Sections order.

## Mandatory Sections (Ordered)
1. Metadata & Inputs
2. Task File Summary
3. Change Scope (Files & Diff Summary)
4. Acceptance & Checklist Coverage Matrix
5. Quality & Test Evidence
6. Architecture & Pattern Conformance
7. Risk & Regression Analysis
8. Gate Evaluation Metrics
9. Gaps & Remediation Actions
10. Verdict & Recommendation
11. Assumptions & Limitations
12. Appendices (Evidence References, Version Pins, Design Tokens if used)

## Coverage Matrix Specification
Table columns: ID | Criterion / Checklist Item | Evidence (file:line / test / commit) | Status (Implemented | Partial | Missing) | Notes.

## Gate Evaluation Metrics (Same Baseline as Implementation Phase)
| # | Metric | Value | Source | Production Gate | Notes |
|---|--------|-------|--------|-----------------|-------|
| 1 | BuildSuccess | PASS/FAIL | (build log / CI) | MUST PASS | Build completes w/o errors |
| 2 | AllTestsPassed | PASS/FAIL | (test runner) | MUST PASS | 100% tests pass |
| 3 | RequirementsFulfilled | 0–100% | (coverage matrix calc) | = 100% | Acceptance + checklist coverage |
| 4 | SecurityClean | PASS/FAIL | (secret/vuln scan) | MUST PASS | No secrets / critical vulns |
| 5 | NoRegressions | PASS/FAIL | (diff + tests) | MUST PASS | Existing behavior intact |
| 6 | CodeQualityScore | 0–100 | (quality tool) | ≥ 70 | Analyzer/linter aggregate |
| 7 | TestCoverage | 0–100% | (coverage report) | ≥ 80% | Line/branch coverage |
| 8 | StaticAnalysisClean | PASS/FAIL | (static analysis) | MUST PASS | No critical/high issues |
| 9 | DocumentationComplete | PASS/FAIL | (doc diff) | MUST PASS | Docs/comments updated |
| 10 | ProductionSafe | PASS/FAIL | (review + tests) | MUST PASS | Error handling / logging present |
| 11 | OriginalCodeCompliance | PASS/FAIL | (diff inspection) | MUST PASS | Adapted, not verbatim external |

Metric Notes:
- All values measured; NA only with justification.
- If measurement data unavailable, classify as degraded and flag remediation.

## Success Criteria
- All Mandatory Sections present & ordered.
- 100% task acceptance & checklist items mapped (Implemented OR explicitly Partial/Missing with remediation).
- Each MUST PASS metric is PASS or appears under Gaps with blocking status.
- RequirementsFulfilled = 100% OR gap entries exist.
- No unaddressed critical/high static analysis issues.
- OriginalCodeCompliance validated (no unexplained large pasted blocks).
- Clear PASS / CONDITIONAL PASS / FAIL verdict with criteria.
- No placeholder tokens (TBD / ??? / placeholder / `$ARGUMENTS`).
 - Context detection compliance: expected vs detected reconciled (no MissingExpected without remediation; no UnjustifiedDetected); deviations justified.

## Error Handling

| Condition | Action | Status |
|-----------|--------|--------|
| Missing task file path | Abort; emit minimal metadata | `INPUT_MISSING` |
| Unreadable task file | Abort; report path & reason | `FATAL_TASK_IO` |
| Git diff unavailable | Continue; mark scope degraded | `DEGRADED_EXT_RES` |
| Missing supplemental doc | Continue; list under Limitations | `MISSING_OPTIONAL_DOC` |
| Metrics collection failure | Set metric NA w/ justification | `DEGRADED_METRIC` |
| Mandatory metric absent | Block verdict until populated | `MISSING_METRIC` |
| Gate fail w/o remediation | Mark report FAIL | `UNJUSTIFIED_GATE_FAIL` |

## Constraints
- Read-only: MUST NOT modify repository files.
- No dependency installation or build execution unless evidence already cached (simulate if uncertain).
- External access only via sanctioned MCP lookups.
- Deterministic ordering (alphabetical or semantic grouping; declare chosen rule).

## Output Formatting Rules
- Markdown only; level-2 headings for Mandatory Sections.
- Tables for matrices & metrics.
- File paths and code identifiers in backticks.
- No raw diffs exceeding 120 lines per block—summarize large diffs.
- Line length target ≤120 chars.

## Findings Classification
- Severity: Info | Minor | Moderate | Major | Critical.
- Provide remediation action + expected effort (S, M, L) per gap.

## Verdict Definitions
- PASS: All MUST PASS metrics pass; no Major/Critical unremediated issues.
- CONDITIONAL PASS: Minor / Moderate gaps with remediation tasks defined (no blocking issues).
- FAIL: Any blocking metric fails or Critical/Major gaps unresolved.

## Evaluation Criteria

| Category | Check | Pass Condition | Fail Trigger | Auto-Check / Heuristic |
|----------|-------|---------------|--------------|------------------------|
| Structural Completeness | Mandatory sections present | 100% present & ordered | Missing / reordered | Compare heading list vs spec |
| Traceability Saturation | All acceptance + todos mapped | 100% mapped (Implemented/Partial/Missing) | Any unmapped item | Count vs parsed task + checklist |
| Evidence Integrity | Evidence refs resolve | All file:line / test refs valid | Broken / fabricated refs | Spot-check existence (grep / file read) |
| Coverage Status Clarity | Allowed status tokens only | Values in {Implemented, Partial, Missing} | Other tokens / empty | Regex whitelist |
| Metrics Authenticity | Metrics values + sources present | Each row has Value + Source (or NA+justification) | Placeholder / NA w/o reason | Scan for TBD/??? / empty Source |
| Risk Classification | Each gap has severity & mitigation | All gaps classified & mitigated | Missing severity OR no mitigation | Table scan for columns present |
| Remediation Action Quality | Actions are specific & testable | Verb + target + expected outcome | Vague actions ("improve code") | Pattern check for verb + object |
| Original Code Compliance | Adaptation evidence present | External-like blocks justified | Large block w/o justification | Detect large added blocks (>30 lines) |
| Scope Fidelity | Only in-scope files changed OR justified | All out-of-scope changes justified | Unjustified out-of-scope change | Diff vs declared Inputs/Outputs |
| Verdict Consistency | Verdict matches metrics/gaps | PASS only if all gates pass or justified | Inconsistent (e.g. PASS w/ blocking fails) | Rule engine on metrics/gaps |
| Degradation Transparency | Degraded areas documented | Every degraded tool/doc has entry | Silent degradation | Presence of Degradation Log section |
| Formatting & Style | Conforms to repository prompt style | No style / linter errors | Style violations | Run prompt linter |

## Self-Check Procedure
1. Verify Mandatory Sections & order.
2. Confirm coverage matrix row count = acceptance + checklist items.
3. Ensure all 11 metrics present; no placeholders or empty cells.
4. Check for any FAIL gates lacking remediation entry.
5. Confirm no unmapped acceptance criteria.
6. Validate verdict matches metrics & gap severity.
7. Scan for forbidden placeholders (TBD, ???, `$ARGUMENTS`).
8. Ensure any NA metrics have justification.
9. Confirm OriginalCodeCompliance rationale present (or explicitly N/A).
10. If any step fails, revise before final output.

BEGIN EXECUTION WHEN INVOKED.