---
description: Execute repository analysis workflow and generate codeanalysis.md using the analyze template.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

You MUST consider the user input before proceeding (if not empty).

## Scripts
sh: .github/scripts/bash/setup-analyze.sh --json
ps: .github/scripts/powershell/setup-analyze.ps1 -Json

## Outline

1. **Setup:**
   - Invoke `{SCRIPT}` exactly as listed (do not derive or hard-code absolute filesystem paths).
   - Parse JSON for: `template_path`, `output_path`.
   - Enforce no extra flags beyond `--json` / `--help`.
2. **Validate Repository Root:**
   - If no input: set ROOT_FOLDER = repo root excluding `.github`, `.vscode`, `.propel`.
   - If path provided: verify existence & readability; adopt as ROOT_FOLDER.
   - List top-level entries (summarize if >500).
   - If inaccessible: emit minimal metadata + `FATAL_REPO_ACCESS` then abort.
3. **Detect Technologies:**
   - Scan for language/framework/build markers (package managers / config files).
   - Rank languages by file count; select `primary_language` (break ties by highest count heuristic).
4. **Build Context Package:**
   - Assemble object: root_folder, detected_languages, primary_language, frameworks, build_tools, analysis_depth, time_budget_minutes, focus_areas, include_tests, ignore_paths, timestamp_utc, agent_version.
   - Persist for downstream steps.
5. **Run Parallel Analyses:**
   - Architecture scan (layering, boundaries, coupling hotspots).
   - Best practices compliance (Context7 MCP).
   - Sequential reasoning pass (patterns / anti-patterns & remediation logic).
   - Technical debt classification (structural, quality, dependency, testing, security).
   - Pattern vs anti-pattern matrix assembly.
6. **Modulate Depth:**
   - comprehensive: add ASCII architecture diagram, risk scoring vector, remediation priority ordering.
   - standard: high-level module map only.
   - quick: condensed bullet sections; still include mandatory headings.
7. **Generate Report:**
   - Populate `${output_path}` using `${template_path}`; maintain ordering & formatting rules.
   - Expand all placeholders deterministically.
8. **Finalize & Summarize:**
   - Compute counts: patterns_found, anti_patterns_found, debt_items.
   - Append summary & ensure idempotent overwrite.

## Mandatory Sections
1. Metadata & Parameters
2. Repository Overview
3. Architecture Analysis
4. Patterns & Anti-Patterns
5. Technical Debt Register
6. Best Practices Compliance
7. Risk & Priority Assessment
8. Recommended Remediation Roadmap
9. Assumptions & Limitations
10. Appendices

## Success Criteria
- Include all mandatory sections in specified order
- Provide remediation guidance for every anti-pattern
- Detect at least one primary language
- Avoid unresolved fatal validation errors
- Expand all template placeholders

## Error Handling

| Condition | Action | Status |
|-----------|--------|--------|
| Missing ROOT_FOLDER | Emit Metadata section; abort | `FATAL_REPO_ACCESS` |
| Unreadable files | Continue; list under Limitations | `NON_FATAL_IO` |
| MCP unavailable | Mark affected sections degraded; continue | `DEGRADED_EXT_RES` |

## Constraints
- Read-only analysis (no code mutations).
- Do not execute build or dependency install unless explicitly allowed.
- External network only via sanctioned MCP lookups.
- Deterministic ordering (alphabetical or priority rank rationale documented).

## Output Format Rules
- Markdown only; use level-2 headings ## for sections.
- Tables for matrices & debt.
- Line length target ≤120 chars.

## Scoring Guidelines
- Impact: Low | Moderate | High | Critical.
- Priority = Impact × Frequency (define scale in appendix).

## Assumptions
- Primary language = highest file count when tie.
- Test coverage N/A if no test indicators detected.

## Finalization
Overwrite `${output_path}` atomically. Provide concluding metrics & timestamp.

DO NOT include this prompt content inside the generated report.

## Evaluation Criteria

| Category | Metric | Pass Condition | Fail Trigger | Auto-Check Hints |
|----------|--------|---------------|--------------|------------------|
| Structural Completeness | Mandatory sections present | 100% present & ordered | Missing or misordered section | Compare headings vs mandatory list |
| Consistency & Formatting | Style compliance | No style / lint errors | Style violations detected | Run prompt linter |

Self-Check Procedure:
1. Enumerate produced headings; verify full mandatory list & order.
2. Run linter; resolve any reported errors.
3. Confirm no placeholder tokens remain (`$ARGUMENTS`, `${output_path}`, `${template_path}`).
4. Ensure every anti-pattern lists a remediation line.
5. If any fail trigger detected, revise before execution.

> Note: Additional analysis-specific evaluation metrics may be appended later.

BEGIN EXECUTION WHEN INVOKED.