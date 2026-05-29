---
name: adversarial-tests
description: Hunt for edge cases and failing cases in existing code by hypothesizing how it breaks, then writing tests to confirm. Use after implementing a feature/story, or when the user wants adversarial/edge-case/break-it tests, negative tests, or to stress-test a code area.
---

# Adversarial Tests

## Mindset

Your job is to **break this code**, not to confirm it works. The code was written to pass
the happy path — verifying that teaches you nothing. Assume there is a bug and go find it.

A test that passes on the first run is the least interesting outcome. Hunt for the input,
the ordering, the boundary, the failure mode the author didn't think about.

**Bans — do not do these:**

- **No happy-path tests.** "User checks out with a valid cart" is not your job. The model
  already overproduces these; you exist to cover what they miss.
- **No coverage-padding.** Chase _interesting_ failures, not line/branch coverage numbers.
  One test that surfaces a real bug beats twenty that lift a coverage percentage.
- **This is NOT TDD red-green-refactor.** See the `tdd` skill for building new code. Here the
  code already exists, so a **red test is a finding, not a to-do item.** You never write code
  to make it green.

## Step 1 — Scope

**Default: the current feature branch.** Most often you're invoked right after a feature or
story was implemented, so the code to attack is whatever that branch changed.

- Detect the base branch (`git symbolic-ref refs/remotes/origin/HEAD`, else fall back to
  `main` / `master` / `develop`).
- `git diff --stat <base>...HEAD` to see the changed files, then read the changed code.
- State the detected scope back to the user before proceeding ("Attacking the 4 files changed
  on this branch vs `main`: …").

**Fallback / override:** if there's no meaningful diff (you're on the base branch, clean
tree) or the user named a specific feature/area/file, use that instead. If it's ambiguous,
ask which scope to target.

## Step 2 — Understand the code and the test setup

- Read the target code thoroughly — its inputs, outputs, invariants, and assumptions.
- **Discover the project's testing conventions from the repo** — framework, test file
  location, naming, and the command to run tests. Do NOT hardcode framework assumptions;
  match what's already there.
- Borrow the one principle from the `tdd` skill that still applies: **assert behavior through
  public interfaces, not implementation details.** Findings should survive a refactor — a bug
  is a bug regardless of internal structure.

## Step 3 — Hypothesize (write the scratch file FIRST)

Before writing a single test, brainstorm how the code might break, using the taxonomy below,
and record every hypothesis in a scratch file (`adversarial-hypotheses.md` at the repo root,
or under `/tmp` if the repo must stay clean).

Writing them down before testing is the whole point: it forces breadth and stops you from
quietly skipping the hard ones. Each entry:

```
- [ ] condition / input  ·  why it might break  ·  expected-correct behavior  ·  priority
```

Briefly show the user the hypothesis list before you start testing.

### Failure-mode taxonomy

Walk this list against the target — most categories won't apply, but checking each forces you
past the obvious:

- **Boundaries** — empty, null/undefined, zero, single element, max, overflow/underflow.
- **Malformed & hostile input** — wrong types, garbage, oversized, deeply nested, duplicate keys.
- **Off-by-one** — ranges, slices, indices, loop bounds, inclusive/exclusive.
- **Numeric precision** — integer overflow, float rounding, negative numbers, NaN/Infinity, division.
- **Concurrency, ordering & races** — out-of-order events, simultaneous writes, stale reads.
- **Idempotency & retries** — calling twice, replaying, double-submit, retry after partial success.
- **Partial failure & rollback** — step 3 of 5 fails; is state consistent? Does cleanup run?
- **Error-path & exception handling** — does the error path actually work, or just exist?
- **State assumptions** — uninitialized, stale, or mutated-elsewhere state; order of operations.
- **Resource exhaustion** — huge input, memory, timeouts, connection/file-handle limits.
- **Encoding / unicode / locale** — non-ASCII, emoji, normalization, case-folding, RTL.
- **Time, timezones & DST** — boundaries, leap years/seconds, DST transitions, clock skew, ordering.
- **Security-adjacent** (where relevant) — injection, path traversal, auth/permission edges.

## Step 4 — Test one hypothesis at a time

Work vertically, like `tdd`: write ONE adversarial test encoding ONE hypothesis, run it,
observe the result, then move to the next. Do not bulk-write speculative tests — what you
learn from one result reshapes the next hypothesis. Check off the scratch file as you go.

## Step 5 — Triage each result (REPORT, DON'T FIX)

- **Test passes** → the code already handles this case. Mostly low value. Keep the test only
  if it documents a genuinely non-obvious guarantee; otherwise discard it to avoid noise.
- **Test fails** → this is a finding. Classify it:
  - **Likely code bug** — the code does the wrong thing.
  - **Test expectation was wrong** — you misjudged the correct behavior. Fix the test's
    expectation and say so explicitly.
- **Hard rules on a failing test:**
  - Do **NOT** modify the feature code to make it pass.
  - Do **NOT** weaken, skip, or delete the test to turn it green — that is the exact
    anti-goal of this skill.
  - Leave genuine bug-revealing tests **red** as findings.
- Surface every real finding to the user and let them make the bug-vs-test call.

## Step 6 — Summarize and clean up

Report a table of what you found:

| Hypothesis | Test result | Verdict |
|---|---|---|
| … | pass / fail | bug / handled / uncertain |

List the test files you added. Then **ask the user whether to delete the scratch
hypothesis file** — do not delete it without asking.

## Checklist

```
[ ] No happy-path or coverage-padding tests
[ ] Every test maps to a recorded hypothesis
[ ] Tests assert behavior via the public interface
[ ] Failing bug-revealing tests left RED; no feature code touched
[ ] Findings reported with bug-vs-test classification
[ ] Asked before deleting the scratch file
```
