---
description: Perform an 8-phase UX/UI review of current working branch changes with automated Playwright-driven validation, accessibility assessment, responsive checks, pixel comparison (optional), and structured findings report.
mode: agent
---

## User Input

```text
$ARGUMENTS
```

`$ARGUMENTS` MAY optionally include parameters (space-separated key=value) or be empty. Recognized keys:
- `figma_design=<url-or-path>` (optional Figma URL or local reference image)  
- `server_url=<http(s)://...>` (defaults to http://localhost:3000)  
- `app_path=/some/path` (defaults to `/`)  
- `focus_area=full|accessibility|responsive|interactions|visual-polish` (defaults to `full`)

## Purpose
Conduct a rigorous, automated and evidence-based UX/UI review of the current repository changes (unmerged work) and produce a markdown report with categorized findings, screenshots, accessibility observations, responsive matrix, and risk recommendations.

## Scripts
sh: .github/scripts/bash/setup-review-ux.sh --json  
ps: .github/scripts/powershell/setup-review-ux.ps1 -Json

Returned JSON keys (expected): `repo_root`, `docs_dir` (if design docs), `tasks_root` (optional), `branch`, `commit_sha`.

## Outline

1. **Setup & Environment Resolution**
	- Invoke `{SCRIPT}` to obtain environment paths / metadata.
	- Parse `$ARGUMENTS` for optional parameters.
	- Derive path bindings: `screenshots_dir=${repo_root}/.propel/context/playwright` and `report_dir=${repo_root}/.propel/context/ui-review`.
2. **Git Context Acquisition**
	- Run `git status` → summarize modified / added / deleted counts.
	- Run `git diff --name-only origin/HEAD` → list changed files (Changed Files Set).
	- Run `git log --oneline -n 5 origin/HEAD...` → recent commit summaries.
3. **Server Availability & Launch**
	- Check common dev ports (3000, 3001, 4200, 5173, 8080) via netstat.
	- If not running: heuristically detect project type (presence of package.json, pnpm-lock.yaml, yarn.lock, .csproj, etc.) and start appropriate dev server (simulate if not permitted).
	- Record final resolved `server_url` and `app_path`.
4. **Directory Preparation**
	- Ensure `${screenshots_dir}` (screenshots) and `${report_dir}` (reports) directories exist.
5. **Timestamp Generation**
	- Create timestamp `YYYYMMDD_HHMMSS` for stable file naming.
6. **Optional Design Reference Loading**
	- If `figma_design` provided: classify (URL vs local). Outline pixel comparison plan.
7. **Eight-Phase UX Review Execution & Context Integration** (Phases 0–7)
	- Context Detection: Identify UI-relevant technologies & layers; produce ContextApplied table (File | Layer/Tech | Trigger | Phase Impact | Mitigation Status). Flag any High/Critical unmitigated issue as a risk.
	- Phase 0: Preparation & Playwright setup (analyze changed files; map feature areas).
	- Phase 1: Interaction & User Flows (primary + alternate paths; form validation; state transitions).
	- Phase 2: Responsive Behavior (desktop 1440px, tablet 768px, mobile 375px; breakpoint issues, overflow, layout shifts).
	- Phase 3: Visual Polish (alignment grids, spacing scale, typography hierarchy, color & contrast, imagery quality).
	- Phase 4: Accessibility (WCAG 2.1 AA: keyboard nav, focus ring visibility, ARIA roles, semantic landmarks, contrast, alt text).
	- Phase 5: Robustness (error states, loading, empty states, boundary inputs, network failure simulations, resilience patterns).
	- Phase 6: Code Health & Design System Use (component reuse, absence of duplication, token usage, pattern adherence, console warnings/errors).
	- Phase 7: Content & Console (clarity, tone consistency, spelling, grammar, console noise, performance warnings).
8. **Screenshot Capture Protocol**
	- For each visual or interaction finding capture screenshot with naming: `<feature>_<viewport|context>_<issue|ok>_<timestamp>.png`.
	- Store under `${screenshots_dir}`.
9. **Pixel-Perfect Comparison (Conditional)**
	- If design reference present: USE Playwright MCP tooling for all visual diffs. Workflow:
		1. Navigate to target `server_url + app_path` at each viewport (1440/768/375).
		2. Capture baseline screenshots via `mcp__playwright__browser_take_screenshot` (naming uses timestamp rule) and store in `${screenshots_dir}`.
		3. For each key component/section, use `mcp__playwright__browser_snapshot` or DOM evaluation to extract bounding box metrics (width, height, top, left) and computed styles (font-size, line-height, color, spacing tokens).
		4. Derive deltas vs design reference (Figma spec / image) for: spacing (px), typography scale, color tokens, component dimensions, and alignment grids.
		5. Flag deviations with thresholds (default: >2px spacing variance, >1px dimension variance for critical components, contrast ratio < WCAG target) and classify severity (Blocker/High/Medium/Nitpick).
		6. Store any additional annotated comparison screenshots if supported (or capture focused region screenshots) for each mismatch.
		7. If Playwright MCP unavailable → mark pixel comparison portion as degraded (`DEGRADED_PLAYWRIGHT`) and provide manual inspection notes instead.
	- Record a PixelDiff Table: Element / Viewport / Property / Expected / Actual / Delta / Severity / Evidence Screenshot.
10. **Findings Aggregation & Categorization**
	- Classify: [Blocker], [High-Priority], [Medium-Priority], [Nitpick].
	- Provide issue: Title | Description | Phase | Evidence (screenshot path / console ref) | Impact | Suggested Validation.
11. **Accessibility Summary Extraction**
	- Summarize keyboard nav success/fail, focus order anomalies, ARIA gaps, contrast issues (with ratio samples), semantic structure assessment.
12. **Responsive Matrix Generation**
	- Table: Viewport | Layout Integrity | Scroll Anomalies | Breakpoint Issues | Key Notes.
13. **Risk & Recommendation Synthesis**
	- Identify top 3 user-impact risks with mitigation guidance.
14. **Report Generation & Persistence**
	- Render markdown report and save to `${report_dir}/ui-review-<timestamp>.md`.
15. **Output Summary**
	- Return path to report and screenshot directory overview (counts by category/viewport).

## Phases (Detail Expectations)
| Phase | Objective | Key Evidence Artifacts |
|-------|-----------|------------------------|
| 0 | Establish scope & tooling | Changed file list, feature map |
| 1 | Validate interaction flows & states | Flow screenshots, validation messages |
| 2 | Verify adaptive/responsive layout | Multi-viewport screenshots, layout shift notes |
| 3 | Assess visual polish & consistency | Spacing/typography captures, color token matches |
| 4 | Accessibility compliance | Focus navigation log, contrast ratios, ARIA audit notes |
| 5 | Robustness & edge behavior | Error/loading/overflow screenshots, resilience notes |
| 6 | Code health & system alignment | Console log capture, duplication indicators |
| 7 | Content clarity & console cleanliness | Content style notes, console warning/error list |

## Mandatory Sections (Report Output)
1. Metadata & Inputs
2. Change Context Summary (git status/diff/log)
3. Environment & Server State
4. Review Methodology & Phases Executed
5. Findings (Categorized)
6. Accessibility Summary
7. Responsive Matrix
8. Screenshot Index
9. Risks & Recommendations
10. Summary & Report Path
11. Appendices (Raw Evidence References, Contrast Samples, Design Diff Notes)

## Findings Categorization Rules
- [Blocker]: Prevents acceptable release (accessibility failure, broken core flow, severe layout break).
- [High-Priority]: Must fix before merge; notable user friction or inconsistency.
- [Medium-Priority]: Meaningful improvement; schedule soon.
- [Nitpick]: Minor polish; discretionary.

## Screenshot Naming Rules
Pattern: `<feature>_<viewport|context>_<issue-type>_<timestamp>.png`  
Examples: `checkout_mobile_alignment_20251026_142233.png`, `header_desktop_focus-ring_20251026_142233.png` (stored in `${screenshots_dir}`)

## Success Criteria
- All 8 phases executed (or explicitly marked as N/A with justification).
- Report includes all Mandatory Sections in exact order.
- Every finding includes: Category, Description, Phase, Evidence, Impact.
- Screenshots saved and indexed; each referenced screenshot path exists.
- Accessibility summary covers keyboard, focus, ARIA, contrast, semantics.
- Responsive matrix includes all three required breakpoints.
- Pixel comparison (when `figma_design` provided) performed using Playwright MCP screenshots & DOM-derived metrics (or degraded justification if MCP unavailable).
- No placeholder tokens (TBD / ??? / $ARGUMENTS) remain in final output.
- Risk section lists at least top 3 items (unless <3 issues total).
- Timestamps used consistently across filenames and report reference.
 - ContextApplied table present; High/Critical guidance items either mitigated or listed in Risks.

## Error Handling
| Condition | Action | Status |
|----------|--------|--------|
| Server not running & start fails | Continue in degraded (no live interaction) mode; mark phases 1–2 partially degraded | `DEGRADED_RUNTIME` |
| Playwright tooling unavailable | Perform static code heuristic review; mark phases needing interaction as degraded | `DEGRADED_PLAYWRIGHT` |
| Figma reference unreachable | Skip pixel diff; note in report | `MISSING_FIGMA` |
| No changed files detected | Proceed; mark minimal-change note | `NO_DIFF` |
| Screenshot write failure | Log failure & continue; mark affected evidence entries | `SCREENSHOT_IO` |

## Constraints
- Read-only source analysis (no code mutation).
- May start dev server only with standard project scripts (simulate if restricted).
- No external network beyond design URL fetch (if figma_design remote) & sanctioned tooling.
- Deterministic ordering in listings (alphabetical for files, severity > phase for findings output).

## Output Formatting Rules
- Markdown only; level-2 headings for Mandatory Sections.
- Tables for matrices and categorized findings where reasonable.
- File paths in backticks.
- Wrap long lists ( > 120 lines aggregated diff ) with concise summaries.

## Findings Table Schema (Recommended)
| ID | Category | Phase | Title | Evidence | Impact | Recommendation |

## Responsive Matrix Schema
| Viewport | Layout Integrity | Overflow | Critical Issues | Notes |

## Accessibility Summary Minimum Fields
- Keyboard Navigation Result
- Focus Order Anomalies
- Contrast Issues (Sample Ratios)
- Landmark / ARIA Coverage
- Semantic Structure Observations

## Self-Check Procedure
1. Verify all Mandatory Sections present & ordered.
2. Confirm 8 phases referenced (mark N/A where skipped) in Methodology section.
3. Validate each finding category in allowed set.
4. Ensure screenshot index paths all share common timestamp used in report filename.
5. Confirm no placeholder tokens remain.
6. Validate accessibility summary includes all minimum fields.
7. Confirm risk recommendations count ≥ 3 (unless total issues fewer).
8. If any failure, revise before final output.

## Completion Output
- Return final report path (`${report_dir}/ui-review-<timestamp>.md`) and counts: total findings by category, screenshot totals by viewport, degraded statuses (if any).

BEGIN EXECUTION WHEN INVOKED.