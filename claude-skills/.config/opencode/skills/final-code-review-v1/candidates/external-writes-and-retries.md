---
name: external-writes-and-retries
family: Correctness
tags: [api, web, db]
evidence: 7 accepted ePort threads
---
# External writes, retries, and idempotency

## Index line
Non-idempotent external writes a client can retry, dedup that misses a source, full updates where a partial update exists.

## What to look for
- A handler calls an external system (a third-party API, a file store, a mail or payment provider, an ingestion pipeline), then persists locally. A failure in the local step returns a generic error, so the client retries and the external write runs again.
- A multi-phase flow where phase one commits and a later phase fails. The response gives no way to resume, and a retry hits a conflict on phase one, so the user is stuck.
- Repeated requests for one key create several active records. No idempotency key, no unique constraint, no claim step, no already-exists path.
- Recovery after a partial failure is deferred to a follow-up. No compensating action, no idempotent retry path, no alert.
- Retry logic wrapped around a non-idempotent call without a key.
- A client reads the full resource, changes one field, and writes the whole thing back, or polls with read-back retries, where the API offers a partial update that does it in one idempotent request.
- An update sends every field including unchanged ones, so server-side checks run on fields the user did not touch and can reject the request for unrelated reasons.
- Dedup before an external write or an ingestion checks one source of already-done while other sources exist: a local table, the external system's own state, an earlier batch, a different status field.
- Sibling methods in the same module already use the partial update or the idempotent path, and the new one diverges.

## Why it matters
- A retried non-idempotent write duplicates records, sends messages twice, or charges twice.
- A stuck flow after a partial commit needs manual repair and hides how often it happens.
- Full-object writes race with concurrent editors and fail on fields the user never saw.
- Dedup that checks one source lets already-processed items through again.

## What not to flag
- Reads and idempotent writes retried freely, including full replacement guarded by a version check.
- Writes inside one local transaction that roll back together: that is state-transition-integrity.
- Full-object updates where the API offers no partial update and the object is small.
- A full update chosen because the partial form cannot express clearing a field, when a comment says so.
- External calls that are idempotent by a key the code sends.
- Compensation or alerting that lives in a job outside the diff. Check before flagging.
- The wrong HTTP status or error code by itself: that is error-messages-and-codes.

## Severity
- must fix: a retry of a non-idempotent external write is reachable from the client's normal error handling, or nothing prevents duplicates for one key.
- should fix: read-modify-write where a partial update exists, an update that sends untouched fields and can be rejected for them, dedup that misses a source, recovery deferred with no plan.
- nit: divergence from sibling methods with no correctness risk.

## Remedies
- return a distinct status or code once the external write has succeeded
- add an idempotency key, a claim step, or a unique constraint
- use the partial update and send only changed fields
- check every source of already-done before writing
- add compensation or alerting for the partial-failure path

## Related
- state-transition-integrity: local state machines, preconditions, and atomic claims. This candidate covers the seam between an external write and the local persist, and what the client does on failure.
- guards-from-wrong-or-partial-sources: guards that read a proxy fact. Dedup before an external write belongs here.
- batch-failure-isolation: one failing item aborting a batch.
- outcome-signaling: reporting partial failure to the user.
- error-messages-and-codes: which status or code is sent.

## Sources
- ePort: !46 !71 !85 !129 !259
- other: none
