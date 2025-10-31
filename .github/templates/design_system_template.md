# Design System Template

> Use this template for User Stories and Tasks with confirmed UI impact. Omit entirely if `ui_impact = false`.

## UI Impact Assessment
**Has UI Changes**: [ ] Yes / [ ] No
If No: Stop here (do not include further sections).
If Yes: Complete all applicable sections below.

## Story / Task Context
**Story or Task ID**: [ID]
**Title**: [Concise Title]
**UI Impact Type**: [New UI | Enhancement | Redesign | Component Update]

## Primary Design References
Select one or more:
- **Figma Project**: [https://figma.com/file/PROJECT_ID/PROJECT_NAME]
- **Design Images**: [Path(s) to screenshots]
- **Design System Docs**: [Link]
- **Brand Guidelines**: [Link]

## Visual Asset Mapping (Choose A or B)
### Option A: Figma Frame Mapping
| Screen / Feature | Figma Frame ID | Link | Description | Priority |
|------------------|----------------|------|-------------|----------|
| [Screen Name] | node-id=2:45 | [Figma Link] | [Description] | High/Med/Low |

### Option B: Image Reference Mapping
| Screen / Feature | Image File | Path | Description | Priority |
|------------------|-----------|------|-------------|----------|
| login_design.png | .propel/context/Design/images/login_design.png | Login interface design | High |

## Design Tokens (Scoped to this UI)
```yaml
colors:
  primary:
    value: "#007AFF"
    usage: "Primary CTAs, active states"
    affected_components: ["Button", "Links"]
typography:
  heading1:
    family: "SF Pro Display"
    size: "32px"
    weight: "600"
    line-height: "40px"
    used_in: ["Page Headers", "Modal Titles"]
spacing:
  base: "8px"
  affected_layouts: ["Form spacing", "Card padding"]
```

## Component References (UI Components Only)
### Figma Components
| Component | Figma Component | Code Location | UI Changes |
|-----------|-----------------|---------------|------------|
| Button | node-id=C:123 | components/Button.tsx | New variant 'outline' |

### Image-Based References
| Component | Reference Image | Code Location | UI Changes |
|-----------|-----------------|---------------|------------|
| Button | components/button_variants.png | components/Button.tsx | New variant 'outline' |

## Visual Assets (New UI Elements)
```yaml
screenshots:
  location: ".propel/context/Design/US-[XXX]/"
  files:
    - name: "before_after.png"
      description: "Comparison of current vs new UI"
      source: "figma_frame: node-id=2:45"
new_assets:
  icons:
    - name: "search_icon.svg"
      source: "figma_export: node-id=I:789"
      purpose: "Search functionality"
```

## Task-Level Design Mapping
```yaml
TASK-001:
  title: "Implement Login UI"
  ui_impact: true
  visual_references:
    figma_frames: ["node-id=2:45"]
  components_affected:
    - Button (new 'primary' variant)
    - Input Field (add focus states)
  visual_validation_required: true
```

## UI Validation Criteria (Conditional)
```typescript
const requiresVisualValidation = task.ui_impact === true;
if (requiresVisualValidation) {
  const visualValidation = {
    screenshotComparison: {
      maxDifference: "5%",
      breakpoints: [375, 768, 1440]
    },
    componentValidation: {
      colorAccuracy: true,
      spacingAccuracy: true,
      typographyMatch: true
    }
  };
}
```

## Conditional Sections
### New UI Components
```yaml
new_components:
  - name: "SearchBar"
    figma_reference: "node-id=C:456"
    file_location: "components/SearchBar.tsx"
    design_specifications:
      width: "100%"
      height: "48px"
      border_radius: "8px"
      states: ["default", "focused", "error"]
```

### UI Enhancements
```yaml
ui_enhancements:
  existing_component: "Button"
  changes_required:
    - "Add loading state"
    - "Update hover animation to 200ms"
    - "Add disabled state styling"
  figma_reference: "node-id=C:123-updated"
```

### Backend / API Tasks
```yaml
backend_task:
  ui_impact: false
  design_references: "Not applicable"
  validation_type: "Unit tests and API testing"
```

## Accessibility Requirements (UI Only)
- WCAG Level: AA
- Color Contrast: Validate modified UI elements
- Focus States: For new/updated interactive components
- Screen Reader: ARIA labels for new elements

## Design Review Checklist (UI Only)
- [ ] Figma frames reviewed
- [ ] Design tokens extracted
- [ ] Component specs documented
- [ ] Visual validation criteria defined
- [ ] Responsive behavior specified
- [ ] Accessibility requirements noted

_Omit entire template if there is no UI impact._
