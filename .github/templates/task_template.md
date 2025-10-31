---
name: Base Task Template
description: 
---

## Purpose
Provide a concise narrative of WHY this task exists (business / technical objective) and WHAT success looks like. Avoid restating the title verbatim; highlight unique value (e.g., "Introduce metrics endpoint to expose latency percentiles for autoscaling decisions").

## Core Principles
1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

---

## Requirement Reference
- User Story: [US_XXX | (none)]
- Story Location: [canonical path or (inline / external spec)]
- Acceptance Criteria:
	- [List each acceptance criterion verbatim or normalized]

## Task Overview
High-level scope (in/out). Provide 3–6 bullet points:
 - Core capability:
 - Primary actors:
 - Out of scope:
 - Key constraints:
 - Success signal:

## Dependent Tasks
List prerequisite task IDs (if none: `_None_`). For each: ID | Reason | Blocked Aspect.

## Tasks (Internal Decomposition)
Atomic internal steps (NOT other top-level tasks). Keep each step ≤ ~45 mins. Example:
1. Scaffold controller file
2. Add route definition & schema validation
3. Implement domain service logic
4. Write unit tests (service)
5. Add integration test (happy path + failure)
6. Update documentation

## Current State
Describe existing relevant modules. Provide concise tree or bullet diff context (omit unrelated noise). If brand new area: `_No existing related components_`.

## Future State
Planned structure after completion (new & modified items marked with + / *):
```
<insert tree>
```
Explain structural rationale if non-trivial.

## Development Workflow
Phased execution (ordered). Example:
| Phase | Focus | Exit Criteria |
|-------|-------|---------------|
| 1 | Scaffold & contracts | Routes & interfaces compile |
| 2 | Core logic | Unit tests (core) passing |
| 3 | Integration & edge cases | Integration tests green |
| 4 | Hardening | Error paths & performance check |
| 5 | Documentation & polish | Docs updated, lint clean |

## Data Workflow
Describe data flow (request → processing → persistence → response) OR `_Not applicable_`.

## Impacted Components
List by layer (FE / BE / DB / Infra). For each layer:
### Backend
- New:
- Modified:
- Removed (if any):
### Frontend
...

## Implementation Plan
Layer-specific actionable steps referencing files & tests.
### Backend
- [ ] Step description (file: `path/to/file`)
- [ ] Add unit tests (`tests/...`)
### Frontend (omit if N/A)
...

## References
### Internal References
- Relevant files / modules: (list)
- Related tasks: (list)
### External References
- [Doc / Spec / API] (URL) – purpose summary

## Implementation Validation Strategy
Define concrete validation gates:
- Lint / Static Analysis:
- Unit Tests:
- Integration / E2E:
- Performance (if applicable):
- Security / Auth:
- Accessibility (UI only):
- Rollback / Fallback Plan:

## ToDo Task
Executable granular checklist (mirrors Internal Decomposition) — ALL unchecked:
- [ ] Item 1
- [ ] Item 2
- [ ] Item 3

> NOTE: Do not pre-check any items. Checklist drives iterative agent execution.