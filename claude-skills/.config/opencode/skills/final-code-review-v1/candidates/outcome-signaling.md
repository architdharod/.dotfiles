---
name: outcome-signaling
family: Correctness
tags: [any]
evidence: 9
---
# Outcome signaling

## Index line
Partial failure reported as success, distinct outcomes merged into one signal, recovery paths that leave no trace.

## What to look for
- A response, return value, or status marked success while the payload lists failed items. Succeeded and failed belong as separate top-level fields the caller must read.
- A success callback or success toast that fires on the transport status alone, without reading whether the body reports failures.
- A client or handler that maps every non-success response to one generic error, so callers cannot tell a permanent rejection from a transient fault. Retry logic then loops on errors that will never succeed.
- An error handler that shows every error the same way, when a sibling flow routes a known recoverable case to a milder message.
- Cancellation or a deliberate early stop reported through the crash channel: a non-zero exit, an error log line, an alert.
- Run-level cancellation propagated into in-flight items as per-item failures with no distinct reason.
- A rollback or compensating action whose own failure is caught and dropped. The system is now in a state nobody knows about.
- An empty catch, or one that only returns a default, on the path that ends a task or job. The reason it died is gone.
- A fallback, retry, or rollback that runs with no log or report, so nobody learns it happened or how often.
- Exit codes, job statuses, or summary counts that do not distinguish all done, some failed, stopped early, and crashed.

## Why it matters
- Callers act on the signal, not the payload. Success over failed items means no retry, and users believe the work is done.
- Merged outcomes break retry policy both ways: permanent errors retry forever and recoverable ones raise alarms.
- Silent recovery hides frequency. A fallback that fires on every request looks like one that never fires.
- Alerts from non-failures teach operators to ignore the channel, so the real failure goes unseen.

## What not to flag
- A catch that logs the reason and context, then returns a default on purpose, when that fallback is the intended behaviour.
- An operation that is truly all-or-nothing, where one status is honest because no partial state exists.
- A UI that collapses several server faults into one message when the user cannot act differently on any of them.
- A retry wrapper that classifies errors before it retries; the classification is the fix, not the concern.
- How an error is reported to the tracker (duplicates, tags, missing ids). That is error-reporting-hygiene.
- Which code or message text one known condition gets. That is error-messages-and-codes.
- Whether the other items in a batch keep running after one fails. That is batch-failure-isolation.

## Severity
- must fix: success signalled over failed items; permanent errors reported as retryable so a caller loops; a failed rollback or compensating step swallowed.
- should fix: cancellation or early stop reported as a crash; recoverable conditions shown as hard failures; recovery branches with no trace.
- nit: summary lines or counts that could separate outcomes more clearly when the caller already gets the right signal elsewhere.

## Remedies
- return succeeded and failed as separate top-level fields
- classify errors before mapping them to a status, toast, or retry decision
- add a distinct outcome for cancellation and early stop
- log or report inside every catch and fallback, with the reason
- surface compensating-action failures instead of dropping them

## Related
- error-messages-and-codes: one known condition gets the wrong code or text.
- error-reporting-hygiene: how the report is made once the outcome is known.
- batch-failure-isolation: whether independent items keep running after one fails.
- external-writes-and-retries: retry safety of the write itself.
- state-transition-integrity: persisted status that claims work ran when it did not.
- ui-state-fidelity: labels and states on screen that do not follow the data; the toast for an outcome is here.
- absence-conflation: one value standing for several kinds of missing data.

## Sources
- review threads: 9 accepted change requests from real code reviews