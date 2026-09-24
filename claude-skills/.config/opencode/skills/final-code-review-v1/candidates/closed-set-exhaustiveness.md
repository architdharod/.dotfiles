---
name: closed-set-exhaustiveness
family: Structure
tags: [any]
evidence: 6
---
# Closed sets, exhaustiveness, and unenforced invariants

## Index line
Maps and branches over a closed set that compile with a member missing; assumed invariants nothing enforces; misclassified members.

## What to look for
- A record or map keyed by a union or enum is typed as partial, keyed by string, or left as an untyped literal, so a missing member compiles.
- A switch or if-chain over a closed set ends in a default branch that returns a fallback, so a new member silently takes the fallback instead of failing the type check.
- The diff loosens an existing guard: a full record type becomes partial, an exhaustive switch gains a default, a never-check is removed.
- Two maps or lists keyed by the same set live in different modules with no shared key type tying them, so one can gain a member the other lacks.
- Code relies on a relation between two values or sets (membership in one implies membership in the other, one status implies a field is set) and nothing checks or documents it.
- A lookup relies on an upstream property of its key (casing, trimming, format) instead of normalizing at the point of use.
- A hand-maintained set, allow-list, or branch puts a member on the wrong side of the rule it implements. Check each member against the rule's meaning, not its name.
- A config exemption, glob, or convention covers a wider set than the rule it stands for, so the invariant holds only by discipline.
- A domain rule is stated in a comment or docblock, and the code that could enforce it does not.

## Why it matters
- A new member of the set takes a silent fallback or an undefined lookup instead of a compile error, and the failure shows up far from the cause.
- An assumed relation between values holds today by accident. The first row that breaks it produces wrong results with no error.
- A misclassified member gives wrong filters, counts, and permissions, and tests that never enumerate the set stay green.

## What not to flag
- Sets that are open by nature: free text, external ids, user input.
- A map meant to be partial by design, where the code handles the miss explicitly and the type says so.
- A missing test for one member of the set: missing-test-cases.
- Two copies of the same table or list: single-source-of-truth.
- A site the diff forgot when adding a member: incomplete-propagation. This candidate is about the missing guard that would have caught it.
- Runtime guards for cases the type already forbids: type-runtime-contradiction.
- A key property the shared schema already enforces at the boundary before the lookup runs.

## Severity
- must fix: a member sits on the wrong side of a rule that decides access, money, deletion, or status.
- should fix: a map or switch over a closed set compiles with a member missing, or an assumed invariant has no check.
- nit: the guard exists only in a test or a comment; add the type-level one.

## Remedies
- type the map as a full record over the union, or add a never-check to the default branch
- share one key type between the maps
- normalize the key at the point of use
- assert the invariant where it is assumed and document it
- move the member to the correct side of the rule

## Related
- missing-test-cases: no test for a member. Here: no type or check for it.
- single-source-of-truth: two copies of one table. Here: two tables over one set with nothing tying them.
- incomplete-propagation: the forgotten site. Here: the guard that should have made forgetting impossible.
- type-runtime-contradiction: types and runtime checks that disagree. Here: types too loose to catch a missing member.
- validation-boundaries: where input is normalized. Here: code assuming a normalization nothing did.

## Sources
- review threads: 6 accepted change requests from real code reviews
- other: none
