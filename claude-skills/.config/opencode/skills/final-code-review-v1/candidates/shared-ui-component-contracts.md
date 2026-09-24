---
name: shared-ui-component-contracts
family: Frontend
tags: [shared-ui, web]
evidence: 5
---
# Shared UI component contracts

## Index line
Shared components that break caller styling, bake in call-site details, or lack a story reaching each state.

## What to look for
- The class name or style pass-through prop of a shared component lands on a different element than before, or on an inner element, so every caller's styling moves.
- Variant or size classes applied after the caller's classes, or with higher specificity, so the caller cannot override them. Check the merge order and whether the class merge utility is used.
- A caller-specific attribute, role, scope, or behaviour baked into the shared primitive, so the next caller inherits it without noticing.
- A prop added to a shared component for one caller's need when a wrapper or composition at the call site would do.
- A new component in the shared UI package or shared components folder with no story.
- A story whose name claims a state (loading, error, empty, disabled) but whose args or mocks never put the component in that state.
- A story that renders only the defaults for a component that has several variants or states.
- A change to a shared component's defaults, required props, or exported types that existing callers rely on. Search the callers.
- A shared component that starts reading app context or global state it did not before, so it no longer renders in isolation.

## Why it matters
- Every caller depends on the contract. A moved pass-through or a stronger variant class breaks styling across the app with no type error.
- Baked-in call-site details are invisible to the next caller and produce wrong markup nobody sees in review.
- Stories are the living spec for shared components. A missing or misleading story means the state cannot be checked by eye or by visual test.

## What not to flag
- Page-level or feature-local components. This candidate covers components many callers import.
- A shared component that deliberately accepts no outside styling, when that rule is stated and consistent across the package.
- Variant styles on properties the caller is not expected to change, when the merge still lets the caller win on what it passes.
- A story that covers the main state only, for a component that has no other states.
- Story tooling and visual regression setup as such; only the story's claim against the state it reaches.
- Whether the primitive should exist or duplicates a library component. That is reinvented-library-feature.

## Severity
- must fix: a pass-through prop moved to another element, or variant classes that override caller styling, when callers in the repo rely on the old behaviour.
- should fix: caller-specific details baked into the primitive; a new shared component with no story; a story that never reaches the state it names.
- nit: a story that shows only the default state for a component with few states.

## Remedies
- add a separate wrapper style prop and keep the original pass-through where it was
- merge classes so the caller's classes win
- move the call-site attribute out of the primitive
- add a story per meaningful state, with args or mocks that reach that state
- check every caller before changing a shared default

## Related
- reinvented-library-feature: whether the component should exist at all.
- accessibility: whether the attribute or role is right for users; here the concern is where it lives.
- blast-radius: unrelated flows changed by shared code; here the callers of one component.
- precedent-divergence: a component built unlike its siblings.
- wrong-home: layer placement in general; here a shared component's public contract.
- missing-test-cases: tests as such.

## Sources
- review threads: 5 accepted change requests from real code reviews