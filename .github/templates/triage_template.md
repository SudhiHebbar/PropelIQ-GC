---
name: Bug Triage and Fix Template
description: Structured template for bug triage results and fix implementation tasks
---

## Purpose
Template optimized for AI agents to implement bug fixes with comprehensive triage analysis, root cause identification, and systematic validation to achieve reliable resolution through structured problem-solving.

## Core Principles 
1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

---

# Bug Fix Task: [Issue Title]

## Requirement Reference
- Bug Report: [Bug ID or source reference]

## Bug Triage Summary

### Issue Classification
- **Bug ID**: [Reference number or internal ID]
- **Priority**: [Critical/High/Medium/Low]
- **Severity**: [System impact level]
- **Affected Version**: [Version number or commit hash]
- **First Occurrence**: [Date identified or commit where introduced]
- **Reporter**: [User, system, or detection method]
- **Environment**: [OS, browser, device, or system configuration]

### Reproduction Details
**Environment Requirements**:
- OS/Platform: [Specific details]
- Technology Stack: [Framework versions, dependencies]
- Configuration: [Relevant settings or environment variables]
- Data Requirements: [Specific test data or system state]

**Steps to Reproduce**:
1. [Detailed step with expected setup]
2. [Action to perform with specific inputs]
3. [Trigger condition or user interaction]
4. **Expected Result**: [What should happen]
5. **Actual Result**: [What actually happens]

**Error Output**:
```
[Stack trace, error messages, log entries, or console output]
```

**Screenshots/Evidence**:
- [Links to screenshots, logs, or other evidence files]

### Root Cause Analysis
**Primary Cause**:
[Technical explanation of the underlying issue]

**Code Location**:
- **File**: `[path/to/file.ext:line_number]`
- **Component**: [Component or module name]
- **Function**: [Method, function, or class name]
- **Code Context**: [Brief description of the problematic code]

**Regression Analysis**:
- **Introduced in**: [Commit hash if this is a regression]
- **Related PR/Change**: [Pull request number or change reference]
- **Previous Working Version**: [Last known working version]

**Dependency Analysis**:
- **Affected Dependencies**: [List of impacted modules/components]
- **Cascade Effects**: [Other systems or features impacted]

### Impact Assessment
- **Affected Features**: [List of features experiencing issues]
- **User Impact Description**: [How end users are affected]
- **Business Impact**: [Revenue, reputation, or operational impact]
- **Data Integrity Risk**: [Yes/No with specific concerns]
- **Security Implications**: [Any security vulnerabilities exposed]
- **Performance Impact**: [System performance degradation details]
- **Affected User Base**: [Percentage or number of users impacted]

## Task Overview
[High-level description of the fix approach and expected outcomes]

## Dependent Tasks
- [List any prerequisite tasks that must be completed first]
- [Reference to blocking issues or dependencies]

## Tasks
- [High-level tasks to accomplish the bug fix]
- [Include both fix implementation and validation tasks]

## Current State
- [Current problematic behavior and system state]
- [Code structure causing the issue]

## Future State
- [Expected behavior after fix implementation]
- [Updated system state and code structure]

## Development Workflow
[Step-by-step implementation approach]

## Data Workflow
[Any data migration, cleanup, or integrity steps required]

## Impacted Components
### [Technology Stack Layer]
- [List of classes/modules/files to be modified]
- [Indicate whether each is updated or newly created]

## Implementation Plan
### [Technology Stack Layer] Implementation Plan
- [Detailed implementation steps with file references]
- [Unit test updates and new test case requirements]
- [Integration testing considerations]

### Fix Implementation Strategy
**Solution Approach**:
[Detailed technical approach to resolving the issue]

**Code Changes Required**:
```
[Pseudocode, specific code changes, or implementation examples]
```

**Database/Schema Changes** (if applicable):
```sql
[SQL migration scripts or schema updates]
```

### Regression Prevention Strategy
**New Tests Required**:
- [ ] Unit test for [specific scenario that caused the bug]
- [ ] Integration test for [affected workflow or feature]
- [ ] Edge case test for [boundary conditions that failed]
- [ ] Regression test for [preventing this specific issue]

**Existing Tests to Update**:
- [ ] `[test_file.ext]` - [reason for update and changes needed]
- [ ] `[integration_test.ext]` - [modifications required]

**Test Data Requirements**:
- [Specific test data or system states needed for validation]

### Rollback Procedure
**Immediate Rollback Steps**:
1. [Step to quickly revert changes if issues arise]
2. [Configuration or deployment rollback procedure]
3. [Data restoration steps if applicable]

**Rollback Validation**:
- [ ] [Verification that rollback restored expected behavior]
- [ ] [Confirmation that no data was lost during rollback]

## References

### Universal Standards & Principle References
- [anti_pattern.md](../gotchas/anti_patterns.md) - [Specific anti-patterns to avoid]
- [anti_redundancy_rules.md](../gotchas/anti_redundancy_rules.md) - [Code efficiency guidelines]
- [general_coding_standards.md](../gotchas/general_coding_standards.md) - [Code quality standards]

### Project Context References
- [spec.md file in '/.propel/context/docs' folder]
- [design.md file in '/.propel/context/docs' folder]

### External References
- [Framework documentation links for bug fix patterns]
- [Stack Overflow solutions or similar issue discussions]
- [GitHub issues or bug reports for similar problems]
- [Technical blog posts or articles about the issue type]

### Bug-Specific Research
- **Original Bug Report**: [Link to original report or issue]
- **Related Issues**: [Links to similar or related problems]
- **Fix Examples**: [Examples of similar fixes in codebase or other projects]

## Build Commands
- [Technology-specific commands for building and testing the fix]
- [Validation commands to ensure fix works correctly]

## Implementation Validation Strategy
### Validation Criteria
- [ ] **Primary Issue Resolved**: Bug no longer reproducible using original steps
- [ ] **Regression Testing**: All existing functionality still works
- [ ] **New Test Coverage**: New tests pass and prevent recurrence
- [ ] **Performance Validation**: No performance degradation introduced
- [ ] **Security Review**: No new security vulnerabilities created
- [ ] **Code Review Approval**: Implementation reviewed and approved
- [ ] **Integration Testing**: End-to-end workflows function correctly
- [ ] **Staging Deployment**: Successfully deployed and tested in staging environment

### Post-Implementation Monitoring
- [Metrics or logs to monitor after deployment]
- [Success criteria for production deployment]
- [Timeline for validation in production environment]

## ToDo Task
- [Implementation tasks in priority order]
- [Testing and validation tasks]
- [Documentation and code review tasks]
- [Deployment and monitoring tasks]

## Implementation Time Estimate
- **Triage Phase**: [Completed during task generation]
- **Fix Implementation**: [Estimated hours for code changes]
- **Testing & Validation**: [Hours for test creation and execution]
- **Code Review & Refinement**: [Time for review and improvements]
- **Total Estimated Time**: [Total hours for complete resolution]