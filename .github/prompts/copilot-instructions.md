# Additional Context for Command Development

This file provides specific guidelines for breaking down user stories and creating tasks for command-related development work.

## MCP Pagination Policy

### Scope 
Applies to any MCP tool that can return large lists, logs, files, or code.

### Rules
- **Always paginate**: Include a limit and offset/cursor on every call.
- **Token budget**: Hard ceiling 25,000 tokens per tool response. Reserve headroom; target ≤ 18,000 tokens per call to leave space for prompts/reasoning.
- **Projection first**: Request only required fields; avoid full objects/blobs.
- **Filter early**: Use server-side filters (since, ids, status, path, glob, etc.) to shrink results.

### Defaults (tune up/down based on page size)
- **Lists/records**: Start with limit: 50.
    - If a page < ~9k tokens → double limit next page (up to your safe target).
    - If a page ≥ ~18k tokens → halve limit next page.
- **Files/text**: Use range reads (offset + limit).
    - Start with 60k–80k chars per slice (≈15k–20k tokens). Return nextOffset/hasMore.

### Stop & Safety
- Stop when goal met or after 5 pages unless explicitly required.
- If nearing budget (≥ ~18k tokens) or latency rises, reduce limit by 50% and tighten filters.
- No whole-dataset pulls. Prefer filtered queries and targeted ranges.
- Log decisions: e.g., “Read 3 pages @ 50/100/50; final output < 18k tokens.”

## User Story Breakdown Guidelines

### Story Point Estimation
- Each user story should be broken into manageable and independently testable stories
- **Maximum story size**: 5 story points per story
- **Story point calculation**: 1 story point = 6 hours of effort
- Stories should be independent and deliverable as standalone units

### Story Breakdown Criteria
- Stories must be testable independently
- Each story should deliver business value
- Stories should follow INVEST principles (Independent, Negotiable, Valuable, Estimable, Small, Testable)

## Task Creation Guidelines

### Task Effort Estimation
- **Standard task effort**: 4 hours per task
- Tasks must be manageable and meaningful
- Each task should have clear acceptance criteria

### Project Scaffolding (No Existing Codebase)
**When no codebase is available, create language-specific project scaffolding tasks:**
- **Project initialization task**: Setup project structure, build tools, and configuration
- **Development environment task**: Configure development tools, linting, formatting
- **Framework selection task**: Choose and setup appropriate frameworks/libraries
- **Project structure task**: Create folder structure, naming conventions, and organization
- **Build pipeline task**: Setup CI/CD, testing infrastructure, and deployment configuration
- **Documentation foundation task**: Create README, contributing guidelines, and project documentation

### Stream Separation
Create separate tasks for each development stream:
- **Frontend (FE) tasks**: UI/UX implementation, client-side logic
- **Backend (BE) tasks**: Server-side logic, API development
- **Database (DB) tasks**: Schema changes, data migrations, queries
- **Integration tasks**: End-to-end workflow testing, feature integration testing

### Integration Testing
- Create dedicated integration tasks to test complete workflows
- Integration tasks should validate the entire feature implementation
- Include cross-stream dependency validation

## Reference Guidelines

### Existing Task Analysis
**Before creating new tasks:**
1. Review `.propel/context/us_*` folder for existing task patterns
2. Understand current task structure and naming conventions
3. Build dependency mapping with existing tasks
4. Identify reusable components or patterns

**For new projects (no existing codebase):**
1. Determine target programming language and technology stack
2. Research language-specific best practices and project templates
3. Consider industry standards for the chosen technology stack
4. Plan scaffolding tasks based on project complexity and requirements

### Test Script Development
**Before creating test scripts:**
1. Review `.propel/context/tests` folder for existing test patterns
2. Understand current testing framework and conventions
3. Consider updating existing scripts for new enhancements
4. Follow established test naming and organization patterns

## Task Dependencies

### Dependency Mapping
- Map dependencies between FE, BE, and DB tasks
- Identify blocking dependencies and critical path items
- Document prerequisite tasks and deliverables
- Consider parallel execution opportunities

### Integration Points
- Define clear handoff points between streams
- Specify interface contracts between components
- Plan integration testing at appropriate milestones

