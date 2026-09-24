---
name: missed-simplification
family: Structure
tags: [any]
evidence: 0
---
# Missed simplification

## Index line
A reframing exists that deletes whole branches, modes, flags, layers, or state while keeping behavior.

## What to look for
- The diff adds a boolean flag, mode, or nullable parameter to an existing function so one caller can behave differently. Ask whether both callers could share one path if the difference were resolved before the call.
- The diff adds a branch for a case that would not exist if the input were normalized or shaped once at its source.
- The diff adds a helper, layer, or piece of state to carry a value that an existing mechanism in the architecture already delivers to that point.
- Two paths in the diff differ in one small detail. They could be one path with the detail passed as data.
- A refactor moves code between files, but the number of concepts a reader must hold (branches, flags, helpers, modes) stays the same or grows.
- The diff stores a value in state, a column, or a cache that the code could recompute or read directly at the point of use.
- The diff keeps a transitional dual path, old and new behavior side by side, although both sides could converge in this MR.
- The diff introduces a new type, status, or mode whose cases map one to one onto a concept the codebase already has.
- The diff handles one special case at several downstream points where handling it once upstream would remove every downstream check.

## Why it matters
- Each extra branch, flag, or mode is a concept every future reader must hold and every future change must respect.
- Complexity that is rearranged instead of deleted keeps its cost and adds the cost of the rearrangement.
- The simpler frame usually reveals the real model. The branchy one hides it and invites the next special case.

## What not to flag
- A reframe that changes behavior, even slightly. This candidate is only for behavior-preserving restructuring.
- A reframe you cannot state in two sentences with the removed pieces named. "Could be cleaner" is not a finding.
- A reframe whose cost is far larger than the diff. Report it as a nit at most.
- Wrappers, pass-through helpers, and identity abstractions that add nothing now: shallow-abstractions.
- Long conditionals and special-case branches bolted onto shared paths: convoluted-control-flow.
- The same logic in two places: duplicated-logic. A hand-built library feature: reinvented-library-feature.
- Style rewrites of one expression or loop that remove no concept.
- A transitional path whose comment names the condition for its removal and whose other half is outside this MR's scope.

## Severity
- must fix: never on its own. A missed reframe does not break behavior.
- should fix: the reframe is clear, fits inside this MR, and removes a named branch, flag, mode, layer, or piece of state.
- nit: the reframe is plausible but needs work outside the diff, or removes little.

## Remedies
- normalize the input once at its source and delete the downstream branch
- merge the two paths and pass the difference as data
- derive the value instead of storing it
- reach the existing mechanism directly and drop the new layer
- collapse the transitional dual path

## Related
- shallow-abstractions: an abstraction that buys nothing now. Here the question is whether the whole shape of the change could be simpler.
- convoluted-control-flow: the branching itself is tangled. Here a different frame makes the branches disappear.
- speculative-generality: pieces added for a future need. Here the pieces serve a present need in a roundabout way.
- derived-state-and-effect-sync: stored state that should be derived, in React specifically.
- define-errors-out-of-existence: the same move applied to error cases.

## Sources
- review threads: none (seed only)
- thermo-nuclear-code-quality-review skill: code judo
- A Philosophy of Software Design, ch. 3 (strategic programming) and ch. 16 (modifying existing code)
