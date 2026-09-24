---
name: error-reporting-hygiene
family: Correctness
tags: [api, web]
evidence: 4 accepted ePort threads
---
# Error reports that fire twice or say too little

## Index line
Error reports that fire twice, lack the ids needed to act, or attach context in the wrong slot.

## What to look for
- A catch block that sends the error to the tracker and then rethrows it. Trace upward. If a handler, middleware, or the framework reports uncaught errors, this error reports twice.
- A capture call inside a helper that is called from code with its own capture, or under a global handler.
- Report metadata that holds a sample, a count, or the first few ids instead of every id that failed. The reader of the report must be able to find each affected record.
- A report on a child item that omits the parent, batch, or request id.
- Values a reader would filter or search by, attached as breadcrumbs or folded into the message text. Tags are for filtering, context is for structured detail, breadcrumbs are for the trail of events before the error.
- Variable data concatenated into the message, so every occurrence has a different message and reports never group.
- A report fired inside a loop once per item, where one grouped report with all ids is what someone would act on.
- A rethrow that wraps the original error without keeping it as the cause, so the report loses the original stack.

## Why it matters
- Double reports inflate counts, split one incident across two issues, and alert people twice.
- A report without the affected ids cannot be acted on. Someone must reproduce the failure to learn what failed.
- Metadata in the wrong slot cannot be filtered or searched, so patterns across reports stay hidden.
- Reports that do not group bury real regressions in noise.

## What not to flag
- Capture and rethrow when no handler above reports. Trace the call path before flagging.
- Capture without rethrow when the code recovers and the report is the only trace. That is correct.
- Breadcrumbs used for the event trail that leads up to the error.
- A stable message with the variable parts in tags or context.
- Which error code or message the client sees. That is error-messages-and-codes.
- Whether a partial failure is reported at all. That is outcome-signaling.
- Sampling or truncation the tracker itself applies, or the repo's rule files require for volume reasons.
- Ids or fields that are sensitive and must not leave the system. Check the repo's rules on personal data before asking for more detail in a report.

## Severity
- must fix: capture plus rethrow under a handler that reports, so every error counts twice.
- should fix: reports missing the ids or parent ids needed to act; searchable context placed in breadcrumbs or in the message text.
- nit: tag naming, grouping, and level choice.

## Remedies
- capture once at the top handler, or rethrow without capturing
- capture and recover, without rethrow
- move ids into tags and context; keep the message stable
- report the whole batch in one event with all ids
- keep the original error as the cause when wrapping

## Related
- outcome-signaling: whether an outcome is reported at all, and what the user sees. This candidate is how the report is built.
- error-messages-and-codes: the code and message a client receives.
- exception-aggregation: where in the call stack each error class is handled. This candidate is the reporting call, not the handling.
- batch-failure-isolation: whether one failing item aborts the batch. This candidate is whether the report names every failing item.
- security-basics: personal data in logs and reports.

## Sources
- ePort: !71 !85
- ePort threads only; no book or skill source
