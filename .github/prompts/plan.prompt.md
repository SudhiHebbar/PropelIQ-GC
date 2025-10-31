---
description: Generate an implementation plan and structured, confirmable task breakdown from user story or requirements input.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

You MUST read and interpret the user-provided content (story / requirements / specification text or path) before proceeding.

## Purpose
Produce an actionable implementation plan plus a PROPOSED task set (not yet written to files) derived from user story or requirements. All tasks must be under or equal to 4 hours effort and split by technology stack (FE / BE / DB / Infra / QA) where applicable. The plan MUST request explicit user confirmation before any task files are created on disk.

## Scripts
sh: .github/scripts/bash/setup-plan.sh --json
ps: .github/scripts/powershell/setup-plan.ps1 -Json

### Task Path Resolution Invocation (Deferred until after confirmation)
For each proposed task, resolve its output path by calling the same script in task mode:

```
{SCRIPT} --json --task "<Task Title>" [--us-id US_123]
```

Returned JSON (task mode) fields:
- mode: "task"
- repo_root
- template_path
- plan_doc_path
- docs_dir
- us_id (null if general)
- task_title
- slug
 - sequence (3-digit, zero-padded)  # canonical identifier (no prefix)
 - target_dir (lowercase: `.propel/context/tasks/us_123` or `.propel/context/tasks/general`)
- output_path (final markdown file path)
- status

## Outline

1. **Setup:**
	- Run `{SCRIPT}` in init mode (no `--task`). Parse JSON: `repo_root`, `template_path`, `plan_doc_path`, `docs_dir`.
	- Confirm `docs_dir` exists. No task files created yet.
2. **Acquire & Classify Input:**
	- Determine if `$ARGUMENTS` is path, URL, raw text, or mixed spec; load or summarize accordingly.
3. **Load Supplemental Context:**
	- From `docs_dir` read `spec.md`, `design.md`, `codeanalysis.md` if present; summarize constraints & acceptance cues; record missing.
4. **Scan for Reuse Patterns:**
	- Identify analogous modules/services for reuse or pattern mirroring (list file paths).
5. **Resolve Framework Guidance:**
	- Resolve library IDs; fetch version-specific docs & API usage excerpts (Context7 MCP).
6. **Perform Deep Research:**
	- Sequential reasoning on performance, security, extensibility, pitfalls.
7. **Context Pattern Detection:**
	- Detect layers (frontend/backend/database/integration) & technologies; list ambiguities and potential risks.
	- Map detections to cross-cutting concerns emphasis (security, performance, accessibility, observability).
8. **Define Confirmation Gate Strategy:**
	- Prepare plan & tasks; insert confirmation block; defer file writes.
9. **Map Task Generation Blueprint:**
	- Build task blueprints referencing `task_template.md` (fields only).
10. **Segment Tasks by Stack:**
	- Categorize tasks FE / BE / DB / Infra / QA / Security / DevEx.
11. **Slice Effort Units:**
	- Ensure each task ≤4h; split & justify if larger.
12. **Integrate UI / Design Context:**
	- If UI impact: extract `designsystem.md`, Figma refs, tokens, accessibility & validation criteria.
13. **Build To-Do & Traceability:**
	- Create unchecked `[ ]` sub-step lists referencing original requirement lines.
14. **Describe Post-Confirmation Execution:**
	- Document deferred invocation of `{SCRIPT}` in task mode to materialize task files (not executed yet).

## Mandatory Sections (ordered)
1. Metadata & Inputs
2. Source Content Summary (Story / Requirements)
3. Supplemental Artifacts Summary (spec.md / design.md / codeanalysis.md / designsystem.md)
4. Design & UX Context (omit if no UI impact)
5. Technology & Framework Baseline (with resolved versions)
6. Similar Pattern & Reuse Analysis
7. Requirements Decomposition Table
8. Proposed Task Breakdown (≤4h units)
9. Cross-Cutting Concerns (Security, Performance, Observability, Accessibility)
10. Risks, Assumptions & Open Questions
11. Confirmation Gate Instructions
12. Appendices (Doc references, Version Pins)

## Requirements Decomposition Table
Provide table columns: ID | Requirement Snippet | Impacted Areas | Proposed Task Sequences | Notes.

## Task Blueprint Specification
Each proposed task entry MUST include:
- Sequence: `xxx` (three-digit, zero-padded; does NOT embed user story id)
- Title: concise imperative phrase
- Category: FE | BE | DB | Infra | QA | Security | DevEx
- Effort: hours (max 4)
- Dependencies: other task sequences or external preconditions
- Inputs: files / modules / services impacted
- Outputs: new/modified artifacts
- Acceptance Criteria: bullet list (clear, testable)
- Test Strategy: unit/integration/e2e outline
- Risks & Mitigations
 - ToDo Task Checklist: `[ ]` items representing concrete implementation sub-steps (NO checked boxes)
 - Design Context (if UI): tokens, components, accessibility, breakpoints

