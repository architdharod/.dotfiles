---
name: test-fixtures-and-setup
family: Tests
tags: [tests, e2e]
evidence: 16
---
# Test fixtures and setup that prove less than they claim

## Index line
Fixtures too thin, unrealistic, or too broad; costly resources rebuilt per test; teardown that skips on failure.

## What to look for
- A fixture is a partial object cast to the full type, so any new field access crashes the test instead of failing it.
- A fixture too thin to fail on the decision under test: one candidate row where ordering is asserted, or the entity that selects the real branch is missing so only the fallback runs.
- Test inputs that never occur at the call site, so the test passes only on unrealistic data. Compare the fixture with what production callers send.
- Tests omit a prop or argument every production caller passes, so the shipped branch is never exercised.
- Duplicate rows that differ only in a field no assertion reads, so first-wins and last-wins cannot be told apart.
- A seed or factory default that treats an explicit null like absent, so a test asking for the empty case silently gets the filled one.
- A test that loads the whole production seed, coupling every test to its contents.
- The application or another costly resource rebuilt for each test where a few shared instances per role would do; an extra instance for a role the default one already has; a leftover default instance beside the shared ones.
- A helper with a parameter no caller uses, or a negative test that uses a real-looking constant it never imports, so it reads specific while pinning nothing.
- A global assigned directly with inline cleanup, so a failing assertion skips the teardown and leaks into later tests.

## Why it matters
- A test that passes on data production never sends proves nothing and blocks the refactor that would break it.
- Thin fixtures let the wrong implementation pass: ordering, dedup, and branch selection all go untested.
- Leaked state and rebuilt resources make suites slow and flaky, and flaky suites get ignored.

## What not to flag
- Partial fixtures built by a factory that fills the rest with valid defaults.
- Fresh instances where isolation is needed because the test mutates shared state, and the test says so.
- Short setup repeated across tests for readability.
- The assertion itself is weak: weak-or-tautological-assertions. A case is missing entirely: missing-test-cases.
- End-to-end suites that run against the production seed by design.

## Severity
- must fix: the setup makes the test pass on data or a branch that cannot occur in production, or teardown leaks into later tests.
- should fix: fixtures too thin to fail on the decision under test, or costly resources rebuilt at a real cost.
- nit: an unused helper parameter or a leftover instance.

## Remedies
- build a full valid object through a factory
- share the instance per role in a suite-level hook
- make the fixture distinguish the rule under test
- pass explicit null through the seed helper
- use the runner's stub and its after-each hook

## Related
- weak-or-tautological-assertions: the assertion cannot fail; here the setup cannot make it fail.
- missing-test-cases: a case has no test at all.
- test-wiring-and-layer: the right unit is tested at the wrong layer or call site.
- e2e-selectors: locators, not fixtures.
- precedent-divergence: a new setup idiom where the file already has one.

## Sources
- review threads: 16 accepted change requests from real code reviews
- real review threads only