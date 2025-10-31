---
applyTo: "**/*.{jsx,tsx,js,ts,css,scss}" 
description: "Advanced frontend engineering guidance: modular styling separation, lazy loading governance, bundle control, UX performance budgets, and resiliency. Excludes basics already in reactjs, performance, a11y, and anti-pattern instruction files."
---

## Scope & Positioning
Augments existing React, performance, accessibility, and anti-pattern instructions. Focuses on advanced structural & operational frontend concerns: style modularity, code-splitting strategy, runtime resilience, bundle economics, and measurable UX budgets. Avoids repeating foundational React hook/state patterns.

## Styling Architecture
- Strict Separation: No inline style objects for layout/theme primitives; only dynamic token toggles (e.g., class merge) allowed.
- Style Module Domains: `styles/global`, `styles/themes`, `styles/components` – components import only what they need; avoid wildcard re-exports.
- Theming Contract: Theme switch must not trigger full page reload; rely on CSS custom properties (prefixed, e.g., `--color-text-primary`).
- Dead Style Detection: Introduce periodic CI job (e.g., PurgeCSS dry-run) – remove unused selectors proactively.
- Encapsulation: Prefer CSS Modules or scoped styles; avoid global cascade leakage except for reset, typography, variables.

## Component & Route Loading Strategy
- Route-Level Lazy Loading Mandatory: All non-root routes loaded via dynamic imports with suspense fallback.
- Critical Fold Policy: Only components impacting first meaningful paint load synchronously.
- Conditional Heavy Components: Charts, rich editors, media viewers gated behind intent (interaction or viewport intersection observer).
- Preload Heuristics: After idle (e.g., `requestIdleCallback` or 2s timeout) prefetch most-likely next route bundles.
- Error Boundaries: Wrap lazy route segments with boundary to isolate loading & render failures.

## Bundle Governance
- Budget Definitions (Gzipped): entry < 200KB, each async chunk < 120KB, vendor aggregate < 350KB (fail build if exceeded without waiver).
- Vendor Split Strategy: Separate framework core, visualization libs, and rarely-changed heavy libs (e.g., date/time, charting) for long-cache surfaces.
- Manual Chunking: Group infrequently co-loaded utilities to avoid over-splitting (configure bundler chunk groups explicitly).
- Import Hygiene: Enforce path-specific imports (`lodash/debounce`, not whole lib). CI rule against namespace imports on large libs.
- Asset Inlining Threshold: Inline only assets < 4KB; above this, prefer lazy loaded resource.

## Performance & UX Budgets
- Core Web Vitals Targets: LCP < 2.5s (p75), CLS < 0.1, INP < 200ms.
- Interaction Ready Metric: Time to interactive sub 3s on reference mid-tier device (document device profile).
- Long Task Monitoring: Add performance observer logging tasks > 50ms; aggregate & alert on regression.
- Skeleton vs Spinner: Prefer skeleton placeholders for content regions > 300ms expected load, avoid multiple nested spinners.

## State & Data Efficiency (Delta Only)
- Suspense Boundaries Granularity: Wrap data-fetching islands independently to prevent whole-page blocking.
- Client Cache Invalidation: Explicit stale time declarations; no implicit infinite caching unless truly immutable (e.g., build metadata).
- Over-Fetch Guard: Consolidate adjacent network calls when triggered within same event loop tick.

## Accessibility + Lazy Integration
- Fallback Content: Suspense fallbacks must communicate purpose (e.g., "Loading dashboard widgets"), not generic "Loading...".
- Focus Continuity: On route lazy load complete, ensure first landmark or heading is focusable programmatically for skip link use.
- Reduced Motion: Respect prefers-reduced-motion for load transition animations; supply non-animated alternative.

## Error & Resilience Patterns
- Segmented Error Boundaries: Distinct boundaries per major page zone (navigation shell, content pane, widget cluster) to localize failure impact.
- Retry Decorators: Lazy import failures (network) auto-retry once with exponential backoff + user-visible retry action.
- Offline Guard: Detect `navigator.onLine` changes, queue user mutations client-side, replay when restored.

## Asset & Resource Strategy
- Image Policy: Use responsive `<img srcset>` or dynamic import for large hero images; enforce AVIF/WebP first with JPEG fallback.
- Font Loading: Use `font-display: swap`; subset fonts (remove unused glyph ranges). Log FOIT events if exceeding 100ms.
- Third-Party Scripts: Defer or load after idle unless core to initial user task; isolate via async & integrity attributes.

## Testing Focus (Incremental)
- Performance Smoke: Automated Lighthouse CI thresholds enforce budgets; fail build on regression >5% without override note.
- Rendering Determinism: Snapshot only for structural anchors (ARIA tree, semantic structure), not visual noise.
- Dead Code Guard: Track unused exported components (bundler stats) – flag if stale 30 days.

## CI / Automation Recommendations
- Bundle Report Diff: Commit artifact summarizing size changes; PR must explain increases beyond thresholds.
- Unused Style Report: Weekly job enumerates selectors with zero matches in built HTML/JS, excluding dynamic patterns whitelist.
- Chunk Hash Stability: Alert if core vendor chunk hash changes absent dependency updates (catches accidental bundler config modifications).

## Quality Checklist
- [ ] No inline layout/style objects except dynamic variable toggles.
- [ ] All non-root routes lazy loaded with appropriate suspense + boundary.
- [ ] Heavy components gated & conditionally imported.
- [ ] Bundle budgets satisfied (entry, chunk, vendor).
- [ ] Web vitals budget documented & not regressed.
- [ ] Accessible fallbacks & focus management present.
- [ ] Image & font optimization strategy applied.
- [ ] Third-party scripts deferred or justified.
- [ ] Performance observer instrumentation active.
- [ ] CI reports (bundle diff, unused styles) green or justified.

## Focused Terminology
- Critical Fold: Above-the-fold content required for initial meaningful user experience.
- Long Task: Main thread task >50ms causing potential input delay.
- Skeleton UI: Lightweight structural placeholder representing forthcoming content shape.
- Chunk Hash Stability: Minimizing cache bust frequency for long-lived vendor assets.

