---
description: Generate (but do not write until confirmation) comprehensive user stories from epics / scope using userstory-template.md (base user story template) with Sequential Thinking MCP and Context7 MCP research.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

Possible `$ARGUMENTS` forms (choose one):
- scope file path + epic ID
- scope file path only
- epic ID only (format EP-NNN)
- epic URL
- direct feature text
- empty (fallback: `.propel/context/docs/spec.md`)

## Purpose
Produce a set of PROPOSED user stories (INVEST, independent, testable) without writing files until explicit confirmation. Apply Sequential Thinking MCP for decomposition reasoning and Context7 MCP for framework/library reference enrichment. Output a structured preview including sizing, acceptance criteria, dependencies, and traceability back to epics & requirements.

## Scripts
sh: .github/scripts/bash/setup-userstory.sh --json
ps: .github/scripts/powershell/setup-userstory.ps1 -Json

## Outline
1. **Environment Setup**
	- Invoke `{SCRIPT}`; parse JSON: `repo_root`, `docs_dir`, `spec_path`, `stories_root`, `template_path`, `timestamp_utc`, `agent_version`, `next_seq_padded`, `next_id`, `stories_dir_pattern`, `file_basename_pattern`, `legacy_unpadded_detected`.
	- Verify `spec_path` existence (unless direct text provided). No writes.
2. **Input Classification**
	- Detect mode: MULTI_EPIC | SINGLE_EPIC | SCOPE_FILE | SCOPE_FILE_EPIC | DIRECT_TEXT | EPIC_URL | FALLBACK_SPEC.
	- Record chosen mode; set processing strategy.
