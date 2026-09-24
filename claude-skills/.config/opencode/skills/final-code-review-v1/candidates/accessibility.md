---
name: accessibility
family: Frontend
tags: [web, shared-ui]
evidence: 9
---
# Accessibility gaps in new UI

## Index line
Missing or constant accessible names, color-only status, invalid states without a visible reason, lost focus or keyboard reach.

## What to look for
- A repeated control carries the same constant accessible name for every item, so a screen reader cannot tell the items apart.
- An interactive element with no accessible name at all: icon-only buttons, links, and toggles without a label or a labelled-by reference.
- A status shown by color or by an icon alone, with no text, tooltip, or accessible name that carries the same meaning.
- A field marked invalid, often from network-derived state, with no visible message and no link from the field to the message.
- One state of a control has a tooltip and is focusable while a new sibling state is not, so only one group of users gets the explanation.
- Data-table header cells without a column or row scope.
- A disclosure toggle with no expanded-state attribute, or one that unmounts while focused, so focus drops to the document body.
- A dialog opened by a timer or by code that receives no focus, or has no close action, so screen readers stay on hidden content.
- A composite widget built as one root per item instead of one root for the list, losing the keyboard navigation the library gives.
- A clickable element that is not a button or link and has no role, tab stop, or key handler.
- A badge or indicator that shows a positive mark for an item that does not meet the rule, contradicting the ticket.

## Why it matters
- A missing name or focus stop makes the flow impossible for keyboard and screen-reader users, not merely awkward.
- Color-only and icon-only status is invisible to color-blind users and to assistive tech.
- Invalid states with no reason leave every user guessing what to fix.

## What not to flag
- Decorative icons hidden from assistive tech beside a visible text label.
- Library primitives that wire names, roles, focus, and keyboard handling when used as documented.
- Color paired with text, or an icon paired with text.
- Contrast and type size set by design tokens the diff does not change.
- Copy that fails to follow state, and misleading empty states: ui-state-fidelity.
- Overflow, viewport, and truncation problems: layout-robustness.

## Severity
- must fix: a keyboard or screen-reader user cannot complete the flow: an unreachable control, a dialog without focus, the sole control for an action with no name.
- should fix: the explanation or state exists for one modality only, or repeated controls share one name.
- nit: a redundant or decorative attribute.

## Remedies
- give each control a distinct accessible name
- render the reason and link it to the field
- add scope to header cells
- add expanded state, keep toggles mounted, move focus into dialogs and give them a close action
- use one composite root for the whole list

## Related
- ui-state-fidelity: what sighted users see does not match the state.
- layout-robustness: layout breaks with real copy or other viewports.
- reinvented-library-feature: a primitive rebuilt by hand that also lost its accessibility.
- shared-ui-component-contracts: a shared component's variants and stories.
- text-disagrees-with-code: a comment that claims accessibility behavior the code does not have.

## Sources
- review threads: 9 accepted change requests from real code reviews
- real review threads only