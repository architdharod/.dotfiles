---
name: layout-robustness
family: Frontend
tags: [web, shared-ui]
evidence: 7 accepted ePort threads
---
# Layout robustness

## Index line
Layout that breaks with real copy, other viewports, or overflow, or visibly departs from the design.

## What to look for
- A fixed width or height on a container that holds text from data, with no wrapping, truncation, or scrolling rule for long values.
- A panel, drawer, or dialog sized for one viewport, with no minimum width, no responsive rule, and no scrolling when the viewport is smaller.
- A scroll container where only one pane scrolls, or a grid row that grows to the tallest column, so content is clipped with no scrollbar.
- A tooltip or popover whose content comes from data and has no maximum width or wrapping, so it can leave the viewport.
- A flex or grid wrapper added around inline text, so a long title jumps to the next line as a block instead of wrapping inline as it did before.
- Cells in a grid or table that lose alignment as soon as one label wraps to a second line.
- Alignment or spacing that does not match the design: content not centered where the design centers it, or a control overlapping a scrollbar or another control.
- A label built by joining several fields into one string, so the reader cannot tell the parts apart. The same treatment applies wherever that label is shown.
- Text with a no-wrap rule and no truncation, or truncation with no way to see the full value.

## Why it matters
- Layouts are built with short sample copy. Real names, titles, and translated strings are longer and break them first.
- Clipped or overflowing content hides information and controls with no error and no log line.
- Alignment defects and flat labels slow scanning and make the product look unfinished.

## What not to flag
- Truncation with an ellipsis plus a way to see the full value. That is a valid choice for long copy.
- Layouts at viewports the product does not support, when the repo states its supported sizes.
- A concern you cannot trace to the code. Flag only when the diff shows the cause: a fixed size, a no-wrap rule, a missing overflow rule, a missing minimum size, or a wrapper that changes the text flow.
- Text from a small fixed set of short labels that cannot grow.
- Spacing that differs from the design by the design system's own scale rounding.
- A wrapper element that adds nothing but breaks nothing. That is shallow-abstractions.

## Severity
- must fix: content or controls clipped or unreachable at a supported viewport, or an overlay that leaves the viewport.
- should fix: wrapping or alignment that breaks with realistic copy, and layout that visibly departs from the design.
- nit: a composite label that could be split into parts.

## Remedies
- add wrapping, truncation, or a maximum width for data-driven text
- add a minimum width or a responsive rule
- make the scroll container the part that grows
- remove the wrapper that changes the text flow
- render the parts of a composite label as separate elements

## Related
- shallow-abstractions: a wrapper with no job goes there. Report it here only when it causes a visible defect.
- ui-state-fidelity: content that does not match the state goes there. Geometry, overflow, and alignment are here.
- accessibility: color-only status, accessible names, and keyboard reach go there.
- shared-ui-component-contracts: a shared component's variants fighting caller styles goes there. Page layout is here.
- scope-and-requirements: missing features against the reference system go there. Visual departures from the design are here.

## Sources
- ePort: !43 !52 !98 !229 !233 !293
- other: none