### Task Template Section Mapping
All blueprint fields MUST map to the concrete sections in `task_template.md` when materializing files:

| Template Section | Source / Mapping Logic |
|------------------|------------------------|
| Front Matter (name, description) | name = Task Title; description = one-line purpose/value proposition |
| Purpose | Concise narrative combining Title + primary outcome + success signal |
| Requirement Reference | us_id (or `(none)`), original source path/URL if available, acceptance criteria pointer |
| Task Overview | Expanded scope: what is in / out, relation to parent story |
| Dependent Tasks | Dependencies list (task sequences) |
| Tasks | Internal decomposition (NOT global multi-task table) |
| Current State | Snapshot of relevant files / modules before change (tree/diff summary) |
| Future State | Planned structure after change (new/modified paths) |
| Development Workflow | Ordered phases (e.g. scaffold -> logic -> tests -> docs -> hardening) |
| Data workflow | Entity / API / event flow (omit with note if N/A) |
| Impacted Components | Group Inputs/Outputs by layer stack (FE/BE/DB/etc.) |
| Implementation Plan (<Layer>) | Layer-specific actionable steps referencing files & test updates |
| References / External References | Version-pinned docs, internal file anchors |
| Implementation Validation Strategy | Lint, unit, integration, e2e, performance, accessibility criteria |
| ToDo Task | Checklist (all unchecked) mirroring decomposition atomic steps |

If a section is not applicable, include a single line: `_Not applicable for this task (reason)._` — never omit the heading.

Do NOT generate actual task files here—only the structured plan.

## Success Criteria
- Include all mandatory sections in required order
- Keep each task ≤4 hours (split & justify if larger)
- Map every requirement to at least one task
- Keep all task checkboxes unchecked (`[ ]` only)
- Resolve and list framework/library versions before referencing APIs
- Provide design tokens & validation criteria for any UI tasks
- Include explicit confirmation gate before any file creation instructions
- Categorize tasks by stack where applicable
- Show exact task-mode invocation for each proposed task
- Use lowercase directories under `tasks` (`us_<id>` or `general`) in examples
- Represent every `task_template.md` section or mark with justified `_Not applicable_`


## Error Handling

| Condition | Action | Status |
|-----------|--------|--------|
| Missing primary input | Emit Metadata & error note; abort | `INPUT_MISSING` |
| No resolvable frameworks | Continue; mark Version Pins as none | `NO_FRAMEWORKS` |
| Context7 unavailable | Mark impacted sections degraded; continue | `DEGRADED_EXT_RES` |
| Sequential Thinking MCP unavailable | Mark impacted sections degraded; continue | `DEGRADED_EXT_RES` |
| Missing supplemental docs | List under Limitations | `MISSING_OPTIONAL_DOCS` |

## Constraints
- Read-only; do NOT create or modify repository files in this phase.
- No external network calls except via sanctioned MCP resources (Context7, sequential thinking reasoning layer).
- Deterministic ordering: alphabetical or dependency precedence (document rule used).

## Output Formatting Rules
- Use level-2 headings for all sections.
- Tables for decomposition & tasks index.
- Wrap code or file paths in backticks.
- Keep line length target ≤120 chars.

## Version Pinning Protocol
1. Enumerate detected frameworks (e.g., React, .NET, Django, Express, EF Core, PostgreSQL).
2. Resolve library IDs via Context7 MCP.
3. Fetch minimal doc excerpts (APIs & conventions) and cite source.

## Confirmation Gate
> AWAITING USER CONFIRMATION: Reply YES to generate task files. Each task will resolve its path via `setup-plan` in task mode (no files exist yet). Reply NO to request revisions first.

## Assumptions
- Provided story/requirements are authoritative unless contradicted by spec.md.
- Unspecified non-functional requirements default to existing patterns found in codebase analysis.

## Final Notes
- Do NOT echo this prompt content.
- Produce a single cohesive plan document only.
- Ensure all proposed tasks remain in-memory until user confirms generation.
- After confirmation: invoke task mode per task, then render from `task_template.md` using returned `output_path`.

## Evaluation Criteria

| Category | Metric | Pass Condition | Fail Trigger | Auto-Check Hints |
|----------|--------|---------------|--------------|------------------|
| Structural Completeness | Mandatory sections present | 100% present & ordered | Missing/misordered section | Compare headings vs mandatory list |
| Consistency & Formatting | Style compliance | No style / lint errors | Style violations present | Run prompt linter |

Self-Check Procedure:
1. List headings & verify order.
2. Run linter; clear all hard failures.
3. Confirm no placeholder tokens remain (`$ARGUMENTS`, `${...}`).
4. Ensure confirmation gate appears exactly once.
5. If any fail trigger exists, revise prior to execution.

> Note: Task- and planning-specific evaluation metrics will be appended later when defined.

BEGIN EXECUTION WHEN INVOKED.