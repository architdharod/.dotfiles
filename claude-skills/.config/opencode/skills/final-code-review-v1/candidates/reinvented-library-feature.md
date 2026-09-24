---
name: reinvented-library-feature
family: Structure
tags: [web, shared-ui, api]
evidence: 10
---
# Reinvented library feature

## Index line
A UI primitive or library feature hand-built, worked around, miscomposed, or copied and drifting, although the library provides it.

## What to look for
- A hand-built container, disclosure, accordion, dialog, menu, button, or form field where the project's UI package or component library already ships one with accessibility built in.
- A plain HTML element with hand-rolled focus, hover, size, or disabled styles next to a shared component that has a variant for that look. A one-off look usually maps to an existing low-emphasis variant.
- A hand-rolled field in one step of a multi-step form while sibling steps use the shared form field component.
- An empty or no-op handler passed to a component to suppress its default behavior, where the component exposes a prop for that intent.
- One library root instantiated per item where the library documents a single root with a multiple mode. Keyboard navigation between items is lost.
- Library parts composed against the documented structure: parts nested in the wrong order, a part used outside its root, or a prop set on the wrong part.
- A comment that explains why the hand-built version does something the library version does by default.
- A schema or config type that the code generator or plugin documents as unsupported for that case, so the generated output is wrong or empty.
- A copied or vendored primitive described as stock that was copied from an older upstream revision and lacks a later upstream change.
- A copied primitive with no note of which upstream revision it came from or why it was copied.

## Why it matters
- Hand-built primitives drop keyboard support, focus management, and screen reader semantics that the library gives for free.
- Bespoke styles drift from the design system with every theme change.
- Workarounds against a component's default behavior break on the next library upgrade.
- Copies with no upstream reference cannot be updated and silently miss fixes.

## What not to flag
- A visual pattern with no counterpart in the library or design system.
- A library primitive wrapped once in the shared UI package with a documented reason. That wrapper is the project's own primitive.
- A vendored copy pinned to a named upstream revision with a stated reason and a note of local changes.
- A lower-level primitive from the same library used because the higher-level one cannot meet a documented requirement.
- The internal quality of a shared component (variants, stories, style overrides): that is shared-ui-component-contracts.
- A repo-internal helper re-implemented in the repo: that is duplicated-logic.
- Accessibility defects in code that does not replace a library primitive: that is accessibility.

## Severity
- must fix: the hand-built version drops keyboard or screen reader behavior the library provides, or the unsupported usage produces wrong generated output.
- should fix: a bespoke element where a shared component with a matching variant exists, a no-op workaround where a prop exists, a per-item root where one root is documented, a copied primitive with no upstream reference.
- nit: a comment that justifies library-default behavior, a composition deviation with no user-visible effect.

## Remedies
- replace with the library primitive or the shared component's existing variant
- use the documented prop instead of the no-op handler
- collapse to one root with the library's multiple mode
- align sibling steps to the shared field component
- pin the copy to a named upstream revision and list local changes

## Related
- duplicated-logic: re-implementing repo code. This candidate covers library and UI package features.
- shared-ui-component-contracts: the shared component's own contract. This candidate covers callers that bypass it.
- accessibility: accessibility defects in general. Here the defect comes from bypassing a primitive that had it.
- precedent-divergence: a sibling already uses the library way. Report it here when the library is the point.
- text-disagrees-with-code: a copy described as stock when it is not is reported here, not there.

## Sources
- review threads: 10 accepted change requests from real code reviews
- other: none
