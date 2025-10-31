---
name: Base User Story Template
Concise, canonical user story template ensuring consistent format, explicit acceptance criteria, enumerated edge cases, traceability (IDs, tags FR/NFR/etc.), and iterative refinement—optimized for clarity, testability, reuse, and automated validation to accelerate high‑quality implementation.
---

## Purpose
Establish a consistent, information‑dense structure for capturing software requirements for each user story so both humans and AI agents can: 
- Rapidly understand user intent through a canonical story format (“As a … I want … so that …”) 
- Validate completeness via explicit acceptance criteria and enumerated edge cases 
- Ensure traceability using unique IDs, epic linkage, and tagged classifications (FR, NFR, etc.) 
- Accelerate iterative refinement by making ambiguities explicit and testability central 
- Reuse standardized patterns, terminology, and governance rules (see CLAUDE.md) across the codebase 

This template is the authoritative starting point for drafting, refining, and validating user stories prior to implementation or automation.

## Core Principles
1. **Context is King**: Include all necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

## Best Practices
1. **Be Specific**: Use measurable criteria and concrete examples
2. **Be Testable**: Each user story should be verifiable
3. **Be Traceable**: Use unique IDs for user story for better tracking
4. **Be Complete**: Avoid ambiguous language and undefined terms
5. **Mark Unclear**: Flag user stories needing clarification rather than guessing

## Format:
```yaml
# User Story:
  * ID: []              # Unique ID to be populated
  * Title: []           # To be populated
## Description:
   * []                 # To be populated ("As a ... I want ... so that ...")
## Acceptance Criteria:
   * []                 # To be populated (Given/When/Then)
## Edge Cases:
   * []                 # To be populated
## Traceability:
### Parent: 
    * []                # mapped to epic ID
### Tags:
    * []                # To be populated (NFR, FR, TR, DR, UXR, <Platform tag>, <Domain tag>)
### Dependencies:
    * []                # To be populated (List of dependent user story IDs or N/A if none or not applicable)
```
---

# [User Story]
## ID : 
   * ID Format: US_<unique seq num>

## Title : 
   * [Title of the story in less than 10 words]

## Description
  * Description Format: "As a..., I want..., so that..."

## Acceptance Criteria
  * Acceptance Criteria Format: "Given [initial state], When [action], Then [expected outcome]"

## Edge Cases
   * What happens when [boundary condition]?
   * How does system handle [error scenario]?

## Traceability
### Parent
    * Epic : [Epic ID]

### Tags
    * [NFR, FR, TR, DR, UXR, <Platform tag>, <Domain tag>]

## Story Points & Effort
   * Points: [1-5]
   * Risk Level: [Low|Medium|High]

### Dependencies
    * [List of dependent user story IDs or N/A if none or not applicable]

### Library References
   * [library] : [API/doc excerpt]