## Best Practices

### Task Documentation
- Include clear task descriptions and acceptance criteria
- Document expected inputs and outputs
- Specify testing requirements for each task
- Include relevant context from existing codebase

### Quality Assurance
- Plan testing tasks alongside development tasks
- Include code review tasks where appropriate
- Consider performance and security implications
- Plan documentation updates as separate tasks when needed

## Code Generation Guidelines

### Code Modification Standards
1. **Codebase Analysis**: Always analyze and understand the existing codebase for additional context before generating new code
2. **Boundary Identification**: Always identify the start and end boundaries of existing code before applying modifications
3. **Functionality Preservation**: Ensure code generation does not break existing functionality or introduce regressions
4. **Impact Assessment**: Analyze dependencies and side effects before making changes to existing code
5. **Avoid Deprecated Libraries**: Avoid using deprecated libraries and prefer modern, maintained alternatives

### Template Adherence
- **Template Structure Compliance**: Commands must produce outcomes that follow the referenced template structure available in the Templates folder
- **Template Reading**: Always read the appropriate template from References/Templates/ directory before generating outputs
- **Structure Validation**: Validate that generated content matches the expected template sections and format
- **Placeholder Replacement**: Ensure all template placeholders are replaced with actual content, not left empty

## Conditional Gotcha Loading Strategy

### Purpose
Loading only relevant gotcha files based on task/command context while maintaining comprehensive coverage.

### Critical Distinction
- **best_practices.md files** = Universal guidance for ANY technology in that layer (frontend/backend/database)
- **Technology-specific gotchas** = Framework/language-specific issues (**react_gotchas.md** for React ONLY, **dotnet_gotchas.md** for .NET ONLY)

### Standardized Loading Template

Commands should apply this conditional loading logic based on their context:

#### **Step 1: ALWAYS Load Core Gotchas**
These apply to ALL tasks regardless of technology or context:
- Read `References/Gotchas/anti_redundancy_rules.md` - Framework rules and scope discipline
- Read `References/Gotchas/general_coding_standards.md` - Universal coding standards
- Read `References/Gotchas/anti_patterns.md` - Common pitfalls across all technologies
- Read `References/Gotchas/architecture_patterns.md` - Architectural guidance and patterns
- Read `References/Gotchas/framework_methodology.md` - Process methodology and workflow

#### **Step 2: Conditional Layer-Based Best Practices**
Load based on which application layer is involved:

**IF Frontend Layer Detected** (UI, components, client-side code):
- Read `References/Gotchas/frontend_best_practices.md` - Universal frontend guidance (ANY framework)
- Read `References/Gotchas/design-principles.md` - Design principles (if UI design is involved)

**IF Backend Layer Detected** (APIs, services, server-side logic):
- Read `References/Gotchas/backend_best_practices.md` - Universal backend guidance (ANY framework)

**IF Database Layer Detected** (SQL, migrations, data access):
- Read `References/Gotchas/database_best_practices.md` - Database patterns and practices

#### **Step 3: Conditional Technology-Specific Gotchas**
Load ONLY if the specific technology is explicitly detected:

**IF React Explicitly Detected**:
- Read `References/Gotchas/react_gotchas.md` - React-specific patterns and issues
- **Detection criteria**: Import statements with 'react', JSX/TSX syntax, package.json includes react dependency

**IF .NET/C# Explicitly Detected**:
- Read `References/Gotchas/dotnet_gotchas.md` - .NET-specific patterns and issues
- **Detection criteria**: .csproj/.sln files, using statements, C# syntax, ASP.NET mentions

#### **Step 4: Conditional Context-Specific Guidance**
Load based on specific work context:

**IF Testing Context** (test creation, automation, Playwright):
- Read `References/Gotchas/automation_testing_gotchas.md` - Testing best practices
- Read `References/Gotchas/testing_workflow_patterns.md` - Test organization patterns

**IF DevOps Context** (deployment, CI/CD, infrastructure):
- Read `References/Gotchas/devops_best_practices.md` - DevOps practices
- Read `References/Gotchas/validation_commands.md` - Validation strategies

**IF Troubleshooting Context** (debugging, error resolution):
- Read `References/Gotchas/troubleshooting_guide.md` - Debugging guidance

