---
applyTo: "**"
description: "UI design and system guidance: tokens, layout hierarchy, module-specific UI tactics, accessibility alignment, and interaction quality. Excludes foundational a11y, performance, and frontend coding rules already covered elsewhere."
---

## Scope & Intent
Provide high-level UI design system & interaction principles for all generated artifacts (code, docs, templates). Focuses on consistent tokens, hierarchy, clarity, module patterns (media moderation, data tables, configuration panels), and user-centric interaction. Does NOT restate baseline accessibility (a11y instructions), generic performance budgets, or React-specific coding conventions.

## Core Philosophy
- Users First: Decisions optimize task completion & reduce cognitive load.
- Clarity Over Novelty: Prefer explicit labels & progressive disclosure to clever but obscure UI.
- Consistent Language: Reinforce shared visual grammar (colors, typography, spacing) across components.
- Accessible by Design: Contrast & focus states planned at component inception (not retrofitted).
- Opinionated Defaults: Provide sensible initial settings minimizing immediate user decisions.

## Design Tokens
Define & maintain a canonical token set (single source):
- Color: Brand primary + semantic (success, warning, error, info) + neutral grayscale ramp (5–7 steps) for backgrounds/text.
- Typography: Modular scale (H1→Caption) with limited weights (Regular, Medium, SemiBold, Bold) & line-height guidelines (body 1.5–1.7).
- Spacing: Base unit (e.g., 8px) with multiplicative scale (4,8,12,16,24,32...).
- Radius: Small (inputs/buttons), Medium (cards/modals). No ad-hoc pixel values.
- Dark Mode Parity: Provide accessible dark equivalents (contrast AA+ maintained).
Tokens consumed via variables/custom properties – no hard-coded literals in components.

## Component States & System Cohesion
Each core component defines explicit states: default, hover, focus (visible outline), active, disabled, loading.
Primary Set (examples, not exhaustive): Buttons, Inputs, Selects, Date Pickers, Checkboxes, Radios, Toggles, Cards, Tables, Modals, Navigation (Sidebar/Tabs), Badges, Tooltips, Progress Indicators, Icons, Avatars.
Guidelines:
- State Feedback Immediate (<100ms visual response).
- Focus Outline Contrast ≥3:1 against adjacent colors.
- Disabled vs ReadOnly clearly differentiated (opacity vs alternate styling).

## Layout & Hierarchy
- Grid: Responsive 12-column baseline; components align to grid at breakpoints (mobile-first adjustments).
- Visual Hierarchy: Typography size/weight & spacing establish priority; avoid relying solely on color.
- Whitespace Utilization: Intentional breathing room reduces cognitive load (avoid dense clustering).
- Alignment Consistency: Vertical rhythm maintained via spacing scale; textual alignment left for text, right for numeric.
- Shell Structure: Persistent sidebar navigation + top bar (optional) + scrollable content region; ensures landmark consistency for assistive tech.

## Interaction & Motion
- Micro-Interactions: Subtle (150–300ms) easing (ease-in-out) for hover/press; never obstruct task flow.
- Loading States: Skeletons for page-level blocks expected >300ms; inline spinners for local actions.
- Motion Reduction: Honor `prefers-reduced-motion`; supply non-animated fallbacks.
- Keyboard Navigation: All actionable elements reachable in logical order; composite components manage roving tabindex where needed.

## Module-Specific Patterns
### Media Moderation
- Prominent Preview: Clear imagery/video surface with status badge (Pending/Approved/Rejected).
- Bulk Actions: Multi-select workflow + visible contextual toolbar.
- Shortcut Enablement: Common actions mapped (document keys) for throughput.
- Fatigue Reduction: Clean layout, optional dark theme for prolonged review.

### Data Tables
- Readability: Left-align text, right-align numbers, bold headers.
- Interaction: Sort indicators, accessible filter controls, global search.
- Large Sets: Pagination preferred; virtual scroll only when validated performance need.
- Row Enhancements: Expandable details, inline edits (clearly styled), bulk selection with action toolbar.

### Configuration Panels
- Clarity: Precise labels + concise helper text; avoid jargon.
- Grouping: Related settings sectionalized via headings or tabs.
- Progressive Disclosure: Secondary/advanced options hidden until requested.
- Feedback: Immediate save confirmation (toast/inline), explicit error messaging.
- Reset & Defaults: Provide per-section and global reset.
- Preview: Live or near-live preview for site/microsite changes.

## Styling Architecture (Design Perspective)
- Token Driven: Always reference design tokens (CSS variables / theme object) – no arbitrary hex in components.
- Methodology: Utility-first or modular/scoped styles; global layer limited to reset, variables, typography.
- Maintainability: Regular audit for unused classes/selectors; consolidate duplicates.
- Performance: Avoid large unused bundles (purge unused styles in CI dry-run).

## General Best Practices
- Iteration: Continual user feedback loop & refinement.
- Information Architecture: Logical navigation & content grouping supporting primary workflows.
- Responsiveness: All key interactions accessible & performant across mobile/tablet/desktop.
- Documentation: Keep living design system reference updated alongside component changes.

## Quality Checklist
- [ ] Tokens (color/type/spacing/radius) applied; no hard-coded style literals.
- [ ] Component states defined & visually distinct (focus visible).
- [ ] Layout follows responsive grid & spacing scale.
- [ ] Hierarchy communicates priority without relying solely on color.
- [ ] Loading states appropriate (skeleton vs spinner).
- [ ] Module-specific patterns followed (media/table/config) where applicable.
- [ ] Progressive disclosure used for advanced settings.
- [ ] Dark mode palette maintains contrast requirements.
- [ ] Keyboard focus order logical & untrapped.
- [ ] Documentation updated with new/changed components.

## Focused Terminology
- Progressive Disclosure: Revealing complexity only when user needs it.
- Skeleton Screen: Placeholder UI replicating layout while data loads.
- Design Tokens: Named, reusable design values forming the system's visual language.
- Visual Hierarchy: Ordering of elements to guide user attention & comprehension.
- Roving Tabindex: Technique managing focus within composite widgets.
