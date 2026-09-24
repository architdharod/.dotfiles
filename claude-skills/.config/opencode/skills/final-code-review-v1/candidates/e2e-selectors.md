---
name: e2e-selectors
family: Tests
tags: [e2e, tests]
evidence: 5
---
# End-to-end selectors

## Index line
E2E locators coupled to DOM nesting, translated copy, live counts, or page-wide scope instead of stable, scoped hooks.

## What to look for
- A locator that climbs to an ancestor or walks down several levels from an attribute, so the nesting depth becomes an undocumented contract.
- A locator built from translated user copy. It breaks on copy edits and in other locales.
- A locator that includes a live count or another dynamic value the test does not otherwise care about.
- The status or label the test means to assert is used to locate the element instead of being checked after locating it. If the text is wrong the element is not found, and the failure never says what was wrong.
- A form field, option, or button queried at page scope when more than one instance can exist. It works only while one is on screen.
- Options or rows collected page-wide from an open listbox, menu, or table instead of scoped to the open control.
- A component without a stable test hook, so the test reaches for classes, structure, or copy. The fix is to add the hook to the component and scope the query.
- Locators on generated class names, styling attributes, or element order.

## Why it matters
- Structure-bound locators break on unrelated markup changes and get fixed by copying the new structure.
- Copy-bound locators fail on translation and wording changes that do not change behavior.
- Page-wide queries pass against the wrong element when a second instance appears.
- A locator that embeds the expected value turns an assertion failure into a not-found timeout.

## What not to flag
- Role-based locators with a stable accessible name. They are the recommended first choice.
- Page-scoped queries for elements unique by construction: the page heading, a single open dialog.
- One level of scoping: a dialog, then a button inside it.
- Test ids added to shared components for this purpose. They are not dead code.
- Text assertions made after locating by test id or role.
- Selectors in component tests follow the same rules and are reported here too.
- What the test asserts once it has the element: that is weak-or-tautological-assertions.

## Severity
- must fix: the locator can match the wrong element when a second instance exists, so the test passes against the wrong target.
- should fix: DOM walking, translated copy, or live values in a locator; the asserted value used as the locator.
- nit: a missing test hook where a role locator would also work.

## Remedies
- add a test id to the component and scope the query to it
- locate by role or test id, then assert the text
- scope option and row queries to the open control
- replace the DOM walk with a scoped locator
- drop dynamic values from the locator

## Related
- weak-or-tautological-assertions: the assertion itself. This candidate covers how the element is found.
- test-fixtures-and-setup: fixtures and setup around the test.
- shared-ui-component-contracts: the shared component's own contract. Adding a test hook to it is a fix here, not a finding there.
- accessibility: missing roles and names make role locators impossible. Report the missing name there.

## Sources
- review threads: 5 accepted change requests from real code reviews
- other: none
