---
name: wrong-home
family: Structure
tags: [any]
evidence: 33
---
# Code in the wrong home

## Index line
Code sits in a layer or module that does not own it, including one-consumer re-exports and downstream workarounds.

## What to look for
- The diff defines a schema, constant, helper, or rule in a layer that does not own the concept, so other code must import it from a layer it should not depend on. Check where the repo keeps siblings of the same kind.
- The diff writes validation or an invariant inline in a route or component while the repo keeps sibling invariants in a shared schema package.
- Page-specific or feature-specific code lands in a shared or generic folder, often under a generic name.
- A reusable hook, context, pure helper, or formatter is defined inside a component file although the repo keeps such things in dedicated folders.
- The diff creates a new file or module for something the project already has a home for: a constants module, a hooks folder, a test file per unit.
- A re-export, barrel entry, or pass-through shim is added or kept for one consumer's convenience. Consumers should import from the defining module.
- The scope of a registration, prefetch, or constant does not match its consumer: registered app-wide for one route, prefetched in a parent route for one page, or declared in a component although it governs a query defined elsewhere.
- A downstream workaround compensates for an upstream defect in the same repo, and shared code is added only to serve that workaround.
- A field describes a nested object but sits on the parent object of a payload.
- A feature-specific branch is added to a shared path although the repo has a per-type registry or hook point for it.
- User-facing copy sits inside a package whose other consumers are not UI.
- The diff re-implements, in its own layer, a lookup or method the owning layer already provides.

## Why it matters
- Readers look in the canonical place first. Code elsewhere goes unfound and gets written again.
- Wrong-layer imports point dependencies the wrong way and pull heavy modules into light ones.
- A downstream workaround hides the upstream defect, so every other consumer meets it too.
- Convenience re-exports blur ownership and grow into import cycles.

## What not to flag
- Placement that follows an established sibling pattern in the repo, even when another layout would also work.
- Imports through a barrel that the package publishes as its entry point for every consumer.
- A private helper used only by the file it sits in. It needs no shared home yet.
- Test-only helpers kept in the test tree.
- A global registration or prefetch that several routes use.
- A workaround for a third-party defect the team cannot fix, when a comment says so.
- Misplacement that existed before the diff. Report only what the diff adds or moves.

## Severity
- must fix: a workaround for an upstream defect the same repo could fix; app code importing from a layer it must not depend on; app-wide registration for one consumer that changes startup for everyone.
- should fix: schemas, hooks, helpers, constants, or components in the wrong module or folder; re-exports for one consumer; copy in a non-UI package.
- nit: placement that only affects discoverability and is cheap to move later.

## Remedies
- move to the owning module
- import from the defining module and delete the re-export
- fix the upstream defect and drop the workaround
- scope the registration or prefetch to its consumer
- extract into the project's dedicated folder

## Related
- validation-boundaries: which paths enforce a rule. This candidate only asks where the rule's code lives.
- duplicated-logic and single-source-of-truth: the same logic or list in two places, whatever the layer.
- blast-radius: what an over-wide registration or shared-path edit does to other flows.
- file-and-code-organization: order and mixing inside one file.
- precedent-divergence: a sibling pattern ignored for reasons other than placement.
- dead-code-and-export-surface: exports that only tests use; unused re-exports.
- complexity-pushed-to-callers: a helper whose interface makes callers do its work.
- repeated-conditionals-on-type: per-type branches that a registry should hold.
- dependency-direction: import direction across an architecture boundary.

## Sources
- review threads: 33 accepted change requests from real code reviews
- thermo-nuclear-code-quality-review skill: keep logic in the canonical layer
