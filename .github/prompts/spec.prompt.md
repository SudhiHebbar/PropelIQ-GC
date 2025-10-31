---
description: Generate (but do not write until confirmation) a comprehensive spec.md (and conditional designsystem.md) from a scope file or direct text using requirement_base template with deep multi-phase analysis.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

You MUST read, classify, and process the user input before any requirement authoring. No file writes until explicit confirmation.

## Scripts
sh: .github/scripts/bash/setup-spec.sh --json
ps: .github/scripts/powershell/setup-spec.ps1 -Json

## Purpose
Transform a scope (file path or direct text) into a comprehensive, business‑aligned, technically feasible specification at `.propel/context/docs/spec.md` (primary) and, only if UI impact exists, `.propel/context/docs/designsystem.md`. Base all authored requirement sections on `.github/templates/spec_template.md` (and `.github/templates/design_system_template.md` if present for UI design). Maintain strict traceability, testability, and confirmation gating.

## Outline

1. **Setup & Environment Bootstrap**
	- Run `{SCRIPT}`; parse JSON: `repo_root`, `docs_dir`, `templates_dir`, `timestamp_utc`, `agent_version`.
	- Resolve template paths: `spec_template.md` (mandatory), `design_system_template.md` (optional).
	- Precompute target output paths: `${docs_dir}/spec.md`, `${docs_dir}/designsystem.md` (conditional).
	- No writes.

2. **Input Acquisition & Classification**
	- Determine if `$ARGUMENTS` is:
	  - File path (extensions: .pdf .txt .md .docx).
	  - Direct text (no recognized extension).
	- Validate:
	  - Missing → status `INPUT_MISSING` (abort after metadata).
	  - Non-existent/unreadable file → `FATAL_INPUT_IO`.
	  - Text/content < 25 non-space chars → `INPUT_TOO_BRIEF` request augmentation.

3. **Content Extraction & Normalization**
	- File:
	  - Read via allowed tools (no extra flags).
	  - PDF: strip headers/footers; preserve list semantics.
	  - DOCX: flatten styles; convert tables to markdown if feasible.
	- Direct text: trim & normalize whitespace.
	- Produce raw scope text + length metrics + detected domain/technology/UI/compliance keywords.

4. **UI Impact & Design Asset Detection (Conditional)**
	- Detect presence of Figma URLs (`figma.com/file/`, `figma.com/proto/`), image assets (`.png .jpg .jpeg .svg .sketch`), UI terms (screen, mockup, component, responsive, accessibility, WCAG).
	- If found → flag `ui_impact = true`; enumerate assets; plan `designsystem.md`.
	- If assets referenced but inaccessible → add risk `DESIGN_ASSET_MISSING`.

5. **Repository / Codebase Context Scan**
	- Enumerate top-level dirs excluding `.github`, `.vscode`, `.propel`.
	- Detect technology markers: `package.json`, `pyproject.toml`, `requirements.txt`, `pom.xml`, `Cargo.toml`, `.csproj`, `Dockerfile`, `docker-compose.yml`, infrastructure manifests, test directories.
	- Identify architecture patterns (layered, modular monolith, services) and constraints (DB engines, cloud hints).
	- If no code detected (greenfield) plan epic `EP-TECH`.

6. **Gotcha Loading Strategy**
	- Apply Conditional Gotcha Loading Strategy (see `copilot-instructions.md` / "Conditional Gotcha Loading Strategy").
	- Always include core set; add layer / technology / context sets only when their detection triggers fire (if layer ambiguous → include frontend + backend best practices by rule).
	- Produce a Gotchas Table (File | Category: Core/Layer/Tech/Context | Trigger | Mapped Task IDs | Mitigation Status).
	- Do NOT load technology-specific gotchas (React / .NET) without explicit detection evidence; treat any violation as a risk entry.

7. **Deep Requirements Analysis (Use Sequential Thinking MCP)**
	1. Business Context & Objectives (stakeholders, goals, KPIs, value hypotheses).
	2. Personas & Journeys (actors, pain points, primary flows, edge scenarios).
	3. Functional Domain Modeling (capability clusters, invariants, state transitions).
	4. Non-Functional Requirements (performance, reliability, security, scalability, observability, compliance, accessibility (if UI)).
	5. Data Requirements (entities, relationships, retention, integrity, migration strategy).
	6. Technical Architecture Feasibility (alignment with detected stack & constraints).
	7. Integration / External Systems (APIs, auth flows, event streams).
	8. Risk & Mitigation Matrix (top 10 severity-ranked).
	9. Constraints & Assumptions Validation.
	10. Hidden / Implicit Requirement Surfacing (derive from context and gaps).

	- Use sequential-thinking tool if available; fallback to structured internal stepwise reasoning if degraded (ensure parity of depth).

