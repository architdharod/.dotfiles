---
name: blast-radius
family: Structure
tags: [any]
evidence: 12 accepted ePort threads
---
# Blast radius of shared changes

## Index line
A shared-code change alters flows the MR did not target, removes unrelated behavior, or deletes what planned work needs.

## What to look for
- The diff edits a shared component, layout, route shell, schema, plugin, or global style. List every consumer and ask whether each one wants the new behavior.
- A shared component's contract changes to serve one caller: a prop rerouted to another element, a default flipped, a behavior switched off.
- A global or layout-level change fixes one page's problem with overflow, scrolling, or spacing.
- A shared schema is widened or tightened, so other endpoints' published contracts change or other flows now parse strictly on a field they never set.
- Something is registered app-wide for one route, so startup or every request now depends on it.
- One component or input is replaced by another and the replacement drops integrations the old one had: form wiring, validation display, accessibility attributes, loading states.
- A refactor or cleanup removes a behavior nothing in the MR asked to remove (a guard, an animation, a fallback), and no test pinned it.
- A cleanup deletes an enum value, column, or export that planned near-term work needs, so re-adding it costs a migration.
- A wrapper or structural change around existing elements alters how they wrap, size, or scroll.
- Compare the changed files against the base version. Behavior that vanished without a mention in the MR description is a finding.

## Why it matters
- Consumers the author never opened break in ways the MR's tests do not cover.
- Contract changes on shared schemas or components ripple into clients and generated artifacts.
- Silent removals ship because no reviewer looked at the untouched flows.

## What not to flag
- A shared change whose consumers the author listed and adapted in the same MR.
- A change to shared code that the MR set out to make and describes, where the wider effect is the point.
- Removal of a behavior the MR description or ticket retires, with tests updated to match.
- Removal of something only a stale comment or reference still points at, with no planned consumer.
- Wide-scope registrations or global styles that existed before the diff and that the diff does not touch.
- A shared change that several siblings need, applied to some and not others. That is incomplete-propagation.

## Severity
- must fix: a shared contract changed for one consumer without adapting the others; a behavior removed without mention; a deletion that planned work needs.
- should fix: a global fix for a local problem where a consumer-level fix exists; a replacement missing the old integrations.
- nit: a cosmetic shift in an untouched flow.

## Remedies
- override at the consumer
- scope the change to the new route or page
- add a separate prop instead of changing the existing contract
- keep the value and retire it in the MR that no longer needs it
- pin the untouched behavior with a test before refactoring

## Related
- wrong-home: where code sits. This candidate covers what a wide placement does to other flows.
- incomplete-propagation: siblings that should have changed and did not. Here the siblings should not have changed.
- shared-ui-component-contracts: variant and style overrides and stories of shared components.
- layout-robustness: layout that breaks with real copy or viewports, when the diff meant to touch that layout.
- validation-boundaries: schema strictness as a rule. Here the concern is which flows a stricter parse reaches.
- scope-and-requirements: what the MR was meant to do.

## Sources
- ePort: !41 !52 !56 !71 !85 !98 !183 !230 !259 !265 !293
- other sources: none
