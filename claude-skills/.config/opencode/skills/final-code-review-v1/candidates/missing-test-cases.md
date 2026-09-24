---
name: missing-test-cases
family: Tests
tags: [tests]
evidence: 24
---
# Decisions that ship with no test to catch their removal

## Index line
A decision, guard, boundary, or closed-set member ships with no test that fails when it is removed or mutated.

## What to look for
- For each guard, validation rule, or condition the diff adds, ask which test fails if it is deleted or its operator flipped. If none, the decision is unpinned.
- A rejection or denial path with tests only for the accepting side. Each way an input can be refused needs a test that it is refused.
- A comparison or threshold tested away from its edges. Test the exact edge, one step past it, and the case where both sides are equal.
- A range or overlap check tested for plain overlap only. Containment, identical ranges, and touching edges are separate partitions.
- A rule keyed on an enum or closed set, tested for some members only. The odd-one-out member is the one most likely to be wrong.
- A table of pairs or combinations tested for one or two rows. When the table is data, the test should iterate every row.
- A hand-transcribed mapping or constant table with no test that pins it against its source.
- A fallback, degradation, compensation, or rethrow branch with no test. When the branch is an accepted failure mode, a test is how the reader learns that.
- A wire shape with several ways to express an empty result, with only one of them tested.
- A guard or behaviour in existing code that the diff removes or changes, where no test had pinned it. Ask whether the removal was intended.
- A workaround, patch, or vendored copy whose reason for existing is demonstrated nowhere. If the bug it works around returns, nothing catches it.
- A concurrency or ownership guard with no test that exercises the losing side of the race.

## Why it matters
- A guard nobody tests can be deleted by the next refactor with the suite green. The suite then protects nothing.
- Edges and odd members are where logic is most often wrong and least often tried by hand.
- Untested fallback branches hide the accepted failure mode from readers.
- A removed behaviour with no pinning test is found by users, not by CI.

## What not to flag
- Assertions that exist but cannot fail for the wrong reason. That is weak-or-tautological-assertions.
- The layer a test sits at, or a unit tested without its call site. That is test-wiring-and-layer.
- Fixture shape and setup cost. That is test-fixtures-and-setup.
- The one untested direction of a symmetric pair. That is mirror-case-gaps.
- A case covered elsewhere: another file, another layer, the e2e suite, or a type-level check that makes the case impossible. Search before flagging.
- Whether a map over a closed set is complete. That is closed-set-exhaustiveness. Whether each member's behaviour is tested is this candidate.
- Pass-through code with no decision in it.
- Coverage of code the diff did not touch, unless the diff changed its behaviour or removed a guard.

## Severity
- must fix: a new guard, auth check, or validation rule whose removal fails no test; a removed behaviour that nothing pinned.
- should fix: edges, remaining closed-set members, fallback and compensation branches, hand-transcribed tables, the losing side of a race.
- nit: extra partitions on logic that is trivial and shared, or where the risk is low and the test cost is high.

## Remedies
- add the negative case
- add the edge cases: at the edge, one past it, and equal
- iterate the closed set in a table-driven test
- pin the decision with a test that fails when it flips
- add a regression guard next to the workaround

## Related
- weak-or-tautological-assertions: a test exists but proves nothing.
- test-wiring-and-layer: the right layer and the call site.
- test-fixtures-and-setup: fixture quality and cost.
- mirror-case-gaps: the other direction of a pair.
- closed-set-exhaustiveness: the map is complete by type or test. Here, each member's behaviour has a test.
- blast-radius: the diff removes an unrelated behaviour. Here, the point is that no test pinned it.
- state-transition-integrity: whether a guard is correct. Here, whether it is tested.

## Sources
- review threads: 24 accepted change requests from real code reviews
- real review threads only