8. **Requirements Authoring & ID Governance**
	- Prefixes & format: FR-, NFR-, TR-, DR-, UXR- (zero-padded: FR-001).
	- Testability: each clear requirement has acceptance criteria or validation reference.
	- Ambiguity: tag `[UNCLEAR]` → exclude from Epics & Traceability; aggregate in Clarification Queue.
	- Cross-reference to avoid duplication (e.g., “See NFR-004 for latency baseline”).
	- Maintain internal uniqueness set; abort composition if collision detected (should not occur).

9. **Epic Construction**
		- IDs: EP-NNN (sequential zero-padded, e.g., EP-001).
	- Each epic: Title | Description | Mapped Requirement IDs | Business Value | Dependencies | Success Metrics.
	- Cap mapped requirement IDs ≈ 12 unless rationale given.
	- Include `EP-TECH` when scaffolding/greenfield or foundational platform tasks required.

10. **Traceability Matrix Assembly**
	 - Table: Requirement ID | Epic ID | Category | Validation Type (Test/Review/Metric) | Notes.
	 - Every non-ambiguous requirement appears exactly once (exceptions for shared security/logging patterns flagged).

11. **Risks, Constraints, Assumptions Enumeration**
	 - Risks: ID | Description | Category | Impact | Likelihood | Mitigation | Residual.
	 - Constraints: ID | Constraint | Source | Implication.
	 - Assumptions: ID | Assumption | Validation Strategy | Risk if False.

12. **Spec Quality Assessment (Draft)**
	 - Score (0–100%) with rationale:
		- Business Alignment
		- Requirements Completeness
		- Technical Accuracy
		- Clarity & Precision
		- Testability
		- Stakeholder Coverage
		- Risk Management
		- Implementation Readiness

13. **Confirmation Gate (No Writes Yet)**
	 - Present full draft preview (excluding raw prompt).
	 - Show explicit block:
		AWAITING USER CONFIRMATION: Reply YES to write spec.md (and designsystem.md if applicable). Reply NO to revise or clarify first.
	 - On YES proceed to file generation; on NO gather clarifications and iterate.

14. **File Generation (Post-Confirmation Only)**
	 - Render `spec.md` with mandated section order.
	 - If `ui_impact = true` render `designsystem.md` (component tokens, assets, accessibility mapping).
	 - Overwrite atomically (no partial writes). Provide summary counts (diff not required beyond metrics).

15. **Completion Summary**
	 - Emit summary object: counts (FR/NFR/TR/DR/UXR), Epics, Risks, Ambiguities, UI Impact (Y/N).

## Mandatory Sections (spec.md Order)
1. Executive Summary
2. Business Context & Objectives
3. Stakeholder & Persona Analysis
4. User Journey Overview
5. Scope & Out-of-Scope Items
6. Functional Requirements (FR)
7. Non-Functional Requirements (NFR)
8. Technical Requirements (TR)
9. Data Requirements (DR)
10. UX / UI Requirements (UXR) (omit if no UI impact; include explicit “No UI Impact” note)
11. Backlog Clarification Queue ([UNCLEAR] items)
12. Epics
13. Traceability Matrix
14. Architecture & Integration Considerations
15. Data Model Overview
16. Security & Compliance
17. Performance & Scalability
18. Observability & Monitoring
19. Accessibility (UI only or omission note)
20. Risks & Mitigations
21. Constraints
22. Assumptions
23. Implementation Roadmap & Phasing
24. Success Metrics & KPIs
25. Spec Quality Assessment
26. References & External Docs
27. Appendix (Diagrams / Extended Notes)

## Mandatory Sections (designsystem.md, if UI Impact)
1. Overview & Scope
2. Design Assets Inventory
3. Color Tokens
4. Typography Tokens
5. Spacing & Layout Scale
6. Components Catalog (ID | Name | Purpose | States | Accessibility)
7. Interaction Patterns
8. Responsive Breakpoints & Rules
9. Accessibility Requirements (WCAG mapping)
10. Asset Mapping to Future User Stories
11. Open Design Questions

