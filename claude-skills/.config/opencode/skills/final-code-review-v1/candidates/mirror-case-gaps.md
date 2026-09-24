---
name: mirror-case-gaps
family: Correctness
tags: [any]
evidence: 8
---
# One direction handled, the other forgotten

## Index line
A sync, reconciliation, guard, or test handles one direction of a symmetric pair and forgets the other.

## What to look for
- A two-way sync where the diff wires one direction only. State mirrored between two places should update both ways, or the code should say why not.
- A flag or state set on entry and cleared on the success path only. Check the error, cancel, and early-return paths.
- A reconciliation that adds what is missing on one side but never removes what is extra, or the reverse.
- A pair of inverse operations where the diff changes or tests only one of them.
- A field made optional or nullable, with tests for the present case only. The absent case needs its own test.
- A guard against a race on one path, while the sibling path with the same race has no guard or no test.
- A shared mechanism with two outcomes, tested through only one of them.
- A comment or docblock that claims two sides mirror each other or mirror a constraint. Check that both sides exist and both are tested.
- A constraint enforced on read but not on write, or checked at a boundary in one direction only.
- A test suite that covers the allowed direction of a rule and never the denied direction.

## Why it matters
- The untested direction is where the bug lives. A symmetry claim in a comment gives false confidence.
- One-way sync produces state that drifts and a UI that shows stale values with no error.
- A flag cleared on one path only leaves the system stuck after the first failure.

## What not to flag
- Pairs that are not symmetric by design. Some operations have no inverse, and some syncs are one-way on purpose. Flag only when the other direction is needed or claimed.
- A mirror case covered by a test in another file, at another layer, or in the e2e suite. Search the whole suite before flagging.
- One direction left out on purpose, with a comment that says why and a follow-up noted.
- Operations that share a name pattern but not a contract. Symmetric-looking names do not make a pair.
- Missing negative or boundary tests that have no mirror image. Those are missing-test-cases.
- One-way data flow or navigation that the framework defines as one-way.

## Severity
- must fix: a flag or sync that leaves the UI or the data stuck or drifting after one path runs.
- should fix: an inverse operation, guard, or reconciliation direction that exists but is untested, or that a comment claims but the code lacks.
- nit: a trivial helper pair where one side lacks a test and both share the same logic.

## Remedies
- add the mirror case test
- wire the missing direction
- clear the flag on every exit path
- reconcile both sides: remove as well as add
- state the asymmetry in a comment when one direction is enough on purpose

## Related
- missing-test-cases: negative and boundary cases with no mirror image. This candidate covers pairs only.
- state-transition-integrity: lifecycles that cannot complete. A stuck flag borders it; the forgotten exit path is this candidate.
- incomplete-propagation: a change applied to some siblings in a set. This candidate is a pair with a direction.
- guards-from-wrong-or-partial-sources: a guard reading the wrong fact. Here the guard exists on one side only.
- outcome-signaling: an error path that leaves no trace for the user.

## Sources
- review threads: 8 accepted change requests from real code reviews
- real review threads only