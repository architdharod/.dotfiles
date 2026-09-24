---
name: batch-failure-isolation
family: Correctness
tags: [api, web]
evidence: 5 accepted ePort threads
---
# Batch failure isolation

## Index line
One failing item aborts, discards, or starves a whole batch of independent items.

## What to look for
- A loop or a parallel map over independent items with no per-item error boundary. One throw ends the batch.
- A parse or validation step that rejects the whole payload when one element is malformed, although the payload reports errors per element and the rest is usable.
- A batch resolver that stops at the first failure and never resolves the remaining items, although each item's outcome is reported separately downstream.
- Work done per item that sits outside the per-item try block. A lookup, config read, or setup for one item can then abort the whole run.
- A queue or scheduler that advances its cursor only on success, so a permanently failing item stays at the head and starves everything behind it.
- Recovery, lease release, or cleanup for the whole run that never happens because one item's failure exits early.
- A result collector that returns nothing when any item failed, instead of the successes plus a list of failures.

## Why it matters
- One bad record makes a whole feature, page, or job unavailable, and nobody can tell which record it was.
- Head-of-line blocking turns one poisoned item into a permanent outage for everything queued behind it.
- Early exits skip lease release, cleanup, and progress marks for items that did nothing wrong.

## What not to flag
- Items that depend on each other, where a later item needs an earlier one's result. Sequential abort is correct there.
- A write set the domain requires to succeed or fail as one unit, done inside one transaction on purpose.
- A batch-level precondition checked once before any item runs. That is not a per-item failure.
- A failure that would hit every item the same way, when the run is retried later and the early exit is deliberate.
- Per-item isolation that exists in a helper outside the diff.
- Small fixed batches inside one request where the caller expects all-or-nothing and the contract says so.

## Severity
- must fix: one item can block or abort a recurring job, a queue, or a whole page for every user.
- should fix: a batch returns nothing on partial failure, or per-item work sits outside the per-item boundary.
- nit: isolation exists but the failure detail per item is thin.

## Remedies
- wrap each item in its own error boundary
- parse or resolve per element and collect failures
- advance the cursor on failure too, or park the failing item
- move per-item setup inside the per-item boundary
- return successes plus failures

## Related
- outcome-signaling: how a partial result is reported to the user or the log goes there. Whether siblings survive one failure is here.
- state-transition-integrity: whether one item's own state change is atomic and complete goes there.
- external-writes-and-retries: the retry policy for one item goes there. A retried item blocking the rest is here.
- validation-boundaries: how strict the parse is goes there. One element's parse failure discarding the rest is here.
- exception-aggregation: where an error class is handled goes there. The scope of one failure's effect is here.
- performance: independent work run one after another for speed reasons goes there.

## Sources
- ePort: !161 !168 !271 !283
- other: none
