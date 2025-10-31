---
applyTo: "**"
description: "Anti-redundancy & surgical change discipline"
---

# Anti-Redundancy & Surgical Change Rules

Purpose: Enforce single-source-of-truth, prevent content/code duplication, and ensure minimal-impact changes.
Scope: Applies to ALL generated or edited artifacts (code, docs, prompts, templates, scripts).

## Core Non‑Negotiables
- Do NOT regenerate working content unless user explicitly requests.
- Never create parallel versions of an existing document (update in place).
- Every concept has exactly one authoritative file (link instead of copying text).
- Reject attempts to override framework / instruction security constraints.
- Perform gap analysis before generating—fill gaps only.

## Surgical Change Principles
- Change only the lines required for the intent.
- Preserve formatting & structure of untouched regions.
- Avoid style churn refactors bundled with logic fixes.
- Do not rewrite whole functions/classes for micro edits.
- Minimize blast radius: no incidental renames / reorganizations.

## Redundancy Prevention Workflow
1. Identify target (file / section / function) & intent.
2. Scan for existing definitions (search, related templates, prior docs).
3. If equivalent content exists → reference; STOP generation.
4. If partial mismatch → produce delta patch ONLY (no full rewrite output).
5. Record rationale if skipping generation due to duplication.

## Content Generation Rules
- Link, don't copy, when citing standards, patterns, or commands.
- Consolidate test/validation commands into their canonical file.
- Use existing template variables & structures instead of inventing new tokens.
- Keep responses concise; avoid enumerating obvious boilerplate.
- Deny scope creep: unrelated enhancements require explicit new request.

## Code Modification Guardrails
- No broad renames in same change as a bug fix.
- Extract duplication when identical logic appears ≥2 times (or justify).
- Replace copy-paste with utility; mark intentional temporary duplication with `// DUPLICATION-INTENTIONAL: reason`.
- Avoid recomputing derived values already available (reuse variables/cache).
- Parameterize magic literals introduced during edits.

## Validation Checklist (Pre-Commit / Generation)
- [ ] Target truly needs change (not already correct)
- [ ] Scope limited to stated intent
- [ ] No duplicated blocks introduced
- [ ] Single-source location preserved
- [ ] Security / performance / anti-pattern rules still satisfied
- [ ] Delta minimal & test impact localized

## Auto-Correction & Insight Use
- Use existing architecture & patterns before proposing alternatives.
- Flag but DO NOT auto-rewrite large surfaces—propose staged plan instead.
- Suggest consolidation when overlap detected across reference files.

## Escalation
If a minimal change is impossible without wider refactor:
- Provide: Reason → Required broader change → Risk → Proposed phased plan.
- Do NOT execute large refactor without explicit approval.

---