## Success Criteria
- 100% Mandatory Sections present & ordered (conditional sections properly noted).
- Unique zero-padded IDs; no collisions.
- All non-ambiguous requirements have acceptance criteria or validation linkage.
- Every clear requirement appears in Traceability Matrix (1 row each, documented exceptions).
- `[UNCLEAR]` requirements only in Clarification Queue (not in epics or traceability).
- Epics contain success metrics & mapped requirement IDs.
- Quality Assessment table populated (no placeholders).
- No file writes prior to explicit YES confirmation.
- `designsystem.md` only if UI impact flagged.
- Gotchas Table present if any conditional gotchas loaded; absence justified otherwise.
- Risk severities include impact & likelihood qualifiers.
- Greenfield scenario includes EP-TECH epic.

## Error Handling

| Condition | Action | Status |
|-----------|--------|--------|
| Missing input | Emit metadata + request input; abort | `INPUT_MISSING` |
| Unreadable file | Emit stub + abort | `FATAL_INPUT_IO` |
| Extraction failure (PDF/DOCX) | Request alternate format | `EXTRACTION_FAILED` |
| Text too brief | Request augmentation | `INPUT_TOO_BRIEF` |
| No derivable requirements | Ask for elaboration | `INSUFFICIENT_SCOPE` |
| Gotcha load failure | Continue; note degradation | `DEGRADED_GOTCHAS` |
| UI asset referenced but inaccessible | Add risk entry | `DESIGN_ASSET_MISSING` |

## Constraints
- Read-only until confirmation.
- No speculative technology commitments absent in input or repository indicators.
- Deterministic ordering (alphabetical where not priority/sequence-based).
- External access only via sanctioned tools (sequential-thinking, allowed file ops).
- Avoid placeholder terms (TBD/???). Use `[PENDING: reason]` if unavoidable (must be rare).

## Output Formatting Rules
- All top-level sections use level 2 markdown headings: ##
- Tables for: Gotchas, Requirements (if tabular subsets), Traceability, Risks, Constraints, Assumptions, Quality Scores.
- IDs: ALL-CAPS prefix + dash + zero-padded 3-digit sequence.
- Wrap file paths & tokens in backticks.
- Line length target ≤120 chars.
- No inclusion of this prompt text inside generated spec documents.

## Spec Quality Scoring Table Template
| Metric | Score (%) | Notes |
|--------|-----------|-------|
| Business Alignment | X | ... |
| Requirements Completeness | X | ... |
| Technical Accuracy | X | ... |
| Clarity & Precision | X | ... |
| Testability | X | ... |
| Stakeholder Coverage | X | ... |
| Risk Management | X | ... |
| Implementation Readiness | X | ... |

## Confirmation Gate (Exact Text)
AWAITING USER CONFIRMATION: Reply YES to write spec.md (and designsystem.md if applicable). Reply NO to revise or clarify first.

## Post-Confirmation Procedure
1. Generate `spec.md`.
2. Generate `designsystem.md` if UI impact.

## Evaluation Criteria

| Category | Metric | Pass Condition | Fail Trigger | Auto-Check Hint |
|----------|--------|----------------|--------------|-----------------|
| Structural Completeness | Mandatory sections present & ordered | 100% | Missing/misordered | Compare heading sequence |
| ID Integrity | Unique, zero-padded IDs | No duplicates | Duplicate/skip | Track emitted set |
| Traceability Coverage | All clear reqs mapped once | 100% | Missing/duplicate mapping | Cross-check matrix vs lists |
| Quality Scores | All metrics populated | 8 filled | Placeholder / missing | Scan for X / placeholders |
| Confirmation Gate | Present pre-write | Exactly once | Absent/multiple | Regex confirm |
| Ambiguity Isolation | [UNCLEAR] only in queue | Strict | Leakage elsewhere | Search outside queue |
| Gotchas Strategy | Conditional loads justified | All triggers valid | Unauthorized loads | Validate trigger list |

## Self-Check Procedure (Pre-Display)
1. Enumerate generated section headings → verify full ordered list.
2. Validate uniqueness sets: requirements + epics.
3. Confirm all `[UNCLEAR]` items isolated to Clarification Queue.
4. Verify each clear requirement row has acceptance criteria or validation note.
5. Ensure Traceability Matrix covers all clear IDs exactly once (exceptions documented).
6. Populate Quality Assessment scores (no placeholders).
7. Confirm Confirmation Gate appears once.
8. If UI impact true → confirm `designsystem.md` plan section present; else explicit omission note in spec sections.
9. Verify no unresolved placeholder tokens (`$ARGUMENTS`, `${...}`).
10. Ensure error statuses not triggered; if any fatal condition → abort before gate.

DO NOT include this prompt content inside produced spec.

BEGIN EXECUTION WHEN INVOKED.