### Detection Heuristics

#### Layer Detection
**Frontend Layer:**
- File extensions: `.tsx`, `.jsx`, `.css`, `.scss`, `.html`
- Keywords: UI, component, client-side, browser, DOM, state management
- Directories: `/components`, `/pages`, `/app`, `/src/client`

**Backend Layer:**
- File extensions: `.cs`, API files, controller files
- Keywords: API, controller, service, server-side, endpoint, middleware
- Directories: `/Controllers`, `/Services`, `/API`, `/backend`

**Database Layer:**
- File extensions: `.sql`, migration files
- Keywords: database, SQL, migration, query, Entity Framework, data access
- Directories: `/Migrations`, `/Data`, `/Database`

#### Technology-Specific Detection
**React Detection** (triggers react_gotchas.md):
- Import statements: `import React`, `import { useState }`
- JSX/TSX syntax in file content
- package.json contains "react" dependency
- **Do NOT load for**: Vue, Angular, Svelte, vanilla JavaScript

**.NET Detection** (triggers dotnet_gotchas.md):
- File extensions: `.csproj`, `.sln`
- Using statements: `using System`, `using Microsoft`
- Keywords: ASP.NET, Entity Framework, C#
- **Do NOT load for**: Node.js, Python, Java backends

#### Context Detection
**Testing Context:**
- Files: `.test.ts`, `.spec.ts`, `playwright.config.ts`
- Keywords: test, Playwright, E2E, automation, test workflow

**DevOps Context:**
- Files: `Dockerfile`, `.yml`, `.yaml`, CI/CD configuration files
- Keywords: deployment, pipeline, container, infrastructure

**Design Context:**
- Keywords: UI design, Figma, design system, visual specifications
- Context: UI tasks with design requirements

**Troubleshooting Context:**
- Keywords: debug, error, fix, troubleshoot, issue, bug

### Default Behaviors

1. **If layer is unclear**: Load both `frontend_best_practices.md` + `backend_best_practices.md` (safest default)
2. **Never load react_gotchas.md**: Unless React is explicitly detected in code/dependencies
3. **Never load dotnet_gotchas.md**: Unless .NET/C# is explicitly detected in code/files
4. **ALWAYS load core gotchas**: The 5 core files apply universally to all work
5. **Multiple technologies**: Load all relevant layer best_practices and detected technology gotchas
6. **Testing tasks**: Always include testing gotchas + layer best_practices based on what's being tested

### Usage in Commands

Commands should reference this strategy with context-appropriate detection:

**Example for Implementation Tasks:**
```markdown
**Gotcha Loading:**
Apply Conditional Gotcha Loading Strategy from CLAUDE.md based on task file context:
- Analyze task todos for file extensions and technology keywords
- Load core gotchas (always)
- Load layer-based best_practices based on detected layers
- Load technology-specific gotchas only if React or .NET explicitly detected
```

**Example for Review/Analysis Tasks:**
```markdown
**Gotcha Loading:**
Apply Conditional Gotcha Loading Strategy from CLAUDE.md based on changed files:
- Analyze file extensions (.tsx → frontend, .cs → backend, .sql → database)
- Load core gotchas (always)
- Load relevant layer best_practices
- Load react_gotchas.md only if .tsx/.jsx files present
- Load dotnet_gotchas.md only if .cs files present
```

### Examples

**Example 1: Generic Frontend Component Task**
- Detected: `.tsx` files, "component" keyword
- Load: Core (5) + frontend_best_practices
- Skip: react_gotchas (unless React imports detected in task context)

**Example 2: React Hook Implementation**
- Detected: `import { useState }` in task, React in package.json
- Load: Core (5) + frontend_best_practices + react_gotchas + design-principles

**Example 3: Generic REST API Task**
- Detected: "API endpoint" keyword, controller mentions
- Load: Core (5) + backend_best_practices
- Skip: dotnet_gotchas (unless .NET detected)

**Example 4: .NET Web API with Database**
- Detected: `.cs` files, Entity Framework, SQL migrations
- Load: Core (5) + backend_best_practices + dotnet_gotchas + database_best_practices