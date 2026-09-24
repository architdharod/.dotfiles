---
name: convoluted-control-flow
family: Structure
tags: [any]
evidence: 2 accepted ePort threads
---
# Convoluted control flow

## Index line
Dense compound conditions, branchy reassignment chains, and one-off special cases bolted onto shared paths.

## What to look for
- A condition that joins many boolean terms with mixed and, or, and negation on one line, with no named parts.
- A rule or predicate function written as a stack of such one-liners, so a reader cannot test one clause on its own.
- A variable declared mutable and reassigned across several branches, where one expression or a lookup could produce the final value.
- Nesting deeper than about three levels in a new or changed function.
- A branch added to a shared path that only one caller or one feature needs.
- The same mode or flag checked at several points in one function instead of one split by mode at the top.
- The same sub-expression repeated across several branches of one conditional.
- Early returns mixed with else chains so the reader cannot tell which path is the main one.
- A later branch that patches the result of an earlier one instead of computing the right value once.
- A change that makes an existing shared flow harder to follow even though the new behaviour is correct.

## Why it matters
- Each new branch multiplies the paths to test and to reason about.
- A wrong operator or a missing negation inside a dense condition looks the same as the right one; bugs hide there.
- Reassignment chains can leave the value unset or half set on a path nobody traced.
- One special case in a shared path invites the next; the flow tangles one MR at a time.

## What not to flag
- A guard clause at the top of a function that returns early on bad input.
- A short two-way conditional whose arms both fit on the screen and read at a glance.
- A switch over a closed set with one action per case. Whether it is complete belongs to closed-set-exhaustiveness.
- Branches that mirror distinct business outcomes, when each outcome has a name.
- A mutable variable assigned once inside a try block and read after it.
- Complexity that comes from the problem itself, when no simpler shape exists for the same behaviour.
- Code the diff did not touch, unless the diff makes it more tangled.

## Severity
- must fix: a one-off branch added to a shared flow that other features pass through, or a reassignment chain that can leave the value unset on some path.
- should fix: compound conditions with no named parts, reassignment chains a single expression replaces, nesting past three levels.
- nit: one unnamed compound condition that is still readable, or branch order that could be clearer.

## Remedies
- name the intermediate booleans or extract a predicate function
- compute the value as one expression
- replace the conditional with a lookup map
- move the special case into its own helper or policy
- split by mode at the entry point

## Related
- missed-simplification: a reframing that deletes the branches altogether, not just reshapes them.
- oversized-units: when size, not branch shape, is the problem.
- repeated-conditionals-on-type: the same switch on a type or kind in several places.
- wrong-home: when the special case belongs in another module, not just another branch.
- code-obviousness: control flow hidden behind events or callbacks.
- ambiguous-result-shapes: several independent booleans as a return shape.

## Sources
- ePort: !39 !71
- thermo-nuclear-code-quality-review skill: spaghetti growth
