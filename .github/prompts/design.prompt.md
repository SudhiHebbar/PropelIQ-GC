---
description: Generate (but do not write until confirmation) a comprehensive design.md using design_template.md with deep research, validation loops, and scoring.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` may be a feature file path, user story text, spec excerpt, or left empty. If empty, fallback to existing `spec.md` and `codeanalysis.md`.

## Purpose
Produce a context-rich architectural & implementation design at `.propel/context/docs/design.md` using `.github/templates/design_template.md`, integrating internal codebase patterns, external library references, gotchas, validation strategies, and iterative improvement scoring. Do NOT overwrite an existing `design.md` wholesale—update only relevant sections after confirmation.

## Scripts
sh: .github/scripts/bash/setup-design.sh --json
ps: .github/scripts/powershell/setup-design.ps1 -Json

## Outline
1. **Environment Setup**
	- Invoke `{SCRIPT}`; parse JSON: `repo_root`, `docs_dir`, `templates_dir`, `timestamp_utc`, `agent_version`.
	- Resolve template: `design_template.md` (mandatory). Precompute target path: `${docs_dir}/design.md`. No writes.
2. **Input Acquisition & Classification**
	- Determine if `$ARGUMENTS` is: file path | direct text | empty.
	- File: read & normalize (markdown, text, limited length summary if >8000 chars).
	- Empty: mark `INPUT_EMPTY_FALLBACK` and proceed using `spec.md` + `codeanalysis.md`.
3. **Existing Artifact Loading**
	- Attempt to read: `${docs_dir}/spec.md`, `${docs_dir}/codeanalysis.md`, `${docs_dir}/design.md` (if present for incremental update strategy), `${docs_dir}/designsystem.md` (UI impact only).
	- Summarize each: key objectives, constraints, technology decisions, risks.
4. **UI Impact Detection (Conditional)**
	- Scan input + spec for Figma URLs, image assets, design tokens, accessibility keywords.
	- Set `ui_impact = true|false`. If true, plan inclusion of UI sections & validation criteria.
5. **Codebase Pattern Scan**
	- Enumerate representative modules (limit: 20) for controllers/services/components/entities.
	- Extract naming conventions, error handling, test patterns, dependency injection usage.
6. **External Library & Framework Research**
	- Resolve library IDs (Use Context7 MCP). Fetch minimal doc excerpts (APIs, version differences).
	- Capture constraints (deprecated APIs, performance caveats).
7. **Gotcha Loading Strategy**
	- Apply Conditional Gotcha Loading Strategy (see `copilot-instructions.md` / "Conditional Gotcha Loading Strategy").
	- Always include core set; add layer / technology / context sets only when their detection triggers fire (if layer ambiguous → include frontend + backend best practices by rule).
	- Produce a Gotchas Table (File | Category: Core/Layer/Tech/Context | Trigger | Mapped Task IDs | Mitigation Status).
	- Do NOT load technology-specific gotchas (React / .NET) without explicit detection evidence; treat any violation as a risk entry.
8. **Sequential Deep Reasoning Pass**
	- Use sequential-thinking MCP (if available) to evaluate design hypotheses: architecture layering → data flow → error boundaries → performance & scaling → security posture → testability.
	- Fallback: manual structured reasoning blocks.
9. **Design Template Mapping**
	- Populate template sections: Overview, Architecture Goals, Tech Stack, Style Guidelines (backend/frontend), Naming Conventions, Constraints, Workflow, Future Considerations.
	- Only update changed sections if `design.md` already exists (diff-aware approach).
10. **Implementation Blueprint Construction**
	- Provide pseudocode & file-level change plan (scaffold, logic, tests, docs, hardening).
11. **Validation Strategy Definition**
	- Lint, unit, integration, e2e, performance, security, accessibility (conditional), visual regression (if UI).
12. **Risk & Trade-off Analysis**
	- Table: ID | Area | Risk | Impact | Mitigation | Residual.
13. **Design Quality Scoring Prep**
	- Criteria: Relevance, Correctness, Coherence, Conciseness, Completion, Factfulness, Confidence, Harmfulness.
	- Define scoring method (objective signals + subjective evaluation). No scores yet.
14. **Confirmation Gate (Pre-Write)**
	- Present complete proposed design content (or diff for existing) + planned scores.
	- Await explicit YES before writing or updating `design.md`.
15. **File Materialization (Post-Confirmation)**
	- Write or selectively update sections. Preserve unaffected legacy content.
16. **Scoring & Iterative Improvement Loop (Post-Write)**
	- Compute scores; if any <80% trigger sequential reasoning improvement cycle; update sections.
17. **Finalization**
	- Summarize changes, list improvement cycles, record timestamp & version.

## Mandatory Sections (Ordered)
1. Metadata & Input Summary
2. Existing Artifacts Summary
3. UI Impact & Design Context (omit with note if none)
4. Codebase Pattern & Convention Summary
5. External Libraries & Version Pins
6. Gotchas & Constraints Overview
7. Architecture Goals & Rationale
8. Technology Stack & Validation
9. Style & Naming Guidelines
10. Implementation Blueprint
11. Validation & Quality Strategy
12. Risk & Trade-off Register
13. Future Considerations
14. Confirmation Gate Instructions
15. Post-Confirmation Actions & Scoring Plan
16. Assumptions & Limitations
17. Appendices (Doc excerpts, file lists, gotcha triggers)

## Success Criteria
- All mandatory sections present & ordered.
- UI impact correctly detected & contextual sections included or omitted with justification.
- Library version pins resolved (or degraded status noted).
- Pseudocode & file-level blueprint actionable & aligned with conventions.
- Validation strategy covers functional, non-functional, and UI (if applicable).
- Risks include mitigation & residual state.
- Confirmation gate present exactly once before any write.
- Existing design diff produced if design.md already exists.
- Scores computed post-write; improvement loop executed for any <80%.

## Error Handling
| Condition | Action | Status |
|-----------|--------|--------|
| Missing input & no spec/codeanalysis | Abort after metadata | `INPUT_MISSING` |
| Unreadable feature file | Continue with fallback spec; flag | `FATAL_INPUT_IO` |
| Library resolution failure | Continue; mark degraded | `DEGRADED_EXT_RES` |
| Sequential thinking unavailable | Use fallback reasoning | `DEGRADED_REASONING` |
| Missing mandatory section draft | Halt before gate | `STRUCTURE_INCOMPLETE` |
| Existing design present but diff failure | Switch to full rewrite plan | `DIFF_DEGRADED` |

## Constraints
- Read-only until confirmation.
- Minimal external calls (only sanctioned research tools / library docs).
- Line length ≤120 chars.
- Deterministic table ordering.

## Output Formatting Rules
- Use level-2 headings for all mandatory sections.
- Tables for risks, version pins, gotchas.
- Wrap file paths in backticks.
- Use `_Not applicable (reason)._` for omitted conditional sections.
- No placeholder tokens (`$ARGUMENTS`) remain in final output.

## Confirmation Gate (Exact Text)
AWAITING USER CONFIRMATION: Reply YES to write or update design.md. Reply NO to refine or adjust sections first.

## Design Quality Scoring Table (Post-Write)
| Metric | Score | Threshold | Notes |
|--------|-------|----------|-------|
| Relevance | n/a | ≥80 | Alignment with requirements |
| Correctness | n/a | ≥80 | Technical accuracy |
| Coherence | n/a | ≥80 | Logical structure |
| Conciseness | n/a | ≥80 | Avoids unnecessary verbosity |
| Completion | n/a | ≥80 | Coverage of mandatory sections |
| Factfulness | n/a | ≥80 | Verifiable statements |
| Confidence | n/a | ≥80 | Author certainty & validation evidence |
| Harmfulness | n/a | MUST=No | No harmful content |

## Self-Check Procedure
1. Verify mandatory section headings & order.
2. Confirm UI impact determination & conditional sections correctness.
3. Ensure version pins resolved or degraded noted.
4. Validate blueprint references existing patterns.
5. Confirm single confirmation gate occurrence.
6. Ensure no placeholders left.
7. After confirmation & write: populate scoring table; remediate low scores.

DO NOT include this prompt content inside generated design.md.

BEGIN EXECUTION WHEN INVOKED.