---
name: test-wiring-and-layer
family: Tests
tags: [any]
evidence: 9 accepted ePort threads
---
# Test wiring and layer

## Index line
A unit is tested but its call site is not, or tests run at a layer without asserting its contract.

## What to look for
- A pure function or helper has tests, but no test drives the caller's branch that uses its result. The call could be dropped or inverted and every test would stay green.
- The diff extracts a rule into a tested helper and leaves the call site unpinned, so the extraction moved coverage away from the wiring.
- Tests render or call a unit with inputs no production caller uses, or omit an input every production caller passes, so the shipped branch never runs.
- Tests assert on the argument handed to a mock rather than on the outgoing effect (the header sent, the row written, the message emitted), so a contract change between the layer and its dependency passes.
- Data parsed and kept at one layer, with no assertion that it reaches the next layer: persisted, sent, or rendered.
- The only builder of a critical payload, query, or message has no test that inspects its output.
- Tests at an expensive layer (HTTP, containers, browser) repeat what a cheaper layer's tests already check and assert nothing the expensive layer adds: status mapping, which field failed, headers.
- Pure tests (schema parsing, formatting) placed in the integration or end-to-end project, paying for infrastructure they never use.
- A branch in a helper that no spec reaches. It may be sound on inspection, but nothing pins it.

## Why it matters
- Unit coverage without wiring coverage lets a refactor disconnect a rule while every test stays green.
- Mock-argument assertions test the test's own assumptions, not the contract.
- Expensive-layer duplicates slow the pipeline and hide which layer owns a behavior.

## What not to flag
- An integration test that repeats a unit case on purpose to prove the wiring end to end, when it also asserts the layer's own contract.
- A helper whose only call site is covered by an end-to-end test the pipeline runs.
- Test files placed where the repo's convention puts them, even when a cheaper project exists.
- Missing negative or boundary cases inside an otherwise wired test. That is missing-test-cases.
- Assertions that are weak in themselves. That is weak-or-tautological-assertions.
- Fixture shape and setup cost. That is test-fixtures-and-setup.

## Severity
- must fix: a critical builder or call site with no test that would fail if it were disconnected; mock-argument assertions on a live external contract.
- should fix: tests using inputs no caller uses; an extracted rule with an unpinned call site; expensive-layer tests that repeat cheaper ones without their own assertions.
- nit: pure tests sitting in the integration project.

## Remedies
- add a call-site test that observes the branch
- assert the outgoing effect instead of the mock argument
- test with the inputs production passes
- move pure tests to the unit project
- assert the layer's own contract in the expensive-layer test

## Related
- missing-test-cases: absent cases for a unit. Here absent coverage of the wiring between units.
- weak-or-tautological-assertions: assertions that cannot fail. Here assertions on the wrong object.
- test-fixtures-and-setup: fixture realism and cost. Here whether the shipped branch runs at all.
- e2e-selectors: how end-to-end tests locate elements.

## Sources
- ePort: !144 !259 !274 !280 !288 !289 !293
- other sources: none
