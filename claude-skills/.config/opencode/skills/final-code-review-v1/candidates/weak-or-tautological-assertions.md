---
name: weak-or-tautological-assertions
family: Tests
tags: [tests, e2e]
evidence: 22 accepted ePort threads
---
# Weak or tautological assertions

## Index line
Tests that stay green when the code is wrong: existence-only, path-only, same-source, or partial assertions, and repeated neighbours.

## What to look for
- Existence-only checks on a value whose content is the point: truthy, defined, not null, not undefined. They pass on an empty object or a wrong value.
- Count-only or shape-only checks: length above zero, every item non-empty, a key present. Nothing pins which items or which values.
- Path-only assertions on a router, a branch, or a status code that cannot tell two failure branches apart, with body, code, and message unchecked.
- An expectation computed from the same map, fixture, or function that produced the result. The test passes for any content of that source.
- A test that asserts one of several outputs (one flag, one field, one label) and leaves the siblings unchecked, so swapping the rest keeps it green.
- A test whose name promises a guard, a contract, several fields, or an untouched sibling, while the body checks a round trip, a single field, or a coincidence.
- A test that passes because of a coincidence of the implementation (a pattern that happens to reject, a parser that accepts either arm), not because of the rule the name claims.
- A test that repeats what a neighbouring test already proves, or proves only that serialization round-trips.
- A helper exported and tested directly although only the public function uses it, so the test pins internals and the public behavior stays unpinned.
- Negative tests that check the status class only and never the detail the client will show.
- An assertion that does not pin which of several candidates came back: which item, which branch, which route.
- An end-to-end step whose name lists several fields and whose body checks one.

## Why it matters
- A test that stays green on broken code is worse than no test. The reader trusts it and skips the manual check.
- Coverage rises while the mutation the test was written to catch survives.
- A name that promises more than the body checks misleads the next reader about what is guaranteed.

## What not to flag
- An existence check as the first of several assertions when precise ones follow.
- A smoke test named as one, sitting beside precise tests.
- A case with no test at all: missing-test-cases. Here the test exists and proves too little.
- Tests at the wrong layer or a call site left untested: test-wiring-and-layer.
- Fixture shape, unused helper parameters, and setup cost: test-fixtures-and-setup.
- Snapshot tests where the project's convention accepts them for that layer.
- Duplicate tests you cannot show are duplicates. Name similarity is not enough; show the same inputs and the same assertions.

## Severity
- must fix: the only test of a guard, an authorization rule, or a data invariant stays green when that rule is removed.
- should fix: existence-only, path-only, or same-source assertions on the behavior the test is named for; a name that promises more than the body checks.
- nit: a redundant neighbour, or a weak first assertion followed by precise ones.

## Remedies
- assert the exact value, including body and code, not only status
- pin every output the name promises
- build the expectation by hand, not from the source under test
- fold the duplicate into its neighbour
- test through the public function and un-export the helper

## Related
- missing-test-cases: the absent test. Here: the present test that proves too little.
- test-wiring-and-layer: which layer tests what. Here: what the assertion pins.
- test-fixtures-and-setup: the setup around the assertion.
- dead-code-and-export-surface: an export that exists only for a test. Here: the test that made it necessary.
- text-disagrees-with-code: comments and docs versus code. Here: test names versus test bodies.

## Sources
- ePort: !43 !44 !45 !67 !168 !233 !288 !289 !290 !291 !293 !298
- other: none