3. **Source Acquisition & Normalization**
	- Read scope file or spec; for PDF/DOCX apply normalization; for URL fetch content (if allowed) else mark `DEGRADED_EXT_RES`.
	- Trim whitespace; extract epic blocks (EP-### headings or pattern matches).
4. **Epic Resolution & Filtering**
	- If epic ID specified → isolate that epic only; else collect all epics.
	- Abort with `EPIC_NOT_FOUND` if requested epic absent.
5. **Requirements & Context Extraction**
	- Parse mapped requirement IDs under each epic (FR-, NFR-, TR-, DR-, UXR-).
	- Build Requirements→Epic map; flag unreferenced requirements if any.
6. **Sequential Thinking Decomposition (Mandatory)**
	- Use Sequential Thinking MCP to reason: goal → capabilities → user intents → minimal value slices → edge cases → dependency ordering.
	- Produce decomposition log; fallback to structured reasoning with numbered steps if MCP unavailable (`DEGRADED_REASONING`).
7. **Story Draft Generation (Pass 1)**
	- For each capability slice create provisional story: ID placeholder, Title, Value Statement (As a <actor> I want <action> so that <outcome>).
8. **Context7 Library Enrichment (Conditional)**
	- Resolve library IDs (Context7 MCP) for tech referenced in requirements (e.g., auth framework, UI lib, ORM).
	- Attach doc excerpt citations to stories that depend on specific APIs (mark degraded if lookup fails).
9. **Story Sizing & Effort Calibration**
	- Assign story points (1–5) referencing complexity & risk; convert to estimated hours (1 point = 6h).
	- If >20h equivalent ( >~3 points over threshold rationale ) → split into smaller stories with dependency chain.
10. **Acceptance Criteria Construction**
	- Use Given / When / Then format; minimum 3 criteria per story (functional, validation, edge case).
	- For UI stories add accessibility & visual criteria (if UI impact derived from requirements).
11. **Dependency & Ordering Analysis**
	- Build DAG of story dependencies (no cycles). Detect and remediate cycles → break into clearer prerequisites (`CYCLIC_DEP_RESOLVED`).
12. **Risk & Edge Case Annotation**
	- For each story list top risks (technical, performance, security) + mitigation.
13. **Traceability Matrix Assembly**
	- Table: Requirement ID | Epic ID | Story IDs | Notes (ambiguity or partial coverage).
14. **Quality Gate Pre-Checks**
	- Validate INVEST, independence, atomic acceptance criteria, coverage completeness.
15. **Confirmation Gate (No Writes Yet)**
	- Present story decomposition table + traceability + sample story markdown skeletons.
16. **File Generation Plan (Post-Confirmation)**
	- On YES: create directory `.propel/context/tasks/us_<next_seq_padded>/` (from `stories_dir_pattern`) or reuse if existing; write `us_<next_seq_padded>_<slug>.md` (from `file_basename_pattern`) using `userstory-template.md`.
	- If `legacy_unpadded_detected` is true, recommend migration to zero-padded directories.
	- On NO: gather refinement instructions and re-run decomposition.
17. **Post-Write Quality Scoring Loop (Description Only)**
	- Metrics: Coverage %, Average Points, Independence Pass %, Acceptance Criteria Density, Risk Mitigation Completeness.
18. **Finalization Summary (Planned)**
	- Summarize counts: stories, total points, coverage %, high-risk stories.

## Mandatory Sections (Ordered)
1. Metadata & Input Summary
2. Processing Mode & Epic Resolution
3. Requirements Mapping Summary
4. Decomposition Reasoning Log
5. Story Decomposition Table
6. Story Sizing & Effort Rationale
7. Acceptance Criteria Drafts
8. Dependencies & Ordering
9. Risks & Mitigations
10. Traceability Matrix
11. Quality Gate Checklist
12. Confirmation Gate Instructions
13. Assumptions & Limitations
14. Appendices (Source excerpts, library doc citations)

## Story Decomposition Table Format
| Story ID (placeholder) | Title | Points | Dependencies | Risk Level | Coverage Tags |
|------------------------|-------|--------|--------------|-----------|---------------|

## Success Criteria
- Correct mode detection & epic filtering.
- Every clear requirement maps to ≥1 story.
- No story exceeds 5 points (hours may be preview-only, not written).
- Acceptance criteria use consistent Given/When/Then (or edge-case justification when pattern not applicable).
- Dependencies acyclic; ordering deterministic.
- Traceability Matrix complete (no orphan requirements).
- Confirmation gate present exactly once before any write.
- Sequential Thinking MCP used (or degraded fallback noted).
- Context7 enrichment attached for library-dependent stories (or degraded note).
- No placeholder tokens (`$ARGUMENTS`) remain.

## Error Handling
| Condition | Action | Status |
|-----------|--------|--------|
| Missing input & spec absent | Abort with guidance | `INPUT_MISSING` |
| Requested epic not found | Abort; list available epics | `EPIC_NOT_FOUND` |
| Scope file unreadable | Abort; request alternate | `FATAL_SCOPE_IO` |
| Text too brief (<50 chars) | Request augmentation | `INPUT_TOO_BRIEF` |
| No epics discovered | Abort; advise spec generation | `NO_EPICS` |
| Library resolution failure | Continue; mark degraded | `DEGRADED_EXT_RES` |
| Sequential thinking unavailable | Fallback reasoning; mark | `DEGRADED_REASONING` |
| Cyclic dependencies detected | Attempt auto-break; if fail abort | `CYCLIC_DEP_UNRESOLVED` |
| Mandatory section missing | Halt before gate | `STRUCTURE_INCOMPLETE` |

## Constraints
- Read-only until confirmation.
- No story files created pre-gate.
- External access limited to sanctioned MCP (Sequential Thinking, Context7 doc fetch).
- Deterministic ordering (Story ID ascending).
- Line length ≤120 chars.

## Output Formatting Rules
- Level-2 headings for mandatory sections.
- Tables for decomposition & traceability.
- Backticks around file paths and IDs.
- `_Not applicable (reason)._` for conditional omissions.

## Confirmation Gate (Exact Text)
AWAITING USER CONFIRMATION: Reply YES to generate user story files (padded ID format: `US_<next_seq_padded>`). Reply NO to refine story decomposition or criteria first.

## Self-Check Procedure
1. Validate mode & epic resolution correctness.
2. Ensure decomposition log present (MCP or fallback).
3. Confirm traceability coverage (no orphan requirements).
4. Verify dependency graph acyclic.
5. Check acceptance criteria completeness per story.
6. Confirm single confirmation gate.
7. Remove remaining placeholders (including any unpadded ID variants).

DO NOT include this prompt content inside generated user story files.

BEGIN EXECUTION WHEN INVOKED.