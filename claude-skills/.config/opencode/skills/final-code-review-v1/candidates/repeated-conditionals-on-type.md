---
name: repeated-conditionals-on-type
family: Design (books)
tags: [any]
evidence: 0 accepted ePort threads
---
# Repeated conditionals on a type

## Index line
The same switch or if-chain on a type, status, or kind appears in several places instead of one dispatch.

## What to look for
- The diff adds a switch or if-chain on a type, kind, status, or role, and another file already branches on the same discriminant. Search the repo for the discriminant's members.
- The diff adds a member to a closed set and has to touch several branches to teach each one about it.
- Several functions branch on the same discriminant and each returns one attribute (a label, an icon, a color, a handler, a route). Together they describe one table.
- A shared path grows a per-variant branch although the repo has a registry, map, or handler per variant for that discriminant.
- The same branch on a discriminant appears on both sides of a boundary: API and web app, schema package and consumer.
- String comparisons on a discriminant are scattered through a component tree, where one lookup at the top could pass the resolved values down.
- A boolean derived from the discriminant is re-derived at several places instead of once.
- Runtime shape tests on an object are repeated at call sites, where the variants could carry the behavior themselves.

## Why it matters
- Adding a variant means finding every branch, and the one that is missed is a runtime hole.
- Behavior for one variant is spread across files, so no reader sees it whole.
- Each copy of the chain drifts, until two branches disagree about the same status.

## What not to flag
- A single switch in one place. That is the intended home of the dispatch.
- Branches on the same discriminant in different layers that select unrelated things, when a shared table would couple layers that should not know each other.
- A binary branch that reads better inline than as a map.
- A switch the type checker enforces as exhaustive, one per concern, when the concerns differ.
- Framework idioms where a switch is expected: reducers, routers.
- Chains that existed before the diff and that the diff does not extend or copy.

## Severity
- must fix: the diff adds a new copy of a chain on a discriminant that a registry or map already dispatches.
- should fix: the diff adds a variant and edits several chains; several new functions branch on one discriminant.
- nit: two short chains that a lookup table would merge.

## Remedies
- replace the conditional with a lookup map
- register the variant in the existing registry
- dispatch on a discriminated union once at the top
- move the behavior onto the variant
- pass resolved values down instead of the discriminant

## Related
- closed-set-exhaustiveness: whether one map or switch covers every member.
- incomplete-propagation: a new member missed in some places, the symptom. Here the design that creates many places.
- convoluted-control-flow: long compound conditionals inside one function.
- precedent-divergence: an existing registry pattern ignored.
- single-source-of-truth: parallel hand-maintained maps and lists.
- wrong-home: feature branches in a shared path, when the issue is placement rather than repetition.
- duplicated-logic: the same logic twice in general.

## Sources
- ePort: none
- refactoring.guru: switch statements; Refactoring (Fowler): repeated switches
