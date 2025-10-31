---
description: Generate a comprehensive bug triage analysis and a PROPOSED set of fix tasks (not yet written) with validation criteria and confirmation gating.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` may be a bug report file path, URL, raw error description, or log snippet. Must contain enough detail to attempt reproduction.

## Purpose
Perform deep bug triage (reproduction, root cause, impact, priority, solution exploration) and produce a structured set of PROPOSED bug fix tasks (each ≤4h) without writing any task files until explicit confirmation. All tasks will align with `.github/templates/triage_template.md` when materialized.

## Scripts
sh: .github/scripts/bash/setup-bugfix.sh --json
ps: .github/scripts/powershell/setup-bugfix.ps1 -Json

## Outline

1. **Environment Setup**
	- Invoke `{SCRIPT}`; parse JSON: `repo_root`, `tasks_root`, `docs_dir`, `timestamp_utc`, `agent_version`.
	- Establish working context (no writes yet beyond environment script side-effects).
2. **Input Classification**
	- Determine input type: File | URL | Raw Text.
	- Extract candidate bug ID patterns using examples: bug_123 bug_4567 bug_7890 project-321 (3–5 digit identifiers). Avoid raw regex and prefer lowercase.
	- Normalize any uppercase forms (BUG_, ISSUE_, PROJECT-) to lowercase `bug_` or ticket style before directory planning.
	- If no bug ID found, note fallback usage (root tasks directory).
3. **Content Acquisition & Normalization**
	- Read file or fetch URL content (if tooling allows; else mark `DEGRADED_EXT_RES`).
	- Normalize whitespace, extract reproduction steps, environment markers, error traces.
4. **Preliminary Reproduction Plan**
	- Identify steps to attempt reproduction (commands, data, configuration).
	- Flag missing reproduction info if insufficient → status `REPRO_INFO_INCOMPLETE` (request augmentation).
5. **Codebase Scanning**
	- Grep for key error strings, stack function names, or failing module references.
	- List candidate files (up to top 20) ranked by match density.
6. **Root Cause Sequential Reasoning**
	- Use sequential-thinking MCP (if available): trace suspected flow, enumerate alternative hypotheses.
	- Produce Root Cause Matrix: Hypothesis | Evidence | Confidence (Low/Med/High) | Validation Step.
7. **Impact Assessment**
	- Users/flows affected, data integrity, performance, security implications.
	- Severity classification: Critical | High | Medium | Low (with rationale).
8. **Regression & Similar Issues Scan**
	- Check git history for recent changes touching suspect files.
	- Note related or duplicate bugs if patterns match.
9. **Solution Option Exploration**
	- List ≥2 candidate fix approaches. For each: Pros | Cons | Complexity | Regression Risk | Rollback Strategy.
	- Select preferred approach with rationale.
10. **Framework & Library Research (Conditional)**
	 - Resolve library IDs; fetch version docs for APIs used in solution plan (Use Context7 MCP).
	 - Record relevant patterns & constraints; mark degraded if unavailable.
11. **Risk Register Draft**
	 - Each open risk: ID | Description | Severity | Mitigation | Residual.
12. **Proposed Fix Task Blueprint Generation**
	 - Slice preferred solution into tasks ≤4h each.
	 - Map each task to Root Cause Matrix items & impacted components.
13. **Task Blueprint Specification**
	 - For each proposed task (do not write files): Task ID placeholder (e.g., T001), Title, Category (Code / Tests / Docs / Infra / Security), Effort (h), Dependencies, Inputs, Outputs, Acceptance Criteria, Validation Strategy, Rollback Steps, Risk References.
14. **Directory & Naming Plan**
	 - If bug ID present → planned folder: `.propel/context/tasks/<canonical_id>/` (always lowercase, e.g., `bug_123/`).
	 - Normalize extracted IDs: convert `ISSUE_123`, `BUG-123`, `ISSUE-456` => `bug_123`, `bug_456`.
	 - Else fallback folder: `.propel/context/tasks/`.
	 - Filename pattern: `task_<seq>_fix_<slug>.md` (underscore separator; seq 3-digit zero-padded).
15. **Confirmation Gate (Pre-Materialization)**
	 - Present triage summary + task blueprints. Await YES before calling setup script in task-like mode (future) & writing task files.
16. **Post-Confirmation Execution Plan (Description Only)**
	 - Outline next steps once confirmed: materialize tasks, implement fixes, run regression tests.

## Mandatory Sections (Ordered)
1. Metadata & Input Summary
2. Bug ID & Classification
3. Reproduction Plan & Status
4. Evidence & Codebase Scan Summary
5. Root Cause Matrix
6. Impact & Severity Assessment
7. Regression & History Notes
8. Solution Options Comparison
9. Preferred Solution Rationale
10. Framework & Library Research (omit with note if none)
11. Risk Register
12. Proposed Fix Task Blueprints
13. Directory & Naming Plan
14. Confirmation Gate Instructions
15. Post-Confirmation Execution Plan
16. Assumptions & Limitations
17. Appendices (Logs, Matches, References)

## Root Cause Matrix Format
| Hypothesis | Evidence | Confidence | Validation Step |
|------------|----------|------------|-----------------|

Confidence scale: Low (<40%), Medium (40–70%), High (>70%).

## Task Blueprint Required Fields
| Field | Description |
|-------|-------------|
| Task ID | Placeholder format TXXX (zero-padded assigned on materialization) |
| Title | Imperative concise fix objective |
| Category | Code / Tests / Docs / Infra / Security |
| Effort | Hours (≤4) |
| Dependencies | Other task IDs or prerequisites |
| Inputs | Files / modules affected |
| Outputs | New/modified artifacts |
| Acceptance Criteria | Clear, testable outcomes |
| Validation Strategy | Tests, static analysis, manual checks |
| Rollback Steps | Reversion method & checkpoints |
| Risk References | IDs linking to Risk Register entries |
| Root Cause Link | Hypothesis IDs or evidence references |

## Success Criteria
- All mandatory sections present & ordered.
- At least one reproducible path or explicit reproduction gap flagged.
- ≥2 solution options evaluated with comparative table or structured list.
- Preferred solution includes rollback strategy.
- Each task blueprint ≤4h and maps to root cause elements.
- Risks have severity + mitigation.
- Confirmation gate appears exactly once before any file write instructions.
- No placeholder tokens left (`$ARGUMENTS`).

## Error Handling
| Condition | Action | Status |
|-----------|--------|--------|
| Missing input | Abort after metadata | `INPUT_MISSING` |
| Unreadable file | Abort; request alternative | `FATAL_INPUT_IO` |
| Insufficient reproduction info | Request augmentation | `REPRO_INFO_INCOMPLETE` |
| No root cause hypotheses | Prompt for logs / more detail | `NO_HYPOTHESES` |
| Library resolution failure | Continue; mark degraded | `DEGRADED_EXT_RES` |
| Missing mandatory section draft | Halt; fix before gate | `STRUCTURE_INCOMPLETE` |

## Constraints
- Read-only until confirmation (no task file creation).
- Minimal external calls; only sanctioned research tools.
- Deterministic ordering; stable headings.
- Keep line length ≤120 chars.

## Output Formatting Rules
- Level-2 headings for all major sections.
- Tables for matrices (root cause, tasks, risks).
- Wrap file paths in backticks.
- Use `_Not applicable (reason)._` for omitted conditional sections.

## Confirmation Gate (Exact Text)
AWAITING USER CONFIRMATION: Reply YES to generate bug fix task files. Reply NO to refine triage or blueprints first.

## Self-Check Procedure
1. Verify mandatory section headings and order.
2. Ensure Root Cause Matrix populated or gap reason stated.
3. Confirm ≥2 solution options.
4. Validate each blueprint has all required fields.
5. Check risks include severity + mitigation.
6. Confirm confirmation gate present once.
7. Ensure no unresolved placeholders.

DO NOT include this prompt content inside generated task files.

BEGIN EXECUTION WHEN INVOKED.